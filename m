Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C22C2183BBF
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 22:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgCLVuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 17:50:40 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37127 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgCLVui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 17:50:38 -0400
Received: by mail-pf1-f194.google.com with SMTP id p14so3933735pfn.4
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 14:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=F4hJajqYk2h/ybnEeY37tlfjCnLIdXw943v3m0uq7rQ=;
        b=wgNziDYZI2VajRxkcx0fdNxOvbIavzhuFOW4dDd8ctpOy0DNB8973nodmxifOKyGMd
         rff08RH8YMdLvkpru8ZoT6mtmBLKVXAkv3F/WfQU/QRiaZFRBISV4N6jOcNqb7GxuhRA
         NCfdDxKhyBI0cCvX94x/LhQ3KEnA2En7kjQFgi15iJyOH2BBLu4F+Ie5Kbl3qCO/USLH
         dIja2590LWvAYpWe6jI7bsDnDTjvlRhKj/Lc/LuO8yRWRf5ZxE379w2oTT5RasBj74Th
         1Jz3RnKRYvY5a6qZioGIU5ztcU6alE4Ni4cLO6CXxjqJ1B6tNvPdKG7j3wK+BP/ofYux
         +9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=F4hJajqYk2h/ybnEeY37tlfjCnLIdXw943v3m0uq7rQ=;
        b=GqaaA0FoLC4oUlQe1AGWxHFzgdo/mmgkSlcyFmXD687K2HctXsFGGg+Ytn8N4sJFfj
         cetxVVAclmjLvW+lxRiBdLoOXu8Kj1q1wUUgK3uzHAWBnP2L1vt6UyYbvpFsEHI9VpzW
         aRqWNXFbNFZh0cE+lN2Ps7tfWAwEU8Izd9cdiVzM24aFoWV8H5c61CiYfULehH8RzKNT
         e2wmkY9TvmdF6jMUXesLlyBOE+L5th2+M14PRpAjQ0YFCdvwf6PEIKR3rnhAx+wYEYe4
         p+FmQZrFLON9r947hK9NjR0TD9MBRwdZZVLOVNdX5PKqLFOa78Om60c8mKTCAghQhqyi
         jNBQ==
X-Gm-Message-State: ANhLgQ1KjwkgcLc1YkJicLYfSYyZdesFG8Hg2jpnvmRKdxG2+XqO+wiX
        +QwL0EzyUM3SEqOcFTpEw/JDD3VCzME=
X-Google-Smtp-Source: ADFU+vtOwVKGFt09RH4By17ND80Pgz558E1hmVvPlaL5XbyD9nf9wI11EomEffF08w/r2juE1x6cMQ==
X-Received: by 2002:aa7:9850:: with SMTP id n16mr10150663pfq.256.1584049835912;
        Thu, 12 Mar 2020 14:50:35 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p2sm38281203pfb.41.2020.03.12.14.50.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Mar 2020 14:50:35 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 7/7] ionic: check for link when link down
Date:   Thu, 12 Mar 2020 14:50:15 -0700
Message-Id: <20200312215015.69547-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312215015.69547-1-snelson@pensando.io>
References: <20200312215015.69547-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the link is down, have the heartbeat watchdog also
check the link for changes in case no Event is sent.

Meanwhile, sometimes the link status check runs into itself
or the ionic_open() thread, and can either confuse itself,
throw incorrect error messages, or even miss the link message.
This patch cleans up the code and gets the right messages out
to the log file when they happen.

 - rearrange the link_up/link_down messages so that we announce
   link up when we first notice that the link is up when the
   driver loads, and decouple the link_up/link_down messages
   from the UP and DOWN netdev state.
 - add error checking of ionic_qcq_disable() so as to not have
   to wait too long on shutdown when everything it timeout out.
 - add a state to indicate transitions between netdev UP and
   DOWN so as to prevent recursion.
 - don't clean the dev_cmd when we notice that the fw has halted,
   it's possible it might still execute the request.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 10 ++-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 78 ++++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  2 +
 .../net/ethernet/pensando/ionic/ionic_main.c  |  1 -
 4 files changed, 61 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index bb513db7163c..349b63f3ab54 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -14,11 +14,19 @@
 static void ionic_watchdog_cb(struct timer_list *t)
 {
 	struct ionic *ionic = from_timer(ionic, t, watchdog_timer);
+	struct ionic_lif *lif = ionic->master_lif;
+	int hb;
 
 	mod_timer(&ionic->watchdog_timer,
 		  round_jiffies(jiffies + ionic->watchdog_period));
 
-	ionic_heartbeat_check(ionic);
+	hb = ionic_heartbeat_check(ionic);
+
+	/* check link if we're waiting for link to come back up */
+	if (hb >= 0 && lif && netif_running(lif->netdev) &&
+	    !test_bit(IONIC_LIF_F_UP, lif->state)) {
+		ionic_link_status_check_request(lif);
+	}
 }
 
 void ionic_init_devinfo(struct ionic *ionic)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 8027b72835b6..cd349187376f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -90,40 +90,44 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 	link_status = le16_to_cpu(lif->info->status.link_status);
 	link_up = link_status == IONIC_PORT_OPER_STATUS_UP;
 
