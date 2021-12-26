Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E2547F808
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 16:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbhLZPkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 10:40:52 -0500
Received: from marcansoft.com ([212.63.210.85]:57190 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232743AbhLZPkb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Dec 2021 10:40:31 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 3511544B2A;
        Sun, 26 Dec 2021 15:40:21 +0000 (UTC)
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
Subject: [PATCH 29/34] brcmfmac: pcie: Read the console on init and shutdown
Date:   Mon, 27 Dec 2021 00:36:19 +0900
Message-Id: <20211226153624.162281-30-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211226153624.162281-1-marcan@marcan.st>
References: <20211226153624.162281-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows us to get console messages if the firmware crashed during
early init, or if an operation failed and we're about to shut down.

Signed-off-by: Hector Martin <marcan@marcan.st>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 6cf55027e0d7..4202ca2e9381 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -851,6 +851,8 @@ static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo,
 		return;
 
 	console = &devinfo->shared.console;
+	if (!console->base_addr)
+		return;
 	addr = console->base_addr + BRCMF_CONSOLE_WRITEIDX_OFFSET;
 	newidx = brcmf_pcie_read_tcm32(devinfo, addr);
 	while (newidx != console->read_idx) {
@@ -1627,6 +1629,7 @@ brcmf_pcie_init_share_ram_info(struct brcmf_pciedev_info *devinfo,
 		  shared->max_rxbufpost, shared->rx_dataoffset);
 
 	brcmf_pcie_bus_console_init(devinfo);
+	brcmf_pcie_bus_console_read(devinfo, false);
 
 	return 0;
 }
@@ -2394,6 +2397,7 @@ brcmf_pcie_remove(struct pci_dev *pdev)
 		return;
 
 	devinfo = bus->bus_priv.pcie->devinfo;
+	brcmf_pcie_bus_console_read(devinfo, false);
 
 	devinfo->state = BRCMFMAC_PCIE_STATE_DOWN;
 	if (devinfo->ci)
-- 
2.33.0

