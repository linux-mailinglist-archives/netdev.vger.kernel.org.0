Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42D4483C7E
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbiADH3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbiADH3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 02:29:30 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1AEC061784;
        Mon,  3 Jan 2022 23:29:30 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 35CB5425CB;
        Tue,  4 Jan 2022 07:29:20 +0000 (UTC)
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
Subject: [PATCH v2 13/35] brcmfmac: pcie: Support PCIe core revisions >= 64
Date:   Tue,  4 Jan 2022 16:26:36 +0900
Message-Id: <20220104072658.69756-14-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st>
References: <20220104072658.69756-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These newer PCIe core revisions include new sets of registers that must
be used instead of the legacy ones. Introduce a brcmf_pcie_reginfo to
hold the specific register offsets and values to use for a given
platform, and change all the register accesses to indirect through it.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 125 +++++++++++++++---
 1 file changed, 105 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 595815164e18..f3744e806157 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -118,6 +118,12 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 #define BRCMF_PCIE_PCIE2REG_H2D_MAILBOX_0	0x140
 #define BRCMF_PCIE_PCIE2REG_H2D_MAILBOX_1	0x144
 
+#define BRCMF_PCIE_64_PCIE2REG_INTMASK		0xC14
+#define BRCMF_PCIE_64_PCIE2REG_MAILBOXINT	0xC30
+#define BRCMF_PCIE_64_PCIE2REG_MAILBOXMASK	0xC34
+#define BRCMF_PCIE_64_PCIE2REG_H2D_MAILBOX_0	0xA20
+#define BRCMF_PCIE_64_PCIE2REG_H2D_MAILBOX_1	0xA24
+
 #define BRCMF_PCIE2_INTA			0x01
 #define BRCMF_PCIE2_INTB			0x02
 
@@ -137,6 +143,8 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 #define	BRCMF_PCIE_MB_INT_D2H3_DB0		0x400000
 #define	BRCMF_PCIE_MB_INT_D2H3_DB1		0x800000
 
+#define BRCMF_PCIE_MB_INT_FN0			(BRCMF_PCIE_MB_INT_FN0_0 | \
+						 BRCMF_PCIE_MB_INT_FN0_1)
 #define BRCMF_PCIE_MB_INT_D2H_DB		(BRCMF_PCIE_MB_INT_D2H0_DB0 | \
 						 BRCMF_PCIE_MB_INT_D2H0_DB1 | \
 						 BRCMF_PCIE_MB_INT_D2H1_DB0 | \
@@ -146,6 +154,40 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 						 BRCMF_PCIE_MB_INT_D2H3_DB0 | \
 						 BRCMF_PCIE_MB_INT_D2H3_DB1)
 
+#define	BRCMF_PCIE_64_MB_INT_D2H0_DB0		0x1
+#define	BRCMF_PCIE_64_MB_INT_D2H0_DB1		0x2
+#define	BRCMF_PCIE_64_MB_INT_D2H1_DB0		0x4
+#define	BRCMF_PCIE_64_MB_INT_D2H1_DB1		0x8
+#define	BRCMF_PCIE_64_MB_INT_D2H2_DB0		0x10
+#define	BRCMF_PCIE_64_MB_INT_D2H2_DB1		0x20
+#define	BRCMF_PCIE_64_MB_INT_D2H3_DB0		0x40
+#define	BRCMF_PCIE_64_MB_INT_D2H3_DB1		0x80
+#define	BRCMF_PCIE_64_MB_INT_D2H4_DB0		0x100
+#define	BRCMF_PCIE_64_MB_INT_D2H4_DB1		0x200
+#define	BRCMF_PCIE_64_MB_INT_D2H5_DB0		0x400
+#define	BRCMF_PCIE_64_MB_INT_D2H5_DB1		0x800
+#define	BRCMF_PCIE_64_MB_INT_D2H6_DB0		0x1000
+#define	BRCMF_PCIE_64_MB_INT_D2H6_DB1		0x2000
+#define	BRCMF_PCIE_64_MB_INT_D2H7_DB0		0x4000
+#define	BRCMF_PCIE_64_MB_INT_D2H7_DB1		0x8000
+
+#define BRCMF_PCIE_64_MB_INT_D2H_DB		(BRCMF_PCIE_64_MB_INT_D2H0_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H0_DB1 | \
+						 BRCMF_PCIE_64_MB_INT_D2H1_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H1_DB1 | \
+						 BRCMF_PCIE_64_MB_INT_D2H2_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H2_DB1 | \
+						 BRCMF_PCIE_64_MB_INT_D2H3_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H3_DB1 | \
+						 BRCMF_PCIE_64_MB_INT_D2H4_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H4_DB1 | \
+						 BRCMF_PCIE_64_MB_INT_D2H5_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H5_DB1 | \
+						 BRCMF_PCIE_64_MB_INT_D2H6_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H6_DB1 | \
+						 BRCMF_PCIE_64_MB_INT_D2H7_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H7_DB1)
+
 #define BRCMF_PCIE_SHARED_VERSION_7		7
 #define BRCMF_PCIE_MIN_SHARED_VERSION		5
 #define BRCMF_PCIE_MAX_SHARED_VERSION		BRCMF_PCIE_SHARED_VERSION_7