-	/* filter out the no-change cases */
-	if (link_up == netif_carrier_ok(netdev))
-		goto link_out;
-
 	if (link_up) {
 		u32 link_speed;
 
-		link_speed = le16_to_cpu(lif->info->status.link_speed);
-		netdev_info(netdev, "Link up - %d Gbps\n", link_speed / 1000);
+		if (!netif_carrier_ok(netdev)) {
+			/* force an update in shared structs */
+			ionic_port_identify(lif->ionic);
+
+			link_speed = le32_to_cpu(lif->info->status.link_speed);
+			netdev_info(netdev, "Link up - %d Gbps\n",
+				    link_speed / 1000);
+			netif_carrier_on(netdev);
+		}
 
 		if (!test_bit(IONIC_LIF_F_UP, lif->state) &&
-		    netif_running(netdev)) {
+		    netif_running(netdev) &&
+		    !test_bit(IONIC_LIF_F_TRANS, lif->state)) {
 			rtnl_lock();
 			ionic_open(netdev);
 			rtnl_unlock();
 		}
-
-		netif_carrier_on(netdev);
 	} else {
-		netdev_info(netdev, "Link down\n");
-		netif_carrier_off(netdev);
+		if (netif_carrier_ok(netdev)) {
+			netdev_info(netdev, "Link down\n");
+			netif_carrier_off(netdev);
+		}
 
-		if (test_bit(IONIC_LIF_F_UP, lif->state)) {
+		if (test_bit(IONIC_LIF_F_UP, lif->state) &&
+		    !test_bit(IONIC_LIF_F_TRANS, lif->state)) {
 			rtnl_lock();
 			ionic_stop(netdev);
 			rtnl_unlock();
 		}
 	}
 
-link_out:
 	clear_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state);
 }
 
