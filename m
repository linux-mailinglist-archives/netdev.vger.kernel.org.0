Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D191853A42D
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 13:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352834AbiFALbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 07:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352819AbiFALbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 07:31:35 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61350703F3;
        Wed,  1 Jun 2022 04:31:33 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k19so1919429wrd.8;
        Wed, 01 Jun 2022 04:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DjC4XPc3pHJcR2WcSokV5/EvwHKyghpLbBxl/e5UR/c=;
        b=ghSOQ5id8TKh2BaBsLyS2j946ZQzeNgQEVJWTTsnDs0eVCUpTSHmCdo04lXGyHnuRj
         PbtzYXEam3clKmg+R/QZFGxzZHhyFdl68+Cmiwwigu7f9y+TYCSGwowtb0qr6YQxBtq+
         p+0NR/X6vUiTwzU6kZcOdxcePREZG820t7v7c0lWWCVtRNCBWtuTexdreTP3UzFCHX2L
         Nhe2/M+YJD+BwLVrC6HBbGKkQG/2GH+4iskbBt7gvgJtIQDLGHAPRLEUMVD6mDyJ2r9G
         U8eNgruOXmaXgbZQxLC6S47iJUGPtW2tnxoVE7q1DOAleJtx8noONTI6MCij47jqncwZ
         7faw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DjC4XPc3pHJcR2WcSokV5/EvwHKyghpLbBxl/e5UR/c=;
        b=g7nXOJxnwN/l+ina1+QkheYmtJQExyB6+ZOUUiUDuAx6raivp49oMHF1sAhELkfko/
         kWopKyXJRQoUng4AX5RYr2Nzg9TgiLZjEGPlgqoYjqm/ygUQomwVlygjL/65pxZxyOCh
         o3UBsd+Qtnz/xblewYNZ3WJQqwukHeVY1zpC5QP2Q4EEPSNsuttGMry42PXAs6iIcX2O
         FEuBgLFq6YS9OPO2tbkvoFnN/iSaZtBygmwwrc4E/n/p8Frh3idASoJgxyXeAcCVAgdp
         zQagq1QbT4QFqUlIs/+FiaZdtmmRSiBiJr0Nh10hxbc/XOuSsm/oWHQgD3xcT5dZzMhs
         ajUA==
X-Gm-Message-State: AOAM533k2r/LM8MNBSmzOamgTg35ylCgRzYZQxEYsa74wcX5ymTNo+kN
        xevkqILWT8TJzltlFrbhCcekXgUsiO/1AA==
X-Google-Smtp-Source: ABdhPJyDFaFVDgmZaPQmgYXbzyRn/h1+JpR4ncoSGamGjxz+1HJf9faNqR9m2ogf2xjHKmNSDBjVOA==
X-Received: by 2002:adf:fbce:0:b0:20f:ca5b:c4cf with SMTP id d14-20020adffbce000000b0020fca5bc4cfmr43732009wrs.421.1654083092508;
        Wed, 01 Jun 2022 04:31:32 -0700 (PDT)
Received: from baligh-ThinkCentre-M720q.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.googlemail.com with ESMTPSA id j14-20020a05600c190e00b00397381a7ae8sm6196724wmq.30.2022.06.01.04.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 04:31:32 -0700 (PDT)
From:   Baligh Gasmi <gasmibal@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Baligh Gasmi <gasmibal@gmail.com>
Subject: [RFC PATCH v4 2/3] mac80211: add periodic monitor for channel busy time
Date:   Wed,  1 Jun 2022 13:29:02 +0200
Message-Id: <20220601112903.2346319-3-gasmibal@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220601112903.2346319-1-gasmibal@gmail.com>
References: <20220601112903.2346319-1-gasmibal@gmail.com>
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

Add a worker scheduled periodicaly to calculate the busy time average of
the current channel.

This will be used in the estimation for expected throughput.

Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
---
 net/mac80211/ieee80211_i.h |  6 ++++
 net/mac80211/iface.c       | 65 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 86ef0a46a68c..2cb388335ce8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -901,6 +901,7 @@ struct ieee80211_if_nan {
 	struct idr function_inst_ids;
 };
 
