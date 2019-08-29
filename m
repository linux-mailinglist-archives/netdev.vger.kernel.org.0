Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB061A251F
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbfH2S2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:28:36 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35658 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729631AbfH2S2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:28:04 -0400
Received: by mail-pl1-f194.google.com with SMTP id gn20so1975365plb.2
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 11:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=0aPKTAkZxQ8atuvLbTXJ1n2zlkdU83lmWdlx+wSNCCs=;
        b=nL4/6EFgogbvuOZkw22nBnLA1CMYpnGM2OseGZi4H86NIM2HYxHLNP5yVvJuvzNw7N
         229HS4i2JJreUpQNbHJlBjZSCe1ByjNaijV+Am5Ur18vMmTY+/KYyq/9WtfR3BY0MdrN
         gDjUlHaTh8i49YcwuW4YpMihSYNBuB1ILtj66aOwmQ1nvaL6ehNH1lBsM/caaKKoCywc
         QqX8n9K14dDuorm/nqpyr4UAe/nIgxX+QUifVusPU5hu6OxliPP/RWvH+opsFTQLpUjO
         fL9cA9fWC9d1HFKPK10q/ie+MScqYK7cxyW97/3R9xRDXacIMgRf6+OuN47AMF/V45gE
         ikkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=0aPKTAkZxQ8atuvLbTXJ1n2zlkdU83lmWdlx+wSNCCs=;
        b=UHMS1eEn62GhXbIG5rNZLyrQJ3Nnfy0Bv8Q8N+adcZ5kuu2EhhIbCkbFVBkRGJOMPK
         Yj8ZIOdrQSvwRRtUkku4y6Q9ZkldEiI1Q/HIHLlGkMzQZC5nvRC428DQO3dRiQn/opx3
         8LdxGmIW6sYGL9fHRVyij+Ih5+M444H7T9+r941Dt0qejaieP4+g2GmedIPCNjbuN13U
         pxsirWDG0oz4U+5FjJVJhbIeZHs5jJbf823+Gs22LaMiiVrxBK5/Jierf0v4JIjLDIXx
         cKdgDzYx+vugLteZQtAiJFDaSohxzI3+w+O2Q8hoddW1MSdMAgNeMwwHZvwZKQ/GmQw4
         sKSA==
X-Gm-Message-State: APjAAAXNQOMw6sW3+PdFAIFbLZDXwg8kr5O5enpgAnPScMZ85Ed/ToMF
        qG+j4UUGFUMUPOzQod2wJVlPgQ==
X-Google-Smtp-Source: APXvYqwRFipe4Cu3/cEvIMIO0O/D1UmZhyTfdxZGi44OjmWeQiKg28x3aWXqKro+knkPcFg/kdZMYA==
X-Received: by 2002:a17:902:4545:: with SMTP id m63mr10056202pld.45.1567103283588;
        Thu, 29 Aug 2019 11:28:03 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id t70sm3082824pjb.2.2019.08.29.11.28.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 11:28:02 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v6 net-next 13/19] ionic: Add async link status check and basic stats
Date:   Thu, 29 Aug 2019 11:27:14 -0700
Message-Id: <20190829182720.68419-14-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829182720.68419-1-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
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
index 21925c156277..71e053c2df63 100644
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
@@ -382,12 +434,7 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
 
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
@@ -446,6 +493,59 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
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
@@ -981,6 +1081,8 @@ int ionic_open(struct net_device *netdev)
 
 	set_bit(IONIC_LIF_UP, lif->state);
 
+	ionic_link_status_check_request(lif);
+
 	return 0;
 }
 
@@ -1006,6 +1108,7 @@ int ionic_stop(struct net_device *netdev)
 static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_open               = ionic_open,
 	.ndo_stop               = ionic_stop,
+	.ndo_get_stats64	= ionic_get_stats64,
 	.ndo_set_rx_mode	= ionic_set_rx_mode,
 	.ndo_set_features	= ionic_set_features,
 	.ndo_set_mac_address	= ionic_set_mac_address,
@@ -1439,6 +1542,7 @@ int ionic_lifs_register(struct ionic *ionic)
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

