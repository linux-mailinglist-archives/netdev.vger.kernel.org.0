Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3772513F868
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732408AbgAPQyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:54:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732370AbgAPQyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34BEC21D56;
        Thu, 16 Jan 2020 16:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193677;
        bh=rSBlNIS5WiVptM6PLSAkdb7qjuwwbMQhxuQYndwIlwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQl4Np8VGd6w4p1RB/3/HaJNYvBtHJu+lgtC71iSp8qbWgkgsBDfo4qauIGzeq2EV
         fYvtTgTydcJZ2sgQwGXMwaLhzaaduP+ub1ox8A2uitahk7F2KasyPSr4FsjWA84Kpg
         gqmlMoDbdZobR1AqyDADX5G3vknqxP7UBrJPncW4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuong Lien <tuong.t.lien@dektech.com.au>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 201/205] tipc: fix potential hanging after b/rcast changing
Date:   Thu, 16 Jan 2020 11:42:56 -0500
Message-Id: <20200116164300.6705-201-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>

[ Upstream commit dca4a17d24ee9d878836ce5eb8dc25be1ffa5729 ]

In commit c55c8edafa91 ("tipc: smooth change between replicast and
broadcast"), we allow instant switching between replicast and broadcast
by sending a dummy 'SYN' packet on the last used link to synchronize
packets on the links. The 'SYN' message is an object of link congestion
also, so if that happens, a 'SOCK_WAKEUP' will be scheduled to be sent
back to the socket...
However, in that commit, we simply use the same socket 'cong_link_cnt'
counter for both the 'SYN' & normal payload message sending. Therefore,
if both the replicast & broadcast links are congested, the counter will
be not updated correctly but overwritten by the latter congestion.
Later on, when the 'SOCK_WAKEUP' messages are processed, the counter is
reduced one by one and eventually overflowed. Consequently, further
activities on the socket will only wait for the false congestion signal
to disappear but never been met.

Because sending the 'SYN' message is vital for the mechanism, it should
be done anyway. This commit fixes the issue by marking the message with
an error code e.g. 'TIPC_ERR_NO_PORT', so its sending should not face a
link congestion, there is no need to touch the socket 'cong_link_cnt'
either. In addition, in the event of any error (e.g. -ENOBUFS), we will
purge the entire payload message queue and make a return immediately.

Fixes: c55c8edafa91 ("tipc: smooth change between replicast and broadcast")
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bcast.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index 6ef1abdd525f..885ecf6ea65a 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -305,17 +305,17 @@ static int tipc_rcast_xmit(struct net *net, struct sk_buff_head *pkts,
  * @skb: socket buffer to copy
  * @method: send method to be used
  * @dests: destination nodes for message.
- * @cong_link_cnt: returns number of encountered congested destination links
  * Returns 0 if success, otherwise errno
  */
 static int tipc_mcast_send_sync(struct net *net, struct sk_buff *skb,
 				struct tipc_mc_method *method,
-				struct tipc_nlist *dests,
-				u16 *cong_link_cnt)
+				struct tipc_nlist *dests)
 {
 	struct tipc_msg *hdr, *_hdr;
 	struct sk_buff_head tmpq;
 	struct sk_buff *_skb;
+	u16 cong_link_cnt;
+	int rc = 0;
 
 	/* Is a cluster supporting with new capabilities ? */
 	if (!(tipc_net(net)->capabilities & TIPC_MCAST_RBCTL))
@@ -343,18 +343,19 @@ static int tipc_mcast_send_sync(struct net *net, struct sk_buff *skb,
 	_hdr = buf_msg(_skb);
 	msg_set_size(_hdr, MCAST_H_SIZE);
 	msg_set_is_rcast(_hdr, !msg_is_rcast(hdr));
+	msg_set_errcode(_hdr, TIPC_ERR_NO_PORT);
 
 	__skb_queue_head_init(&tmpq);
 	__skb_queue_tail(&tmpq, _skb);
 	if (method->rcast)
-		tipc_bcast_xmit(net, &tmpq, cong_link_cnt);
+		rc = tipc_bcast_xmit(net, &tmpq, &cong_link_cnt);
 	else
-		tipc_rcast_xmit(net, &tmpq, dests, cong_link_cnt);
+		rc = tipc_rcast_xmit(net, &tmpq, dests, &cong_link_cnt);
 
 	/* This queue should normally be empty by now */
 	__skb_queue_purge(&tmpq);
 
-	return 0;
+	return rc;
 }
 
 /* tipc_mcast_xmit - deliver message to indicated destination nodes
@@ -396,9 +397,14 @@ int tipc_mcast_xmit(struct net *net, struct sk_buff_head *pkts,
 		msg_set_is_rcast(hdr, method->rcast);
 
 		/* Switch method ? */
-		if (rcast != method->rcast)
-			tipc_mcast_send_sync(net, skb, method,
-					     dests, cong_link_cnt);
+		if (rcast != method->rcast) {
+			rc = tipc_mcast_send_sync(net, skb, method, dests);
+			if (unlikely(rc)) {
+				pr_err("Unable to send SYN: method %d, rc %d\n",
+				       rcast, rc);
+				goto exit;
+			}
+		}
 
 		if (method->rcast)
 			rc = tipc_rcast_xmit(net, pkts, dests, cong_link_cnt);
-- 
2.20.1

