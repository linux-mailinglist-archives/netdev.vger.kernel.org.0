Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38AE8196356
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 04:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgC1DPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 23:15:08 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33441 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgC1DPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 23:15:05 -0400
Received: by mail-pg1-f195.google.com with SMTP id d17so5599419pgo.0
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 20:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=60AS913VczUmA/4bVsuhjtEx3AKtNrJQqPyZOf27E9E=;
        b=CVcIfElTENskxiRwHs3VaywOf7MxovD+Ui1qEq086nPW1aSDUOQRxWNzgKEJLDhj57
         gWO6ECRm4ZiOyYh+SvDPlug6tmETxbOchZ3m3tjpDpnLeoYMv19OIZ6wboIj6C3Yc5bp
         46n4qfOH6lxJ+oHQS6OAmFt8qBmyeX2bY9usDgoF6CAIkqc5sYiFFPnQ8Ce2QfkyRwSd
         PGpCt6AjXj5b5C5eAOQjXCtYizk2PRatZAgrilyMZP+Fre9bsqai1mLkgmc97hGceU3V
         sjLwpD4vrlb2dW0Hb+tv3HPp241U90CjZWpebdg0Fh9OSbWX4JosOfwOYB4m0ErANDho
         xcHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=60AS913VczUmA/4bVsuhjtEx3AKtNrJQqPyZOf27E9E=;
        b=QpXJRHPoukMH2vxy7/sc6/Eu3TMae7KpaXoO271mNeucZcjcYbFQRaduulduYme4QZ
         7Se9X8o0rSusPl/PP4fuPNb3ak4CRot9dHAzw86RGLuv4vfyIkbmnRRPqVxj0yiw13Ih
         DVt5eWEc0vKLyYiopXUTAHxbDqI+j27MVvComQ8WcjrLCX+3pVii67xxpHRsMR5+1usu
         9Gx6S3bAZQz5vf2ezVvJeWovz23mUjJHkPHI//y4hv9Rv79NlsPOuoNwgOii5f7RIGPc
         iaV6HyXvSRcBte+JRL8bwprzaJmvkkEEhsTUzOBPc0r/ivhip/caykc0aHyFHaD3DUq/
         SXOg==
X-Gm-Message-State: ANhLgQ3+rPqbt3QmR2BY6reMFIEE4hUSmWYc3UIOUCjeGlnh18ieL0rZ
        71VaNOxeCKr7Y1n9zWcPc3nMAmPPB8o=
X-Google-Smtp-Source: ADFU+vufU8/11lb27xOu+2t1tKMlVSKnSo84jixp0WfZ7KQ55id+z262/zwXn6OiJY2R68FELQu2CQ==
X-Received: by 2002:a63:6cc5:: with SMTP id h188mr2401265pgc.337.1585365301540;
        Fri, 27 Mar 2020 20:15:01 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o65sm5208391pfg.187.2020.03.27.20.15.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 20:15:00 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 8/8] ionic: remove lifs on fw reset
Date:   Fri, 27 Mar 2020 20:14:48 -0700
Message-Id: <20200328031448.50794-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200328031448.50794-1-snelson@pensando.io>
References: <20200328031448.50794-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the FW RESET event comes to the driver from the firmware,
or the fw_status goes to 0 (stopped) or to 0xff (no PCI
connection), then shut down the driver activity.  This event
signals a FW upgrade where we need to quiesce all operations and
wait for the FW to restart.  The FW will continue the update
process once it sees all the LIFs are reset.  When the update
process is done it will set the fw_status back to RUNNING.
Meanwhile, the heartbeat check continues and when the fw_status
is seen as set to running we can restart the driver operations.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  40 +++++-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   1 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 130 +++++++++++++++---
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   4 +
 .../net/ethernet/pensando/ionic/ionic_main.c  |   8 +-
 5 files changed, 158 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index f03a092f370f..f4ae40ae1e53 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -86,6 +86,7 @@ int ionic_dev_setup(struct ionic *ionic)
 		return -EFAULT;
 	}
 
