Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7794B4FDC7A
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiDLKbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379186AbiDLKTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 06:19:36 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EE62317C;
        Tue, 12 Apr 2022 02:17:49 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so2160285pjn.3;
        Tue, 12 Apr 2022 02:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ToqYQJ3Zu2Ezuxdg4olJk7A9ve1Ywk8RAFod628TOOw=;
        b=iss0BVbVL2Ets73q3UhPFN/Y/zTtbtNShT38wBSEOz2WzcEGtRlu1Ne7Sh8K8/Cnak
         zDwYVdo+SX/FHmzdyAdEvrSKyTlaF+Ep3T2H7+P+4LvvGItxvRBM+vhkZaKQ/15X2jcO
         YPeh40qFyheHwTkyjRuQIKhYivQEJj4VaLp5H6diyjSr+H5UXaWtKJeixTrMCrpyqW9c
         Kh/BAbYLBFDoARt6rrb3tREk9+Zjhub/8VzrYStOLWVmK5+Lu/Imc3ehSN1SnrDDwl8t
         SjvXkWI3hqfdoOxuLgmqgGt7AmVZEb6mQZ2htjYiigakf+2CauDBQijx3w5bWUQxwmea
         BMJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ToqYQJ3Zu2Ezuxdg4olJk7A9ve1Ywk8RAFod628TOOw=;
        b=yKb5benvmWufqs5epmxoK8iuZIXk964ZwUFlOXEaoUmk6AMl2rxpSiYb+IgBWr/Buq
         NtJWqVtr2NR8cNb4r0h6dqN+8SEe1aoMksdgGrfD2fMRAoppaqWRwgBHdlrULtEUZwNn
         45jC8+4NGRQ7XhxKnu+t+8vxhMa3KK388j1laIBpFLZlbyOT/UrK1Kqq5v8PBC+Z6xDE
         qPL4ljfe4NDzyA+6l0BqY6mEVl2ZCv+Z/fV0OQtpDJp5ZFFUbnEKK7nKIdf8hQoSTnZC
         Qrmtx3HgFcbU1rW3y1X3awE80TXCFwfjv8DYMb7ZiMypcK28kYnAQuVssLqQuWgwf7TM
         WcQg==
X-Gm-Message-State: AOAM532xTsKPaKPKkbnWyFA63pNtA+JW686HA6XxEi3QfaW2GCoBrhKm
        OXtI7cxItQEgRozCzJ8Zqbk=
X-Google-Smtp-Source: ABdhPJzLXvuTIjZ6pAEEkIO00H+vjj/KrCf5Vfufd0rU1qzj0xadYxwfn7TXUOhSk0ddLzg7PwNryg==
X-Received: by 2002:a17:90a:bb10:b0:1cb:57fa:309 with SMTP id u16-20020a17090abb1000b001cb57fa0309mr3893982pjr.191.1649755068887;
        Tue, 12 Apr 2022 02:17:48 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id p12-20020a63ab0c000000b00381f7577a5csm2177302pgf.17.2022.04.12.02.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 02:17:48 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] wlcore: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Tue, 12 Apr 2022 09:17:42 +0000
Message-Id: <20220412091742.2533527-1-chi.minghao@zte.com.cn>
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
 drivers/net/wireless/ti/wlcore/main.c | 225 +++++++++-----------------
 1 file changed, 75 insertions(+), 150 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 5669f17b395f..24849e497772 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -141,11 +141,9 @@ static void wl1271_rx_streaming_enable_work(struct work_struct *work)
 	if (!wl->conf.rx_streaming.interval)
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wl1271_set_rx_streaming(wl, wlvif, true);
 	if (ret < 0)
@@ -174,11 +172,9 @@ static void wl1271_rx_streaming_disable_work(struct work_struct *work)
 	if (!test_bit(WLVIF_FLAG_RX_STREAMING_STARTED, &wlvif->flags))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wl1271_set_rx_streaming(wl, wlvif, false);
 	if (ret)