@@ -272,6 +314,7 @@ struct brcmf_pciedev_info {
 	char nvram_name[BRCMF_FW_NAME_LEN];
 	char clm_name[BRCMF_FW_NAME_LEN];
 	const struct firmware *clm_fw;
+	const struct brcmf_pcie_reginfo *reginfo;
 	void __iomem *regs;
 	void __iomem *tcm;
 	u32 ram_base;
@@ -358,6 +401,36 @@ static const u32 brcmf_ring_itemsize[BRCMF_NROF_COMMON_MSGRINGS] = {
 	BRCMF_D2H_MSGRING_RX_COMPLETE_ITEMSIZE
 };
 
+struct brcmf_pcie_reginfo {
+	u32 intmask;
+	u32 mailboxint;
+	u32 mailboxmask;
+	u32 h2d_mailbox_0;
+	u32 h2d_mailbox_1;
+	u32 int_d2h_db;
+	u32 int_fn0;
+};
+
+static const struct brcmf_pcie_reginfo brcmf_reginfo_default = {
+	.intmask = BRCMF_PCIE_PCIE2REG_INTMASK,
+	.mailboxint = BRCMF_PCIE_PCIE2REG_MAILBOXINT,
+	.mailboxmask = BRCMF_PCIE_PCIE2REG_MAILBOXMASK,
+	.h2d_mailbox_0 = BRCMF_PCIE_PCIE2REG_H2D_MAILBOX_0,
+	.h2d_mailbox_1 = BRCMF_PCIE_PCIE2REG_H2D_MAILBOX_1,
+	.int_d2h_db = BRCMF_PCIE_MB_INT_D2H_DB,
+	.int_fn0 = BRCMF_PCIE_MB_INT_FN0,
+};
+
+static const struct brcmf_pcie_reginfo brcmf_reginfo_64 = {
+	.intmask = BRCMF_PCIE_64_PCIE2REG_INTMASK,
+	.mailboxint = BRCMF_PCIE_64_PCIE2REG_MAILBOXINT,
+	.mailboxmask = BRCMF_PCIE_64_PCIE2REG_MAILBOXMASK,
+	.h2d_mailbox_0 = BRCMF_PCIE_64_PCIE2REG_H2D_MAILBOX_0,
+	.h2d_mailbox_1 = BRCMF_PCIE_64_PCIE2REG_H2D_MAILBOX_1,
+	.int_d2h_db = BRCMF_PCIE_64_MB_INT_D2H_DB,
+	.int_fn0 = 0,
+};
+
 static void brcmf_pcie_setup(struct device *dev, int ret,
 			     struct brcmf_fw_request *fwreq);
 static struct brcmf_fw_request *
@@ -840,30 +913,29 @@ static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo,
 
 static void brcmf_pcie_intr_disable(struct brcmf_pciedev_info *devinfo)
 {
-	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXMASK, 0);
+	brcmf_pcie_write_reg32(devinfo, devinfo->reginfo->mailboxmask, 0);
 }
 
 
 static void brcmf_pcie_intr_enable(struct brcmf_pciedev_info *devinfo)
 {
-	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXMASK,
-			       BRCMF_PCIE_MB_INT_D2H_DB |
-			       BRCMF_PCIE_MB_INT_FN0_0 |
-			       BRCMF_PCIE_MB_INT_FN0_1);
+	brcmf_pcie_write_reg32(devinfo, devinfo->reginfo->mailboxmask,
+			       devinfo->reginfo->int_d2h_db |
+			       devinfo->reginfo->int_fn0);
 }
 
 static void brcmf_pcie_hostready(struct brcmf_pciedev_info *devinfo)
 {
 	if (devinfo->shared.flags & BRCMF_PCIE_SHARED_HOSTRDY_DB1)
 		brcmf_pcie_write_reg32(devinfo,
-				       BRCMF_PCIE_PCIE2REG_H2D_MAILBOX_1, 1);
+				       devinfo->reginfo->h2d_mailbox_1, 1);
 }
 
 static irqreturn_t brcmf_pcie_quick_check_isr(int irq, void *arg)
 {
 	struct brcmf_pciedev_info *devinfo = (struct brcmf_pciedev_info *)arg;
 
-	if (brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT)) {
+	if (brcmf_pcie_read_reg32(devinfo, devinfo->reginfo->mailboxint)) {
 		brcmf_pcie_intr_disable(devinfo);
 		brcmf_dbg(PCIE, "Enter\n");
 		return IRQ_WAKE_THREAD;
@@ -878,15 +950,14 @@ static irqreturn_t brcmf_pcie_isr_thread(int irq, void *arg)
 	u32 status;
 
 	devinfo->in_irq = true;
-	status = brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT);
+	status = brcmf_pcie_read_reg32(devinfo, devinfo->reginfo->mailboxint);
 	brcmf_dbg(PCIE, "Enter %x\n", status);
 	if (status) {
-		brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT,
+		brcmf_pcie_write_reg32(devinfo, devinfo->reginfo->mailboxint,
 				       status);
-		if (status & (BRCMF_PCIE_MB_INT_FN0_0 |
-			      BRCMF_PCIE_MB_INT_FN0_1))
+		if (status & devinfo->reginfo->int_fn0)
 			brcmf_pcie_handle_mb_data(devinfo);
-		if (status & BRCMF_PCIE_MB_INT_D2H_DB) {
+		if (status & devinfo->reginfo->int_d2h_db) {
 			if (devinfo->state == BRCMFMAC_PCIE_STATE_UP)
 				brcmf_proto_msgbuf_rx_trigger(
 							&devinfo->pdev->dev);
@@ -945,8 +1016,8 @@ static void brcmf_pcie_release_irq(struct brcmf_pciedev_info *devinfo)
 	if (devinfo->in_irq)
 		brcmf_err(bus, "Still in IRQ (processing) !!!\n");
 
-	status = brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT);
-	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT, status);
+	status = brcmf_pcie_read_reg32(devinfo, devinfo->reginfo->mailboxint);
+	brcmf_pcie_write_reg32(devinfo, devinfo->reginfo->mailboxint, status);
 
 	devinfo->irq_allocated = false;
 }
@@ -998,7 +1069,7 @@ static int brcmf_pcie_ring_mb_ring_bell(void *ctx)
 
 	brcmf_dbg(PCIE, "RING !\n");
 	/* Any arbitrary value will do, lets use 1 */
-	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_H2D_MAILBOX_0, 1);
+	brcmf_pcie_write_reg32(devinfo, devinfo->reginfo->h2d_mailbox_0, 1);
 
 	return 0;
 }
