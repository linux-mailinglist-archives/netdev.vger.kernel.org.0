Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE7513AE1B
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 16:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgANPzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 10:55:51 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41679 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726365AbgANPzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 10:55:51 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 Jan 2020 17:55:45 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.134.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00EFtjgr015236;
        Tue, 14 Jan 2020 17:55:45 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 00EFtjBq019706;
        Tue, 14 Jan 2020 17:55:45 +0200
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 00EFtj8e019703;
        Tue, 14 Jan 2020 17:55:45 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC 3/3] net/mlx5: Add FW upgrade reset support
Date:   Tue, 14 Jan 2020 17:55:28 +0200
Message-Id: <1579017328-19643-4-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579017328-19643-1-git-send-email-moshe@mellanox.com>
References: <1579017328-19643-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for FW upgrade reset.
On devlink reload the driver checks if there is a FW stored pending
upgrade reset. In such case the driver will set the device to FW upgrade
reset on next PCI link toggle and do link toggle after unload.

To do PCI link toggle, the driver ensures that no other device ID under
the same bridge by checking that all the PF functions under the same PCI
bridge have same device ID. If no other device it uses PCI bridge link
control to turn link down and up.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 81 ++++++++++++++++++++++-
 1 file changed, 80 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index ac108f1..2aa9e99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -85,12 +85,91 @@ static u16 mlx5_fw_ver_subminor(u32 version)
 	return 0;
 }
 
+static int mlx5_pci_link_toggle(struct mlx5_core_dev *dev)
+{
+	struct pci_bus *bridge_bus = dev->pdev->bus;
+	struct pci_dev *bridge = bridge_bus->self;
+	struct pci_dev *sdev;
+	u16 dev_id, sdev_id;
+	u16 reg16;
+	int cap;
+	int err;
+
+	/* Check that all functions under the pci bridge are VFs and PFs of
+	 * this device otherwise fail this function.
+	 */
+	pci_read_config_word(dev->pdev, PCI_DEVICE_ID, &dev_id);
+	list_for_each_entry(sdev, &bridge_bus->devices, bus_list) {
+		pci_read_config_word(sdev, PCI_DEVICE_ID, &sdev_id);
+		if (sdev_id != 0xFFFF && sdev_id != dev_id)
+			return -EPERM;
+	}
+
+	cap = pci_find_capability(bridge, PCI_CAP_ID_EXP);
+	if (!cap)
+		return -EOPNOTSUPP;
+
+	list_for_each_entry(sdev, &bridge_bus->devices, bus_list) {
+		pci_save_state(sdev);
+		pci_cfg_access_lock(sdev);
+	}
+	err = pci_read_config_word(bridge, cap + PCI_EXP_LNKCTL, &reg16);
+	if (err)
+		return err;
+	reg16 |= PCI_EXP_LNKCTL_LD;
+	err = pci_write_config_word(bridge, cap + PCI_EXP_LNKCTL, reg16);
+	if (err)
+		return err;
+	msleep(100);
+	reg16 &= ~PCI_EXP_LNKCTL_LD;
+	err = pci_write_config_word(bridge, cap + PCI_EXP_LNKCTL, reg16);
+	if (err)
+		return err;
+	msleep(100);
+	list_for_each_entry(sdev, &bridge_bus->devices, bus_list) {
+		pci_cfg_access_unlock(sdev);
+		pci_restore_state(sdev);
+	}
+
+	return 0;
+}
+
 static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 				    struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	bool pci_link_toggle_required = false;
+	u32 running_fw, stored_fw;
+	u8 reset_level;
+	int err;
+
+	err = mlx5_fw_version_query(dev, &running_fw, &stored_fw);
+	if (err)
+		return err;
 
-	return mlx5_unload_one(dev, false);
+	if (stored_fw) {
+		err = mlx5_fw_query_reset_level(dev, &reset_level);
+		if (err)
+			return err;
+		if (reset_level & MLX5_MFRL_REG_RESET_LEVEL3) {
+			err = mlx5_fw_set_reset_level(dev,
+						      MLX5_MFRL_REG_RESET_LEVEL3);
+			if (err)
+				return err;
+			pci_link_toggle_required = true;
+		} else {
+			mlx5_core_warn(dev, "FW upgrade requires reboot\n");
+		}
+	}
+
+	err =  mlx5_unload_one(dev, false);
+	if (err)
+		return err;
+
+	if (pci_link_toggle_required)
+		return mlx5_pci_link_toggle(dev);
+
+	return 0;
 }
 
 static int mlx5_devlink_reload_up(struct devlink *devlink,
-- 
1.8.3.1

