Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026C0533315
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 23:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239210AbiEXVkb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 May 2022 17:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241951AbiEXVk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 17:40:29 -0400
Received: from sender11-of-o53.zoho.eu (sender11-of-o53.zoho.eu [31.186.226.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3D47CB4B
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 14:40:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1653427343; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=iIcXL1H4EEm9Cti55VVUyEqFXv0jEE1Psm1WGoY/ZtW2L6a8KX0O2NuUD2rzNUM+RSlyhNlCmZWMi9mF86+wp5ngeSkpXm8qSLO2ZpvTJGBijWvs/DnhUX3CGGx/XOh6kaUUPy1dHZqPWIIBs0oDTx915vIXoWOf5MQNmhu4zys=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1653427343; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=kfMgNN0Q1Ds1SrlZiSXNiTXOz7T/kCau2sb/z5kFqXU=; 
        b=AeBvyDkbgworGKvFt56Hcxn16voAC0mJY8iX/uNmkvoJTYhSo1y/Big4YzCOBNGQhymbVRimLHj6jQVAAhuNqX025J+D5l6aqELEeRK4W7XfpSK4fkbtXF72kohYBScC27KRWt9kow2VXOzl6Zsuj2X5IYymLv2DoLWRAxomAwI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from localhost.localdomain (port-92-194-239-176.dynamic.as20676.net [92.194.239.176]) by mx.zoho.eu
        with SMTPS id 1653427341858630.0610591818537; Tue, 24 May 2022 23:22:21 +0200 (CEST)
From:   Bastian Germann <bage@debian.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kubakici@wp.pl>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vasily Khoruzhick <anarsoul@gmail.com>,
        Bastian Germann <bage@debian.org>
Message-ID: <20220524212155.16944-3-bage@debian.org>
Subject: [PATCH v2 2/3] Bluetooth: btrtl: add support for the RTL8723CS
Date:   Tue, 24 May 2022 23:21:53 +0200
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220524212155.16944-1-bage@debian.org>
References: <20220524212155.16944-1-bage@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=utf8
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Khoruzhick <anarsoul@gmail.com>

The Realtek RTL8723CS is SDIO WiFi chip. It also contains a Bluetooth
module which is connected via UART to the host.

It shares lmp subversion with 8703B, so Realtek's userspace
initialization tool (rtk_hciattach) differentiates varieties of RTL8723CS
(CG, VF, XX) with RTL8703B using vendor's command to read chip type.

Also this chip declares support for some features it doesn't support
so add a quirk to indicate that these features are broken.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
[move former btrtl_apply_quirks to btrtl_set_quirks]
[rebase on current tree]
Signed-off-by: Bastian Germann <bage@debian.org>
---
 drivers/bluetooth/btrtl.c  | 120 +++++++++++++++++++++++++++++++++++--
 drivers/bluetooth/btrtl.h  |   5 ++
 drivers/bluetooth/hci_h5.c |   4 ++
 3 files changed, 125 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index 481d488bca0f..4b7378a65895 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -17,7 +17,11 @@
 
 #define VERSION "0.1"
 
+#define RTL_CHIP_8723CS_CG	3
+#define RTL_CHIP_8723CS_VF	4
+#define RTL_CHIP_8723CS_XX	5
 #define RTL_EPATCH_SIGNATURE	"Realtech"
+#define RTL_ROM_LMP_8703B	0x8703
 #define RTL_ROM_LMP_8723A	0x1200
 #define RTL_ROM_LMP_8723B	0x8723
 #define RTL_ROM_LMP_8821A	0x8821
@@ -30,6 +34,7 @@
 #define IC_MATCH_FL_HCIREV	(1 << 1)
 #define IC_MATCH_FL_HCIVER	(1 << 2)
 #define IC_MATCH_FL_HCIBUS	(1 << 3)
+#define IC_MATCH_FL_CHIP_TYPE	(1 << 4)
 #define IC_INFO(lmps, hcir, hciv, bus) \
 	.match_flags = IC_MATCH_FL_LMPSUBV | IC_MATCH_FL_HCIREV | \
 		       IC_MATCH_FL_HCIVER | IC_MATCH_FL_HCIBUS, \
@@ -58,6 +63,7 @@ struct id_table {
 	__u16 hci_rev;
 	__u8 hci_ver;
 	__u8 hci_bus;
+	__u8 chip_type;
 	bool config_needed;
 	bool has_rom_version;
 	bool has_msft_ext;
@@ -98,6 +104,39 @@ static const struct id_table ic_id_table[] = {
 	  .fw_name  = "rtl_bt/rtl8723b_fw.bin",
 	  .cfg_name = "rtl_bt/rtl8723b_config" },
 
+	/* 8723CS-CG */
+	{ .match_flags = IC_MATCH_FL_LMPSUBV | IC_MATCH_FL_CHIP_TYPE |
+			 IC_MATCH_FL_HCIBUS,
+	  .lmp_subver = RTL_ROM_LMP_8703B,
+	  .chip_type = RTL_CHIP_8723CS_CG,
+	  .hci_bus = HCI_UART,
+	  .config_needed = true,
+	  .has_rom_version = true,
+	  .fw_name  = "rtl_bt/rtl8723cs_cg_fw.bin",
+	  .cfg_name = "rtl_bt/rtl8723cs_cg_config" },
+
+	/* 8723CS-VF */
+	{ .match_flags = IC_MATCH_FL_LMPSUBV | IC_MATCH_FL_CHIP_TYPE |
+			 IC_MATCH_FL_HCIBUS,
+	  .lmp_subver = RTL_ROM_LMP_8703B,
+	  .chip_type = RTL_CHIP_8723CS_VF,
+	  .hci_bus = HCI_UART,
+	  .config_needed = true,
+	  .has_rom_version = true,
+	  .fw_name  = "rtl_bt/rtl8723cs_vf_fw.bin",
+	  .cfg_name = "rtl_bt/rtl8723cs_vf_config" },
+
+	/* 8723CS-XX */
+	{ .match_flags = IC_MATCH_FL_LMPSUBV | IC_MATCH_FL_CHIP_TYPE |
+			 IC_MATCH_FL_HCIBUS,
+	  .lmp_subver = RTL_ROM_LMP_8703B,
+	  .chip_type = RTL_CHIP_8723CS_XX,
+	  .hci_bus = HCI_UART,
+	  .config_needed = true,
+	  .has_rom_version = true,
+	  .fw_name  = "rtl_bt/rtl8723cs_xx_fw.bin",
+	  .cfg_name = "rtl_bt/rtl8723cs_xx_config" },
+
 	/* 8723D */
 	{ IC_INFO(RTL_ROM_LMP_8723B, 0xd, 0x8, HCI_USB),
 	  .config_needed = true,
@@ -199,7 +238,8 @@ static const struct id_table ic_id_table[] = {
 	};
 
 static const struct id_table *btrtl_match_ic(u16 lmp_subver, u16 hci_rev,
-					     u8 hci_ver, u8 hci_bus)
+					     u8 hci_ver, u8 hci_bus,
+					     u8 chip_type)
 {
 	int i;
 
@@ -216,6 +256,9 @@ static const struct id_table *btrtl_match_ic(u16 lmp_subver, u16 hci_rev,
 		if ((ic_id_table[i].match_flags & IC_MATCH_FL_HCIBUS) &&
 		    (ic_id_table[i].hci_bus != hci_bus))
 			continue;
+		if ((ic_id_table[i].match_flags & IC_MATCH_FL_CHIP_TYPE) &&
+		    (ic_id_table[i].chip_type != chip_type))
+			continue;
 
 		break;
 	}
@@ -298,6 +341,7 @@ static int rtlbt_parse_firmware(struct hci_dev *hdev,
 		{ RTL_ROM_LMP_8723B, 1 },
 		{ RTL_ROM_LMP_8821A, 2 },
 		{ RTL_ROM_LMP_8761A, 3 },
+		{ RTL_ROM_LMP_8703B, 7 },
 		{ RTL_ROM_LMP_8822B, 8 },
 		{ RTL_ROM_LMP_8723B, 9 },	/* 8723D */
 		{ RTL_ROM_LMP_8821A, 10 },	/* 8821C */
@@ -577,6 +621,48 @@ static int btrtl_setup_rtl8723b(struct hci_dev *hdev,
 	return ret;
 }
 
+static bool rtl_has_chip_type(u16 lmp_subver)
+{
+	switch (lmp_subver) {
+	case RTL_ROM_LMP_8703B:
+		return true;
+	default:
+		break;
+	}
+
+	return  false;
+}
+
+static int rtl_read_chip_type(struct hci_dev *hdev, u8 *type)
+{
+	struct rtl_chip_type_evt *chip_type;
+	struct sk_buff *skb;
+	const unsigned char cmd_buf[] = {0x00, 0x94, 0xa0, 0x00, 0xb0};
+
+	/* Read RTL chip type command */
+	skb = __hci_cmd_sync(hdev, 0xfc61, 5, cmd_buf, HCI_INIT_TIMEOUT);
+	if (IS_ERR(skb)) {
+		rtl_dev_err(hdev, "Read chip type failed (%ld)",
+			    PTR_ERR(skb));
+		return PTR_ERR(skb);
+	}
+
+	if (skb->len != sizeof(*chip_type)) {
+		rtl_dev_err(hdev, "RTL chip type event length mismatch");
+		kfree_skb(skb);
+		return -EIO;
+	}
+
+	chip_type = (struct rtl_chip_type_evt *)skb->data;
+	rtl_dev_info(hdev, "chip_type status=%x type=%x",
+		     chip_type->status, chip_type->type);
+
+	*type = chip_type->type & 0x0f;
+
+	kfree_skb(skb);
+	return 0;
+}
+
 void btrtl_free(struct btrtl_device_info *btrtl_dev)
 {
 	kvfree(btrtl_dev->fw_data);
@@ -593,7 +679,7 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
 	struct hci_rp_read_local_version *resp;
 	char cfg_name[40];
 	u16 hci_rev, lmp_subver;
-	u8 hci_ver;
+	u8 hci_ver, chip_type = 0;
 	int ret;
 	u16 opcode;
 	u8 cmd[2];
@@ -619,8 +705,14 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
 	hci_rev = le16_to_cpu(resp->hci_rev);
 	lmp_subver = le16_to_cpu(resp->lmp_subver);
 
+	if (rtl_has_chip_type(lmp_subver)) {
+		ret = rtl_read_chip_type(hdev, &chip_type);
+		if (ret)
+			goto err_free;
+	}
+
 	btrtl_dev->ic_info = btrtl_match_ic(lmp_subver, hci_rev, hci_ver,
-					    hdev->bus);
+					    hdev->bus, chip_type);
 
 	if (!btrtl_dev->ic_info)
 		btrtl_dev->drop_fw = true;
@@ -663,7 +755,7 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
 		lmp_subver = le16_to_cpu(resp->lmp_subver);
 
 		btrtl_dev->ic_info = btrtl_match_ic(lmp_subver, hci_rev, hci_ver,
-						    hdev->bus);
+						    hdev->bus, chip_type);
 	}
 out_free:
 	kfree_skb(skb);
@@ -745,6 +837,7 @@ int btrtl_download_firmware(struct hci_dev *hdev,
 	case RTL_ROM_LMP_8761A:
 	case RTL_ROM_LMP_8822B:
 	case RTL_ROM_LMP_8852A:
+	case RTL_ROM_LMP_8703B:
 		return btrtl_setup_rtl8723b(hdev, btrtl_dev);
 	default:
 		rtl_dev_info(hdev, "assuming no firmware upload needed");
@@ -777,6 +870,19 @@ void btrtl_set_quirks(struct hci_dev *hdev, struct btrtl_device_info *btrtl_dev)
 		rtl_dev_dbg(hdev, "WBS supported not enabled.");
 		break;
 	}
+
+	switch (btrtl_dev->ic_info->lmp_subver) {
+	case RTL_ROM_LMP_8703B:
+		/* 8723CS reports two pages for local ext features,
+		 * but it doesn't support any features from page 2 -
+		 * it either responds with garbage or with error status
+		 */
+		set_bit(HCI_QUIRK_BROKEN_LOCAL_EXT_FTR_MAX_PAGE,
+			&hdev->quirks);
+		break;
+	default:
+		break;
+	}
 }
 EXPORT_SYMBOL_GPL(btrtl_set_quirks);
 
@@ -935,6 +1041,12 @@ MODULE_FIRMWARE("rtl_bt/rtl8723b_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8723b_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8723bs_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8723bs_config.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8723cs_cg_fw.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8723cs_cg_config.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8723cs_vf_fw.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8723cs_vf_config.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8723cs_xx_fw.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8723cs_xx_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8723ds_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8723ds_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8761a_fw.bin");
diff --git a/drivers/bluetooth/btrtl.h b/drivers/bluetooth/btrtl.h
index 2c441bda390a..1c6282241d2d 100644
--- a/drivers/bluetooth/btrtl.h
+++ b/drivers/bluetooth/btrtl.h
@@ -14,6 +14,11 @@
 
 struct btrtl_device_info;
 
+struct rtl_chip_type_evt {
+	__u8 status;
+	__u8 type;
+} __packed;
+
 struct rtl_download_cmd {
 	__u8 index;
 	__u8 data[RTL_FRAG_LEN];
diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index c5a0409ef84f..048fefd03233 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -936,6 +936,8 @@ static int h5_btrtl_setup(struct h5 *h5)
 	err = btrtl_download_firmware(h5->hu->hdev, btrtl_dev);
 	/* Give the device some time before the hci-core sends it a reset */
 	usleep_range(10000, 20000);
+	if (err)
+		goto out_free;
 
 	btrtl_set_quirks(h5->hu->hdev, btrtl_dev);
 
@@ -1100,6 +1102,8 @@ static const struct of_device_id rtl_bluetooth_of_match[] = {
 	  .data = (const void *)&h5_data_rtl8822cs },
 	{ .compatible = "realtek,rtl8723bs-bt",
 	  .data = (const void *)&h5_data_rtl8723bs },
+	{ .compatible = "realtek,rtl8723cs-bt",
+	  .data = (const void *)&h5_data_rtl8723bs },
 	{ .compatible = "realtek,rtl8723ds-bt",
 	  .data = (const void *)&h5_data_rtl8723bs },
 #endif
-- 
2.36.1


