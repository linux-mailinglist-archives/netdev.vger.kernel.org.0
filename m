Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B634BB0BF
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 05:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiBRE0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 23:26:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiBRE0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 23:26:22 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0EB14006
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 20:26:02 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 9C5F9202DA; Fri, 18 Feb 2022 12:25:56 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>
Subject: [PATCH net-next 1/2] mctp: replace mctp_address_ok with more fine-grained helpers
Date:   Fri, 18 Feb 2022 12:25:53 +0800
Message-Id: <20220218042554.564787-2-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218042554.564787-1-jk@codeconstruct.com.au>
References: <20220218042554.564787-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we have mctp_address_ok(), which checks if an EID is in the
"valid" range of 8-254 inclusive. However, 0 and 255 may also be valid
addresses, depending on context. 0 is the NULL EID, which may be set
when physical addressing is used. 255 is valid as a destination address
for broadcasts.

This change renames mctp_address_ok to mctp_address_unicast, and adds
similar helpers for broadcast and null EIDs, which will be used in an
upcoming commit.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 include/net/mctp.h | 12 +++++++++++-
 net/mctp/device.c  |  2 +-
 net/mctp/neigh.c   |  2 +-
 net/mctp/route.c   |  2 +-
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/net/mctp.h b/include/net/mctp.h
index e80a4baf8379..d37268fe6825 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -40,11 +40,21 @@ struct mctp_hdr {
 
 #define MCTP_INITIAL_DEFAULT_NET	1
 
-static inline bool mctp_address_ok(mctp_eid_t eid)
+static inline bool mctp_address_unicast(mctp_eid_t eid)
 {
 	return eid >= 8 && eid < 255;
 }
 
+static inline bool mctp_address_broadcast(mctp_eid_t eid)
+{
+	return eid == 255;
+}
+
+static inline bool mctp_address_null(mctp_eid_t eid)
+{
+	return eid == 0;
+}
+
 static inline bool mctp_address_matches(mctp_eid_t match, mctp_eid_t eid)
 {
 	return match == eid || match == MCTP_ADDR_ANY;
diff --git a/net/mctp/device.c b/net/mctp/device.c
index 02ddc0f1bd3e..9e097e61f23a 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -209,7 +209,7 @@ static int mctp_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!mdev)
 		return -ENODEV;
 
-	if (!mctp_address_ok(addr->s_addr))
+	if (!mctp_address_unicast(addr->s_addr))
 		return -EINVAL;
 
 	/* Prevent duplicates. Under RTNL so don't need to lock for reading */
diff --git a/net/mctp/neigh.c b/net/mctp/neigh.c
index 6ad3e33bd4d4..ffa0f9e0983f 100644
--- a/net/mctp/neigh.c
+++ b/net/mctp/neigh.c
@@ -143,7 +143,7 @@ static int mctp_rtm_newneigh(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	eid = nla_get_u8(tb[NDA_DST]);
-	if (!mctp_address_ok(eid)) {
+	if (!mctp_address_unicast(eid)) {
 		NL_SET_ERR_MSG(extack, "Invalid neighbour EID");
 		return -EINVAL;
 	}
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 0c4c56e1bd6e..6a11d78cfbab 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -962,7 +962,7 @@ static int mctp_route_add(struct mctp_dev *mdev, mctp_eid_t daddr_start,
 	struct net *net = dev_net(mdev->dev);
 	struct mctp_route *rt, *ert;
 
-	if (!mctp_address_ok(daddr_start))
+	if (!mctp_address_unicast(daddr_start))
 		return -EINVAL;
 
 	if (daddr_extent > 0xff || daddr_start + daddr_extent >= 255)
-- 
2.34.1

