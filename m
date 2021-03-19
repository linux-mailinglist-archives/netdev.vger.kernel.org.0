Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BBB34119F
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 01:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhCSAt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 20:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbhCSAsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 20:48:54 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA627C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:54 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ga23-20020a17090b0397b02900c0b81bbcd4so5903803pjb.0
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vlDkzhG208rz3UoSz9hxhQbEQocMwtSUkUwBtKeX6uU=;
        b=fBxDzSSrv+eYz2aScysiMmG/AeZNFXvqdUXYXCyK+lT/KOHQSIffzyBkMdxTj/qZ0m
         zxTFjitZ2WVURq2Mg5Q6/sY8zR6x49L31ih/RRPZcDnA5q8ZXEojmxVU0l8UZmX9vGo8
         WvgyApPLEK/UkuLyNlouRH2qA6f854hH+jR1gL0jtrY0kiJO+hD736FREq7/AgVAF8/F
         g4UkRUom0VC6bMBiXdhTPvGPVM390R4k3UuaBms0lGuq+kTSFmUvAQ5V2qg6ff7J1/qo
         EMnxO8NpfW/vUNzU3GtNHRwa3vyWx9htqzdOv+zYRhmsNZUCGBtCmNuGWRccm7Dz8ze+
         P/Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vlDkzhG208rz3UoSz9hxhQbEQocMwtSUkUwBtKeX6uU=;
        b=ti6dq9/Y3Mq5lSbfWChxLVPmv+apHjiQo9w+yf6eXi3hPTRRISrvPej7L6Kk/Ae7Jc
         PdoMI5Lhj6EA041MNLjtj68F04MxsOvxhAXKXxNCfxZcm0SaXBgXVdXAhbDi5uDkmDbX
         9TqJAiTYkfxIeocwg5rWeqae7+3uz5hjct+VzZ1+wiA89k3+d1EtFHZYrFB9UJr+4FKw
         8QIgm+BcskAGQcuYmCXQzxvQEF74EYv9RHCVDW4fl/dY+0UgTdvuomgx2gXKaEztIiW/
         Po1ifKX7ni7VIh5BBiebPghwPKlPgepT8MxLHZWfoK2W1eDtKAxJdmN8y42xt2Nxsazl
         UJfA==
X-Gm-Message-State: AOAM532iGZ9f+51AJunxMvNvJY02y/I6qG5ZDep4OKw+cm+yWWgOfWqq
        4eT9Q7UGIJRZuhKW5qlwZ04aClkTu6nRcw==
X-Google-Smtp-Source: ABdhPJylhqm3xVfwurqCaSX/+Gg/OmItHwnFUZOAMj98R+lcwLFgYFNkzcn7duGY2OJ/GZjoCnGpoA==
X-Received: by 2002:a17:902:d706:b029:e6:90aa:24e0 with SMTP id w6-20020a170902d706b02900e690aa24e0mr12367697ply.42.1616114933970;
        Thu, 18 Mar 2021 17:48:53 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i7sm3592949pfq.184.2021.03.18.17.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 17:48:53 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/7] ionic: block actions during fw reset
Date:   Thu, 18 Mar 2021 17:48:08 -0700
Message-Id: <20210319004810.4825-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210319004810.4825-1-snelson@pensando.io>
References: <20210319004810.4825-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Block some actions while the FW is in a reset activity
and the queues are not configured.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 4 ++++
 drivers/net/ethernet/pensando/ionic/ionic_dev.c     | 8 +++++---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     | 7 ++++++-
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index b0d8499d373b..e4a5416adc80 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -184,6 +184,10 @@ static int ionic_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	struct device *dev = ionic->dev;
 	int ret = 0;
 
+	if (ionic->lif &&
+	    test_bit(IONIC_LIF_F_FW_RESET, ionic->lif->state))
+		return -EBUSY;
+
 	if (num_vfs > 0) {
 		ret = pci_enable_sriov(pdev, num_vfs);
 		if (ret) {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index b951bf5bbdc4..0532f7cf086d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -14,18 +14,20 @@
 static void ionic_watchdog_cb(struct timer_list *t)
 {
 	struct ionic *ionic = from_timer(ionic, t, watchdog_timer);
+	struct ionic_lif *lif = ionic->lif;
 	int hb;
 
 	mod_timer(&ionic->watchdog_timer,
 		  round_jiffies(jiffies + ionic->watchdog_period));
 
-	if (!ionic->lif)
+	if (!lif)
 		return;
 
 	hb = ionic_heartbeat_check(ionic);
 
-	if (hb >= 0)
-		ionic_link_status_check_request(ionic->lif, CAN_NOT_SLEEP);
+	if (hb >= 0 &&
+	    !test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		ionic_link_status_check_request(lif, CAN_NOT_SLEEP);
 }
 
 void ionic_init_devinfo(struct ionic *ionic)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 18fcba4fc413..4f4ca183830b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1477,7 +1477,8 @@ static void ionic_tx_timeout_work(struct work_struct *ws)
 {
 	struct ionic_lif *lif = container_of(ws, struct ionic_lif, tx_timeout_work);
 
-	netdev_info(lif->netdev, "Tx Timeout recovery\n");
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return;
 
 	/* if we were stopped before this scheduled job was launched,
 	 * don't bother the queues as they are already stopped.
@@ -1493,6 +1494,7 @@ static void ionic_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 
+	netdev_info(lif->netdev, "Tx Timeout triggered - txq %d\n", txqueue);
 	schedule_work(&lif->tx_timeout_work);
 }
 
@@ -1834,6 +1836,9 @@ static int ionic_start_queues(struct ionic_lif *lif)
 {
 	int err;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	if (test_and_set_bit(IONIC_LIF_F_UP, lif->state))
 		return 0;
 
-- 
2.17.1

