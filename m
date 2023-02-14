Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7E1695EFF
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbjBNJ0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbjBNJ0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:26:06 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FDE241EE;
        Tue, 14 Feb 2023 01:25:52 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id A6C3D41EF0;
        Tue, 14 Feb 2023 09:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676366750; bh=LhOeRls7x4jwHrR5XoSMQk8mZI7Pma9wTdtILXcF65s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=V4hmLFdM/v6D+yy3GU3llEqgEl8DhiVPUJFwgf0VavRsGalClSWjg8mRtigZqfeTI
         YfX7vO6PJNCo2t3sdZgprYL1Duh4ACYoKpUl7mbyCvqVsA0M9lLy2TO2I+aZbeKZ79
         Ch29l5TWyGNU2pl9JwqjUdzf0oWKTmMbgAE7/nbrMWaUGL3k+NF/zRy5lUN/JXnGnr
         oLSbYr3wPuMwVeVirglRwjEUayDskEsY+mBXAY0g2Zsqry92ed2wHQjKucvgPfMBP/
         UqjZSIoAydUmePhMbjr94w3Kbxe0+4okAv7yoLkB05+4C1j5w2kR0jvb0SirkRrirx
         xl19DW79ao4+A==
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
Subject: [PATCH 05/10] brcmfmac: cfg80211: Add support for PMKID_V3 operations
Date:   Tue, 14 Feb 2023 18:24:18 +0900
Message-Id: <20230214092423.15175-5-marcan@marcan.st>
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

Add support for the new PMKID_V3 API, which allows performing PMKID
mutations individually, instead of requiring the driver to keep track of
the full list. This new API is required by at least BCM4387.

Note that PMKID_V2 is not implemented yet.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 52 +++++++++++-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h  | 83 +++++++++++++++++++
 2 files changed, 132 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 3e006b783f3f..f3450b4db156 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4306,6 +4306,37 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 	return 0;
 }
 
+static s32
+brcmf_pmksa_v3_op(struct brcmf_if *ifp, struct cfg80211_pmksa *pmksa,
+		  bool alive)
+{
+	struct brcmf_pmk_op_v3_le *pmk_op;
+	int length = offsetof(struct brcmf_pmk_op_v3_le, pmk);
+	int ret;
+
+	pmk_op = kzalloc(sizeof(*pmk_op), GFP_KERNEL);
+	pmk_op->version = cpu_to_le16(BRCMF_PMKSA_VER_3);
+
+	if (!pmksa) {
+		/* Flush operation, operate on entire list */
+		pmk_op->count = cpu_to_le16(0);
+	} else {
+		/* Single PMK operation */
+		pmk_op->count = cpu_to_le16(1);
+		length += sizeof(struct brcmf_pmksa_v3);
+		memcpy(pmk_op->pmk[0].bssid, pmksa->bssid, ETH_ALEN);
+		memcpy(pmk_op->pmk[0].pmkid, pmksa->pmkid, WLAN_PMKID_LEN);
+		pmk_op->pmk[0].pmkid_len = WLAN_PMKID_LEN;
+		pmk_op->pmk[0].time_left = cpu_to_le32(alive ? BRCMF_PMKSA_NO_EXPIRY : 0);
+	}
+
+	pmk_op->length = cpu_to_le16(length);
+
+	ret = brcmf_fil_iovar_data_set(ifp, "pmkid_info", pmk_op, sizeof(*pmk_op));
+	kfree(pmk_op);
+	return ret;
+}
+
 static __used s32
 brcmf_update_pmklist(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp)
 {
@@ -4339,6 +4370,14 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
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
@@ -4355,9 +4394,6 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 		return -EINVAL;
 	}
 
-	brcmf_dbg(CONN, "set_pmksa - PMK bssid: %pM =\n", pmk[npmk].bssid);
-	brcmf_dbg(CONN, "%*ph\n", WLAN_PMKID_LEN, pmk[npmk].pmkid);
-
 	err = brcmf_update_pmklist(cfg, ifp);
 
 	brcmf_dbg(TRACE, "Exit\n");
@@ -4381,6 +4417,11 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 
 	brcmf_dbg(CONN, "del_pmksa - PMK bssid = %pM\n", pmksa->bssid);
 
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V3))
+		return brcmf_pmksa_v3_op(ifp, pmksa, false);
+
+	/* TODO: implement PMKID_V2 */
+
 	npmk = le32_to_cpu(cfg->pmk_list.npmk);
 	for (i = 0; i < npmk; i++)
 		if (!memcmp(pmksa->bssid, pmk[i].bssid, ETH_ALEN))
@@ -4417,6 +4458,11 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
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
index 801709c26b7b..792adaf880b4 100644
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
2.35.1

