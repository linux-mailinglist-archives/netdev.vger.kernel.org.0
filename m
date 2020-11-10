Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6592AE019
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 20:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbgKJTvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 14:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgKJTvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 14:51:22 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403FEC0613D1;
        Tue, 10 Nov 2020 11:51:22 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id k9so14104996edo.5;
        Tue, 10 Nov 2020 11:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=bOdWylhtQ7csIcx3x7AgcGPRiivjTYceou3ldTAJsAs=;
        b=YeBxn6BCTsEDT2K3jc2JwEBRjqhWJ4MxrIdcqijDmpwNxmHZjSSoL1c7tNj79zov0u
         jGcdzUbaafpV+7md60rfV7XhBJ0spqnBGkFLNbS1urJ9tR5zo1lrzsKH3lR32S+6v2ev
         4aWuKJw5QZP15QpGRBfS0Q2NJtJhg+Hv9dAl0MPJr2BAlO4gqfRv9BlI/oj04n0I51C3
         gV2CQ8oWuZ/3aRAo/kbS2hRju9wCOxa59FFjJ2cXwvJyKHfTrrKtn+ECQTYbBmk6DYlL
         TCjnVxgxtu99AAuOb5XdESLmFIYghJawyJhELlyKn+XWUXg8PQgVPF/Lwn9hCTt977GC
         pHoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=bOdWylhtQ7csIcx3x7AgcGPRiivjTYceou3ldTAJsAs=;
        b=GdyfFJsoiV/9vuvsYXj8qV+9tzIFlRFzEK4w1yWeypSB/5W1ctIkYgKTKtwRwVspQb
         JzLKIfsSwqVTan42Uk23gCZ/nyGQbIl033RLVpjC2bTHUMRIEaKu4Dc2zizGfU5YvUSz
         5hx5e2TvKLHKXiQV2u8m6jnDr+b46HXw09g98Vfv0kLdnpRKZO4FHgH/bxdgAxJrtvnH
         5IkQJ0iTjSoPB7nJ1oB+nqCFzFVAbJcPVdS1iWPPTrAjN2gV6oCK/PtdXCss3y4GJvg2
         AIELCfxUlUCvRqePEbbEJPyRtRqza9v81z3TlEdSPtcaIFR03dTpSnFweel8sOGUd6ba
         kAYQ==
X-Gm-Message-State: AOAM530OrErErBHpJ1XR1kLNoaVtJDX/x9P7qQDdNuqVCuzDl9Xrh37F
        9lzVHtemob8f6E8Ak1RGOnutRAfeund+yw==
X-Google-Smtp-Source: ABdhPJxk7DTsgCEZiCcDHIK6P7rRocDMeZD9EY8ECUBsYZPrhDfIBIbmqWIZBZNqp8eLRr7R6QyMEQ==
X-Received: by 2002:a05:6402:31b6:: with SMTP id dj22mr23495415edb.348.1605037880671;
        Tue, 10 Nov 2020 11:51:20 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:895e:e59d:3602:de4b? (p200300ea8f232800895ee59d3602de4b.dip0.t-ipconnect.de. [2003:ea:8f23:2800:895e:e59d:3602:de4b])
        by smtp.googlemail.com with ESMTPSA id a1sm11311622edv.88.2020.11.10.11.51.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 11:51:20 -0800 (PST)
Subject: [PATCH net-next 1/5] IB/hfi1: switch to core handling of rx/tx
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
Message-ID: <5093239e-2d3b-a716-3039-790abdb7a5ba@gmail.com>
Date:   Tue, 10 Nov 2020 20:47:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev->tstats instead of a member of hfi1_ipoib_dev_priv for storing
a pointer to the per-cpu counters. This allows us to use core
functionality for statistics handling.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/infiniband/hw/hfi1/driver.c     |  4 +---
 drivers/infiniband/hw/hfi1/ipoib.h      | 27 -------------------------
 drivers/infiniband/hw/hfi1/ipoib_main.c | 15 +++-----------
 drivers/infiniband/hw/hfi1/ipoib_tx.c   |  2 +-
 4 files changed, 5 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index a40701a6e..0b64aa87a 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -1686,7 +1686,6 @@ static void hfi1_ipoib_ib_rcv(struct hfi1_packet *packet)
 	u32 extra_bytes;
 	u32 tlen, qpnum;
 	bool do_work, do_cnp;
-	struct hfi1_ipoib_dev_priv *priv;
 
 	trace_hfi1_rcvhdr(packet);
 
@@ -1734,8 +1733,7 @@ static void hfi1_ipoib_ib_rcv(struct hfi1_packet *packet)
 	if (unlikely(!skb))
 		goto drop;
 
-	priv = hfi1_ipoib_priv(netdev);
-	hfi1_ipoib_update_rx_netstats(priv, 1, skb->len);
+	dev_sw_netstats_rx_add(netdev, skb->len);
 
 	skb->dev = netdev;
 	skb->pkt_type = PACKET_HOST;
