Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B65BCC2921
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbfI3Vtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:49:33 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37005 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfI3Vtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:49:32 -0400
Received: by mail-pg1-f194.google.com with SMTP id c17so8117189pgg.4
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 14:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W5Qj9lAfsgwEgBLR07x0eSYyF6520KGJs7oKlKwlqiI=;
        b=ZcJCA60cV3xawJ4R8YgVnCMEDYIfEACm/PvcXEFKldZmXhKn8Mml0XU5DQ7aMgA92z
         l8Od/++8IePU0MJXh8n4iNB06FZPi2t+D5O4lyeff62Oto9c0U5wFW+vB9vM99u+7PVW
         mbnUcpm9ZWYk1uZi+BLPLPrntIwFScCtaEdPF6zCo2IYXOM9AeCH7O3f9sIUi2yqrpi6
         42xEzYJE/AVGpJyQ6NXPWIABTpxRiyHiH1Mhf1AYlR/F4neoMAeEuNhaSAsVc+kyZJUN
         2KAOj4zhdPKHVlMbyGdLQveJDaSDXOWFZ9lUw3ymNk/FQriInUTZyFe1QeFxb7VMw12h
         5X/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W5Qj9lAfsgwEgBLR07x0eSYyF6520KGJs7oKlKwlqiI=;
        b=omhmYU4E2spN4Xu22ZSEy/FAgLu99ZaPkT+hNU28GplIOXcKrDAFpM5o6SMBqi7l4F
         o99q4RJgdadrFKAMgSejgWZnKTopQTYcVf5huZHXyIUxmpUTf0wb6WnyqjqILAkuMqkB
         x39XaSja1yoKgdrwFyloDqHgXPIVEGoDqwfnMSmWctA+GzBJ/dfNqHb3rV89ljZrfjaX
         TKJUXOYkVAuT4MlZ9geDsYbEMV1pOyqZRQ6XHpGf8A11LlyNka0dQsFA0h+uKhQVarWn
         fWjXyzYuyObLFWpxVVwimNhFJJBrgQnSYEnX0HzH1a7iJxYwkiqHj6NItVmRwLVWi75s
         eywQ==
X-Gm-Message-State: APjAAAVAsPYaS3D/b1jjhll/Uam7dHDcp8t6pz1ARAHDtlK9jfigEFTx
        FVYbpBRCNPO3Cd02OhzHn3Q2QpTpsErLCQ==
X-Google-Smtp-Source: APXvYqzoNhQrloxKYlISVdLwcDUpMWEYsNky46LJ4VosHTOeKP1i/Px8vWIaoQoh7S4PYqnGLgIA3g==
X-Received: by 2002:a17:90a:fa0d:: with SMTP id cm13mr1607973pjb.70.1569880171146;
        Mon, 30 Sep 2019 14:49:31 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 30sm505746pjk.25.2019.09.30.14.49.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 14:49:30 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 2/5] ionic: use wait_on_bit_lock() rather than open code
Date:   Mon, 30 Sep 2019 14:49:17 -0700
Message-Id: <20190930214920.18764-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190930214920.18764-1-snelson@pensando.io>
References: <20190930214920.18764-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the open-coded ionic_wait_for_bit() with the
kernel's wait_on_bit_lock().

Fixes: beead698b1736 ("ionic: Add the basic NDO callbacks for netdev support")
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

