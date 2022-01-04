Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A03483C59
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbiADH2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:28:37 -0500
Received: from marcansoft.com ([212.63.210.85]:45950 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233243AbiADH2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 02:28:34 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id EF6BD41F5D;
        Tue,  4 Jan 2022 07:28:24 +0000 (UTC)
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
Subject: [PATCH v2 06/35] brcmfmac: firmware: Support passing in multiple board_types
Date:   Tue,  4 Jan 2022 16:26:29 +0900
Message-Id: <20220104072658.69756-7-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st>
References: <20220104072658.69756-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to make use of the multiple alt_path functionality, change
board_type to an array. Bus drivers can pass in a NULL-terminated list
of board type strings to try for the firmware fetch.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/firmware.c    | 35 ++++++++++++-------
 .../broadcom/brcm80211/brcmfmac/firmware.h    |  2 +-
 .../broadcom/brcm80211/brcmfmac/pcie.c        |  4 ++-
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  2 +-
 4 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 7570dbf22cdd..054ea3ed133e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -594,28 +594,39 @@ static int brcmf_fw_complete_request(const struct firmware *fw,
 	return (cur->flags & BRCMF_FW_REQF_OPTIONAL) ? 0 : ret;
 }
 
-static int brcm_alt_fw_paths(const char *path, const char *board_type,
+static int brcm_alt_fw_paths(const char *path, struct brcmf_fw *fwctx,
 			     const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS])
 {
+	const char **board_types = fwctx->req->board_types;
+	unsigned int i;
 	char alt_path[BRCMF_FW_NAME_LEN];
 	const char *suffix;
 
 	memset(alt_paths, 0, array_size(sizeof(*alt_paths),
 					BRCMF_FW_MAX_ALT_PATHS));
 
+	if (!board_types[0])
+		return -ENOENT;
+
 	suffix = strrchr(path, '.');
 	if (!suffix || suffix == path)
 		return -EINVAL;
 
-	/* strip extension at the end */
-	strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
-	alt_path[suffix - path] = 0;
+	for (i = 0; i < BRCMF_FW_MAX_ALT_PATHS; i++) {
+		if (!board_types[i])
+		    break;
 
-	strlcat(alt_path, ".", BRCMF_FW_NAME_LEN);
-	strlcat(alt_path, board_type, BRCMF_FW_NAME_LEN);
-	strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
+		/* strip extension at the end */
+		strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
+		alt_path[suffix - path] = 0;
 
-	alt_paths[0] = kstrdup(alt_path, GFP_KERNEL);
+		strlcat(alt_path, ".", BRCMF_FW_NAME_LEN);
+		strlcat(alt_path, board_types[i], BRCMF_FW_NAME_LEN);
+		strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
+
+		alt_paths[i] = kstrdup(alt_path, GFP_KERNEL);
+		brcmf_dbg(TRACE, "FW alt path: %s\n", alt_paths[i]);
+	}
 
 	return 0;
 }
@@ -637,11 +648,10 @@ static int brcmf_fw_request_firmware(const struct firmware **fw,
 	unsigned int i;
 
 	/* Files can be board-specific, first try a board-specific path */
-	if (fwctx->req->board_type) {
+	if (fwctx->req->board_types[0]) {
 		const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS];
 
-		if (brcm_alt_fw_paths(cur->path, fwctx->req->board_type,
-				      alt_paths) != 0)
+		if (brcm_alt_fw_paths(cur->path, fwctx, alt_paths) != 0)
 			goto fallback;
 
 		for (i = 0; i < BRCMF_FW_MAX_ALT_PATHS && alt_paths[i]; i++) {
@@ -750,8 +760,7 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 	fwctx->done = fw_cb;
 
 	/* First try alternative board-specific path if any */
-	if (brcm_alt_fw_paths(first->path, req->board_type,
-			      fwctx->alt_paths) == 0) {
+	if (brcm_alt_fw_paths(first->path, fwctx, fwctx->alt_paths) == 0) {
 		fwctx->alt_index = 0;
 		ret = request_firmware_nowait(THIS_MODULE, true,
 					      fwctx->alt_paths[0],
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
index 7f4e6e359c82..3b60a0e290b0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
@@ -68,7 +68,7 @@ struct brcmf_fw_request {
 	u16 domain_nr;
 	u16 bus_nr;
 	u32 n_items;
-	const char *board_type;
+	const char *board_types[BRCMF_FW_MAX_ALT_PATHS];
 	struct brcmf_fw_item items[];
 };
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 591f870d1e47..a52a6f8081eb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1877,11 +1877,13 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
 	fwreq->items[BRCMF_PCIE_FW_NVRAM].flags = BRCMF_FW_REQF_OPTIONAL;
 	fwreq->items[BRCMF_PCIE_FW_CLM].type = BRCMF_FW_TYPE_BINARY;
 	fwreq->items[BRCMF_PCIE_FW_CLM].flags = BRCMF_FW_REQF_OPTIONAL;
-	fwreq->board_type = devinfo->settings->board_type;
 	/* NVRAM reserves PCI domain 0 for Broadcom's SDK faked bus */
 	fwreq->domain_nr = pci_domain_nr(devinfo->pdev->bus) + 1;
 	fwreq->bus_nr = devinfo->pdev->bus->number;
 
+	brcmf_dbg(PCIE, "Board: %s\n", devinfo->settings->board_type);
+	fwreq->board_types[0] = devinfo->settings->board_type;
+
 	return fwreq;
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 7466e6fd6eca..ed944764f6ea 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4432,7 +4432,7 @@ brcmf_sdio_prepare_fw_request(struct brcmf_sdio *bus)
 	fwreq->items[BRCMF_SDIO_FW_NVRAM].type = BRCMF_FW_TYPE_NVRAM;
 	fwreq->items[BRCMF_SDIO_FW_CLM].type = BRCMF_FW_TYPE_BINARY;
 	fwreq->items[BRCMF_SDIO_FW_CLM].flags = BRCMF_FW_REQF_OPTIONAL;
-	fwreq->board_type = bus->sdiodev->settings->board_type;
+	fwreq->board_types[0] = bus->sdiodev->settings->board_type;
 
 	return fwreq;
 }
-- 
2.33.0

