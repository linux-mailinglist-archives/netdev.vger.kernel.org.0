Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D7422614C
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgGTNsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 09:48:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39110 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725792AbgGTNsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 09:48:23 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7A1DCA8B768124F4FDD5;
        Mon, 20 Jul 2020 21:48:20 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 21:48:18 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <jiri@mellanox.co>, <idosch@mellanox.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH net] mlxsw: destroy workqueue when trap_register in mlxsw_emad_init
Date:   Mon, 20 Jul 2020 22:31:49 +0800
Message-ID: <20200720143150.40362-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mlxsw_core_trap_register fails in mlxsw_emad_init,
destroy_workqueue() shouled be called to destroy mlxsw_core->emad_wq.

Fixes: d965465b60ba ("mlxsw: core: Fix possible deadlock")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 1363168b3c82..b01f8f2fab63 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -710,7 +710,7 @@ static int mlxsw_emad_init(struct mlxsw_core *mlxsw_core)
 	err = mlxsw_core_trap_register(mlxsw_core, &mlxsw_emad_rx_listener,
 				       mlxsw_core);
 	if (err)
-		return err;
+		goto err_trap_register;
 
 	err = mlxsw_core->driver->basic_trap_groups_set(mlxsw_core);
 	if (err)
@@ -722,6 +722,7 @@ static int mlxsw_emad_init(struct mlxsw_core *mlxsw_core)
 err_emad_trap_set:
 	mlxsw_core_trap_unregister(mlxsw_core, &mlxsw_emad_rx_listener,
 				   mlxsw_core);
+err_trap_register:
 	destroy_workqueue(mlxsw_core->emad_wq);
 	return err;
 }
-- 
2.17.1

