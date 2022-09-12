Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8145B5781
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 11:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiILJxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 05:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiILJwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 05:52:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D2F36844;
        Mon, 12 Sep 2022 02:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oGsSCx6vnYSPKIXNfcv9dULMF1Fss3aaza+G+S+XB44=; b=JAkRGnBlDNmsZXIoEsLD4FSGXv
        iwJJRgYOXM44LBfqP6gq3TxjSvelm4EktdsgVhkbtvTFHEnoqfxORXfehMqUrbEGl/xUyNCc6iuuG
        gRVDd7HoUgMmTvYHU4zt3GcWh680gOFB3yZcI68F6nAuSNfRn2gpHtHXzod1NbIIl/AI6WCpwbhTG
        AKsVi7daYT4J9K3eN8VP4Ookv8PrdtltMyHh2nCXvLxrrWMZFpIhs/VXc30Bpc0U1paWomAcY+BSY
        ON3LfbYP31idai3yTDEh/z4HUDYG5ZDOsYZYRVI/1H8eqkexdoLFzWy0ePGceByf27Dlb1feh8Uox
        tc66N6pw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:33092 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oXg7T-0001Rd-5V; Mon, 12 Sep 2022 10:52:47 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oXg7S-0064um-F7; Mon, 12 Sep 2022 10:52:46 +0100
In-Reply-To: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
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
Subject: [PATCH wireless-next v2 02/12] brcmfmac: firmware: Handle per-board
 clm_blob files
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oXg7S-0064um-F7@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 12 Sep 2022 10:52:46 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

Teach brcm_alt_fw_paths to correctly split off variable length
extensions, and enable alt firmware lookups for the CLM blob firmware
requests.

Apple platforms have per-board CLM blob files.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../broadcom/brcm80211/brcmfmac/firmware.c    | 33 +++++++++++--------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 15e99d8865bd..6c7c0c8f94ce 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -587,22 +587,29 @@ static int brcmf_fw_complete_request(const struct firmware *fw,
 
 static char *brcm_alt_fw_path(const char *path, const char *board_type)
 {
-	char alt_path[BRCMF_FW_NAME_LEN];
-	char suffix[5];
+	char base[BRCMF_FW_NAME_LEN];
+	const char *suffix;
+	char *ret;
 
-	strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
-	/* At least one character + suffix */
-	if (strlen(alt_path) < 5)
+	if (!board_type)
 		return NULL;
 
-	/* strip .txt or .bin at the end */
-	strscpy(suffix, alt_path + strlen(alt_path) - 4, 5);
-	alt_path[strlen(alt_path) - 4] = 0;
-	strlcat(alt_path, ".", BRCMF_FW_NAME_LEN);
-	strlcat(alt_path, board_type, BRCMF_FW_NAME_LEN);
-	strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
+	suffix = strrchr(path, '.');
+	if (!suffix || suffix == path)
+		return NULL;
+
+	/* strip extension at the end */
+	strscpy(base, path, BRCMF_FW_NAME_LEN);
+	base[suffix - path] = 0;
+
+	ret = kasprintf(GFP_KERNEL, "%s.%s%s", base, board_type, suffix);
+	if (!ret)
+		brcmf_err("out of memory allocating firmware path for '%s'\n",
+			  path);
+
+	brcmf_dbg(TRACE, "FW alt path: %s\n", ret);
 
-	return kstrdup(alt_path, GFP_KERNEL);
+	return ret;
 }
 
 static int brcmf_fw_request_firmware(const struct firmware **fw,
@@ -612,7 +619,7 @@ static int brcmf_fw_request_firmware(const struct firmware **fw,
 	int ret;
 
 	/* Files can be board-specific, first try a board-specific path */
-	if (cur->type == BRCMF_FW_TYPE_NVRAM && fwctx->req->board_type) {
+	if (fwctx->req->board_type) {
 		char *alt_path;
 
 		alt_path = brcm_alt_fw_path(cur->path, fwctx->req->board_type);
-- 
2.30.2

