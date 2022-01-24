Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089CE4989B9
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344115AbiAXS56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344527AbiAXSyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:46 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECE0C061793
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:33 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id nn16-20020a17090b38d000b001b56b2bce31so42962pjb.3
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5U7DgCFcnZ1n8kyHk3IMbj1iF8HAhpo6uzE8G34cl6I=;
        b=HGB/tpmnLMo6WYX0+jx8qWxgddAnGeYxmLGAH0gCU1aRZyvpkh/P9GnrdWvTYW3uAh
         N/jzvtiOEmjG/XJXAVwd6zXB6/pbWrY4ndHOFpL9mmm65T3TtKTmyFmqVmESleezsCSp
         9X8v+LibGAyHEBesb0bld5Eb3iuZoNva17tRjZiV6O595WIAfk7msCNECi17p7BIQHSV
         XSnmRKd9ccF/DUvL3MeaNkiirPSt6b5uujRGRPGTf7mLv7VX4SEZU6SkpDopupBGbMAL
         u/o9/eWy80Jh5esJfQdl1CTzQq6vENv73QE9ldO2bZqwq9YHV6Nstu2aMZrjLJJj/v7N
         aDiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5U7DgCFcnZ1n8kyHk3IMbj1iF8HAhpo6uzE8G34cl6I=;
        b=s3gA320+61472S4Bh4fqUdH0QfNUmsI9WJO2Aqla5Hm3NlQfsIHT+KPNeQ6Dv6Zj06
         X0NOqiATGH1AlC4zwFRuczFJtgAvbPiCnBJX43mwinGX5MBmrp/SvjZxG2kHN5lQtFtM
         YDlaiuOTqP56XWugN0ZsCMwOt/VCA7Q8whuRCHUTHpEA0RicjNaF8Ny4Biv3tOvuJehv
         6yjoMPkgh+fcOMOTCHfZ9Czs18lo3Nv3nMrFFYlwVGDMQ4aR3WaJo10kK0vGcHuklTbk
         1N3+oGtO+su2o0E8o7ZWc/ajRmAfdSzvs6MSXmStP2i4JBaoeqbQKxwBH3pq9hVV6Hly
         cJ1A==
X-Gm-Message-State: AOAM531bv1/yyP14sD+uoF1g1qpzb9tO6dQdmprfnGWn9GLsbBoioiZF
        JNHGh7fWDfKOZ64Zq3rURdeLag==
X-Google-Smtp-Source: ABdhPJzx3xviAclqPvxGBBt7pLTeHmaRenxbAOeRz/nMx0g/TKSVMO7t8q4Hmtwve/f+5IB76jDfaA==
X-Received: by 2002:a17:902:6b06:b0:14b:f88:5f9b with SMTP id o6-20020a1709026b0600b0014b0f885f9bmr15377136plk.169.1643050413063;
        Mon, 24 Jan 2022 10:53:33 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:32 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 06/16] ionic: better handling of RESET event
Date:   Mon, 24 Jan 2022 10:53:02 -0800
Message-Id: <20220124185312.72646-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When IONIC_EVENT_RESET is received, we only need to start the
fw_down process if we aren't already down, and we need to be
sure to set the FW_STOPPING state on the way.

If this is how we noticed that FW was stopped, it is most
likely from a FW update, and we'll see a new FW generation.
The update happens quickly enough that we might not see
fw_status==0, so we need to be sure things get restarted when
we see the fw_generation change.

Fixes: d2662072c094 ("ionic: monitor fw status generation")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c | 17 +++++++++++++----
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 17 +++++++++++------
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 8edbd7c30ccc..35581cabbae3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -33,7 +33,8 @@ static void ionic_watchdog_cb(struct timer_list *t)
 	    !test_bit(IONIC_LIF_F_FW_RESET, lif->state))
 		ionic_link_status_check_request(lif, CAN_NOT_SLEEP);
 
-	if (test_bit(IONIC_LIF_F_FILTER_SYNC_NEEDED, lif->state)) {
+	if (test_bit(IONIC_LIF_F_FILTER_SYNC_NEEDED, lif->state) &&
+	    !test_bit(IONIC_LIF_F_FW_RESET, lif->state)) {
 		work = kzalloc(sizeof(*work), GFP_ATOMIC);
 		if (!work) {
 			netdev_err(lif->netdev, "rxmode change dropped\n");
@@ -148,8 +149,9 @@ bool ionic_is_fw_running(struct ionic_dev *idev)
 
 int ionic_heartbeat_check(struct ionic *ionic)
 {
-	struct ionic_dev *idev = &ionic->idev;
 	unsigned long check_time, last_check_time;
+	struct ionic_dev *idev = &ionic->idev;
+	struct ionic_lif *lif = ionic->lif;
 	bool fw_status_ready = true;
 	bool fw_hb_ready;
 	u8 fw_generation;
@@ -187,14 +189,21 @@ int ionic_heartbeat_check(struct ionic *ionic)
 			 * the down, the next watchdog will see the fw is up
 			 * and the generation value stable, so will trigger
 			 * the fw-up activity.
+			 *
+			 * If we had already moved to FW_RESET from a RESET event,
+			 * it is possible that we never saw the fw_status go to 0,
+			 * so we fake the current idev->fw_status_ready here to
+			 * force the transition and get FW up again.
 			 */
-			fw_status_ready = false;
+			if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+				idev->fw_status_ready = false;	/* go to running */
+			else
+				fw_status_ready = false;	/* go to down */
 		}
 	}
 
 	/* is this a transition? */
 	if (fw_status_ready != idev->fw_status_ready) {
-		struct ionic_lif *lif = ionic->lif;
 		bool trigger = false;
 
 		if (!fw_status_ready && lif &&
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 08c8589e875a..13c00466023f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1112,12 +1112,17 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
 		ionic_link_status_check_request(lif, CAN_NOT_SLEEP);
 		break;
 	case IONIC_EVENT_RESET:
-		work = kzalloc(sizeof(*work), GFP_ATOMIC);
-		if (!work) {
-			netdev_err(lif->netdev, "Reset event dropped\n");
-		} else {
-			work->type = IONIC_DW_TYPE_LIF_RESET;
-			ionic_lif_deferred_enqueue(&lif->deferred, work);
+		if (lif->ionic->idev.fw_status_ready &&
+		    !test_bit(IONIC_LIF_F_FW_RESET, lif->state) &&
+		    !test_and_set_bit(IONIC_LIF_F_FW_STOPPING, lif->state)) {
+			work = kzalloc(sizeof(*work), GFP_ATOMIC);
+			if (!work) {
+				netdev_err(lif->netdev, "Reset event dropped\n");
+				clear_bit(IONIC_LIF_F_FW_STOPPING, lif->state);
+			} else {
+				work->type = IONIC_DW_TYPE_LIF_RESET;
+				ionic_lif_deferred_enqueue(&lif->deferred, work);
+			}
 		}
 		break;
 	default:
-- 
2.17.1

