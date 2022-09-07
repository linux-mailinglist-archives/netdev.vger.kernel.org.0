Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E411A5AFE0B
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiIGHta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiIGHsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:48:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A5BA6AEF;
        Wed,  7 Sep 2022 00:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Nv07mv2MpxUPTETUKi/5pGHsGikcrJct5kZhcHfYHKE=; b=YHlslZeevxeRhsmbyBSsLCIIUV
        kNG6TEtvoKm4bc9qVKRdab15u2F/KMqkMfb81D26tZWMkTLie+f5scZSVwS4/y2OjMgWOSkuSvw5X
        R9xyQsv/KjAfXDDIKQwoEr38XhUliZinvs80m0Ftel0CdQPZwN6qsopaBp29Q5yIJ0OlIvME1dL+z
        8K28LVvaDwyi0X0cux4AByxNBKyMOyYEQuAVYzrj4S7QM3hkoMpyl60Yq03XOH0HJHrAC+ch5L1NG
        lMuHuaIRRVLxmyIPR5ARYw8fA9+KbbHWDdu+lduigdE3IVcCXCkhUwIrtI/+RzAyBMuqbCVUMcrbj
        0q77fVLw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:51096 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oVpnL-0004wd-EJ; Wed, 07 Sep 2022 08:48:23 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oVpnK-005LC2-7g; Wed, 07 Sep 2022 08:48:22 +0100
In-Reply-To: <YxhMaYOfnM+7FG+W@shell.armlinux.org.uk>
References: <YxhMaYOfnM+7FG+W@shell.armlinux.org.uk>
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
Subject: [PATCH net-next 08/12] brcmfmac: firmware: Allow platform to override
 macaddr
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oVpnK-005LC2-7g@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 07 Sep 2022 08:48:22 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

On Device Tree platforms, it is customary to be able to set the MAC
address via the Device Tree, as it is often stored in system firmware.
This is particularly relevant for Apple ARM64 platforms, where this
information comes from system configuration and passed through by the
bootloader into the DT.

Implement support for this by fetching the platform MAC address and
adding or replacing the macaddr= property in nvram. This becomes the
dongle's default MAC address.

On platforms with an SROM MAC address, this overrides it. On platforms
without one, such as Apple ARM64 devices, this is required for the
firmware to boot (it will fail if it does not have a valid MAC at all).

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../broadcom/brcm80211/brcmfmac/firmware.c    | 31 +++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 371c086d1f48..c109e20fc5c6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -21,6 +21,8 @@
 #define BRCMF_FW_NVRAM_DEVPATH_LEN		19	/* devpath0=pcie/1/4/ */
 #define BRCMF_FW_NVRAM_PCIEDEV_LEN		10	/* pcie/1/4/ + \0 */
 #define BRCMF_FW_DEFAULT_BOARDREV		"boardrev=0xff"
+#define BRCMF_FW_MACADDR_FMT			"macaddr=%pM"
+#define BRCMF_FW_MACADDR_LEN			(7 + ETH_ALEN * 3)
 
 enum nvram_parser_state {
 	IDLE,
@@ -57,6 +59,7 @@ struct nvram_parser {
 	bool multi_dev_v1;
 	bool multi_dev_v2;
 	bool boardrev_found;
+	bool strip_mac;
 };
 
 /*
@@ -121,6 +124,10 @@ static enum nvram_parser_state brcmf_nvram_handle_key(struct nvram_parser *nvp)
 			nvp->multi_dev_v2 = true;
 		if (strncmp(&nvp->data[nvp->entry], "boardrev", 8) == 0)
 			nvp->boardrev_found = true;
+		/* strip macaddr if platform MAC overrides */
+		if (nvp->strip_mac &&
+		    strncmp(&nvp->data[nvp->entry], "macaddr", 7) == 0)
+			st = COMMENT;
 	} else if (!is_nvram_char(c) || c == ' ') {
 		brcmf_dbg(INFO, "warning: ln=%d:col=%d: '=' expected, skip invalid key entry\n",
 			  nvp->line, nvp->column);
@@ -209,6 +216,7 @@ static int brcmf_init_nvram_parser(struct nvram_parser *nvp,
 		size = data_len;
 	/* Add space for properties we may add */
 	size += strlen(BRCMF_FW_DEFAULT_BOARDREV) + 1;
+	size += BRCMF_FW_MACADDR_LEN + 1;
 	/* Alloc for extra 0 byte + roundup by 4 + length field */
 	size += 1 + 3 + sizeof(u32);
 	nvp->nvram = kzalloc(size, GFP_KERNEL);
@@ -368,22 +376,37 @@ static void brcmf_fw_add_defaults(struct nvram_parser *nvp)
 	nvp->nvram_len++;
 }
 
+static void brcmf_fw_add_macaddr(struct nvram_parser *nvp, u8 *mac)
+{
+	int len;
+
+	len = scnprintf(&nvp->nvram[nvp->nvram_len], BRCMF_FW_MACADDR_LEN + 1,
+			BRCMF_FW_MACADDR_FMT, mac);
+	WARN_ON(len != BRCMF_FW_MACADDR_LEN);
+	nvp->nvram_len += len + 1;
+}
+
 /* brcmf_nvram_strip :Takes a buffer of "<var>=<value>\n" lines read from a fil
  * and ending in a NUL. Removes carriage returns, empty lines, comment lines,
  * and converts newlines to NULs. Shortens buffer as needed and pads with NULs.
  * End of buffer is completed with token identifying length of buffer.
  */
 static void *brcmf_fw_nvram_strip(const u8 *data, size_t data_len,
-				  u32 *new_length, u16 domain_nr, u16 bus_nr)
+				  u32 *new_length, u16 domain_nr, u16 bus_nr,
+				  struct device *dev)
 {
 	struct nvram_parser nvp;
 	u32 pad;
 	u32 token;
 	__le32 token_le;
+	u8 mac[ETH_ALEN];
 
 	if (brcmf_init_nvram_parser(&nvp, data, data_len) < 0)
 		return NULL;
 
+	if (eth_platform_get_mac_address(dev, mac) == 0)
+		nvp.strip_mac = true;
+
 	while (nvp.pos < data_len) {
 		nvp.state = nv_parser_states[nvp.state](&nvp);
 		if (nvp.state == END)
@@ -404,6 +427,9 @@ static void *brcmf_fw_nvram_strip(const u8 *data, size_t data_len,
 
 	brcmf_fw_add_defaults(&nvp);
 
+	if (nvp.strip_mac)
+		brcmf_fw_add_macaddr(&nvp, mac);
+
 	pad = nvp.nvram_len;
 	*new_length = roundup(nvp.nvram_len + 1, 4);
 	while (pad != *new_length) {
@@ -538,7 +564,8 @@ static int brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 	if (data)
 		nvram = brcmf_fw_nvram_strip(data, data_len, &nvram_length,
 					     fwctx->req->domain_nr,
-					     fwctx->req->bus_nr);
+					     fwctx->req->bus_nr,
+					     fwctx->dev);
 
 	if (free_bcm47xx_nvram)
 		bcm47xx_nvram_release_contents(data);
-- 
2.30.2

