Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCD1582A81
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 18:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbiG0QRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 12:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234880AbiG0QRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 12:17:10 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43D93FA18
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:17:02 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id u5so25193788wrm.4
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y7xVx0zWpufB0j409voZdtiAi8N5IZSk1dbEtWpgvwo=;
        b=LgeQ8em4m8YDuOiRO7sDRo6A46HCUxAzONVV4SN/TrJ6c4FjrsRzQpCD+wUbGPjjss
         Z1agaUoEsaSREyS5Erl2GySyOjx/qu4nBKDqwJi8mJ7I4bU9cJQlqqF0PlJL7OdD7vOX
         h+A+0L8ZzLp7lsk0ytvnI4sWSfxqwiLvYK9taKWpWe0qi4o5d+put7yz7gYGKksCYKUC
         XwLPg6PRKktYbvRi1YHUNo41HOXwNNJJ2jeyhtaSTO4aaZQ/K72n9pe9PcTRsIp//g0J
         2WRyOvNO4arbQM9kP/lHil5fbZVdqAvR1y3gm1rVMlNq6umBiGQ/YDDOXwv514oOUcGL
         7aGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y7xVx0zWpufB0j409voZdtiAi8N5IZSk1dbEtWpgvwo=;
        b=kwht64+whqBONL+GUduQCnbx7sDwFcI5YoRpovXK2ZUuC+pyvta1BUcKF8IyAYnvfM
         /Z2Fnd4jCQLBnlvgHyizUgFaZgdp+l/USO12n9PeV5JlgM+b8oLxpPjfEh/j/UVwmVQk
         IAU6ihppFNvUW+K0qCTfZ8Os5nzlP5neyCK/fsqwHSXK55Jp9BXMoBi27F+zmaxe6axd
         k2lFphtYogVWlYvpOlsZnrSpPtaWREAMsSwTYFZ82xpUAzbHKf0AdtR4CGLI11nAGjGv
         iv704oxOw///wnFIEsxmf+8DBTboMfePbKkxYsVQ5LnbZnQ0t/Yy+thSkjF2San6uUmU
         s8ug==
X-Gm-Message-State: AJIora/sU0aU5xOhX1c1xngGlSTVelMqE10B9NCIuaDPV4EdMVmUeqCA
        aXgEHb4rLy/qqufxtQYTApMjBA==
X-Google-Smtp-Source: AGRyM1uVbwQlTagIgAi3Zkduf2IXLPay0pWUMK8p4s4FYX2NUFj7AaeKAQp1xQ5f9fyHOMOetA+12A==
X-Received: by 2002:a05:600c:6005:b0:3a3:7308:69db with SMTP id az5-20020a05600c600500b003a3730869dbmr3598644wmb.91.1658938621084;
        Wed, 27 Jul 2022 09:17:01 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id l4-20020a05600012c400b0021e4829d359sm17245474wrx.39.2022.07.27.09.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 09:17:00 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@kernel.org, loic.poulain@linaro.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bryan.odonoghue@linaro.org
Subject: [PATCH v3 3/4] wcn36xx: Move capability bitmap to string translation function to firmware.c
Date:   Wed, 27 Jul 2022 17:16:54 +0100
Message-Id: <20220727161655.2286867-4-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727161655.2286867-1-bryan.odonoghue@linaro.org>
References: <20220727161655.2286867-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move wcn36xx_get_cap_name() function in main.c into firmware.c as
wcn36xx_firmware_get_cap_name().

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/firmware.c | 75 +++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/firmware.h |  2 +
 drivers/net/wireless/ath/wcn36xx/main.c     | 81 +--------------------
 3 files changed, 81 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/firmware.c b/drivers/net/wireless/ath/wcn36xx/firmware.c
index 03b93d2bdcf96..4b7f439e4db58 100644
--- a/drivers/net/wireless/ath/wcn36xx/firmware.c
+++ b/drivers/net/wireless/ath/wcn36xx/firmware.c
@@ -3,6 +3,81 @@
 #include "wcn36xx.h"
 #include "firmware.h"
 
