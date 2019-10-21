Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 262FEDE2B3
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 05:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfJUDlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 23:41:39 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:58991 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbfJUDli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 23:41:38 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9L3fYsJ014799, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9L3fYsJ014799
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Oct 2019 11:41:34 +0800
Received: from fc30.localdomain (172.21.177.156) by RTITCAS11.realtek.com.tw
 (172.21.6.12) with Microsoft SMTP Server id 14.3.468.0; Mon, 21 Oct 2019
 11:41:33 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <pmalani@chromium.org>, <grundler@chromium.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 4/4] r8152: support firmware of PHY NC for RTL8153A
Date:   Mon, 21 Oct 2019 11:41:13 +0800
Message-ID: <1394712342-15778-334-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-330-Taiwan-albertk@realtek.com>
References: <1394712342-15778-330-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.156]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support the firmware of PHY NC which is used to fix the issue found
for PHY. Currently, only RTL_VER_04, RTL_VER_05, and RTL_VER_06 need
it.

The order of loading PHY firmware would be

	RTL_FW_PHY_START
	RTL_FW_PHY_NC
	RTL_FW_PHY_STOP

The RTL_FW_PHY_START/RTL_FW_PHY_STOP are used to lock/unlock the PHY,
and set/clear the patch key from the firmware file.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 284 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 282 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index ab57c672c4ca..d3c30ccc8577 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -187,6 +187,7 @@
 #define OCP_PHY_STATE		0xa708		/* nway state for 8153 */
 #define OCP_PHY_PATCH_STAT	0xb800
 #define OCP_PHY_PATCH_CMD	0xb820
+#define OCP_PHY_LOCK		0xb82e
 #define OCP_ADC_IOFFSET		0xbcfc
 #define OCP_ADC_CFG		0xbc06
 #define OCP_SYSCLK_CFG		0xc416
@@ -197,6 +198,7 @@
 #define SRAM_10M_AMP1		0x8080
 #define SRAM_10M_AMP2		0x8082
 #define SRAM_IMPEDANCE		0x8084
+#define SRAM_PHY_LOCK		0xb82e
 
 /* PLA_RCR */
 #define RCR_AAP			0x00000001
