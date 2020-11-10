Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E70D2AE020
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 20:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731718AbgKJTv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 14:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731613AbgKJTv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 14:51:26 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B41BC0613D1;
        Tue, 10 Nov 2020 11:51:25 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id dk16so19316300ejb.12;
        Tue, 10 Nov 2020 11:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=NhuUAeR80nfEeuMWJO9rn2BTncFH7te01FW54NzBpW0=;
        b=l/9jHpoHkxGjhxxpoLcIKUhaM62UhbllNGha4Jm9H0CxXCyZ7VxrOaAXcYQBMQVs4Z
         wee+8QCMDvxlTW8MaZ3vhgJtZ+jIaX5l8r8uyMjoGC36JvWiVLZVrRz39iBl3+xcc0yT
         e4saa3KkL7D9WjH7PRS0T3i2hA8T9sEk8wSdp/xpkDGkmkVGe8Cn5Eo0cxgbKILFsPWV
         77zvKw49H9JN5zE4xPPas8ackvvroVMSyVm1u6ij+WWfVAW4ANxwKI3A3T1uUvJhTGWE
         bE3R/GL75W4oe/NfCzxHFvI6EulHbtdTrKnTjGngPNoi3awQqt++LDA83+vSuQHqVbdx
         lePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=NhuUAeR80nfEeuMWJO9rn2BTncFH7te01FW54NzBpW0=;
        b=fRSudPqsL0Gmb6X+ieL3Giw2xia+37m3xMcI0j26nkDRIH6TpAOgOOmZQdehFdx/Kw
         eAoAGg+PsaGrU9Q0HUU8V44upKIWsoctSFeNi5ifpeD0j/4+HUfD2F1EwnCi3+rWPYg3
         Y0GgfkNC5vM0dfICYF7zP90NczR4C8hHZk188/J35VAzYn1e/e6zvD78F12EZZRN3W89
         GDwONrPyYZXYdIgf4AzwVk67S7za6gwA1kBT87mBxwloaMga6mxpSiV9jHfKMk+sZ/aV
         djLSEq8WOBvx9If+f48jpHaZJ6wjPmyYBxKKnbB+GrtcZELCFujpuHfVkzmcH7egPeII
         96bQ==
X-Gm-Message-State: AOAM532g4zmShHBnE4pKWkxFnN97yj+st5tRwwuEtZ4DKsrinU8RtEwx
        DZ2igBl5wBwiBWhlK4iUpQgRqxMAc/N4Hw==
X-Google-Smtp-Source: ABdhPJwA3v9bN4hBcNPA/ZTQbFo4nEiwQ73RwBaMXlDzRloJblYJEK+RYKsMLYx6DUR+0k5Ww8Q9Dg==
X-Received: by 2002:a17:906:6949:: with SMTP id c9mr21671485ejs.482.1605037883883;
        Tue, 10 Nov 2020 11:51:23 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:895e:e59d:3602:de4b? (p200300ea8f232800895ee59d3602de4b.dip0.t-ipconnect.de. [2003:ea:8f23:2800:895e:e59d:3602:de4b])
        by smtp.googlemail.com with ESMTPSA id l20sm11104664eja.40.2020.11.10.11.51.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 11:51:23 -0800 (PST)
Subject: [PATCH net-next 3/5] qtnfmac: switch to core handling of rx/tx
 byte/packet counters
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Oliver Neukum <oneukum@suse.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
Message-ID: <4b22c155-6868-793f-ebfe-f797e16b9c40@gmail.com>
Date:   Tue, 10 Nov 2020 20:48:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev->tstats instead of a member of qtnf_vif for storing a pointer
to the per-cpu counters. This allows us to use core functionality for
statistics handling.
The driver sets netdev->needs_free_netdev, therefore freeing the per-cpu
counters at the right point in time is a little bit tricky. Best option
seems to be to use the ndo_init/ndo_uninit callbacks.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/wireless/quantenna/qtnfmac/core.c | 78 ++++---------------
 drivers/net/wireless/quantenna/qtnfmac/core.h |  4 -
 .../quantenna/qtnfmac/pcie/pearl_pcie.c       |  4 +-
 .../quantenna/qtnfmac/pcie/topaz_pcie.c       |  4 +-
 4 files changed, 20 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index bf6dbeb61..ad726bd10 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -126,28 +126,13 @@ qtnf_netdev_hard_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	if (unlikely(skb->protocol == htons(ETH_P_PAE))) {
 		qtnf_packet_send_hi_pri(skb);
-		qtnf_update_tx_stats(ndev, skb);
+		dev_sw_netstats_tx_add(ndev, 1, skb->len);
 		return NETDEV_TX_OK;
 	}
 
 	return qtnf_bus_data_tx(mac->bus, skb, mac->macid, vif->vifid);
 }
 
