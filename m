Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FCD25517B
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 01:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgH0XBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 19:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbgH0XAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 19:00:53 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B8FC061233
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:52 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id g6so3376019pjl.0
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sdQtruYKH6srsNzVoS2H/+lFBOy/0Wi0kwRy7/vzXtY=;
        b=y9W440N7v0ams8GwO9X7QP/zGpsjQpVtj/9i8xYLfD6J8g7DIaBtUpIRwhUXWShsHg
         9Zz9nWwbXFrytFnuheIjLkE1BenIUi/8NthBDnCtWVAy4Sb+XDwAns+C+MSKpUMGAGqq
         DiorQ+oQu+UmEikUaSt6Y+i5huB9sRSHtVV44V9pqL4DFmm1R4a6WOOjY+o27EJr7Fvs
         tH2sbN4Ihm+Nhnu4u+tdpcpEEbZZyi1PsM1TGvypuree0e7MaWYAtEgni4d9P1MkfsiE
         /TGTCqcP4liZCs/JldfJ/rZPlor9g/p94ddVp4PhTLfpjU8PDwD7uNSLu5qUmv3NHGiB
         IqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sdQtruYKH6srsNzVoS2H/+lFBOy/0Wi0kwRy7/vzXtY=;
        b=McXnlC07NUFbGq2Me8sZQtfHmOpzxJ9TtqXf+cQ+ryGTSssKUp/f8AUtxXfB6Y2vGS
         voayE83COqaoM3BxZmmacPBwqXozsStY1T3gE8/P4edsbAUYnwnWKTScqoUDpJtYBIgS
         OyC4RseqnqH8AhMUDrZ9jf27I6Oo2RPmIxnpiIf9BsyvjRPbzKO5wt9a57Nl7LbAM4FN
         8P28gtd3IZMT6no/uwoz4a58Q9TX+7ohNMajFmMjOX1sH5RM2vMnJ8Wm1otsjTBd0Y75
         rw81H9iQST+LbWJexmm6KEiRnu0PF1KQfZ3x+cDumBaCfhZwSO0C7o0b3ev9atF/Omgn
         fYpw==
X-Gm-Message-State: AOAM532aGenpjkKdl1JtAqpel/PcdJO/rOJUi2kUoMFX2xL1gP7+/t+/
        zt5lK6Til3sGol/72ut9tqlcrmJH9l+F9g==
X-Google-Smtp-Source: ABdhPJx59qfEp1r7gs9OJY1YTYykQeZqzQ3tTyCLVH6Ggk6idLs9O4eifj4qWWzl0yU0Y1uVAf6fwQ==
X-Received: by 2002:a17:90a:e64b:: with SMTP id ep11mr971540pjb.10.1598569252169;
        Thu, 27 Aug 2020 16:00:52 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n22sm3137534pjq.25.2020.08.27.16.00.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 16:00:51 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 12/12] ionic: pull reset_queues into tx_timeout handler
Date:   Thu, 27 Aug 2020 16:00:30 -0700
Message-Id: <20200827230030.43343-13-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827230030.43343-1-snelson@pensando.io>
References: <20200827230030.43343-1-snelson@pensando.io>
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
index 4b16dbf257d9..eeaa73650986 100644
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

