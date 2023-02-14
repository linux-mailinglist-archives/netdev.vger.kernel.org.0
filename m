Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A2A695EFA
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbjBNJ0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbjBNJZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:25:53 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B11234EE;
        Tue, 14 Feb 2023 01:25:46 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 272783FA55;
        Tue, 14 Feb 2023 09:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676366745; bh=kiyVFSPMTX4wj8SqOFpCUbIY9AGQyAr+4jKEs3bBn3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=C5PphV6q2O8c7QCTxQMCW4feGSbYy1P0YGb9DGMUOIFFsZBw9gGMz634x6jHXwBrl
         tp02VzxdvZ7URD00Nesgbf66Xw1z5xTsr+xSin69v4bR65oX2AYCAllHaNZhnSdcVq
         ur7xtBVjtQ4ApJJl2xjMlOhQl/iEu0Wmzw6InGXkWyeo4q16t9f1+TG6/cfIJn3Omr
         A/G5DTiHgbDQ2quTmiqHJMEDQ3ZOhoRdn5XfQRBOWI/KCpFjFvB9kzcOv+4kjyf1bG
         Uv5O3at2DJsijHuTGbSt/VhzYsuHxC5jgNyP2DVrxIiiBK8oPs+29I+qy2smGRZxa1
         umOaIwQZOaJAQ==
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
Subject: [PATCH 04/10] brcmfmac: feature: Add support for setting feats based on WLC version
Date:   Tue, 14 Feb 2023 18:24:17 +0900
Message-Id: <20230214092423.15175-4-marcan@marcan.st>
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

The "wlc_ver" iovar returns information on the WLC and EPI versions.
This can be used to determine whether the PMKID_V2 and _V3 features are
supported.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/feature.c     | 48 +++++++++++++++++++
 .../broadcom/brcm80211/brcmfmac/feature.h     |  4 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h  | 25 ++++++++++
 3 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index b6797f800e55..6d10c9efbe93 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -126,6 +126,53 @@ static void brcmf_feat_firmware_overrides(struct brcmf_pub *drv)
 	drv->feat_flags |= feat_flags;
 }
 
+struct brcmf_feat_wlcfeat {
+	u16 min_ver_major;
+	u16 min_ver_minor;
+	u32 feat_flags;
+};
+
+static const struct brcmf_feat_wlcfeat brcmf_feat_wlcfeat_map[] = {
+	{ 12, 0, BIT(BRCMF_FEAT_PMKID_V2) },
+	{ 13, 0, BIT(BRCMF_FEAT_PMKID_V3) },
+};
+
+static void brcmf_feat_wlc_version_overrides(struct brcmf_pub *drv)
+{
+	struct brcmf_if *ifp = brcmf_get_ifp(drv, 0);
+	const struct brcmf_feat_wlcfeat *e;
+	struct brcmf_wlc_version_le ver;
+	u32 feat_flags = 0;
+	int i, err, major, minor;
+
+	err = brcmf_fil_iovar_data_get(ifp, "wlc_ver", &ver, sizeof(ver));
+	if (err)
+		return;
+
+	major = le16_to_cpu(ver.wlc_ver_major);
+	minor = le16_to_cpu(ver.wlc_ver_minor);
+
+	brcmf_dbg(INFO, "WLC version: %d.%d\n", major, minor);
+
+	for (i = 0; i < ARRAY_SIZE(brcmf_feat_wlcfeat_map); i++) {
+		e = &brcmf_feat_wlcfeat_map[i];
+		if (major > e->min_ver_major ||
+		    (major == e->min_ver_major &&
+		     minor >= e->min_ver_minor)) {
+			feat_flags |= e->feat_flags;
+		}
+	}
+
+	if (!feat_flags)
+		return;
+
+	for (i = 0; i < BRCMF_FEAT_LAST; i++)
+		if (feat_flags & BIT(i))
+			brcmf_dbg(INFO, "enabling firmware feature: %s\n",
+				  brcmf_feat_names[i]);
+	drv->feat_flags |= feat_flags;
+}
+
 /**
  * brcmf_feat_iovar_int_get() - determine feature through iovar query.
  *
@@ -299,6 +346,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 		ifp->drvr->feat_flags &= ~drvr->settings->feature_disable;
 	}
 
+	brcmf_feat_wlc_version_overrides(drvr);
 	brcmf_feat_firmware_overrides(drvr);
 
 	/* set chip related quirks */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index 549298c55b55..7f4f0b3e4a7b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -55,7 +55,9 @@
 	BRCMF_FEAT_DEF(SAE) \
 	BRCMF_FEAT_DEF(FWAUTH) \
 	BRCMF_FEAT_DEF(DUMP_OBSS) \
-	BRCMF_FEAT_DEF(SCAN_V2)
+	BRCMF_FEAT_DEF(SCAN_V2) \
+	BRCMF_FEAT_DEF(PMKID_V2) \
+	BRCMF_FEAT_DEF(PMKID_V3)
 
 /*
  * Quirks:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index b3844d0d1adb..801709c26b7b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -788,6 +788,31 @@ struct brcmf_rev_info_le {
 	__le32 nvramrev;
 };
 
+/**
+ * struct brcmf_wlc_version_le - firmware revision info.
+ *
+ * @version: structure version.
+ * @length: structure length.
+ * @epi_ver_major: EPI major version
+ * @epi_ver_minor: EPI minor version
+ * @epi_ver_rc: EPI rc version
+ * @epi_ver_incr: EPI increment version
+ * @wlc_ver_major: WLC major version
+ * @wlc_ver_minor: WLC minor version
+ */
+struct brcmf_wlc_version_le {
+	__le16 version;
+	__le16 length;
+
+	__le16 epi_ver_major;
+	__le16 epi_ver_minor;
+	__le16 epi_ver_rc;
+	__le16 epi_ver_incr;
+
+	__le16 wlc_ver_major;
+	__le16 wlc_ver_minor;
+};
+
 /**
  * struct brcmf_assoclist_le - request assoc list.
  *
-- 
2.35.1

