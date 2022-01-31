Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FF14A4B76
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343537AbiAaQKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349651AbiAaQJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:09:55 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA2BC061763;
        Mon, 31 Jan 2022 08:08:47 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id D0A4D41F7F;
        Mon, 31 Jan 2022 16:08:38 +0000 (UTC)
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
Subject: [PATCH v4 9/9] brcmfmac: pcie: Read the console on init and shutdown
Date:   Tue,  1 Feb 2022 01:07:13 +0900
Message-Id: <20220131160713.245637-10-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220131160713.245637-1-marcan@marcan.st>
References: <20220131160713.245637-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows us to get console messages if the firmware crashed during
early init, or if an operation failed and we're about to shut down.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 3ff4997e1c97..4fe341376a16 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -744,6 +744,8 @@ static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo,
 		return;
 
 	console = &devinfo->shared.console;
+	if (!console->base_addr)
+		return;
 	addr = console->base_addr + BRCMF_CONSOLE_WRITEIDX_OFFSET;
 	newidx = brcmf_pcie_read_tcm32(devinfo, addr);
 	while (newidx != console->read_idx) {
@@ -1520,6 +1522,7 @@ brcmf_pcie_init_share_ram_info(struct brcmf_pciedev_info *devinfo,
 		  shared->max_rxbufpost, shared->rx_dataoffset);
 
 	brcmf_pcie_bus_console_init(devinfo);
+	brcmf_pcie_bus_console_read(devinfo, false);
 
 	return 0;
 }
@@ -1959,6 +1962,7 @@ brcmf_pcie_remove(struct pci_dev *pdev)
 		return;
 
 	devinfo = bus->bus_priv.pcie->devinfo;
+	brcmf_pcie_bus_console_read(devinfo, false);
 
 	devinfo->state = BRCMFMAC_PCIE_STATE_DOWN;
 	if (devinfo->ci)
-- 
2.33.0

