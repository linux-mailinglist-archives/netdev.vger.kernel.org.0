Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28A2483CB4
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbiADHbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbiADHav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 02:30:51 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3501C06139C;
        Mon,  3 Jan 2022 23:30:50 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id ACBAD41F5D;
        Tue,  4 Jan 2022 07:30:41 +0000 (UTC)
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
Subject: [PATCH v2 23/35] brcmfmac: cfg80211: Add support for scan params v2
Date:   Tue,  4 Jan 2022 16:26:46 +0900
Message-Id: <20220104072658.69756-24-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st>
References: <20220104072658.69756-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new API version is required for at least the BCM4387 firmware. Add
support for it, with a fallback to the v1 API.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 113 ++++++++++++++----
 .../broadcom/brcm80211/brcmfmac/feature.c     |   1 +
 .../broadcom/brcm80211/brcmfmac/feature.h     |   4 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h  |  49 +++++++-
 4 files changed, 145 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index fb727778312c..71e932a8302c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -769,12 +769,50 @@ void brcmf_set_mpc(struct brcmf_if *ifp, int mpc)
 	}
 }
 
+static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
+			     struct brcmf_scan_params_v2_le *params_le,
+			     struct cfg80211_scan_request *request);
+
+static void brcmf_scan_params_v2_to_v1(struct brcmf_scan_params_v2_le *params_v2_le,
+				       struct brcmf_scan_params_le *params_le)
+{
+	size_t params_size;
+	u32 ch;
+	int n_channels, n_ssids;
+
+	memcpy(&params_le->ssid_le, &params_v2_le->ssid_le,
+	       sizeof(params_le->ssid_le));
+	memcpy(&params_le->bssid, &params_v2_le->bssid,
+	       sizeof(params_le->bssid));
+
+	params_le->bss_type = params_v2_le->bss_type;
+	params_le->scan_type = params_v2_le->scan_type;
+	params_le->nprobes = params_v2_le->nprobes;
+	params_le->active_time = params_v2_le->active_time;
+	params_le->passive_time = params_v2_le->passive_time;
+	params_le->home_time = params_v2_le->home_time;
+	params_le->channel_num = params_v2_le->channel_num;
+
+	ch = le32_to_cpu(params_v2_le->channel_num);
+	n_channels = ch & BRCMF_SCAN_PARAMS_COUNT_MASK;
+	n_ssids = ch >> BRCMF_SCAN_PARAMS_NSSID_SHIFT;
+
+	params_size = sizeof(u16) * n_channels;
+	if (n_ssids > 0) {
+		params_size = roundup(params_size, sizeof(u32));
+		params_size += sizeof(struct brcmf_ssid_le) * n_ssids;
+	}
+
+	memcpy(&params_le->channel_list[0],
+	       &params_v2_le->channel_list[0], params_size);
+}
+
 s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 				struct brcmf_if *ifp, bool aborted,
 				bool fw_abort)
 {
 	struct brcmf_pub *drvr = cfg->pub;
-	struct brcmf_scan_params_le params_le;
+	struct brcmf_scan_params_v2_le params_v2_le;
 	struct cfg80211_scan_request *scan_request;
 	u64 reqid;
 	u32 bucket;
@@ -793,20 +831,23 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 	if (fw_abort) {
 		/* Do a scan abort to stop the driver's scan engine */
 		brcmf_dbg(SCAN, "ABORT scan in firmware\n");
-		memset(&params_le, 0, sizeof(params_le));
-		eth_broadcast_addr(params_le.bssid);
-		params_le.bss_type = DOT11_BSSTYPE_ANY;
-		params_le.scan_type = 0;
-		params_le.channel_num = cpu_to_le32(1);
-		params_le.nprobes = cpu_to_le32(1);
-		params_le.active_time = cpu_to_le32(-1);
-		params_le.passive_time = cpu_to_le32(-1);
-		params_le.home_time = cpu_to_le32(-1);
-		/* Scan is aborted by setting channel_list[0] to -1 */
-		params_le.channel_list[0] = cpu_to_le16(-1);
+
+		brcmf_escan_prep(cfg, &params_v2_le, NULL);
+
 		/* E-Scan (or anyother type) can be aborted by SCAN */
-		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN,
-					     &params_le, sizeof(params_le));
+		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_SCAN_V2)) {
+			err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN,
+						     &params_v2_le,
+						     sizeof(params_v2_le));
+		} else {
+			struct brcmf_scan_params_le params_le;
+
+			brcmf_scan_params_v2_to_v1(&params_v2_le, &params_le);
+			err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN,
+						     &params_le,
+						     sizeof(params_le));
+		}
+
 		if (err)
 			bphy_err(drvr, "Scan abort failed\n");
 	}
@@ -1026,7 +1067,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 }
 
 static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
