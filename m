Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C14927F0B3
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 19:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731106AbgI3Rs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 13:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgI3Rs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 13:48:59 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4DFC0613D0
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 10:48:59 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n14so1670153pff.6
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 10:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/YTvNtrLxFHo4qW2QcfkLf5fd9lIOH+F5JK98NHFCBM=;
        b=o+F4v1doreRvqKhE5HUdsdAmy2eUVx6rCW0hdtttV1UabiIteoXct7Gg5AGjo/2abg
         RbUBeBN41VO9e9T0Bn/a25G968hE+x7FU74GFCOF3Y5GNQXGwrZVXpFqvTat9HkWap3h
         4O8j3VOy+fSiYAANTck66BYMlneB9Q7h1fkST3PqPbnthvYHqeQPPredBYvLhfHDKJgA
         onCKje4bN16d0Gd1jS/MiDZAEB15Gl/k1yaoLsBb0irXz14b/FJWXUzu9Pv7GwhL0KQZ
         /9d2BoIa5LDj0h80QzlTthZ7Dpm+pszbfw7SWbZJ6AyKErEXcQ6QTUV38MSv/pYyNLRQ
         MMmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/YTvNtrLxFHo4qW2QcfkLf5fd9lIOH+F5JK98NHFCBM=;
        b=YcFLafGtx01vnbYTeFO5vf3MzZJ4qx0GuJ46GxFm1Qa6uuKuB4/9WRLlcS1vhJK12g
         AS2xJYMSNQ8YhhYK8VYC4u+9VUsrPCiamlj8OriDlf7I6v8XcGSEUezW2TGbeP2kvssS
         dn/AGBp1EBmICIz1tk6PA7MWgmFiuqhV3UjmbeRKqpWdjA6B2RCG8WphGbFiTRxV9C7o
         HCnuO+iAvvRd14MOKwYSXp5VXJ9UG0rnjjl/sEyKEVTAgL109Plpx2t0PsWU++zNBu5U
         2GA8wBIv5dJ4/v+w+sKvCVSj4Z/VrLOwGt/FIo9R+xavK06O8Bl5uz55oE7fLfUih1/q
         Jxwg==
X-Gm-Message-State: AOAM532wldSWjowLNn8h9M9Kz9+TQH1EjjwGdulaeLlq18MTSL9tVuU8
        z74NEVWcRdGnyNXh7jwOZOcq/fQe+ZGAAQ==
X-Google-Smtp-Source: ABdhPJzXXYc1dAI07GHd6yMcF8teJysGXp6XlytTyouCEzkz6iPDPCjFejh0otslgsWqQKgJzEYDGQ==
X-Received: by 2002:a63:fd03:: with SMTP id d3mr2916986pgh.201.1601488138632;
        Wed, 30 Sep 2020 10:48:58 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id l13sm2993974pgq.33.2020.09.30.10.48.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Sep 2020 10:48:58 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 1/2] ionic: stop watchdog timer earlier on remove
Date:   Wed, 30 Sep 2020 10:48:27 -0700
Message-Id: <20200930174828.39657-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930174828.39657-1-snelson@pensando.io>
References: <20200930174828.39657-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to be better at making sure we don't have a link check
watchdog go off while we're shutting things down, so let's stop
the timer as soon as we start the remove.

Meanwhile, since that was the only thing in
ionic_dev_teardown(), simplify and remove that function.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 5 +++--
 drivers/net/ethernet/pensando/ionic/ionic_dev.c     | 5 -----
 drivers/net/ethernet/pensando/ionic/ionic_dev.h     | 1 -
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index d1d6fb6669e5..2749ce009ebc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -350,7 +350,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_reset:
 	ionic_reset(ionic);
 err_out_teardown:
-	ionic_dev_teardown(ionic);
+	del_timer_sync(&ionic->watchdog_timer);
 	pci_clear_master(pdev);
 	/* Don't fail the probe for these errors, keep
 	 * the hw interface around for inspection
@@ -378,6 +378,8 @@ static void ionic_remove(struct pci_dev *pdev)
 	if (!ionic)
 		return;
 
+	del_timer_sync(&ionic->watchdog_timer);
+
 	if (ionic->lif) {
 		ionic_devlink_unregister(ionic);
 		ionic_lif_unregister(ionic->lif);
@@ -389,7 +391,6 @@ static void ionic_remove(struct pci_dev *pdev)
 
 	ionic_port_reset(ionic);
 	ionic_reset(ionic);
-	ionic_dev_teardown(ionic);
 	pci_clear_master(pdev);
 	ionic_unmap_bars(ionic);
 	pci_release_regions(pdev);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index a02f710200da..16b6b65e8319 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -98,11 +98,6 @@ int ionic_dev_setup(struct ionic *ionic)
 	return 0;
 }
 
-void ionic_dev_teardown(struct ionic *ionic)
-{
-	del_timer_sync(&ionic->watchdog_timer);
-}
-
 /* Devcmd Interface */
 int ionic_heartbeat_check(struct ionic *ionic)
 {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 8842dc4a716f..c109cd5a0471 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -283,7 +283,6 @@ static inline bool ionic_q_has_space(struct ionic_queue *q, unsigned int want)
 
 void ionic_init_devinfo(struct ionic *ionic);
 int ionic_dev_setup(struct ionic *ionic);
-void ionic_dev_teardown(struct ionic *ionic);
 
 void ionic_dev_cmd_go(struct ionic_dev *idev, union ionic_dev_cmd *cmd);
 u8 ionic_dev_cmd_status(struct ionic_dev *idev);
-- 
2.17.1

