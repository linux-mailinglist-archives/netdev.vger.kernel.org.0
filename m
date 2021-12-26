Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FD547F7E6
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 16:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbhLZPkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 10:40:05 -0500
Received: from marcansoft.com ([212.63.210.85]:56938 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234259AbhLZPj7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Dec 2021 10:39:59 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 1735644B2A;
        Sun, 26 Dec 2021 15:39:49 +0000 (UTC)
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
Subject: [PATCH 25/34] brcmfmac: cfg80211: Add support for PMKID_V3 operations
Date:   Mon, 27 Dec 2021 00:36:15 +0900
Message-Id: <20211226153624.162281-26-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211226153624.162281-1-marcan@marcan.st>
References: <20211226153624.162281-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the new PMKID_V3 API, which allows performing PMKID
mutations individually, instead of requiring the driver to keep track of
the full list. This new API is required by at least BCM4387.

Note that PMKID_V2 is not implemented yet.

Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 49 ++++++++++-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h  | 83 +++++++++++++++++++
 2 files changed, 129 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 71e932a8302c..fd2b8b822f8c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4029,6 +4029,34 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 	return 0;
 }
 
+static s32
+brcmf_pmksa_v3_op(struct brcmf_if *ifp, struct cfg80211_pmksa *pmksa,
+		  bool alive)
+{
+	struct brcmf_pmk_op_v3_le pmk_op;
+	int length = offsetof(struct brcmf_pmk_op_v3_le, pmk);
+
+	memset(&pmk_op, 0, sizeof(pmk_op));
+	pmk_op.version = cpu_to_le16(BRCMF_PMKSA_VER_3);
+
+	if (!pmksa) {
+		/* Flush operation, operate on entire list */
+		pmk_op.count = cpu_to_le16(0);
+	} else {
+		/* Single PMK operation */
+		pmk_op.count = cpu_to_le16(1);
+		length += sizeof(struct brcmf_pmksa_v3);
+		memcpy(pmk_op.pmk[0].bssid, pmksa->bssid, ETH_ALEN);
+		memcpy(pmk_op.pmk[0].pmkid, pmksa->pmkid, WLAN_PMKID_LEN);
+		pmk_op.pmk[0].pmkid_len = WLAN_PMKID_LEN;
+		pmk_op.pmk[0].time_left = alive ? BRCMF_PMKSA_NO_EXPIRY : 0;
+	}
+
+	pmk_op.length = cpu_to_le16(length);
+
+	return brcmf_fil_iovar_data_set(ifp, "pmkid_info", &pmk_op, sizeof(pmk_op));
+}
+
 static __used s32
 brcmf_update_pmklist(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp)
 {
@@ -4065,6 +4093,14 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
+	brcmf_dbg(CONN, "set_pmksa - PMK bssid: %pM =\n", pmksa->bssid);
+	brcmf_dbg(CONN, "%*ph\n", WLAN_PMKID_LEN, pmksa->pmkid);
+
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V3))
+		return brcmf_pmksa_v3_op(ifp, pmksa, true);
+
+	/* TODO: implement PMKID_V2 */
+
 	npmk = le32_to_cpu(cfg->pmk_list.npmk);
 	for (i = 0; i < npmk; i++)
 		if (!memcmp(pmksa->bssid, pmk[i].bssid, ETH_ALEN))
@@ -4081,9 +4117,6 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 		return -EINVAL;
 	}
 
-	brcmf_dbg(CONN, "set_pmksa - PMK bssid: %pM =\n", pmk[npmk].bssid);
-	brcmf_dbg(CONN, "%*ph\n", WLAN_PMKID_LEN, pmk[npmk].pmkid);
-
 	err = brcmf_update_pmklist(cfg, ifp);
 
 	brcmf_dbg(TRACE, "Exit\n");
@@ -4107,6 +4140,11 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 
 	brcmf_dbg(CONN, "del_pmksa - PMK bssid = %pM\n", pmksa->bssid);
 
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V3))
+		return brcmf_pmksa_v3_op(ifp, pmksa, false);
+
+	/* TODO: implement PMKID_V2 */
+
 	npmk = le32_to_cpu(cfg->pmk_list.npmk);
 	for (i = 0; i < npmk; i++)
 		if (!memcmp(pmksa->bssid, pmk[i].bssid, ETH_ALEN))
