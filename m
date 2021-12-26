Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADFB47F7E0
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 16:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhLZPjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 10:39:48 -0500
Received: from marcansoft.com ([212.63.210.85]:56738 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234113AbhLZPjf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Dec 2021 10:39:35 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id F363544B4A;
        Sun, 26 Dec 2021 15:39:25 +0000 (UTC)
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
Subject: [PATCH 22/34] brcmfmac: chip: Handle 1024-unit sizes for TCM blocks
Date:   Mon, 27 Dec 2021 00:36:12 +0900
Message-Id: <20211226153624.162281-23-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211226153624.162281-1-marcan@marcan.st>
References: <20211226153624.162281-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BCM4387 has trailing odd-sized blocks as part of TCM which have
their size described as a multiple of 1024 instead of 8192. Handle this
so we can compute the TCM size properly.

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