@@ -1760,15 +1831,22 @@ static int brcmf_pcie_buscoreprep(void *ctx)
 static int brcmf_pcie_buscore_reset(void *ctx, struct brcmf_chip *chip)
 {
 	struct brcmf_pciedev_info *devinfo = (struct brcmf_pciedev_info *)ctx;
-	u32 val;
+	struct brcmf_core *core;
+	u32 val, reg;
 
 	devinfo->ci = chip;
 	brcmf_pcie_reset_device(devinfo);
 
-	val = brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT);
+	/* reginfo is not ready yet */
+	core = brcmf_chip_get_core(chip, BCMA_CORE_PCIE2);
+	if (core->rev >= 64)
+		reg = BRCMF_PCIE_64_PCIE2REG_MAILBOXINT;
+	else
+		reg = BRCMF_PCIE_PCIE2REG_MAILBOXINT;
+
+	val = brcmf_pcie_read_reg32(devinfo, reg);
 	if (val != 0xffffffff)
-		brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT,
-				       val);
+		brcmf_pcie_write_reg32(devinfo, reg, val);
 
 	return 0;
 }
@@ -2172,6 +2250,7 @@ brcmf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct brcmf_pciedev_info *devinfo;
 	struct brcmf_pciedev *pcie_bus_dev;
 	struct brcmf_bus *bus;
+	struct brcmf_core *core;
 
 	brcmf_dbg(PCIE, "Enter %x:%x\n", pdev->vendor, pdev->device);
 
@@ -2190,6 +2269,12 @@ brcmf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto fail;
 	}
 
+	core = brcmf_chip_get_core(devinfo->ci, BCMA_CORE_PCIE2);
+	if (core->rev >= 64)
+		devinfo->reginfo = &brcmf_reginfo_64;
+	else
+		devinfo->reginfo = &brcmf_reginfo_default;
+
 	pcie_bus_dev = kzalloc(sizeof(*pcie_bus_dev), GFP_KERNEL);
 	if (pcie_bus_dev == NULL) {
 		ret = -ENOMEM;
@@ -2358,7 +2443,7 @@ static int brcmf_pcie_pm_leave_D3(struct device *dev)
 	brcmf_dbg(PCIE, "Enter, dev=%p, bus=%p\n", dev, bus);
 
 	/* Check if device is still up and running, if so we are ready */
-	if (brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_INTMASK) != 0) {
+	if (brcmf_pcie_read_reg32(devinfo, devinfo->reginfo->intmask) != 0) {
 		brcmf_dbg(PCIE, "Try to wakeup device....\n");
 		if (brcmf_pcie_send_mb_data(devinfo, BRCMF_H2D_HOST_D0_INFORM))
 			goto cleanup;
-- 
2.33.0

