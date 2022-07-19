Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F66579CAF
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 14:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241282AbiGSMlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 08:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241592AbiGSMj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 08:39:57 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FED35465B
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 05:16:11 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id z12so21324813wrq.7
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 05:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1htt3sRateXvcU1ylDQghkW6+6TpG01zPBq1kp3I6v0=;
        b=TbpsTJnC4c04TmS6K0aLQnFEGRIxb7jDLtd+6Zj3EiLaSQH6HTw/fkaVI2KD/Tczj3
         /Sg+GGwqe6MxLUEYFwYUt4UkGCHRoquTXcfvB8wbsa1DVK9T4huF+WCrLzqSDOLNkTcu
         qE+Q5+ilIasAMSG39iPOz87krb6l7vI0D87GgAThWDbSu/dAWlswoyP3rnqBwtw0n+6U
         ygwctALhdFqctpZBUDuKFbz54H2B100mEkcI8+bG4ahJI7nwO25pD56SvwQMroJvcsvo
         7PFZqOymFOzWOTEo051ax4ZJV3JdpmpwiZCMBN/pY8DvuIhOezvdG9hrq79itCI+Qjd3
         13gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1htt3sRateXvcU1ylDQghkW6+6TpG01zPBq1kp3I6v0=;
        b=Z98umaDGwEt1dIcumCPfCj09Pzvi2vb5ey2511dkaDtB6I8FZlbOh9VFZjYeRU6ikX
         gml82r5XU8xSfkdhAUcWsbBe0AUEr9MLKlVGBvqnNc95fB9bhpvmfUCXpVh0iraPPiGw
         tfZk9cZeYiU04ric8JDw7l0uP6PCz3YSMJMliUVCHprInAbFIrwqPgBeTWrBa1m7TwaP
         Qxz5h3DsuyB2A6WJmh/20tWbRrpq7vUSResTW8hXcPDtvLwLvYVPPu6gUPz9qZIzFr5t
         k5+BRy53mIMvhyhNsSvJ5n4T5SshJ+mEHwA4EH42V//dw8ViuIMX8KZEl1UwJOtgyzwD
         yiZA==
X-Gm-Message-State: AJIora+6vLx3+nJGfggGJ9GAn4xLawn3KcwqAFPqOsvk+0+03wnIXB8z
        LA9Gmw7oRt4x+ScF53OqkRMgfQ==
X-Google-Smtp-Source: AGRyM1sA0rGJKj6MgQ0kiYF11W0LSXa0VE7FhKJSu4CkDmEfDtMZFSVXvILM4r4n/vPKfhIF9RTiTQ==
X-Received: by 2002:a05:6000:104c:b0:21d:87bf:63a2 with SMTP id c12-20020a056000104c00b0021d87bf63a2mr26171589wrx.461.1658232966465;
        Tue, 19 Jul 2022 05:16:06 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id d16-20020a05600c34d000b0039c5642e430sm14423812wmq.20.2022.07.19.05.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:16:05 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@kernel.org, loic.poulain@linaro.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        bryan.odonoghue@linaro.org
Subject: [PATCH 3/4] wcn36xx: Move capability bitmap to string translation function to firmware.c
Date:   Tue, 19 Jul 2022 13:15:59 +0100
Message-Id: <20220719121600.1847440-4-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719121600.1847440-1-bryan.odonoghue@linaro.org>
References: <20220719121600.1847440-1-bryan.odonoghue@linaro.org>
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

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/firmware.c | 75 +++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/firmware.h |  2 +
 drivers/net/wireless/ath/wcn36xx/main.c     | 81 +--------------------
 3 files changed, 81 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/firmware.c b/drivers/net/wireless/ath/wcn36xx/firmware.c
index 03b93d2bdcf9..4b7f439e4db5 100644
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
index 552c0e9325e1..f991cf959f82 100644
--- a/drivers/net/wireless/ath/wcn36xx/firmware.h
+++ b/drivers/net/wireless/ath/wcn36xx/firmware.h
@@ -78,5 +78,7 @@ int wcn36xx_firmware_get_feat_caps(u32 *bitmap,
 void wcn36xx_firmware_clear_feat_caps(u32 *bitmap,
 				      enum wcn36xx_firmware_feat_caps cap);
 
+const char *wcn36xx_firmware_get_cap_name(enum wcn36xx_firmware_feat_caps x);
+
 #endif /* _FIRMWARE_H_ */
 
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index af62911a4659..fec85e89a02f 100644
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

