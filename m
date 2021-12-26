Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C6847F7EC
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 16:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhLZPkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 10:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbhLZPj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 10:39:59 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CCAC06175C;
        Sun, 26 Dec 2021 07:39:50 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 0763744B24;
        Sun, 26 Dec 2021 15:39:41 +0000 (UTC)
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
Subject: [PATCH 24/34] brcmfmac: feature: Add support for setting feats based on WLC version
Date:   Mon, 27 Dec 2021 00:36:14 +0900
Message-Id: <20211226153624.162281-25-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211226153624.162281-1-marcan@marcan.st>
References: <20211226153624.162281-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "wlc_ver" iovar returns information on the WLC and EPI versions.
This can be used to determine whether the PMKID_V2 and _V3 features are
supported.

Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/feature.c     | 48 +++++++++++++++++++
 .../broadcom/brcm80211/brcmfmac/feature.h     |  4 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h  | 25 ++++++++++
 3 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index d0fada88f0f0..def4c9648645 100644
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
@@ -296,6 +343,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 		ifp->drvr->feat_flags &= ~drvr->settings->feature_disable;
 	}
 
+	brcmf_feat_wlc_version_overrides(drvr);
 	brcmf_feat_firmware_overrides(drvr);
 
 	/* set chip related quirks */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index 9d098a068d13..becbcc50d57a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -53,7 +53,9 @@
 	BRCMF_FEAT_DEF(DOT11H) \
 	BRCMF_FEAT_DEF(SAE) \
 	BRCMF_FEAT_DEF(FWAUTH) \
-	BRCMF_FEAT_DEF(SCAN_V2)
+	BRCMF_FEAT_DEF(SCAN_V2) \
+	BRCMF_FEAT_DEF(PMKID_V2) \
+	BRCMF_FEAT_DEF(PMKID_V3)
 
 /*
  * Quirks:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 2ef3fcbb00b9..19d300dadc28 100644
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
2.33.0

