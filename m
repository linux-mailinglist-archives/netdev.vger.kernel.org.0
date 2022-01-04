Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EB7483C5F
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbiADH2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbiADH2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 02:28:42 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0360C061761;
        Mon,  3 Jan 2022 23:28:41 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id F365D422CC;
        Tue,  4 Jan 2022 07:28:32 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH v2 07/35] brcmfmac: pcie: Read Apple OTP information
Date:   Tue,  4 Jan 2022 16:26:30 +0900
Message-Id: <20220104072658.69756-8-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st>
References: <20220104072658.69756-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Apple platforms, the One Time Programmable ROM in the Broadcom chips
contains information about the specific board design (module, vendor,
version) that is required to select the correct NVRAM file. Parse this
OTP ROM and extract the required strings.

Note that the user OTP offset/size is per-chip. This patch does not add
any chips yet.

Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 219 ++++++++++++++++++
 include/linux/bcma/bcma_driver_chipcommon.h   |   1 +
 2 files changed, 220 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index a52a6f8081eb..74c9a4f74813 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -255,6 +255,15 @@ struct brcmf_pcie_core_info {
 	u32 wrapbase;
 };
 
+#define BRCMF_OTP_MAX_PARAM_LEN 16
+
+struct brcmf_otp_params {
+	char module[BRCMF_OTP_MAX_PARAM_LEN];
+	char vendor[BRCMF_OTP_MAX_PARAM_LEN];
+	char version[BRCMF_OTP_MAX_PARAM_LEN];
+	bool valid;
+};
+
 struct brcmf_pciedev_info {
 	enum brcmf_pcie_state state;
 	bool in_irq;
@@ -282,6 +291,7 @@ struct brcmf_pciedev_info {
 	void (*write_ptr)(struct brcmf_pciedev_info *devinfo, u32 mem_offset,
 			  u16 value);
 	struct brcmf_mp_device *settings;
+	struct brcmf_otp_params otp;
 };
 
 struct brcmf_pcie_ringbuf {
@@ -353,6 +363,14 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
 static struct brcmf_fw_request *
 brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo);
 
+static u16
+brcmf_pcie_read_reg16(struct brcmf_pciedev_info *devinfo, u32 reg_offset)
+{
+	void __iomem *address = devinfo->regs + reg_offset;
+
+	return ioread16(address);
+}
+
 static u32
 brcmf_pcie_read_reg32(struct brcmf_pciedev_info *devinfo, u32 reg_offset)
 {
@@ -539,6 +557,8 @@ brcmf_pcie_copy_dev_tomem(struct brcmf_pciedev_info *devinfo, u32 mem_offset,
 }
 
 
+#define READCC32(devinfo, reg) brcmf_pcie_read_reg32(devinfo, \
+		CHIPCREGOFFS(reg))
 #define WRITECC32(devinfo, reg, value) brcmf_pcie_write_reg32(devinfo, \
 		CHIPCREGOFFS(reg), value)
 
@@ -1758,6 +1778,199 @@ static const struct brcmf_buscore_ops brcmf_pcie_buscore_ops = {
 	.write32 = brcmf_pcie_buscore_write32,
 };
 
