Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7755B695F1B
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbjBNJ1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbjBNJ1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:27:05 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C964F241DA;
        Tue, 14 Feb 2023 01:26:24 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 39C74421F5;
        Tue, 14 Feb 2023 09:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676366778; bh=vutuY9AFls99YQJzykBSufwXU5e8fEtqih3sU9WRAlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=H99/p3rrxqwx68Cf1xGpCjpew3cUkS5PYSWvzGbpf2ucec+7kY0PnLgjJKW06atEX
         Gm1vqLBIgbb7DKWwzXNEqaE5q+AWOc4ABmmx9aWy5vAnbF9FIDDA/14HIXasH7VP6D
         +Q+0JphGQfiv8Ap1c0Kip+fzrXuc7G9O3jN1wrXtEa/1N7QP1bYZd9FtcH1iOiMegB
         NUPk77gnQVSZIJpQb4o3yxi5iEzNdoSPLTh5jJy8s284reoIce1D3tTBae+8F6D3gb
         widqJi9MZ3YzTHDbXf9PjLbJ1N3QZHGbJzo7PWlpuwMmmeDJDhpV8MtjBGnDO95k0g
         3MzllLIf0l57A==
From:   Hector Martin <marcan@marcan.st>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 10/10] brcmfmac: common: Add support for external calibration blobs
Date:   Tue, 14 Feb 2023 18:24:23 +0900
Message-Id: <20230214092423.15175-10-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230214091651.10178-1-marcan@marcan.st>
References: <20230214091651.10178-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/common.c      | 24 +++++++++++++++++++
 .../broadcom/brcm80211/brcmfmac/common.h      |  2 ++
 .../wireless/broadcom/brcm80211/brcmfmac/of.c |  7 ++++++
 3 files changed, 33 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index be68dd0cbbd2..2d0d7c9296f2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -246,6 +246,23 @@ static const u8 brcmf_default_mac_address[ETH_ALEN] = {
 	0x00, 0x90, 0x4c, 0xc5, 0x12, 0x38
 };
 
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
@@ -336,6 +353,13 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
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
index aa25abffcc7d..378a051b34b7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -54,6 +54,8 @@ struct brcmf_mp_device {
 	const char	*board_type;
 	unsigned char	mac[ETH_ALEN];
 	const char	*antenna_sku;
+	const void	*cal_blob;
+	int		cal_size;
 	union {
 		struct brcmfmac_sdio_pd sdio;
 	} bus;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index fdd0c9abc1a1..52527b61341e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -86,6 +86,13 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 	if (!of_property_read_string(np, "apple,antenna-sku", &prop))
 		settings->antenna_sku = prop;
 
+	/* The WLAN calibration blob is normally stored in SROM, but Apple
+	 * ARM64 platforms pass it via the DT instead.
+	 */
+	prop = of_get_property(np, "brcm,cal-blob", &settings->cal_size);
+	if (prop && settings->cal_size)
+		settings->cal_blob = prop;
+
 	/* Set board-type to the first string of the machine compatible prop */
 	root = of_find_node_by_path("/");
 	if (root && err) {
-- 
2.35.1

