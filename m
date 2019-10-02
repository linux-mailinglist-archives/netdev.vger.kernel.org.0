Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C26F1C94F6
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbfJBXhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:16472 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729093AbfJBXhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862611"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:22 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Paolo Abeni <pabeni@redhat.com>, cpaasch@apple.com, fw@strlen.de,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 22/45] mptcp: use sk_page_frag() in sendmsg
Date:   Wed,  2 Oct 2019 16:36:32 -0700
Message-Id: <20191002233655.24323-23-mathew.j.martineau@linux.intel.com>
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

This clean-up a bit the send path, and allows better performances.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index fdcfffce0ec9..da983ea4fb5e 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -65,10 +65,11 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct socket *ssock;
 	struct sock *ssk;
 	struct mptcp_ext *mpext = NULL;
-	struct page *page = NULL;
+	struct page_frag *pfrag;
 	struct sk_buff *skb;
 	size_t psize;
 	int poffset;
+	long timeo;
 
 	lock_sock(sk);
 	ssock = __mptcp_fallback_get_ref(msk);
@@ -97,32 +98,32 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		goto put_out;
 	}
 
-	/* Initial experiment: new page per send.  Real code will
-	 * maintain list of active pages and DSS mappings, append to the
-	 * end and honor zerocopy
+	lock_sock(ssk);
+	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
+
+	/* use the mptcp page cache so that we can easily move the data
+	 * from one substream to another, but do per subflow memory accounting
 	 */
-	page = alloc_page(GFP_KERNEL);
-	if (!page) {
-		ret = -ENOMEM;
-		goto put_out;
+	pfrag = sk_page_frag(sk);
+	while (!sk_page_frag_refill(ssk, pfrag)) {
+		ret = sk_stream_wait_memory(ssk, &timeo);
+		if (ret)
+			goto put_out;
 	}
 
 	/* Copy to page */
-	poffset = 0;
+	poffset = pfrag->offset;
 	pr_debug("left=%zu", msg_data_left(msg));
-	psize = copy_page_from_iter(page, poffset,
+	psize = copy_page_from_iter(pfrag->page, poffset,
 				    min_t(size_t, msg_data_left(msg),
-					  PAGE_SIZE),
+					  pfrag->size - poffset),
 				    &msg->msg_iter);
 	pr_debug("left=%zu", msg_data_left(msg));
-
 	if (!psize) {
 		ret = -EINVAL;
 		goto put_out;
 	}
 
-	lock_sock(ssk);
-
 	/* Mark the end of the previous write so the beginning of the
 	 * next write (with its own mptcp skb extension data) is not
 	 * collapsed.
@@ -132,8 +133,8 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		TCP_SKB_CB(skb)->eor = 1;
 
 	mss_now = tcp_send_mss(ssk, &size_goal, msg->msg_flags);
-
-	ret = do_tcp_sendpages(ssk, page, poffset, min_t(int, size_goal, psize),
+	psize = min_t(int, size_goal, psize);
+	ret = do_tcp_sendpages(ssk, pfrag->page, poffset, psize,
 			       msg->msg_flags | MSG_SENDPAGE_NOTLAST);
 	if (ret <= 0)
 		goto put_out;
@@ -159,14 +160,13 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			 mpext->checksum, mpext->dsn64);
 	} /* TODO: else fallback */
 
+	pfrag->offset += ret;
 	msk->write_seq += ret;
 	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
 
 	tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle, size_goal);
 
 put_out:
-	if (page)
-		put_page(page);
 	release_sock(sk);
 	sock_put(ssk);
 	return ret;
-- 
2.23.0

