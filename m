Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF09695EF5
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjBNJZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbjBNJZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:25:43 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D24B23305;
        Tue, 14 Feb 2023 01:25:41 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 6118D41EF0;
        Tue, 14 Feb 2023 09:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676366739; bh=vWqRDSekpJMneWSP8WTEqeIIExZfoCyGj2tl43yt0HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Msj+eLH+cJGNmBVWy+vEPMQ5pO2CgCuZicBWHbOBY/G8w+Mt5X7VTri2yFLz+0Jr1
         ly1wV9HVocEKFXsXEnZPuWIaRZFhwue/lbdVhf6xXq76NlpwQy2SyMtKHge7qYs13H
         A/yg9PzcPHv7ALwR5xFWyezyIpIpBWiDbOuI/79Kin57pnmwj4rwstWgDSW/ld3pn3
         X7maX9dyPGcrXYgr3uCMd5/2p7fYYke4heo851irTTwFoVswEJuhlPbO2uQjQpMYKI
         fgtO5WOS5SnEbIryJNkBD/aGAFbIfov97lMuGw/gQwa1Dt+kthSGLRkH4nwV3MEJ0m
         ZauwGhVALWQAw==
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
Subject: [PATCH 03/10] brcmfmac: cfg80211: Add support for scan params v2
Date:   Tue, 14 Feb 2023 18:24:16 +0900
Message-Id: <20230214092423.15175-3-marcan@marcan.st>
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

This new API version is required for at least the BCM4387 firmware. Add
support for it, with a fallback to the v1 API.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 245 +++++++++++-------
 .../broadcom/brcm80211/brcmfmac/feature.c     |   1 +
 .../broadcom/brcm80211/brcmfmac/feature.h     |   4 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h  |  49 +++-
 4 files changed, 209 insertions(+), 90 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index a9690ec4c850..3e006b783f3f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1039,12 +1039,134 @@ void brcmf_set_mpc(struct brcmf_if *ifp, int mpc)
 	}
 }
 
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
+	params_le->scan_type = le32_to_cpu(params_v2_le->scan_type);
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
+static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
+			     struct brcmf_scan_params_v2_le *params_le,
+			     struct cfg80211_scan_request *request)
+{
+	u32 n_ssids;
+	u32 n_channels;
+	s32 i;
+	s32 offset;
+	u16 chanspec;
+	char *ptr;
+	int length;
+	struct brcmf_ssid_le ssid_le;
+
+	eth_broadcast_addr(params_le->bssid);
+
+	length = BRCMF_SCAN_PARAMS_V2_FIXED_SIZE;
+
+	params_le->version = cpu_to_le16(BRCMF_SCAN_PARAMS_VERSION_V2);
+	params_le->bss_type = DOT11_BSSTYPE_ANY;
+	params_le->scan_type = cpu_to_le32(BRCMF_SCANTYPE_ACTIVE);
+	params_le->channel_num = 0;
+	params_le->nprobes = cpu_to_le32(-1);
+	params_le->active_time = cpu_to_le32(-1);
+	params_le->passive_time = cpu_to_le32(-1);
+	params_le->home_time = cpu_to_le32(-1);
+	memset(&params_le->ssid_le, 0, sizeof(params_le->ssid_le));
+
+	/* Scan abort */
+	if (!request) {
+		length += sizeof(u16);
+		params_le->channel_num = cpu_to_le32(1);
+		params_le->channel_list[0] = cpu_to_le16(-1);
+		params_le->length = cpu_to_le16(length);
+		return;
+	}
+
+	n_ssids = request->n_ssids;
+	n_channels = request->n_channels;
+
+	/* Copy channel array if applicable */
+	brcmf_dbg(SCAN, "### List of channelspecs to scan ### %d\n",
+		  n_channels);
+	if (n_channels > 0) {
+		length += roundup(sizeof(u16) * n_channels, sizeof(u32));
+		for (i = 0; i < n_channels; i++) {
+			chanspec = channel_to_chanspec(&cfg->d11inf,
+						       request->channels[i]);
+			brcmf_dbg(SCAN, "Chan : %d, Channel spec: %x\n",
+				  request->channels[i]->hw_value, chanspec);
+			params_le->channel_list[i] = cpu_to_le16(chanspec);
+		}
+	} else {
+		brcmf_dbg(SCAN, "Scanning all channels\n");
+	}
+
+	/* Copy ssid array if applicable */
+	brcmf_dbg(SCAN, "### List of SSIDs to scan ### %d\n", n_ssids);
+	if (n_ssids > 0) {
+		offset = offsetof(struct brcmf_scan_params_v2_le, channel_list) +
+				n_channels * sizeof(u16);
+		offset = roundup(offset, sizeof(u32));
+		length += sizeof(ssid_le) * n_ssids,
+		ptr = (char *)params_le + offset;
+		for (i = 0; i < n_ssids; i++) {
+			memset(&ssid_le, 0, sizeof(ssid_le));
+			ssid_le.SSID_len =
+					cpu_to_le32(request->ssids[i].ssid_len);
+			memcpy(ssid_le.SSID, request->ssids[i].ssid,
+			       request->ssids[i].ssid_len);
+			if (!ssid_le.SSID_len)
+				brcmf_dbg(SCAN, "%d: Broadcast scan\n", i);
+			else
+				brcmf_dbg(SCAN, "%d: scan for  %.32s size=%d\n",
+					  i, ssid_le.SSID, ssid_le.SSID_len);
+			memcpy(ptr, &ssid_le, sizeof(ssid_le));
+			ptr += sizeof(ssid_le);
+		}
+	} else {
+		brcmf_dbg(SCAN, "Performing passive scan\n");
+		params_le->scan_type = cpu_to_le32(BRCMF_SCANTYPE_PASSIVE);
+	}
+	params_le->length = cpu_to_le16(length);
+	/* Adding mask to channel numbers */
+	params_le->channel_num =
+		cpu_to_le32((n_ssids << BRCMF_SCAN_PARAMS_NSSID_SHIFT) |
+			(n_channels & BRCMF_SCAN_PARAMS_COUNT_MASK));
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
@@ -1063,20 +1185,23 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
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
@@ -1295,83 +1420,13 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	return err;
 }
 
