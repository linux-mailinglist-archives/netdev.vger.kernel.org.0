Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C112E6916DD
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 03:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjBJCvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 21:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjBJCvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 21:51:32 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819827431E;
        Thu,  9 Feb 2023 18:51:03 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 866D541EF0;
        Fri, 10 Feb 2023 02:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1675997461; bh=oD5HXirQeIT2xQaWWuTkE6auxXaVpayxwb02Xu0ejvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=phtFB7EMV0dIgZRy6d78jqpkAKFrcJvZYPNkaq/BBPM7eJL4vUkz0H84W/0FBqV5L
         tU4eNzOAiUujSEX/dtAfzxu12UO087CEkFrXQWq7iWoTi/3uHCPslYnaSih2rLyqpt
         NwxxFZpw8EwXXhpW/lCM8PYubVCm+4Jvr/hVXB5YeJt+YL3DPWpd1uVw2oY9qlNTjY
         y9FnYsHIt2+ia0IGNGsMd7zel4iXNdRVEm6BbtPgpxKbFlvmT+RPzLHiV67+inwATj
         /DdHGtKlAWbp9SwdeUpKZJKfFYIQdbGzRW+ec42tVWTSNgtLcC/IxZSegy2MsmET5E
         UJL4G3RrEyCMg==
From:   Hector Martin <marcan@marcan.st>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Prutskov <alep@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Soontak Lee <soontak.lee@cypress.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Aditya Garg <gargaditya08@live.com>,
        Jonas Gorski <jonas.gorski@gmail.com>, asahi@lists.linux.dev,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH v3 4/4] brcmfmac: pcie: Perform correct BCM4364 firmware selection
Date:   Fri, 10 Feb 2023 11:50:09 +0900
Message-Id: <20230210025009.21873-5-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230210025009.21873-1-marcan@marcan.st>
References: <20230210025009.21873-1-marcan@marcan.st>
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

This chip exists in two revisions (B2=r3 and B3=r4) on different
platforms, and was added without regard to doing proper firmware
selection or differentiating between them. Fix this to have proper
per-revision firmwares and support Apple NVRAM selection.

Revision B2 is present on at least these Apple T2 Macs:

kauai:    MacBook Pro 15" (Touch/2018-2019)
maui:     MacBook Pro 13" (Touch/2018-2019)
lanai:    Mac mini (Late 2018)
ekans:    iMac Pro 27" (5K, Late 2017)

And these non-T2 Macs:

nihau:    iMac 27" (5K, 2019)

Revision B3 is present on at least these Apple T2 Macs:

bali:     MacBook Pro 16" (2019)
trinidad: MacBook Pro 13" (2020, 4 TB3)
borneo:   MacBook Pro 16" (2019, 5600M)
kahana:   Mac Pro (2019)
kahana:   Mac Pro (2019, Rack)
hanauma:  iMac 27" (5K, 2020)
kure:     iMac 27" (5K, 2020, 5700/XT)

v2: Also fix the firmware interface for 4364, from BCA to WCC.

Fixes: 24f0bd136264 ("brcmfmac: add the BRCM 4364 found in MacBook Pro 15,2")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index d54394885af7..f320b6ce8bff 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -57,7 +57,8 @@ BRCMF_FW_CLM_DEF(4356, "brcmfmac4356-pcie");
 BRCMF_FW_CLM_DEF(43570, "brcmfmac43570-pcie");
 BRCMF_FW_DEF(4358, "brcmfmac4358-pcie");
 BRCMF_FW_DEF(4359, "brcmfmac4359-pcie");
-BRCMF_FW_DEF(4364, "brcmfmac4364-pcie");
+BRCMF_FW_CLM_DEF(4364B2, "brcmfmac4364b2-pcie");
+BRCMF_FW_CLM_DEF(4364B3, "brcmfmac4364b3-pcie");
 BRCMF_FW_DEF(4365B, "brcmfmac4365b-pcie");
 BRCMF_FW_DEF(4365C, "brcmfmac4365c-pcie");
 BRCMF_FW_DEF(4366B, "brcmfmac4366b-pcie");
@@ -88,7 +89,8 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43570_CHIP_ID, 0xFFFFFFFF, 43570),
 	BRCMF_FW_ENTRY(BRCM_CC_4358_CHIP_ID, 0xFFFFFFFF, 4358),
 	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
-	BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0xFFFFFFFF, 4364),
+	BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0x0000000F, 4364B2), /* 3 */
+	BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0xFFFFFFF0, 4364B3), /* 4 */
 	BRCMF_FW_ENTRY(BRCM_CC_4365_CHIP_ID, 0x0000000F, 4365B),
 	BRCMF_FW_ENTRY(BRCM_CC_4365_CHIP_ID, 0xFFFFFFF0, 4365C),
 	BRCMF_FW_ENTRY(BRCM_CC_4366_CHIP_ID, 0x0000000F, 4366B),
@@ -2003,6 +2005,11 @@ static int brcmf_pcie_read_otp(struct brcmf_pciedev_info *devinfo)
 		base = 0x8c0;
 		words = 0xb2;
 		break;
+	case BRCM_CC_4364_CHIP_ID:
+		coreid = BCMA_CORE_CHIPCOMMON;
+		base = 0x8c0;
+		words = 0x1a0;
+		break;
 	case BRCM_CC_4377_CHIP_ID:
 	case BRCM_CC_4378_CHIP_ID:
 		coreid = BCMA_CORE_GCI;
@@ -2611,7 +2618,7 @@ static const struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_2G_DEVICE_ID, WCC),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_5G_DEVICE_ID, WCC),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_RAW_DEVICE_ID, WCC),
-	BRCMF_PCIE_DEVICE(BRCM_PCIE_4364_DEVICE_ID, BCA),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4364_DEVICE_ID, WCC),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4365_DEVICE_ID, BCA),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4365_2G_DEVICE_ID, BCA),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4365_5G_DEVICE_ID, BCA),
-- 
2.35.1

