Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C94535D9C
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 11:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344888AbiE0Jtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 05:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbiE0Jtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 05:49:45 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9427B106364;
        Fri, 27 May 2022 02:49:44 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id z15so5159829wrg.11;
        Fri, 27 May 2022 02:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m5bhK0uuFpLsSa23o9aOkF1WGUPThssNTQf5QyxyuwE=;
        b=gzubcYVM/O9mZoQOrIoCLFARZILBxl76EnsbMDjmDLTR1xdGgM3OG3wU9FQACapiSL
         eL2LQzmlh4IdYNGcbQMcOxalzdMOuqTc3zpFIlOZqXkTcmpDp1k27p6YuXR2ShuRpeqc
         RSLyZu2yLTX/jFHhFJjFGzsoiOVEnV5nzqJM7ieRQ9rZp3sVPZ3FouRFXMVX+N/jbKdJ
         N9By0IHK+dr/SciAK+LQVs1q/vaJNg5QtBPKurLokkGCf99jLaSpkSVGGXuSlQ3Egmr7
         Cs0nRTnRdZxiAzT9f06hM9Rti9btnT7RhBjyE5n5dtQ+RjH13xo3NIt8ntEHavYnWqe0
         2hcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m5bhK0uuFpLsSa23o9aOkF1WGUPThssNTQf5QyxyuwE=;
        b=g9zxJvrX3FH6QcKL4CyNwSaxKlucV0qCdHBphjDww+C5FTqL3do8ey+ZtlNUZY1l1Z
         qzzw/CeAVbOH6b/qb2Ge97N+MzWrGbOIIqlHWt0UjkT6ylDbNNd9mlG9OaL6hUGms/wT
         F8ms/qPvYbYJ/+ZWY/x/5or5V4chSahEFsZmYVGto32Nt5zl0rVhcmfxJ8wzj0NhLSVQ
         Xitnc6PeQqQPfvjazaASI124ij3nkoV0HecWek5DhQsf622kKdpf4DpeiP0Qb5B5k5+c
         hPNaxcD6em12eBkz6l0v+PPwJRM9nz00w6y51bi05oRvGdwGeugSPaCzni8z+3QhVYqQ
         sI8w==
X-Gm-Message-State: AOAM5313RXNHWxpsxtXVRgQW1LCiXPvVkM4YiJrkf3J+ft+samLEfkCC
        ZdBUUJwUE1lzcxpuUxUWvWQ=
X-Google-Smtp-Source: ABdhPJzRcMe77jX+bSVANL7BNzVOXlNv/j6Idml3JlAMJdczhtyBa2UE66MOq9xxg++HaI7eeruEEQ==
X-Received: by 2002:a05:6000:1acc:b0:20f:e35e:450 with SMTP id i12-20020a0560001acc00b0020fe35e0450mr17993001wry.531.1653644982985;
        Fri, 27 May 2022 02:49:42 -0700 (PDT)
Received: from baligh-ThinkCentre-M720q.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.googlemail.com with ESMTPSA id o15-20020a5d58cf000000b0020d02ddf4d0sm1257376wrf.69.2022.05.27.02.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 02:49:42 -0700 (PDT)
From:   Baligh Gasmi <gasmibal@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Baligh Gasmi <gasmibal@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org (open list:MAC80211),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v1 1/1] mac80211: use AQL airtime for expected throughput.
Date:   Fri, 27 May 2022 11:49:28 +0200
Message-Id: <20220527094928.3153984-1-gasmibal@gmail.com>
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
index 379fd367197f..0c1ebf8d87ef 100644
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
+		u32 tp_tx_size;
+		u32 tp_tx_time_est;
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

