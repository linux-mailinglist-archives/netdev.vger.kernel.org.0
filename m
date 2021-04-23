Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A5C36990F
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243599AbhDWSR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:17:57 -0400
Received: from mga03.intel.com ([134.134.136.65]:40509 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243410AbhDWSRw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 14:17:52 -0400
IronPort-SDR: /ZZe9Ee9Sg2lbGiMMnVkoEG2MyV3RaIp5s4nWKQUwJjrmYp825T8JRcBK2ud6qP4vDNripcPkj
 bZLC/dhX2cZA==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="196172522"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="196172522"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 11:17:14 -0700
IronPort-SDR: xLjRQScNjimN7pzLZOXzj0sX96EGISjRF8C2TkBg5hF8XzTJf7SljB/piiPa68POfHnTUKYnYd
 OHwyeylDBAXA==
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="402264971"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.72.13])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 11:17:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Yonglong Li <liyonglong@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/5] mptcp: add MSG_PEEK support
Date:   Fri, 23 Apr 2021 11:17:08 -0700
Message-Id: <20210423181709.330233-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423181709.330233-1-mathew.j.martineau@linux.intel.com>
References: <20210423181709.330233-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Li <liyonglong@chinatelecom.cn>

This patch adds support for MSG_PEEK flag. Packets are not removed
from the receive_queue if MSG_PEEK set in recv() system call.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a996dd5bb0c2..8bf21996734d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1745,10 +1745,10 @@ static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
 				struct msghdr *msg,
 				size_t len, int flags)
 {
-	struct sk_buff *skb;
+	struct sk_buff *skb, *tmp;
 	int copied = 0;
 
-	while ((skb = skb_peek(&msk->receive_queue)) != NULL) {
+	skb_queue_walk_safe(&msk->receive_queue, skb, tmp) {
 		u32 offset = MPTCP_SKB_CB(skb)->offset;
 		u32 data_len = skb->len - offset;
 		u32 count = min_t(size_t, len - copied, data_len);
@@ -1766,15 +1766,18 @@ static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
 		copied += count;
 
 		if (count < data_len) {
-			MPTCP_SKB_CB(skb)->offset += count;
+			if (!(flags & MSG_PEEK))
+				MPTCP_SKB_CB(skb)->offset += count;
 			break;
 		}
 
-		/* we will bulk release the skb memory later */
-		skb->destructor = NULL;
-		msk->rmem_released += skb->truesize;
-		__skb_unlink(skb, &msk->receive_queue);
-		__kfree_skb(skb);
+		if (!(flags & MSG_PEEK)) {
+			/* we will bulk release the skb memory later */
+			skb->destructor = NULL;
+			msk->rmem_released += skb->truesize;
+			__skb_unlink(skb, &msk->receive_queue);
+			__kfree_skb(skb);
+		}
 
 		if (copied >= len)
 			break;
@@ -2053,7 +2056,8 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	pr_debug("msk=%p data_ready=%d rx queue empty=%d copied=%d",
 		 msk, test_bit(MPTCP_DATA_READY, &msk->flags),
 		 skb_queue_empty_lockless(&sk->sk_receive_queue), copied);
-	mptcp_rcv_space_adjust(msk, copied);
+	if (!(flags & MSG_PEEK))
+		mptcp_rcv_space_adjust(msk, copied);
 
 	release_sock(sk);
 	return copied;
-- 
2.31.1

