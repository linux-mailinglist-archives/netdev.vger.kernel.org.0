Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC18B7137F
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 09:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388735AbfGWH6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 03:58:34 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48879 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730810AbfGWH6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 03:58:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6A58C21DC4;
        Tue, 23 Jul 2019 03:58:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 23 Jul 2019 03:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=iQf/cLDGJ/A268yALw9MxqH8j12Z2BrAO5xagmSOsIA=; b=WMTZHVt+
        KYgRL9fXeU1C17/VVm1tNhEI1UG1K5RylyvCgHWHrLDav40fnsMnVNisImCOIRFd
        CBZ+dTeRb1Qlr07zC8KhrFashNtorWNa+Tc8GTJRlvqnOa53BIIxMxYo1lwboz6T
        YZyAQfA+Lks6bdtomOfUIEgOR2qE4pR+Lo/cd/oihRGl5wB/OYIytDNmJ74/EYOJ
        N2h2gU1luwh7Fb5lT2oNi7oIYkDjNZBTnvjpondtl7iwy7g0RZTFr7ZkRECyzm16
        +HtqqJOwO5db4CTNBTiPeRPHHnTsOyz5yGvg3tIyB07EqWggzhpzCSiaJEDosnVq
        7BhHaEZX/892HA==
X-ME-Sender: <xms:Jr42XTxo7gV3wi1-SJ8dq6dusmt5KOa0TpZYp31udNncVbvyBGjFzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeejgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:Jr42XSZQFQW4YpQ5fpEwJBXE3PGEuHcvydBw_2fCUIF3eN5iwi8qIQ>
    <xmx:Jr42Xfoatep7iW0g09ho0uFgg5_Z0kdhHSjzlB23wFBH4ft91YxcHg>
    <xmx:Jr42XWS7EundR9Vtg45ciApdGGI_ZTWbYQz_sKNTcjRMf_rlhLZNoA>
    <xmx:Jr42XXv3TELsYIxA2C-syWR_b605ANz2uuk66gakftpZe1cJDYydow>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 09035380083;
        Tue, 23 Jul 2019 03:58:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/2] mlxsw: spectrum_router: Increase scale of IPv6 nexthop groups
Date:   Tue, 23 Jul 2019 10:57:42 +0300
Message-Id: <20190723075742.29029-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723075742.29029-1-idosch@idosch.org>
References: <20190723075742.29029-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Unlike IPv4, the kernel does not consolidate IPv6 nexthop groups. To
avoid exhausting the device's adjacency table - where nexthops are
stored - the driver does this consolidation instead.

Each nexthop group is hashed by XOR-ing the interface indexes of all the
member nexthop devices. However, the ifindex itself is not hashed, which
can result in identical keys used for different groups and finally an
-EBUSY error from rhashtable due to too long objects list.

Improve the situation by hashing the ifindex itself.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index e618be7ce6c6..a330b369e899 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2943,7 +2943,7 @@ static u32 mlxsw_sp_nexthop_group_hash_obj(const void *data, u32 len, u32 seed)
 		val = nh_grp->count;
 		for (i = 0; i < nh_grp->count; i++) {
 			nh = &nh_grp->nexthops[i];
-			val ^= nh->ifindex;
+			val ^= jhash(&nh->ifindex, sizeof(nh->ifindex), seed);
 		}
 		return jhash(&val, sizeof(val), seed);
 	default:
@@ -2961,7 +2961,7 @@ mlxsw_sp_nexthop6_group_hash(struct mlxsw_sp_fib6_entry *fib6_entry, u32 seed)
 
 	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list) {
 		dev = mlxsw_sp_rt6->rt->fib6_nh->fib_nh_dev;
-		val ^= dev->ifindex;
+		val ^= jhash(&dev->ifindex, sizeof(dev->ifindex), seed);
 	}
 
 	return jhash(&val, sizeof(val), seed);
-- 
2.21.0