@@ -223,11 +219,9 @@ static void wlcore_rc_update_work(struct work_struct *work)
 	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	if (ieee80211_vif_is_mesh(vif)) {
 		ret = wl1271_acx_set_ht_capabilities(wl, &wlvif->rc_ht_cap,
@@ -537,11 +531,9 @@ static int wlcore_irq_locked(struct wl1271 *wl)
 	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	while (!done && loopcount--) {
 		smp_mb__after_atomic();
@@ -838,11 +830,9 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 	 * Do not send a stop fwlog command if the fw is hanged or if
 	 * dbgpins are used (due to some fw bug).
 	 */
-	error = pm_runtime_get_sync(wl->dev);
-	if (error < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	error = pm_runtime_resume_and_get(wl->dev);
+	if (error < 0)
 		return;
-	}
 	if (!wl->watchdog_recovery &&
 	    wl->conf.fwlog.output != WL12XX_FWLOG_OUTPUT_DBG_PINS)
 		wl12xx_cmd_stop_fwlog(wl);
@@ -937,11 +927,9 @@ static void wl1271_recovery_work(struct work_struct *work)
 	if (wl->state == WLCORE_STATE_OFF || wl->plt)
 		goto out_unlock;
 
-	error = pm_runtime_get_sync(wl->dev);
-	if (error < 0) {
+	error = pm_runtime_resume_and_get(wl->dev);
+	if (error < 0)
 		wl1271_warning("Enable for recovery failed");
-		pm_runtime_put_noidle(wl->dev);
-	}
 	wlcore_disable_interrupts_nosync(wl);
 
 	if (!test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags)) {
@@ -1741,9 +1729,8 @@ static int __maybe_unused wl1271_op_suspend(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	ret = pm_runtime_get_sync(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
 	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
 		mutex_unlock(&wl->mutex);
 		return ret;
 	}
@@ -1855,11 +1842,9 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 		goto out_sleep;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	wl12xx_for_each_wlvif(wl, wlvif) {
 		if (wlcore_is_p2p_mgmt(wlvif))
@@ -2060,11 +2045,9 @@ static void wlcore_channel_switch_work(struct work_struct *work)
 	vif = wl12xx_wlvif_to_vif(wlvif);
 	ieee80211_chswitch_done(vif, false);
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	wl12xx_cmd_stop_channel_switch(wl, wlvif);
 
@@ -2131,11 +2114,9 @@ static void wlcore_pending_auth_complete_work(struct work_struct *work)
 	if (!time_after(time_spare, wlvif->pending_auth_reply_time))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	/* cancel the ROC if active */
 	wlcore_update_inconn_sta(wl, wlvif, NULL, false);
@@ -2591,11 +2572,9 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	 * Call runtime PM only after possible wl12xx_init_fw() above
 	 * is done. Otherwise we do not have interrupts enabled.
 	 */
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out_unlock;
-	}
 
 	if (wl12xx_need_fw_change(wl, vif_count, true)) {
 		wl12xx_force_active_psm(wl);
@@ -2691,11 +2670,9 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 
 	if (!test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags)) {
 		/* disable active roles */
-		ret = pm_runtime_get_sync(wl->dev);
-		if (ret < 0) {
-			pm_runtime_put_noidle(wl->dev);
+		ret = pm_runtime_resume_and_get(wl->dev);
+		if (ret < 0)
 			goto deinit;
-		}
 
 		if (wlvif->bss_type == BSS_TYPE_STA_BSS ||
 		    wlvif->bss_type == BSS_TYPE_IBSS) {
@@ -3129,11 +3106,9 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	/* configure each interface */
 	wl12xx_for_each_wlvif(wl, wlvif) {
@@ -3213,11 +3188,9 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	wl12xx_for_each_wlvif(wl, wlvif) {
 		if (wlcore_is_p2p_mgmt(wlvif))
@@ -3470,11 +3443,9 @@ static int wlcore_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		goto out_wake_queues;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out_wake_queues;
-	}
 
 	ret = wlcore_hw_set_key(wl, cmd, vif, sta, key_conf);
 
@@ -3622,11 +3593,9 @@ static void wl1271_op_set_default_key_idx(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out_unlock;
-	}
 
 	wlvif->default_key = key_idx;
 
@@ -3659,11 +3628,9 @@ void wlcore_regdomain_config(struct wl1271 *wl)
 	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_autosuspend(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wlcore_cmd_regdomain_config_locked(wl);
 	if (ret < 0) {
@@ -3706,11 +3673,9 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	/* fail if there is any role in ROC */
 	if (find_first_bit(wl->roc_map, WL12XX_MAX_ROLES) < WL12XX_MAX_ROLES) {
@@ -3749,11 +3714,9 @@ static void wl1271_op_cancel_hw_scan(struct ieee80211_hw *hw,
 	if (wl->scan.state == WL1271_SCAN_STATE_IDLE)
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	if (wl->scan.state != WL1271_SCAN_STATE_DONE) {
 		ret = wl->ops->scan_stop(wl, wlvif);
@@ -3800,11 +3763,9 @@ static int wl1271_op_sched_scan_start(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wl->ops->sched_scan_start(wl, wlvif, req, ies);
 	if (ret < 0)
@@ -3834,11 +3795,9 @@ static int wl1271_op_sched_scan_stop(struct ieee80211_hw *hw,
 	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	wl->ops->sched_scan_stop(wl, wlvif);
 
@@ -3862,11 +3821,9 @@ static int wl1271_op_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 		goto out;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wl1271_acx_frag_threshold(wl, value);
 	if (ret < 0)
@@ -3894,11 +3851,9 @@ static int wl1271_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 		goto out;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	wl12xx_for_each_wlvif(wl, wlvif) {
 		ret = wl1271_acx_rts_threshold(wl, wlvif, value);
@@ -4653,11 +4608,9 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (unlikely(!test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags)))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	if ((changed & BSS_CHANGED_TXPOWER) &&
 	    bss_conf->txpower != wlvif->power_level) {
@@ -4714,11 +4667,9 @@ static void wlcore_op_change_chanctx(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	wl12xx_for_each_wlvif(wl, wlvif) {
 		struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
@@ -4771,11 +4722,9 @@ static int wlcore_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 	if (unlikely(!test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags)))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	wlvif->band = ctx->def.chan->band;
 	wlvif->channel = channel;
@@ -4823,11 +4772,9 @@ static void wlcore_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	if (unlikely(!test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags)))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	if (wlvif->radar_enabled) {
 		wl1271_debug(DEBUG_MAC80211, "Stop radar detection");
@@ -4893,11 +4840,9 @@ wlcore_op_switch_vif_chanctx(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	for (i = 0; i < n_vifs; i++) {
 		struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vifs[i].vif);
@@ -4939,11 +4884,9 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw,
 	if (!test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	/*
 	 * the txop is confed in units of 32us by the mac80211,
@@ -4987,11 +4930,9 @@ static u64 wl1271_op_get_tsf(struct ieee80211_hw *hw,
 	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wl12xx_acx_tsf_info(wl, wlvif, &mactime);
 	if (ret < 0)
@@ -5305,11 +5246,9 @@ static int wl12xx_op_sta_state(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wl12xx_update_sta_state(wl, wlvif, sta, old_state, new_state);
 
@@ -5363,11 +5302,9 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 
 	ba_bitmap = &wl->links[hlid].ba_bitmap;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 ampdu: Rx tid %d action %d",
 		     tid, action);
@@ -5475,11 +5412,9 @@ static int wl12xx_set_bitrate_mask(struct ieee80211_hw *hw,
 	if (wlvif->bss_type == BSS_TYPE_STA_BSS &&
 	    !test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) {
 
-		ret = pm_runtime_get_sync(wl->dev);
-		if (ret < 0) {
-			pm_runtime_put_noidle(wl->dev);
+		ret = pm_runtime_resume_and_get(wl->dev);
+		if (ret < 0)
 			goto out;
-		}
 
 		wl1271_set_band_rate(wl, wlvif);
 		wlvif->basic_rate =
@@ -5517,11 +5452,9 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	/* TODO: change mac80211 to pass vif as param */
 
@@ -5611,11 +5544,9 @@ static void wlcore_op_channel_switch_beacon(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wl->ops->channel_switch(wl, wlvif, &ch_switch);
 	if (ret)
@@ -5666,11 +5597,9 @@ static int wlcore_op_remain_on_channel(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wl12xx_start_dev(wl, wlvif, chan->band, channel);
 	if (ret < 0)
@@ -5723,11 +5652,9 @@ static int wlcore_roc_completed(struct wl1271 *wl)
 		goto out;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = __wlcore_roc_completed(wl);
 
@@ -5808,11 +5735,9 @@ static void wlcore_op_sta_statistics(struct ieee80211_hw *hw,
 	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out_sleep;
-	}
 
 	ret = wlcore_acx_average_rssi(wl, wlvif, &rssi_dbm);
 	if (ret < 0)
-- 
2.25.1