@@ -4143,6 +4181,11 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V3))
+		return brcmf_pmksa_v3_op(ifp, NULL, false);
+
+	/* TODO: implement PMKID_V2 */
+
 	memset(&cfg->pmk_list, 0, sizeof(cfg->pmk_list));
 	err = brcmf_update_pmklist(cfg, ifp);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 19d300dadc28..2c8063a546b6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -174,6 +174,10 @@
 
 #define BRCMF_HE_CAP_MCS_MAP_NSS_MAX	8
 
+#define BRCMF_PMKSA_VER_2		2
+#define BRCMF_PMKSA_VER_3		3
+#define BRCMF_PMKSA_NO_EXPIRY		0xffffffff
+
 /* MAX_CHUNK_LEN is the maximum length for data passing to firmware in each
  * ioctl. It is relatively small because firmware has small maximum size input
  * playload restriction for ioctls.
@@ -355,6 +359,12 @@ struct brcmf_ssid_le {
 	unsigned char SSID[IEEE80211_MAX_SSID_LEN];
 };
 
+/* Alternate SSID structure used in some places... */
+struct brcmf_ssid8_le {
+	u8 SSID_len;
+	unsigned char SSID[IEEE80211_MAX_SSID_LEN];
+};
+
 struct brcmf_scan_params_le {
 	struct brcmf_ssid_le ssid_le;	/* default: {0, ""} */
 	u8 bssid[ETH_ALEN];	/* default: bcast */
@@ -875,6 +885,51 @@ struct brcmf_pmksa {
 	u8 pmkid[WLAN_PMKID_LEN];
 };
 
+/**
+ * struct brcmf_pmksa_v2 - PMK Security Association
+ *
+ * @length: Length of the structure.
+ * @bssid: The AP's BSSID.
+ * @pmkid: The PMK ID.
+ * @pmk: PMK material for FILS key derivation.
+ * @pmk_len: Length of PMK data.
+ * @ssid: The AP's SSID.
+ * @fils_cache_id: FILS cache identifier
+ */
+struct brcmf_pmksa_v2 {
+	__le16 length;
+	u8 bssid[ETH_ALEN];
+	u8 pmkid[WLAN_PMKID_LEN];
+	u8 pmk[WLAN_PMK_LEN_SUITE_B_192];
+	__le16 pmk_len;
+	struct brcmf_ssid8_le ssid;
+	u16 fils_cache_id;
+};
+
+/**
+ * struct brcmf_pmksa_v3 - PMK Security Association
+ *
+ * @bssid: The AP's BSSID.
+ * @pmkid: The PMK ID.
+ * @pmkid_len: The length of the PMK ID.
+ * @pmk: PMK material for FILS key derivation.
+ * @pmk_len: Length of PMK data.
+ * @fils_cache_id: FILS cache identifier
+ * @ssid: The AP's SSID.
+ * @time_left: Remaining time until expiry. 0 = expired, ~0 = no expiry.
+ */
+struct brcmf_pmksa_v3 {
+	u8 bssid[ETH_ALEN];
+	u8 pmkid[WLAN_PMKID_LEN];
+	u8 pmkid_len;
+	u8 pmk[WLAN_PMK_LEN_SUITE_B_192];
+	u8 pmk_len;
+	__le16 fils_cache_id;
+	u8 pad;
+	struct brcmf_ssid8_le ssid;
+	__le32 time_left;
+};
+
 /**
  * struct brcmf_pmk_list_le - List of pmksa's.
  *
@@ -886,6 +941,34 @@ struct brcmf_pmk_list_le {
 	struct brcmf_pmksa pmk[BRCMF_MAXPMKID];
 };
 
+/**
+ * struct brcmf_pmk_list_v2_le - List of pmksa's.
+ *
+ * @version: Request version.
+ * @length: Length of this structure.
+ * @pmk: PMK SA information.
+ */
+struct brcmf_pmk_list_v2_le {
+	__le16 version;
+	__le16 length;
+	struct brcmf_pmksa_v2 pmk[BRCMF_MAXPMKID];
+};
+
+/**
+ * struct brcmf_pmk_op_v3_le - Operation on PMKSA list.
+ *
+ * @version: Request version.
+ * @length: Length of this structure.
+ * @pmk: PMK SA information.
+ */
+struct brcmf_pmk_op_v3_le {
+	__le16 version;
+	__le16 length;
+	__le16 count;
+	__le16 pad;
+	struct brcmf_pmksa_v3 pmk[BRCMF_MAXPMKID];
+};
+
 /**
  * struct brcmf_pno_param_le - PNO scan configuration parameters
  *
-- 
2.33.0

