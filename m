Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4032661EBF1
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbiKGH1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiKGH0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:26:46 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B1B13CF0;
        Sun,  6 Nov 2022 23:26:45 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A76qsmq030455;
        Sun, 6 Nov 2022 23:26:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=qWKdv/uvxKwUTuRLBtd7l/ZFlc8Qv+LnF7fso7Xy8JM=;
 b=JUUlYJoMKETKpFZXftiBoqbW3vt25zBHPEJFXNGslf3IjycVeJCtg2CpselQ3bFdK83k
 xoKUDhAVJGJl/E27RjYdl6E3hqHWjd7AYcOHLjQvWFQUMKx3Rl4r1bqXoI/SrTn8UIPg
 rLz8pmqnCSEarMQTQUzF5DaAdIMCzwgdRgCVF5wUZVcGpFa2cI0kV+yRbnfbumaCiwnL
 cND2bdZdDQgMlJdilHmi5u4lHR1Da33sHPRvZ8y7Zn6WJsCx9vOfwUrestUQRJd0U5l8
 uujKTPkhusyDdMbMmjI4Fc2BW0JtMndjjXNt+M/9omSfEVazzvpV26OWByjSYhSlsjmz Qg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kpw4wg3fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 06 Nov 2022 23:26:35 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 6 Nov
 2022 23:26:33 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 6 Nov 2022 23:26:33 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 2F2033F7058;
        Sun,  6 Nov 2022 23:26:33 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 1/9] octeon_ep: wait for firmware ready
Date:   Sun, 6 Nov 2022 23:25:15 -0800
Message-ID: <20221107072524.9485-2-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221107072524.9485-1-vburru@marvell.com>
References: <20221107072524.9485-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: V4DlXe9AhixBuFYL5or7qitLQIABDCb3
X-Proofpoint-ORIG-GUID: V4DlXe9AhixBuFYL5or7qitLQIABDCb3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-06_16,2022-11-03_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make driver initialize the device only after firmware is ready
 - add async device setup routine.
 - poll firmware status register.
 - once firmware is ready, call async device setup routine.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
---
 .../ethernet/marvell/octeon_ep/octep_main.c   | 156 +++++++++++++-----
 .../ethernet/marvell/octeon_ep/octep_main.h   |  15 ++
 2 files changed, 133 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 1cbfa800a8af..488159217030 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -867,6 +867,14 @@ static const struct net_device_ops octep_netdev_ops = {
 	.ndo_change_mtu          = octep_change_mtu,
 };
 