+	idev->last_fw_status = 0xff;
 	timer_setup(&ionic->watchdog_timer, ionic_watchdog_cb, 0);
 	ionic->watchdog_period = IONIC_WATCHDOG_SECS * HZ;
 	mod_timer(&ionic->watchdog_timer,
@@ -119,8 +120,43 @@ int ionic_heartbeat_check(struct ionic *ionic)
 	 * fw_status != 0xff (bad PCI read)
 	 */
 	fw_status = ioread8(&idev->dev_info_regs->fw_status);
-	if (fw_status == 0xff ||
-	    !(fw_status & IONIC_FW_STS_F_RUNNING))
+	if (fw_status != 0xff)
+		fw_status &= IONIC_FW_STS_F_RUNNING;  /* use only the run bit */
+
+	/* is this a transition? */
+	if (fw_status != idev->last_fw_status &&
+	    idev->last_fw_status != 0xff) {
+		struct ionic_lif *lif = ionic->master_lif;
+		bool trigger = false;
+
+		if (!fw_status || fw_status == 0xff) {
+			dev_info(ionic->dev, "FW stopped %u\n", fw_status);
+			if (lif && !test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+				trigger = true;
+		} else {
+			dev_info(ionic->dev, "FW running %u\n", fw_status);
+			if (lif && test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+				trigger = true;
+		}
+
+		if (trigger) {
+			struct ionic_deferred_work *work;
+
+			work = kzalloc(sizeof(*work), GFP_ATOMIC);
+			if (!work) {
+				dev_err(ionic->dev, "%s OOM\n", __func__);
+			} else {
+				work->type = IONIC_DW_TYPE_LIF_RESET;
+				if (fw_status & IONIC_FW_STS_F_RUNNING &&
+				    fw_status != 0xff)
+					work->fw_status = 1;
+				ionic_lif_deferred_enqueue(&lif->deferred, work);
+			}
+		}
+	}
+	idev->last_fw_status = fw_status;
+
+	if (!fw_status || fw_status == 0xff)
 		return -ENXIO;
 
 	/* early FW has no heartbeat, else FW will return non-zero */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 7838e342c4fd..587398b01997 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -132,6 +132,7 @@ struct ionic_dev {
 
 	unsigned long last_hb_time;
 	u32 last_hb;
+	u8 last_fw_status;
 
 	u64 __iomem *db_pages;
 	dma_addr_t phy_db_pages;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 8584a7c51446..27ec44c92d6f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -21,6 +21,9 @@ static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode);
 static int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr);
 static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr);
 static void ionic_link_status_check(struct ionic_lif *lif);
+static void ionic_lif_handle_fw_down(struct ionic_lif *lif);
+static void ionic_lif_handle_fw_up(struct ionic_lif *lif);
+static void ionic_lif_set_netdev_info(struct ionic_lif *lif);
 
 static int ionic_start_queues(struct ionic_lif *lif);
 static void ionic_stop_queues(struct ionic_lif *lif);
@@ -53,6 +56,12 @@ static void ionic_lif_deferred_work(struct work_struct *work)
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
@@ -61,8 +70,8 @@ static void ionic_lif_deferred_work(struct work_struct *work)
 	}
 }
 
-static void ionic_lif_deferred_enqueue(struct ionic_deferred *def,
-				       struct ionic_deferred_work *work)
+void ionic_lif_deferred_enqueue(struct ionic_deferred *def,
+				struct ionic_deferred_work *work)
 {
 	spin_lock_bh(&def->lock);
 	list_add_tail(&work->list, &def->list);
@@ -682,6 +691,7 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
 				  struct ionic_cq_info *cq_info)
 {
 	union ionic_notifyq_comp *comp = cq_info->cq_desc;
+	struct ionic_deferred_work *work;
 	struct net_device *netdev;
 	struct ionic_queue *q;
 	struct ionic_lif *lif;
@@ -707,11 +717,13 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
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
@@ -1224,7 +1236,8 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 	netdev->hw_features |= netdev->hw_enc_features;
 	netdev->features |= netdev->hw_features;
 
-	netdev->priv_flags |= IFF_UNICAST_FLT;
+	netdev->priv_flags |= IFF_UNICAST_FLT |
+			      IFF_LIVE_ADDR_CHANGE;
 
 	return 0;
 }