-static void ionic_link_status_check_request(struct ionic_lif *lif)
+void ionic_link_status_check_request(struct ionic_lif *lif)
 {
 	struct ionic_deferred_work *work;
 
@@ -1455,10 +1459,15 @@ static void ionic_lif_rss_deinit(struct ionic_lif *lif)
 static void ionic_txrx_disable(struct ionic_lif *lif)
 {
 	unsigned int i;
+	int err;
 
 	for (i = 0; i < lif->nxqs; i++) {
-		ionic_qcq_disable(lif->txqcqs[i].qcq);
-		ionic_qcq_disable(lif->rxqcqs[i].qcq);
+		err = ionic_qcq_disable(lif->txqcqs[i].qcq);
+		if (err == -ETIMEDOUT)
+			break;
+		err = ionic_qcq_disable(lif->rxqcqs[i].qcq);
+		if (err == -ETIMEDOUT)
+			break;
 	}
 }
 
@@ -1581,7 +1590,7 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 
 		ionic_rx_fill(&lif->rxqcqs[i].qcq->q);
 		err = ionic_qcq_enable(lif->rxqcqs[i].qcq);
-		if (err) {
+		if (err && err != -ETIMEDOUT) {
 			ionic_qcq_disable(lif->txqcqs[i].qcq);
 			goto err_out;
 		}
@@ -1591,8 +1600,12 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 
 err_out:
 	while (i--) {
-		ionic_qcq_disable(lif->rxqcqs[i].qcq);
-		ionic_qcq_disable(lif->txqcqs[i].qcq);
+		err = ionic_qcq_disable(lif->rxqcqs[i].qcq);
+		if (err == -ETIMEDOUT)
+			break;
+		err = ionic_qcq_disable(lif->txqcqs[i].qcq);
+		if (err == -ETIMEDOUT)
+			break;
 	}
 
 	return err;
@@ -1601,7 +1614,7 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 int ionic_open(struct net_device *netdev)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
-	int err;
+	int err = 0;
 
 	if (test_bit(IONIC_LIF_F_UP, lif->state)) {
 		dev_dbg(lif->ionic->dev, "%s: %s called when state=UP\n",
@@ -1609,15 +1622,18 @@ int ionic_open(struct net_device *netdev)
 		return 0;
 	}
 
+	if (test_and_set_bit(IONIC_LIF_F_TRANS, lif->state))
+		return -EBUSY;
+
 	ionic_link_status_check_request(lif);
 
 	/* wait until carrier is up before creating rx and tx queues */
 	if (!netif_carrier_ok(lif->netdev))
-		return 0;
+		goto open_out;
 
 	err = ionic_txrx_alloc(lif);
 	if (err)
-		return err;
+		goto open_out;
 
 	err = ionic_txrx_init(lif);
 	if (err)
@@ -1635,25 +1651,30 @@ int ionic_open(struct net_device *netdev)
 	if (netif_carrier_ok(netdev))
 		netif_tx_wake_all_queues(netdev);
 
-	return 0;
-
 err_txrx_deinit:
-	ionic_txrx_deinit(lif);
+	if (err)
+		ionic_txrx_deinit(lif);
 err_txrx_free:
-	ionic_txrx_free(lif);
+	if (err)
+		ionic_txrx_free(lif);
+open_out:
+	clear_bit(IONIC_LIF_F_TRANS, lif->state);
 	return err;
 }
 
 int ionic_stop(struct net_device *netdev)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
-	int err = 0;
 
 	if (!test_bit(IONIC_LIF_F_UP, lif->state)) {
 		dev_dbg(lif->ionic->dev, "%s: %s called when state=DOWN\n",
 			__func__, lif->name);
 		return 0;
 	}
+
+	if (test_and_set_bit(IONIC_LIF_F_TRANS, lif->state))
+		return -EBUSY;
+
 	dev_dbg(lif->ionic->dev, "%s: %s state=UP\n", __func__, lif->name);
 	clear_bit(IONIC_LIF_F_UP, lif->state);
 
@@ -1667,7 +1688,8 @@ int ionic_stop(struct net_device *netdev)
 	ionic_txrx_deinit(lif);
 	ionic_txrx_free(lif);
 
-	return err;
+	clear_bit(IONIC_LIF_F_TRANS, lif->state);
+	return 0;
 }
 
 static int ionic_get_vf_config(struct net_device *netdev,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index fdbb25774755..7c6e8495322d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -125,6 +125,7 @@ enum ionic_lif_state_flags {
 	IONIC_LIF_F_INITED,
 	IONIC_LIF_F_SW_DEBUG_STATS,
 	IONIC_LIF_F_UP,
+	IONIC_LIF_F_TRANS,
 	IONIC_LIF_F_LINK_CHECK_REQUESTED,
 	IONIC_LIF_F_QUEUE_RESET,
 	IONIC_LIF_F_FW_RESET,
@@ -228,6 +229,7 @@ static inline u32 ionic_coal_hw_to_usec(struct ionic *ionic, u32 units)
 
 void ionic_lif_deferred_enqueue(struct ionic_deferred *def,
 				struct ionic_deferred_work *work);
+void ionic_link_status_check_request(struct ionic_lif *lif);
 int ionic_lifs_alloc(struct ionic *ionic);
 void ionic_lifs_free(struct ionic *ionic);
 void ionic_lifs_deinit(struct ionic *ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 601865db7e03..1dafc047b136 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -364,7 +364,6 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 		done, duration / HZ, duration);
 
 	if (!done && hb) {
-		ionic_dev_cmd_clean(ionic);
 		dev_warn(ionic->dev, "DEVCMD %s (%d) failed - FW halted\n",
 			 ionic_opcode_to_str(opcode), opcode);
 		return -ENXIO;
-- 
2.17.1

