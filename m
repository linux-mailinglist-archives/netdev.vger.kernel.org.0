Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C0D535E10
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 12:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345512AbiE0KVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 06:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241726AbiE0KU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 06:20:59 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BC9128146;
        Fri, 27 May 2022 03:20:58 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id p10so5260759wrg.12;
        Fri, 27 May 2022 03:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5gwPr7LjNcXQJ+T49cK0g1nGx/GxeM1oD069psfY/W4=;
        b=Vrf44SpKpcAri+VmyqXuuRxeQ21nMXLuq6gDJPJ8OxKdtI/HTOgMm0T7HtsySlMaPV
         oRnyXucrBmme2bEifUipgV89mevObJVnCH2in3AXg00q5W00oSROiPO/zqdbOtqAMydJ
         huwz9ID6iYAyhiq3jhvSNGBBGYTqQJYKoWlfAdtJEY3JMNT/tSBEdoGuv8vp7xbigrWY
         cGitCIOZsD4JdA5EGAKd8QGqCI+A8Z1JAc0mcpa3kKif85AVWm6zBbsWNz9aBAW6vnSy
         O83ZNvDpkilhNuXMYnnkjyvD5QVeMg+CqWRr0wVIkv4xPhmQ3UbZH4ggxMQto0p7e/Y0
         5ylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5gwPr7LjNcXQJ+T49cK0g1nGx/GxeM1oD069psfY/W4=;
        b=bruWTf9rqbIoLuvZGplnR7r6NFqgQ/DNqshoJRgT5eA0XjjZPiidDqYgdzXGLb2LVL
         DmhHuyEgSIxUFQYjT8t91Yh9q6UMP103ly6p/4fZrZuXit8CbICaahnwJTagzuFMSuiW
         4bCYPIEwxBfbCj7EpNJl2q0MWZANUdywLIMmqhGnUXFhzw0MYJuctzcVgClEoOyZYiON
         1Io/pK3T0QWHNs/eGNu7Y/0LZcNh/n2PwtvUEb5Vhs/INTGihInEPjIE0/Gx2qPM4ONJ
         Ym4QobHeI3gE0dQCXmZVA6eZYn9yp3BWnMRkPH0y0KbTp1x10vBcfE+NOdqOLXmzh2r9
         6vcg==
X-Gm-Message-State: AOAM532P5IkZQKj5/u6LDH9jufs+oy9OPJpn6T/Z7cJGuwhVXv6WsNgG
        zYTNOvXjd3393mwwo3y4T+g=
X-Google-Smtp-Source: ABdhPJzvaWZL4k4MQJAF4sP2ZGQW2JCcu0mAYETMK+qMfZtv80OQf+p+NJlvkuYQ4JUpP2As5pNrkg==
X-Received: by 2002:a5d:4572:0:b0:20f:ca8a:bc5a with SMTP id a18-20020a5d4572000000b0020fca8abc5amr24048553wrc.514.1653646857302;
        Fri, 27 May 2022 03:20:57 -0700 (PDT)
Received: from baligh-ThinkCentre-M720q.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.googlemail.com with ESMTPSA id k7-20020a1ca107000000b00394708a3d7dsm1739192wme.15.2022.05.27.03.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 03:20:56 -0700 (PDT)
From:   Baligh Gasmi <gasmibal@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Baligh Gasmi <gasmibal@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org (open list:MAC80211),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v2 1/1] mac80211: use AQL airtime for expected throughput.
Date:   Fri, 27 May 2022 12:20:54 +0200
Message-Id: <20220527102054.3194209-1-gasmibal@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the integration of AQL, packet TX airtime estimation is
calculated and counted to be used for the dequeue limit.

Use this estimated airtime to compute expected throughput for
each station.

It will be a generic mac80211 implementation. If the driver has
get_expected_throughput implementation, it will be used instead.

Useful for L2 routing protocols, like B.A.T.M.A.N.

Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
---
 net/mac80211/driver-ops.h |  2 ++
 net/mac80211/sta_info.c   | 39 +++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h   | 12 ++++++++++++
 net/mac80211/status.c     |  3 ++-
 net/mac80211/tx.c         |  8 +++++++-
 5 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 4e2fc1a08681..4331b79647fa 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1142,6 +1142,8 @@ static inline u32 drv_get_expected_throughput(struct ieee80211_local *local,
 	trace_drv_get_expected_throughput(&sta->sta);
 	if (local->ops->get_expected_throughput && sta->uploaded)
 		ret = local->ops->get_expected_throughput(&local->hw, &sta->sta);
+	else
+		ret = ewma_avg_est_tp_read(&sta->status_stats.avg_est_tp);
 	trace_drv_return_u32(local, ret);
 
 	return ret;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 91fbb1ee5c38..f39d7ec2238d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1985,6 +1985,45 @@ void ieee80211_sta_update_pending_airtime(struct ieee80211_local *local,
 			       tx_pending, 0);
 }
 
