Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA9C4DE208
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240462AbiCRT7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 15:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240453AbiCRT7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 15:59:46 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0133611BCEB
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 12:58:27 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso11269952pjb.0
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 12:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=squareup.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gSuKdEg2QyJhGVNfcWhCG5mMthIWcw84Xj0bFaKk1K0=;
        b=KH+L/4Qk3634chHzxtOMoyIVddByO58d/7/A0h80FTeBAJbnhRMDCSfJQDAQOksHKH
         G71wBBqCOXQbvr1X2waAHVAbCDsbsDmq6DW68A7Ugl4/fYy2feLWzKvhaYZFirckTU0N
         k506hPyxR2vRJ3qC9bD037EShGWKMaq28uutM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gSuKdEg2QyJhGVNfcWhCG5mMthIWcw84Xj0bFaKk1K0=;
        b=T35eqhatI7pAIOCkCiWOL4Mx1ECEcXb8QCDmNk6TAsgsgxibnniuv4iO0JXCZ3kBHO
         mQj9oscqAA5lVVxsx6omu1NH+UxJJmeIeDQMf8W9a/LKLC6NzAorjjZ+c7HHbNAxj/Wn
         ldMkerAtielf+twsB1vK7mfWH9x5KhQqbHvkLY1B4sBfi7DJkxt65vyPmz7kT3jcCcPz
         vl/8CtuA2ybQcQ+bcu4NwLeIIZb2/PPsAG183q8ThAa1jqggYugGaEcLizIBzOqMQSn5
         bQiRK95IRBbQFwSutPsWBNjX8b0AZL6Ume+EUY7CzDORi19hWPaU8QEHbcX3VPpbuI9O
         pY9A==
X-Gm-Message-State: AOAM533r21aND65M/HYtpHv8sS0wztBjnDvxYwV0T1kazW1yGrDiVWsC
        lfQ1jX08zOVHv2Jbz2JUut4DYg==
X-Google-Smtp-Source: ABdhPJwea3tAlNGcP1X1B2LxKQwZ1tQvI0A/AlcaAT7AatFu5CkVcZG6W72QhVrGH0kLQdw3EaktcQ==
X-Received: by 2002:a17:902:f68b:b0:154:2265:b605 with SMTP id l11-20020a170902f68b00b001542265b605mr1195748plg.84.1647633506410;
        Fri, 18 Mar 2022 12:58:26 -0700 (PDT)
Received: from localhost ([135.84.132.160])
        by smtp.gmail.com with UTF8SMTPSA id q2-20020a638c42000000b003817671cb29sm7788797pgn.41.2022.03.18.12.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 12:58:26 -0700 (PDT)
From:   Edmond Gagnon <egagnon@squareup.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Edmond Gagnon <egagnon@squareup.com>,
        Benjamin Li <benl@squareup.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] wcn36xx: Implement tx_rate reporting
Date:   Fri, 18 Mar 2022 14:58:03 -0500
Message-Id: <20220318195804.4169686-3-egagnon@squareup.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220318195804.4169686-1-egagnon@squareup.com>
References: <20220318195804.4169686-1-egagnon@squareup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the driver reports a tx_rate of 6.0 MBit/s no matter the true
rate:

root@linaro-developer:~# iw wlan0 link
Connected to 6c:f3:7f:eb:9b:92 (on wlan0)
        SSID: SQ-DEVICETEST
        freq: 5200
        RX: 4141 bytes (32 packets)
        TX: 2082 bytes (15 packets)
        signal: -77 dBm
        rx bitrate: 135.0 MBit/s MCS 6 40MHz short GI
        tx bitrate: 6.0 MBit/s

        bss flags:      short-slot-time
        dtim period:    1
        beacon int:     100

This patch requests HAL_GLOBAL_CLASS_A_STATS_INFO via a hal_get_stats
firmware message and reports it via ieee80211_tx_rate_update:

root@linaro-developer:~# iw wlan0 link
Connected to 6c:f3:7f:eb:98:21 (on wlan0)
        SSID: SQ-DEVICETEST
        freq: 2412
        RX: 440785 bytes (573 packets)
        TX: 60526 bytes (571 packets)
        signal: -64 dBm
        rx bitrate: 72.2 MBit/s MCS 7 short GI
        tx bitrate: 52.0 MBit/s MCS 5

        bss flags:      short-preamble short-slot-time
        dtim period:    1
        beacon int:     100

