Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0439070BB0
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 23:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732859AbfGVVlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 17:41:08 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40925 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732796AbfGVVkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 17:40:42 -0400
Received: by mail-pf1-f194.google.com with SMTP id p184so17987872pfp.7
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 14:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=7Lgm65BrOBw1MHqX45lTFJz7ZIlVRTq841/lGw4pJH0=;
        b=h6B8UAsTfot2u+dQOn7ZzHh+9bSAeBz7aj7ZsuVbgbVSFZW6rkqRV4aR4JrA2NCMjS
         irgir56b8VKIkcob32YjTwdSze2tuVDoZhW1TOWkS5AXaMx8lOhLyQvZ9Sbnn+qHP9JP
         IXMLruy1oPYuRQQNgk651yDUSXCeOL2MHmStSETIDJfqzmv0sKH6E2W72qqz/Dmd6uSs
         ypmZm662vvMKCq3un5mRsMS+bX6DFHApWOeTmuwzPQQEhghUDcWqrCtc37JoCcWZnq/y
         k7YF2jPzUtBefbaCuf6qjuN5fITAQLjiUgfE05jXnqQixDQl5T1bn+agnYpVYt71+MRC
         NLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=7Lgm65BrOBw1MHqX45lTFJz7ZIlVRTq841/lGw4pJH0=;
        b=JRQlxWJMV/PH36S9xDY0e1EA8B+h730IocHczZQhEJNGzUOlbwrNTO5V6SOPXGsGw9
         5vyD+tXFsiVh3OmsQVDB2oJILr+WuWfx9N6U6HfVqTsw1SzfHltcvHKtVeS3VOplvn6R
         7ay4PFVQFqzIHjf4f3vypqgYVeWrdyt7BRZ/9oFLuyatDvXNkb/OmQoO/2xGIPL2GwIl
         oEB9LIWs9fjdSO7kpZ70lVU4zRn5Vm/B2fvDL61/aaOUNgMQEl2cxlQxolPhhWy4aC0e
         PW5M5qaOkX4aXEwv+dmGZyTz1cpCu+Wqh7QBWsZ8yRqx8BA/pE+9r7/Z17lTOnZLtpw8
         twJQ==
X-Gm-Message-State: APjAAAXb7jzBbpEXSgKRqN4zagfE7eCLUuWD7ykVv9Y4r7XXyB4L6KXC
        B77kUq1XoQh//XQrIrJlpXnoUQ==
X-Google-Smtp-Source: APXvYqw+1SH0oP7Rcj96CoQU6iAfhyDrdr0dAUIjVJHulcfj5Uy564yorRled3XKvdXK41tHO7FWVw==
X-Received: by 2002:a62:e20b:: with SMTP id a11mr2316028pfi.0.1563831641381;
        Mon, 22 Jul 2019 14:40:41 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id p65sm40593714pfp.58.2019.07.22.14.40.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 14:40:40 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v4 net-next 12/19] ionic: Add async link status check and basic stats
Date:   Mon, 22 Jul 2019 14:40:16 -0700
Message-Id: <20190722214023.9513-13-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190722214023.9513-1-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
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