+/* Cancel all tasks except hb task */
+static void cancel_all_tasks(struct octep_device *oct)
+{
+	cancel_work_sync(&oct->tx_timeout_task);
+	cancel_work_sync(&oct->ctrl_mbox_task);
+	octep_ctrl_mbox_uninit(&oct->ctrl_mbox);
+}
+
 /**
  * octep_ctrl_mbox_task - work queue task to handle ctrl mbox messages.
  *
@@ -979,6 +987,9 @@ int octep_device_setup(struct octep_device *oct)
 							   ctrl_mbox->f2hq.elem_sz,
 							   ctrl_mbox->f2hq.elem_cnt);
 
+	INIT_WORK(&oct->tx_timeout_task, octep_tx_timeout_task);
+	INIT_WORK(&oct->ctrl_mbox_task, octep_ctrl_mbox_task);
+
 	return 0;
 
 unsupported_dev:
@@ -1003,7 +1014,7 @@ static void octep_device_cleanup(struct octep_device *oct)
 		oct->mbox[i] = NULL;
 	}
 
-	octep_ctrl_mbox_uninit(&oct->ctrl_mbox);
+	cancel_all_tasks(oct);
 
 	oct->hw_ops.soft_reset(oct);
 	for (i = 0; i < OCTEP_MMIO_REGIONS; i++) {
@@ -1015,6 +1026,92 @@ static void octep_device_cleanup(struct octep_device *oct)
 	oct->conf = NULL;
 }
 
+static u8 get_fw_ready_status(struct octep_device *oct)
+{
+	u32 pos = 0;
+	u16 vsec_id;
+	u8 status = 0;
+
+	while ((pos = pci_find_next_ext_capability(oct->pdev, pos,
+						   PCI_EXT_CAP_ID_VNDR))) {
+		pci_read_config_word(oct->pdev, pos + 4, &vsec_id);
+#define FW_STATUS_VSEC_ID  0xA3
+		if (vsec_id == FW_STATUS_VSEC_ID) {
+			pci_read_config_byte(oct->pdev, (pos + 8), &status);
+			dev_info(&oct->pdev->dev, "Firmware ready %u\n",
+				 status);
+			return status;
+		}
+	}
+	return 0;
+}
+
+/**
+ * octep_dev_setup_task - work queue task to setup octep device.
+ *
+ * @work: pointer to dev setup work_struct
+ *
+ * Wait for firmware to be ready, then continue with device setup.
+ * Check for module exit while waiting for firmware.
+ *
+ **/
+static void octep_dev_setup_task(struct work_struct *work)
+{
+	struct octep_device *oct = container_of(work, struct octep_device,
+						dev_setup_task);
+	struct net_device *netdev = oct->netdev;
+	u8 status;
+	int err;
+
+	atomic_set(&oct->status, OCTEP_DEV_STATUS_WAIT_FOR_FW);
+	while (true) {
+		status = get_fw_ready_status(oct);
+#define FW_STATUS_READY    1
+		if (status == FW_STATUS_READY)
+			break;
+
+		schedule_timeout_interruptible(HZ * 1);
+
+		if (atomic_read(&oct->status) >= OCTEP_DEV_STATUS_READY) {
+			dev_info(&oct->pdev->dev,
+				 "Stopping firmware ready work.\n");
+			return;
+		}
+	}
+
+	/* Do not free resources on failure. driver unload will
+	 * lead to freeing resources.
+	 */
+	atomic_set(&oct->status, OCTEP_DEV_STATUS_INIT);
+	err = octep_device_setup(oct);
+	if (err) {
+		dev_err(&oct->pdev->dev, "Device setup failed\n");
+		atomic_set(&oct->status, OCTEP_DEV_STATUS_ALLOC);
+		return;
+	}
+
+	netdev->netdev_ops = &octep_netdev_ops;
+	octep_set_ethtool_ops(netdev);
+	netif_carrier_off(netdev);
+
+	netdev->hw_features = NETIF_F_SG;
+	netdev->features |= netdev->hw_features;
+	netdev->min_mtu = OCTEP_MIN_MTU;
+	netdev->max_mtu = OCTEP_MAX_MTU;
+	netdev->mtu = OCTEP_DEFAULT_MTU;
+
+	octep_get_mac_addr(oct, oct->mac_addr);
+	eth_hw_addr_set(netdev, oct->mac_addr);
+
+	err = register_netdev(netdev);
+	if (err) {
+		dev_err(&oct->pdev->dev, "Failed to register netdev\n");
+		atomic_set(&oct->status, OCTEP_DEV_STATUS_INIT);
+		return;
+	}
+	atomic_set(&oct->status, OCTEP_DEV_STATUS_READY);
+}
+
 /**
  * octep_probe() - Octeon PCI device probe handler.
  *
@@ -1066,39 +1163,13 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	octep_dev->dev = &pdev->dev;
 	pci_set_drvdata(pdev, octep_dev);
 
-	err = octep_device_setup(octep_dev);
-	if (err) {
-		dev_err(&pdev->dev, "Device setup failed\n");
-		goto err_octep_config;
-	}
-	INIT_WORK(&octep_dev->tx_timeout_task, octep_tx_timeout_task);
-	INIT_WORK(&octep_dev->ctrl_mbox_task, octep_ctrl_mbox_task);
+	atomic_set(&octep_dev->status, OCTEP_DEV_STATUS_ALLOC);
+	INIT_WORK(&octep_dev->dev_setup_task, octep_dev_setup_task);
+	queue_work(octep_wq, &octep_dev->dev_setup_task);
+	dev_info(&pdev->dev, "Device setup task queued\n");
 
-	netdev->netdev_ops = &octep_netdev_ops;
-	octep_set_ethtool_ops(netdev);
-	netif_carrier_off(netdev);
-
-	netdev->hw_features = NETIF_F_SG;
-	netdev->features |= netdev->hw_features;
-	netdev->min_mtu = OCTEP_MIN_MTU;
-	netdev->max_mtu = OCTEP_MAX_MTU;
-	netdev->mtu = OCTEP_DEFAULT_MTU;
-
-	octep_get_mac_addr(octep_dev, octep_dev->mac_addr);
-	eth_hw_addr_set(netdev, octep_dev->mac_addr);
-
-	err = register_netdev(netdev);
-	if (err) {
-		dev_err(&pdev->dev, "Failed to register netdev\n");
-		goto register_dev_err;
-	}
-	dev_info(&pdev->dev, "Device probe successful\n");
 	return 0;
 
-register_dev_err:
-	octep_device_cleanup(octep_dev);
-err_octep_config:
-	free_netdev(netdev);
 err_alloc_netdev:
 	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
@@ -1119,20 +1190,29 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 static void octep_remove(struct pci_dev *pdev)
 {
 	struct octep_device *oct = pci_get_drvdata(pdev);
-	struct net_device *netdev;
+	int status;
 
 	if (!oct)
 		return;
 
-	cancel_work_sync(&oct->tx_timeout_task);
-	cancel_work_sync(&oct->ctrl_mbox_task);
-	netdev = oct->netdev;
-	if (netdev->reg_state == NETREG_REGISTERED)
-		unregister_netdev(netdev);
+	dev_info(&pdev->dev, "Removing device.\n");
+	status = atomic_read(&oct->status);
+	if (status <= OCTEP_DEV_STATUS_ALLOC)
+		goto free_resources;
+
+	atomic_set(&oct->status, OCTEP_DEV_STATUS_UNINIT);
+	if (status == OCTEP_DEV_STATUS_WAIT_FOR_FW) {
+		cancel_work_sync(&oct->dev_setup_task);
+		goto free_resources;
+	}
+	if (oct->netdev->reg_state == NETREG_REGISTERED)
+		unregister_netdev(oct->netdev);
 
 	octep_device_cleanup(oct);
+
+free_resources:
 	pci_release_mem_regions(pdev);
-	free_netdev(netdev);
+	free_netdev(oct->netdev);
 	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
 }
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
index 123ffc13754d..45226282bf21 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
@@ -192,6 +192,16 @@ struct octep_iface_link_info {
 	u8  oper_up;
 };
 
+/* Device status */
+enum octep_dev_status {
+	OCTEP_DEV_STATUS_INVALID,
+	OCTEP_DEV_STATUS_ALLOC,
+	OCTEP_DEV_STATUS_WAIT_FOR_FW,
+	OCTEP_DEV_STATUS_INIT,
+	OCTEP_DEV_STATUS_READY,
+	OCTEP_DEV_STATUS_UNINIT
+};
+
 /* The Octeon device specific private data structure.
  * Each Octeon device has this structure to represent all its components.
  */
@@ -271,6 +281,11 @@ struct octep_device {
 	/* Work entry to handle ctrl mbox interrupt */
 	struct work_struct ctrl_mbox_task;
 
+	/* Work entry to handle device setup */
+	struct work_struct dev_setup_task;
+
+	/* Device status */
+	atomic_t status;
 };
 
 static inline u16 OCTEP_MAJOR_REV(struct octep_device *oct)
-- 
2.36.0

