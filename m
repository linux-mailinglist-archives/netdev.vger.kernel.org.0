Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0594191F03
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 03:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbgCYC1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 22:27:01 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:36274 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727280AbgCYC1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 22:27:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585103219; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=LtUW2dSiumEZN9/M65XSzpI2Mn57XCbv/ZGSeI+eZ5U=; b=FdY8RwJLVvtsg64D/NV4rfGbmRGbjtH4qEGcGnPvWGun46F9Vt2a9AjgEbwbF/U+2vFQKqJb
 f054ekEULh7O1TM+4en5h/Szu5BOFozgcuwYGX9Qih0EjWHSJi6H/yyrJB22QYSJ03Q1IWvG
 FMuxBiOkhLh6AZPztqQiD2mlw7k=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e7ac173.7fed6b955ce0-smtp-out-n04;
 Wed, 25 Mar 2020 02:26:59 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 15175C433D2; Wed, 25 Mar 2020 02:26:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from localhost.localdomain (unknown [112.64.2.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rjliao)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E9037C433CB;
        Wed, 25 Mar 2020 02:26:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E9037C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=rjliao@codeaurora.org
From:   Rocky Liao <rjliao@codeaurora.org>
To:     robh+dt@kernel.org, mark.rutland@arm.com, marcel@holtmann.org,
        johan.hedberg@gmail.com, thierry.escande@linaro.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bgodavar@codeaurora.org,
        c-hbandi@codeaurora.org, hemantg@codeaurora.org, mka@chromium.org,
        Rocky Liao <rjliao@codeaurora.org>
Subject: [PATCH v2 1/2] Bluetooth: hci_qca: Add support for Qualcomm Bluetooth SoC QCA6390
Date:   Wed, 25 Mar 2020 10:26:37 +0800
Message-Id: <20200325022638.14325-1-rjliao@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200314094328.3331-1-rjliao@codeaurora.org>
References: <20200314094328.3331-1-rjliao@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for QCA6390, including the devicetree and acpi
compatible hwid matching, and patch/nvm downloading.

Signed-off-by: Rocky Liao <rjliao@codeaurora.org>
---

Changes in v2:
  -removed the use of macro QCA_IS_3991_6390
  -removed the qca_send_enhancelog_enable_cmd()

 drivers/bluetooth/btqca.c   | 18 ++++++++++++-----
 drivers/bluetooth/btqca.h   |  3 ++-
 drivers/bluetooth/hci_qca.c | 40 ++++++++++++++++++++++++++++++-------
 3 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index a16845c0751d..3ea866d44568 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -32,7 +32,7 @@ int qca_read_soc_version(struct hci_dev *hdev, u32 *soc_version,
 	 * VSE event. WCN3991 sends version command response as a payload to
 	 * command complete event.
 	 */
-	if (soc_type == QCA_WCN3991) {
+	if (soc_type >= QCA_WCN3991) {
 		event_type = 0;
 		rlen += 1;
 		rtype = EDL_PATCH_VER_REQ_CMD;
@@ -69,7 +69,7 @@ int qca_read_soc_version(struct hci_dev *hdev, u32 *soc_version,
 		goto out;
 	}
 
-	if (soc_type == QCA_WCN3991)
+	if (soc_type >= QCA_WCN3991)
 		memmove(&edl->data, &edl->data[1], sizeof(*ver));
 
 	ver = (struct qca_btsoc_version *)(edl->data);
@@ -217,7 +217,7 @@ static void qca_tlv_check_data(struct qca_fw_config *config,
 				tlv_nvm->data[0] |= 0x80;
 
 				/* UART Baud Rate */
-				if (soc_type == QCA_WCN3991)
+				if (soc_type >= QCA_WCN3991)
 					tlv_nvm->data[1] = nvm_baud_rate;
 				else
 					tlv_nvm->data[2] = nvm_baud_rate;
@@ -268,7 +268,7 @@ static int qca_tlv_send_segment(struct hci_dev *hdev, int seg_size,
 	 * VSE event. WCN3991 sends version command response as a payload to
 	 * command complete event.
 	 */
-	if (soc_type == QCA_WCN3991) {
+	if (soc_type >= QCA_WCN3991) {
 		event_type = 0;
 		rlen = sizeof(*edl);
 		rtype = EDL_PATCH_TLV_REQ_CMD;
@@ -301,7 +301,7 @@ static int qca_tlv_send_segment(struct hci_dev *hdev, int seg_size,
 		err = -EIO;
 	}
 
-	if (soc_type == QCA_WCN3991)
+	if (soc_type >= QCA_WCN3991)
 		goto out;
 
 	tlv_resp = (struct tlv_seg_resp *)(edl->data);
@@ -442,6 +442,11 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 			    (soc_ver & 0x0000000f);
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/crbtfw%02x.tlv", rom_ver);
+	} else if (soc_type == QCA_QCA6390) {
+		rom_ver = ((soc_ver & 0x00000f00) >> 0x04) |
+			    (soc_ver & 0x0000000f);
+		snprintf(config.fwname, sizeof(config.fwname),
+			 "qca/htbtfw%02x.tlv", rom_ver);
 	} else {
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/rampatch_%08x.bin", soc_ver);
@@ -464,6 +469,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	else if (qca_is_wcn399x(soc_type))
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/crnv%02x.bin", rom_ver);
+	else if (soc_type == QCA_QCA6390)
+		snprintf(config.fwname, sizeof(config.fwname),
+			 "qca/htnv%02x.bin", rom_ver);
 	else
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/nvm_%08x.bin", soc_ver);
diff --git a/drivers/bluetooth/btqca.h b/drivers/bluetooth/btqca.h
index e16a4d650597..6e1e62dd4b95 100644
--- a/drivers/bluetooth/btqca.h
+++ b/drivers/bluetooth/btqca.h
@@ -125,8 +125,9 @@ enum qca_btsoc_type {
 	QCA_AR3002,
 	QCA_ROME,
 	QCA_WCN3990,
-	QCA_WCN3991,
 	QCA_WCN3998,
+	QCA_WCN3991,
+	QCA_QCA6390,
 };
 
 #if IS_ENABLED(CONFIG_BT_QCA)
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 439392b1c043..d0ac554584a4 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -26,6 +26,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
+#include <linux/acpi.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/serdev.h>
@@ -1596,7 +1597,7 @@ static int qca_setup(struct hci_uart *hu)
 	set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 
 	bt_dev_info(hdev, "setting up %s",
-		qca_is_wcn399x(soc_type) ? "wcn399x" : "ROME");
+		qca_is_wcn399x(soc_type) ? "wcn399x" : "ROME/QCA6390");
 
 retry:
 	ret = qca_power_on(hdev);
@@ -1665,10 +1666,10 @@ static int qca_setup(struct hci_uart *hu)
 	}
 
 	/* Setup bdaddr */
-	if (qca_is_wcn399x(soc_type))
-		hu->hdev->set_bdaddr = qca_set_bdaddr;
-	else
+	if (soc_type == QCA_ROME)
 		hu->hdev->set_bdaddr = qca_set_bdaddr_rome;
+	else
+		hu->hdev->set_bdaddr = qca_set_bdaddr;
 
 	return ret;
 }
@@ -1721,6 +1722,11 @@ static const struct qca_vreg_data qca_soc_data_wcn3998 = {
 	.num_vregs = 4,
 };
 
+static const struct qca_vreg_data qca_soc_data_qca6390 = {
+	.soc_type = QCA_QCA6390,
+	.num_vregs = 0,
+};
+
 static void qca_power_shutdown(struct hci_uart *hu)
 {
 	struct qca_serdev *qcadev;
@@ -1764,7 +1770,7 @@ static int qca_power_off(struct hci_dev *hdev)
 	enum qca_btsoc_type soc_type = qca_soc_type(hu);
 
 	/* Stop sending shutdown command if soc crashes. */
-	if (qca_is_wcn399x(soc_type)
+	if (soc_type != QCA_ROME
 		&& qca->memdump_state == QCA_MEMDUMP_IDLE) {
 		qca_send_pre_shutdown_cmd(hdev);
 		usleep_range(8000, 10000);
@@ -1900,7 +1906,11 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 			return err;
 		}
 	} else {
-		qcadev->btsoc_type = QCA_ROME;
+		if (data)
+			qcadev->btsoc_type = data->soc_type;
+		else
+			qcadev->btsoc_type = QCA_ROME;
+
 		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
 					       GPIOD_OUT_LOW);
 		if (!qcadev->bt_en) {
@@ -2044,21 +2054,37 @@ static int __maybe_unused qca_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(qca_pm_ops, qca_suspend, qca_resume);
 
+#ifdef CONFIG_OF
 static const struct of_device_id qca_bluetooth_of_match[] = {
 	{ .compatible = "qcom,qca6174-bt" },
+	{ .compatible = "qcom,qca6390-bt", .data = &qca_soc_data_qca6390},
 	{ .compatible = "qcom,wcn3990-bt", .data = &qca_soc_data_wcn3990},
 	{ .compatible = "qcom,wcn3991-bt", .data = &qca_soc_data_wcn3991},
 	{ .compatible = "qcom,wcn3998-bt", .data = &qca_soc_data_wcn3998},
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, qca_bluetooth_of_match);
+#endif
+
+#ifdef CONFIG_ACPI
+static const struct acpi_device_id qca_bluetooth_acpi_match[] = {
+	{ "QCOM6390", (kernel_ulong_t)&qca_soc_data_qca6390 },
+	{ "DLA16390", (kernel_ulong_t)&qca_soc_data_qca6390 },
+	{ "DLB16390", (kernel_ulong_t)&qca_soc_data_qca6390 },
+	{ "DLB26390", (kernel_ulong_t)&qca_soc_data_qca6390 },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, qca_bluetooth_acpi_match);
+#endif
+
 
 static struct serdev_device_driver qca_serdev_driver = {
 	.probe = qca_serdev_probe,
 	.remove = qca_serdev_remove,
 	.driver = {
 		.name = "hci_uart_qca",
-		.of_match_table = qca_bluetooth_of_match,
+		.of_match_table = of_match_ptr(qca_bluetooth_of_match),
+		.acpi_match_table = ACPI_PTR(qca_bluetooth_acpi_match),
 		.pm = &qca_pm_ops,
 	},
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
