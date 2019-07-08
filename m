Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830E062978
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404120AbfGHTZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:25:52 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45432 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404113AbfGHTZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:25:51 -0400
Received: by mail-pl1-f195.google.com with SMTP id y8so4058154plr.12
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=7Lgm65BrOBw1MHqX45lTFJz7ZIlVRTq841/lGw4pJH0=;
        b=NnbWNpO1T/JECUxeIVAvPV6A9PKxsCVNchv8ryej2jx2/J7dTsUg/Y81HJZgjDsJee
         TQyLq3oo9sNbUPncLMu57O4Kwh9+HP2oNypN8aLh38Qe4vfzgH54X2Itka6E4yjFGuG4
         +FR2qRjU7yh5AUxGrtJg6hN50yu4BCKxEk3Ugs4UgAHYRAeOqI0YDDwKC5ZKN1V2kvin
         d7VbfO+kOisTV7RSYypyGX2wRkxo0Swx4Vb+Hz8YVBi4NKwX45iSC+epGIBdGuoyVNSq
         OCXUA82r+2fRhl9zrpvIwQz3T98katSfRUP6aofrVLDdqVQQGKtC/BJvXWFUKiEN8Pj4
         Hqlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=7Lgm65BrOBw1MHqX45lTFJz7ZIlVRTq841/lGw4pJH0=;
        b=bgnNG9YYJjY9L7ysvh0RCvxBrK4EilgtFYrqaf3rJZvE5UhYeO2W1WAumbDeHhNNcv
         C2ZoGYLtuyiLiUWgbN71KecrDUiG3cNhsjrDILmaJqL82vDDTCvoNtJ8HB1GZ/0NPzMN
         3zMoMdvBBlhhxtOTCUyXXr6l/Kym67vwz1MGo6kmfceZaOs/qHeg4D/ZcapUln9ercxQ
         TnQNfwYcnJE4bdRbqgKafeHWTs21VBpCt2uZgYGIEcOoEApQzO/cbbxFlqdzPJkgetib
         cw0+3AieKsCWuMxhg9xh6o/Ntw//H2CVRI8TQ6uwpyigJMmo6ak/LMw0NDRKcPOGzg4D
         aJhA==
X-Gm-Message-State: APjAAAUeO3vqTj+YERVKHU2s+J/xpiLN8h0speh8gkxV/oolgq2OZDUJ
        uobM82AGNDv1NNsy3F+nJ/cXVw==
X-Google-Smtp-Source: APXvYqxevDBYqgeKy5/5dt/Ei5yqun3AXYzKzr2G5u8kjcGgV7vXUNoPS5O7IXpZo73Thz/HfBVmJQ==
X-Received: by 2002:a17:902:b20d:: with SMTP id t13mr25705315plr.229.1562613950217;
        Mon, 08 Jul 2019 12:25:50 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id n19sm20006770pfa.11.2019.07.08.12.25.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:25:49 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 12/19] ionic: Add async link status check and basic stats
Date:   Mon,  8 Jul 2019 12:25:25 -0700
Message-Id: <20190708192532.27420-13-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190708192532.27420-1-snelson@pensando.io>
References: <20190708192532.27420-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add code to handle the link status event, and wire up the
basic netdev hardware stats.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 116 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   1 +
 2 files changed, 117 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index efcda1337f91..f52af9cb6264 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -15,6 +15,7 @@
 static void ionic_lif_rx_mode(struct lif *lif, unsigned int rx_mode);
 static int ionic_lif_addr_add(struct lif *lif, const u8 *addr);
 static int ionic_lif_addr_del(struct lif *lif, const u8 *addr);
+static void ionic_link_status_check(struct lif *lif);
 
 static int ionic_set_nic_features(struct lif *lif, netdev_features_t features);
 static int ionic_notifyq_clean(struct lif *lif, int budget);
@@ -44,6 +45,9 @@ static void ionic_lif_deferred_work(struct work_struct *work)
 		case DW_TYPE_RX_ADDR_DEL:
 			ionic_lif_addr_del(lif, w->addr);
 			break;
+		case DW_TYPE_LINK_STATUS:
+			ionic_link_status_check(lif);
+			break;
 		default:
 			break;
 		}
@@ -69,6 +73,7 @@ int ionic_open(struct net_device *netdev)
 
 	set_bit(LIF_UP, lif->state);
 
+	ionic_link_status_check(lif);
 	if (netif_carrier_ok(netdev))
 		netif_tx_wake_all_queues(netdev);
 
@@ -151,6 +156,39 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 	return max(n_work, a_work);
 }
 
+static void ionic_link_status_check(struct lif *lif)
+{
+	struct net_device *netdev = lif->netdev;
+	u16 link_status;
+	bool link_up;
+
+	clear_bit(LIF_LINK_CHECK_NEEDED, lif->state);
+
+	link_status = le16_to_cpu(lif->info->status.link_status);
+	link_up = link_status == PORT_OPER_STATUS_UP;
+
+	/* filter out the no-change cases */
+	if (link_up == netif_carrier_ok(netdev))
+		return;
+
+	if (link_up) {
+		netdev_info(netdev, "Link up - %d Gbps\n",
+			    le32_to_cpu(lif->info->status.link_speed) / 1000);
+
+		if (test_bit(LIF_UP, lif->state)) {
+			netif_tx_wake_all_queues(lif->netdev);
+			netif_carrier_on(netdev);
+		}
+	} else {
+		netdev_info(netdev, "Link down\n");
+
+		/* carrier off first to avoid watchdog timeout */
+		netif_carrier_off(netdev);
+		if (test_bit(LIF_UP, lif->state))
+			netif_tx_stop_all_queues(netdev);
+	}
+}
+
 static bool ionic_notifyq_service(struct cq *cq, struct cq_info *cq_info)
 {
 	union notifyq_comp *comp = cq_info->cq_desc;
@@ -182,6 +220,9 @@ static bool ionic_notifyq_service(struct cq *cq, struct cq_info *cq_info)
 			    "  link_status=%d link_speed=%d\n",
 			    le16_to_cpu(comp->link_change.link_status),
 			    le32_to_cpu(comp->link_change.link_speed));
