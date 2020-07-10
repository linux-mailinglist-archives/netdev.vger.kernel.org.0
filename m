Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A6E21B6BC
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgGJNmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:42:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59465 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727915AbgGJNmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:42:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0C45B5C0101;
        Fri, 10 Jul 2020 09:42:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:42:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=dapy7W6by3QEcUBZVZMFBmySiLFXZX45wKtCXkiCU1s=; b=KCuO4BNx
        h7hExAHBllQsvaprVA/A/WsGNJXK5+lR2gv05Azw1go0q7Oj3Wrx2y5c4weBTT8c
        dVdusP+oki7H+W0ruxsqx2tTtcDZ3Vt/IgNXLAVVDMZnp8XvdlJKdPbigggKQgrd
        GciNjy3+LmWffUAgWD+gj3d3ppNvYfNnVEVrysH9/R5QD58DCLpMg9pNyA0InHNL
        CflYUgLI115uUxlV5ruJcMiGIyobvdghz37OBW1g6jYVSQvBpq3AHPLUZsaPtIFP
        aL6fUUCG2bX/YWpJvP6O1WwssIBYu1hE7rqYjZIWOTlZGwE8ZdbcLE9xunnbSTen
        ZnDcmYK25mUMzQ==
X-ME-Sender: <xms:PHAIX4uKFOmi42TUkhvt74lhzg5SxTgDp26RCu8nCmitwHN1ckLLKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeefteeijedugfejheffffeigeeijeehke
    eltdfgudevgfefieekgefhffetgeduudenucffohhmrghinhepqhgvmhhurdhorhhgnecu
    kfhppedutdelrdeiiedrudelrddufeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:PXAIX1f7UTwtcG7iqjievqTzFfJXj-4-fzhHBpIBMyWzdDsnBHhUgQ>
    <xmx:PXAIXzyGTHTErV4keA5buqY4aN55-a7mzlKMUXNuKOxkvIS3qG0thQ>
    <xmx:PXAIX7N7YlEns9EtwF0_VjYlAoeurzY8PJfOO22xPisWzk4V5wGNog>
    <xmx:PXAIX2kqvNEG1a0ePbVfNePN4INwf570OyqxB3pDcefgyQz7fARF6A>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4A722328005D;
        Fri, 10 Jul 2020 09:42:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 2/2] mlxsw: pci: Fix use-after-free in case of failed devlink reload
Date:   Fri, 10 Jul 2020 16:41:39 +0300
Message-Id: <20200710134139.599811-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710134139.599811-1-idosch@idosch.org>
References: <20200710134139.599811-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In case devlink reload failed, it is possible to trigger a
use-after-free when querying the kernel for device info via 'devlink dev
info' [1].

This happens because as part of the reload error path the PCI command
interface is de-initialized and its mailboxes are freed. When the
devlink '->info_get()' callback is invoked the device is queried via the
command interface and the freed mailboxes are accessed.

Fix this by initializing the command interface once during probe and not
during every reload.

This is consistent with the other bus used by mlxsw (i.e., 'mlxsw_i2c')
and also allows user space to query the running firmware version (for
example) from the device after a failed reload.

[1]
BUG: KASAN: use-after-free in memcpy include/linux/string.h:406 [inline]
BUG: KASAN: use-after-free in mlxsw_pci_cmd_exec+0x177/0xa60 drivers/net/ethernet/mellanox/mlxsw/pci.c:1675
Write of size 4096 at addr ffff88810ae32000 by task syz-executor.1/2355

