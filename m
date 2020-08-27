Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53277254C9A
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 20:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgH0SIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 14:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgH0SIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 14:08:04 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2D6C061235
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:08:03 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d22so4123954pfn.5
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qAaQMAIbCsC1QieNjhv1BdtPe5IPhgS0CnX7GcAK8X4=;
        b=Hnu+RfVLXILr7LOr36hm01gAbvKRMDplQOdd1plpIywhp2vaCPtTuVjeLC0pqWcZNY
         fGBKmn7P7qiWM6Qn3YEMSork75njVEcU0vp5EX7hBr1W9BXf6ylaqX/gJv0HDFcXHIeR
         AkkGU7JD6/a/N0d3np2p5wu7wQhF8lOTR57b5KLXF+og5ZXA18uPr9H4NuaaAGWSyaD5
         KgPudBTa1ckeY6X/Ef0N4EVKzYENBlb7VnBRrMYy8foSvJPFqhhmnEmm+Ni7MiHXjWvw
         YXkyGHteeI40MTVRPOrb3uDu2Z2W8Ff69wz7XFQQC8CyC2BQ8PAQeruaZndXFxTtOyKF
         0J7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qAaQMAIbCsC1QieNjhv1BdtPe5IPhgS0CnX7GcAK8X4=;
        b=ckidEiPmQh0fo1hrER1NDOcVPbJ6B3gJzO3902BGhNXAIgadP4Ni5sAe2QUzbt3nHD
         XabemiYiBlgDmguMiwK85Q+LP83+Ji4oBY7JZKOUdl8hy3lKBUUpVr+UyF5l6B5mdI8M
         T+ynMSfPWAtTDnqOV+ZecZjOncT9XSTUP1Ic/c/XfSAwcp3hBCT6VIN4KFHscz+4H47F
         VzQeo9qPyJ8zI/TbC5Ca2kxvToLVquDFwDBqmbvpgLxyp31U+SKQuYeG0wsR0nNbfeyo
         gqw/rh3LUdrakrRg3fI9u77sBw+Fvhoi/yP8+KAhIfK3jJQa1idy4hqa7Qj6JJVcAvxJ
         I0Lw==
X-Gm-Message-State: AOAM532x5tv4vOZgMQGR3gpnRlCzSOvlrj97j9FaPnPJTi4unFIgkuIL
        kFNo9efxNjJqMSjczCup4ZXUYRySZvDVcw==
X-Google-Smtp-Source: ABdhPJxwaTy6dHg8yw4gmAop6sVuK5pJ4HwepOBmX7ZDQYXjjQppNBchDYc6Md+pUB2ygV+Dsna9aA==
X-Received: by 2002:a63:6705:: with SMTP id b5mr9805518pgc.355.1598551683001;
        Thu, 27 Aug 2020 11:08:03 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n1sm3480249pfu.2.2020.08.27.11.08.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 11:08:01 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 12/12] ionic: pull reset_queues into tx_timeout handler
Date:   Thu, 27 Aug 2020 11:07:35 -0700
Message-Id: <20200827180735.38166-13-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827180735.38166-1-snelson@pensando.io>
References: <20200827180735.38166-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert tx_timeout handler to not do the full reset.  As this was
the last user of ionic_reset_queues(), we can drop it.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 39 ++++---------------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  1 -
 2 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 6bf7a077e66a..ea950f5c4d5b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1406,9 +1406,14 @@ static void ionic_tx_timeout_work(struct work_struct *ws)
 
 	netdev_info(lif->netdev, "Tx Timeout recovery\n");
 
-	rtnl_lock();
-	ionic_reset_queues(lif, NULL, NULL);
-	rtnl_unlock();
+	/* if we were stopped before this scheduled job was launched,
+	 * don't bother the queues as they are already stopped.
+	 */
+	if (!netif_running(lif->netdev))
+		return;
+
+	ionic_stop_queues_reconfig(lif);
+	ionic_start_queues_reconfig(lif);
 }
 
 static void ionic_tx_timeout(struct net_device *netdev, unsigned int txqueue)
@@ -2280,34 +2285,6 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	return err;
 }
 
-int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg)
-{
-	bool running;
-	int err = 0;
-
-	mutex_lock(&lif->queue_lock);
-	running = netif_running(lif->netdev);
-	if (running) {
-		netif_device_detach(lif->netdev);
-		err = ionic_stop(lif->netdev);
-		if (err)
-			goto reset_out;
-	}
-
-	if (cb)
-		cb(lif, arg);
-
-	if (running) {
-		err = ionic_open(lif->netdev);
-		netif_device_attach(lif->netdev);
-	}
-
-reset_out:
-	mutex_unlock(&lif->queue_lock);
-
-	return err;
-}
-
 int ionic_lif_alloc(struct ionic *ionic)
 {
 	struct device *dev = ionic->dev;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 1df3e1e4107b..e1e6ff1a0918 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -259,7 +259,6 @@ int ionic_lif_rss_config(struct ionic_lif *lif, u16 types,
 			 const u8 *key, const u32 *indir);
 int ionic_reconfigure_queues(struct ionic_lif *lif,
 			     struct ionic_queue_params *qparam);
-int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg);
 
 static inline void debug_stats_txq_post(struct ionic_queue *q, bool dbell)
 {
-- 
2.17.1

