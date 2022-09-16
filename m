Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746F45BB0BE
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiIPQDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiIPQCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:02:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7516B56F1;
        Fri, 16 Sep 2022 09:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=q2B4e2Yl5JI9c7GcwkHC7CEN29XU0TUjbG9EmvqhnvM=; b=oQixZ3YVrRF9z4yMCiLM+eSC6u
        pxRtUj71H7UE4YwG9YubCZhX5QeXZ2nXtO8mNMPFVi2d7EpFumG64akrIKUzF47g/v74bRSdNiZrk
        ynkPoFHy3QySuDf7Cow7P/crkkYSPqSOIdkUhWgoYZFlTS+nNTyb1dhWNEkIfvMlNybyolQEQ/0ls
        Ora7Kg6czuwadi+jGXsh7p3yguLLj8A0/Xc/XAdPGeEDsbHKg5Os7JgVE7qOG+MHULtZAbimONrTc
        BuCnnYmx39/RjxkIUA1iQDEgGdrx+5kk42FHcnPMezRRI0in0OXo/n0eXX8v8AhTfmcp6lkAHAeaI
        jVeOA+Tw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:40116 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oZDnj-0006uJ-7X; Fri, 16 Sep 2022 17:02:47 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oZDni-0077aM-I6; Fri, 16 Sep 2022 17:02:46 +0100
In-Reply-To: <YySd3pASZKUh4leX@shell.armlinux.org.uk>
References: <YySd3pASZKUh4leX@shell.armlinux.org.uk>
From:   Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc:     Alyssa Rosenzweig <alyssa@rosenzweig.io>, asahi@lists.linux.dev,
        brcm80211-dev-list.pdl@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafa__ Mi__ecki" <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        SHA-cyfmac-dev-list@infineon.com, Sven Peter <sven@svenpeter.dev>
Subject: [PATCH wireless-next v3 05/12] brcmfmac: pcie: Read Apple OTP
 information
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oZDni-0077aM-I6@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 16 Sep 2022 17:02:46 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

On Apple platforms, the One Time Programmable ROM in the Broadcom chips
contains information about the specific board design (module, vendor,
version) that is required to select the correct NVRAM file. Parse this
OTP ROM and extract the required strings.

Note that the user OTP offset/size is per-chip. This patch does not add
any chips yet.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 218 ++++++++++++++++++
 include/linux/bcma/bcma_driver_chipcommon.h   |   1 +
 2 files changed, 219 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 2a74c9d8d46a..76ca835378bb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -256,6 +256,15 @@ struct brcmf_pcie_core_info {
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
@@ -283,6 +292,7 @@ struct brcmf_pciedev_info {
 	void (*write_ptr)(struct brcmf_pciedev_info *devinfo, u32 mem_offset,
 			  u16 value);
 	struct brcmf_mp_device *settings;
+	struct brcmf_otp_params otp;
 };
 
 struct brcmf_pcie_ringbuf {
@@ -354,6 +364,14 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
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
@@ -499,6 +517,8 @@ brcmf_pcie_copy_dev_tomem(struct brcmf_pciedev_info *devinfo, u32 mem_offset,
 }
 
 
+#define READCC32(devinfo, reg) brcmf_pcie_read_reg32(devinfo, \
+		CHIPCREGOFFS(reg))
 #define WRITECC32(devinfo, reg, value) brcmf_pcie_write_reg32(devinfo, \
 		CHIPCREGOFFS(reg), value)
 
@@ -1734,6 +1754,198 @@ static const struct brcmf_buscore_ops brcmf_pcie_buscore_ops = {
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
+	p = skip_spaces(board_params);
+	while (*p) {
+		char tag = *p++;
+		const char *end;
+		size_t len;
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
+		/* Skip to next arg, if any */
+		p = skip_spaces(end);
+	}
+
+	brcmf_dbg(PCIE, "OTP: module=%s vendor=%s version=%s\n",
+		  devinfo->otp.module, devinfo->otp.vendor,
+		  devinfo->otp.version);
+
+	if (!devinfo->otp.module[0] ||
+	    !devinfo->otp.vendor[0] ||
+	    !devinfo->otp.version[0])
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
+	int ret = -EINVAL;
+
+	brcmf_dbg(PCIE, "parse_otp size=%zd\n", size);
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
+			brcmf_dbg(PCIE, "OTP @ 0x%x (%d): SYS_VENDOR\n",
+				  p, length);
+			ret = brcmf_pcie_parse_otp_sys_vendor(devinfo,
+							      &otp[p + 2],
+							      length);
+			break;
+		case BRCMF_OTP_BRCM_CIS:
+			brcmf_dbg(PCIE, "OTP @ 0x%x (%d): BRCM_CIS\n",
+				  p, length);
+			break;
+		default:
+			brcmf_dbg(PCIE, "OTP @ 0x%x (%d): Unknown type 0x%x\n",
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
+	otp = kcalloc(words, sizeof(u16), GFP_KERNEL);
+	if (!otp)
+		return -ENOMEM;
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
@@ -1930,6 +2142,12 @@ brcmf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
index e3314f746bfa..2d94c30ed439 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -271,6 +271,7 @@
 #define  BCMA_CC_SROM_CONTROL_OP_WRDIS	0x40000000
 #define  BCMA_CC_SROM_CONTROL_OP_WREN	0x60000000
 #define  BCMA_CC_SROM_CONTROL_OTPSEL	0x00000010
+#define  BCMA_CC_SROM_CONTROL_OTP_PRESENT	0x00000020
 #define  BCMA_CC_SROM_CONTROL_LOCK	0x00000008
 #define  BCMA_CC_SROM_CONTROL_SIZE_MASK	0x00000006
 #define  BCMA_CC_SROM_CONTROL_SIZE_1K	0x00000000
-- 
2.30.2