+#define BRCMF_OTP_SYS_VENDOR	0x15
+#define BRCMF_OTP_BRCM_CIS	0x80
+
+#define BRCMF_OTP_VENDOR_HDR	0x00000008
+
+static int
+brcmf_pcie_parse_otp_sys_vendor(struct brcmf_pciedev_info *devinfo,
+				u8 *data, size_t size)
+{
+	int idx = 4;
+	const char *chip_params;
+	const char *board_params;
+	const char *p;
+
+	/* 4-byte header and two empty strings */
+	if (size < 6)
+		return -EINVAL;
+
+	if (get_unaligned_le32(data) != BRCMF_OTP_VENDOR_HDR)
+		return -EINVAL;
+
+	chip_params = &data[idx];
+
+	/* Skip first string, including terminator */
+	idx += strnlen(chip_params, size - idx) + 1;
+	if (idx >= size)
+		return -EINVAL;
+
+	board_params = &data[idx];
+
+	/* Skip to terminator of second string */
+	idx += strnlen(board_params, size - idx);
+	if (idx >= size)
+		return -EINVAL;
+
+	/* At this point both strings are guaranteed NUL-terminated */
+	brcmf_dbg(PCIE, "OTP: chip_params='%s' board_params='%s'\n",
+		  chip_params, board_params);
+
+	p = board_params;
+	while (*p) {
+		char tag = *p++;
+		const char *end;
+		size_t len;
+
+		if (tag == ' ') /* Skip extra spaces */
+			continue;
+
+		if (*p++ != '=') /* implicit NUL check */
+			return -EINVAL;
+
+		/* *p might be NUL here, if so end == p and len == 0 */
+		end = strchrnul(p, ' ');
+		len = end - p;
+
+		/* leave 1 byte for NUL in destination string */
+		if (len > (BRCMF_OTP_MAX_PARAM_LEN - 1))
+			return -EINVAL;
+
+		/* Copy len characters plus a NUL terminator */
+		switch (tag) {
+		case 'M':
+			strscpy(devinfo->otp.module, p, len + 1);
+			break;
+		case 'V':
+			strscpy(devinfo->otp.vendor, p, len + 1);
+			break;
+		case 'm':
+			strscpy(devinfo->otp.version, p, len + 1);
+			break;
+		}
+
+		/* Skip to space separator or NUL */
+		p = end;
+	}
+
+	brcmf_dbg(PCIE, "OTP: module=%s vendor=%s version=%s\n",
+		  devinfo->otp.module, devinfo->otp.vendor,
+		  devinfo->otp.version);
+
+	if (!devinfo->otp.module ||
+	    !devinfo->otp.vendor ||
+	    !devinfo->otp.version)
+		return -EINVAL;
+
+	devinfo->otp.valid = true;
+	return 0;
+}
+
+static int
+brcmf_pcie_parse_otp(struct brcmf_pciedev_info *devinfo, u8 *otp, size_t size)
+{
+	int p = 0;
+	int ret = -1;
+
+	brcmf_dbg(PCIE, "parse_otp size=%ld\n", size);
+
+	while (p < (size - 1)) {
+		u8 type = otp[p];
+		u8 length = otp[p + 1];
+
+		if (type == 0)
+			break;
+
+		if ((p + 2 + length) > size)
+			break;
+
+		switch (type) {
+		case BRCMF_OTP_SYS_VENDOR:
+			brcmf_dbg(PCIE, "OTP @ 0x%x (0x%x): SYS_VENDOR\n",
+				  p, length);
+			ret = brcmf_pcie_parse_otp_sys_vendor(devinfo,
+							      &otp[p + 2],
+							      length);
+			break;
+		case BRCMF_OTP_BRCM_CIS:
+			brcmf_dbg(PCIE, "OTP @ 0x%x (0x%x): BRCM_CIS\n",
+				  p, length);
+			break;
+		default:
+			brcmf_dbg(PCIE, "OTP @ 0x%x (0x%x): Unknown type 0x%x\n",
+				  p, length, type);
+			break;
+		}
+
+		p += 2 + length;
+	}
+
+	return ret;
+}
+
+static int brcmf_pcie_read_otp(struct brcmf_pciedev_info *devinfo)
+{
+	const struct pci_dev *pdev = devinfo->pdev;
+	struct brcmf_bus *bus = dev_get_drvdata(&pdev->dev);
+	u32 coreid, base, words, idx, sromctl;
+	u16 *otp;
+	struct brcmf_core *core;
+	int ret;
+
+	switch (devinfo->ci->chip) {
+	default:
+		/* OTP not supported on this chip */
+		return 0;
+	}
+
+	core = brcmf_chip_get_core(devinfo->ci, coreid);
+	if (!core) {
+		brcmf_err(bus, "No OTP core\n");
+		return -ENODEV;
+	}
+
+	if (coreid == BCMA_CORE_CHIPCOMMON) {
+		/* Chips with OTP accessed via ChipCommon need additional
+		 * handling to access the OTP
+		 */
+		brcmf_pcie_select_core(devinfo, coreid);
+		sromctl = READCC32(devinfo, sromcontrol);
+
+		if (!(sromctl & BCMA_CC_SROM_CONTROL_OTP_PRESENT)) {
+			/* Chip lacks OTP, try without it... */
+			brcmf_err(bus,
+				  "OTP unavailable, using default firmware\n");
+			return 0;
+		}
+
+		/* Map OTP to shadow area */
+		WRITECC32(devinfo, sromcontrol,
+			  sromctl | BCMA_CC_SROM_CONTROL_OTPSEL);
+	}
+
+	otp = kzalloc(sizeof(u16) * words, GFP_KERNEL);
+
+	/* Map bus window to SROM/OTP shadow area in core */
+	base = brcmf_pcie_buscore_prep_addr(devinfo->pdev, base + core->base);
+
+	brcmf_dbg(PCIE, "OTP data:\n");
+	for (idx = 0; idx < words; idx++) {
+		otp[idx] = brcmf_pcie_read_reg16(devinfo, base + 2 * idx);
+		brcmf_dbg(PCIE, "[%8x] 0x%04x\n", base + 2 * idx, otp[idx]);
+	}
+
+	if (coreid == BCMA_CORE_CHIPCOMMON) {
+		brcmf_pcie_select_core(devinfo, coreid);
+		WRITECC32(devinfo, sromcontrol, sromctl);
+	}
+
+	ret = brcmf_pcie_parse_otp(devinfo, (u8 *)otp, 2 * words);
+	kfree(otp);
+
+	return ret;
+}
+
 #define BRCMF_PCIE_FW_CODE	0
 #define BRCMF_PCIE_FW_NVRAM	1
 #define BRCMF_PCIE_FW_CLM	2
@@ -1955,6 +2168,12 @@ brcmf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto fail_bus;
 
+	ret = brcmf_pcie_read_otp(devinfo);
+	if (ret) {
+		brcmf_err(bus, "failed to parse OTP\n");
+		goto fail_brcmf;
+	}
+
 	fwreq = brcmf_pcie_prepare_fw_request(devinfo);
 	if (!fwreq) {
 		ret = -ENOMEM;
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index d35b9206096d..c91db7460190 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -270,6 +270,7 @@
 #define  BCMA_CC_SROM_CONTROL_OP_WRDIS	0x40000000
 #define  BCMA_CC_SROM_CONTROL_OP_WREN	0x60000000
 #define  BCMA_CC_SROM_CONTROL_OTPSEL	0x00000010
+#define  BCMA_CC_SROM_CONTROL_OTP_PRESENT	0x00000020
 #define  BCMA_CC_SROM_CONTROL_LOCK	0x00000008
 #define  BCMA_CC_SROM_CONTROL_SIZE_MASK	0x00000006
 #define  BCMA_CC_SROM_CONTROL_SIZE_1K	0x00000000
-- 
2.33.0

