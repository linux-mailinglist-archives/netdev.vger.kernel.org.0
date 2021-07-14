Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8483C8032
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 10:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238603AbhGNIfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 04:35:32 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:33346 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238590AbhGNIfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 04:35:30 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d85 with ME
        id UwYb2500C21Fzsu03wYbte; Wed, 14 Jul 2021 10:32:37 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 14 Jul 2021 10:32:37 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jiri@nvidia.com, idosch@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: switchdev: Simplify 'mlxsw_sp_mc_write_mdb_entry()'
Date:   Wed, 14 Jul 2021 10:32:33 +0200
Message-Id: <fbc480268644caf24aef68a3b893bdaef71d7306.1626251484.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 'bitmap_alloc()/bitmap_free()' instead of hand-writing it.
This makes the code less verbose.

Also, use 'bitmap_alloc()' instead of 'bitmap_zalloc()' because the bitmap
is fully overridden by a 'bitmap_copy()' call just after its allocation.

While at it, remove an extra and unneeded space.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index c5ef9aa64efe..61911fed6aeb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1569,7 +1569,6 @@ mlxsw_sp_mc_write_mdb_entry(struct mlxsw_sp *mlxsw_sp,
 {
 	long *flood_bitmap;
 	int num_of_ports;
-	int alloc_size;
 	u16 mid_idx;
 	int err;
 
@@ -1579,18 +1578,17 @@ mlxsw_sp_mc_write_mdb_entry(struct mlxsw_sp *mlxsw_sp,
 		return false;
 
 	num_of_ports = mlxsw_core_max_ports(mlxsw_sp->core);
-	alloc_size = sizeof(long) * BITS_TO_LONGS(num_of_ports);
-	flood_bitmap = kzalloc(alloc_size, GFP_KERNEL);
+	flood_bitmap = bitmap_alloc(num_of_ports, GFP_KERNEL);
 	if (!flood_bitmap)
 		return false;
 
-	bitmap_copy(flood_bitmap,  mid->ports_in_mid, num_of_ports);
+	bitmap_copy(flood_bitmap, mid->ports_in_mid, num_of_ports);
 	mlxsw_sp_mc_get_mrouters_bitmap(flood_bitmap, bridge_device, mlxsw_sp);
 
 	mid->mid = mid_idx;
 	err = mlxsw_sp_port_smid_full_entry(mlxsw_sp, mid_idx, flood_bitmap,
 					    bridge_device->mrouter);
-	kfree(flood_bitmap);
+	bitmap_free(flood_bitmap);
 	if (err)
 		return false;
 
-- 
2.30.2

