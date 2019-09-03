Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 608E1A76FA
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfICW3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:29:03 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38291 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727433AbfICW3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:29:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id h195so5247688pfe.5
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=Jkjz7s/+TXYMke/A/0xl4j1mkOAJnwB9JM7ilhhUKfM=;
        b=slRN/Ex8kPOKf+YVllyZ2o24nxJ9efuH/8zpkjhf3cwwAka1UHay1Cdq265qeLH878
         +jyQlRkSrtETxIK6WBRxoKqS2ZVD2LW8Jy9uZSFVgYKewP1TEUWI2GtVxuStEHkSwt+C
         afy/nQgDl+oyWVcgo5kIImB5cWUkloujMlyitj8JY0TK3LfeYbojOLYJsE5fxkyIVyRW
         9Xli48+SdVmcc1iJ+A1Z2Q2TM4D9ZysBnfE6/8Bro/V+AMkdpDyUvoqcVYqn1KxNzkpH
         Wk3e6Fon5K0T4quzNwJU1PqKyUEVtczaN20xzAMAh9vaHC65LIMGU5uSWUzFVii2fjO+
         Cx2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=Jkjz7s/+TXYMke/A/0xl4j1mkOAJnwB9JM7ilhhUKfM=;
        b=snrKIOjO/oJPrzT39lEM/ZyUkMa9lUCI41N7A1wf1eiZCDBO8zzQK7JubpmaSXzZEG
         JW2sdGvnpOC1GIB5OXKZAKhdZh+CMeP5AxG7ZEnie6xTxXxOdsqFLj5BmEVZYgmZQQnD
         RDc5zupmRQmhEeA/5UZcpjKRIc2MuvhmHhQbA8pH1tr/z14h6TerbFVlWyc0WSvcTHrw
         AlyJfQke8qrt5oxv4wLyQJ8Wxy+IuT0FEswF+CLqtpdPjdXPzAlvR9O37JVKItQT0R07
         JThvtCHTS+Wjrq6MvmePE5b0IgvnPcBZ/IZfm5FyAkmZeILq7Y8rjv3FBzq03RnEbPT0
         POgg==
X-Gm-Message-State: APjAAAXE7XvqPv4L10CDIgImePZFVG+scnCuJfFnTzgox4HhN+Zb5fjQ
        iu+ZeUH6lRQNNnPt0yfXnnhsJQ==
X-Google-Smtp-Source: APXvYqxa1J8sYjfChvJELBjQXREPyXpVjY4oLYKY1xdzJlRg0sY7G5ccl497f6/wBZ5BIhumi4LZTg==
X-Received: by 2002:a63:4522:: with SMTP id s34mr31959264pga.362.1567549740535;
        Tue, 03 Sep 2019 15:29:00 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e17sm520520pjt.6.2019.09.03.15.28.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 15:28:59 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v7 net-next 13/19] ionic: Add async link status check and basic stats
Date:   Tue,  3 Sep 2019 15:28:15 -0700
Message-Id: <20190903222821.46161-14-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903222821.46161-1-snelson@pensando.io>
References: <20190903222821.46161-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add code to handle the link status event, and wire up the
basic netdev hardware stats.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 116 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   1 +
 2 files changed, 111 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4bbccb8eaf35..a9175d7014f7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -15,6 +15,7 @@
 static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode);
 static int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr);
 static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr);
+static void ionic_link_status_check(struct ionic_lif *lif);
 
 static void ionic_lif_deferred_work(struct work_struct *work)
 {
@@ -41,6 +42,9 @@ static void ionic_lif_deferred_work(struct work_struct *work)
 		case IONIC_DW_TYPE_RX_ADDR_DEL:
 			ionic_lif_addr_del(lif, w->addr);
 			break;
+		case IONIC_DW_TYPE_LINK_STATUS:
+			ionic_link_status_check(lif);
+			break;
 		default:
 			break;
 		}
@@ -58,6 +62,54 @@ static void ionic_lif_deferred_enqueue(struct ionic_deferred *def,
 	schedule_work(&def->work);
 }
 
