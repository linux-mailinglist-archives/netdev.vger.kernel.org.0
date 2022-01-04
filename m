Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD63B483C50
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbiADH2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbiADH2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 02:28:17 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8642DC061799;
        Mon,  3 Jan 2022 23:28:17 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id A469C425CB;
        Tue,  4 Jan 2022 07:28:08 +0000 (UTC)
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
Subject: [PATCH v2 04/35] brcmfmac: firmware: Support having multiple alt paths
Date:   Tue,  4 Jan 2022 16:26:27 +0900
Message-Id: <20220104072658.69756-5-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st>
References: <20220104072658.69756-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apple platforms have firmware and config files identified with multiple
dimensions. We want to be able to find the most specific firmware
available for any given platform, progressively trying more general
firmwares.

First, add support for having multiple alternate firmware paths.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/firmware.c    | 75 ++++++++++++++-----
 .../broadcom/brcm80211/brcmfmac/firmware.h    |  2 +
 2 files changed, 59 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 0497b721136a..7570dbf22cdd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -427,6 +427,8 @@ void brcmf_fw_nvram_free(void *nvram)
 struct brcmf_fw {
 	struct device *dev;
 	struct brcmf_fw_request *req;
+	const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS];
+	int alt_index;
 	u32 curpos;
 	void (*done)(struct device *dev, int err, struct brcmf_fw_request *req);
 };
@@ -592,14 +594,18 @@ static int brcmf_fw_complete_request(const struct firmware *fw,
 	return (cur->flags & BRCMF_FW_REQF_OPTIONAL) ? 0 : ret;
 }
 
-static char *brcm_alt_fw_path(const char *path, const char *board_type)
+static int brcm_alt_fw_paths(const char *path, const char *board_type,
+			     const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS])
 {
 	char alt_path[BRCMF_FW_NAME_LEN];
 	const char *suffix;
 
+	memset(alt_paths, 0, array_size(sizeof(*alt_paths),
+					BRCMF_FW_MAX_ALT_PATHS));
+
 	suffix = strrchr(path, '.');
 	if (!suffix || suffix == path)
-		return NULL;
+		return -EINVAL;
 
 	/* strip extension at the end */
 	strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
@@ -609,7 +615,18 @@ static char *brcm_alt_fw_path(const char *path, const char *board_type)
 	strlcat(alt_path, board_type, BRCMF_FW_NAME_LEN);
 	strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
 
-	return kstrdup(alt_path, GFP_KERNEL);
+	alt_paths[0] = kstrdup(alt_path, GFP_KERNEL);
+
+	return 0;
+}
+
+static void
+brcm_free_alt_fw_paths(const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS])
+{
+	unsigned int i;
+
+	for (i = 0; alt_paths[i]; i++)
+		kfree(alt_paths[i]);
 }
 
 static int brcmf_fw_request_firmware(const struct firmware **fw,
@@ -617,19 +634,25 @@ static int brcmf_fw_request_firmware(const struct firmware **fw,
 {
 	struct brcmf_fw_item *cur = &fwctx->req->items[fwctx->curpos];
 	int ret;
+	unsigned int i;
 
 	/* Files can be board-specific, first try a board-specific path */
 	if (fwctx->req->board_type) {
-		char *alt_path;
+		const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS];
 
-		alt_path = brcm_alt_fw_path(cur->path, fwctx->req->board_type);
-		if (!alt_path)
+		if (brcm_alt_fw_paths(cur->path, fwctx->req->board_type,
+				      alt_paths) != 0)
 			goto fallback;
 
-		ret = request_firmware(fw, alt_path, fwctx->dev);
-		kfree(alt_path);
-		if (ret == 0)
-			return ret;
+		for (i = 0; i < BRCMF_FW_MAX_ALT_PATHS && alt_paths[i]; i++) {
+			ret = firmware_request_nowarn(fw, alt_paths[i],
+						      fwctx->dev);
+			if (ret == 0) {
+				brcm_free_alt_fw_paths(alt_paths);
+				return ret;
+			}
+		}
+		brcm_free_alt_fw_paths(alt_paths);
 	}
 
 fallback:
@@ -641,6 +664,8 @@ static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
 	struct brcmf_fw *fwctx = ctx;
 	int ret;
 
+	brcm_free_alt_fw_paths(fwctx->alt_paths);
+
 	ret = brcmf_fw_complete_request(fw, fwctx);
 
 	while (ret == 0 && ++fwctx->curpos < fwctx->req->n_items) {
@@ -662,13 +687,27 @@ static void brcmf_fw_request_done_alt_path(const struct firmware *fw, void *ctx)
 	struct brcmf_fw_item *first = &fwctx->req->items[0];
 	int ret = 0;
 
-	/* Fall back to canonical path if board firmware not found */
-	if (!fw)
+	if (fw) {
+		brcmf_fw_request_done(fw, ctx);
+		return;
+	}
+
+	fwctx->alt_index++;
+	if (fwctx->alt_index < BRCMF_FW_MAX_ALT_PATHS &&
+	    fwctx->alt_paths[fwctx->alt_index]) {
+		/* Try the next alt firmware */
+		ret = request_firmware_nowait(THIS_MODULE, true,
+					      fwctx->alt_paths[fwctx->alt_index],
+					      fwctx->dev, GFP_KERNEL, fwctx,
+					      brcmf_fw_request_done_alt_path);
+	} else {
+		/* Fall back to canonical path if board firmware not found */
 		ret = request_firmware_nowait(THIS_MODULE, true, first->path,
 					      fwctx->dev, GFP_KERNEL, fwctx,
 					      brcmf_fw_request_done);
+	}
 
-	if (fw || ret < 0)
+	if (ret < 0)
 		brcmf_fw_request_done(fw, ctx);
 }
 
@@ -693,7 +732,6 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 {
 	struct brcmf_fw_item *first = &req->items[0];
 	struct brcmf_fw *fwctx;
-	char *alt_path;
 	int ret;
 
 	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(dev));
@@ -712,12 +750,13 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 	fwctx->done = fw_cb;
 
 	/* First try alternative board-specific path if any */
-	alt_path = brcm_alt_fw_path(first->path, fwctx->req->board_type);
-	if (alt_path) {
-		ret = request_firmware_nowait(THIS_MODULE, true, alt_path,
+	if (brcm_alt_fw_paths(first->path, req->board_type,
+			      fwctx->alt_paths) == 0) {
+		fwctx->alt_index = 0;
+		ret = request_firmware_nowait(THIS_MODULE, true,
+					      fwctx->alt_paths[0],
 					      fwctx->dev, GFP_KERNEL, fwctx,
 					      brcmf_fw_request_done_alt_path);
-		kfree(alt_path);
 	} else {
 		ret = request_firmware_nowait(THIS_MODULE, true, first->path,
 					      fwctx->dev, GFP_KERNEL, fwctx,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
index e290dec9c53d..7f4e6e359c82 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
@@ -11,6 +11,8 @@
 
 #define BRCMF_FW_DEFAULT_PATH		"brcm/"
 
+#define BRCMF_FW_MAX_ALT_PATHS	8
+
 /**
  * struct brcmf_firmware_mapping - Used to map chipid/revmask to firmware
  *	filename and nvram filename. Each bus type implementation should create
-- 
2.33.0

