Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BA0483CF5
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiADHcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:32:43 -0500
Received: from marcansoft.com ([212.63.210.85]:47772 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233730AbiADHc1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 02:32:27 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 0E57A41F5D;
        Tue,  4 Jan 2022 07:32:17 +0000 (UTC)
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
Subject: [PATCH v2 35/35] brcmfmac: common: Add support for external calibration blobs
Date:   Tue,  4 Jan 2022 16:26:58 +0900
Message-Id: <20220104072658.69756-36-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st>
References: <20220104072658.69756-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The calibration blob for a chip is normally stored in SROM and loaded
internally by the firmware. However, Apple ARM64 platforms instead store
it as part of platform configuration data, and provide it via the Apple
Device Tree. We forward this into the Linux DT in the bootloader.

Add support for taking this blob from the DT and loading it into the
dongle. The loading mechanism is the same as used for the CLM and TxCap
blobs.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/common.c      | 24 +++++++++++++++++++
 .../broadcom/brcm80211/brcmfmac/common.h      |  2 ++
 .../wireless/broadcom/brcm80211/brcmfmac/of.c |  8 +++++++
 3 files changed, 34 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index d65308c3f070..ad36e6b5dd47 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -218,6 +218,23 @@ static int brcmf_c_process_txcap_blob(struct brcmf_if *ifp)
 	return err;
 }
 
+static int brcmf_c_process_cal_blob(struct brcmf_if *ifp)
+{
+	struct brcmf_pub *drvr = ifp->drvr;
+	struct brcmf_mp_device *settings = drvr->settings;
+	s32 err;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	if (!settings->cal_blob || !settings->cal_size)
+		return 0;
+
+	brcmf_info("Calibration blob provided by platform, loading\n");
+	err = brcmf_c_download_blob(ifp, settings->cal_blob, settings->cal_size,
+				    "calload", "calload_status");
+	return err;
+}
+
 int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
@@ -291,6 +308,13 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 		goto done;
 	}
 
+	/* Download external calibration blob, if available */
+	err = brcmf_c_process_cal_blob(ifp);
+	if (err < 0) {
+		bphy_err(drvr, "download calibration blob file failed, %d\n", err);
+		goto done;
+	}
+
 	/* query for 'ver' to get version info from firmware */
 	memset(buf, 0, sizeof(buf));
 	err = brcmf_fil_iovar_data_get(ifp, "ver", buf, sizeof(buf));
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index a88c4a9310f3..f321346edd01 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -51,6 +51,8 @@ struct brcmf_mp_device {
 	struct brcmfmac_pd_cc *country_codes;
 	const char	*board_type;
 	const char	*antenna_sku;
+	void		*cal_blob;
+	int		cal_size;
 	union {
 		struct brcmfmac_sdio_pd sdio;
 	} bus;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index 085d34176b78..6f885c3210c3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -78,6 +78,14 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 	if (!of_property_read_string(np, "apple,antenna-sku", &prop))
 		settings->antenna_sku = devm_kstrdup(dev, prop, GFP_KERNEL);
 
+	/* The WLAN calibration blob is normally stored in SROM, but Apple
+	 * ARM64 platforms pass it via the DT instead.
+	 */
+	prop = of_get_property(np, "brcm,cal-blob", &settings->cal_size);
+	if (prop && settings->cal_size)
+		settings->cal_blob = devm_kmemdup(dev, prop, settings->cal_size,
+						  GFP_KERNEL);
+
 	/* Set board-type to the first string of the machine compatible prop */
 	root = of_find_node_by_path("/");
 	if (root && !settings->board_type) {
-- 
2.33.0