+DECLARE_EWMA(avg_busy, 8, 4)
 struct ieee80211_sub_if_data {
 	struct list_head list;
 
@@ -1024,6 +1025,11 @@ struct ieee80211_sub_if_data {
 	} debugfs;
 #endif
 
+	struct delayed_work monitor_work;
+	u64 last_time;
+	u64 last_time_busy;
+	struct ewma_avg_busy avg_busy;
+
 	/* must be last, dynamically sized area in this! */
 	struct ieee80211_vif vif;
 };
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 41531478437c..45b860c59d79 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1970,6 +1970,64 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 	mutex_unlock(&local->iflist_mtx);
 }
 
+#define DEFAULT_MONITOR_INTERVAL_MS 1000
+
+static void ieee80211_if_monitor_work(struct work_struct *work)
+{
+	struct delayed_work *delayed_work = to_delayed_work(work);
+	struct ieee80211_sub_if_data *sdata =
+		container_of(delayed_work, struct ieee80211_sub_if_data,
+			     monitor_work);
+	struct survey_info survey;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *channel = NULL;
+	int q = 0;
+	u64 interval = DEFAULT_MONITOR_INTERVAL_MS;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (chanctx_conf)
+		channel = chanctx_conf->def.chan;
+	rcu_read_unlock();
+
+	if (!channel)
+		goto end;
+
+	if (!local->started)
+		goto end;
+
+	do {
+		survey.filled = 0;
+		if (drv_get_survey(local, q++, &survey) != 0) {
+			survey.filled = 0;
+			break;
+		}
+	} while (channel != survey.channel);
+
+	if (survey.filled & SURVEY_INFO_TIME) {
+		/* real interval */
+		interval = survey.time - sdata->last_time;
+		/* store last time */
+		sdata->last_time = survey.time;
+	}
+
+	if (survey.filled & SURVEY_INFO_TIME_BUSY) {
+		/* busy */
+		u64 busy = survey.time_busy < sdata->last_time_busy ? 0 :
+			survey.time_busy - sdata->last_time_busy;
+		/* average percent busy time */
+		ewma_avg_busy_add(&sdata->avg_busy,
+				  (busy * 100) / interval);
+		/* store last busy time */
+		sdata->last_time_busy = survey.time_busy;
+	}
+
+end:
+	schedule_delayed_work(&sdata->monitor_work,
+			      msecs_to_jiffies(DEFAULT_MONITOR_INTERVAL_MS));
+}
+
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     unsigned char name_assign_type,
 		     struct wireless_dev **new_wdev, enum nl80211_iftype type,
@@ -2083,6 +2141,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 			  ieee80211_dfs_cac_timer_work);
 	INIT_DELAYED_WORK(&sdata->dec_tailroom_needed_wk,
 			  ieee80211_delayed_tailroom_dec);
+	INIT_DELAYED_WORK(&sdata->monitor_work,
+			  ieee80211_if_monitor_work);
 
 	for (i = 0; i < NUM_NL80211_BANDS; i++) {
 		struct ieee80211_supported_band *sband;
@@ -2154,6 +2214,9 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	list_add_tail_rcu(&sdata->list, &local->interfaces);
 	mutex_unlock(&local->iflist_mtx);
 
+	schedule_delayed_work(&sdata->monitor_work,
+			      msecs_to_jiffies(DEFAULT_MONITOR_INTERVAL_MS));
+
 	if (new_wdev)
 		*new_wdev = &sdata->wdev;
 
@@ -2164,6 +2227,8 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 {
 	ASSERT_RTNL();
 
+	cancel_delayed_work_sync(&sdata->monitor_work);
+
 	mutex_lock(&sdata->local->iflist_mtx);
 	list_del_rcu(&sdata->list);
 	mutex_unlock(&sdata->local->iflist_mtx);
-- 
2.36.1

