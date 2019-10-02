Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED6D2C9504
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfJBXiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:38:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:16479 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729203AbfJBXhm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862635"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:24 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Paolo Abeni <pabeni@redhat.com>, cpaasch@apple.com, fw@strlen.de,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 38/45] mptcp: implement memory accounting for mptcp rtx queue
Date:   Wed,  2 Oct 2019 16:36:48 -0700
Message-Id: <20191002233655.24323-39-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Charge the data on the rtx queue to the master MPTCP socket, too.
Such memory in uncharged when the data is acked/dequeued.

Also account mptcp sockets inuse via a protocol specific pcpu
counter.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1f7a090ed25c..8319ee807481 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -19,6 +19,8 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
+static struct percpu_counter mptcp_sockets_allocated;
+
 static void mptcp_set_timeout(const struct sock *sk, const struct sock *ssk)
 {
 	unsigned long tout = ssk && inet_csk(ssk)->icsk_pending ?
@@ -112,9 +114,10 @@ static inline bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
 		df->data_seq + df->data_len == msk->write_seq;
 }
 
-static void dfrag_clear(struct mptcp_data_frag *dfrag)
+static void dfrag_clear(struct sock *sk, struct mptcp_data_frag *dfrag)
 {
 	list_del(&dfrag->list);
+	sk_mem_uncharge(sk, dfrag->data_len + dfrag->overhead);
 	put_page(dfrag->page);
 }
 
@@ -128,8 +131,9 @@ static void mptcp_clean_una(struct sock *sk)
 		if (after64(dfrag->data_seq + dfrag->data_len, snd_una))
 			break;
 
-		dfrag_clear(dfrag);
+		dfrag_clear(sk, dfrag);
 	}
+	sk_mem_reclaim_partial(sk);
 }
 
 /* ensure we get enough memory for the frag hdr, beyond some minimal amount of
@@ -236,6 +240,9 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	if (!psize)
 		return -EINVAL;
 
+	if (!sk_wmem_schedule(sk, psize + dfrag->overhead))
+		return -ENOMEM;
+
 	/* tell the TCP stack to delay the push so that we can safely
 	 * access the skb after the sendpages call
 	 */
@@ -257,6 +264,11 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		list_add_tail(&dfrag->list, &msk->rtx_queue);
 	}
 
+	/* charge data on mptcp rtx queue to the master socket
+	 * Note: we charge such data both to sk and ssk
+	 */
+	sk->sk_forward_alloc -= frag_truesize;
+
 	collapsed = skb == tcp_write_queue_tail(ssk);
 	if (collapsed) {
 		WARN_ON_ONCE(!can_collapse);
@@ -769,6 +781,8 @@ static int mptcp_init_sock(struct sock *sk)
 	if (ret)
 		return ret;
 
+	sk_sockets_allocated_inc(sk);
+
 	if (!mptcp_is_enabled(sock_net(sk)))
 		return -ENOPROTOOPT;
 
@@ -783,7 +797,7 @@ static void __mptcp_clear_xmit(struct sock *sk)
 	sk_stop_timer(sk, &msk->sk.icsk_retransmit_timer);
 
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list)
-		dfrag_clear(dfrag);
+		dfrag_clear(sk, dfrag);
 }
 
 static void mptcp_close(struct sock *sk, long timeout)
@@ -902,6 +916,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 
 static void mptcp_destroy(struct sock *sk)
 {
+	sk_sockets_allocated_dec(sk);
 }
 
 static int mptcp_setsockopt(struct sock *sk, int level, int optname,
@@ -1088,6 +1103,11 @@ static struct proto mptcp_prot = {
 	.hash		= inet_hash,
 	.unhash		= inet_unhash,
 	.get_port	= mptcp_get_port,
+	.sockets_allocated	= &mptcp_sockets_allocated,
+	.memory_allocated	= &tcp_memory_allocated,
+	.memory_pressure	= &tcp_memory_pressure,
+	.sysctl_wmem_offset	= offsetof(struct net, ipv4.sysctl_tcp_wmem),
+	.sysctl_mem	= sysctl_tcp_mem,
 	.obj_size	= sizeof(struct mptcp_sock),
 	.no_autobind	= 1,
 };
@@ -1324,6 +1344,9 @@ void mptcp_proto_init(void)
 	mptcp_stream_ops.listen = mptcp_listen;
 	mptcp_stream_ops.shutdown = mptcp_shutdown;
 
+	if (percpu_counter_init(&mptcp_sockets_allocated, 0, GFP_KERNEL))
+		panic("Failed to allocate MPTCP pcpu counter\n");
+
 	mptcp_subflow_init();
 	pm_init();
 
-- 
2.23.0

