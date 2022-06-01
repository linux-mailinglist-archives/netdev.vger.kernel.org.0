Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6B853A435
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 13:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352799AbiFALbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 07:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352807AbiFALbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 07:31:36 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3F670367;
        Wed,  1 Jun 2022 04:31:35 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x17so1936693wrg.6;
        Wed, 01 Jun 2022 04:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dxtIkLrQ+uEkp6mtT2vSgs4p16WW1MiV+wwrEChzYxE=;
        b=iO6RppWGp5s3SMMWxYTaus2hDNnRvlUkzGk/rnnBNXxXEfsmwkhLCvIFpSFqFi/KDA
         0hQzZJoyptsPBwq1PdlAT+IMac0DBp4bBjCI45Dib2kFHpCJQDk40+wNmNILqs8a34eM
         7vXgFhHVVFpjklCZynBL5x2o2P+E6w17PiZ5mibCmokrYe/Ary/JSYCttvedmnBjEaKl
         HWEYXkHRcxh/UTYiXJP8Myfr1c9JUl5kRhhmVbn+Uwnl9IPSqoAJuKIAU+sV1DtMeaWR
         An7LSjCx0J2e4wE+0GXail4zUya2nclEyGeuFZQSzaiVK/OvViaIShNNwlLp/fYBwT3V
         N6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dxtIkLrQ+uEkp6mtT2vSgs4p16WW1MiV+wwrEChzYxE=;
        b=3uOqURhd4Arux77LPEAtodRi+11R9cjJ86mm7WuKaljcC7b/h9YGr8I4UqohYKKM0v
         IuEQz6xuugA+hKvKJUCP0DQmf8Pmo7rNO21Xgmc+LU2hJWHfB22bBOjv2CTpbm6hVkBb
         b6y8Nj5q3ReXAkiE0FwNbRt8TfHND5h7ZlwCpywcYUYiHZ6wYe16RwUuyB4G+RJUgP+I
         jsMo2jGBUZyvyvfV0u2LTBxSGKf3m6b2o068HK6n9oR8M+QqEuE/FSRUAGHTEl/MVOYd
         f/XdbFj+TPSjpqwPRMVrI4XUcKpeGBlLXYIjQwWVuAL5wtl6218j3eZqbFleTMtN47Bi
         ACbQ==
X-Gm-Message-State: AOAM530fg36Li6XvsoWSPzaUG+8MtNFnu5GEdd0OUrrkJuMPPDqPP+pX
        viagVfm9ccyhZbUzWKBwc9Y=
X-Google-Smtp-Source: ABdhPJzrVmsK0GkBO/VJ2D/KHo0BKBl30TFWTTJv88GhKJFOl+a41CMtKClPhivLeV/F32jVfy9cvQ==
X-Received: by 2002:a05:6000:1625:b0:210:29c9:3e30 with SMTP id v5-20020a056000162500b0021029c93e30mr15622721wrb.252.1654083094480;
        Wed, 01 Jun 2022 04:31:34 -0700 (PDT)
Received: from baligh-ThinkCentre-M720q.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.googlemail.com with ESMTPSA id j14-20020a05600c190e00b00397381a7ae8sm6196724wmq.30.2022.06.01.04.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 04:31:34 -0700 (PDT)
From:   Baligh Gasmi <gasmibal@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Baligh Gasmi <gasmibal@gmail.com>
Subject: [RFC PATCH v4 3/3] mac80211: add busy time factor into expected throughput
Date:   Wed,  1 Jun 2022 13:29:03 +0200
Message-Id: <20220601112903.2346319-4-gasmibal@gmail.com>
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

When estimating the expected throughput, take into account the busy time
of the current channel.

Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
---
 net/mac80211/sta_info.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 201aab465234..9f977cf13dd5 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2000,6 +2000,8 @@ void ieee80211_sta_update_tp(struct ieee80211_local *local,
 			     bool ack, int retry)
 {
 	unsigned long diff;
+	struct ieee80211_sub_if_data *sdata;
+	u32 avg_busy;
 	struct rate_control_ref *ref = NULL;
 
 	if (!skb || !sta || !tx_time_est)
@@ -2014,6 +2016,7 @@ void ieee80211_sta_update_tp(struct ieee80211_local *local,
 	if (local->ops->get_expected_throughput)
 		return;
 
+	sdata = sta->sdata;
 	tx_time_est += ack ? 4 : 0;
 	tx_time_est += retry ? retry * 2 : 2;
 
@@ -2022,6 +2025,10 @@ void ieee80211_sta_update_tp(struct ieee80211_local *local,
 
 	diff = jiffies - sta->deflink.status_stats.last_tp_update;
 	if (diff > HZ / 10) {
+		avg_busy = ewma_avg_busy_read(&sdata->avg_busy) >> 1;
+		sta->deflink.tx_stats.tp_tx_time_est +=
+			(sta->deflin.tx_stats.tp_tx_time_est * avg_busy) / 100;
+
 		ewma_avg_est_tp_add(&sta->deflink.status_stats.avg_est_tp,
 				    sta->deflink.tx_stats.tp_tx_size /
 				    sta->deflink.tx_stats.tp_tx_time_est);
-- 
2.36.1

