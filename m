Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D927A4DB29
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 22:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfFTUZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 16:25:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35312 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbfFTUYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 16:24:43 -0400
Received: by mail-pg1-f194.google.com with SMTP id s27so2170741pgl.2
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 13:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=EF6gJU7CSRKEJzGMa8AldmctROxdKmv3LtpAFh4o74o=;
        b=f2BP7xEvY5ReOXsLpQXkj8AviJkgugRqt3YH8DsLBMuo0drPMcLzQLBq63J9sKltRp
         5hTNIwEd7CTyVj+4B7TGuQsrX2cTuelKExa3TgRBT46BYZ+nvzcDi6ae/iH/jr8RviFF
         nETsqAAZ0A1Kmuw+fHfwNJo+MhwkCYei18fX03ojPj+rOTEsYWQDoasIQ79xnGFu3Zz/
         41fqNmnsWxWvGsLo8M9mAacx/a0sSeuZhxG/mIJxYkBGwLfC8z+Y8bsZV47Cr7XxYNfd
         gMUFnOoWi0q1nevkl7i0IoParZgb+BdiDD1HNy+F9XD3aK1xP8Qf1Q05ywz6ugZXvSxe
         AuJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=EF6gJU7CSRKEJzGMa8AldmctROxdKmv3LtpAFh4o74o=;
        b=q5fdyt2YdcGx+XDFzH6e5+OAGOlJa+GZsF6ghC96hkgmtKsx9iR74pK88Io9dEqE6u
         6C8nXeG/GRfjF/H0W/mCKVcMSSSBba++T2C8sucEqR4cm0EEZww1MSQC9k7cVyq5nZ0g
         jHYbBcugfmKeP58Mg3Ew2X7Q22o9PIJzAOYTyfAQsua6Z4KXL5Ow2304IkIqCfoGdNp+
         XWhDWniccuSTXzmBKEmAW+slE+0xKUeoz6UnM8wJu81cu1GqX8FtqtCwcGJpmOTCoMb5
         dmGlmRV2VWetCXqbktwqdt9QDPvzY4Gq2ZnzQjnXHs60S+dTwiNL/aMkB28wTg1LlAUu
         yoUw==
X-Gm-Message-State: APjAAAU5QoR6zxXW/BQiCsTzmy/Sm7OnxLOGntgO8K8rGn2KtoI+YNFR
        X/S1WfJ2Yk7cc9PK7J7987H+dEtAtmc=
X-Google-Smtp-Source: APXvYqwarLdfQYNfcmk7L2CF0RQieNglUcn4gLVEwdsgAhcP0cH2HmWnHPpWGmzfnIFXTrUUFt5S5w==
X-Received: by 2002:a62:6083:: with SMTP id u125mr4931394pfb.208.1561062281990;
        Thu, 20 Jun 2019 13:24:41 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id h26sm340537pfq.64.2019.06.20.13.24.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 13:24:41 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH net-next 12/18] ionic: Add async link status check and basic stats
Date:   Thu, 20 Jun 2019 13:24:18 -0700
Message-Id: <20190620202424.23215-13-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620202424.23215-1-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add code to handle the link status event, and wire up the
basic netdev hardware stats.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 117 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   1 +
 2 files changed, 118 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index fa48648b68b7..8bf865f50054 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -15,6 +15,7 @@
 static void ionic_lif_rx_mode(struct lif *lif, unsigned int rx_mode);
 static int ionic_lif_addr_add(struct lif *lif, const u8 *addr);
 static int ionic_lif_addr_del(struct lif *lif, const u8 *addr);
+static void ionic_link_status_check(struct lif *lif);
 
 static int ionic_set_nic_features(struct lif *lif, netdev_features_t features);
 static int ionic_notifyq_clean(struct lif *lif, int budget);
@@ -43,6 +44,9 @@ static void ionic_lif_deferred_work(struct work_struct *work)
 		case DW_TYPE_RX_ADDR_DEL:
 			ionic_lif_addr_del(lif, w->addr);
 			break;
+		case DW_TYPE_LINK_STATUS:
+			ionic_link_status_check(lif);
+			break;
 		default:
 			break;
 		};
@@ -68,6 +72,7 @@ int ionic_open(struct net_device *netdev)
 
 	set_bit(LIF_UP, lif->state);
 
+	ionic_link_status_check(lif);
 	if (netif_carrier_ok(netdev))
 		netif_tx_wake_all_queues(netdev);
 
@@ -150,6 +155,40 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
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
+	if ((link_up && netif_carrier_ok(netdev)) ||
+	    (!link_up && !netif_carrier_ok(netdev)))
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
@@ -181,6 +220,9 @@ static bool ionic_notifyq_service(struct cq *cq, struct cq_info *cq_info)
 			    "  link_status=%d link_speed=%d\n",
 			    le16_to_cpu(comp->link_change.link_status),
 			    le32_to_cpu(comp->link_change.link_speed));
+
+		set_bit(LIF_LINK_CHECK_NEEDED, lif->state);
+
 		break;
 	case EVENT_OPCODE_RESET:
 		netdev_info(netdev, "Notifyq EVENT_OPCODE_RESET eid=%lld\n",
@@ -225,10 +267,81 @@ static int ionic_notifyq_clean(struct lif *lif, int budget)
 	if (work_done == budget)
 		goto return_to_napi;
 
+	/* After outstanding events are processed we can check on
+	 * the link status and any outstanding interrupt credits.
+	 *
+	 * We wait until here to check on the link status in case
+	 * there was a long list of link events from a flap episode.
+	 */
+	if (test_bit(LIF_LINK_CHECK_NEEDED, lif->state)) {
+		struct deferred_work *work;
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
@@ -594,6 +707,7 @@ static int ionic_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto,
 static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_open               = ionic_open,
 	.ndo_stop               = ionic_stop,
+	.ndo_get_stats64	= ionic_get_stats64,
 	.ndo_set_rx_mode	= ionic_set_rx_mode,
 	.ndo_set_features	= ionic_set_features,
 	.ndo_set_mac_address	= ionic_set_mac_address,
@@ -1442,6 +1556,8 @@ static int ionic_lif_init(struct lif *lif)
 
 	set_bit(LIF_INITED, lif->state);
 
+	ionic_link_status_check(lif);
+
 	return 0;
 
 err_out_notifyq_deinit:
@@ -1485,6 +1601,7 @@ int ionic_lifs_register(struct ionic *ionic)
 		return err;
 	}
 
+	ionic_link_status_check(ionic->master_lif);
 	ionic->master_lif->registered = true;
 
 	return 0;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index c3ecf1df9c2c..efe680da9a5c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -86,6 +86,7 @@ struct deferred {
 enum lif_state_flags {
 	LIF_INITED,
 	LIF_UP,
+	LIF_LINK_CHECK_NEEDED,
 	LIF_QUEUE_RESET,
 
 	/* leave this as last */
-- 
2.17.1

