Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99272490A7A
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 15:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239675AbiAQObx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 09:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239730AbiAQOb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 09:31:28 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32421C06175B;
        Mon, 17 Jan 2022 06:31:12 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 235D541E96;
        Mon, 17 Jan 2022 14:31:02 +0000 (UTC)
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
        SHA-cyfmac-dev-list@infineon.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH v3 6/9] brcmfmac: pcie: Fix crashes due to early IRQs
Date:   Mon, 17 Jan 2022 23:29:16 +0900
Message-Id: <20220117142919.207370-7-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220117142919.207370-1-marcan@marcan.st>
References: <20220117142919.207370-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver was enabling IRQs before the message processing was
initialized. This could cause IRQs to come in too early and crash the
driver. Instead, move the IRQ enable and hostready to a bus preinit
function, at which point everything is properly initialized.

Fixes: 9e37f045d5e7 ("brcmfmac: Adding PCIe bus layer support.")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c  | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index c25f48db1f60..3ff4997e1c97 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1315,6 +1315,18 @@ static void brcmf_pcie_down(struct device *dev)
 {
 }
 
+static int brcmf_pcie_preinit(struct device *dev)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pciedev *buspub = bus_if->bus_priv.pcie;
+
+	brcmf_dbg(PCIE, "Enter\n");
+
+	brcmf_pcie_intr_enable(buspub->devinfo);
+	brcmf_pcie_hostready(buspub->devinfo);
+
+	return 0;
+}
 
 static int brcmf_pcie_tx(struct device *dev, struct sk_buff *skb)
 {
@@ -1423,6 +1435,7 @@ static int brcmf_pcie_reset(struct device *dev)
 }
 
 static const struct brcmf_bus_ops brcmf_pcie_bus_ops = {
+	.preinit = brcmf_pcie_preinit,
 	.txdata = brcmf_pcie_tx,
 	.stop = brcmf_pcie_down,
 	.txctl = brcmf_pcie_tx_ctlpkt,
@@ -1795,9 +1808,6 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
 
 	init_waitqueue_head(&devinfo->mbdata_resp_wait);
 
-	brcmf_pcie_intr_enable(devinfo);
-	brcmf_pcie_hostready(devinfo);
-
 	ret = brcmf_attach(&devinfo->pdev->dev);
 	if (ret)
 		goto fail;
-- 
2.33.0

