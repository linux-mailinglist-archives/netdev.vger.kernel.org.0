Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDC4190050
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgCWV3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:29:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:45008 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgCWV3k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 17:29:40 -0400
IronPort-SDR: v+6JoiKKfI8jWiqK4/nJ/zdRCYku5adKZ7SB9+wi7B+RjhIjkap7/9GtQiPjwCwlgcQjo0j+uH
 XlPNjRQLj3sw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 14:29:38 -0700
IronPort-SDR: DfwiWTrZRbW/KEEeRbjdGlMBfvKOCl+YnWym+3NAO+iemZK2IX6atAUz5PPm4CpAlvrByNdQf6
 40B8sq3ZzKgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="445960420"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.254.100.76])
  by fmsmga005.fm.intel.com with ESMTP; 23 Mar 2020 14:29:38 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, eric.dumazet@gmail.com,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 09/17] mptcp: implement memory accounting for mptcp rtx queue
Date:   Mon, 23 Mar 2020 14:26:34 -0700
Message-Id: <20200323212642.34104-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
References: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
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

Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 48eb054ae19e..c578f1deed0b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -37,6 +37,8 @@ struct mptcp_skb_cb {
 
 #define MPTCP_SKB_CB(__skb)	((struct mptcp_skb_cb *)&((__skb)->cb[0]))
 
+static struct percpu_counter mptcp_sockets_allocated;
+
 /* If msk has an initial subflow socket, and the MP_CAPABLE handshake has not
  * completed yet or has failed, return the subflow socket.
  * Otherwise return NULL.
@@ -333,9 +335,17 @@ static inline bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
 		df->data_seq + df->data_len == msk->write_seq;
 }
 
-static void dfrag_clear(struct mptcp_data_frag *dfrag)
+static void dfrag_uncharge(struct sock *sk, int len)
+{
+	sk_mem_uncharge(sk, len);
+}
+
+static void dfrag_clear(struct sock *sk, struct mptcp_data_frag *dfrag)
 {
+	int len = dfrag->data_len + dfrag->overhead;
+
 	list_del(&dfrag->list);
+	dfrag_uncharge(sk, len);
 	put_page(dfrag->page);
 }
 
@@ -344,12 +354,18 @@ static void mptcp_clean_una(struct sock *sk)
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_data_frag *dtmp, *dfrag;
 	u64 snd_una = atomic64_read(&msk->snd_una);
+	bool cleaned = false;
 
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list) {
 		if (after64(dfrag->data_seq + dfrag->data_len, snd_una))
 			break;
 
-		dfrag_clear(dfrag);
+		dfrag_clear(sk, dfrag);
+		cleaned = true;
+	}
+
+	if (cleaned) {
+		sk_mem_reclaim_partial(sk);
 	}
 }
 
@@ -461,6 +477,9 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	if (!psize)
 		return -EINVAL;
 
+	if (!sk_wmem_schedule(sk, psize + dfrag->overhead))
+		return -ENOMEM;
+
 	/* tell the TCP stack to delay the push so that we can safely
 	 * access the skb after the sendpages call
 	 */
@@ -482,6 +501,11 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		list_add_tail(&dfrag->list, &msk->rtx_queue);
 	}
 
+	/* charge data on mptcp rtx queue to the master socket
+	 * Note: we charge such data both to sk and ssk
+	 */
+	sk->sk_forward_alloc -= frag_truesize;
+
 	/* if the tail skb extension is still the cached one, collapsing
 	 * really happened. Note: we can't check for 'same skb' as the sk_buff
 	 * hdr on tail can be transmitted, freed and re-allocated by the
@@ -933,6 +957,8 @@ static int mptcp_init_sock(struct sock *sk)
 	if (ret)
 		return ret;
 
+	sk_sockets_allocated_inc(sk);
+
 	if (!mptcp_is_enabled(sock_net(sk)))
 		return -ENOPROTOOPT;
 
@@ -947,7 +973,7 @@ static void __mptcp_clear_xmit(struct sock *sk)
 	sk_stop_timer(sk, &msk->sk.icsk_retransmit_timer);
 
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list)
-		dfrag_clear(dfrag);
+		dfrag_clear(sk, dfrag);
 }
 
 static void mptcp_cancel_work(struct sock *sk)
@@ -1182,6 +1208,8 @@ static void mptcp_destroy(struct sock *sk)
 
 	if (msk->cached_ext)
 		__skb_ext_put(msk->cached_ext);
+
+	sk_sockets_allocated_dec(sk);
 }
 
 static int mptcp_setsockopt(struct sock *sk, int level, int optname,
@@ -1395,7 +1423,12 @@ static struct proto mptcp_prot = {
 	.hash		= inet_hash,
 	.unhash		= inet_unhash,
 	.get_port	= mptcp_get_port,
+	.sockets_allocated	= &mptcp_sockets_allocated,
+	.memory_allocated	= &tcp_memory_allocated,
+	.memory_pressure	= &tcp_memory_pressure,
 	.stream_memory_free	= mptcp_memory_free,
+	.sysctl_wmem_offset	= offsetof(struct net, ipv4.sysctl_tcp_wmem),
+	.sysctl_mem	= sysctl_tcp_mem,
 	.obj_size	= sizeof(struct mptcp_sock),
 	.no_autobind	= true,
 };
@@ -1684,6 +1717,9 @@ void mptcp_proto_init(void)
 {
 	mptcp_prot.h.hashinfo = tcp_prot.h.hashinfo;
 
+	if (percpu_counter_init(&mptcp_sockets_allocated, 0, GFP_KERNEL))
+		panic("Failed to allocate MPTCP pcpu counter\n");
+
 	mptcp_subflow_init();
 	mptcp_pm_init();
 
-- 
2.26.0

