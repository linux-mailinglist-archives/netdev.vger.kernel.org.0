Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFEB695EF0
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbjBNJZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjBNJZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:25:33 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF50233D6;
        Tue, 14 Feb 2023 01:25:28 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id A84703FA55;
        Tue, 14 Feb 2023 09:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676366726; bh=314UXgDCtZ3kdOtQKtcZP693f9fhR2R2wD0sbLyzkhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Lco/4bv0VJVUCAnF9xE3jz8FuKarnLH1edAh1p0tcmFLHFMk6KGmsXMl0TgVbDyYg
         oq5X2/MbP4gcJkDao3/m+Lvxh0CuWK57XSfIWkRC34RvLOQAnbFDJn6BMU9/Wew/xd
         N/36AhvTJLMqzK+ipcHM675a868IfLTwwx3V89nrxNVevcTZwixyHilkypBYqCi1iS
         zlQnLDD7pPqP6+jm/hOOxkLjrEVZJSXoDshItFaiSLIIS28o66bESCblikIEMJ7V/g
         aHyc1HM4bDB0gCP5FnEhrW7ylgw+IbBYycpkQ0xYCNlrn9aZeoM6ZaNWXD4AQpmfDT
         PQUTKCwb59YKw==
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
Subject: [PATCH 01/10] brcmfmac: chip: Only disable D11 cores; handle an arbitrary number
Date:   Tue, 14 Feb 2023 18:24:14 +0900
Message-Id: <20230214092423.15175-1-marcan@marcan.st>
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

At least on BCM4387, the D11 cores are held in reset on cold startup and
firmware expects to release reset itself. Just assert reset here and let
firmware deassert it. Premature deassertion results in the firmware
failing to initialize properly some of the time, with strange AXI bus
errors.

Also, BCM4387 has 3 cores, up from 2. The logic for handling that is in
brcmf_chip_ai_resetcore(), but since we aren't using that any more, just
handle it here.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 8073f31be27d..a6239051404b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -1292,15 +1292,18 @@ static bool brcmf_chip_cm3_set_active(struct brcmf_chip_priv *chip)
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
2.35.1

