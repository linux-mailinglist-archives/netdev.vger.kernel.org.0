Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83895253567
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgHZQtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:49:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58477 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727969AbgHZQtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:49:32 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 843855C01D9;
        Wed, 26 Aug 2020 12:49:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 26 Aug 2020 12:49:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=RRzgNkrmSPnv2kcHTOyIdt84ed1J3NcEQqM89mbZ9I8=; b=KaI0vXUB
        fGuVDt+l96qVHJRM6bZySvJYywC27BTZZ3HA70UueY+kLnCx5P22ccGBZMn9E+EM
        JyxGVQFCcNMVEiFijsSdbFQvqVYXZcacUDal+uoiCooeRblR78t+GQlyMciQf3dV
        NeqeCfLXW5ErhG8oQwU4n7SPYBbZDOeVHtucwEZH4jP+AbHZ3+EuGd0Xw0bVCeic
        eHrUWGMA4gyZSDXVYrrvyCg5vRN5atqqc9ZuZqIYBiNoctcZBObBb6FRJL3zVnNs
        aAm529cKDEAv3R30aqkEoppqIfMFwV39AucRECfH6jmsYBaFtiCecs/uiDqQIkS1
        7yGyQVoTKRc3dA==
X-ME-Sender: <xms:m5JGX2R4ZBjkof_C5MtRNa1VGC5r3nAVzHsaUbsfC6fmRAkosTNfuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddvvddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudei
    keenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:m5JGX7w2F6Nv2Z1Sx2XytA5lbpwQlVUBzDv_jYs6M-pcI8DnG57Yjw>
    <xmx:m5JGXz2Ov8AU2AgAmgEv1HFurkV2p1Z6hOr_nhkH039gk_6yC_rrhQ>
    <xmx:m5JGXyDKeXZ8ElkNQXs5AIPpgvkQvzZi0VpSVbis_CePLElg_vabuw>
    <xmx:m5JGX3b5MxwRm0gqbAP1iXU8xczPbRFjW_ZcJASxGtseSxMBOp6doA>
Received: from shredder.mtl.com (igld-84-229-37-168.inter.net.il [84.229.37.168])
        by mail.messagingengine.com (Postfix) with ESMTPA id B1756328005E;
        Wed, 26 Aug 2020 12:49:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/7] ipv4: nexthop: Correctly update nexthop group when replacing a nexthop
Date:   Wed, 26 Aug 2020 19:48:56 +0300
Message-Id: <20200826164857.1029764-7-idosch@idosch.org>
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

However, the indication is not updated when a nexthop is replaced. This
results in the kernel wrongly rejecting IPv6 routes from pointing to
groups that only contain IPv6 nexthops. Example:

# ip nexthop replace id 1 via 192.0.2.2 dev dummy10
# ip nexthop replace id 10 group 1
# ip nexthop replace id 1 via 2001:db8:1::2 dev dummy10
# ip route replace 2001:db8:10::/64 nhid 10
Error: IPv6 routes can not use an IPv4 nexthop.

Solve this by iterating over all the nexthop groups that the replaced
nexthop is a member of and potentially update their IPv4 indication
according to the new set of member nexthops.

Avoid wasting cycles by only performing the update in case an IPv4
nexthop is replaced by an IPv6 nexthop.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 5199a2815df6..bf9d4cd2d6e5 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -964,6 +964,23 @@ static int replace_nexthop_grp(struct net *net, struct nexthop *old,
 	return 0;
 }
 
+static void nh_group_v4_update(struct nh_group *nhg)
+{
+	struct nh_grp_entry *nhges;
+	bool has_v4 = false;
+	int i;
+
+	nhges = nhg->nh_entries;
+	for (i = 0; i < nhg->num_nh; i++) {
+		struct nh_info *nhi;
+
+		nhi = rtnl_dereference(nhges[i].nh->nh_info);
+		if (nhi->family == AF_INET)
+			has_v4 = true;
+	}
+	nhg->has_v4 = has_v4;
+}
+
 static int replace_nexthop_single(struct net *net, struct nexthop *old,
 				  struct nexthop *new,
 				  struct netlink_ext_ack *extack)
@@ -987,6 +1004,21 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
 	rcu_assign_pointer(old->nh_info, newi);
 	rcu_assign_pointer(new->nh_info, oldi);
 
+	/* When replacing an IPv4 nexthop with an IPv6 nexthop, potentially
+	 * update IPv4 indication in all the groups using the nexthop.
+	 */
+	if (oldi->family == AF_INET && newi->family == AF_INET6) {
+		struct nh_grp_entry *nhge;
+
+		list_for_each_entry(nhge, &old->grp_list, nh_list) {
+			struct nexthop *nhp = nhge->nh_parent;
+			struct nh_group *nhg;
+
+			nhg = rtnl_dereference(nhp->nh_grp);
+			nh_group_v4_update(nhg);
+		}
+	}
+
 	return 0;
 }
 
-- 
2.26.2

