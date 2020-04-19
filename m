Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13FA1AF81D
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 09:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgDSHB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 03:01:57 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57273 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726006AbgDSHB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 03:01:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 459ED5C008D;
        Sun, 19 Apr 2020 03:01:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 19 Apr 2020 03:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=9L1OwmGQMVntJTzoitJYdlQmJa9gU/eF0KNsYlg+Blk=; b=W2JmawEj
        FX2VBkLjk4yTcLGZ0R7Rp8IrkMdLhb3fi7xHUC09FMynM3GSXawekA1V69DjOX/V
        wY2MfvfrTQmy04XUtEKEwvyteXpC+G3s6NELlTXG0f4am55iSRGbkjAJ2D/NicJy
        1NkTbMO5RP/W5NWDOZbeoO10mrg+VctOzGbyb4jmm/u+ISpx3rZrO7zvJZBNXr1r
        OG0EC6hg3Aq87zQn3Dclvnc1vqYDSKUWlF9INUtS0gFO/wW94n20+0bFMw+OPXDM
        DWZFnzecAokaWthGK/g9ZaCwMGNOeJ73eKQtEYLfIziuwhdnHGJytil36O3ybCFn
        ZeAB7/RGRteO0Q==
X-ME-Sender: <xms:ZPebXju0RQZFimdyNcQcomAjBhisMVKPoezTn3ImIB0i3pdr6u89sA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgedtgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudektddrheegrdduudeinecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:ZPebXgysqV0Y9grxvHOvw7qHOv06dV2LEzlNHUb9MFttaCKciCWaWg>
    <xmx:ZPebXpgS4GPEc4tfngd2rMtzZL47Ff7PzFEjhfSqKRHwH-bHlyJxPA>
    <xmx:ZPebXkAa0KN3ESC57l5kfYINz3rdGfy1HdURrEM0IlCO4t7MIAbDzQ>
    <xmx:ZPebXpfH44BNWDfdct4abdG4BNlCPBtbt57SVGsBTlbTlBiJS1p7TQ>
Received: from localhost.localdomain (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0CA6D328005D;
        Sun, 19 Apr 2020 03:01:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/2] mlxsw: spectrum_router: Re-increase scale of IPv6 nexthop groups
Date:   Sun, 19 Apr 2020 10:01:05 +0300
Message-Id: <20200419070106.3471528-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200419070106.3471528-1-idosch@idosch.org>
References: <20200419070106.3471528-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

As explained in commit fc25996e6f46 ("mlxsw: spectrum_router: Increase
scale of IPv6 nexthop groups"), each nexthop group is hashed by XOR-ing
the interface indexes of all the member nexthop devices.

To avoid many different nexthop groups ending up using the same key, the
above commit started hashing the interface indexes themselves before
they are XOR-ed.

However, in cases in which there are many nexthop groups that all use
the same nexthop device and only differ in the gateway IP, we can still
end up in a situation in which all the groups are using the same key.
This eventually leads to -EBUSY error from rhashtable during insertion.

Improve the situation by also making the gateway IP part of the key.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Alex Veber <alexve@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Tested-by: Alex Veber <alexve@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index d5bca1be3ef5..71aee4914619 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2999,6 +2999,7 @@ static u32 mlxsw_sp_nexthop_group_hash_obj(const void *data, u32 len, u32 seed)
 		for (i = 0; i < nh_grp->count; i++) {
 			nh = &nh_grp->nexthops[i];
 			val ^= jhash(&nh->ifindex, sizeof(nh->ifindex), seed);
+			val ^= jhash(&nh->gw_addr, sizeof(nh->gw_addr), seed);
 		}
 		return jhash(&val, sizeof(val), seed);
 	default:
@@ -3012,11 +3013,14 @@ mlxsw_sp_nexthop6_group_hash(struct mlxsw_sp_fib6_entry *fib6_entry, u32 seed)
 {
 	unsigned int val = fib6_entry->nrt6;
 	struct mlxsw_sp_rt6 *mlxsw_sp_rt6;
-	struct net_device *dev;
 
 	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list) {
-		dev = mlxsw_sp_rt6->rt->fib6_nh->fib_nh_dev;
+		struct fib6_nh *fib6_nh = mlxsw_sp_rt6->rt->fib6_nh;
+		struct net_device *dev = fib6_nh->fib_nh_dev;
+		struct in6_addr *gw = &fib6_nh->fib_nh_gw6;
+
 		val ^= jhash(&dev->ifindex, sizeof(dev->ifindex), seed);
+		val ^= jhash(gw, sizeof(*gw), seed);
 	}
 
 	return jhash(&val, sizeof(val), seed);
-- 
2.24.1

