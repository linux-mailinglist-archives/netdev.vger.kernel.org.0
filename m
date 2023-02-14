Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103B2695F0B
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbjBNJ0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbjBNJ0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:26:18 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C6A244BC;
        Tue, 14 Feb 2023 01:25:57 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 2F137423CD;
        Tue, 14 Feb 2023 09:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676366756; bh=sNsHpSeG7aIfT4zedGW0Q+9YV78TXq/I5hsq0+8G9b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=CL+9PZ+7gefzYNYYX5jBOp3LYvnPh+b01iiKTOUylbD97uMJYDtSI062VgnvVXGu6
         6Cc6AUN/dxvRZN08M1HQK3KzvMiPwDxY2B8BRhS+A1+nWoLPfk0u6VFDe4SpOnx/i9
         HwH83JGlw8hCdq//W4tTcVcEEYRoenZKTDx1J5l6ndqBRsXvVssogIjIV/IuSmLwmk
         c1PrAIpRr/XBr7F4pr/6MGxLOKKzVyqvyu+HAQwRGD4bxdj9iA4XT4B5bYKwfSFSGr
         7oqNLeBIaqHfpsixeubQh3QV2e4o1362GhPicCEt2d9eCv2kfvf4UjRoAUc1wdhVp3
         hgyGKNEaVOTKA==
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
Subject: [PATCH 06/10] brcmfmac: cfg80211: Pass the PMK in binary instead of hex
Date:   Tue, 14 Feb 2023 18:24:19 +0900
Message-Id: <20230214092423.15175-6-marcan@marcan.st>
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

Apparently the hex passphrase mechanism does not work on newer
chips/firmware (e.g. BCM4387). It seems there was a simple way of
passing it in binary all along, so use that and avoid the hexification.

OpenBSD has been doing it like this from the beginning, so this should
work on all chips.

Also clear the structure before setting the PMK. This was leaking
uninitialized stack contents to the device.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index f3450b4db156..18e6699d4024 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1686,13 +1686,14 @@ static int brcmf_set_pmk(struct brcmf_if *ifp, const u8 *pmk_data, u16 pmk_len)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct brcmf_wsec_pmk_le pmk;
-	int i, err;
+	int err;
+
+	memset(&pmk, 0, sizeof(pmk));
 
-	/* convert to firmware key format */
-	pmk.key_len = cpu_to_le16(pmk_len << 1);
-	pmk.flags = cpu_to_le16(BRCMF_WSEC_PASSPHRASE);
-	for (i = 0; i < pmk_len; i++)
-		snprintf(&pmk.key[2 * i], 3, "%02x", pmk_data[i]);
+	/* pass pmk directly */
+	pmk.key_len = cpu_to_le16(pmk_len);
+	pmk.flags = cpu_to_le16(0);
+	memcpy(pmk.key, pmk_data, pmk_len);
 
 	/* store psk in firmware */
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_WSEC_PMK,
-- 
2.35.1