@@ -1669,6 +1682,9 @@ int ionic_stop(struct net_device *netdev)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return 0;
+
 	ionic_stop_queues(lif);
 	ionic_txrx_deinit(lif);
 	ionic_txrx_free(lif);
@@ -2064,6 +2080,80 @@ static void ionic_lif_reset(struct ionic_lif *lif)
 	mutex_unlock(&lif->ionic->dev_cmd_lock);
 }
 
+static void ionic_lif_handle_fw_down(struct ionic_lif *lif)
+{
+	struct ionic *ionic = lif->ionic;
+
+	if (test_and_set_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return;
+
+	dev_info(ionic->dev, "FW Down: Stopping LIFs\n");
+
+	netif_device_detach(lif->netdev);
+
+	if (test_bit(IONIC_LIF_F_UP, lif->state)) {
+		dev_info(ionic->dev, "Surprise FW stop, stopping queues\n");
+		ionic_stop_queues(lif);
+	}
+
+	if (netif_running(lif->netdev)) {
+		ionic_txrx_deinit(lif);
+		ionic_txrx_free(lif);
+	}
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
+	if (!test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return;
+
+	dev_info(ionic->dev, "FW Up: restarting LIFs\n");
+
+	err = ionic_qcqs_alloc(lif);
+	if (err)
+		goto err_out;
+
+	err = ionic_lifs_init(ionic);
+	if (err)
+		goto err_qcqs_free;
+
+	if (lif->registered)
+		ionic_lif_set_netdev_info(lif);
+
+	if (netif_running(lif->netdev)) {
+		err = ionic_txrx_alloc(lif);
+		if (err)
+			goto err_lifs_deinit;
+
+		err = ionic_txrx_init(lif);
+		if (err)
+			goto err_txrx_free;
+	}
+
+	clear_bit(IONIC_LIF_F_FW_RESET, lif->state);
+	ionic_link_status_check_request(lif);
+	netif_device_attach(lif->netdev);
+	dev_info(ionic->dev, "FW Up: LIFs restarted\n");
+
+	return;
+
+err_txrx_free:
+	ionic_txrx_free(lif);
+err_lifs_deinit:
+	ionic_lifs_deinit(ionic);
+err_qcqs_free:
+	ionic_qcqs_free(lif);
+err_out:
+	dev_err(ionic->dev, "FW Up: LIFs restart failed - err %d\n", err);
+}
+
 static void ionic_lif_free(struct ionic_lif *lif)
 {
 	struct device *dev = lif->ionic->dev;
@@ -2076,7 +2166,8 @@ static void ionic_lif_free(struct ionic_lif *lif)
 
 	/* free queues */
 	ionic_qcqs_free(lif);
-	ionic_lif_reset(lif);
+	if (!test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		ionic_lif_reset(lif);
 
 	/* free lif info */
 	dma_free_coherent(dev, lif->info_sz, lif->info, lif->info_pa);
@@ -2109,17 +2200,19 @@ void ionic_lifs_free(struct ionic *ionic)
 
 static void ionic_lif_deinit(struct ionic_lif *lif)
 {
-	if (!test_bit(IONIC_LIF_F_INITED, lif->state))
+	if (!test_and_clear_bit(IONIC_LIF_F_INITED, lif->state))
 		return;
 
-	clear_bit(IONIC_LIF_F_INITED, lif->state);
+	if (!test_bit(IONIC_LIF_F_FW_RESET, lif->state)) {
+		cancel_work_sync(&lif->deferred.work);
+		cancel_work_sync(&lif->tx_timeout_work);
+	}
 
 	ionic_rx_filters_deinit(lif);
 	if (lif->netdev->features & NETIF_F_RXHASH)
 		ionic_lif_rss_deinit(lif);
 
 	napi_disable(&lif->adminqcq->napi);
-	netif_napi_del(&lif->adminqcq->napi);
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
 
@@ -2213,6 +2306,7 @@ static int ionic_lif_notifyq_init(struct ionic_lif *lif)
 	if (err)
 		return err;
 
+	lif->last_eid = 0;
 	q->hw_type = ctx.comp.q_init.hw_type;
 	q->hw_index = le32_to_cpu(ctx.comp.q_init.hw_index);
 	q->dbval = IONIC_DBELL_QID(q->hw_index);
@@ -2253,8 +2347,8 @@ static int ionic_station_set(struct ionic_lif *lif)
 	addr.sa_family = AF_INET;
 	err = eth_prepare_mac_addr_change(netdev, &addr);
 	if (err) {
-		netdev_warn(lif->netdev, "ignoring bad MAC addr from NIC %pM\n",
-			    addr.sa_data);
+		netdev_warn(lif->netdev, "ignoring bad MAC addr from NIC %pM - err %d\n",
+			    addr.sa_data, err);
 		return 0;
 	}
 
@@ -2464,12 +2558,8 @@ void ionic_lifs_unregister(struct ionic *ionic)
 	 * current model, so don't bother searching the
 	 * ionic->lif for candidates to unregister
 	 */
-	if (!ionic->master_lif)
-		return;
-
-	cancel_work_sync(&ionic->master_lif->deferred.work);
-	cancel_work_sync(&ionic->master_lif->tx_timeout_work);
-	if (ionic->master_lif->netdev->reg_state == NETREG_REGISTERED)
+	if (ionic->master_lif &&
+	    ionic->master_lif->netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(ionic->master_lif->netdev);
 }
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 8aaa7daf3842..5d4ffda5c05f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -98,6 +98,7 @@ struct ionic_deferred_work {
 	union {
 		unsigned int rx_mode;
 		u8 addr[ETH_ALEN];
+		u8 fw_status;
 	};
 };
 
@@ -126,6 +127,7 @@ enum ionic_lif_state_flags {
 	IONIC_LIF_F_UP,
 	IONIC_LIF_F_LINK_CHECK_REQUESTED,
 	IONIC_LIF_F_QUEUE_RESET,
+	IONIC_LIF_F_FW_RESET,
 
 	/* leave this as last */
 	IONIC_LIF_F_STATE_SIZE
@@ -225,6 +227,8 @@ static inline u32 ionic_coal_hw_to_usec(struct ionic *ionic, u32 units)
 }
 
 void ionic_link_status_check_request(struct ionic_lif *lif);
+void ionic_lif_deferred_enqueue(struct ionic_deferred *def,
+				struct ionic_deferred_work *work);
 int ionic_lifs_alloc(struct ionic *ionic);
 void ionic_lifs_free(struct ionic *ionic);
 void ionic_lifs_deinit(struct ionic *ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index c16dbbe54bf7..588c62e9add7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -286,9 +286,11 @@ int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 
 	err = ionic_adminq_post(lif, ctx);
 	if (err) {
-		name = ionic_opcode_to_str(ctx->cmd.cmd.opcode);
-		netdev_err(netdev, "Posting of %s (%d) failed: %d\n",
-			   name, ctx->cmd.cmd.opcode, err);
+		if (!test_bit(IONIC_LIF_F_FW_RESET, lif->state)) {
+			name = ionic_opcode_to_str(ctx->cmd.cmd.opcode);
+			netdev_err(netdev, "Posting of %s (%d) failed: %d\n",
+				   name, ctx->cmd.cmd.opcode, err);
+		}
 		return err;
 	}
 
-- 
2.17.1

