Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B787E464947
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344139AbhLAILQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:11:16 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:59642 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbhLAILP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:11:15 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 37AA72022C; Wed,  1 Dec 2021 16:07:51 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        jk@codeconstruct.com.au
Subject: [PATCH net] mctp: Don't let RTM_DELROUTE delete local routes
Date:   Wed,  1 Dec 2021 16:07:42 +0800
Message-Id: <20211201080742.429664-1-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to test against the existing route type, not
the rtm_type in the netlink request.

Fixes: 83f0a0b7285b ("mctp: Specify route types, require rtm_type in RTM_*ROUTE messages")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 net/mctp/route.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 46c44823edb7..cdf09c2a7007 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -952,7 +952,7 @@ static int mctp_route_add(struct mctp_dev *mdev, mctp_eid_t daddr_start,
 }
 
 static int mctp_route_remove(struct mctp_dev *mdev, mctp_eid_t daddr_start,
-			     unsigned int daddr_extent)
+			     unsigned int daddr_extent, unsigned char type)
 {
 	struct net *net = dev_net(mdev->dev);
 	struct mctp_route *rt, *tmp;
@@ -969,7 +969,8 @@ static int mctp_route_remove(struct mctp_dev *mdev, mctp_eid_t daddr_start,
 
 	list_for_each_entry_safe(rt, tmp, &net->mctp.routes, list) {
 		if (rt->dev == mdev &&
-		    rt->min == daddr_start && rt->max == daddr_end) {
+		    rt->min == daddr_start && rt->max == daddr_end &&
+		    rt->type == type) {
 			list_del_rcu(&rt->list);
 			/* TODO: immediate RTM_DELROUTE */
 			mctp_route_release(rt);
@@ -987,7 +988,7 @@ int mctp_route_add_local(struct mctp_dev *mdev, mctp_eid_t addr)
 
 int mctp_route_remove_local(struct mctp_dev *mdev, mctp_eid_t addr)
 {
-	return mctp_route_remove(mdev, addr, 0);
+	return mctp_route_remove(mdev, addr, 0, RTN_LOCAL);
 }
 
 /* removes all entries for a given device */
@@ -1195,7 +1196,7 @@ static int mctp_delroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (rtm->rtm_type != RTN_UNICAST)
 		return -EINVAL;
 
-	rc = mctp_route_remove(mdev, daddr_start, rtm->rtm_dst_len);
+	rc = mctp_route_remove(mdev, daddr_start, rtm->rtm_dst_len, RTN_UNICAST);
 	return rc;
 }
 
-- 
2.32.0

