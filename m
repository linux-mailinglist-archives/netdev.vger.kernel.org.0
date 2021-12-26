Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F41D47F7FF
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 16:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhLZPkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 10:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbhLZPj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 10:39:28 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CB8C06175A;
        Sun, 26 Dec 2021 07:39:26 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id EC7AD44B48;
        Sun, 26 Dec 2021 15:39:17 +0000 (UTC)
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
Subject: [PATCH 21/34] brcmfmac: chip: Only disable D11 cores; handle an arbitrary number
Date:   Mon, 27 Dec 2021 00:36:11 +0900
Message-Id: <20211226153624.162281-22-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211226153624.162281-1-marcan@marcan.st>
References: <20211226153624.162281-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At least on BCM4387, the D11 cores are held in reset on cold startup and
firmware expects to release reset itself. Just assert reset here and let
firmware deassert it. Premature deassertion results in the firmware
failing to initialize properly some of the time, with strange AXI bus
errors.

Also, BCM4387 has 3 cores, up from 2. The logic for handling that is in
brcmf_chip_ai_resetcore(), but since we aren't using that any more, just
handle it here.

Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 73ab96968ac6..713546cebd5a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -1289,15 +1289,18 @@ static bool brcmf_chip_cm3_set_active(struct brcmf_chip_priv *chip)
 static inline void
 brcmf_chip_cr4_set_passive(struct brcmf_chip_priv *chip)
 {
+	int i;
 	struct brcmf_core *core;
 
 	brcmf_chip_disable_arm(chip, BCMA_CORE_ARM_CR4);
 
-	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_80211);
-	brcmf_chip_resetcore(core, D11_BCMA_IOCTL_PHYRESET |
-				   D11_BCMA_IOCTL_PHYCLOCKEN,
-			     D11_BCMA_IOCTL_PHYCLOCKEN,
-			     D11_BCMA_IOCTL_PHYCLOCKEN);
+	/* Disable the cores only and let the firmware enable them.
+	 * Releasing reset ourselves breaks BCM4387 in weird ways.
+	 */
+	for (i = 0; (core = brcmf_chip_get_d11core(&chip->pub, i)); i++)
+		brcmf_chip_coredisable(core, D11_BCMA_IOCTL_PHYRESET |
+				       D11_BCMA_IOCTL_PHYCLOCKEN,
+				       D11_BCMA_IOCTL_PHYCLOCKEN);
 }
 
 static bool brcmf_chip_cr4_set_active(struct brcmf_chip_priv *chip, u32 rstvec)
-- 
2.33.0

