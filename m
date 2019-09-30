Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 811B3C292B
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfI3VxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:53:16 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42809 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfI3VxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:53:16 -0400
Received: by mail-pf1-f193.google.com with SMTP id q12so6344637pff.9
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 14:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AcvsrTDPI1DwGdfoflhY9yDVrDd/Kn7qYVH8mAfzKK0=;
        b=S7OdcZikjXKVqVCHV4ApmosPT9/PwNryy28jgiAD+FwTwDlUq3y6RdRUwzzyFxL4fG
         xCba4ncmzWNryloTaoV/IJhAIO3TtqV/hGJ4IakCgAzEpCq330yyjZBEgzVwPb8FUWBq
         7Y2Myqz1W2kfEWbleS1bXiioSRs8vxSJbNWI5/Ijs/RLCK927JXq/TDyZdKSJjuwo4po
         L8pYBD61ISG58xfliiN1ZhC+B9SHAjDcVz6zAGCzIOtLVfmyIRsBYEYVqfdWhK8QWqim
         4ayVaA3UyjZlYTSAITl1i7nkXfRDo/XNpbFlLQL8f0+5nwvRqksRBrQYhqWoAGG5PcvO
         bwKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AcvsrTDPI1DwGdfoflhY9yDVrDd/Kn7qYVH8mAfzKK0=;
        b=GobrBzRDI9HbLIL/JOyGqckBSlr+ZV/18+G8g4rAf1CbHo8SwKFtsbtXooQkk+t2fL
         S4URjn/03xMeGOTxEN2y1GZJIaZ0K0q4Pcp+lP394gmf0csTIf7ZbP/f+NRsc5aGHDOI
         OBKpmTz6UU12p+Nia8fGwVT0IE9Zc7aWoPtSCNYvLS5oZni6myuTLkQm/n6Hey0I979f
         20gtxfh8ngMQ/GMAx4NbMIDKtAAo84TWVLVEWuzoIR5mnZw/YVBxHLpUwsBPtbmUart2
         D9MukDLhKUxLTISQJu1eKMBkuV1fAFXz64QNUwoVtDjDHlmQayrI2ZOpOZtUoem54zXU
         Yzog==
X-Gm-Message-State: APjAAAU3Od6DgXk5CYd9iejM5aAn7ldaE3yknA/mMYfvpEM/7tARNSHP
        5E+7QgxbZHKUVo53O+WhgBhMnLxf56JenA==
X-Google-Smtp-Source: APXvYqx1M+osXxcpDquamKYeSBP+zuvyKHLfhsQyBHjPkljXu4sKFloCDH4eHuzY0yDNtHm4B1jrAg==
X-Received: by 2002:a17:90a:f487:: with SMTP id bx7mr473616pjb.83.1569866536353;
        Mon, 30 Sep 2019 11:02:16 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id u1sm153873pjn.3.2019.09.30.11.02.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 11:02:15 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/5] ionic: use wait_on_bit_lock() rather than open code
Date:   Mon, 30 Sep 2019 11:01:55 -0700
Message-Id: <20190930180158.36101-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190930180158.36101-1-snelson@pensando.io>
References: <20190930180158.36101-1-snelson@pensando.io>
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