+static void ionic_link_status_check(struct ionic_lif *lif)
+{
+	struct net_device *netdev = lif->netdev;
+	u16 link_status;
+	bool link_up;
+
+	link_status = le16_to_cpu(lif->info->status.link_status);
+	link_up = link_status == IONIC_PORT_OPER_STATUS_UP;
+
+	/* filter out the no-change cases */
+	if (link_up == netif_carrier_ok(netdev))
+		goto link_out;
+
+	if (link_up) {
+		netdev_info(netdev, "Link up - %d Gbps\n",
+			    le32_to_cpu(lif->info->status.link_speed) / 1000);
+
+	} else {
+		netdev_info(netdev, "Link down\n");
+
+		/* carrier off first to avoid watchdog timeout */
+		netif_carrier_off(netdev);
+	}
+
+link_out:
+	clear_bit(IONIC_LIF_LINK_CHECK_REQUESTED, lif->state);
+}
+
+static void ionic_link_status_check_request(struct ionic_lif *lif)
+{
+	struct ionic_deferred_work *work;
+
+	/* we only need one request outstanding at a time */
+	if (test_and_set_bit(IONIC_LIF_LINK_CHECK_REQUESTED, lif->state))
+		return;
+
+	if (in_interrupt()) {
+		work = kzalloc(sizeof(*work), GFP_ATOMIC);
+		if (!work)
+			return;
+
+		work->type = IONIC_DW_TYPE_LINK_STATUS;
+		ionic_lif_deferred_enqueue(&lif->deferred, work);
+	} else {
+		ionic_link_status_check(lif);
+	}
+}
+
 static irqreturn_t ionic_isr(int irq, void *data)
 {
 	struct napi_struct *napi = data;
@@ -381,12 +433,7 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
 
 	switch (le16_to_cpu(comp->event.ecode)) {
 	case IONIC_EVENT_LINK_CHANGE:
-		netdev_info(netdev, "Notifyq IONIC_EVENT_LINK_CHANGE eid=%lld\n",
-			    eid);
-		netdev_info(netdev,
-			    "  link_status=%d link_speed=%d\n",
-			    le16_to_cpu(comp->link_change.link_status),
-			    le32_to_cpu(comp->link_change.link_speed));
+		ionic_link_status_check_request(lif);
 		break;
 	case IONIC_EVENT_RESET:
 		netdev_info(netdev, "Notifyq IONIC_EVENT_RESET eid=%lld\n",
@@ -445,6 +492,59 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 	return max(n_work, a_work);
 }
 
+static void ionic_get_stats64(struct net_device *netdev,
+			      struct rtnl_link_stats64 *ns)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_lif_stats *ls;
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
 static int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 {
 	struct ionic_admin_ctx ctx = {
@@ -982,6 +1082,8 @@ int ionic_open(struct net_device *netdev)
 
 	set_bit(IONIC_LIF_UP, lif->state);
 
+	ionic_link_status_check_request(lif);
+
 	return 0;
 }
 
@@ -1007,6 +1109,7 @@ int ionic_stop(struct net_device *netdev)
 static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_open               = ionic_open,
 	.ndo_stop               = ionic_stop,
+	.ndo_get_stats64	= ionic_get_stats64,
 	.ndo_set_rx_mode	= ionic_set_rx_mode,
 	.ndo_set_features	= ionic_set_features,
 	.ndo_set_mac_address	= ionic_set_mac_address,
@@ -1447,6 +1550,7 @@ int ionic_lifs_register(struct ionic *ionic)
 		return err;
 	}
 
+	ionic_link_status_check_request(ionic->master_lif);
 	ionic->master_lif->registered = true;
 
 	return 0;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 7da7d4a3fdf0..135c1a27e589 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -84,6 +84,7 @@ struct ionic_deferred {
 enum ionic_lif_state_flags {
 	IONIC_LIF_INITED,
 	IONIC_LIF_UP,
+	IONIC_LIF_LINK_CHECK_REQUESTED,
 	IONIC_LIF_QUEUE_RESET,
 
 	/* leave this as last */
-- 
2.17.1