CPU: 1 PID: 2355 Comm: syz-executor.1 Not tainted 5.8.0-rc2+ #29
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xf6/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0+0x1c/0x250 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x14e/0x1b0 mm/kasan/generic.c:192
 memcpy+0x39/0x60 mm/kasan/common.c:106
 memcpy include/linux/string.h:406 [inline]
 mlxsw_pci_cmd_exec+0x177/0xa60 drivers/net/ethernet/mellanox/mlxsw/pci.c:1675
 mlxsw_cmd_exec+0x249/0x550 drivers/net/ethernet/mellanox/mlxsw/core.c:2335
 mlxsw_cmd_access_reg drivers/net/ethernet/mellanox/mlxsw/cmd.h:859 [inline]
 mlxsw_core_reg_access_cmd drivers/net/ethernet/mellanox/mlxsw/core.c:1938 [inline]
 mlxsw_core_reg_access+0x2f6/0x540 drivers/net/ethernet/mellanox/mlxsw/core.c:1985
 mlxsw_reg_query drivers/net/ethernet/mellanox/mlxsw/core.c:2000 [inline]
 mlxsw_devlink_info_get+0x17f/0x6e0 drivers/net/ethernet/mellanox/mlxsw/core.c:1090
 devlink_nl_info_fill.constprop.0+0x13c/0x2d0 net/core/devlink.c:4588
 devlink_nl_cmd_info_get_dumpit+0x246/0x460 net/core/devlink.c:4648
 genl_lock_dumpit+0x85/0xc0 net/netlink/genetlink.c:575
 netlink_dump+0x515/0xe50 net/netlink/af_netlink.c:2245
 __netlink_dump_start+0x53d/0x830 net/netlink/af_netlink.c:2353
 genl_family_rcv_msg_dumpit.isra.0+0x296/0x300 net/netlink/genetlink.c:638
 genl_family_rcv_msg net/netlink/genetlink.c:733 [inline]
 genl_rcv_msg+0x78d/0x9d0 net/netlink/genetlink.c:753
 netlink_rcv_skb+0x152/0x440 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:764
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x53a/0x750 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x850/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0x150/0x190 net/socket.c:672
 ____sys_sendmsg+0x6d8/0x840 net/socket.c:2363
 ___sys_sendmsg+0xff/0x170 net/socket.c:2417
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2450
 do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: a9c8336f6544 ("mlxsw: core: Add support for devlink info command")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 54 ++++++++++++++++-------
 1 file changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index fd0e97de44e7..c04ec1a92826 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1414,23 +1414,12 @@ static int mlxsw_pci_init(void *bus_priv, struct mlxsw_core *mlxsw_core,
 	u16 num_pages;
 	int err;
 
-	mutex_init(&mlxsw_pci->cmd.lock);
-	init_waitqueue_head(&mlxsw_pci->cmd.wait);
-
 	mlxsw_pci->core = mlxsw_core;
 
 	mbox = mlxsw_cmd_mbox_alloc();
 	if (!mbox)
 		return -ENOMEM;
 
-	err = mlxsw_pci_mbox_alloc(mlxsw_pci, &mlxsw_pci->cmd.in_mbox);
-	if (err)
-		goto mbox_put;
-
-	err = mlxsw_pci_mbox_alloc(mlxsw_pci, &mlxsw_pci->cmd.out_mbox);
-	if (err)
-		goto err_out_mbox_alloc;
-
 	err = mlxsw_pci_sw_reset(mlxsw_pci, mlxsw_pci->id);
 	if (err)
 		goto err_sw_reset;
@@ -1537,9 +1526,6 @@ static int mlxsw_pci_init(void *bus_priv, struct mlxsw_core *mlxsw_core,
 	mlxsw_pci_free_irq_vectors(mlxsw_pci);
 err_alloc_irq:
 err_sw_reset:
-	mlxsw_pci_mbox_free(mlxsw_pci, &mlxsw_pci->cmd.out_mbox);
-err_out_mbox_alloc:
-	mlxsw_pci_mbox_free(mlxsw_pci, &mlxsw_pci->cmd.in_mbox);
 mbox_put:
 	mlxsw_cmd_mbox_free(mbox);
 	return err;
@@ -1553,8 +1539,6 @@ static void mlxsw_pci_fini(void *bus_priv)
 	mlxsw_pci_aqs_fini(mlxsw_pci);
 	mlxsw_pci_fw_area_fini(mlxsw_pci);
 	mlxsw_pci_free_irq_vectors(mlxsw_pci);
-	mlxsw_pci_mbox_free(mlxsw_pci, &mlxsw_pci->cmd.out_mbox);
-	mlxsw_pci_mbox_free(mlxsw_pci, &mlxsw_pci->cmd.in_mbox);
 }
 
 static struct mlxsw_pci_queue *
@@ -1776,6 +1760,37 @@ static const struct mlxsw_bus mlxsw_pci_bus = {
 	.features		= MLXSW_BUS_F_TXRX | MLXSW_BUS_F_RESET,
 };
 
+static int mlxsw_pci_cmd_init(struct mlxsw_pci *mlxsw_pci)
+{
+	int err;
+
+	mutex_init(&mlxsw_pci->cmd.lock);
+	init_waitqueue_head(&mlxsw_pci->cmd.wait);
+
+	err = mlxsw_pci_mbox_alloc(mlxsw_pci, &mlxsw_pci->cmd.in_mbox);
+	if (err)
+		goto err_in_mbox_alloc;
+
+	err = mlxsw_pci_mbox_alloc(mlxsw_pci, &mlxsw_pci->cmd.out_mbox);
+	if (err)
+		goto err_out_mbox_alloc;
+
+	return 0;
+
+err_out_mbox_alloc:
+	mlxsw_pci_mbox_free(mlxsw_pci, &mlxsw_pci->cmd.in_mbox);
+err_in_mbox_alloc:
+	mutex_destroy(&mlxsw_pci->cmd.lock);
+	return err;
+}
+
+static void mlxsw_pci_cmd_fini(struct mlxsw_pci *mlxsw_pci)
+{
+	mlxsw_pci_mbox_free(mlxsw_pci, &mlxsw_pci->cmd.out_mbox);
+	mlxsw_pci_mbox_free(mlxsw_pci, &mlxsw_pci->cmd.in_mbox);
+	mutex_destroy(&mlxsw_pci->cmd.lock);
+}
+
 static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	const char *driver_name = pdev->driver->name;
@@ -1831,6 +1846,10 @@ static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mlxsw_pci->pdev = pdev;
 	pci_set_drvdata(pdev, mlxsw_pci);
 
+	err = mlxsw_pci_cmd_init(mlxsw_pci);
+	if (err)
+		goto err_pci_cmd_init;
+
 	mlxsw_pci->bus_info.device_kind = driver_name;
 	mlxsw_pci->bus_info.device_name = pci_name(mlxsw_pci->pdev);
 	mlxsw_pci->bus_info.dev = &pdev->dev;
@@ -1848,6 +1867,8 @@ static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_bus_device_register:
+	mlxsw_pci_cmd_fini(mlxsw_pci);
+err_pci_cmd_init:
 	iounmap(mlxsw_pci->hw_addr);
 err_ioremap:
 err_pci_resource_len_check:
@@ -1865,6 +1886,7 @@ static void mlxsw_pci_remove(struct pci_dev *pdev)
 	struct mlxsw_pci *mlxsw_pci = pci_get_drvdata(pdev);
 
 	mlxsw_core_bus_device_unregister(mlxsw_pci->core, false);
+	mlxsw_pci_cmd_fini(mlxsw_pci);
 	iounmap(mlxsw_pci->hw_addr);
 	pci_release_regions(mlxsw_pci->pdev);
 	pci_disable_device(mlxsw_pci->pdev);
-- 
2.26.2