-			     struct brcmf_scan_params_le *params_le,
+			     struct brcmf_scan_params_v2_le *params_le,
 			     struct cfg80211_scan_request *request)
 {
 	u32 n_ssids;
@@ -1035,9 +1076,14 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 	s32 offset;
 	u16 chanspec;
 	char *ptr;
+	int length;
 	struct brcmf_ssid_le ssid_le;
 
 	eth_broadcast_addr(params_le->bssid);
+
+	length = BRCMF_SCAN_PARAMS_V2_FIXED_SIZE;
+
+	params_le->version = BRCMF_SCAN_PARAMS_VERSION_V2;
 	params_le->bss_type = DOT11_BSSTYPE_ANY;
 	params_le->scan_type = BRCMF_SCANTYPE_ACTIVE;
 	params_le->channel_num = 0;
@@ -1047,6 +1093,15 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 	params_le->home_time = cpu_to_le32(-1);
 	memset(&params_le->ssid_le, 0, sizeof(params_le->ssid_le));
 
+	/* Scan abort */
+	if (!request) {
+		length += sizeof(u16);
+		params_le->channel_num = cpu_to_le32(1);
+		params_le->channel_list[0] = cpu_to_le16(-1);
+		params_le->length = cpu_to_le16(length);
+		return;
+	}
+
 	n_ssids = request->n_ssids;
 	n_channels = request->n_channels;
 
@@ -1054,6 +1109,7 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 	brcmf_dbg(SCAN, "### List of channelspecs to scan ### %d\n",
 		  n_channels);
 	if (n_channels > 0) {
+		length += roundup(sizeof(u16) * n_channels, sizeof(u32));
 		for (i = 0; i < n_channels; i++) {
 			chanspec = channel_to_chanspec(&cfg->d11inf,
 						       request->channels[i]);
@@ -1064,12 +1120,14 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 	} else {
 		brcmf_dbg(SCAN, "Scanning all channels\n");
 	}
+
 	/* Copy ssid array if applicable */
 	brcmf_dbg(SCAN, "### List of SSIDs to scan ### %d\n", n_ssids);
 	if (n_ssids > 0) {
-		offset = offsetof(struct brcmf_scan_params_le, channel_list) +
+		offset = offsetof(struct brcmf_scan_params_v2_le, channel_list) +
 				n_channels * sizeof(u16);
 		offset = roundup(offset, sizeof(u32));
+		length += sizeof(ssid_le) * n_ssids,
 		ptr = (char *)params_le + offset;
 		for (i = 0; i < n_ssids; i++) {
 			memset(&ssid_le, 0, sizeof(ssid_le));
@@ -1089,6 +1147,7 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 		brcmf_dbg(SCAN, "Performing passive scan\n");
 		params_le->scan_type = BRCMF_SCANTYPE_PASSIVE;
 	}
+	params_le->length = cpu_to_le16(length);
 	/* Adding mask to channel numbers */
 	params_le->channel_num =
 		cpu_to_le32((n_ssids << BRCMF_SCAN_PARAMS_NSSID_SHIFT) |
@@ -1100,8 +1159,8 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
 		struct cfg80211_scan_request *request)
 {
 	struct brcmf_pub *drvr = cfg->pub;
-	s32 params_size = BRCMF_SCAN_PARAMS_FIXED_SIZE +
-			  offsetof(struct brcmf_escan_params_le, params_le);
+	s32 params_size = BRCMF_SCAN_PARAMS_V2_FIXED_SIZE +
+			  offsetof(struct brcmf_escan_params_le, params_v2_le);
 	struct brcmf_escan_params_le *params;
 	s32 err = 0;
 
@@ -1121,8 +1180,22 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
 		goto exit;
 	}
 	BUG_ON(params_size + sizeof("escan") >= BRCMF_DCMD_MEDLEN);
-	brcmf_escan_prep(cfg, &params->params_le, request);
-	params->version = cpu_to_le32(BRCMF_ESCAN_REQ_VERSION);
+	brcmf_escan_prep(cfg, &params->params_v2_le, request);
+
+	params->version = cpu_to_le32(BRCMF_ESCAN_REQ_VERSION_V2);
+
+	if (!brcmf_feat_is_enabled(ifp, BRCMF_FEAT_SCAN_V2)) {
+		struct brcmf_escan_params_le *params_v1;
+
+		params_size -= BRCMF_SCAN_PARAMS_V2_FIXED_SIZE;
+		params_size += BRCMF_SCAN_PARAMS_FIXED_SIZE;
+		params_v1 = kzalloc(params_size, GFP_KERNEL);
+		params_v1->version = cpu_to_le32(BRCMF_ESCAN_REQ_VERSION);
+		brcmf_scan_params_v2_to_v1(&params->params_v2_le, &params_v1->params_le);
+		kfree(params);
+		params = params_v1;
+	}
+
 	params->action = cpu_to_le16(WL_ESCAN_ACTION_START);
 	params->sync_id = cpu_to_le16(0x1234);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 7c68d9849324..d0fada88f0f0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -287,6 +287,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 		ifp->drvr->feat_flags |= BIT(BRCMF_FEAT_SCAN_RANDOM_MAC);
 
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_FWSUP, "sup_wpa");
+	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_SCAN_V2, "scan_ver");
 
 	if (drvr->settings->feature_disable) {
 		brcmf_dbg(INFO, "Features: 0x%02x, disable: 0x%02x\n",
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index d1f4257af696..9d098a068d13 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -29,6 +29,7 @@
  * DOT11H: firmware supports 802.11h
  * SAE: simultaneous authentication of equals
  * FWAUTH: Firmware authenticator
+ * SCAN_V2: Version 2 scan params
  */
 #define BRCMF_FEAT_LIST \
 	BRCMF_FEAT_DEF(MBSS) \
@@ -51,7 +52,8 @@
 	BRCMF_FEAT_DEF(MONITOR_FMT_HW_RX_HDR) \
 	BRCMF_FEAT_DEF(DOT11H) \
 	BRCMF_FEAT_DEF(SAE) \
-	BRCMF_FEAT_DEF(FWAUTH)
+	BRCMF_FEAT_DEF(FWAUTH) \
+	BRCMF_FEAT_DEF(SCAN_V2)
 
 /*
  * Quirks:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index ff2ef557f0ea..2ef3fcbb00b9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -48,6 +48,10 @@
 
 /* size of brcmf_scan_params not including variable length array */
 #define BRCMF_SCAN_PARAMS_FIXED_SIZE	64
+#define BRCMF_SCAN_PARAMS_V2_FIXED_SIZE	72
+
+/* version of brcmf_scan_params structure */
+#define BRCMF_SCAN_PARAMS_VERSION_V2	2
 
 /* masks for channel and ssid count */
 #define BRCMF_SCAN_PARAMS_COUNT_MASK	0x0000ffff
@@ -67,6 +71,7 @@
 #define BRCMF_PRIMARY_KEY		(1 << 1)
 #define DOT11_BSSTYPE_ANY		2
 #define BRCMF_ESCAN_REQ_VERSION		1
+#define BRCMF_ESCAN_REQ_VERSION_V2	2
 
 #define BRCMF_MAXRATES_IN_SET		16	/* max # of rates in rateset */
 
@@ -386,6 +391,45 @@ struct brcmf_scan_params_le {
 	__le16 channel_list[1];	/* list of chanspecs */
 };
 
+struct brcmf_scan_params_v2_le {
+	__le16 version;		/* structure version */
+	__le16 length;		/* structure length */
+	struct brcmf_ssid_le ssid_le;	/* default: {0, ""} */
+	u8 bssid[ETH_ALEN];	/* default: bcast */
+	s8 bss_type;		/* default: any,
+				 * DOT11_BSSTYPE_ANY/INFRASTRUCTURE/INDEPENDENT
+				 */
+	u8 pad;
+	__le32 scan_type;	/* flags, 0 use default */
+	__le32 nprobes;		/* -1 use default, number of probes per channel */
+	__le32 active_time;	/* -1 use default, dwell time per channel for
+				 * active scanning
+				 */
+	__le32 passive_time;	/* -1 use default, dwell time per channel
+				 * for passive scanning
+				 */
+	__le32 home_time;	/* -1 use default, dwell time for the
+				 * home channel between channel scans
+				 */
+	__le32 channel_num;	/* count of channels and ssids that follow
+				 *
+				 * low half is count of channels in
+				 * channel_list, 0 means default (use all
+				 * available channels)
+				 *
+				 * high half is entries in struct brcmf_ssid
+				 * array that follows channel_list, aligned for
+				 * s32 (4 bytes) meaning an odd channel count
+				 * implies a 2-byte pad between end of
+				 * channel_list and first ssid
+				 *
+				 * if ssid count is zero, single ssid in the
+				 * fixed parameter portion is assumed, otherwise
+				 * ssid in the fixed portion is ignored
+				 */
+	__le16 channel_list[1];	/* list of chanspecs */
+};
+
 struct brcmf_scan_results {
 	u32 buflen;
 	u32 version;
@@ -397,7 +441,10 @@ struct brcmf_escan_params_le {
 	__le32 version;
 	__le16 action;
 	__le16 sync_id;
-	struct brcmf_scan_params_le params_le;
+	union {
+		struct brcmf_scan_params_le params_le;
+		struct brcmf_scan_params_v2_le params_v2_le;
+	};
 };
 
 struct brcmf_escan_result_le {
-- 
2.33.0

