Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBF3C2C34
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 05:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732483AbfJADDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 23:03:40 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45631 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732442AbfJADDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 23:03:39 -0400
Received: by mail-pg1-f196.google.com with SMTP id q7so8575852pgi.12
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 20:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AcvsrTDPI1DwGdfoflhY9yDVrDd/Kn7qYVH8mAfzKK0=;
        b=srwdu09/+MCf+GYOlfYznQebLvGooPjEviaKBXlydS6eabMH+R1739vEMT0bJtHOzZ
         xX+wjlAPkPNq17N53jTqUuP+2TbOEf9fsbbTbFy/ZeZZ+0wi2FxP3XZlPWWPLQlDqrv/
         HDNLn8Bum6OYleXQMO3UXWF7RtleXdVnZBVFvKwYqxQXNZC2QGS7JVsn6LMr1/e7QcMn
         xMZrElXc+TL+3mTgnt5HlO+YqjNdHb8oFjeBWeeFTjoVuVeKryVFR6lZ1Xo4rR04Mv7C
         eo+/w91u5z0GwEEZBkD2SIlDOMozgB1V+z36vdUNlr78VoaDO07FY/reBZ2LUmMn6WMN
         qagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AcvsrTDPI1DwGdfoflhY9yDVrDd/Kn7qYVH8mAfzKK0=;
        b=XNBIbuzvVvwZ2RZDCk8NMlSS5FsvLSC5bXcP6fHUMSwVFlDqrP+gumy0hq96YCaYov
         f/k00q5OlNRmx9dHTyxc1CkoXwS9xTnz2BvzBy+ADanVzN/N3rWUJzL/VjeZVVBr3LvM
         0XwogjfL1d2UL7QZPXwMXy+VYXMUxUEErbM3QNPToSiknO5cwtXVpeD6bpkHbhHx9php
         KnduGMBM65pT55QfNnP4hNE5jfRARbUVeczgI4ojlaAVKlPGhCmcJMW61wxwWa1mN5Wy
         SBTNTZBSD3sL0h5KjauzlLaV9IYRkih2U9oKtUIBCUqm8+MAjEUcTsKkdew1zR2DFCCb
         U82g==
X-Gm-Message-State: APjAAAXKzAsLuvIV5doqPWkslVLOa/kkdtRE+3Oi9/djrIoYw/uQL3Rw
        hbkwpnf/yia0nE/G704Eanl3mvNfL3CaSA==
X-Google-Smtp-Source: APXvYqwGWID5a/i+oNadjrov7+w0PPYoItBi+r5qwdz0S5LiR+orgCNRUdtEDRdAahIQ97/Ur7Gqgg==
X-Received: by 2002:a62:4dc5:: with SMTP id a188mr272078pfb.250.1569899017390;
        Mon, 30 Sep 2019 20:03:37 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id y17sm14831062pfo.171.2019.09.30.20.03.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 20:03:36 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 2/5] ionic: use wait_on_bit_lock() rather than open code
Date:   Mon, 30 Sep 2019 20:03:23 -0700
Message-Id: <20191001030326.29623-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191001030326.29623-1-snelson@pensando.io>
References: <20191001030326.29623-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the open-coded ionic_wait_for_bit() with the
kernel's wait_on_bit_lock().

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 12 ++++++++----
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     |  5 +++--
 drivers/net/ethernet/pensando/ionic/ionic_lif.h     |  9 ++-------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 7d10265f782a..7760fcd709b4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -453,6 +453,7 @@ static int ionic_set_ringparam(struct net_device *netdev,
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	bool running;
+	int err;
 
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending) {
 		netdev_info(netdev, "Changing jumbo or mini descriptors not supported\n");
@@ -470,8 +471,9 @@ static int ionic_set_ringparam(struct net_device *netdev,
 	    ring->rx_pending == lif->nrxq_descs)
 		return 0;
 
-	if (!ionic_wait_for_bit(lif, IONIC_LIF_QUEUE_RESET))
-		return -EBUSY;
+	err = ionic_wait_for_bit(lif, IONIC_LIF_QUEUE_RESET);
+	if (err)
+		return err;
 
 	running = test_bit(IONIC_LIF_UP, lif->state);
 	if (running)
@@ -504,6 +506,7 @@ static int ionic_set_channels(struct net_device *netdev,
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	bool running;
+	int err;
 
 	if (!ch->combined_count || ch->other_count ||
 	    ch->rx_count || ch->tx_count)
@@ -512,8 +515,9 @@ static int ionic_set_channels(struct net_device *netdev,
 	if (ch->combined_count == lif->nxqs)
 		return 0;
 
-	if (!ionic_wait_for_bit(lif, IONIC_LIF_QUEUE_RESET))
-		return -EBUSY;
+	err = ionic_wait_for_bit(lif, IONIC_LIF_QUEUE_RESET);
+	if (err)
+		return err;
 
 	running = test_bit(IONIC_LIF_UP, lif->state);
 	if (running)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 72107a0627a9..4d5883a7e586 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1619,8 +1619,9 @@ int ionic_reset_queues(struct ionic_lif *lif)
 	/* Put off the next watchdog timeout */
 	netif_trans_update(lif->netdev);
 
-	if (!ionic_wait_for_bit(lif, IONIC_LIF_QUEUE_RESET))
-		return -EBUSY;
+	err = ionic_wait_for_bit(lif, IONIC_LIF_QUEUE_RESET);
+	if (err)
+		return err;
 
 	running = netif_running(lif->netdev);
 	if (running)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 812190e729c2..b74f7e9ee82d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -185,15 +185,10 @@ struct ionic_lif {
 #define lif_to_txq(lif, i)	(&lif_to_txqcq((lif), i)->q)
 #define lif_to_rxq(lif, i)	(&lif_to_txqcq((lif), i)->q)
 
+/* return 0 if successfully set the bit, else non-zero */
 static inline int ionic_wait_for_bit(struct ionic_lif *lif, int bitname)
 {
-	unsigned long tlimit = jiffies + HZ;
-
-	while (test_and_set_bit(bitname, lif->state) &&
-	       time_before(jiffies, tlimit))
-		usleep_range(100, 200);
-
-	return test_bit(bitname, lif->state);
+	return wait_on_bit_lock(lif->state, bitname, TASK_INTERRUPTIBLE);
 }
 
 static inline u32 ionic_coal_usec_to_hw(struct ionic *ionic, u32 usecs)
-- 
2.17.1