@@ -577,6 +579,9 @@ enum spd_duplex {
 /* OCP_PHY_PATCH_CMD */
 #define PATCH_REQUEST		BIT(4)
 
+/* OCP_PHY_LOCK */
+#define PATCH_LOCK		BIT(0)
+
 /* OCP_ADC_CFG */
 #define CKADSEL_L		0x0100
 #define ADC_EN			0x0080
@@ -601,6 +606,9 @@ enum spd_duplex {
 /* SRAM_IMPEDANCE */
 #define RX_DRIVING_MASK		0x6000
 
+/* SRAM_PHY_LOCK */
+#define PHY_PATCH_LOCK		0x0001
+
 /* MAC PASSTHRU */
 #define AD_MASK			0xfee0
 #define BND_MASK		0x0004
@@ -905,10 +913,65 @@ struct fw_mac {
 	char info[0];
 } __packed;
 
+/**
+ * struct fw_phy_patch_key - a firmware block used by RTL_FW_PHY_START.
+ *	This is used to set patch key when loading the firmware of PHY.
+ * @key_reg: the register to write the patch key.
+ * @key_data: patch key.
+ */
+struct fw_phy_patch_key {
+	struct fw_block blk_hdr;
+	__le16 key_reg;
+	__le16 key_data;
+	__le32 reserved;
+} __packed;
+
+/**
+ * struct fw_phy_nc - a firmware block used by RTL_FW_PHY_NC.
+ *	The layout of the firmware block is:
+ *	<struct fw_phy_nc> + <info> + <firmware data>.
+ * @fw_offset: offset of the firmware binary data. The start address of
+ *	the data would be the address of struct fw_phy_nc + @fw_offset.
+ * @fw_reg: the register to load the firmware. Depends on chip.
+ * @ba_reg: the register to write the base address. Depends on chip.
+ * @ba_data: base address. Depends on chip.
+ * @patch_en_addr: the register of enabling patch mode. Depends on chip.
+ * @patch_en_value: patch mode enabled mask. Depends on the firmware.
+ * @mode_reg: the regitster of switching the mode.
+ * @mod_pre: the mode needing to be set before loading the firmware.
+ * @mod_post: the mode to be set when finishing to load the firmware.
+ * @bp_start: the start register of break points. Depends on chip.
+ * @bp_num: the break point number which needs to be set for this firmware.
+ *	Depends on the firmware.
+ * @bp: break points. Depends on firmware.
+ * @info: additional information for debugging, and is followed by the
+ *	binary data of firmware.
+ */
+struct fw_phy_nc {
+	struct fw_block blk_hdr;
+	__le16 fw_offset;
+	__le16 fw_reg;
+	__le16 ba_reg;
+	__le16 ba_data;
+	__le16 patch_en_addr;
+	__le16 patch_en_value;
+	__le16 mode_reg;
+	__le16 mode_pre;
+	__le16 mode_post;
+	__le16 reserved;
+	__le16 bp_start;
+	__le16 bp_num;
+	__le16 bp[4];
+	char info[0];
+} __packed;
+
 enum rtl_fw_type {
 	RTL_FW_END = 0,
 	RTL_FW_PLA,
 	RTL_FW_USB,
+	RTL_FW_PHY_START,
+	RTL_FW_PHY_STOP,
+	RTL_FW_PHY_NC,
 };
 
 enum rtl_version {
@@ -3424,6 +3487,114 @@ static int r8153_patch_request(struct r8152 *tp, bool request)
 	}
 }
 
+static int r8153_pre_ram_code(struct r8152 *tp, u16 key_addr, u16 patch_key)
+{
+	if (r8153_patch_request(tp, true)) {
+		dev_err(&tp->intf->dev, "patch request fail\n");
+		return -ETIME;
+	}
+
+	sram_write(tp, key_addr, patch_key);
+	sram_write(tp, SRAM_PHY_LOCK, PHY_PATCH_LOCK);
+
+	return 0;
+}
+
+static int r8153_post_ram_code(struct r8152 *tp, u16 key_addr)
+{
+	u16 data;
+
+	sram_write(tp, 0x0000, 0x0000);
+
+	data = ocp_reg_read(tp, OCP_PHY_LOCK);
+	data &= ~PATCH_LOCK;
+	ocp_reg_write(tp, OCP_PHY_LOCK, data);
+
+	sram_write(tp, key_addr, 0x0000);
+
+	r8153_patch_request(tp, false);
+
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, tp->ocp_base);
+
+	return 0;
+}
+
+static bool rtl8152_is_fw_phy_nc_ok(struct r8152 *tp, struct fw_phy_nc *phy)
+{
+	u32 length;
+	u16 fw_offset, fw_reg, ba_reg, patch_en_addr, mode_reg, bp_start;
+	bool rc = false;
+
+	switch (tp->version) {
+	case RTL_VER_04:
+	case RTL_VER_05:
+	case RTL_VER_06:
+		fw_reg = 0xa014;
+		ba_reg = 0xa012;
+		patch_en_addr = 0xa01a;
+		mode_reg = 0xb820;
+		bp_start = 0xa000;
+		break;
+	default:
+		goto out;
+	}
+
+	fw_offset = __le16_to_cpu(phy->fw_offset);
+	if (fw_offset < sizeof(*phy)) {
+		dev_err(&tp->intf->dev, "fw_offset too small\n");
+		goto out;
+	}
+
+	length = __le32_to_cpu(phy->blk_hdr.length);
+	if (length < fw_offset) {
+		dev_err(&tp->intf->dev, "invalid fw_offset\n");
+		goto out;
+	}
+
+	length -= __le16_to_cpu(phy->fw_offset);
+	if (!length || (length & 1)) {
+		dev_err(&tp->intf->dev, "invalid block length\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(phy->fw_reg) != fw_reg) {
+		dev_err(&tp->intf->dev, "invalid register to load firmware\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(phy->ba_reg) != ba_reg) {
+		dev_err(&tp->intf->dev, "invalid base address register\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(phy->patch_en_addr) != patch_en_addr) {
+		dev_err(&tp->intf->dev,
+			"invalid patch mode enabled register\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(phy->mode_reg) != mode_reg) {
+		dev_err(&tp->intf->dev,
+			"invalid register to switch the mode\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(phy->bp_start) != bp_start) {
+		dev_err(&tp->intf->dev,
+			"invalid start register of break point\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(phy->bp_num) > 4) {
+		dev_err(&tp->intf->dev, "invalid break point number\n");
+		goto out;
+	}
+
+	rc = true;
+out:
+	return rc;
+}
+
 static bool rtl8152_is_fw_mac_ok(struct r8152 *tp, struct fw_mac *mac)
 {
 	u16 fw_reg, bp_ba_addr, bp_en_addr, bp_start, fw_offset;
@@ -3600,6 +3771,9 @@ static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
 	const struct firmware *fw = rtl_fw->fw;
 	struct fw_header *fw_hdr = (struct fw_header *)fw->data;
 	struct fw_mac *pla = NULL, *usb = NULL;
+	struct fw_phy_patch_key *start = NULL;
+	struct fw_phy_nc *phy_nc = NULL;
+	struct fw_block *stop = NULL;
 	long ret = -EFAULT;
 	int i;
 
@@ -3626,7 +3800,7 @@ static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
 		case RTL_FW_END:
 			if (__le32_to_cpu(block->length) != sizeof(*block))
 				goto fail;
-			goto success;
+			goto fw_end;
 		case RTL_FW_PLA:
 			if (pla) {
 				dev_err(&tp->intf->dev,
@@ -3654,6 +3828,57 @@ static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
 					"check USB firmware failed\n");
 				goto fail;
 			}
+			break;
+		case RTL_FW_PHY_START:
+			if (start || phy_nc || stop) {
+				dev_err(&tp->intf->dev,
+					"check PHY_START fail\n");
+				goto fail;
+			}
+
+			if (__le32_to_cpu(block->length) != sizeof(*start)) {
+				dev_err(&tp->intf->dev,
+					"Invalid length for PHY_START\n");
+				goto fail;
+			}
+
+			start = (struct fw_phy_patch_key *)block;
+			break;
+		case RTL_FW_PHY_STOP:
+			if (stop || !start) {
+				dev_err(&tp->intf->dev,
+					"Check PHY_STOP fail\n");
+				goto fail;
+			}
+
+			if (__le32_to_cpu(block->length) != sizeof(*block)) {
+				dev_err(&tp->intf->dev,
+					"Invalid length for PHY_STOP\n");
+				goto fail;
+			}
+
+			stop = block;
+			break;
+		case RTL_FW_PHY_NC:
+			if (!start || stop) {
+				dev_err(&tp->intf->dev,
+					"check PHY_NC fail\n");
+				goto fail;
+			}
+
+			if (phy_nc) {
+				dev_err(&tp->intf->dev,
+					"multiple PHY NC encountered\n");
+				goto fail;
+			}
+
+			phy_nc = (struct fw_phy_nc *)block;
+			if (!rtl8152_is_fw_phy_nc_ok(tp, phy_nc)) {
+				dev_err(&tp->intf->dev,
+					"check PHY NC firmware failed\n");
+				goto fail;
+			}
+
 			break;
 		default:
 			dev_warn(&tp->intf->dev, "Unknown type %u is found\n",
@@ -3665,12 +3890,52 @@ static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
 		i += ALIGN(__le32_to_cpu(block->length), 8);
 	}
 
-success:
+fw_end:
+	if ((phy_nc || start) && !stop) {
+		dev_err(&tp->intf->dev, "without PHY_STOP\n");
+		goto fail;
+	}
+
 	return 0;
 fail:
 	return ret;
 }
 
+static void rtl8152_fw_phy_nc_apply(struct r8152 *tp, struct fw_phy_nc *phy)
+{
+	u16 mode_reg, bp_index;
+	u32 length, i, num;
+	__le16 *data;
+
+	mode_reg = __le16_to_cpu(phy->mode_reg);
+	sram_write(tp, mode_reg, __le16_to_cpu(phy->mode_pre));
+	sram_write(tp, __le16_to_cpu(phy->ba_reg),
+		   __le16_to_cpu(phy->ba_data));
+
+	length = __le32_to_cpu(phy->blk_hdr.length);
+	length -= __le16_to_cpu(phy->fw_offset);
+	num = length / 2;
+	data = (__le16 *)((u8 *)phy + __le16_to_cpu(phy->fw_offset));
+
+	ocp_reg_write(tp, OCP_SRAM_ADDR, __le16_to_cpu(phy->fw_reg));
+	for (i = 0; i < num; i++)
+		ocp_reg_write(tp, OCP_SRAM_DATA, __le16_to_cpu(data[i]));
+
+	sram_write(tp, __le16_to_cpu(phy->patch_en_addr),
+		   __le16_to_cpu(phy->patch_en_value));
+
+	bp_index = __le16_to_cpu(phy->bp_start);
+	num = __le16_to_cpu(phy->bp_num);
+	for (i = 0; i < num; i++) {
+		sram_write(tp, bp_index, __le16_to_cpu(phy->bp[i]));
+		bp_index += 2;
+	}
+
+	sram_write(tp, mode_reg, __le16_to_cpu(phy->mode_post));
+
+	dev_dbg(&tp->intf->dev, "successfully applied %s\n", phy->info);
+}
+
 static void rtl8152_fw_mac_apply(struct r8152 *tp, struct fw_mac *mac)
 {
 	u16 bp_en_addr, bp_index, type, bp_num, fw_ver_reg;
@@ -3737,6 +4002,8 @@ static void rtl8152_apply_firmware(struct r8152 *tp)
 	struct rtl_fw *rtl_fw = &tp->rtl_fw;
 	const struct firmware *fw = rtl_fw->fw;
 	struct fw_header *fw_hdr = (struct fw_header *)fw->data;
+	struct fw_phy_patch_key *key;
+	u16 key_addr = 0;
 	int i;
 
 	if (IS_ERR_OR_NULL(rtl_fw->fw))
@@ -3755,6 +4022,19 @@ static void rtl8152_apply_firmware(struct r8152 *tp)
 		case RTL_FW_USB:
 			rtl8152_fw_mac_apply(tp, (struct fw_mac *)block);
 			break;
+		case RTL_FW_PHY_START:
+			key = (struct fw_phy_patch_key *)block;
+			key_addr = __le16_to_cpu(key->key_reg);
+			r8153_pre_ram_code(tp, key_addr,
+					   __le16_to_cpu(key->key_data));
+			break;
+		case RTL_FW_PHY_STOP:
+			WARN_ON(!key_addr);
+			r8153_post_ram_code(tp, key_addr);
+			break;
+		case RTL_FW_PHY_NC:
+			rtl8152_fw_phy_nc_apply(tp, (struct fw_phy_nc *)block);
+			break;
 		default:
 			break;
 		}
-- 
2.21.0

