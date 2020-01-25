Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C867D1497EA
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 22:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgAYVS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 16:18:57 -0500
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:34372 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbgAYVS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 16:18:56 -0500
Received: from localhost.localdomain ([92.140.214.230])
        by mwinf5d35 with ME
        id ulJo210054ypjRG03lJoUA; Sat, 25 Jan 2020 22:18:53 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 25 Jan 2020 22:18:53 +0100
X-ME-IP: 92.140.214.230
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jiri@mellanox.com, idosch@mellanox.com, davem@davemloft.net,
        vadimp@mellanox.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] mlxsw: minimal: Fix an error handling path in 'mlxsw_m_port_create()'
Date:   Sat, 25 Jan 2020 22:18:47 +0100
Message-Id: <20200125211847.12755-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An 'alloc_etherdev()' called is not ballanced by a corresponding
'free_netdev()' call in one error handling path.

Slighly reorder the error handling code to catch the missed case.

Fixes: c100e47caa8e ("mlxsw: minimal: Add ethtool support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 2b543911ae00..c4caeeadcba9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -213,8 +213,8 @@ mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u8 local_port, u8 module)
 
 err_register_netdev:
 	mlxsw_m->ports[local_port] = NULL;
-	free_netdev(dev);
 err_dev_addr_get:
+	free_netdev(dev);
 err_alloc_etherdev:
 	mlxsw_core_port_fini(mlxsw_m->core, local_port);
 	return err;
-- 
2.20.1

