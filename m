Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A9F33E8A
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 07:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFDFqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 01:46:54 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42030 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfFDFqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 01:46:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id o12so7246900wrj.9
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 22:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fax9k2lzQoJp12tuloyUGTNb1H9PvOkOB0OGDfVFtMQ=;
        b=ZutxyidRqqwh2KIDTDGEisup6pBJJLbWiiflMCiveApeYy4X8nNLRgNc6UwjSTXaF4
         L1C9Ni8XhhWgnPM7uV2G7/Hj0/bXU+CQd1Sspz1RNPen+uHYmeKrrkzaGRDBm2IkLYJb
         O0+aCXhxqJF5Yad9mg6XW4HvtI8ivBnUYexqs0h0ixSK7Rpb/4dfluoLUojfPEvptUkc
         SOs8lOJAU7WHFWk+fq4I1njcd2t6wxTdI2Q+md/lB0YqfAZete54vdrfHJu/b8OooqhC
         bPZWL5qIEejh3mR/Aj+uJs1+iDGeC5J8BdXIogcR8WVpLY3cdujGNqOrWOtBxreuxZi+
         NF1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fax9k2lzQoJp12tuloyUGTNb1H9PvOkOB0OGDfVFtMQ=;
        b=F/Nz6Eg1s1ci/M6oM3NkzDYRWVEI+GHJvROtcztqx8hGeOHJQWxg3rCUnvRBXphi8a
         I2fTxbJVsI8iMsdGcHXJ1+Da3UUyBo8G0C/V6yPler0wm91b0BpGa/+UwkqBoDaqddTB
         d3C/tSAPHNr7Wgrvlkj/sAQ5kFqdd9vgPuKoZ6U1OWc3dAQW8kH6SYsr3HlHP687HoJA
         Eb+UJdHKvgNKVQMmBPoUx5HjGhVCTMjgqpZHEEKswG7BveOznxzXmoI4nW+dO8ybb79P
         9+Du8PjhvQhV/lryPEpLL7+7KsvZ8GuL3f9HS156tFj48i4G3gD8+p/zP3YbV2eLUqBi
         Xrtw==
X-Gm-Message-State: APjAAAUu/TZlClh3MKeYzZ136rv3BU5JoWs/Ne9V+TdIL+USxx1DFFAo
        B3eL7/s1lTPGgveMEKv7FxNevVm4
X-Google-Smtp-Source: APXvYqx4f42JnZ2YHcJKdLJNRe7j1lHvEYCElebM5BzkgPeh0Sms4ZAwBGP9kfaFMLHm4QRTTa/iZQ==
X-Received: by 2002:adf:f003:: with SMTP id j3mr4867541wro.250.1559627211402;
        Mon, 03 Jun 2019 22:46:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:15c:4632:d703:a1f7? (p200300EA8BF3BD00015C4632D703A1F7.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:15c:4632:d703:a1f7])
        by smtp.googlemail.com with ESMTPSA id p2sm13133311wmp.40.2019.06.03.22.46.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 22:46:50 -0700 (PDT)
Subject: [PATCH net-next 2/2] r8169: factor out firmware handling
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <3e2e0491-8b0f-17e1-b163-e47fcb931eb5@gmail.com>
Message-ID: <80bdf40e-bfa9-dae4-2d30-29451e5b8e51@gmail.com>
Date:   Tue, 4 Jun 2019 07:46:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <3e2e0491-8b0f-17e1-b163-e47fcb931eb5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's factor out firmware handling into a separate source code file.
This simplifies reading the code and makes clearer what the interface
between driver and firmware handling is.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/Makefile         |   2 +-
 drivers/net/ethernet/realtek/r8169_firmware.c | 231 +++++++++++++++++
 drivers/net/ethernet/realtek/r8169_firmware.h |  39 +++
 drivers/net/ethernet/realtek/r8169_main.c     | 243 +-----------------
 4 files changed, 274 insertions(+), 241 deletions(-)
 create mode 100644 drivers/net/ethernet/realtek/r8169_firmware.c
 create mode 100644 drivers/net/ethernet/realtek/r8169_firmware.h

