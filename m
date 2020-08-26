Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023E7253563
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgHZQti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:49:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53477 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726929AbgHZQt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:49:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5AE225C01C2;
        Wed, 26 Aug 2020 12:49:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 26 Aug 2020 12:49:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=fLyWhkYxnNjSTifyEz4x0qpfXqVz+BDpga5wmqBIXh8=; b=B769YBLk
        5NmfmcuZWYeqxsgmfY0/fKDELK+3pBO2qZ20lMGTDQoPmoJ/xewCVBQpuYldToAM
        apvmVR55MzlKXfrm74EiD7/4+fQRIUg3IOA4m05sYNRpZOSifb9dAbR/Xphik5vl
        m81N2DrQq9ghSV70AMbkViOi8F0xv/1W3BEcP8XtGuG5xr84YQEEAdLmkZvoQN0X
        VrhkCFsFE/oS4BzmKzQVcmYPDpYKdzMUHM80ATuHJQxxTbXXdMxeWYTVYiSoprik
        6HLJ9PgJwnSdigHCAEBMYXRuowfbwQBjXl0712MPabssiyuAA2YldDk/Xn72buil
        WuP0U0N6lSyrVQ==
X-ME-Sender: <xms:l5JGX08TbU983qFFro7Rm0El_XeInk6rm6VksDm3d5fBn5NZ5xfMcw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddvvddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudei
    keenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:l5JGX8tOlGeChPBikszIiJ8NG8jbae5Ne--BAATM84mI-YPFPOZpWw>
    <xmx:l5JGX6BGdP1aPjSf4yCXt-3hAFyq71dHZwcHakjbgXWlhr6eiIy0PA>
    <xmx:l5JGX0c-WYI-7SSK7w6CBiu7kpNQcDTDT6qg7PPYaygK51mzlw5XxQ>
    <xmx:l5JGX30ryW9O98IcDgBluRHeg9A5II4UyxzDcQ_0Ubb5Yvi4SL3a7g>
Received: from shredder.mtl.com (igld-84-229-37-168.inter.net.il [84.229.37.168])
        by mail.messagingengine.com (Postfix) with ESMTPA id 92A093280060;
        Wed, 26 Aug 2020 12:49:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/7] ipv4: nexthop: Correctly update nexthop group when removing a nexthop
Date:   Wed, 26 Aug 2020 19:48:54 +0300
Message-Id: <20200826164857.1029764-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200826164857.1029764-1-idosch@idosch.org>
References: <20200826164857.1029764-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Each nexthop group contains an indication if it has IPv4 nexthops
('has_v4'). Its purpose is to prevent IPv6 routes from using groups with
IPv4 nexthops.

However, the indication is not updated when a nexthop is removed. This
results in the kernel wrongly rejecting IPv6 routes from pointing to
groups that only contain IPv6 nexthops. Example:

# ip nexthop replace id 1 via 192.0.2.2 dev dummy10
# ip nexthop replace id 2 via 2001:db8:1::2 dev dummy10
# ip nexthop replace id 10 group 1/2
# ip nexthop del id 1
# ip route replace 2001:db8:10::/64 nhid 10
Error: IPv6 routes can not use an IPv4 nexthop.

Solve this by updating the indication according to the new set of
member nexthops.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 1b736e3e1baa..5199a2815df6 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -797,7 +797,7 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 		return;
 	}
 
-	newg->has_v4 = nhg->has_v4;
+	newg->has_v4 = false;
 	newg->mpath = nhg->mpath;
 	newg->fdb_nh = nhg->fdb_nh;
 	newg->num_nh = nhg->num_nh;
@@ -806,12 +806,18 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 	nhges = nhg->nh_entries;
 	new_nhges = newg->nh_entries;
 	for (i = 0, j = 0; i < nhg->num_nh; ++i) {
+		struct nh_info *nhi;
+
 		/* current nexthop getting removed */
 		if (nhg->nh_entries[i].nh == nh) {
 			newg->num_nh--;
 			continue;
 		}
 
+		nhi = rtnl_dereference(nhges[i].nh->nh_info);
+		if (nhi->family == AF_INET)
+			newg->has_v4 = true;
+
 		list_del(&nhges[i].nh_list);
 		new_nhges[j].nh_parent = nhges[i].nh_parent;
 		new_nhges[j].nh = nhges[i].nh;
-- 
2.26.2

