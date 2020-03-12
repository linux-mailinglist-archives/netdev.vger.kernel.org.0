Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E1C183BBE
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 22:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgCLVuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 17:50:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38754 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgCLVue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 17:50:34 -0400
Received: by mail-pg1-f193.google.com with SMTP id x7so3731431pgh.5
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 14:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Jgxy3tCrGex6W2ji7AyPVdZL2zZf5ftOnGNPJQUguS8=;
        b=A6lXYk+B/IokykcSQKMhWcNCSF5DNGu31wRY8H/C1tsENFdmB3pefb7+n1EEy27Qzv
         fsmLL5NHx/FEOW9KOkOdRHJk/6RIOXf2hj+mXI1re8Ci4X7bdI+7RIbQxgH78iOWdMxR
         VRBItvS2D6qZLyX+jEue/i97krBYAJA29/Cbk+0IpVx3Z2pfAwK8QkCXNuo15PwwSf5W
         eFhCdrvaxQ0p58D17K5JX2VvO95BtMHpdkPl30uDZqU1bw2QB8jCIWkbWPCIy8SYWMq9
         bJULuIXWRS24YIoUPZLQUrBzLGcFiYqEWNGPgX2jC/+9EVbAaCzRgpmEFb/9o5+5QPMz
         temA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Jgxy3tCrGex6W2ji7AyPVdZL2zZf5ftOnGNPJQUguS8=;
        b=cg6GPxFPNh6ncdIFaG9aSUiuTeng28MTMNWAf3pLZydt3PvYotIWV32pGfonRfcL6f
         /NF1iXuv8psUjW50DIgysYXqLJNvk6ODxGQcnnnJuKW7nrTgCzzP38lPxc9Djd3m3gP0
         6OhwUOXVd03FuanPLsKYu2lPrPhoHjTY9naKM+3vD1IU2Bp6PZAA8NxaRMoWF8fe+0Sb
         RRwDsV8QQ/GSa/+JIZrejZWNmKNRZExLs7yJPWc8vf3SsHTQ5Tf8g9ONvSal6L5TzXbv
         M9Xtq5kls8NaPQdH+Jw1c5PN6R35FY+5YigdP0xvpsfsxHPJQINQ2WFK0VwnJMhsCfrG
         mtVQ==
X-Gm-Message-State: ANhLgQ2zUS+2T8RvwuWr6seZNWptwShp36ZDQvOTXk4qa/Ke2UxWgdpf
        cWvYSBiKIy2FDxCivrgTK3+3UXPVU70=
X-Google-Smtp-Source: ADFU+vvmYh4t8G0Q6lCo0rbjBUh5NZ8k5uM4B9EUY4uQn3OAEbpWWFP0nTrid+zG4evj3j8ngicF2A==
X-Received: by 2002:aa7:8553:: with SMTP id y19mr8246175pfn.307.1584049833115;
        Thu, 12 Mar 2020 14:50:33 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p2sm38281203pfb.41.2020.03.12.14.50.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Mar 2020 14:50:31 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/7] ionic: remove lifs on fw reset
Date:   Thu, 12 Mar 2020 14:50:13 -0700
Message-Id: <20200312215015.69547-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312215015.69547-1-snelson@pensando.io>
References: <20200312215015.69547-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the FW RESET event comes to the driver from the firmware,
tear down the LIFs.  This event signals a FW upgrade where we
need to quiesce all operations and wait for the FW to restart.
The FW will continue the update process once it sees all the
LIFs are reset.  When the update process is done it will set
the fw_status back to RUNNING.  Meanwhile, the heartbeat
check continues and when the fw_status is seen as set to
running we can rebuild the LIFs.

We expect that there was a LINK_DOWN event before this to stop
the queues, and there will be a LINK_UP event afterwards to
get things started again.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 79 ++++++++++++++++---
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  1 +
 2 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 7909a037d5f7..a6af75031347 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -21,6 +21,9 @@ static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode);
 static int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr);
 static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr);
 static void ionic_link_status_check(struct ionic_lif *lif);
+static void ionic_lif_handle_fw_down(struct ionic_lif *lif);
+static void ionic_lif_handle_fw_up(struct ionic_lif *lif);
+static void ionic_lif_set_netdev_info(struct ionic_lif *lif);
 
 static void ionic_lif_deferred_work(struct work_struct *work)
 {
@@ -50,6 +53,12 @@ static void ionic_lif_deferred_work(struct work_struct *work)
 		case IONIC_DW_TYPE_LINK_STATUS:
 			ionic_link_status_check(lif);
 			break;
+		case IONIC_DW_TYPE_LIF_RESET:
+			if (w->fw_status)
+				ionic_lif_handle_fw_up(lif);
+			else
+				ionic_lif_handle_fw_down(lif);
+			break;
 		default:
 			break;
 		}