+void ieee80211_sta_update_tp(struct ieee80211_local *local,
+			     struct sta_info *sta,
+			     struct sk_buff *skb,
+			     u16 tx_time_est,
+			     bool ack, int retry)
+{
+	unsigned long diff = 0;
+	struct rate_control_ref *ref = NULL;
+
+	if (!skb || !sta || !tx_time_est)
+		return;
+
+	if (test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
+		ref = sta->rate_ctrl;
+
+	if (ref && ref->ops->get_expected_throughput)
+		return;
+
+	if (local->ops->get_expected_throughput)
+		return;
+
+	tx_time_est += ack ? 4 : 0;
+	tx_time_est += retry ? retry * 2 : 2;
+
+	sta->tx_stats.tp_tx_size += (skb->len * 8) * 1000;
+	sta->tx_stats.tp_tx_time_est += tx_time_est;
+
+	diff = jiffies - sta->status_stats.last_tp_update;
+	if (diff > HZ / 10) {
+		ewma_avg_est_tp_add(&sta->status_stats.avg_est_tp,
+				    sta->tx_stats.tp_tx_size /
+				    sta->tx_stats.tp_tx_time_est);
+
+		sta->tx_stats.tp_tx_size = 0;
+		sta->tx_stats.tp_tx_time_est = 0;
+		sta->status_stats.last_tp_update = jiffies;
+	}
+}
+
 int sta_info_move_state(struct sta_info *sta,
 			enum ieee80211_sta_state new_state)
 {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 379fd367197f..b285e62ba210 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -123,6 +123,7 @@ enum ieee80211_sta_info_flags {
 #define HT_AGG_STATE_STOP_CB		7
 #define HT_AGG_STATE_SENT_ADDBA		8
 
+DECLARE_EWMA(avg_est_tp, 8, 16)
 DECLARE_EWMA(avg_signal, 10, 8)
 enum ieee80211_agg_stop_reason {
 	AGG_STOP_DECLINED,
@@ -157,6 +158,12 @@ void ieee80211_register_airtime(struct ieee80211_txq *txq,
 
 struct sta_info;
 
+void ieee80211_sta_update_tp(struct ieee80211_local *local,
+			     struct sta_info *sta,
+			     struct sk_buff *skb,
+			     u16 tx_time_est,
+			     bool ack, int retry);
+
 /**
  * struct tid_ampdu_tx - TID aggregation information (Tx).
  *
@@ -567,6 +574,7 @@ struct ieee80211_fragment_cache {
  * @status_stats.last_ack_signal: last ACK signal
  * @status_stats.ack_signal_filled: last ACK signal validity
  * @status_stats.avg_ack_signal: average ACK signal
+ * @status_stats.avg_est_tp: average expected throughput
  * @frags: fragment cache
  */
 struct sta_info {
@@ -641,6 +649,8 @@ struct sta_info {
 		s8 last_ack_signal;
 		bool ack_signal_filled;
 		struct ewma_avg_signal avg_ack_signal;
+		struct ewma_avg_est_tp avg_est_tp;
+		unsigned long last_tp_update;
 	} status_stats;
 
 	/* Updated from TX path only, no locking requirements */
@@ -650,6 +660,8 @@ struct sta_info {
 		struct ieee80211_tx_rate last_rate;
 		struct rate_info last_rate_info;
 		u64 msdu[IEEE80211_NUM_TIDS + 1];
+		u64 tp_tx_size;
+		u64 tp_tx_time_est;
 	} tx_stats;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index e81e8a5bb774..293a0f14a3ad 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -18,7 +18,6 @@
 #include "led.h"
 #include "wme.h"
 
-
 void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
 				 struct sk_buff *skb)
 {
@@ -1138,6 +1137,8 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 	ack_signal_valid =
 		!!(info->status.flags & IEEE80211_TX_STATUS_ACK_SIGNAL_VALID);
 
+	ieee80211_sta_update_tp(local, sta, skb, tx_time_est, acked, retry_count);
+
 	if (pubsta) {
 		struct ieee80211_sub_if_data *sdata = sta->sdata;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b6b20f38de0e..364cca1d688e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3634,6 +3634,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result r;
 	struct ieee80211_vif *vif = txq->vif;
+	struct rate_control_ref *ref = NULL;
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
@@ -3792,8 +3793,13 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 encap_out:
 	IEEE80211_SKB_CB(skb)->control.vif = vif;
 
+	if (tx.sta && test_sta_flag(tx.sta, WLAN_STA_RATE_CONTROL))
+		ref = tx.sta->rate_ctrl;
+
 	if (vif &&
-	    wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL)) {
+	    ((!local->ops->get_expected_throughput &&
+	     (!ref || !ref->ops->get_expected_throughput)) ||
+	    wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL))) {
 		bool ampdu = txq->ac != IEEE80211_AC_VO;
 		u32 airtime;
 
-- 
2.36.1

