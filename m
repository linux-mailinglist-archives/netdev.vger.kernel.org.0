Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684B33E5111
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 04:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhHJCez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 22:34:55 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:39922 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhHJCey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 22:34:54 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 6D28920135; Tue, 10 Aug 2021 10:34:31 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] mctp: Specify route types, require rtm_type in RTM_*ROUTE messages
Date:   Tue, 10 Aug 2021 10:34:22 +0800
Message-Id: <20210810023422.2229863-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds a 'type' attribute to routes, which can be parsed from
a RTM_NEWROUTE message. This will help to distinguish local vs. peer
routes in a future change.

This means userspace will need to set a correct rtm_type in RTM_NEWROUTE
and RTM_DELROUTE messages; we currently only accept RTN_UNICAST.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 include/net/mctp.h |  1 +
 net/mctp/route.c   | 27 ++++++++++++++++++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/include/net/mctp.h b/include/net/mctp.h
index 54bbe042c973..a824d47c3c6d 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -173,6 +173,7 @@ struct mctp_route {
 
 	struct mctp_dev		*dev;
 	unsigned int		mtu;
+	unsigned char		type;
 	int			(*output)(struct mctp_route *route,
 					  struct sk_buff *skb);
 
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 960c85039eae..fc77337f4870 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -710,8 +710,9 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 /* route management */
 static int mctp_route_add(struct mctp_dev *mdev, mctp_eid_t daddr_start,
 			  unsigned int daddr_extent, unsigned int mtu,
-			  bool is_local)
+			  unsigned char type)
 {
+	int (*rtfn)(struct mctp_route *rt, struct sk_buff *skb);
 	struct net *net = dev_net(mdev->dev);
 	struct mctp_route *rt, *ert;
 
@@ -721,6 +722,17 @@ static int mctp_route_add(struct mctp_dev *mdev, mctp_eid_t daddr_start,
 	if (daddr_extent > 0xff || daddr_start + daddr_extent >= 255)
 		return -EINVAL;
 
+	switch (type) {
+	case RTN_LOCAL:
+		rtfn = mctp_route_input;
+		break;
+	case RTN_UNICAST:
+		rtfn = mctp_route_output;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	rt = mctp_route_alloc();
 	if (!rt)
 		return -ENOMEM;
@@ -730,7 +742,8 @@ static int mctp_route_add(struct mctp_dev *mdev, mctp_eid_t daddr_start,
 	rt->mtu = mtu;
 	rt->dev = mdev;
 	dev_hold(rt->dev->dev);
-	rt->output = is_local ? mctp_route_input : mctp_route_output;
+	rt->type = type;
+	rt->output = rtfn;
 
 	ASSERT_RTNL();
 	/* Prevent duplicate identical routes. */
@@ -777,7 +790,7 @@ static int mctp_route_remove(struct mctp_dev *mdev, mctp_eid_t daddr_start,
 
 int mctp_route_add_local(struct mctp_dev *mdev, mctp_eid_t addr)
 {
-	return mctp_route_add(mdev, addr, 0, 0, true);
+	return mctp_route_add(mdev, addr, 0, 0, RTN_LOCAL);
 }
 
 int mctp_route_remove_local(struct mctp_dev *mdev, mctp_eid_t addr)
@@ -939,7 +952,11 @@ static int mctp_newroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 	/* TODO: parse mtu from nlparse */
 	mtu = 0;
 
-	rc = mctp_route_add(mdev, daddr_start, rtm->rtm_dst_len, mtu, false);
+	if (rtm->rtm_type != RTN_UNICAST)
+		return -EINVAL;
+
+	rc = mctp_route_add(mdev, daddr_start, rtm->rtm_dst_len, mtu,
+			    rtm->rtm_type);
 	return rc;
 }
 
@@ -988,7 +1005,7 @@ static int mctp_fill_rtinfo(struct sk_buff *skb, struct mctp_route *rt,
 	hdr->rtm_table = RT_TABLE_DEFAULT;
 	hdr->rtm_protocol = RTPROT_STATIC; /* everything is user-defined */
 	hdr->rtm_scope = RT_SCOPE_LINK; /* TODO: scope in mctp_route? */
-	hdr->rtm_type = RTN_ANYCAST; /* TODO: type from route */
+	hdr->rtm_type = rt->type;
 
 	if (nla_put_u8(skb, RTA_DST, rt->min))
 		goto cancel;
-- 
2.30.2

