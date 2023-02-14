Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B21695EF3
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjBNJZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbjBNJZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:25:35 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A0810433;
        Tue, 14 Feb 2023 01:25:35 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id D82F541A36;
        Tue, 14 Feb 2023 09:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676366733; bh=/8Wa1xp66OasY/4qg0g0e58vj0bjHYWqCuEoT5jLVMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=BqCoyFV83ol16p1hcfmWweUDMFDyQI/U1BOgHqqgS0BF8+YaNC/S0dFFfV6xr8Z+P
         M05LdL4zoPOluo8bua8o1yKuUgPO64tAIYewVJo5rLoxF81TNO6qrbt4278z0zUijU
         /AMhnhvSjiM6rR2GIw/r6eRkSvB6j/E7tNxf61r06VpA2LKgzir0FJ6audkV7cNPLs
         P5FQeXGEUzCvUs6v0We1Z//XumvlH7mSjjIBFoEka28ml9HcVm2Cv6LxZOy6c0irLg
         JbKpf2s/1kji78pym9AJO6Zoca2UVecBK14vajyxQEBRot4zkaqM0qNYFprWGhtWDi
         PdaR8SWee7YVw==
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
Subject: [PATCH 02/10] brcmfmac: chip: Handle 1024-unit sizes for TCM blocks
Date:   Tue, 14 Feb 2023 18:24:15 +0900
Message-Id: <20230214092423.15175-2-marcan@marcan.st>
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

BCM4387 has trailing odd-sized blocks as part of TCM which have
their size described as a multiple of 1024 instead of 8192. Handle this
so we can compute the TCM size properly.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/chip.c    | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index a6239051404b..50e0c015cf43 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -212,8 +212,9 @@ struct sbsocramregs {
 #define	ARMCR4_TCBANB_MASK	0xf
 #define	ARMCR4_TCBANB_SHIFT	0
 
-#define	ARMCR4_BSZ_MASK		0x3f
+#define	ARMCR4_BSZ_MASK		0x7f
 #define	ARMCR4_BSZ_MULT		8192
+#define	ARMCR4_BLK_1K_MASK	0x200
 
 struct brcmf_core_priv {
 	struct brcmf_core pub;
@@ -684,6 +685,7 @@ static u32 brcmf_chip_tcm_ramsize(struct brcmf_core_priv *cr4)
 	u32 nbb;
 	u32 totb;
 	u32 bxinfo;
+	u32 blksize;
 	u32 idx;
 
 	corecap = brcmf_chip_core_read32(cr4, ARMCR4_CAP);
@@ -695,7 +697,11 @@ static u32 brcmf_chip_tcm_ramsize(struct brcmf_core_priv *cr4)
 	for (idx = 0; idx < totb; idx++) {
 		brcmf_chip_core_write32(cr4, ARMCR4_BANKIDX, idx);
 		bxinfo = brcmf_chip_core_read32(cr4, ARMCR4_BANKINFO);
-		memsize += ((bxinfo & ARMCR4_BSZ_MASK) + 1) * ARMCR4_BSZ_MULT;
+		blksize = ARMCR4_BSZ_MULT;
+		if (bxinfo & ARMCR4_BLK_1K_MASK)
+			blksize >>= 3;
+
+		memsize += ((bxinfo & ARMCR4_BSZ_MASK) + 1) * blksize;
 	}
 
 	return memsize;
-- 
2.35.1

