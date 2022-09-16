Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5286B5BB0CA
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiIPQDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiIPQDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:03:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E36B5A6C;
        Fri, 16 Sep 2022 09:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tlEaHB8T796XcbsijNg2jyJRh0gBsHYqf8/9wqbp0EQ=; b=ioGEKRKkc/Jzjtyrz0cyXdqw8u
        RV0dTTHZ+QnCBWImHUj+glKyBoCjLHCK3UMEB4SEdKtUdaQTey7KTW9F3k7w3yMcaUIX0SIQ0Z0uV
        L7/pv5B/IBFegwbmkoYqYw3zKJ+v9W2pkt/v3xhC7yLzcOfJVptE20kBMBNE170yOiTW/EuXtRifs
        d9x5ZUXplLCIT/JVr7KlPENxLoyzA9bjDg8ZoCM1lcxabp0FT4DVZDEE9Kf3nealvP10vb4jEfYMd
        26zJ37Fr6i5185EO3gqE5jPNmxcER74qKXs6L+5fjI/tkSPT2JUFhqs3VvwKULAuxWP3/1Lyxq11b
        mH6XV1qA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54020 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oZDny-0006vU-KH; Fri, 16 Sep 2022 17:03:02 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oZDnx-0077ae-VK; Fri, 16 Sep 2022 17:03:02 +0100
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
Subject: [PATCH wireless-next v3 08/12] brcmfmac: firmware: Allow platform to
 override macaddr
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oZDnx-0077ae-VK@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 16 Sep 2022 17:03:01 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../broadcom/brcm80211/brcmfmac/firmware.c    | 32 +++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 371c086d1f48..f2207793f6e2 100644
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
@@ -44,6 +46,7 @@ enum nvram_parser_state {
  * @multi_dev_v1: detect pcie multi device v1 (compressed).
  * @multi_dev_v2: detect pcie multi device v2.
  * @boardrev_found: nvram contains boardrev information.
+ * @strip_mac: strip the MAC address.
  */
 struct nvram_parser {
 	enum nvram_parser_state state;
@@ -57,6 +60,7 @@ struct nvram_parser {
 	bool multi_dev_v1;
 	bool multi_dev_v2;
 	bool boardrev_found;
+	bool strip_mac;
 };
 
 /*
@@ -121,6 +125,10 @@ static enum nvram_parser_state brcmf_nvram_handle_key(struct nvram_parser *nvp)
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
@@ -209,6 +217,7 @@ static int brcmf_init_nvram_parser(struct nvram_parser *nvp,
 		size = data_len;
 	/* Add space for properties we may add */
 	size += strlen(BRCMF_FW_DEFAULT_BOARDREV) + 1;
+	size += BRCMF_FW_MACADDR_LEN + 1;
 	/* Alloc for extra 0 byte + roundup by 4 + length field */
 	size += 1 + 3 + sizeof(u32);
 	nvp->nvram = kzalloc(size, GFP_KERNEL);
@@ -368,22 +377,37 @@ static void brcmf_fw_add_defaults(struct nvram_parser *nvp)
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
@@ -404,6 +428,9 @@ static void *brcmf_fw_nvram_strip(const u8 *data, size_t data_len,
 
 	brcmf_fw_add_defaults(&nvp);
 
+	if (nvp.strip_mac)
+		brcmf_fw_add_macaddr(&nvp, mac);
+
 	pad = nvp.nvram_len;
 	*new_length = roundup(nvp.nvram_len + 1, 4);
 	while (pad != *new_length) {
@@ -538,7 +565,8 @@ static int brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
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