-/* Netdev handler for getting stats.
- */
-static void qtnf_netdev_get_stats64(struct net_device *ndev,
-				    struct rtnl_link_stats64 *stats)
-{
-	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
-
-	netdev_stats_to_stats64(stats, &ndev->stats);
-
-	if (!vif->stats64)
-		return;
-
-	dev_fetch_sw_netstats(stats, vif->stats64);
-}
-
 /* Netdev handler for transmission timeout.
  */
 static void qtnf_netdev_tx_timeout(struct net_device *ndev, unsigned int txqueue)
@@ -211,13 +196,27 @@ static int qtnf_netdev_port_parent_id(struct net_device *ndev,
 	return 0;
 }
 
+static int qtnf_netdev_alloc_pcpu_stats(struct net_device *dev)
+{
+	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+
+	return dev->tstats ? 0 : -ENOMEM;
+}
+
+static void qtnf_netdev_free_pcpu_stats(struct net_device *dev)
+{
+	free_percpu(dev->tstats);
+}
+
 /* Network device ops handlers */
 const struct net_device_ops qtnf_netdev_ops = {
+	.ndo_init = qtnf_netdev_alloc_pcpu_stats,
+	.ndo_uninit = qtnf_netdev_free_pcpu_stats,
 	.ndo_open = qtnf_netdev_open,
 	.ndo_stop = qtnf_netdev_close,
 	.ndo_start_xmit = qtnf_netdev_hard_start_xmit,
 	.ndo_tx_timeout = qtnf_netdev_tx_timeout,
-	.ndo_get_stats64 = qtnf_netdev_get_stats64,
+	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_set_mac_address = qtnf_netdev_set_mac_address,
 	.ndo_get_port_parent_id = qtnf_netdev_port_parent_id,
 };
@@ -448,10 +447,6 @@ static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus,
 		qtnf_sta_list_init(&vif->sta_list);
 		INIT_WORK(&vif->high_pri_tx_work, qtnf_vif_send_data_high_pri);
 		skb_queue_head_init(&vif->high_pri_tx_queue);
-		vif->stats64 = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
-		if (!vif->stats64)
-			pr_warn("VIF%u.%u: per cpu stats allocation failed\n",
-				macid, i);
 	}
 
 	qtnf_mac_init_primary_intf(mac);
@@ -531,7 +526,6 @@ static void qtnf_core_mac_detach(struct qtnf_bus *bus, unsigned int macid)
 		}
 		rtnl_unlock();
 		qtnf_sta_list_free(&vif->sta_list);
-		free_percpu(vif->stats64);
 	}
 
 	if (mac->wiphy_registered)
@@ -924,46 +918,6 @@ void qtnf_wake_all_queues(struct net_device *ndev)
 }
 EXPORT_SYMBOL_GPL(qtnf_wake_all_queues);
 
