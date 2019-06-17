Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C458249586
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbfFQW7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:10994 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727762AbfFQW6z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:52 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:51 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, cpaasch@apple.com, fw@strlen.de,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 25/33] mptcp: use sk_page_frag() in sendmsg
Date:   Mon, 17 Jun 2019 15:58:00 -0700
Message-Id: <20190617225808.665-26-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
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
 net/mptcp/protocol.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0db4099d9c13..98257a70ac2b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -52,10 +52,11 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	int mss_now, size_goal, poffset, ret;
 	struct mptcp_ext *mpext = NULL;
-	struct page *page = NULL;
+	struct page_frag *pfrag;
 	struct sk_buff *skb;
 	struct sock *ssk;
 	size_t psize;
+	long timeo;
 
 	pr_debug("msk=%p", msk);
 	if (msk->subflow) {
@@ -80,33 +81,33 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		goto put_out;
 	}
 
-	/* Initial experiment: new page per send.  Real code will
-	 * maintain list of active pages and DSS mappings, append to the
-	 * end and honor zerocopy
+	lock_sock(sk);
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
+			goto release_out;
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
-		goto put_out;
+		goto release_out;
 	}
 
-	lock_sock(sk);
-	lock_sock(ssk);
-
 	/* Mark the end of the previous write so the beginning of the
 	 * next write (with its own mptcp skb extension data) is not
 	 * collapsed.
@@ -116,8 +117,8 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		TCP_SKB_CB(skb)->eor = 1;
 
 	mss_now = tcp_send_mss(ssk, &size_goal, msg->msg_flags);
-
-	ret = do_tcp_sendpages(ssk, page, poffset, min_t(int, size_goal, psize),
+	psize = min_t(int, size_goal, psize);
+	ret = do_tcp_sendpages(ssk, pfrag->page, poffset, psize,
 			       msg->msg_flags | MSG_SENDPAGE_NOTLAST);
 	if (ret <= 0)
 		goto release_out;
@@ -143,6 +144,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			 mpext->checksum, mpext->dsn64);
 	} /* TODO: else fallback */
 
+	pfrag->offset += ret;
 	msk->write_seq += ret;
 	subflow_ctx(ssk)->rel_write_seq += ret;
 
@@ -153,9 +155,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	release_sock(sk);
 
 put_out:
-	if (page)
-		put_page(page);
-
 	sock_put(ssk);
 	return ret;
 }
-- 
2.22.0

