Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC84483CB0
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbiADHa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbiADHam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 02:30:42 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915D7C061396;
        Mon,  3 Jan 2022 23:30:42 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id AB276419BC;
        Tue,  4 Jan 2022 07:30:33 +0000 (UTC)
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
Subject: [PATCH v2 22/35] brcmfmac: chip: Handle 1024-unit sizes for TCM blocks
Date:   Tue,  4 Jan 2022 16:26:45 +0900
Message-Id: <20220104072658.69756-23-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st>
References: <20220104072658.69756-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BCM4387 has trailing odd-sized blocks as part of TCM which have
their size described as a multiple of 1024 instead of 8192. Handle this
so we can compute the TCM size properly.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 713546cebd5a..cfa93e3ef1a1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -212,8 +212,8 @@ struct sbsocramregs {
 #define	ARMCR4_TCBANB_MASK	0xf
 #define	ARMCR4_TCBANB_SHIFT	0
 
-#define	ARMCR4_BSZ_MASK		0x3f
-#define	ARMCR4_BSZ_MULT		8192
+#define	ARMCR4_BSZ_MASK		0x7f
+#define	ARMCR4_BLK_1K_MASK	0x200
 
 struct brcmf_core_priv {
 	struct brcmf_core pub;
@@ -675,7 +675,8 @@ static u32 brcmf_chip_sysmem_ramsize(struct brcmf_core_priv *sysmem)
 }
 
 /** Return the TCM-RAM size of the ARMCR4 core. */
-static u32 brcmf_chip_tcm_ramsize(struct brcmf_core_priv *cr4)
+static u32 brcmf_chip_tcm_ramsize(struct brcmf_chip_priv *ci,
+				  struct brcmf_core_priv *cr4)
 {
 	u32 corecap;
 	u32 memsize = 0;
@@ -683,6 +684,7 @@ static u32 brcmf_chip_tcm_ramsize(struct brcmf_core_priv *cr4)
 	u32 nbb;
 	u32 totb;
 	u32 bxinfo;
+	u32 blksize;
 	u32 idx;
 
 	corecap = brcmf_chip_core_read32(cr4, ARMCR4_CAP);
@@ -694,7 +696,12 @@ static u32 brcmf_chip_tcm_ramsize(struct brcmf_core_priv *cr4)
 	for (idx = 0; idx < totb; idx++) {
 		brcmf_chip_core_write32(cr4, ARMCR4_BANKIDX, idx);
 		bxinfo = brcmf_chip_core_read32(cr4, ARMCR4_BANKINFO);
-		memsize += ((bxinfo & ARMCR4_BSZ_MASK) + 1) * ARMCR4_BSZ_MULT;
+		if (bxinfo & ARMCR4_BLK_1K_MASK)
+			blksize = 1024;
+		else
+			blksize = 8192;
+
+		memsize += ((bxinfo & ARMCR4_BSZ_MASK) + 1) * blksize;
 	}
 
 	return memsize;
@@ -752,7 +759,7 @@ int brcmf_chip_get_raminfo(struct brcmf_chip *pub)
 	mem = brcmf_chip_get_core(&ci->pub, BCMA_CORE_ARM_CR4);
 	if (mem) {
 		mem_core = container_of(mem, struct brcmf_core_priv, pub);
-		ci->pub.ramsize = brcmf_chip_tcm_ramsize(mem_core);
+		ci->pub.ramsize = brcmf_chip_tcm_ramsize(ci, mem_core);
 		ci->pub.rambase = brcmf_chip_tcm_rambase(ci);
 		if (ci->pub.rambase == INVALID_RAMBASE) {
 			brcmf_err("RAM base not provided with ARM CR4 core\n");
-- 
2.33.0

