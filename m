Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF084F9072
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 10:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbiDHIOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 04:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiDHIOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 04:14:19 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D514AE0D;
        Fri,  8 Apr 2022 01:12:15 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id s7so10080555qtk.6;
        Fri, 08 Apr 2022 01:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jw/XuL4gze/EjFGmPl0tsO01dQMr5OjXvuq1Bzbys1Q=;
        b=irp/7ScHoeQsUxSmCUbAbcmEFlRuyij8MQCMERCJiRm+THOMIlWJki09aJB2hid65U
         /rxDnCPH03txnpSNWJhtBWWKthYSeN6w/nrPv+kdpTz6CEmReXQ4MahGS54VstfzT5Al
         rPQTvbtnpJxfnd0KeUL8Lb9A7ZOW7X6KiYmJ3fJNWVo4iruVR9PZHeFI9HidNJIKaVHx
         P763oWiScRxs52CJGi4NKf76AQtHbmvfn11sQOXX6d9vL+VLFslPM7ZJFo4XbrVW9Nv4
         2ELk8SSeH+VGzRRDmktslJHWAWJah9gyiMjr5MQuntfw9Em06dAfHeoqBsKJccm8oJWh
         wigQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jw/XuL4gze/EjFGmPl0tsO01dQMr5OjXvuq1Bzbys1Q=;
        b=Pap+e8iU6HKO8xVz/EspvjG0cAFxpNlCkmdKwXuoD2ipapxvYOPeheJELVfNVT2hyD
         IIvhn2BsDWvFBr+eu1EH3umi5p4JWQ/so1sPwxxwTXw/IRjhxmc38fG60tsiX1Y21EHy
         aVMwPmMsw4Lc2ZDwmTrOoPaL0Gyctp3MfUBRpK7Q81h1hEmvbL6VDvb6s017rcLsa+PD
         /TfBYO6sGrBtoYrkjf2GFHksma001AmqYOf5dzqTb/tkEYQx7KReY9It76tp63CziRb0
         5R5d80WTFM2DsGMr4jXx6HfgPCIXXeINBeUt11fcyOcGlYhCjmBCPBBmBwCkx8yYQQFP
         v/mw==
X-Gm-Message-State: AOAM530Bi89mUN8jVTt/7lfOz68E3gQEgdy955Z8sadvrNLwWihmbbM2
        xIX+Gbk/gtAbD/MiI7N1pdI=
X-Google-Smtp-Source: ABdhPJx3epWw8SnQaL8w47Y6EpL+Nxb2TfF2wFBPcUkPnpy1geqdfdb4Fr2esV6hzF8GexBy05uDgw==
X-Received: by 2002:ac8:5895:0:b0:2e1:c997:a629 with SMTP id t21-20020ac85895000000b002e1c997a629mr14991481qta.124.1649405534737;
        Fri, 08 Apr 2022 01:12:14 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id m6-20020a05622a118600b002ebb68c31d5sm10487776qtk.45.2022.04.08.01.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 01:12:14 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] wlcore: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Fri,  8 Apr 2022 08:12:05 +0000
Message-Id: <20220408081205.2494512-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: Minghao Chi <chi.minghao@zte.com.cn>

Using pm_runtime_resume_and_get is more appropriate
for simplifing code

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/wireless/ti/wlcore/debugfs.c | 52 ++++++++----------------
 1 file changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index cce8d75d8b81..eb3d3f0e0b4d 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -52,11 +52,9 @@ void wl1271_debugfs_update_stats(struct wl1271 *wl)
 	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	if (!wl->plt &&
 	    time_after(jiffies, wl->stats.fw_stats_update +
@@ -108,12 +106,9 @@ static void chip_op_handler(struct wl1271 *wl, unsigned long value,
 		return;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
-
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		return;
-	}
 
 	chip_op = arg;
 	chip_op(wl);
@@ -279,11 +274,9 @@ static ssize_t dynamic_ps_timeout_write(struct file *file,
 	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	/* In case we're already in PSM, trigger it again to set new timeout
 	 * immediately without waiting for re-association
@@ -349,11 +342,9 @@ static ssize_t forced_ps_write(struct file *file,
 	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	/* In case we're already in PSM, trigger it again to switch mode
 	 * immediately without waiting for re-association
@@ -831,11 +822,9 @@ static ssize_t rx_streaming_interval_write(struct file *file,
 
 	wl->conf.rx_streaming.interval = value;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	wl12xx_for_each_wlvif_sta(wl, wlvif) {
 		wl1271_recalc_rx_streaming(wl, wlvif);
@@ -889,11 +878,9 @@ static ssize_t rx_streaming_always_write(struct file *file,
 
 	wl->conf.rx_streaming.always = value;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	wl12xx_for_each_wlvif_sta(wl, wlvif) {
 		wl1271_recalc_rx_streaming(wl, wlvif);
@@ -939,11 +926,9 @@ static ssize_t beacon_filtering_write(struct file *file,
 
 	mutex_lock(&wl->mutex);
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	wl12xx_for_each_wlvif(wl, wlvif) {
 		ret = wl1271_acx_beacon_filter_opt(wl, wlvif, !!value);
@@ -1021,11 +1006,9 @@ static ssize_t sleep_auth_write(struct file *file,
 		goto out;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wl1271_acx_sleep_auth(wl, value);
 	if (ret < 0)
@@ -1254,9 +1237,8 @@ static ssize_t fw_logger_write(struct file *file,
 	}
 
 	mutex_lock(&wl->mutex);
-	ret = pm_runtime_get_sync(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
 	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
 		count = ret;
 		goto out;
 	}
-- 
2.25.1

