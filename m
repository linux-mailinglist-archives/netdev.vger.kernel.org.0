Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2512E22EAC0
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgG0LGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:06:43 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40689 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728537AbgG0LGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:06:19 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 27 Jul 2020 14:06:12 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06RB6CLr022234;
        Mon, 27 Jul 2020 14:06:12 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 06RB6Clg002394;
        Mon, 27 Jul 2020 14:06:12 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 06RB6CYt002393;
        Mon, 27 Jul 2020 14:06:12 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC 06/13] net/mlx5: Handle sync reset now event
Date:   Mon, 27 Jul 2020 14:02:26 +0300
Message-Id: <1595847753-2234-7-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On sync_reset_now event the driver does reload and PCI link toggle to
activate firmware upgrade reset. When the firmware sends this event it
syncs the event on all PFs, so all PFs will do PCI link toggle at once.
To do PCI link toggle, the driver ensures that no other device ID under
the same bridge by checking that all the PF functions under the same PCI
bridge have same device ID. If no other device it uses PCI bridge link
control to turn link down and up.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 126 ++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 13f83fc1783f..87f2b24f4aaa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -8,6 +8,9 @@ struct mlx5_fw_reset {
 	struct mlx5_nb nb;
 	struct workqueue_struct *wq;
 	struct work_struct reset_request_work;
+	struct work_struct reset_now_work;
+	struct completion done;
+	int ret;
 };
 
 static int mlx5_reg_mfrl_set(struct mlx5_core_dev *dev, u8 reset_level,
@@ -71,6 +74,124 @@ static void mlx5_sync_reset_request_event(struct work_struct *work)
 		mlx5_core_warn(dev, "PCI Sync FW Update Reset Ack. Device reset is expected.\n");
 }
 
+#define MLX5_PCI_LINK_UP_TIMEOUT 2000
+
+static int mlx5_pci_link_toggle(struct mlx5_core_dev *dev)
+{
+	struct pci_bus *bridge_bus = dev->pdev->bus;
+	struct pci_dev *bridge = bridge_bus->self;
+	u16 reg16, dev_id, sdev_id;
+	unsigned long timeout;
+	struct pci_dev *sdev;
+	int cap, err;
+	u32 reg32;
+
+	/* Check that all functions under the pci bridge are PFs of
+	 * this device otherwise fail this function.
+	 */
+	err = pci_read_config_word(dev->pdev, PCI_DEVICE_ID, &dev_id);
+	if (err)
+		return err;
+	list_for_each_entry(sdev, &bridge_bus->devices, bus_list) {
+		err = pci_read_config_word(sdev, PCI_DEVICE_ID, &sdev_id);
+		if (err)
+			return err;
+		if (sdev_id != dev_id)
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
+	/* PCI link toggle */
+	err = pci_read_config_word(bridge, cap + PCI_EXP_LNKCTL, &reg16);
+	if (err)
+		return err;
+	reg16 |= PCI_EXP_LNKCTL_LD;
+	err = pci_write_config_word(bridge, cap + PCI_EXP_LNKCTL, reg16);
+	if (err)
+		return err;
+	msleep(500);
+	reg16 &= ~PCI_EXP_LNKCTL_LD;
+	err = pci_write_config_word(bridge, cap + PCI_EXP_LNKCTL, reg16);
+	if (err)
+		return err;
+
+	/* Check link */
+	err = pci_read_config_dword(bridge, cap + PCI_EXP_LNKCAP, &reg32);
+	if (err)
+		return err;
+	if (!(reg32 & PCI_EXP_LNKCAP_DLLLARC)) {
+		mlx5_core_warn(dev, "No PCI link reporting capability (0x%08x)\n", reg32);
+		msleep(1000);
+		goto restore;
+	}
+
+	timeout = jiffies + msecs_to_jiffies(MLX5_PCI_LINK_UP_TIMEOUT);
+	do {
+		err = pci_read_config_word(bridge, cap + PCI_EXP_LNKSTA, &reg16);
+		if (err)
+			return err;
+		if (reg16 & PCI_EXP_LNKSTA_DLLLA)
+			break;
+		msleep(20);
+	} while (!time_after(jiffies, timeout));
+
+	if (reg16 & PCI_EXP_LNKSTA_DLLLA) {
+		mlx5_core_info(dev, "PCI Link up\n");
+	} else {
+		mlx5_core_err(dev, "PCI link not ready (0x%04x) after %d ms\n",
+			      reg16, MLX5_PCI_LINK_UP_TIMEOUT);
+		err = -ETIMEDOUT;
+	}
+
+restore:
+	list_for_each_entry(sdev, &bridge_bus->devices, bus_list) {
+		pci_cfg_access_unlock(sdev);
+		pci_restore_state(sdev);
+	}
+
+	return err;
+}
+
+static void mlx5_sync_reset_now_event(struct work_struct *work)
+{
+	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
+						      reset_now_work);
+	struct mlx5_core_dev *dev = fw_reset->dev;
+	int err;
+
+	mlx5_health_clear_reset_requested_mode(dev);
+	mlx5_stop_health_poll(dev, true);
+
+	mlx5_core_warn(dev, "Sync Reset now. Device is going to reset.\n");
+
+	err = mlx5_cmd_fast_teardown_hca(dev);
+	if (err) {
+		mlx5_core_warn(dev, "Fast teardown failed, no reset done, err %d\n", err);
+		goto done;
+	}
+
+	err = mlx5_pci_link_toggle(dev);
+	if (err) {
+		mlx5_core_warn(dev, "mlx5_pci_link_toggle failed, no reset done, err %d\n", err);
+		goto done;
+	}
+
+	mlx5_enter_error_state(dev, true);
+	mlx5_unload_one(dev, false);
+done:
+	if (err)
+		mlx5_start_health_poll(dev);
+	fw_reset->ret = err;
+	complete(&fw_reset->done);
+}
+
 static void mlx5_sync_reset_events_handle(struct mlx5_fw_reset *fw_reset, struct mlx5_eqe *eqe)
 {
 	struct mlx5_eqe_sync_fw_update *sync_fw_update_eqe;
@@ -82,6 +203,9 @@ static void mlx5_sync_reset_events_handle(struct mlx5_fw_reset *fw_reset, struct
 	case MLX5_SYNC_RST_STATE_RESET_REQUEST:
 		queue_work(fw_reset->wq, &fw_reset->reset_request_work);
 		break;
+	case MLX5_SYNC_RST_STATE_RESET_NOW:
+		queue_work(fw_reset->wq, &fw_reset->reset_now_work);
+		break;
 	}
 }
 
@@ -117,10 +241,12 @@ int mlx5_fw_reset_events_init(struct mlx5_core_dev *dev)
 	dev->priv.fw_reset = fw_reset;
 
 	INIT_WORK(&fw_reset->reset_request_work, mlx5_sync_reset_request_event);
+	INIT_WORK(&fw_reset->reset_now_work, mlx5_sync_reset_now_event);
 
 	MLX5_NB_INIT(&fw_reset->nb, fw_reset_event_notifier, GENERAL_EVENT);
 	mlx5_eq_notifier_register(dev, &fw_reset->nb);
 
+	init_completion(&fw_reset->done);
 	return 0;
 }
 
-- 
2.17.1