@@ -690,6 +699,7 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
 				  struct ionic_cq_info *cq_info)
 {
 	union ionic_notifyq_comp *comp = cq_info->cq_desc;
+	struct ionic_deferred_work *work;
 	struct net_device *netdev;
 	struct ionic_queue *q;
 	struct ionic_lif *lif;
@@ -715,11 +725,13 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
 		ionic_link_status_check_request(lif);
 		break;
 	case IONIC_EVENT_RESET:
-		netdev_info(netdev, "Notifyq IONIC_EVENT_RESET eid=%lld\n",
-			    eid);
-		netdev_info(netdev, "  reset_code=%d state=%d\n",
-			    comp->reset.reset_code,
-			    comp->reset.state);
+		work = kzalloc(sizeof(*work), GFP_ATOMIC);
+		if (!work) {
+			netdev_err(lif->netdev, "%s OOM\n", __func__);
+		} else {
+			work->type = IONIC_DW_TYPE_LIF_RESET;
+			ionic_lif_deferred_enqueue(&lif->deferred, work);
+		}
 		break;
 	default:
 		netdev_warn(netdev, "Notifyq unknown event ecode=%d eid=%lld\n",
@@ -1232,7 +1244,8 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 	netdev->hw_features |= netdev->hw_enc_features;
 	netdev->features |= netdev->hw_features;
 
-	netdev->priv_flags |= IFF_UNICAST_FLT;
+	netdev->priv_flags |= IFF_UNICAST_FLT |
+			      IFF_LIVE_ADDR_CHANGE;
 
 	return 0;
 }
@@ -2067,6 +2080,51 @@ static void ionic_lif_reset(struct ionic_lif *lif)
 	mutex_unlock(&lif->ionic->dev_cmd_lock);
 }
 
+static void ionic_lif_handle_fw_down(struct ionic_lif *lif)
+{
+	struct ionic *ionic = lif->ionic;
+
+	set_bit(IONIC_LIF_F_FW_RESET, lif->state);
+	dev_info(ionic->dev, "FW Down: Stopping LIFs\n");
+
+	if (test_bit(IONIC_LIF_F_UP, lif->state)) {
+		dev_info(ionic->dev, "Surprise FW stop, stopping netdev\n");
+		rtnl_lock();
+		ionic_stop(lif->netdev);
+		rtnl_unlock();
+	}
+
+	ionic_lifs_deinit(ionic);
+	ionic_qcqs_free(lif);
+
+	dev_info(ionic->dev, "FW Down: LIFs stopped\n");
+}
+
+static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
+{
+	struct ionic *ionic = lif->ionic;
+	int err;
+
+	dev_info(ionic->dev, "FW Up: restarting LIFs\n");
+
+	err = ionic_qcqs_alloc(lif);
+	if (!err)
+		err = ionic_lifs_init(ionic);
+
+	if (lif->registered)
+		ionic_lif_set_netdev_info(lif);
+
+	if (!err)
+		clear_bit(IONIC_LIF_F_FW_RESET, lif->state);
+
+	ionic_link_status_check_request(lif);
+
+	if (!err)
+		dev_info(ionic->dev, "FW Up: LIFs restarted\n");
+	else
+		dev_info(ionic->dev, "FW Up: LIFs restart failed\n");
+}
+
 static void ionic_lif_free(struct ionic_lif *lif)
 {
 	struct device *dev = lif->ionic->dev;
@@ -2229,6 +2287,7 @@ static int ionic_lif_notifyq_init(struct ionic_lif *lif)
 	if (err)
 		return err;
 
+	lif->last_eid = 0;
 	q->hw_type = ctx.comp.q_init.hw_type;
 	q->hw_index = le32_to_cpu(ctx.comp.q_init.hw_index);
 	q->dbval = IONIC_DBELL_QID(q->hw_index);
@@ -2271,8 +2330,8 @@ static int ionic_station_set(struct ionic_lif *lif)
 	addr.sa_family = AF_INET;
 	err = eth_prepare_mac_addr_change(netdev, &addr);
 	if (err) {
-		netdev_warn(lif->netdev, "ignoring bad MAC addr from NIC %pM\n",
-			    addr.sa_data);
+		netdev_warn(lif->netdev, "ignoring bad MAC addr from NIC %pM - err %d\n",
+			    addr.sa_data, err);
 		return 0;
 	}
 
@@ -2296,8 +2355,6 @@ static int ionic_lif_init(struct ionic_lif *lif)
 	int dbpage_num;
 	int err;
 
-	ionic_debugfs_add_lif(lif);
-
 	mutex_lock(&lif->ionic->dev_cmd_lock);
 	ionic_dev_cmd_lif_init(idev, lif->index, lif->info_pa);
 	err = ionic_dev_cmd_wait(lif->ionic, DEVCMD_TIMEOUT);
@@ -2333,6 +2390,8 @@ static int ionic_lif_init(struct ionic_lif *lif)
 		goto err_out_free_dbid;
 	}
 
+	ionic_debugfs_add_lif(lif);
+
 	err = ionic_lif_adminq_init(lif);
 	if (err)
 		goto err_out_adminq_deinit;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index d811cbb790dc..732dc1f99d24 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -98,6 +98,7 @@ struct ionic_deferred_work {
 	union {
 		unsigned int rx_mode;
 		u8 addr[ETH_ALEN];
+		u8 fw_status;
 	};
 };
 
-- 
2.17.1

