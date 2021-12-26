Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A348147F79C
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 16:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbhLZPhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 10:37:52 -0500
Received: from marcansoft.com ([212.63.210.85]:55890 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233878AbhLZPhm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Dec 2021 10:37:42 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 8388D44B2A;
        Sun, 26 Dec 2021 15:37:33 +0000 (UTC)
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
Subject: [PATCH 08/34] brcmfmac: of: Fetch Apple properties
Date:   Mon, 27 Dec 2021 00:35:58 +0900
Message-Id: <20211226153624.162281-9-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211226153624.162281-1-marcan@marcan.st>
References: <20211226153624.162281-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Apple ARM64 platforms, firmware selection requires two properties
that come from system firmware: the module-instance (aka "island", a
codename representing a given hardware platform) and the antenna-sku.

The module-instance is hard-coded in per-board DTS files, while the
antenna-sku is forwarded by our bootloader from the Apple Device Tree
into the FDT. Grab them from the DT so firmware selection can use
them.

The module-instance is used to construct a board_type by prepending it
with "apple,".

Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/common.h      |  1 +
 .../wireless/broadcom/brcm80211/brcmfmac/of.c | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

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
index 513c7e6421b2..453a6cda5abb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -63,14 +63,31 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
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
+	if (!of_property_read_string(np, "apple,module-instance", &prop)) {
+		const char *prefix = "apple,";
+		int len = strlen(prefix) + strlen(prop) + 1;
+		char *board_type = devm_kzalloc(dev, len, GFP_KERNEL);
+
+		strscpy(board_type, prefix, len);
+		strlcat(board_type, prop, len);
+		settings->board_type = board_type;
+	}
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

