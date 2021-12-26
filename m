Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902EB47F793
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 16:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbhLZPhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 10:37:32 -0500
Received: from marcansoft.com ([212.63.210.85]:55786 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233954AbhLZPh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Dec 2021 10:37:28 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 79EA34290F;
        Sun, 26 Dec 2021 15:37:17 +0000 (UTC)
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
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH 06/34] brcmfmac: firmware: Support passing in multiple board_types
Date:   Mon, 27 Dec 2021 00:35:56 +0900
Message-Id: <20211226153624.162281-7-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211226153624.162281-1-marcan@marcan.st>
References: <20211226153624.162281-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to make use of the multiple alt_path functionality, change
board_type to an array. Bus drivers can pass in a NULL-terminated list
of board type strings to try for the firmware fetch.

Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/firmware.c    | 35 +++++++++++++------
 .../broadcom/brcm80211/brcmfmac/firmware.h    |  2 +-
 .../broadcom/brcm80211/brcmfmac/pcie.c        |  7 +++-
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  4 ++-
 4 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index eca5a6df1058..51d5d2b88ee6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -594,26 +594,41 @@ static int brcmf_fw_complete_request(const struct firmware *fw,
 	return (cur->flags & BRCMF_FW_REQF_OPTIONAL) ? 0 : ret;
 }
 
-static const char **brcm_alt_fw_paths(const char *path, const char *board_type)
+static const char **brcm_alt_fw_paths(const char *path, struct brcmf_fw *fwctx)
 {
+	const char **board_types = fwctx->req->board_types;
+	int board_type_count = 0;
+	int i;
 	char alt_path[BRCMF_FW_NAME_LEN];
 	char **alt_paths;
 	const char *suffix;
 
+	if (!board_types || !board_types[0])
+		return NULL;
+
+	while (*board_types++)
+		board_type_count++;
+
 	suffix = strrchr(path, '.');
 	if (!suffix || suffix == path)
 		return NULL;
 
-	/* strip extension at the end */
-	strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
-	alt_path[suffix - path] = 0;
+	alt_paths = kzalloc(sizeof(char *) * (board_type_count + 1),
+			    GFP_KERNEL);
+
+	board_types = fwctx->req->board_types;
+	for (i = 0; i < board_type_count; i++) {
+		/* strip extension at the end */
+		strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
+		alt_path[suffix - path] = 0;
 
-	strlcat(alt_path, ".", BRCMF_FW_NAME_LEN);
-	strlcat(alt_path, board_type, BRCMF_FW_NAME_LEN);
-	strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
+		strlcat(alt_path, ".", BRCMF_FW_NAME_LEN);
+		strlcat(alt_path, board_types[i], BRCMF_FW_NAME_LEN);
+		strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
 
-	alt_paths = kzalloc(sizeof(char *) * 2, GFP_KERNEL);
-	alt_paths[0] = kstrdup(alt_path, GFP_KERNEL);
+		alt_paths[i] = kstrdup(alt_path, GFP_KERNEL);
+		brcmf_dbg(TRACE, "FW alt path: %s\n", alt_paths[i]);
+	}
 
 	return (const char **)alt_paths;
 }
@@ -638,7 +653,7 @@ static int brcmf_fw_request_firmware(const struct firmware **fw,
 	int ret, i;
 
 	/* Files can be board-specific, first try a board-specific path */
-	if (fwctx->req->board_type) {
+	if (fwctx->req->board_types) {
 		const char **alt_paths = brcm_alt_fw_paths(cur->path, fwctx);
 
 		if (!alt_paths)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
index e290dec9c53d..d94a1d5be517 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
@@ -66,7 +66,7 @@ struct brcmf_fw_request {
 	u16 domain_nr;
 	u16 bus_nr;
 	u32 n_items;
-	const char *board_type;
+	const char **board_types;
 	struct brcmf_fw_item items[];
 };
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 591f870d1e47..8888d6acb7f2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1877,11 +1877,16 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
 	fwreq->items[BRCMF_PCIE_FW_NVRAM].flags = BRCMF_FW_REQF_OPTIONAL;
 	fwreq->items[BRCMF_PCIE_FW_CLM].type = BRCMF_FW_TYPE_BINARY;
 	fwreq->items[BRCMF_PCIE_FW_CLM].flags = BRCMF_FW_REQF_OPTIONAL;
-	fwreq->board_type = devinfo->settings->board_type;
 	/* NVRAM reserves PCI domain 0 for Broadcom's SDK faked bus */
 	fwreq->domain_nr = pci_domain_nr(devinfo->pdev->bus) + 1;
 	fwreq->bus_nr = devinfo->pdev->bus->number;
 
+	brcmf_dbg(PCIE, "Board: %s\n", devinfo->settings->board_type);
+	fwreq->board_types = devm_kzalloc(&devinfo->pdev->dev,
+					  sizeof(const char *) * 2,
+					  GFP_KERNEL);
+	fwreq->board_types[0] = devinfo->settings->board_type;
+
 	return fwreq;
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 7466e6fd6eca..32f457bf02d1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4432,7 +4432,9 @@ brcmf_sdio_prepare_fw_request(struct brcmf_sdio *bus)
 	fwreq->items[BRCMF_SDIO_FW_NVRAM].type = BRCMF_FW_TYPE_NVRAM;
 	fwreq->items[BRCMF_SDIO_FW_CLM].type = BRCMF_FW_TYPE_BINARY;
 	fwreq->items[BRCMF_SDIO_FW_CLM].flags = BRCMF_FW_REQF_OPTIONAL;
-	fwreq->board_type = bus->sdiodev->settings->board_type;
+	fwreq->board_types = devm_kzalloc(bus->sdiodev->dev,
+					  sizeof(const char *) * 2, GFP_KERNEL);
+	fwreq->board_types[0] = bus->sdiodev->settings->board_type;
 
 	return fwreq;
 }
-- 
2.33.0

