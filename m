Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5FC6612EA
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 02:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbjAHBbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 20:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbjAHBbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 20:31:12 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F3B3B907
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 17:31:05 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id c85so467979pfc.8
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 17:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F1XsLmyJLSZxFahyH+bnrRO9ogW2CStFBT/wHKkbpOs=;
        b=dAqKoTa0yqV8w6eb3XT5pFsi9y8g3XfsYIe2rS1/0t5CnqoGNhzHCePXIZGXBaPwI9
         Ac2oUarTv5SISyiBuG7siLopcI3yQLQnr0h8kfNPf0KPGp09Y9/T+NZ51v2rco+DZTWO
         k+bZCedKgWMvgnt/bMIgWtPUZTQiRdiqcUf0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F1XsLmyJLSZxFahyH+bnrRO9ogW2CStFBT/wHKkbpOs=;
        b=mos5kIby3yp1OtS2tV95S3ij4WE/N/2KUyRD08lprEQOehdeWC9SWepaY6bGbvedth
         lXuIQitFX7cXz2nwfNMJTYn3boQC2EsLY4pT5ItBYAZIAXH44s5zyRzj+1kQptolAPuv
         gKZbLSWAvKLpwfTf971xvv79YCNPA+1JKPYfMbOOEOF5XWkMe3ICGq21oHJXFUa5g1Yt
         U346eIP1egz/NYjeNTHXfzRrAC3KkapssqbQ2d8puu/+mOYiqADkUPB+eEPkufOx8E6X
         CSGu2i8UMU1pY7dnVHHbTg7ESiu/2/PQT5lJkUwlXC2TRQEBP7NjCvUxFuOGo45cQYV4
         /tTw==
X-Gm-Message-State: AFqh2kr+YUw5VDFwX9pICBRdIZdrIcNLuRTcBNww97a+XCPuF7kt0jGT
        N68E3f2kI0DFvcn+sbxUYCFNgw==
X-Google-Smtp-Source: AMrXdXvJwd3Tyv51nq/yoDQJehhVAmFPArqq8grbCdGcLQViy06OM3Vpq4nd8kgYVQ7uqUIL6C57yA==
X-Received: by 2002:a62:2903:0:b0:57f:f2cd:6180 with SMTP id p3-20020a622903000000b0057ff2cd6180mr57052288pfp.0.1673141464818;
        Sat, 07 Jan 2023 17:31:04 -0800 (PST)
Received: from doug-ryzen-5700G.. ([192.183.212.197])
        by smtp.gmail.com with ESMTPSA id x14-20020aa79a4e000000b005811c421e6csm3323714pfj.162.2023.01.07.17.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 17:31:04 -0800 (PST)
From:   Doug Brown <doug@schmorgal.com>
To:     Dan Williams <dcbw@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Doug Brown <doug@schmorgal.com>
Subject: [PATCH v2 4/4] wifi: libertas: add support for WPS enrollee IE in probe requests
Date:   Sat,  7 Jan 2023 17:30:16 -0800
Message-Id: <20230108013016.222494-5-doug@schmorgal.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230108013016.222494-1-doug@schmorgal.com>
References: <20230108013016.222494-1-doug@schmorgal.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatibility with WPS by passing on WPS enrollee information in
probe requests. Ignore other IEs supplied in the scan request. This also
has the added benefit of restoring compatibility with newer
wpa_supplicant versions that always add scan IEs. Previously, with
max_scan_ie_len set to 0, scans would always fail.

Suggested-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Doug Brown <doug@schmorgal.com>
---
 drivers/net/wireless/marvell/libertas/cfg.c | 48 +++++++++++++++++++--
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 5cd78fefbe4c..ec3f35ae15fd 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -446,6 +446,41 @@ static int lbs_add_wpa_tlv(u8 *tlv, const u8 *ie, u8 ie_len)
 	return sizeof(struct mrvl_ie_header) + wpaie->datalen;
 }
 
+/* Add WPS enrollee TLV
+ */
+#define LBS_MAX_WPS_ENROLLEE_TLV_SIZE		\
+	(sizeof(struct mrvl_ie_header)		\
+	 + 256)
+
+static int lbs_add_wps_enrollee_tlv(u8 *tlv, const u8 *ie, size_t ie_len)
+{
+	struct mrvl_ie_data *wpstlv = (struct mrvl_ie_data *)tlv;
+	const struct element *wpsie;
+
+	/* Look for a WPS IE and add it to the probe request */
+	wpsie = cfg80211_find_vendor_elem(WLAN_OUI_MICROSOFT,
+					  WLAN_OUI_TYPE_MICROSOFT_WPS,
+					  ie, ie_len);
+	if (!wpsie)
+		return 0;
+
+	/* Convert the WPS IE to a TLV. The IE looks like this:
+	 *   u8      type (WLAN_EID_VENDOR_SPECIFIC)
+	 *   u8      len
+	 *   u8[]    data
+	 * but the TLV will look like this instead:
+	 *   __le16  type (TLV_TYPE_WPS_ENROLLEE)
+	 *   __le16  len
+	 *   u8[]    data
+	 */
+	wpstlv->header.type = TLV_TYPE_WPS_ENROLLEE;
+	wpstlv->header.len = wpsie->datalen;
+	memcpy(wpstlv->data, wpsie->data, wpsie->datalen);
+
+	/* Return the total number of bytes added to the TLV buffer */
+	return sizeof(struct mrvl_ie_header) + wpsie->datalen;
+}
+
 /*
  * Set Channel
  */
@@ -672,14 +707,15 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 
 
 /*
- * Our scan command contains a TLV, consting of a SSID TLV, a channel list
- * TLV and a rates TLV. Determine the maximum size of them:
+ * Our scan command contains a TLV, consisting of a SSID TLV, a channel list
+ * TLV, a rates TLV, and an optional WPS IE. Determine the maximum size of them:
  */
 #define LBS_SCAN_MAX_CMD_SIZE			\
 	(sizeof(struct cmd_ds_802_11_scan)	\
 	 + LBS_MAX_SSID_TLV_SIZE		\
 	 + LBS_MAX_CHANNEL_LIST_TLV_SIZE	\
-	 + LBS_MAX_RATES_TLV_SIZE)
+	 + LBS_MAX_RATES_TLV_SIZE		\
+	 + LBS_MAX_WPS_ENROLLEE_TLV_SIZE)
 
 /*
  * Assumes priv->scan_req is initialized and valid
@@ -728,6 +764,11 @@ static void lbs_scan_worker(struct work_struct *work)
 	/* add rates TLV */
 	tlv += lbs_add_supported_rates_tlv(tlv);
 
+	/* add optional WPS enrollee TLV */
+	if (priv->scan_req->ie && priv->scan_req->ie_len)
+		tlv += lbs_add_wps_enrollee_tlv(tlv, priv->scan_req->ie,
+						priv->scan_req->ie_len);
+
 	if (priv->scan_channel < priv->scan_req->n_channels) {
 		cancel_delayed_work(&priv->scan_work);
 		if (netif_running(priv->dev))
@@ -2114,6 +2155,7 @@ int lbs_cfg_register(struct lbs_private *priv)
 	int ret;
 
 	wdev->wiphy->max_scan_ssids = 1;
+	wdev->wiphy->max_scan_ie_len = 256;
 	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 
 	wdev->wiphy->interface_modes =
-- 
2.34.1

