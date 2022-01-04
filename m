Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58B4483C4B
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbiADH2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:28:12 -0500
Received: from marcansoft.com ([212.63.210.85]:45764 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233251AbiADH2J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 02:28:09 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id A19F342493;
        Tue,  4 Jan 2022 07:28:00 +0000 (UTC)
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
Subject: [PATCH v2 03/35] brcmfmac: firmware: Handle per-board clm_blob files
Date:   Tue,  4 Jan 2022 16:26:26 +0900
Message-Id: <20220104072658.69756-4-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st>
References: <20220104072658.69756-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Teach brcm_alt_fw_paths to correctly split off variable length
extensions, and enable alt firmware lookups for the CLM blob firmware
requests.

Apple platforms have per-board CLM blob files.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/firmware.c       | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 0eb13e5df517..0497b721136a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -595,16 +595,16 @@ static int brcmf_fw_complete_request(const struct firmware *fw,
 static char *brcm_alt_fw_path(const char *path, const char *board_type)
 {
 	char alt_path[BRCMF_FW_NAME_LEN];
-	char suffix[5];
+	const char *suffix;
 
-	strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
-	/* At least one character + suffix */
-	if (strlen(alt_path) < 5)
+	suffix = strrchr(path, '.');
+	if (!suffix || suffix == path)
 		return NULL;
 
-	/* strip .txt or .bin at the end */
-	strscpy(suffix, alt_path + strlen(alt_path) - 4, 5);
-	alt_path[strlen(alt_path) - 4] = 0;
+	/* strip extension at the end */
+	strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
+	alt_path[suffix - path] = 0;
+
 	strlcat(alt_path, ".", BRCMF_FW_NAME_LEN);
 	strlcat(alt_path, board_type, BRCMF_FW_NAME_LEN);
 	strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
@@ -619,7 +619,7 @@ static int brcmf_fw_request_firmware(const struct firmware **fw,
 	int ret;
 
 	/* Files can be board-specific, first try a board-specific path */
-	if (cur->type == BRCMF_FW_TYPE_NVRAM && fwctx->req->board_type) {
+	if (fwctx->req->board_type) {
 		char *alt_path;
 
 		alt_path = brcm_alt_fw_path(cur->path, fwctx->req->board_type);
-- 
2.33.0

