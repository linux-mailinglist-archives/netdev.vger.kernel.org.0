Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E545F483C63
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbiADH2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbiADH2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 02:28:50 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54BBC061761;
        Mon,  3 Jan 2022 23:28:49 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 0203E425CB;
        Tue,  4 Jan 2022 07:28:40 +0000 (UTC)
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
Subject: [PATCH v2 08/35] brcmfmac: of: Fetch Apple properties
Date:   Tue,  4 Jan 2022 16:26:31 +0900
Message-Id: <20220104072658.69756-9-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st>
References: <20220104072658.69756-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Apple ARM64 platforms, firmware selection requires two properties
that come from system firmware: the module-instance (aka "island", a
codename representing a given hardware platform) and the antenna-sku.
We map Apple's module codenames to board_types in the form
"apple,<module-instance>".

The mapped board_type is added to the DTS file in that form, while the
antenna-sku is forwarded by our bootloader from the Apple Device Tree
into the FDT. Grab them from the DT so firmware selection can use
them.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../wireless/broadcom/brcm80211/brcmfmac/common.h    |  1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c    | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index 8b5f49997c8b..d4aa25d646fe 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -50,6 +50,7 @@ struct brcmf_mp_device {
 	bool		ignore_probe_fail;
 	struct brcmfmac_pd_cc *country_codes;
 	const char	*board_type;
+	const char	*antenna_sku;
 	union {
 		struct brcmfmac_sdio_pd sdio;
 	} bus;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index 513c7e6421b2..085d34176b78 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -63,14 +63,24 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 {
 	struct brcmfmac_sdio_pd *sdio = &settings->bus.sdio;
 	struct device_node *root, *np = dev->of_node;
+	const char *prop;
 	int irq;
 	int err;
 	u32 irqf;
 	u32 val;
 
+	/* Apple ARM64 platforms have their own idea of board type, passed in
+	 * via the device tree. They also have an antenna SKU parameter
+	 */
+	if (!of_property_read_string(np, "brcm,board-type", &prop))
+		settings->board_type = devm_kstrdup(dev, prop, GFP_KERNEL);
+
+	if (!of_property_read_string(np, "apple,antenna-sku", &prop))
+		settings->antenna_sku = devm_kstrdup(dev, prop, GFP_KERNEL);
+
 	/* Set board-type to the first string of the machine compatible prop */
 	root = of_find_node_by_path("/");
-	if (root) {
+	if (root && !settings->board_type) {
 		int i, len;
 		char *board_type;
 		const char *tmp;
-- 
2.33.0