+
+		set_bit(LIF_LINK_CHECK_NEEDED, lif->state);
+
 		break;
 	case EVENT_OPCODE_RESET:
 		netdev_info(netdev, "Notifyq EVENT_OPCODE_RESET eid=%lld\n",
@@ -222,10 +263,81 @@ static int ionic_notifyq_clean(struct lif *lif, int budget)
 	if (work_done == budget)
 		goto return_to_napi;
 
+	/* After outstanding events are processed we can check on
+	 * the link status and any outstanding interrupt credits.
+	 *
+	 * We wait until here to check on the link status in case
+	 * there was a long list of link events from a flap episode.
+	 */
+	if (test_bit(LIF_LINK_CHECK_NEEDED, lif->state)) {
+		struct ionic_deferred_work *work;
+
+		work = kzalloc(sizeof(*work), GFP_ATOMIC);
+		if (!work) {
+			netdev_err(lif->netdev, "%s OOM\n", __func__);
+		} else {
+			work->type = DW_TYPE_LINK_STATUS;
+			ionic_lif_deferred_enqueue(&lif->deferred, work);
+		}
+	}
+
 return_to_napi:
 	return work_done;
 }
 
+static void ionic_get_stats64(struct net_device *netdev,
+			      struct rtnl_link_stats64 *ns)
+{
+	struct lif *lif = netdev_priv(netdev);
+	struct lif_stats *ls;
+
+	memset(ns, 0, sizeof(*ns));
+	ls = &lif->info->stats;
+
+	ns->rx_packets = le64_to_cpu(ls->rx_ucast_packets) +
+			 le64_to_cpu(ls->rx_mcast_packets) +
+			 le64_to_cpu(ls->rx_bcast_packets);
+
+	ns->tx_packets = le64_to_cpu(ls->tx_ucast_packets) +
+			 le64_to_cpu(ls->tx_mcast_packets) +
+			 le64_to_cpu(ls->tx_bcast_packets);
+
+	ns->rx_bytes = le64_to_cpu(ls->rx_ucast_bytes) +
+		       le64_to_cpu(ls->rx_mcast_bytes) +
+		       le64_to_cpu(ls->rx_bcast_bytes);
+
+	ns->tx_bytes = le64_to_cpu(ls->tx_ucast_bytes) +
+		       le64_to_cpu(ls->tx_mcast_bytes) +
+		       le64_to_cpu(ls->tx_bcast_bytes);
+
+	ns->rx_dropped = le64_to_cpu(ls->rx_ucast_drop_packets) +
+			 le64_to_cpu(ls->rx_mcast_drop_packets) +
+			 le64_to_cpu(ls->rx_bcast_drop_packets);
+
+	ns->tx_dropped = le64_to_cpu(ls->tx_ucast_drop_packets) +
+			 le64_to_cpu(ls->tx_mcast_drop_packets) +
+			 le64_to_cpu(ls->tx_bcast_drop_packets);
+
+	ns->multicast = le64_to_cpu(ls->rx_mcast_packets);
+
+	ns->rx_over_errors = le64_to_cpu(ls->rx_queue_empty);
+
+	ns->rx_missed_errors = le64_to_cpu(ls->rx_dma_error) +
+			       le64_to_cpu(ls->rx_queue_disabled) +
+			       le64_to_cpu(ls->rx_desc_fetch_error) +
+			       le64_to_cpu(ls->rx_desc_data_error);
+
+	ns->tx_aborted_errors = le64_to_cpu(ls->tx_dma_error) +
+				le64_to_cpu(ls->tx_queue_disabled) +
+				le64_to_cpu(ls->tx_desc_fetch_error) +
+				le64_to_cpu(ls->tx_desc_data_error);
+
+	ns->rx_errors = ns->rx_over_errors +
+			ns->rx_missed_errors;
+
+	ns->tx_errors = ns->tx_aborted_errors;
+}
+
 static int ionic_lif_addr_add(struct lif *lif, const u8 *addr)
 {
 	struct ionic_admin_ctx ctx = {
@@ -581,6 +693,7 @@ static int ionic_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto,
 static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_open               = ionic_open,
 	.ndo_stop               = ionic_stop,
+	.ndo_get_stats64	= ionic_get_stats64,
 	.ndo_set_rx_mode	= ionic_set_rx_mode,
 	.ndo_set_features	= ionic_set_features,
 	.ndo_set_mac_address	= ionic_set_mac_address,
@@ -1418,6 +1531,8 @@ static int ionic_lif_init(struct lif *lif)
 
 	set_bit(LIF_INITED, lif->state);
 
+	ionic_link_status_check(lif);
+
 	return 0;
 
 err_out_notifyq_deinit:
@@ -1461,6 +1576,7 @@ int ionic_lifs_register(struct ionic *ionic)
 		return err;
 	}
 
+	ionic_link_status_check(ionic->master_lif);
 	ionic->master_lif->registered = true;
 
 	return 0;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 20b4fa573f77..9930b9390c8a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -86,6 +86,7 @@ struct ionic_deferred {
 enum lif_state_flags {
 	LIF_INITED,
 	LIF_UP,
+	LIF_LINK_CHECK_NEEDED,
 	LIF_QUEUE_RESET,
 
 	/* leave this as last */
-- 
2.17.1