-static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
-			     struct brcmf_scan_params_le *params_le,
-			     struct cfg80211_scan_request *request)
-{
-	u32 n_ssids;
-	u32 n_channels;
-	s32 i;
-	s32 offset;
-	u16 chanspec;
-	char *ptr;
-	struct brcmf_ssid_le ssid_le;
-
-	eth_broadcast_addr(params_le->bssid);
-	params_le->bss_type = DOT11_BSSTYPE_ANY;
-	params_le->scan_type = BRCMF_SCANTYPE_ACTIVE;
-	params_le->channel_num = 0;
-	params_le->nprobes = cpu_to_le32(-1);
-	params_le->active_time = cpu_to_le32(-1);
-	params_le->passive_time = cpu_to_le32(-1);
-	params_le->home_time = cpu_to_le32(-1);
-	memset(&params_le->ssid_le, 0, sizeof(params_le->ssid_le));
-
-	n_ssids = request->n_ssids;
-	n_channels = request->n_channels;
-
-	/* Copy channel array if applicable */
-	brcmf_dbg(SCAN, "### List of channelspecs to scan ### %d\n",
-		  n_channels);
-	if (n_channels > 0) {
-		for (i = 0; i < n_channels; i++) {
-			chanspec = channel_to_chanspec(&cfg->d11inf,
-						       request->channels[i]);
-			brcmf_dbg(SCAN, "Chan : %d, Channel spec: %x\n",
-				  request->channels[i]->hw_value, chanspec);
-			params_le->channel_list[i] = cpu_to_le16(chanspec);
-		}
-	} else {
-		brcmf_dbg(SCAN, "Scanning all channels\n");
-	}
-	/* Copy ssid array if applicable */
-	brcmf_dbg(SCAN, "### List of SSIDs to scan ### %d\n", n_ssids);
-	if (n_ssids > 0) {
-		offset = offsetof(struct brcmf_scan_params_le, channel_list) +
-				n_channels * sizeof(u16);
-		offset = roundup(offset, sizeof(u32));
-		ptr = (char *)params_le + offset;
-		for (i = 0; i < n_ssids; i++) {
-			memset(&ssid_le, 0, sizeof(ssid_le));
-			ssid_le.SSID_len =
-					cpu_to_le32(request->ssids[i].ssid_len);
-			memcpy(ssid_le.SSID, request->ssids[i].ssid,
-			       request->ssids[i].ssid_len);
-			if (!ssid_le.SSID_len)
-				brcmf_dbg(SCAN, "%d: Broadcast scan\n", i);
-			else
-				brcmf_dbg(SCAN, "%d: scan for  %.32s size=%d\n",
-					  i, ssid_le.SSID, ssid_le.SSID_len);
-			memcpy(ptr, &ssid_le, sizeof(ssid_le));
-			ptr += sizeof(ssid_le);
-		}
-	} else {
-		brcmf_dbg(SCAN, "Performing passive scan\n");
-		params_le->scan_type = BRCMF_SCANTYPE_PASSIVE;
-	}
-	/* Adding mask to channel numbers */
-	params_le->channel_num =
-		cpu_to_le32((n_ssids << BRCMF_SCAN_PARAMS_NSSID_SHIFT) |
-			(n_channels & BRCMF_SCAN_PARAMS_COUNT_MASK));
-}
-
 static s32
 brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
 		struct cfg80211_scan_request *request)
 {
 	struct brcmf_pub *drvr = cfg->pub;
-	s32 params_size = BRCMF_SCAN_PARAMS_FIXED_SIZE +
-			  offsetof(struct brcmf_escan_params_le, params_le);
+	s32 params_size = BRCMF_SCAN_PARAMS_V2_FIXED_SIZE +
+			  offsetof(struct brcmf_escan_params_le, params_v2_le);
 	struct brcmf_escan_params_le *params;
 	s32 err = 0;
 
@@ -1391,8 +1446,22 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
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
index 10bac865d724..b6797f800e55 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -290,6 +290,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 		ifp->drvr->feat_flags |= BIT(BRCMF_FEAT_SCAN_RANDOM_MAC);
 
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_FWSUP, "sup_wpa");
+	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_SCAN_V2, "scan_ver");
 
 	if (drvr->settings->feature_disable) {
 		brcmf_dbg(INFO, "Features: 0x%02x, disable: 0x%02x\n",
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index f1b086a69d73..549298c55b55 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -30,6 +30,7 @@
  * SAE: simultaneous authentication of equals
  * FWAUTH: Firmware authenticator
  * DUMP_OBSS: Firmware has capable to dump obss info to support ACS
+ * SCAN_V2: Version 2 scan params
  */
 #define BRCMF_FEAT_LIST \
 	BRCMF_FEAT_DEF(MBSS) \
@@ -53,7 +54,8 @@
 	BRCMF_FEAT_DEF(DOT11H) \
 	BRCMF_FEAT_DEF(SAE) \
 	BRCMF_FEAT_DEF(FWAUTH) \
-	BRCMF_FEAT_DEF(DUMP_OBSS)
+	BRCMF_FEAT_DEF(DUMP_OBSS) \
+	BRCMF_FEAT_DEF(SCAN_V2)
 
 /*
  * Quirks:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 04e1beedfd81..b3844d0d1adb 100644
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
2.35.1