diff --git a/drivers/net/ethernet/realtek/Makefile b/drivers/net/ethernet/realtek/Makefile
index c36cd2167..d5304bad2 100644
--- a/drivers/net/ethernet/realtek/Makefile
+++ b/drivers/net/ethernet/realtek/Makefile
@@ -6,5 +6,5 @@
 obj-$(CONFIG_8139CP) += 8139cp.o
 obj-$(CONFIG_8139TOO) += 8139too.o
 obj-$(CONFIG_ATP) += atp.o
-r8169-objs += r8169_main.o
+r8169-objs += r8169_main.o r8169_firmware.o
 obj-$(CONFIG_R8169) += r8169.o
diff --git a/drivers/net/ethernet/realtek/r8169_firmware.c b/drivers/net/ethernet/realtek/r8169_firmware.c
new file mode 100644
index 000000000..8f54a2c83
--- /dev/null
+++ b/drivers/net/ethernet/realtek/r8169_firmware.c
@@ -0,0 +1,231 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* r8169_firmware.c: RealTek 8169/8168/8101 ethernet driver.
+ *
+ * Copyright (c) 2002 ShuChen <shuchen@realtek.com.tw>
+ * Copyright (c) 2003 - 2007 Francois Romieu <romieu@fr.zoreil.com>
+ * Copyright (c) a lot of people too. Please respect their work.
+ *
+ * See MAINTAINERS file for support contact information.
+ */
+
+#include <linux/delay.h>
+#include <linux/firmware.h>
+
+#include "r8169_firmware.h"
+
+enum rtl_fw_opcode {
+	PHY_READ		= 0x0,
+	PHY_DATA_OR		= 0x1,
+	PHY_DATA_AND		= 0x2,
+	PHY_BJMPN		= 0x3,
+	PHY_MDIO_CHG		= 0x4,
+	PHY_CLEAR_READCOUNT	= 0x7,
+	PHY_WRITE		= 0x8,
+	PHY_READCOUNT_EQ_SKIP	= 0x9,
+	PHY_COMP_EQ_SKIPN	= 0xa,
+	PHY_COMP_NEQ_SKIPN	= 0xb,
+	PHY_WRITE_PREVIOUS	= 0xc,
+	PHY_SKIPN		= 0xd,
+	PHY_DELAY_MS		= 0xe,
+};
+
+struct fw_info {
+	u32	magic;
+	char	version[RTL_VER_SIZE];
+	__le32	fw_start;
+	__le32	fw_len;
+	u8	chksum;
+} __packed;
+
+#define FW_OPCODE_SIZE	sizeof(typeof(*((struct rtl_fw_phy_action *)0)->code))
+
+static bool rtl_fw_format_ok(struct rtl_fw *rtl_fw)
+{
+	const struct firmware *fw = rtl_fw->fw;
+	struct fw_info *fw_info = (struct fw_info *)fw->data;
+	struct rtl_fw_phy_action *pa = &rtl_fw->phy_action;
+
+	if (fw->size < FW_OPCODE_SIZE)
+		return false;
+
+	if (!fw_info->magic) {
+		size_t i, size, start;
+		u8 checksum = 0;
+
+		if (fw->size < sizeof(*fw_info))
+			return false;
+
+		for (i = 0; i < fw->size; i++)
+			checksum += fw->data[i];
+		if (checksum != 0)
+			return false;
+
+		start = le32_to_cpu(fw_info->fw_start);
+		if (start > fw->size)
+			return false;
+
+		size = le32_to_cpu(fw_info->fw_len);
+		if (size > (fw->size - start) / FW_OPCODE_SIZE)
+			return false;
+
+		strscpy(rtl_fw->version, fw_info->version, RTL_VER_SIZE);
+
+		pa->code = (__le32 *)(fw->data + start);
+		pa->size = size;
+	} else {
+		if (fw->size % FW_OPCODE_SIZE)
+			return false;
+
+		strscpy(rtl_fw->version, rtl_fw->fw_name, RTL_VER_SIZE);
+
+		pa->code = (__le32 *)fw->data;
+		pa->size = fw->size / FW_OPCODE_SIZE;
+	}
+
+	return true;
+}
+
+static bool rtl_fw_data_ok(struct rtl_fw *rtl_fw)
+{
+	struct rtl_fw_phy_action *pa = &rtl_fw->phy_action;
+	size_t index;
+
+	for (index = 0; index < pa->size; index++) {
+		u32 action = le32_to_cpu(pa->code[index]);
+		u32 regno = (action & 0x0fff0000) >> 16;
+
+		switch (action >> 28) {
+		case PHY_READ:
+		case PHY_DATA_OR:
+		case PHY_DATA_AND:
+		case PHY_MDIO_CHG:
+		case PHY_CLEAR_READCOUNT:
+		case PHY_WRITE:
+		case PHY_WRITE_PREVIOUS:
+		case PHY_DELAY_MS:
+			break;
+
+		case PHY_BJMPN:
+			if (regno > index)
+				goto out;
+			break;
+		case PHY_READCOUNT_EQ_SKIP:
+			if (index + 2 >= pa->size)
+				goto out;
+			break;
+		case PHY_COMP_EQ_SKIPN:
+		case PHY_COMP_NEQ_SKIPN:
+		case PHY_SKIPN:
+			if (index + 1 + regno >= pa->size)
+				goto out;
+			break;
+
+		default:
+			dev_err(rtl_fw->dev, "Invalid action 0x%08x\n", action);
+			return false;
+		}
+	}
+
+	return true;
+out:
+	dev_err(rtl_fw->dev, "Out of range of firmware\n");
+	return false;
+}
+
+void rtl_fw_write_firmware(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
+{
+	struct rtl_fw_phy_action *pa = &rtl_fw->phy_action;
+	rtl_fw_write_t fw_write = rtl_fw->phy_write;
+	rtl_fw_read_t fw_read = rtl_fw->phy_read;
+	int predata = 0, count = 0;
+	size_t index;
+
+	for (index = 0; index < pa->size; index++) {
+		u32 action = le32_to_cpu(pa->code[index]);
+		u32 data = action & 0x0000ffff;
+		u32 regno = (action & 0x0fff0000) >> 16;
+		enum rtl_fw_opcode opcode = action >> 28;
+
+		if (!action)
+			break;
+
+		switch (opcode) {
+		case PHY_READ:
+			predata = fw_read(tp, regno);
+			count++;
+			break;
+		case PHY_DATA_OR:
+			predata |= data;
+			break;
+		case PHY_DATA_AND:
+			predata &= data;
+			break;
+		case PHY_BJMPN:
+			index -= (regno + 1);
+			break;
+		case PHY_MDIO_CHG:
+			if (data == 0) {
+				fw_write = rtl_fw->phy_write;
+				fw_read = rtl_fw->phy_read;
+			} else if (data == 1) {
+				fw_write = rtl_fw->mac_mcu_write;
+				fw_read = rtl_fw->mac_mcu_read;
+			}
+
+			break;
+		case PHY_CLEAR_READCOUNT:
+			count = 0;
+			break;
+		case PHY_WRITE:
+			fw_write(tp, regno, data);
+			break;
+		case PHY_READCOUNT_EQ_SKIP:
+			if (count == data)
+				index++;
+			break;
+		case PHY_COMP_EQ_SKIPN:
+			if (predata == data)
+				index += regno;
+			break;
+		case PHY_COMP_NEQ_SKIPN:
+			if (predata != data)
+				index += regno;
+			break;
+		case PHY_WRITE_PREVIOUS:
+			fw_write(tp, regno, predata);
+			break;
+		case PHY_SKIPN:
+			index += regno;
+			break;
+		case PHY_DELAY_MS:
+			mdelay(data);
+			break;
+		}
+	}
+}
+
+void rtl_fw_release_firmware(struct rtl_fw *rtl_fw)
+{
+	release_firmware(rtl_fw->fw);
+}
+
+int rtl_fw_request_firmware(struct rtl_fw *rtl_fw)
+{
+	int rc;
+
+	rc = request_firmware(&rtl_fw->fw, rtl_fw->fw_name, rtl_fw->dev);
+	if (rc < 0)
+		goto out;
+
+	if (!rtl_fw_format_ok(rtl_fw) || !rtl_fw_data_ok(rtl_fw)) {
+		release_firmware(rtl_fw->fw);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	return 0;
+out:
+	dev_err(rtl_fw->dev, "Unable to load firmware %s (%d)\n",
+		rtl_fw->fw_name, rc);
+	return rc;
+}
diff --git a/drivers/net/ethernet/realtek/r8169_firmware.h b/drivers/net/ethernet/realtek/r8169_firmware.h
new file mode 100644
index 000000000..7dc348ed8
--- /dev/null
+++ b/drivers/net/ethernet/realtek/r8169_firmware.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* r8169_firmware.h: RealTek 8169/8168/8101 ethernet driver.
+ *
+ * Copyright (c) 2002 ShuChen <shuchen@realtek.com.tw>
+ * Copyright (c) 2003 - 2007 Francois Romieu <romieu@fr.zoreil.com>
+ * Copyright (c) a lot of people too. Please respect their work.
+ *
+ * See MAINTAINERS file for support contact information.
+ */
+
+#include <linux/device.h>
+#include <linux/firmware.h>
+
+struct rtl8169_private;
+typedef void (*rtl_fw_write_t)(struct rtl8169_private *tp, int reg, int val);
+typedef int (*rtl_fw_read_t)(struct rtl8169_private *tp, int reg);
+
+#define RTL_VER_SIZE		32
+
+struct rtl_fw {
+	rtl_fw_write_t phy_write;
+	rtl_fw_read_t phy_read;
+	rtl_fw_write_t mac_mcu_write;
+	rtl_fw_read_t mac_mcu_read;
+	const struct firmware *fw;
+	const char *fw_name;
+	struct device *dev;
+
+	char version[RTL_VER_SIZE];
+
+	struct rtl_fw_phy_action {
+		__le32 *code;
+		size_t size;
+	} phy_action;
+};
+
+int rtl_fw_request_firmware(struct rtl_fw *rtl_fw);
+void rtl_fw_release_firmware(struct rtl_fw *rtl_fw);
+void rtl_fw_write_firmware(struct rtl8169_private *tp, struct rtl_fw *rtl_fw);
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4c8ef7bb9..d34cc855f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -27,12 +27,13 @@
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
-#include <linux/firmware.h>
 #include <linux/prefetch.h>
 #include <linux/pci-aspm.h>
 #include <linux/ipv6.h>
 #include <net/ip6_checksum.h>
 
+#include "r8169_firmware.h"
+
 #define MODULENAME "r8169"
 
 #define FIRMWARE_8168D_1	"rtl_nic/rtl8168d-1.fw"
@@ -626,10 +627,6 @@ struct rtl8169_stats {
 	struct u64_stats_sync	syncp;
 };
 
-struct rtl8169_private;
-typedef void (*rtl_fw_write_t)(struct rtl8169_private *tp, int reg, int val);
-typedef int (*rtl_fw_read_t)(struct rtl8169_private *tp, int reg);
-
 struct rtl8169_private {
 	void __iomem *mmio_addr;	/* memory map physical address */
 	struct pci_dev *pci_dev;
@@ -671,24 +668,7 @@ struct rtl8169_private {
 	u32 saved_wolopts;
 
 	const char *fw_name;
-	struct rtl_fw {
-		rtl_fw_write_t phy_write;
-		rtl_fw_read_t phy_read;
-		rtl_fw_write_t mac_mcu_write;
-		rtl_fw_read_t mac_mcu_read;
-		const struct firmware *fw;
-		const char *fw_name;
-		struct device *dev;
-
-#define RTL_VER_SIZE		32
-
-		char version[RTL_VER_SIZE];
-
-		struct rtl_fw_phy_action {
-			__le32 *code;
-			size_t size;
-		} phy_action;
-	} *rtl_fw;
+	struct rtl_fw *rtl_fw;
 
 	u32 ocp_base;
 };
@@ -2300,203 +2280,6 @@ static void __rtl_writephy_batch(struct rtl8169_private *tp,
 
 #define rtl_writephy_batch(tp, a) __rtl_writephy_batch(tp, a, ARRAY_SIZE(a))
 
-enum rtl_fw_opcode {
-	PHY_READ 		= 0x0,
-	PHY_DATA_OR		= 0x1,
-	PHY_DATA_AND		= 0x2,
-	PHY_BJMPN		= 0x3,
-	PHY_MDIO_CHG		= 0x4,
-	PHY_CLEAR_READCOUNT	= 0x7,
-	PHY_WRITE		= 0x8,
-	PHY_READCOUNT_EQ_SKIP	= 0x9,
-	PHY_COMP_EQ_SKIPN	= 0xa,
-	PHY_COMP_NEQ_SKIPN	= 0xb,
-	PHY_WRITE_PREVIOUS	= 0xc,
-	PHY_SKIPN		= 0xd,
-	PHY_DELAY_MS		= 0xe,
-};
-
-struct fw_info {
-	u32	magic;
-	char	version[RTL_VER_SIZE];
-	__le32	fw_start;
-	__le32	fw_len;
-	u8	chksum;
-} __packed;
-
-#define FW_OPCODE_SIZE	sizeof(typeof(*((struct rtl_fw_phy_action *)0)->code))
-
-static bool rtl_fw_format_ok(struct rtl_fw *rtl_fw)
-{
-	const struct firmware *fw = rtl_fw->fw;
-	struct fw_info *fw_info = (struct fw_info *)fw->data;
-	struct rtl_fw_phy_action *pa = &rtl_fw->phy_action;
-
-	if (fw->size < FW_OPCODE_SIZE)
-		return false;
-
-	if (!fw_info->magic) {
-		size_t i, size, start;
-		u8 checksum = 0;
-
-		if (fw->size < sizeof(*fw_info))
-			return false;
-
-		for (i = 0; i < fw->size; i++)
-			checksum += fw->data[i];
-		if (checksum != 0)
-			return false;
-
-		start = le32_to_cpu(fw_info->fw_start);
-		if (start > fw->size)
-			return false;
-
-		size = le32_to_cpu(fw_info->fw_len);
-		if (size > (fw->size - start) / FW_OPCODE_SIZE)
-			return false;
-
-		strscpy(rtl_fw->version, fw_info->version, RTL_VER_SIZE);
-
-		pa->code = (__le32 *)(fw->data + start);
-		pa->size = size;
-	} else {
-		if (fw->size % FW_OPCODE_SIZE)
-			return false;
-
-		strscpy(rtl_fw->version, rtl_fw->fw_name, RTL_VER_SIZE);
-
-		pa->code = (__le32 *)fw->data;
-		pa->size = fw->size / FW_OPCODE_SIZE;
-	}
-
-	return true;
-}
-
-static bool rtl_fw_data_ok(struct rtl_fw *rtl_fw)
-{
-	struct rtl_fw_phy_action *pa = &rtl_fw->phy_action;
-	size_t index;
-
-	for (index = 0; index < pa->size; index++) {
-		u32 action = le32_to_cpu(pa->code[index]);
-		u32 regno = (action & 0x0fff0000) >> 16;
-
-		switch (action >> 28) {
-		case PHY_READ:
-		case PHY_DATA_OR:
-		case PHY_DATA_AND:
-		case PHY_MDIO_CHG:
-		case PHY_CLEAR_READCOUNT:
-		case PHY_WRITE:
-		case PHY_WRITE_PREVIOUS:
-		case PHY_DELAY_MS:
-			break;
-
-		case PHY_BJMPN:
-			if (regno > index)
-				goto out;
-			break;
-		case PHY_READCOUNT_EQ_SKIP:
-			if (index + 2 >= pa->size)
-				goto out;
-			break;
-		case PHY_COMP_EQ_SKIPN:
-		case PHY_COMP_NEQ_SKIPN:
-		case PHY_SKIPN:
-			if (index + 1 + regno >= pa->size)
-				goto out;
-			break;
-
-		default:
-			dev_err(rtl_fw->dev, "Invalid action 0x%08x\n", action);
-			return false;
-		}
-	}
-
-	return true;
-out:
-	dev_err(rtl_fw->dev, "Out of range of firmware\n");
-	return false;
-}
-
-static void rtl_fw_write_firmware(struct rtl8169_private *tp,
-				  struct rtl_fw *rtl_fw)
-{
-	struct rtl_fw_phy_action *pa = &rtl_fw->phy_action;
-	rtl_fw_write_t fw_write = rtl_fw->phy_write;
-	rtl_fw_read_t fw_read = rtl_fw->phy_read;
-	int predata = 0, count = 0;
-	size_t index;
-
-	for (index = 0; index < pa->size; index++) {
-		u32 action = le32_to_cpu(pa->code[index]);
-		u32 data = action & 0x0000ffff;
-		u32 regno = (action & 0x0fff0000) >> 16;
-		enum rtl_fw_opcode opcode = action >> 28;
-
-		if (!action)
-			break;
-
-		switch (opcode) {
-		case PHY_READ:
-			predata = fw_read(tp, regno);
-			count++;
-			break;
-		case PHY_DATA_OR:
-			predata |= data;
-			break;
-		case PHY_DATA_AND:
-			predata &= data;
-			break;
-		case PHY_BJMPN:
-			index -= (regno + 1);
-			break;
-		case PHY_MDIO_CHG:
-			if (data == 0) {
-				fw_write = rtl_fw->phy_write;
-				fw_read = rtl_fw->phy_read;
-			} else if (data == 1) {
-				fw_write = rtl_fw->mac_mcu_write;
-				fw_read = rtl_fw->mac_mcu_read;
-			}
-
-			break;
-		case PHY_CLEAR_READCOUNT:
-			count = 0;
-			break;
-		case PHY_WRITE:
-			fw_write(tp, regno, data);
-			break;
-		case PHY_READCOUNT_EQ_SKIP:
-			if (count == data)
-				index++;
-			break;
-		case PHY_COMP_EQ_SKIPN:
-			if (predata == data)
-				index += regno;
-			break;
-		case PHY_COMP_NEQ_SKIPN:
-			if (predata != data)
-				index += regno;
-			break;
-		case PHY_WRITE_PREVIOUS:
-			fw_write(tp, regno, predata);
-			break;
-		case PHY_SKIPN:
-			index += regno;
-			break;
-		case PHY_DELAY_MS:
-			mdelay(data);
-			break;
-		}
-	}
-}
-
-static void rtl_fw_release_firmware(struct rtl_fw *rtl_fw)
-{
-	release_firmware(rtl_fw->fw);
-}
-
 static void rtl_release_firmware(struct rtl8169_private *tp)
 {
 	if (tp->rtl_fw) {
@@ -4254,26 +4037,6 @@ static void rtl_hw_reset(struct rtl8169_private *tp)
 	rtl_udelay_loop_wait_low(tp, &rtl_chipcmd_cond, 100, 100);
 }
 
-static int rtl_fw_request_firmware(struct rtl_fw *rtl_fw)
-{
-	int rc;
-
-	rc = request_firmware(&rtl_fw->fw, rtl_fw->fw_name, rtl_fw->dev);
-	if (rc < 0)
-		goto out;
-
-	if (!rtl_fw_format_ok(rtl_fw) || !rtl_fw_data_ok(rtl_fw)) {
-		release_firmware(rtl_fw->fw);
-		goto out;
-	}
-
-	return 0;
-out:
-	dev_err(rtl_fw->dev, "Unable to load firmware %s (%d)\n",
-		rtl_fw->fw_name, rc);
-	return rc;
-}
-
 static void rtl_request_firmware(struct rtl8169_private *tp)
 {
 	struct rtl_fw *rtl_fw;
-- 
2.21.0


