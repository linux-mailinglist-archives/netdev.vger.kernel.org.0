Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721C8533AAB
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 12:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242270AbiEYKgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 06:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiEYKgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 06:36:09 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AA1A443;
        Wed, 25 May 2022 03:36:07 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j25so5079003wrb.6;
        Wed, 25 May 2022 03:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SvpetqDp1DmMiiKcIfJTEwOyw3H2hFj8w+4Y+8Shgoo=;
        b=njIND5I76OnHPDIVT0nywN9rceISYcqWz93BerV9hLldTdlnr4yzGDFtf25ZV1opr5
         MtgHT75MJZ+aBTIXWm8JH9WHRCn5ywykLO5Oegka5pboG3U3FKeZoXMbH0X4KU33xmNz
         UkW9C3+ktMS2HhUuZyqCp9sOFZnpl10pElNE7UgbkA5t8UukFEiZPtZehAbhgffH2Nu5
         NaFsylVOx6wS8EfaFhOrHnroRJMG9eP8PwPVjpR0bPNfk5iNy6DgO3W9bga8tdX1H9yN
         1XeIzxRWGuRnzaDQwm0rUvBAbtU3i2jL4baQCCEodZsgRscqJSeg+sud5VYVo39yBHbg
         Ziug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SvpetqDp1DmMiiKcIfJTEwOyw3H2hFj8w+4Y+8Shgoo=;
        b=FykLLmrodA5xGjjeT13b/K8BxX3aqGiHOx/PZMzHliXotIjzoGIhBpwl52+5dTcV9g
         c26AOYxj3JFvh7WRjbEj7Tl7V3zssHWOqdcsOO0VoMmYcQzru0p0VSRigfRb/g2045jW
         tsdDFJnAObH5tffsw6/Wg8JEV0G2TTfq6B4bwL5zSQfJu4GgEZOJm0FYV/y3ujP8GOE3
         /KzAmuKTBuCtuAeSwMKzIp0OiPctlz/MxdB5QhtbS/731+Ypv9gzLII15NJBYWJ5heje
         pKu9C+cCRd9o8Pm0s9RONhxUt4nx5yytD80e+iKE4rqzTmcuXWHFskD5Hr9s4tUplKOX
         gq1A==
X-Gm-Message-State: AOAM533ID9+5dZEdC5AY2IpKp8qVueoF79+d2NrqmQwfeiB64xuMcm0n
        6G4PL45GKXQAwUYr5zGTnII=
X-Google-Smtp-Source: ABdhPJxi0f4Dl7351AWpNQdLfaQ1E8adXhcaJ8q7YuCWNlK2N9rOOPAtIYu4HculsetpPKQs+/9Vaw==
X-Received: by 2002:a05:6000:156d:b0:20f:c26d:dc0d with SMTP id 13-20020a056000156d00b0020fc26ddc0dmr19663775wrz.676.1653474966009;
        Wed, 25 May 2022 03:36:06 -0700 (PDT)
Received: from baligh-ThinkCentre-M720q.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.googlemail.com with ESMTPSA id u10-20020a5d6daa000000b0020c5253d8c2sm1840287wrs.14.2022.05.25.03.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 03:36:05 -0700 (PDT)
From:   Baligh Gasmi <gasmibal@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Baligh Gasmi <gasmibal@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org (open list:MAC80211),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH 1/1] mac80211: use AQL airtime for expected throughput.
Date:   Wed, 25 May 2022 12:35:12 +0200
Message-Id: <20220525103512.3666956-1-gasmibal@gmail.com>
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
 net/mac80211/sta_info.h   |  2 ++
 net/mac80211/status.c     | 22 ++++++++++++++++++++++
 net/mac80211/tx.c         |  3 ++-
 4 files changed, 28 insertions(+), 1 deletion(-)

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
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 379fd367197f..fe60be4c671d 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -123,6 +123,7 @@ enum ieee80211_sta_info_flags {
 #define HT_AGG_STATE_STOP_CB		7
 #define HT_AGG_STATE_SENT_ADDBA		8
 
+DECLARE_EWMA(avg_est_tp, 8, 16)
 DECLARE_EWMA(avg_signal, 10, 8)
 enum ieee80211_agg_stop_reason {
 	AGG_STOP_DECLINED,
@@ -641,6 +642,7 @@ struct sta_info {
 		s8 last_ack_signal;
 		bool ack_signal_filled;
 		struct ewma_avg_signal avg_ack_signal;
+		struct ewma_avg_est_tp avg_est_tp;
 	} status_stats;
 
 	/* Updated from TX path only, no locking requirements */
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index e81e8a5bb774..647ade3719f5 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -1145,6 +1145,28 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 			sta->status_stats.retry_failed++;
 		sta->status_stats.retry_count += retry_count;
 
+		if (skb && tx_time_est) {
+			/* max average packet size */
+			size_t pkt_size = skb->len > 1024 ? 1024 : skb->len;
+
+			if (acked) {
+				/* ACK packet size */
+				pkt_size += 14;
+				/* SIFS x 2 */
+				tx_time_est += 2 * 2;
+			}
+
+			/* Backoff average x retries */
+			tx_time_est += retry_count ? retry_count * 2 : 2;
+
+			/* failed tx */
+			if (!acked && !noack_success)
+				pkt_size = 0;
+
+			ewma_avg_est_tp_add(&sta->status_stats.avg_est_tp,
+					    ((pkt_size * 8) * 1000) / tx_time_est);
+		}
+
 		if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 			if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 			    skb && !(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP))
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b6b20f38de0e..d866a721690d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3793,7 +3793,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	IEEE80211_SKB_CB(skb)->control.vif = vif;
 
 	if (vif &&
-	    wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL)) {
+	    (!local->ops->get_expected_throughput ||
+	    wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL))) {
 		bool ampdu = txq->ac != IEEE80211_AC_VO;
 		u32 airtime;
 
-- 
2.36.1

