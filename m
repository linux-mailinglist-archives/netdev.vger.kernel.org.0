Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4121E173B
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 23:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbgEYVlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 17:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgEYVlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 17:41:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4787EC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 14:41:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jdKqX-0000V1-SU; Mon, 25 May 2020 23:41:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mathew.j.martineau@linux.intel.com, pabeni@redhat.com,
        matthieu.baerts@tessares.net, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] mptcp: attempt coalescing when moving skbs to mptcp rx queue
Date:   Mon, 25 May 2020 23:41:13 +0200
Message-Id: <20200525214113.3131-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can try to coalesce skbs we take from the subflows rx queue with the
tail of the mptcp rx queue.

If successful, the skb head can be discarded early.

We can also free the skb extensions, we do not access them after this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d868b3d921fd..e07a5896fea4 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -144,12 +144,29 @@ static void __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 			     unsigned int offset, size_t copy_len)
 {
 	struct sock *sk = (struct sock *)msk;
+	struct sk_buff *tail;
 
 	__skb_unlink(skb, &ssk->sk_receive_queue);
-	skb_set_owner_r(skb, sk);
-	__skb_queue_tail(&sk->sk_receive_queue, skb);
 
+	skb_ext_reset(skb);
+	skb_orphan(skb);
 	msk->ack_seq += copy_len;
+
+	tail = skb_peek_tail(&sk->sk_receive_queue);
+	if (offset == 0 && tail) {
+		bool fragstolen;
+		int delta;
+
+		if (skb_try_coalesce(tail, skb, &fragstolen, &delta)) {
+			kfree_skb_partial(skb, fragstolen);
+			atomic_add(delta, &sk->sk_rmem_alloc);
+			sk_mem_charge(sk, delta);
+			return;
+		}
+	}
+
+	skb_set_owner_r(skb, sk);
+	__skb_queue_tail(&sk->sk_receive_queue, skb);
 	MPTCP_SKB_CB(skb)->offset = offset;
 }
 
-- 
2.26.2