diff --git a/drivers/infiniband/hw/hfi1/ipoib.h b/drivers/infiniband/hw/hfi1/ipoib.h
index b8c9d0a00..f650cac9d 100644
--- a/drivers/infiniband/hw/hfi1/ipoib.h
+++ b/drivers/infiniband/hw/hfi1/ipoib.h
@@ -110,7 +110,6 @@ struct hfi1_ipoib_dev_priv {
 
 	const struct net_device_ops *netdev_ops;
 	struct rvt_qp *qp;
-	struct pcpu_sw_netstats __percpu *netstats;
 };
 
 /* hfi1 ipoib rdma netdev's private data structure */
@@ -126,32 +125,6 @@ hfi1_ipoib_priv(const struct net_device *dev)
 	return &((struct hfi1_ipoib_rdma_netdev *)netdev_priv(dev))->dev_priv;
 }
 
-static inline void
-hfi1_ipoib_update_rx_netstats(struct hfi1_ipoib_dev_priv *priv,
-			      u64 packets,
-			      u64 bytes)
-{
-	struct pcpu_sw_netstats *netstats = this_cpu_ptr(priv->netstats);
-
-	u64_stats_update_begin(&netstats->syncp);
-	netstats->rx_packets += packets;
-	netstats->rx_bytes += bytes;
-	u64_stats_update_end(&netstats->syncp);
-}
-
-static inline void
-hfi1_ipoib_update_tx_netstats(struct hfi1_ipoib_dev_priv *priv,
-			      u64 packets,
-			      u64 bytes)
-{
-	struct pcpu_sw_netstats *netstats = this_cpu_ptr(priv->netstats);
-
-	u64_stats_update_begin(&netstats->syncp);
-	netstats->tx_packets += packets;
-	netstats->tx_bytes += bytes;
-	u64_stats_update_end(&netstats->syncp);
-}
-
 int hfi1_ipoib_send_dma(struct net_device *dev,
 			struct sk_buff *skb,
 			struct ib_ah *address,
diff --git a/drivers/infiniband/hw/hfi1/ipoib_main.c b/drivers/infiniband/hw/hfi1/ipoib_main.c
index 9f71b9d70..3242290eb 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_main.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_main.c
@@ -21,7 +21,7 @@ static int hfi1_ipoib_dev_init(struct net_device *dev)
 	struct hfi1_ipoib_dev_priv *priv = hfi1_ipoib_priv(dev);
 	int ret;
 
-	priv->netstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 
 	ret = priv->netdev_ops->ndo_init(dev);
 	if (ret)
@@ -93,21 +93,12 @@ static int hfi1_ipoib_dev_stop(struct net_device *dev)
 	return priv->netdev_ops->ndo_stop(dev);
 }
 
-static void hfi1_ipoib_dev_get_stats64(struct net_device *dev,
-				       struct rtnl_link_stats64 *storage)
-{
-	struct hfi1_ipoib_dev_priv *priv = hfi1_ipoib_priv(dev);
-
-	netdev_stats_to_stats64(storage, &dev->stats);
-	dev_fetch_sw_netstats(storage, priv->netstats);
-}
-
 static const struct net_device_ops hfi1_ipoib_netdev_ops = {
 	.ndo_init         = hfi1_ipoib_dev_init,
 	.ndo_uninit       = hfi1_ipoib_dev_uninit,
 	.ndo_open         = hfi1_ipoib_dev_open,
 	.ndo_stop         = hfi1_ipoib_dev_stop,
-	.ndo_get_stats64  = hfi1_ipoib_dev_get_stats64,
+	.ndo_get_stats64  = dev_get_tstats64,
 };
 
 static int hfi1_ipoib_send(struct net_device *dev,
@@ -182,7 +173,7 @@ static void hfi1_ipoib_netdev_dtor(struct net_device *dev)
 	hfi1_ipoib_txreq_deinit(priv);
 	hfi1_ipoib_rxq_deinit(priv->netdev);
 
-	free_percpu(priv->netstats);
+	free_percpu(dev->tstats);
 }
 
 static void hfi1_ipoib_free_rdma_netdev(struct net_device *dev)
diff --git a/drivers/infiniband/hw/hfi1/ipoib_tx.c b/drivers/infiniband/hw/hfi1/ipoib_tx.c
index 9df292b51..edd4eeac8 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_tx.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_tx.c
@@ -121,7 +121,7 @@ static void hfi1_ipoib_free_tx(struct ipoib_txreq *tx, int budget)
 	struct hfi1_ipoib_dev_priv *priv = tx->priv;
 
 	if (likely(!tx->sdma_status)) {
-		hfi1_ipoib_update_tx_netstats(priv, 1, tx->skb->len);
+		dev_sw_netstats_tx_add(priv->netdev, 1, tx->skb->len);
 	} else {
 		++priv->netdev->stats.tx_errors;
 		dd_dev_warn(priv->dd,
-- 
2.29.2


