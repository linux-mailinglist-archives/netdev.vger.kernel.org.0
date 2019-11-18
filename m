Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8535FFF6F
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 08:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfKRHTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 02:19:01 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41331 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbfKRHTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 02:19:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A06A422469;
        Mon, 18 Nov 2019 02:18:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 18 Nov 2019 02:18:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=s/4rpTB7YDTfUONkd
        tNJ3XcbMrsAKvpojO+4NSkzW0g=; b=GEqBaQDWZJ3+LfxTFPVb2v6VpO4MEM12A
        tqD02GKWEbVaiW/poR2EhIzeVlzue8+vwPE8cLAiBHIUgfM1ce9f2xpO5ub1/46B
        zjZ94/P8dJj3YPhh/1rc1+H67no3sDdJxUvASFHTaZ1TmWdGrfIqTenGALq5b/oB
        +GgLDN4ceVmm5M8ULGYGDqhbmqVEjGB6RPe774GHqVwBQHqob3Yk5XOntpDA+v/X
        6wc9p1nnuq/ajRZ/xS6xTbtgygqCdGMvY+i3a2nLc6Z/nFQyehKTpb6emRLbDK4s
        3ZhLfi5R5dmkPbnqzYkkD9EBWhcR6HMap46UtaRj6p/anSP7zPKbw==
X-ME-Sender: <xms:4kXSXWTqPQB0YuCKgDlDq4omh5pZaVATJ9huXbSabCT6dmf6MmMLEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeggedguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:4kXSXfCsoLsQ26ukecVvBuBzhRJcgMXCazfrOtLzV7RTpM6vgNWK5w>
    <xmx:4kXSXdTF07T6mXUgSq_Z_BjHi2AAFWKCJ-4qNXfSgdkgKn_6P0v7mQ>
    <xmx:4kXSXdouueNkou5l89Fg_O0mXOfIFXSmc4DDgPFv__6ezsUTfTDfiA>
    <xmx:40XSXXwByhEbRn-OwmaBjHvZJNeADvNpZ61lqwa_5bp3eKYrWVVe1g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 761D380060;
        Mon, 18 Nov 2019 02:18:57 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] mlxsw: spectrum_router: Fix determining underlay for a GRE tunnel
Date:   Mon, 18 Nov 2019 09:18:42 +0200
Message-Id: <20191118071842.31712-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The helper mlxsw_sp_ipip_dev_ul_tb_id() determines the underlay VRF of a
GRE tunnel. For a tunnel without a bound device, it uses the same VRF that
the tunnel is in. However in Linux, a GRE tunnel without a bound device
uses the main VRF as the underlay. Fix the function accordingly.

mlxsw further assumed that moving a tunnel to a different VRF could cause
conflict in local tunnel endpoint address, which cannot be offloaded.
However, the only way that an underlay could be changed by moving the
tunnel device itself is if the tunnel device does not have a bound device.
But in that case the underlay is always the main VRF, so there is no
opportunity to introduce a conflict by moving such device. Thus this check
constitutes a dead code, and can be removed, which do.

Fixes: 6ddb7426a7d4 ("mlxsw: spectrum_router: Introduce loopback RIFs")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index a330b369e899..39d600c8b92d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -994,7 +994,7 @@ u32 mlxsw_sp_ipip_dev_ul_tb_id(const struct net_device *ol_dev)
 	if (d)
 		return l3mdev_fib_table(d) ? : RT_TABLE_MAIN;
 	else
-		return l3mdev_fib_table(ol_dev) ? : RT_TABLE_MAIN;
+		return RT_TABLE_MAIN;
 }
 
 static struct mlxsw_sp_rif *
@@ -1598,27 +1598,10 @@ static int mlxsw_sp_netdevice_ipip_ol_vrf_event(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_ipip_entry *ipip_entry =
 		mlxsw_sp_ipip_entry_find_by_ol_dev(mlxsw_sp, ol_dev);
-	enum mlxsw_sp_l3proto ul_proto;
-	union mlxsw_sp_l3addr saddr;
-	u32 ul_tb_id;
 
 	if (!ipip_entry)
 		return 0;
 
-	/* For flat configuration cases, moving overlay to a different VRF might
-	 * cause local address conflict, and the conflicting tunnels need to be
-	 * demoted.
-	 */
-	ul_tb_id = mlxsw_sp_ipip_dev_ul_tb_id(ol_dev);
-	ul_proto = mlxsw_sp->router->ipip_ops_arr[ipip_entry->ipipt]->ul_proto;
-	saddr = mlxsw_sp_ipip_netdev_saddr(ul_proto, ol_dev);
-	if (mlxsw_sp_ipip_demote_tunnel_by_saddr(mlxsw_sp, ul_proto,
-						 saddr, ul_tb_id,
-						 ipip_entry)) {
-		mlxsw_sp_ipip_entry_demote_tunnel(mlxsw_sp, ipip_entry);
-		return 0;
-	}
-
 	return __mlxsw_sp_ipip_entry_update_tunnel(mlxsw_sp, ipip_entry,
 						   true, false, false, extack);
 }
-- 
2.21.0

