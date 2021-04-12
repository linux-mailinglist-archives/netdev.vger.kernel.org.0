Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D023A35B7CA
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbhDLAig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:38:36 -0400
Received: from mail-ej1-f51.google.com ([209.85.218.51]:42681 "EHLO
        mail-ej1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235954AbhDLAif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 20:38:35 -0400
Received: by mail-ej1-f51.google.com with SMTP id w23so1600784ejb.9;
        Sun, 11 Apr 2021 17:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DDbc5FmzHKr0w0Z3HFFTz8b2RE4508dazUI9Yvq07CI=;
        b=GeCCmAId1bQ8goXLozAnZqlj8tTdfuHTG6sB3nf91F4OpNjspq0PvGzpGKa/uFeM5e
         OUg8kz/PgLn42KzTsjxN71it4rWNQ0O4RhKh37t/2rp8DJCqQ/ZbDg+iJjhvIx5n/lOG
         OQlsoI2ezR2MyWOW5KYCBLkDByhqme4QjHJidF8kxULfU1U1ttNComv91Irljo7kUonJ
         HKJXKhiCczdPQWpQK5DZDfE5A88e4jNzJXZ8Yc811ygwaiYfO3ZAHMGis8nIrXh5J19M
         1z4+zw+xDIQ4KFKRmeM5NJnhze/P8yINk/EqUYMC0oSuxdDZiS3p1Qsy2fEqqEx4Ncq5
         gSAg==
X-Gm-Message-State: AOAM531/L5Lrgx8W7/2VrYa385POY92n4uIbuV5GTJkrLlpRLBfyZrjR
        zbq6wQRa84K85WkfaXlbkAP+Vj8zmwg=
X-Google-Smtp-Source: ABdhPJxcgBJDrT8M/Q/cfhVmhBRQoFuPb5PWyaRH30b1pGhguRSnSt9RoQFQ6HbOZxh95UemC3bJew==
X-Received: by 2002:a17:906:af09:: with SMTP id lx9mr25806246ejb.58.1618187896838;
        Sun, 11 Apr 2021 17:38:16 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-93-66-21-119.cust.vodafonedsl.it. [93.66.21.119])
        by smtp.gmail.com with ESMTPSA id a9sm5477837eds.33.2021.04.11.17.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 17:38:16 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH net-next v2 2/3] net: use skb_for_each_frag() helper where possible
Date:   Mon, 12 Apr 2021 02:38:01 +0200
Message-Id: <20210412003802.51613-3-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412003802.51613-1-mcroce@linux.microsoft.com>
References: <20210412003802.51613-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

use the new helper macro skb_for_each_frag() which allows to iterate
through all the SKB fragments.

The patch was created with Coccinelle, this was the semantic patch:

@@
struct sk_buff *skb;
identifier i;
statement S;
iterator name skb_for_each_frag;
@@
-for (i = 0; i < skb_shinfo(skb)->nr_frags; \(++i\|i++\))
+skb_for_each_frag(skb, i)
 S
@@
struct skb_shared_info *sinfo;
struct sk_buff *skb;
identifier i;
statement S;
iterator name skb_for_each_frag;
@@
 sinfo = skb_shinfo(skb)
 ...
-for (i = 0; i < sinfo->nr_frags; \(++i\|i++\))
+skb_for_each_frag(skb, i)
 S

Tested with an allmodconfig W=1 build and a test run.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/atm/he.c                              |  2 +-
 drivers/hsi/clients/ssi_protocol.c            |  2 +-
 drivers/infiniband/hw/hfi1/ipoib_tx.c         |  2 +-
 drivers/infiniband/hw/hfi1/vnic_sdma.c        |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c       |  4 +--
 drivers/net/ethernet/3com/3c59x.c             |  2 +-
 drivers/net/ethernet/3com/typhoon.c           |  2 +-
 drivers/net/ethernet/adaptec/starfire.c       |  2 +-
 drivers/net/ethernet/aeroflex/greth.c         |  2 +-
 drivers/net/ethernet/alteon/acenic.c          |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c     |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  2 +-
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  2 +-
 drivers/net/ethernet/atheros/alx/main.c       |  2 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  2 +-
 drivers/net/ethernet/broadcom/tg3.c           |  2 +-
 .../ethernet/cavium/thunder/nicvf_queues.c    |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  2 +-
 drivers/net/ethernet/freescale/gianfar.c      |  3 +-
 drivers/net/ethernet/google/gve/gve_tx.c      |  2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  4 +--
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  4 +--
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  4 +--
 drivers/net/ethernet/ibm/ibmveth.c            |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c            |  2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |  2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c     |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  2 +-
 drivers/net/ethernet/marvell/skge.c           |  2 +-
 drivers/net/ethernet/marvell/sky2.c           |  8 ++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  2 +-
 drivers/net/ethernet/realtek/8139cp.c         |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  2 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  2 +-
 drivers/net/ethernet/sfc/tx.c                 |  2 +-
 drivers/net/ethernet/sun/niu.c                |  4 +--
 drivers/net/ethernet/sun/sungem.c             |  2 +-
 drivers/net/ethernet/sun/sunhme.c             |  2 +-
 drivers/net/ethernet/sun/sunvnet_common.c     |  4 +--
 .../net/ethernet/synopsys/dwc-xlgmac-desc.c   |  2 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/ethernet/ti/netcp_core.c          |  2 +-
 drivers/net/ethernet/via/via-velocity.c       |  2 +-
 drivers/net/usb/usbnet.c                      |  2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c             |  4 +--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.c |  2 +-
 drivers/net/xen-netback/netback.c             |  2 +-
 drivers/net/xen-netfront.c                    |  2 +-
 drivers/s390/net/qeth_core_main.c             |  4 +--
 drivers/scsi/fcoe/fcoe_transport.c            |  2 +-
 drivers/staging/octeon/ethernet-tx.c          |  2 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c   |  4 +--
 net/appletalk/ddp.c                           |  2 +-
 net/core/datagram.c                           |  4 +--
 net/core/skbuff.c                             | 32 +++++++++----------
 net/ipv4/inet_fragment.c                      |  2 +-
 net/ipv4/tcp.c                                |  2 +-
 net/ipv4/tcp_output.c                         |  2 +-
 net/iucv/af_iucv.c                            |  4 +--
 net/kcm/kcmsock.c                             |  3 +-
 net/tls/tls_sw.c                              |  2 +-
 74 files changed, 103 insertions(+), 105 deletions(-)

diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index 17f44abc9418..2e606e255f7c 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -2556,7 +2556,7 @@ he_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	tpd->iovec[slot].len = skb_headlen(skb);
 	++slot;
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		if (slot == TPD_MAXIOV) {	/* queue tpd; start new tpd */
diff --git a/drivers/hsi/clients/ssi_protocol.c b/drivers/hsi/clients/ssi_protocol.c
index 96d0eccca3aa..c697efd22cce 100644
--- a/drivers/hsi/clients/ssi_protocol.c
+++ b/drivers/hsi/clients/ssi_protocol.c
@@ -177,7 +177,7 @@ static void ssip_skb_to_msg(struct sk_buff *skb, struct hsi_msg *msg)
 
 	sg = msg->sgt.sgl;
 	sg_set_buf(sg, skb->data, skb_headlen(skb));
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		sg = sg_next(sg);
 		BUG_ON(!sg);
 		frag = &skb_shinfo(skb)->frags[i];
diff --git a/drivers/infiniband/hw/hfi1/ipoib_tx.c b/drivers/infiniband/hw/hfi1/ipoib_tx.c
index edd4eeac8dd1..b3f1c529e7ca 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_tx.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_tx.c
@@ -240,7 +240,7 @@ static int hfi1_ipoib_build_ulp_payload(struct ipoib_txreq *tx,
 			return ret;
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		ret = sdma_txadd_page(dd,
diff --git a/drivers/infiniband/hw/hfi1/vnic_sdma.c b/drivers/infiniband/hw/hfi1/vnic_sdma.c
index 7d90b900131b..dbdf3bc2ba2b 100644
--- a/drivers/infiniband/hw/hfi1/vnic_sdma.c
+++ b/drivers/infiniband/hw/hfi1/vnic_sdma.c
@@ -101,7 +101,7 @@ static noinline int build_vnic_ulp_payload(struct sdma_engine *sde,
 	if (unlikely(ret))
 		goto bail_txadd;
 
-	for (i = 0; i < skb_shinfo(tx->skb)->nr_frags; i++) {
+	skb_for_each_frag(tx->skb, i) {
 		skb_frag_t *frag = &skb_shinfo(tx->skb)->frags[i];
 
 		/* combine physically continuous fragments later? */
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 494f413dc3c6..92636ac68a86 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -289,7 +289,7 @@ int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf *tx_req)
 	} else
 		off = 0;
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; ++i) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		mapping[i + off] = ib_dma_map_page(ca,
 						 skb_frag_page(frag),
@@ -329,7 +329,7 @@ void ipoib_dma_unmap_tx(struct ipoib_dev_priv *priv,
 	} else
 		off = 0;
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; ++i) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		ib_dma_unmap_page(priv->ca, mapping[i + off],
diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 741c67e546d4..aadf232bd18f 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -2168,7 +2168,7 @@ boomerang_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		vp->tx_ring[entry].frag[0].addr = cpu_to_le32(dma_addr);
 		vp->tx_ring[entry].frag[0].length = cpu_to_le32(skb_headlen(skb));
 
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_for_each_frag(skb, i) {
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 			dma_addr = skb_frag_dma_map(vp->gendev, frag,
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 05e15b6e5e2c..f0f0c0135fa7 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -808,7 +808,7 @@ typhoon_start_tx(struct sk_buff *skb, struct net_device *dev)
 		txd->frag.addrHi = 0;
 		first_txd->numDesc++;
 
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_for_each_frag(skb, i) {
 			const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 			void *frag_addr;
 
diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index 555299737b51..7563bd3c4c72 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -1368,7 +1368,7 @@ static irqreturn_t intr_handler(int irq, void *dev_instance)
 				entry = (entry + np->tx_info[entry].used_slots) % TX_RING_SIZE;
 				{
 					int i;
-					for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+					skb_for_each_frag(skb, i) {
 						dma_unmap_single(&np->pci_dev->dev,
 								 np->tx_info[entry].mapping,
 								 skb_frag_size(&skb_shinfo(skb)->frags[i]),
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 9c5891bbfe61..b59a9606e02b 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -106,7 +106,7 @@ static void greth_print_tx_packet(struct sk_buff *skb)
 	print_hex_dump(KERN_DEBUG, "TX: ", DUMP_PREFIX_OFFSET, 16, 1,
 			skb->data, length, true);
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 
 		print_hex_dump(KERN_DEBUG, "TX: ", DUMP_PREFIX_OFFSET, 16, 1,
 			       skb_frag_address(&skb_shinfo(skb)->frags[i]),
diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 1a7e4df9b3e9..6607ba3b5b50 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -2453,7 +2453,7 @@ static netdev_tx_t ace_start_xmit(struct sk_buff *skb,
 
 		idx = (idx + 1) % ACE_TX_RING_ENTRIES(ap);
 
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_for_each_frag(skb, i) {
 			const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 			struct tx_ring_info *info;
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-desc.c b/drivers/net/ethernet/amd/xgbe/xgbe-desc.c
index 230726d7b74f..9e496fe32ec6 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-desc.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-desc.c
@@ -600,7 +600,7 @@ static int xgbe_map_tx_skb(struct xgbe_channel *channel, struct sk_buff *skb)
 		rdata = XGBE_GET_DESC_DATA(ring, cur_index);
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		netif_dbg(pdata, tx_queued, pdata->netdev,
 			  "mapping frag %u\n", i);
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 4f714f874c4f..903947971d19 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1806,7 +1806,7 @@ static void xgbe_packet_info(struct xgbe_prv_data *pdata,
 		len -= min_t(unsigned int, len, XGBE_TX_MAX_BUF_SIZE);
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		frag = &skb_shinfo(skb)->frags[i];
 		for (len = skb_frag_size(frag); len; ) {
 			packet->rdesc_count++;
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 5f1fc6582d74..82181da38683 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -244,7 +244,7 @@ static int xgene_enet_tx_completion(struct xgene_enet_desc_ring *cp_ring,
 			 skb_headlen(skb),
 			 DMA_TO_DEVICE);
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		frag = &skb_shinfo(skb)->frags[i];
 		dma_unmap_page(dev, frag_dma_addr[i], skb_frag_size(frag),
 			       DMA_TO_DEVICE);
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 9e02f8864593..d38f4c5c34f3 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1465,7 +1465,7 @@ static int alx_map_tx_skb(struct alx_tx_queue *txq, struct sk_buff *skb)
 	tpd->adrl.addr = cpu_to_le64(dma);
 	tpd->len = cpu_to_le16(maplen);
 
-	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++) {
+	skb_for_each_frag(skb, f) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 
 		if (++txq->write_idx == txq->count)
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index ff9f96de74b8..ddfd2bafa164 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -1601,7 +1601,7 @@ static u16 atl1e_cal_tdp_req(const struct sk_buff *skb)
 	u16 fg_size = 0;
 	u16 proto_hdr_len = 0;
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		fg_size = skb_frag_size(&skb_shinfo(skb)->frags[i]);
 		tpd_req += ((fg_size + MAX_TX_BUF_LEN - 1) >> MAX_TX_BUF_SHIFT);
 	}
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 1a6ec1a12d53..208c75691388 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4071,7 +4071,7 @@ netdev_tx_t bnx2x_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_data_bd = (struct eth_tx_bd *)tx_start_bd;
 
 	/* Handle fragmented skb */
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		mapping = skb_frag_dma_map(&bp->pdev->dev, frag, 0,
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index d2381929931b..e167131697fc 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6579,7 +6579,7 @@ static void tg3_tx(struct tg3_napi *tnapi)
 
 		sw_idx = NEXT_TX(sw_idx);
 
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_for_each_frag(skb, i) {
 			ri = &tnapi->tx_buffers[sw_idx];
 			if (unlikely(ri->skb != NULL || sw_idx == hw_idx))
 				tx_bug = 1;
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
index f782e6af45e9..dce6ca7694f0 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -1587,7 +1587,7 @@ int nicvf_sq_append_skb(struct nicvf *nic, struct snd_queue *sq,
 	if (!skb_is_nonlinear(skb))
 		goto doorbell;
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		qentry = nicvf_get_nxt_sqentry(sq, qentry);
diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index 1cc3c51eff71..9dc17b0f6019 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -1595,7 +1595,7 @@ static void deferred_unmap_destructor(struct sk_buff *skb)
 				 skb_transport_header(skb), PCI_DMA_TODEVICE);
 
 	si = skb_shinfo(skb);
-	for (i = 0; i < si->nr_frags; i++)
+	skb_for_each_frag(skb, i)
 		pci_unmap_page(dui->pdev, *p++, skb_frag_size(&si->frags[i]),
 			       PCI_DMA_TODEVICE);
 }
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index b6eba29d8e99..ad4acfd36d8d 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -1012,7 +1012,7 @@ static u32 be_xmit_enqueue(struct be_adapter *adapter, struct be_tx_obj *txo,
 		copied += len;
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		len = skb_frag_size(frag);
 
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 177c020bf34a..b3aa4c9dc03a 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2119,7 +2119,7 @@ static int dpaa_a050385_wa_skb(struct net_device *net_dev, struct sk_buff **s)
 	if (!IS_ALIGNED(skb_headlen(skb), DPAA_A050385_ALIGN))
 		goto workaround;
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		/* all fragments need to have aligned start addresses */
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 3ec4d9fddd52..36a457035ca9 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -1106,8 +1106,7 @@ static void free_skb_tx_queue(struct gfar_priv_tx_q *tx_queue)
 		dma_unmap_single(priv->dev, be32_to_cpu(txbdp->bufPtr),
 				 be16_to_cpu(txbdp->length), DMA_TO_DEVICE);
 		txbdp->lstatus = 0;
-		for (j = 0; j < skb_shinfo(tx_queue->tx_skbuff[i])->nr_frags;
-		     j++) {
+		skb_for_each_frag(tx_queue->tx_skbuff[i], j) {
 			txbdp++;
 			dma_unmap_page(priv->dev, be32_to_cpu(txbdp->bufPtr),
 				       be16_to_cpu(txbdp->length),
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 6938f3a939d6..825095e7f8b7 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -551,7 +551,7 @@ static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
 				     1 + payload_nfrags, hlen, addr);
 	}
 
-	for (i = 0; i < shinfo->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &shinfo->frags[i];
 
 		idx = (idx + 1) & tx->mask;
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index 8b2bf85039f1..eb1999309bad 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -577,7 +577,7 @@ static void hix5hd2_clean_sg_desc(struct hix5hd2_priv *priv,
 	len = le32_to_cpu(desc->linear_len);
 	dma_unmap_single(priv->dev, addr, len, DMA_TO_DEVICE);
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		addr = le32_to_cpu(desc->frags[i].addr);
 		len = le32_to_cpu(desc->frags[i].size);
 		dma_unmap_page(priv->dev, addr, len, DMA_TO_DEVICE);
@@ -717,7 +717,7 @@ static int hix5hd2_fill_sg_desc(struct hix5hd2_priv *priv,
 	desc->linear_addr = cpu_to_le32(addr);
 	desc->linear_len = cpu_to_le32(skb_headlen(skb));
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		int len = skb_frag_size(frag);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 25afe5a3348c..f0fc115b48d2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1257,7 +1257,7 @@ static unsigned int hns3_skb_bd_num(struct sk_buff *skb, unsigned int *bd_size,
 			return bd_num;
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		size = skb_frag_size(frag);
 		if (!size)
@@ -1507,7 +1507,7 @@ static int hns3_fill_skb_to_desc(struct hns3_enet_ring *ring,
 		bd_num += ret;
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		size = skb_frag_size(frag);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index cce08647b9b2..62a349ea3c4c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -336,7 +336,7 @@ static void hinic_copy_lp_data(struct hinic_dev *nic_dev,
 	frag_len = (int)skb_headlen(skb);
 	memcpy(lb_buf + pkt_offset, skb->data, frag_len);
 	pkt_offset += frag_len;
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		frag_data = skb_frag_address(&skb_shinfo(skb)->frags[i]);
 		frag_len = (int)skb_frag_size(&skb_shinfo(skb)->frags[i]);
 		memcpy((lb_buf + pkt_offset), frag_data, frag_len);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 710c4ff7bc0e..f30f6ff3bbfd 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -149,7 +149,7 @@ static int tx_map_skb(struct hinic_dev *nic_dev, struct sk_buff *skb,
 
 	hinic_set_sge(&sges[0], dma_addr, skb_headlen(skb));
 
-	for (i = 0 ; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		frag = &skb_shinfo(skb)->frags[i];
 
 		dma_addr = skb_frag_dma_map(&pdev->dev, frag, 0,
@@ -189,7 +189,7 @@ static void tx_unmap_skb(struct hinic_dev *nic_dev, struct sk_buff *skb,
 	struct pci_dev *pdev = hwif->pdev;
 	int i;
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags ; i++)
+	skb_for_each_frag(skb, i)
 		dma_unmap_page(&pdev->dev, hinic_sge_to_dma(&sges[i + 1]),
 			       sges[i + 1].len, DMA_TO_DEVICE);
 
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 7fea9ae60f13..92e6cb9b5a3f 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1132,7 +1132,7 @@ static netdev_tx_t ibmveth_start_xmit(struct sk_buff *skb,
 	descs[0].fields.address = dma_addr;
 
 	/* Map the frags */
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		dma_addr = skb_frag_dma_map(&adapter->vdev->dev, frag, 0,
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 473411542911..c884a7b83c81 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1675,7 +1675,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		cur = skb_headlen(skb);
 
 		/* Copy the frags */
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_for_each_frag(skb, i) {
 			const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 			memcpy(dst + cur, skb_frag_address(frag),
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index 3362f26d7f99..f103e9b406e4 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -1055,7 +1055,7 @@ netdev_tx_t fm10k_xmit_frame_ring(struct sk_buff *skb,
 	 *       + 2 desc gap to keep tail from touching head
 	 * otherwise try next time
 	 */
-	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++) {
+	skb_for_each_frag(skb, f) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 
 		count += TXD_USE_COUNT(skb_frag_size(frag));
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index c9e8c65a3cfe..4103252f5a9b 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6324,7 +6324,7 @@ netdev_tx_t igb_xmit_frame_ring(struct sk_buff *skb,
 	 *       + 1 desc for context descriptor,
 	 * otherwise try next time
 	 */
-	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
+	skb_for_each_frag(skb, f)
 		count += TXD_USE_COUNT(skb_frag_size(
 						&skb_shinfo(skb)->frags[f]));
 
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index fb3fbcb13331..12a54a33e836 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2165,7 +2165,7 @@ static inline int igbvf_tx_map_adv(struct igbvf_adapter *adapter,
 	if (dma_mapping_error(&pdev->dev, buffer_info->dma))
 		goto dma_error;
 
-	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++) {
+	skb_for_each_frag(skb, f) {
 		const skb_frag_t *frag;
 
 		count++;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 10765491e357..f8613de9b1d2 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1348,7 +1348,7 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 	 *	+ 1 desc for context descriptor,
 	 * otherwise try next time
 	 */
-	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
+	skb_for_each_frag(skb, f)
 		count += TXD_USE_COUNT(skb_frag_size(
 						&skb_shinfo(skb)->frags[f]));
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 7ba1c2985ef7..1b7fc29044f5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8602,7 +8602,7 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 	 *       + 1 desc for context descriptor,
 	 * otherwise try next time
 	 */
-	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
+	skb_for_each_frag(skb, f)
 		count += TXD_USE_COUNT(skb_frag_size(
 						&skb_shinfo(skb)->frags[f]));
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index ba2ed8a43d2d..904304305684 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4127,7 +4127,7 @@ static int ixgbevf_xmit_frame_ring(struct sk_buff *skb,
 	 * otherwise try next time
 	 */
 #if PAGE_SIZE > IXGBE_MAX_DATA_PER_TXD
-	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++) {
+	skb_for_each_frag(skb, f) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 
 		count += TXD_USE_COUNT(skb_frag_size(frag));
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index ca1681aa951a..4a8a2ae7d4b9 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -656,7 +656,7 @@ static inline unsigned int has_tiny_unaligned_frags(struct sk_buff *skb)
 {
 	int frag;
 
-	for (frag = 0; frag < skb_shinfo(skb)->nr_frags; frag++) {
+	skb_for_each_frag(skb, frag) {
 		const skb_frag_t *fragp = &skb_shinfo(skb)->frags[frag];
 
 		if (skb_frag_size(fragp) <= 8 && skb_frag_off(fragp) & 7)
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index ec706d614cac..72c0aece18eb 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4129,7 +4129,7 @@ static int mvpp2_tx_frag_process(struct mvpp2_port *port, struct sk_buff *skb,
 	int i;
 	dma_addr_t buf_dma_addr;
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		void *addr = skb_frag_address(frag);
 
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index d4bb27ba1419..f9e3952ed1e8 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -2786,7 +2786,7 @@ static netdev_tx_t skge_xmit_frame(struct sk_buff *skb,
 		struct skge_tx_desc *tf = td;
 
 		control |= BMU_STFWD;
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_for_each_frag(skb, i) {
 			const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 			map = skb_frag_dma_map(&hw->pdev->dev, frag, 0,
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 68c154d715d6..5e2e20cefdac 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -1199,7 +1199,7 @@ static void sky2_rx_submit(struct sky2_port *sky2,
 
 	sky2_rx_add(sky2, OP_PACKET, re->data_addr, sky2->rx_data_size);
 
-	for (i = 0; i < skb_shinfo(re->skb)->nr_frags; i++)
+	skb_for_each_frag(re->skb, i)
 		sky2_rx_add(sky2, OP_BUFFER, re->frag_addr[i], PAGE_SIZE);
 }
 
@@ -1217,7 +1217,7 @@ static int sky2_rx_map_skb(struct pci_dev *pdev, struct rx_ring_info *re,
 
 	dma_unmap_len_set(re, data_size, size);
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		re->frag_addr[i] = skb_frag_dma_map(&pdev->dev, frag, 0,
@@ -1254,7 +1254,7 @@ static void sky2_rx_unmap_skb(struct pci_dev *pdev, struct rx_ring_info *re)
 	dma_unmap_single(&pdev->dev, re->data_addr,
 			 dma_unmap_len(re, data_size), DMA_FROM_DEVICE);
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
+	skb_for_each_frag(skb, i)
 		dma_unmap_page(&pdev->dev, re->frag_addr[i],
 			       skb_frag_size(&skb_shinfo(skb)->frags[i]),
 			       DMA_FROM_DEVICE);
@@ -1932,7 +1932,7 @@ static netdev_tx_t sky2_xmit_frame(struct sk_buff *skb,
 	le->opcode = mss ? (OP_LARGESEND | HW_OWNER) : (OP_PACKET | HW_OWNER);
 
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		mapping = skb_frag_dma_map(&hw->pdev->dev, frag, 0,
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 810def064f11..e5e0b57b4cdc 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1089,7 +1089,7 @@ static inline int mtk_cal_txd_req(struct sk_buff *skb)
 
 	nfrags = 1;
 	if (skb_is_gso(skb)) {
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_for_each_frag(skb, i) {
 			frag = &skb_shinfo(skb)->frags[i];
 			nfrags += DIV_ROUND_UP(skb_frag_size(frag),
 						MTK_TX_DMA_BUF_LEN);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 8ba62671f5f1..9aa45fe5c74d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -320,7 +320,7 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		dseg++;
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		int fsz = skb_frag_size(frag);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 8e8456811384..0a6842f8e285 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1692,7 +1692,7 @@ static int mlxsw_pci_skb_transmit(void *bus_priv, struct sk_buff *skb,
 	if (err)
 		goto unlock;
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		err = mlxsw_pci_wqe_frag_map(mlxsw_pci, wqe, i + 1,
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 4e44313b7651..787ca2b76912 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -816,7 +816,7 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 
 		cp->tx_skb[entry] = skb;
 
-		for (frag = 0; frag < skb_shinfo(skb)->nr_frags; frag++) {
+		skb_for_each_frag(skb, frag) {
 			const skb_frag_t *this_frag = &skb_shinfo(skb)->frags[frag];
 			u32 len;
 			dma_addr_t mapping;
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 85031b4721fa..dfbde87d9cbe 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4001,7 +4001,7 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
 	struct skb_shared_info *info = skb_shinfo(skb);
 	unsigned int cur_frag;
 
-	for (cur_frag = 0; cur_frag < info->nr_frags; cur_frag++) {
+	skb_for_each_frag(skb, cur_frag) {
 		const skb_frag_t *frag = info->frags + cur_frag;
 		void *addr = skb_frag_address(frag);
 		u32 len = skb_frag_size(frag);
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 3473d296b2e2..758481bd3df1 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -1910,7 +1910,7 @@ static netdev_tx_t rocker_port_xmit(struct sk_buff *skb, struct net_device *dev)
 			goto unmap_frags;
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		err = rocker_tx_desc_frag_map_put(rocker_port, desc_info,
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 0c6650d2e239..4ef172df08b9 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -203,7 +203,7 @@ static void efx_skb_copy_bits_to_pio(struct efx_nic *efx, struct sk_buff *skb,
 	efx_memcpy_toio_aligned(efx, piobuf, skb->data, skb_headlen(skb),
 				copy_buf);
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; ++i) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
 		u8 *vaddr;
 
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 707ccdd03b19..920c29955172 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -3565,7 +3565,7 @@ static int release_tx_packet(struct niu *np, struct tx_ring_info *rp, int idx)
 		len -= MAX_TX_DESC_LEN;
 	} while (len > 0);
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		tb = &rp->tx_buffs[idx];
 		BUG_ON(tb->skb != NULL);
 		np->ops->unmap_page(np->device, tb->mapping,
@@ -6688,7 +6688,7 @@ static netdev_tx_t niu_start_xmit(struct sk_buff *skb,
 		len -= this_len;
 	}
 
-	for (i = 0; i <  skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		len = skb_frag_size(frag);
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 9790656cf970..76cd9569de18 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -1054,7 +1054,7 @@ static netdev_tx_t gem_start_xmit(struct sk_buff *skb,
 					     first_len, DMA_TO_DEVICE);
 		entry = NEXT_TX(entry);
 
-		for (frag = 0; frag < skb_shinfo(skb)->nr_frags; frag++) {
+		skb_for_each_frag(skb, frag) {
 			const skb_frag_t *this_frag = &skb_shinfo(skb)->frags[frag];
 			u32 len;
 			dma_addr_t mapping;
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 54b53dbdb33c..8faed52e5304 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2339,7 +2339,7 @@ static netdev_tx_t happy_meal_start_xmit(struct sk_buff *skb,
 			goto out_dma_error;
 		entry = NEXT_TX(entry);
 
-		for (frag = 0; frag < skb_shinfo(skb)->nr_frags; frag++) {
+		skb_for_each_frag(skb, frag) {
 			const skb_frag_t *this_frag = &skb_shinfo(skb)->frags[frag];
 			u32 len, mapping, this_txflags;
 
diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index 80fde5f06fce..15056f84b4ae 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1080,7 +1080,7 @@ static inline int vnet_skb_map(struct ldc_channel *lp, struct sk_buff *skb,
 		return err;
 	nc = err;
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
 		u8 *vaddr;
 
@@ -1121,7 +1121,7 @@ static inline struct sk_buff *vnet_skb_shape(struct sk_buff *skb, int ncookies)
 
 	/* make sure we have enough cookies and alignment in every frag */
 	docopy = skb_shinfo(skb)->nr_frags >= ncookies;
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
 
 		docopy |= skb_frag_off(f) & 7;
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c
index 589797bad1f9..360b3f1458d5 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c
@@ -576,7 +576,7 @@ static int xlgmac_map_tx_skb(struct xlgmac_channel *channel,
 		desc_data = XLGMAC_GET_DESC_DATA(ring, cur_index);
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		netif_dbg(pdata, tx_queued, pdata->netdev,
 			  "mapping frag %u\n", i);
 
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
index 26d178f8616b..c50223b77b1e 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
@@ -177,7 +177,7 @@ static void xlgmac_prep_tx_pkt(struct xlgmac_pdata *pdata,
 		len -= min_t(unsigned int, len, XLGMAC_TX_MAX_BUF_SIZE);
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		frag = &skb_shinfo(skb)->frags[i];
 		for (len = skb_frag_size(frag); len; ) {
 			pkt_info->desc_count++;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 638d7b03be4b..31038cd4c251 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1183,7 +1183,7 @@ static netdev_tx_t am65_cpsw_nuss_ndo_slave_xmit(struct sk_buff *skb,
 
 	/* Handle the case where skb is fragmented in pages */
 	cur_desc = first_desc;
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		u32 frag_size = skb_frag_size(frag);
 
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index d7a144b4a09f..512e4455b5ee 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1113,7 +1113,7 @@ netcp_tx_map_skb(struct sk_buff *skb, struct netcp_intf *netcp)
 	pdesc = desc;
 
 	/* Handle the case where skb is fragmented in pages */
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		struct page *page = skb_frag_page(frag);
 		u32 page_offset = skb_frag_off(frag);
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index fecc4d7b00b0..02c869bcecc4 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2576,7 +2576,7 @@ static netdev_tx_t velocity_xmit(struct sk_buff *skb,
 	td_ptr->td_buf[0].size = cpu_to_le16(pktlen);
 
 	/* Handle fragments */
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		tdinfo->skb_dma[i + 1] = skb_frag_dma_map(vptr->dev,
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index ecf62849f4c1..465b9926d3da 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1321,7 +1321,7 @@ static int build_dma_sg(const struct sk_buff *skb, struct urb *urb)
 	sg_set_buf(&urb->sg[s++], skb->data, skb_headlen(skb));
 	total_len += skb_headlen(skb);
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
 
 		total_len += skb_frag_size(f);
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 6e87f1fc4874..cc06b9257a15 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -747,7 +747,7 @@ vmxnet3_map_pkt(struct sk_buff *skb, struct vmxnet3_tx_ctx *ctx,
 		buf_offset += buf_size;
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		u32 buf_size;
 
@@ -990,7 +990,7 @@ static int txd_estimate(const struct sk_buff *skb)
 	int count = VMXNET3_TXD_NEEDED(skb_headlen(skb)) + 1;
 	int i;
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		count += VMXNET3_TXD_NEEDED(skb_frag_size(frag));
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 7ae32491b5da..3840f4930af5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1278,7 +1278,7 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 	}
 
 	/* set up the remaining entries to point to the data */
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		dma_addr_t tb_phys;
 		int tb_idx;
diff --git a/drivers/net/wireless/intel/iwlwifi/queue/tx.c b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
index 833f43d1ca7a..7629764c44fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/queue/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
@@ -544,7 +544,7 @@ static int iwl_txq_gen2_tx_add_frags(struct iwl_trans *trans,
 {
 	int i;
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		dma_addr_t tb_phys;
 		unsigned int fragsz = skb_frag_size(frag);
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 39a01c2a3058..85981635b8e5 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1086,7 +1086,7 @@ static int xenvif_handle_frag_list(struct xenvif_queue *queue, struct sk_buff *s
 	}
 
 	/* Release all the original (foreign) frags. */
-	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
+	skb_for_each_frag(skb, f)
 		skb_frag_unref(skb, f);
 	uarg = skb_shinfo(skb)->destructor_arg;
 	/* increase inflight counter to offset decrement in callback */
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 44275908d61a..8388d48e2fda 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -744,7 +744,7 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 	tx = xennet_make_txreqs(queue, tx, skb, page, offset, len);
 
 	/* Requests for all the frags. */
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		tx = xennet_make_txreqs(queue, tx, skb, skb_frag_page(frag),
 					skb_frag_off(frag),
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 6954d4e831a3..b069f67625bc 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3939,7 +3939,7 @@ static int qeth_get_elements_for_frags(struct sk_buff *skb)
 {
 	int cnt, elements = 0;
 
-	for (cnt = 0; cnt < skb_shinfo(skb)->nr_frags; cnt++) {
+	skb_for_each_frag(skb, cnt) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[cnt];
 
 		elements += qeth_get_elements_for_range(
@@ -4152,7 +4152,7 @@ static unsigned int qeth_fill_buffer(struct qeth_qdio_out_buffer *buf,
 	}
 
 	/* map page frags into buffer element(s) */
-	for (cnt = 0; cnt < skb_shinfo(skb)->nr_frags; cnt++) {
+	skb_for_each_frag(skb, cnt) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[cnt];
 
 		data = skb_frag_address(frag);
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index b927b3d84523..6a1d3d31b9a3 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -317,7 +317,7 @@ u32 fcoe_fc_crc(struct fc_frame *fp)
 
 	crc = crc32(~0, skb->data, skb_headlen(skb));
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		frag = &skb_shinfo(skb)->frags[i];
 		off = skb_frag_off(frag);
 		len = skb_frag_size(frag);
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 9c71ad5af7b9..c8e0fb76bdf4 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -269,7 +269,7 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 		hw_buffer.s.pool = 0;
 		hw_buffer.s.size = skb_headlen(skb);
 		CVM_OCT_SKB_CB(skb)[0] = hw_buffer.u64;
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_for_each_frag(skb, i) {
 			skb_frag_t *fs = skb_shinfo(skb)->frags + i;
 
 			hw_buffer.s.addr =
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index b926e1d6c7b8..6bd996adfc2b 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -1384,7 +1384,7 @@ static void cxgbit_lro_skb_dump(struct sk_buff *skb)
 			"frags %u.\n",
 			skb, i, pdu_cb->pdulen, pdu_cb->flags, pdu_cb->seq,
 			pdu_cb->ddigest, pdu_cb->frags);
-	for (i = 0; i < ssi->nr_frags; i++)
+	skb_for_each_frag(skb, i)
 		pr_info("skb 0x%p, frag %d, off %u, sz %u.\n",
 			skb, i, skb_frag_off(&ssi->frags[i]),
 			skb_frag_size(&ssi->frags[i]));
@@ -1397,7 +1397,7 @@ static void cxgbit_lro_hskb_reset(struct cxgbit_sock *csk)
 	u8 i;
 
 	memset(skb->data, 0, LRO_SKB_MIN_HEADROOM);
-	for (i = 0; i < ssi->nr_frags; i++)
+	skb_for_each_frag(skb, i)
 		put_page(skb_frag_page(&ssi->frags[i]));
 	ssi->nr_frags = 0;
 	skb->data_len = 0;
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index ebda397fa95a..7438211cb9c0 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -949,7 +949,7 @@ static unsigned long atalk_sum_skb(const struct sk_buff *skb, int offset,
 	}
 
 	/* checksum stuff in frags */
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		int end;
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		WARN_ON(start > offset + len);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 15ab9ffb27fe..8cd7bbf717df 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -432,7 +432,7 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 	}
 
 	/* Copy paged appendix. Hmm... why does this look so complicated? */
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		int end;
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
@@ -564,7 +564,7 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 	}
 
 	/* Copy paged appendix. Hmm... why does this look so complicated? */
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		int end;
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3ad9e8425ab2..913735fc269a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -662,7 +662,7 @@ static void skb_release_data(struct sk_buff *skb)
 
 	skb_zcopy_clear(skb, true);
 
-	for (i = 0; i < shinfo->nr_frags; i++)
+	skb_for_each_frag(skb, i)
 		__skb_frag_unref(&shinfo->frags[i]);
 
 	if (shinfo->frag_list)
@@ -1623,7 +1623,7 @@ struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
 			n = NULL;
 			goto out;
 		}
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_for_each_frag(skb, i) {
 			skb_shinfo(n)->frags[i] = skb_shinfo(skb)->frags[i];
 			skb_frag_ref(skb, i);
 		}
@@ -1698,7 +1698,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 			goto nofrags;
 		if (skb_zcopy(skb))
 			refcount_inc(&skb_uarg(skb)->refcnt);
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
+		skb_for_each_frag(skb, i)
 			skb_frag_ref(skb, i);
 
 		if (skb_has_frag_list(skb))
@@ -2126,7 +2126,7 @@ void *__pskb_pull_tail(struct sk_buff *skb, int delta)
 
 	/* Estimate size of pulled pages. */
 	eat = delta;
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		int size = skb_frag_size(&skb_shinfo(skb)->frags[i]);
 
 		if (size >= eat)
@@ -2191,7 +2191,7 @@ void *__pskb_pull_tail(struct sk_buff *skb, int delta)
 pull_pages:
 	eat = delta;
 	k = 0;
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		int size = skb_frag_size(&skb_shinfo(skb)->frags[i]);
 
 		if (size <= eat) {
@@ -2259,7 +2259,7 @@ int skb_copy_bits(const struct sk_buff *skb, int offset, void *to, int len)
 		to     += copy;
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		int end;
 		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
 
@@ -2447,7 +2447,7 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 	/*
 	 * then map the fragments
 	 */
-	for (seg = 0; seg < skb_shinfo(skb)->nr_frags; seg++) {
+	skb_for_each_frag(skb, seg) {
 		const skb_frag_t *f = &skb_shinfo(skb)->frags[seg];
 
 		if (__splice_segment(skb_frag_page(f),
@@ -2562,7 +2562,7 @@ static int __skb_send_sock(struct sock *sk, struct sk_buff *skb, int offset,
 	offset -= skb_headlen(skb);
 
 	/* Find where we are in frag list */
-	for (fragidx = 0; fragidx < skb_shinfo(skb)->nr_frags; fragidx++) {
+	skb_for_each_frag(skb, fragidx) {
 		skb_frag_t *frag  = &skb_shinfo(skb)->frags[fragidx];
 
 		if (offset < skb_frag_size(frag))
@@ -2661,7 +2661,7 @@ int skb_store_bits(struct sk_buff *skb, int offset, const void *from, int len)
 		from += copy;
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		int end;
 
@@ -2740,7 +2740,7 @@ __wsum __skb_checksum(const struct sk_buff *skb, int offset, int len,
 		pos	= copy;
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		int end;
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
@@ -2840,7 +2840,7 @@ __wsum skb_copy_and_csum_bits(const struct sk_buff *skb, int offset,
 		pos	= copy;
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		int end;
 
 		WARN_ON(start > offset + len);
@@ -3072,7 +3072,7 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
 	}
 	skb_zerocopy_clone(to, from, GFP_ATOMIC);
 
-	for (i = 0; i < skb_shinfo(from)->nr_frags; i++) {
+	skb_for_each_frag(from, i) {
 		int size;
 
 		if (!len)
@@ -3292,7 +3292,7 @@ static inline void skb_split_inside_header(struct sk_buff *skb,
 	skb_copy_from_linear_data_offset(skb, len, skb_put(skb1, pos - len),
 					 pos - len);
 	/* And move data appendix as is. */
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
+	skb_for_each_frag(skb, i)
 		skb_shinfo(skb1)->frags[i] = skb_shinfo(skb)->frags[i];
 
 	skb_shinfo(skb1)->nr_frags = skb_shinfo(skb)->nr_frags;
@@ -4419,7 +4419,7 @@ __skb_to_sgvec(struct sk_buff *skb, struct scatterlist *sg, int offset, int len,
 		offset += copy;
 	}
 
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		int end;
 
 		WARN_ON(start > offset + len);
@@ -5329,7 +5329,7 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	/* if the skb is not cloned this does nothing
 	 * since we set nr_frags to 0.
 	 */
-	for (i = 0; i < from_shinfo->nr_frags; i++)
+	skb_for_each_frag(from, i)
 		__skb_frag_ref(&from_shinfo->frags[i]);
 
 	to->truesize += delta;
@@ -6053,7 +6053,7 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 			kfree(data);
 			return -ENOMEM;
 		}
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
+		skb_for_each_frag(skb, i)
 			skb_frag_ref(skb, i);
 		if (skb_has_frag_list(skb))
 			skb_clone_fraglist(skb);
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 05cd198d7a6b..4837411c7374 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -487,7 +487,7 @@ void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
 			return NULL;
 		skb_shinfo(clone)->frag_list = skb_shinfo(head)->frag_list;
 		skb_frag_list_init(head);
-		for (i = 0; i < skb_shinfo(head)->nr_frags; i++)
+		skb_for_each_frag(head, i)
 			plen += skb_frag_size(&skb_shinfo(head)->frags[i]);
 		clone->data_len = head->data_len - plen;
 		clone->len = clone->data_len;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e14fd0c50c10..4c54c26c3a50 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4357,7 +4357,7 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 	if (crypto_ahash_update(req))
 		return 1;
 
-	for (i = 0; i < shi->nr_frags; ++i) {
+	skb_for_each_frag(skb, i) {
 		const skb_frag_t *f = &shi->frags[i];
 		unsigned int offset = skb_frag_off(f);
 		struct page *page = skb_frag_page(f) + (offset >> PAGE_SHIFT);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index bde781f46b41..5de00477eaf9 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1644,7 +1644,7 @@ static int __pskb_trim_head(struct sk_buff *skb, int len)
 	eat = len;
 	k = 0;
 	shinfo = skb_shinfo(skb);
-	for (i = 0; i < shinfo->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {
 		int size = skb_frag_size(&shinfo->frags[i]);
 
 		if (size <= eat) {
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 0fdb389c3390..33b0e96a2b91 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1079,7 +1079,7 @@ static int iucv_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 			/* skip iucv_array lying in the headroom */
 			iba[0].address = (u32)(addr_t)skb->data;
 			iba[0].length = (u32)skb_headlen(skb);
-			for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+			skb_for_each_frag(skb, i) {
 				skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 				iba[i + 1].address =
@@ -1181,7 +1181,7 @@ static void iucv_process_message(struct sock *sk, struct sk_buff *skb,
 
 			iba[0].address = (u32)(addr_t)skb->data;
 			iba[0].length = (u32)skb_headlen(skb);
-			for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+			skb_for_each_frag(skb, i) {
 				skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 				iba[i + 1].address =
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 6201965bd822..e1e149539ddb 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -630,8 +630,7 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 			goto out;
 		}
 
-		for (fragidx = 0; fragidx < skb_shinfo(skb)->nr_frags;
-		     fragidx++) {
+		skb_for_each_frag(skb, fragidx) {
 			skb_frag_t *frag;
 
 			frag_offset = 0;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 1dcb34dfd56b..661f4084080b 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -63,7 +63,7 @@ static int __skb_nsg(struct sk_buff *skb, int offset, int len,
                 offset += chunk;
         }
 
-        for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+        skb_for_each_frag(skb, i) {
                 int end;
 
                 WARN_ON(start > offset + len);
-- 
2.30.2