-void qtnf_update_rx_stats(struct net_device *ndev, const struct sk_buff *skb)
-{
-	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
-	struct pcpu_sw_netstats *stats64;
-
-	if (unlikely(!vif || !vif->stats64)) {
-		ndev->stats.rx_packets++;
-		ndev->stats.rx_bytes += skb->len;
-		return;
-	}
-
-	stats64 = this_cpu_ptr(vif->stats64);
-
-	u64_stats_update_begin(&stats64->syncp);
-	stats64->rx_packets++;
-	stats64->rx_bytes += skb->len;
-	u64_stats_update_end(&stats64->syncp);
-}
-EXPORT_SYMBOL_GPL(qtnf_update_rx_stats);
-
-void qtnf_update_tx_stats(struct net_device *ndev, const struct sk_buff *skb)
-{
-	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
-	struct pcpu_sw_netstats *stats64;
-
-	if (unlikely(!vif || !vif->stats64)) {
-		ndev->stats.tx_packets++;
-		ndev->stats.tx_bytes += skb->len;
-		return;
-	}
-
-	stats64 = this_cpu_ptr(vif->stats64);
-
-	u64_stats_update_begin(&stats64->syncp);
-	stats64->tx_packets++;
-	stats64->tx_bytes += skb->len;
-	u64_stats_update_end(&stats64->syncp);
-}
-EXPORT_SYMBOL_GPL(qtnf_update_tx_stats);
-
 struct dentry *qtnf_get_debugfs_dir(void)
 {
 	return qtnf_debugfs_dir;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 269ce12cf..b204a2407 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -70,8 +70,6 @@ struct qtnf_vif {
 	struct qtnf_sta_list sta_list;
 	unsigned long cons_tx_timeout_cnt;
 	int generation;
-
-	struct pcpu_sw_netstats __percpu *stats64;
 };
 
 struct qtnf_mac_info {
@@ -139,8 +137,6 @@ int qtnf_cmd_send_update_phy_params(struct qtnf_wmac *mac, u32 changed);
 struct qtnf_wmac *qtnf_core_get_mac(const struct qtnf_bus *bus, u8 macid);
 struct net_device *qtnf_classify_skb(struct qtnf_bus *bus, struct sk_buff *skb);
 void qtnf_wake_all_queues(struct net_device *ndev);
-void qtnf_update_rx_stats(struct net_device *ndev, const struct sk_buff *skb);
-void qtnf_update_tx_stats(struct net_device *ndev, const struct sk_buff *skb);
 
 void qtnf_virtual_intf_cleanup(struct net_device *ndev);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 9a20c0f29..0003df577 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -489,7 +489,7 @@ static void qtnf_pearl_data_tx_reclaim(struct qtnf_pcie_pearl_state *ps)
 					 PCI_DMA_TODEVICE);
 
 			if (skb->dev) {
-				qtnf_update_tx_stats(skb->dev, skb);
+				dev_sw_netstats_tx_add(skb->dev, 1, skb->len);
 				if (unlikely(priv->tx_stopped)) {
 					qtnf_wake_all_queues(skb->dev);
 					priv->tx_stopped = 0;
@@ -756,7 +756,7 @@ static int qtnf_pcie_pearl_rx_poll(struct napi_struct *napi, int budget)
 			skb_put(skb, psize);
 			ndev = qtnf_classify_skb(bus, skb);
 			if (likely(ndev)) {
-				qtnf_update_rx_stats(ndev, skb);
+				dev_sw_netstats_rx_add(ndev, skb->len);
 				skb->protocol = eth_type_trans(skb, ndev);
 				napi_gro_receive(napi, skb);
 			} else {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
index 4b87d3151..24f1be8dd 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
@@ -418,7 +418,7 @@ static void qtnf_topaz_data_tx_reclaim(struct qtnf_pcie_topaz_state *ts)
 					 PCI_DMA_TODEVICE);
 
 			if (skb->dev) {
-				qtnf_update_tx_stats(skb->dev, skb);
+				dev_sw_netstats_tx_add(skb->dev, 1, skb->len);
 				if (unlikely(priv->tx_stopped)) {
 					qtnf_wake_all_queues(skb->dev);
 					priv->tx_stopped = 0;
@@ -662,7 +662,7 @@ static int qtnf_topaz_rx_poll(struct napi_struct *napi, int budget)
 			skb_put(skb, psize);
 			ndev = qtnf_classify_skb(bus, skb);
 			if (likely(ndev)) {
-				qtnf_update_rx_stats(ndev, skb);
+				dev_sw_netstats_rx_add(ndev, skb->len);
 				skb->protocol = eth_type_trans(skb, ndev);
 				netif_receive_skb(skb);
 			} else {
-- 
2.29.2