Tested on MSM8939 with WCN3680B running CNSS-PR-2-0-1-2-c1-00083 with
5.17, and verified by sniffing frames over the air with Wireshark to
ensure the MCS indices match.

Signed-off-by: Edmond Gagnon <egagnon@squareup.com>
Reviewed-by: Benjamin Li <benl@squareup.com>
---
 drivers/net/wireless/ath/wcn36xx/hal.h     |  7 ++-
 drivers/net/wireless/ath/wcn36xx/main.c    | 25 +++++++++
 drivers/net/wireless/ath/wcn36xx/smd.c     | 58 +++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/smd.h     |  1 +
 drivers/net/wireless/ath/wcn36xx/txrx.c    | 59 ++++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/txrx.h    |  2 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  4 ++
 7 files changed, 155 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 2a1db9756fd5..46a49f0a51b3 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -2626,7 +2626,12 @@ enum tx_rate_info {
 	HAL_TX_RATE_SGI = 0x8,
 
 	/* Rate with Long guard interval */
-	HAL_TX_RATE_LGI = 0x10
+	HAL_TX_RATE_LGI = 0x10,
+
+	/* VHT rates */
+	HAL_TX_RATE_VHT20  = 0x20,
+	HAL_TX_RATE_VHT40  = 0x40,
+	HAL_TX_RATE_VHT80  = 0x80,
 };
 
 struct ani_global_class_a_stats_info {
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 70531f62777e..75453a3744a6 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -25,6 +25,7 @@
 #include <linux/rpmsg.h>
 #include <linux/soc/qcom/smem_state.h>
 #include <linux/soc/qcom/wcnss_ctrl.h>
+#include <linux/workqueue.h>
 #include <net/ipv6.h>
 #include "wcn36xx.h"
 #include "testmode.h"
@@ -960,6 +961,10 @@ static void wcn36xx_bss_info_changed(struct ieee80211_hw *hw,
 			if (vif->type == NL80211_IFTYPE_STATION)
 				wcn36xx_smd_add_beacon_filter(wcn, vif);
 			wcn36xx_enable_keep_alive_null_packet(wcn, vif);
+
+			wcn->get_stats_sta = sta;
+			wcn->get_stats_vif = vif;
+			schedule_delayed_work(&wcn->get_stats_work, msecs_to_jiffies(3000));
 		} else {
 			wcn36xx_dbg(WCN36XX_DBG_MAC,
 				    "disassociated bss %pM vif %pM AID=%d\n",
@@ -967,6 +972,9 @@ static void wcn36xx_bss_info_changed(struct ieee80211_hw *hw,
 				    vif->addr,
 				    bss_conf->aid);
 			vif_priv->sta_assoc = false;
+			cancel_delayed_work_sync(&wcn->get_stats_work);
+			wcn->get_stats_vif = NULL;
+			wcn->get_stats_sta = NULL;
 			wcn36xx_smd_set_link_st(wcn,
 						bss_conf->bssid,
 						vif->addr,
@@ -1598,6 +1606,17 @@ static int wcn36xx_platform_get_resources(struct wcn36xx *wcn,
 	return ret;
 }
 
+void wcn36xx_get_stats_work(struct work_struct *work)
+{
+	struct delayed_work *delayed_work = container_of(work, struct delayed_work, work);
+	struct wcn36xx *wcn = container_of(delayed_work, struct wcn36xx, get_stats_work);
+	int stats_status;
+
+	stats_status = wcn36xx_smd_get_stats(wcn, HAL_GLOBAL_CLASS_A_STATS_INFO);
+
+	schedule_delayed_work(&wcn->get_stats_work, msecs_to_jiffies(WCN36XX_HAL_STATS_INTERVAL));
+}
+
 static int wcn36xx_probe(struct platform_device *pdev)
 {
 	struct ieee80211_hw *hw;
@@ -1640,6 +1659,8 @@ static int wcn36xx_probe(struct platform_device *pdev)
 		goto out_wq;
 	}
 
+	INIT_DELAYED_WORK(&wcn->get_stats_work, wcn36xx_get_stats_work);
+
 	ret = dma_set_mask_and_coherent(wcn->dev, DMA_BIT_MASK(32));
 	if (ret < 0) {
 		wcn36xx_err("failed to set DMA mask: %d\n", ret);
@@ -1713,6 +1734,10 @@ static int wcn36xx_remove(struct platform_device *pdev)
 	__skb_queue_purge(&wcn->amsdu);
 
 	mutex_destroy(&wcn->hal_mutex);
+
+	cancel_delayed_work_sync(&wcn->get_stats_work);
+	wcn->get_stats_vif = NULL;
+	wcn->get_stats_sta = NULL;
 	ieee80211_free_hw(hw);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index caeb68901326..ecb083d5b43a 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2627,6 +2627,63 @@ int wcn36xx_smd_del_ba(struct wcn36xx *wcn, u16 tid, u8 direction, u8 sta_index)
 	return ret;
 }
 
+int wcn36xx_smd_get_stats(struct wcn36xx *wcn, u32 stats_mask)
+{
+	struct wcn36xx_hal_stats_req_msg msg_body;
+	struct wcn36xx_hal_stats_rsp_msg *rsp;
+	void *rsp_body;
+	int ret = 0;
+
+	if (stats_mask & ~HAL_GLOBAL_CLASS_A_STATS_INFO) {
+		wcn36xx_err("stats_mask 0x%x contains unimplemented types\n",
+			    stats_mask);
+		return -EINVAL;
+	}
+
+	mutex_lock(&wcn->hal_mutex);
+	INIT_HAL_MSG(msg_body, WCN36XX_HAL_GET_STATS_REQ);
+
+	msg_body.sta_id = get_sta_index(wcn->get_stats_vif,
+					wcn36xx_sta_to_priv(wcn->get_stats_sta));
+	msg_body.stats_mask = stats_mask;
+
+	PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
+
+	ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
+	if (ret) {
+		wcn36xx_err("sending hal_get_stats failed\n");
+		goto out;
+	}
+
+	ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
+	if (ret) {
+		wcn36xx_err("hal_get_stats response failed err=%d\n", ret);
+		goto out;
+	}
+
+	rsp = (struct wcn36xx_hal_stats_rsp_msg *)wcn->hal_buf;
+	rsp_body = (wcn->hal_buf + sizeof(struct wcn36xx_hal_stats_rsp_msg));
+
+	if (rsp->stats_mask != stats_mask) {
+		wcn36xx_err("stat_mask 0x%x differs from requested 0x%x\n",
+			    rsp->stats_mask, stats_mask);
+		goto out;
+	}
+
+	if (rsp->stats_mask & HAL_GLOBAL_CLASS_A_STATS_INFO) {
+		ret = wcn36xx_report_tx_rate(wcn, (struct ani_global_class_a_stats_info *)rsp_body);
+		if (ret) {
+			wcn36xx_err("failed to report TX rate\n");
+			goto out;
+		}
+		rsp_body += sizeof(struct ani_global_class_a_stats_info);
+	}
+out:
+	mutex_unlock(&wcn->hal_mutex);
+
+	return ret;
+}
+
 static int wcn36xx_smd_trigger_ba_rsp(void *buf, int len, struct add_ba_info *ba_info)
 {
 	struct wcn36xx_hal_trigger_ba_rsp_candidate *candidate;
@@ -3316,6 +3373,7 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
 	case WCN36XX_HAL_ADD_BA_SESSION_RSP:
 	case WCN36XX_HAL_ADD_BA_RSP:
 	case WCN36XX_HAL_DEL_BA_RSP:
+	case WCN36XX_HAL_GET_STATS_RSP:
 	case WCN36XX_HAL_TRIGGER_BA_RSP:
 	case WCN36XX_HAL_UPDATE_CFG_RSP:
 	case WCN36XX_HAL_JOIN_RSP:
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.h b/drivers/net/wireless/ath/wcn36xx/smd.h
index 957cfa87fbde..a30f28f4130d 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.h
+++ b/drivers/net/wireless/ath/wcn36xx/smd.h
@@ -138,6 +138,7 @@ int wcn36xx_smd_add_ba_session(struct wcn36xx *wcn,
 int wcn36xx_smd_add_ba(struct wcn36xx *wcn, u8 session_id);
 int wcn36xx_smd_del_ba(struct wcn36xx *wcn, u16 tid, u8 direction, u8 sta_index);
 int wcn36xx_smd_trigger_ba(struct wcn36xx *wcn, u8 sta_index, u16 tid, u16 *ssn);
+int wcn36xx_smd_get_stats(struct wcn36xx *wcn, u32 stats_mask);
 
 int wcn36xx_smd_update_cfg(struct wcn36xx *wcn, u32 cfg_id, u32 value);
 
diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index df749b114568..ac55f8d62440 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -699,3 +699,62 @@ int wcn36xx_start_tx(struct wcn36xx *wcn,
 
 	return ret;
 }
+
+int wcn36xx_report_tx_rate(struct wcn36xx *wcn, struct ani_global_class_a_stats_info *stats)
+{
+	struct ieee80211_tx_info info;
+	struct ieee80211_tx_rate *tx_rate;
+
+	memset(&info, 0, sizeof(struct ieee80211_tx_info));
+	tx_rate = &info.status.rates[0];
+
+	tx_rate->idx = stats->mcs_index;
+	tx_rate->count = 0;
+	tx_rate->flags = 0;
+
+	if (stats->tx_rate_flags & HAL_TX_RATE_LEGACY) {
+		// tx_rate is in units of 500kbps, while wcn36xx_rate_table's rates
+		// are in units of 100kbps.
+		unsigned int reported_rate = stats->tx_rate * 5;
+		int i;
+
+		// Iterate over the legacy rates to convert bitrate to rate index.
+		for (i = 0; i < ARRAY_SIZE(wcn36xx_rate_table); i++) {
+			const struct wcn36xx_rate *rate = &wcn36xx_rate_table[i];
+
+			if (rate->encoding != RX_ENC_LEGACY) {
+				wcn36xx_warn("legacy rate %u not present in rate table\n",
+					     reported_rate);
+				break;
+			}
+			if (rate->bitrate == reported_rate) {
+				tx_rate->idx = rate->mcs_or_legacy_index;
+				break;
+			}
+		}
+	}
+
+	// HT?
+	if (stats->tx_rate_flags & (HAL_TX_RATE_HT20 | HAL_TX_RATE_HT40))
+		tx_rate->flags |= IEEE80211_TX_RC_MCS;
+
+	// VHT?
+	if (stats->tx_rate_flags & (HAL_TX_RATE_VHT20 | HAL_TX_RATE_VHT40 | HAL_TX_RATE_VHT80))
+		tx_rate->flags |= IEEE80211_TX_RC_VHT_MCS;
+
+	// SGI / LGI?
+	if (stats->tx_rate_flags & HAL_TX_RATE_SGI)
+		tx_rate->flags |= IEEE80211_TX_RC_SHORT_GI;
+
+	// 40MHz?
+	if (stats->tx_rate_flags & (HAL_TX_RATE_HT40 | HAL_TX_RATE_VHT40))
+		tx_rate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+
+	// 80MHz?
+	if (stats->tx_rate_flags & HAL_TX_RATE_VHT80)
+		tx_rate->flags |= IEEE80211_TX_RC_80_MHZ_WIDTH;
+
+	ieee80211_tx_rate_update(wcn->hw, wcn->get_stats_sta, &info);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.h b/drivers/net/wireless/ath/wcn36xx/txrx.h
index b54311ffde9c..28cf45ce6c89 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.h
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.h
@@ -18,6 +18,7 @@
 #define _TXRX_H_
 
 #include <linux/etherdevice.h>
+#include <linux/string.h>
 #include "wcn36xx.h"
 
 /* TODO describe all properties */
@@ -164,5 +165,6 @@ int  wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb);
 int wcn36xx_start_tx(struct wcn36xx *wcn,
 		     struct wcn36xx_sta *sta_priv,
 		     struct sk_buff *skb);
+int wcn36xx_report_tx_rate(struct wcn36xx *wcn, struct ani_global_class_a_stats_info *stats);
 
 #endif	/* _TXRX_H_ */
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 80a4e7aea419..121195991ee2 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -32,6 +32,7 @@
 
 #define WLAN_NV_FILE               "wlan/prima/WCNSS_qcom_wlan_nv.bin"
 #define WCN36XX_AGGR_BUFFER_SIZE 64
+#define WCN36XX_HAL_STATS_INTERVAL 3000
 
 extern unsigned int wcn36xx_dbg_mask;
 
@@ -295,6 +296,9 @@ struct wcn36xx {
 
 	spinlock_t survey_lock;		/* protects chan_survey */
 	struct wcn36xx_chan_survey	*chan_survey;
+	struct delayed_work get_stats_work;
+	struct ieee80211_sta *get_stats_sta;
+	struct ieee80211_vif *get_stats_vif;
 };
 
 static inline bool wcn36xx_is_fw_version(struct wcn36xx *wcn,
-- 
2.25.1

