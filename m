Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD07A538E81
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 12:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245402AbiEaKJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 06:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245400AbiEaKJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 06:09:50 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E68996AD;
        Tue, 31 May 2022 03:09:48 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id k16so13642271wrg.7;
        Tue, 31 May 2022 03:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PSCX4PHCAROocqljRy3ZnI/Dr3u/fImtm88PpfecH+0=;
        b=hgL7i4XhVKnDz+kV6ZUE7M1I5YWxgyeFW2IZF2mSrdg4RvA1wzUpEjpZp0UL8CTzy4
         +6zDKiJjI/xbhMEf/hdKbj+GEz7nQr3s94DqNwb4DnmCKFcUxk0OeQ9vQCKA6ez2anWb
         QbVooWUWhpKl2Yn7AHI9HP6ngfob1aHHe5a9xbOSfuj2OmrK4N9X477rxL8O9b1OsD+g
         PtUvha7RK1clPNKDMorU2IBsVZJQsvxfkCMkcfShi9SxTLwHDC7bnNoB0Lxi8+/+AkuR
         HCru7e1wLgDwrbmJYV3oA2c3aN4+ehq1Vicg0eUYQqvQ1+C0RNIh4ob3SZt4spKW/PxT
         i8Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PSCX4PHCAROocqljRy3ZnI/Dr3u/fImtm88PpfecH+0=;
        b=LZzoGtgAci/jXSpdWjGrhinc4o/sUt+cQXdag+rSLtNDMYiAuc2iQnHFJI3WEKRxO4
         strcHSNd5+7myhZzJVg4ho7XCEWjaYMCJf7xf39NGtk4bmqn5gUlHKbpHZUEE5ezSHWg
         3xfMb5qkAxQpAwTUOBmYZgTmv711zX+gY+xymVRKt0S4h9EBv89K/ELBKKLbCLnTmQfN
         McXVr1ws15hSW/3g8XerGVj4KiV6aLl9rK5itdCOar+yu2ciEEMYKs1uFV7zS23123nt
         0uovx2uwZVYCgbtf7XPP3Wso36jpM/s9/a3bT77ySqCqeC0PArWRelHEe1kbVBW25Nis
         CChg==
X-Gm-Message-State: AOAM533QdCfhHe4mtuCJTLst/RNiWMUnotfZgJN2Drrgn0POF/k7iglI
        tWCtES4wkLVfvEf3afp6y4M=
X-Google-Smtp-Source: ABdhPJzEABsFC0dAQtKAZa34WuskN0k+eNzR8nofFV3y4fHwJcykXVBdRQaxtQGc/Y72uF6IkW2opA==
X-Received: by 2002:a05:6000:1542:b0:20f:f809:cf89 with SMTP id 2-20020a056000154200b0020ff809cf89mr27658582wry.361.1653991786933;
        Tue, 31 May 2022 03:09:46 -0700 (PDT)
Received: from baligh-ThinkCentre-M720q.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.googlemail.com with ESMTPSA id n6-20020a05600c4f8600b0039b006bd6d9sm1975543wmq.6.2022.05.31.03.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 03:09:46 -0700 (PDT)
From:   Baligh Gasmi <gasmibal@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Baligh Gasmi <gasmibal@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org (open list:MAC80211),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v3 1/1] mac80211: use AQL airtime for expected throughput.
Date:   Tue, 31 May 2022 12:09:22 +0200
Message-Id: <20220531100922.491344-1-gasmibal@gmail.com>
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
 net/mac80211/sta_info.h   | 11 +++++++++++
 net/mac80211/status.c     |  2 ++
 net/mac80211/tx.c         |  8 +++++++-
 5 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 4e2fc1a08681..fa9952154795 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1142,6 +1142,8 @@ static inline u32 drv_get_expected_throughput(struct ieee80211_local *local,
 	trace_drv_get_expected_throughput(&sta->sta);
 	if (local->ops->get_expected_throughput && sta->uploaded)
 		ret = local->ops->get_expected_throughput(&local->hw, &sta->sta);
+	else
+		ret = ewma_avg_est_tp_read(&sta->deflink.status_stats.avg_est_tp);
 	trace_drv_return_u32(local, ret);
 
 	return ret;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index e04a0905e941..201aab465234 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1993,6 +1993,45 @@ void ieee80211_sta_update_pending_airtime(struct ieee80211_local *local,
 			       tx_pending, 0);
 }
 
+void ieee80211_sta_update_tp(struct ieee80211_local *local,
+			     struct sta_info *sta,
+			     struct sk_buff *skb,
+			     u16 tx_time_est,
+			     bool ack, int retry)
+{
+	unsigned long diff;
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
+	sta->deflink.tx_stats.tp_tx_size += (skb->len * 8) * 1000;
+	sta->deflink.tx_stats.tp_tx_time_est += tx_time_est;
+
+	diff = jiffies - sta->deflink.status_stats.last_tp_update;
+	if (diff > HZ / 10) {
+		ewma_avg_est_tp_add(&sta->deflink.status_stats.avg_est_tp,
+				    sta->deflink.tx_stats.tp_tx_size /
+				    sta->deflink.tx_stats.tp_tx_time_est);
+
+		sta->deflink.tx_stats.tp_tx_size = 0;
+		sta->deflink.tx_stats.tp_tx_time_est = 0;
+		sta->deflink.status_stats.last_tp_update = jiffies;
+	}
+}
+
 int sta_info_move_state(struct sta_info *sta,
 			enum ieee80211_sta_state new_state)
 {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 35c390bedfba..4200856fefcd 100644
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
@@ -549,6 +556,8 @@ struct link_sta_info {
 		s8 last_ack_signal;
 		bool ack_signal_filled;
 		struct ewma_avg_signal avg_ack_signal;
+		struct ewma_avg_est_tp avg_est_tp;
+		unsigned long last_tp_update;
 	} status_stats;
 
 	/* Updated from TX path only, no locking requirements */
@@ -558,6 +567,8 @@ struct link_sta_info {
 		struct ieee80211_tx_rate last_rate;
 		struct rate_info last_rate_info;
 		u64 msdu[IEEE80211_NUM_TIDS + 1];
+		u64 tp_tx_size;
+		u64 tp_tx_time_est;
 	} tx_stats;
 
 	enum ieee80211_sta_rx_bandwidth cur_max_bandwidth;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index e69272139437..1fb93abc1709 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -1152,6 +1152,8 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 	ack_signal_valid =
 		!!(info->status.flags & IEEE80211_TX_STATUS_ACK_SIGNAL_VALID);
 
+	ieee80211_sta_update_tp(local, sta, skb, tx_time_est, acked, retry_count);
+
 	if (pubsta) {
 		struct ieee80211_sub_if_data *sdata = sta->sdata;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0e4efc08c762..e58d89c108a4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3632,6 +3632,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result r;
 	struct ieee80211_vif *vif = txq->vif;
+	struct rate_control_ref *ref = NULL;
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
@@ -3790,8 +3791,13 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 encap_out:
 	IEEE80211_SKB_CB(skb)->control.vif = vif;
 
+	if (tx.sta && test_sta_flag(tx.sta, WLAN_STA_RATE_CONTROL))
+		ref = tx.sta->deflink.rate_ctrl;
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

