Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CE2695F52
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjBNJeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbjBNJeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:34:18 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7F1234E1;
        Tue, 14 Feb 2023 01:34:08 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 0AF303FA55;
        Tue, 14 Feb 2023 09:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676367247; bh=uhpRt3+5FIqGahR9GdpBYrp1h2hl6A/u/kJ5dtfJNJw=;
        h=From:To:Cc:Subject:Date;
        b=gu2+/FMwES0WX8WVxnej/DMktl5juSIAf11Zi3Y3KkTSrmkcGUkgLoiVBZZ76hUKT
         g5kdi3WMQQ5EVDuLkQvJ1QVR+5bIOnNLYN+nHBkU0GPROYCI39DeMr17NsoxNu1B2d
         dg8I7yQtc/lCgd4cANW6oanDk6SOuHIvtQqsQpVAzjPqLKeRRSRThHeu/t/yIMOw19
         UyHK/PmFAhduCmwDJF+xAvV/D3+R0r7IBbFNuK/h4RQOQ3khrvWqdLNnjHSN5znI/9
         79x2lIxL4Hht5c6nkLNbUh+hfiw6IAgo4uGjdwfCgnq3ECikEppKC7zdQLwJwDbAfz
         X8Dkpftajh1aw==
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
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>
Subject: [PATCH] brcmfmac: cfg80211: Use WSEC to set SAE password
Date:   Tue, 14 Feb 2023 18:33:19 +0900
Message-Id: <20230214093319.21077-1-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
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

Using the WSEC command instead of sae_password seems to be the supported
mechanism on newer firmware, and also how the brcmdhd driver does it.

Signed-off-by: Hector Martin <marcan@marcan.st>
---
Note: must be applied after:

[PATCH 06/10] brcmfmac: cfg80211: Pass the PMK in binary instead of hex

Since that is reviewed and this isn't yet, I expect that will go in
first anyway.

 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 46 ++++++++-----------
 .../broadcom/brcm80211/brcmfmac/fwil_types.h  |  2 +-
 2 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 18e6699d4024..e4690d56e7c3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1682,52 +1682,44 @@ static u16 brcmf_map_fw_linkdown_reason(const struct brcmf_event_msg *e)
 	return reason;
 }
 
-static int brcmf_set_pmk(struct brcmf_if *ifp, const u8 *pmk_data, u16 pmk_len)
+static int brcmf_set_wsec(struct brcmf_if *ifp, const u8 *key, u16 key_len, u16 flags)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct brcmf_wsec_pmk_le pmk;
 	int err;
 
+	if (key_len > sizeof(pmk.key)) {
+		bphy_err(drvr, "key must be less than %zu bytes\n",
+			 sizeof(pmk.key));
+		return -EINVAL;
+	}
+
 	memset(&pmk, 0, sizeof(pmk));
 
-	/* pass pmk directly */
-	pmk.key_len = cpu_to_le16(pmk_len);
-	pmk.flags = cpu_to_le16(0);
-	memcpy(pmk.key, pmk_data, pmk_len);
+	/* pass key material directly */
+	pmk.key_len = cpu_to_le16(key_len);
+	pmk.flags = cpu_to_le16(flags);
+	memcpy(pmk.key, key, key_len);
 
-	/* store psk in firmware */
+	/* store key material in firmware */
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_WSEC_PMK,
 				     &pmk, sizeof(pmk));
 	if (err < 0)
 		bphy_err(drvr, "failed to change PSK in firmware (len=%u)\n",
-			 pmk_len);
+			 key_len);
 
 	return err;
 }
 
+static int brcmf_set_pmk(struct brcmf_if *ifp, const u8 *pmk_data, u16 pmk_len)
+{
+	return brcmf_set_wsec(ifp, pmk_data, pmk_len, 0);
+}
+
 static int brcmf_set_sae_password(struct brcmf_if *ifp, const u8 *pwd_data,
 				  u16 pwd_len)
 {
-	struct brcmf_pub *drvr = ifp->drvr;
-	struct brcmf_wsec_sae_pwd_le sae_pwd;
-	int err;
-
-	if (pwd_len > BRCMF_WSEC_MAX_SAE_PASSWORD_LEN) {
-		bphy_err(drvr, "sae_password must be less than %d\n",
-			 BRCMF_WSEC_MAX_SAE_PASSWORD_LEN);
-		return -EINVAL;
-	}
-
-	sae_pwd.key_len = cpu_to_le16(pwd_len);
-	memcpy(sae_pwd.key, pwd_data, pwd_len);
-
-	err = brcmf_fil_iovar_data_set(ifp, "sae_password", &sae_pwd,
-				       sizeof(sae_pwd));
-	if (err < 0)
-		bphy_err(drvr, "failed to set SAE password in firmware (len=%u)\n",
-			 pwd_len);
-
-	return err;
+	return brcmf_set_wsec(ifp, pwd_data, pwd_len, BRCMF_WSEC_PASSPHRASE);
 }
 
 static void brcmf_link_down(struct brcmf_cfg80211_vif *vif, u16 reason,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 792adaf880b4..3ba90878c47d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -574,7 +574,7 @@ struct brcmf_wsec_key_le {
 struct brcmf_wsec_pmk_le {
 	__le16  key_len;
 	__le16  flags;
-	u8 key[2 * BRCMF_WSEC_MAX_PSK_LEN + 1];
+	u8 key[BRCMF_WSEC_MAX_SAE_PASSWORD_LEN];
 };
 
 /**
-- 
2.35.1