+#define DEFINE(s)[s] = #s
+
+static const char * const wcn36xx_firmware_caps_names[] = {
+	DEFINE(MCC),
+	DEFINE(P2P),
+	DEFINE(DOT11AC),
+	DEFINE(SLM_SESSIONIZATION),
+	DEFINE(DOT11AC_OPMODE),
+	DEFINE(SAP32STA),
+	DEFINE(TDLS),
+	DEFINE(P2P_GO_NOA_DECOUPLE_INIT_SCAN),
+	DEFINE(WLANACTIVE_OFFLOAD),
+	DEFINE(BEACON_OFFLOAD),
+	DEFINE(SCAN_OFFLOAD),
+	DEFINE(ROAM_OFFLOAD),
+	DEFINE(BCN_MISS_OFFLOAD),
+	DEFINE(STA_POWERSAVE),
+	DEFINE(STA_ADVANCED_PWRSAVE),
+	DEFINE(AP_UAPSD),
+	DEFINE(AP_DFS),
+	DEFINE(BLOCKACK),
+	DEFINE(PHY_ERR),
+	DEFINE(BCN_FILTER),
+	DEFINE(RTT),
+	DEFINE(RATECTRL),
+	DEFINE(WOW),
+	DEFINE(WLAN_ROAM_SCAN_OFFLOAD),
+	DEFINE(SPECULATIVE_PS_POLL),
+	DEFINE(SCAN_SCH),
+	DEFINE(IBSS_HEARTBEAT_OFFLOAD),
+	DEFINE(WLAN_SCAN_OFFLOAD),
+	DEFINE(WLAN_PERIODIC_TX_PTRN),
+	DEFINE(ADVANCE_TDLS),
+	DEFINE(BATCH_SCAN),
+	DEFINE(FW_IN_TX_PATH),
+	DEFINE(EXTENDED_NSOFFLOAD_SLOT),
+	DEFINE(CH_SWITCH_V1),
+	DEFINE(HT40_OBSS_SCAN),
+	DEFINE(UPDATE_CHANNEL_LIST),
+	DEFINE(WLAN_MCADDR_FLT),
+	DEFINE(WLAN_CH144),
+	DEFINE(NAN),
+	DEFINE(TDLS_SCAN_COEXISTENCE),
+	DEFINE(LINK_LAYER_STATS_MEAS),
+	DEFINE(MU_MIMO),
+	DEFINE(EXTENDED_SCAN),
+	DEFINE(DYNAMIC_WMM_PS),
+	DEFINE(MAC_SPOOFED_SCAN),
+	DEFINE(BMU_ERROR_GENERIC_RECOVERY),
+	DEFINE(DISA),
+	DEFINE(FW_STATS),
+	DEFINE(WPS_PRBRSP_TMPL),
+	DEFINE(BCN_IE_FLT_DELTA),
+	DEFINE(TDLS_OFF_CHANNEL),
+	DEFINE(RTT3),
+	DEFINE(MGMT_FRAME_LOGGING),
+	DEFINE(ENHANCED_TXBD_COMPLETION),
+	DEFINE(LOGGING_ENHANCEMENT),
+	DEFINE(EXT_SCAN_ENHANCED),
+	DEFINE(MEMORY_DUMP_SUPPORTED),
+	DEFINE(PER_PKT_STATS_SUPPORTED),
+	DEFINE(EXT_LL_STAT),
+	DEFINE(WIFI_CONFIG),
+	DEFINE(ANTENNA_DIVERSITY_SELECTION),
+};
+
+#undef DEFINE
+
+const char *wcn36xx_firmware_get_cap_name(enum wcn36xx_firmware_feat_caps x)
+{
+	if (x >= ARRAY_SIZE(wcn36xx_firmware_caps_names))
+		return "UNKNOWN";
+	return wcn36xx_firmware_caps_names[x];
+}
+
 void wcn36xx_firmware_set_feat_caps(u32 *bitmap,
 				    enum wcn36xx_firmware_feat_caps cap)
 {
diff --git a/drivers/net/wireless/ath/wcn36xx/firmware.h b/drivers/net/wireless/ath/wcn36xx/firmware.h
index 552c0e9325e18..f991cf959f829 100644
--- a/drivers/net/wireless/ath/wcn36xx/firmware.h
+++ b/drivers/net/wireless/ath/wcn36xx/firmware.h
@@ -78,5 +78,7 @@ int wcn36xx_firmware_get_feat_caps(u32 *bitmap,
 void wcn36xx_firmware_clear_feat_caps(u32 *bitmap,
 				      enum wcn36xx_firmware_feat_caps cap);
 
+const char *wcn36xx_firmware_get_cap_name(enum wcn36xx_firmware_feat_caps x);
+
 #endif /* _FIRMWARE_H_ */
 
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index af62911a4659f..fec85e89a02f7 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -193,88 +193,15 @@ static inline u8 get_sta_index(struct ieee80211_vif *vif,
 	       sta_priv->sta_index;
 }
 
-#define DEFINE(s) [s] = #s
-
-static const char * const wcn36xx_caps_names[] = {
-	DEFINE(MCC),
-	DEFINE(P2P),
-	DEFINE(DOT11AC),
-	DEFINE(SLM_SESSIONIZATION),
-	DEFINE(DOT11AC_OPMODE),
-	DEFINE(SAP32STA),
-	DEFINE(TDLS),
-	DEFINE(P2P_GO_NOA_DECOUPLE_INIT_SCAN),
-	DEFINE(WLANACTIVE_OFFLOAD),
-	DEFINE(BEACON_OFFLOAD),
-	DEFINE(SCAN_OFFLOAD),
-	DEFINE(ROAM_OFFLOAD),
-	DEFINE(BCN_MISS_OFFLOAD),
-	DEFINE(STA_POWERSAVE),
-	DEFINE(STA_ADVANCED_PWRSAVE),
-	DEFINE(AP_UAPSD),
-	DEFINE(AP_DFS),
-	DEFINE(BLOCKACK),
-	DEFINE(PHY_ERR),
-	DEFINE(BCN_FILTER),
-	DEFINE(RTT),
-	DEFINE(RATECTRL),
-	DEFINE(WOW),
-	DEFINE(WLAN_ROAM_SCAN_OFFLOAD),
-	DEFINE(SPECULATIVE_PS_POLL),
-	DEFINE(SCAN_SCH),
-	DEFINE(IBSS_HEARTBEAT_OFFLOAD),
-	DEFINE(WLAN_SCAN_OFFLOAD),
-	DEFINE(WLAN_PERIODIC_TX_PTRN),
-	DEFINE(ADVANCE_TDLS),
-	DEFINE(BATCH_SCAN),
-	DEFINE(FW_IN_TX_PATH),
-	DEFINE(EXTENDED_NSOFFLOAD_SLOT),
-	DEFINE(CH_SWITCH_V1),
-	DEFINE(HT40_OBSS_SCAN),
-	DEFINE(UPDATE_CHANNEL_LIST),
-	DEFINE(WLAN_MCADDR_FLT),
-	DEFINE(WLAN_CH144),
-	DEFINE(NAN),
-	DEFINE(TDLS_SCAN_COEXISTENCE),
-	DEFINE(LINK_LAYER_STATS_MEAS),
-	DEFINE(MU_MIMO),
-	DEFINE(EXTENDED_SCAN),
-	DEFINE(DYNAMIC_WMM_PS),
-	DEFINE(MAC_SPOOFED_SCAN),
-	DEFINE(BMU_ERROR_GENERIC_RECOVERY),
-	DEFINE(DISA),
-	DEFINE(FW_STATS),
-	DEFINE(WPS_PRBRSP_TMPL),
-	DEFINE(BCN_IE_FLT_DELTA),
-	DEFINE(TDLS_OFF_CHANNEL),
-	DEFINE(RTT3),
-	DEFINE(MGMT_FRAME_LOGGING),
-	DEFINE(ENHANCED_TXBD_COMPLETION),
-	DEFINE(LOGGING_ENHANCEMENT),
-	DEFINE(EXT_SCAN_ENHANCED),
-	DEFINE(MEMORY_DUMP_SUPPORTED),
-	DEFINE(PER_PKT_STATS_SUPPORTED),
-	DEFINE(EXT_LL_STAT),
-	DEFINE(WIFI_CONFIG),
-	DEFINE(ANTENNA_DIVERSITY_SELECTION),
-};
-
-#undef DEFINE
-
-static const char *wcn36xx_get_cap_name(enum wcn36xx_firmware_feat_caps x)
-{
-	if (x >= ARRAY_SIZE(wcn36xx_caps_names))
-		return "UNKNOWN";
-	return wcn36xx_caps_names[x];
-}
-
 static void wcn36xx_feat_caps_info(struct wcn36xx *wcn)
 {
 	int i;
 
 	for (i = 0; i < MAX_FEATURE_SUPPORTED; i++) {
-		if (wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, i))
-			wcn36xx_dbg(WCN36XX_DBG_MAC, "FW Cap %s\n", wcn36xx_get_cap_name(i));
+		if (wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, i)) {
+			wcn36xx_dbg(WCN36XX_DBG_MAC, "FW Cap %s\n",
+				    wcn36xx_firmware_get_cap_name(i));
+		}
 	}
 }
 
-- 
2.36.1

