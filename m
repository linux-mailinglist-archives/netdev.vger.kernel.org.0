Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6AA250177
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 17:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgHXPuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 11:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbgHXPu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 11:50:27 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A8CC061755
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 08:50:27 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o5so4754514pgb.2
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 08:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a7Ys8JhUWGJ0+ht8tVNZTMxtMbaNauMvGAxp7o/mMFs=;
        b=DXJYVhjSZSrWU6y5k1wNUL0gHz1NXcYhjLTxN7LJvIgBbwoMk/A3pWHF/XWXXHL3yD
         BJmCw3+OVX7GYvRQObKYE1nI3sZLOOIQaUM4b1DYq4hgEn5hCCKUWBu7RMWyHMgj0KlO
         xY+Q8dje8b0+tva+F7qpyCR9IMUwq5/BGxh+ghUmG+1VISBFq0ON6p+rv9vO5OCweGKY
         z5+oWewqljnUYHmHHvJ3A83iBfeXs3s09jhCQn+v7kih05aLXy5ubMxB1CMr38JxB5GA
         ZhSgo3hRvN72PX8Geh8Ght58UCGD8REw/Bvl1qD7Miy9Oor63QBV0LbJM+hUmTvabAb3
         jetQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a7Ys8JhUWGJ0+ht8tVNZTMxtMbaNauMvGAxp7o/mMFs=;
        b=D5uvV6S7I6/G/UTVENHlL00iNvU/QdChJr8bJjPJZDycIifWPOJsM7oFoExDGEpM76
         UbTNaEHhnlWD1vvGvmRrVeFa5VjRh3/XnavlpjFmbNhGM56W7gTBvqrtItEopUG0G3ti
         K7kh6Gp2s4Pn+fhnlS24rAY8c6yWIyfmPFBsVJXA2yykZqxaVsxijOkZxK53BsWE5EsL
         gSvId4ARrLWfBF4rv0RgQKsH479IGknCdrIoy/gfLWlHEV44vCq5GBp5NvLgRnjCudnO
         oItbpmAzWWZsfe7baXGOzOTYtJtnaU3r9eOEI/Xa/vGY2t/HgyAAoZcuuLldBQIpRt4T
         vURA==
X-Gm-Message-State: AOAM5320KEgC/kDVobasqv6ILGHYbnKxVdoNm13wdDMf7ZxeXgrWWKd/
        vyOEfwarH+HGXxLTstQP1HuR6WYrseVWgA==
X-Google-Smtp-Source: ABdhPJzc2xiBN2pGr9mcc+Tbo/nIBnCjWyrkCfa1+efKkpMrnllfl2eKgrQrmtY7gYdHR+HEwAXLQw==
X-Received: by 2002:a62:1684:: with SMTP id 126mr3410543pfw.37.1598284226832;
        Mon, 24 Aug 2020 08:50:26 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id p24sm3364543pgn.49.2020.08.24.08.50.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 08:50:26 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        netdev@vger.kernel.org, sgoutham@marvell.com
Cc:     Aleksey Makarov <amakarov@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [PATCH v8 net-next 3/3] octeontx2-pf: Add support for PTP clock
Date:   Mon, 24 Aug 2020 21:20:02 +0530
Message-Id: <1598284202-19917-4-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598284202-19917-1-git-send-email-sundeep.lkml@gmail.com>
References: <1598284202-19917-1-git-send-email-sundeep.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksey Makarov <amakarov@marvell.com>

This patch adds PTP clock and uses it in Octeontx2
network device. PTP clock uses mailbox calls to
access the hardware counter on the RVU side.

Co-developed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Aleksey Makarov <amakarov@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   7 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  19 ++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  28 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 168 +++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  | 212 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.h  |  13 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  87 ++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   1 +
 9 files changed, 532 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index 778df33..b2c6385 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -6,7 +6,8 @@
 obj-$(CONFIG_OCTEONTX2_PF) += octeontx2_nicpf.o
 obj-$(CONFIG_OCTEONTX2_VF) += octeontx2_nicvf.o
 
-octeontx2_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o
+octeontx2_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o \
+		     otx2_ptp.o
 octeontx2_nicvf-y := otx2_vf.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 93c4cf7..f893423 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -671,6 +671,13 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	if (!sq->sg)
 		return -ENOMEM;
 
+	if (pfvf->ptp) {
+		err = qmem_alloc(pfvf->dev, &sq->timestamps, qset->sqe_cnt,
+				 sizeof(*sq->timestamps));
+		if (err)
+			return err;
+	}
+
 	sq->head = 0;
 	sq->sqe_per_sqb = (pfvf->hw.sqb_size / sq->sqe_size) - 1;
 	sq->num_sqbs = (qset->sqe_cnt + sq->sqe_per_sqb) / sq->sqe_per_sqb;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 2fa2988..689925b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -13,6 +13,9 @@
 
 #include <linux/pci.h>
 #include <linux/iommu.h>
+#include <linux/net_tstamp.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/timecounter.h>
 
 #include <mbox.h>
 #include "otx2_reg.h"
@@ -209,6 +212,17 @@ struct refill_work {
 	struct otx2_nic *pf;
 };
 
+struct otx2_ptp {
+	struct ptp_clock_info ptp_info;
+	struct ptp_clock *ptp_clock;
+	struct otx2_nic *nic;
+
+	struct cyclecounter cycle_counter;
+	struct timecounter time_counter;
+};
+
+#define OTX2_HW_TIMESTAMP_LEN	8
+
 struct otx2_nic {
 	void __iomem		*reg_base;
 	struct net_device	*netdev;
@@ -216,6 +230,8 @@ struct otx2_nic {
 	u16			max_frs;
 	u16			rbsize; /* Receive buffer size */
 
+#define OTX2_FLAG_RX_TSTAMP_ENABLED		BIT_ULL(0)
+#define OTX2_FLAG_TX_TSTAMP_ENABLED		BIT_ULL(1)
 #define OTX2_FLAG_INTF_DOWN			BIT_ULL(2)
 #define OTX2_FLAG_RX_PAUSE_ENABLED		BIT_ULL(9)
 #define OTX2_FLAG_TX_PAUSE_ENABLED		BIT_ULL(10)
@@ -251,6 +267,9 @@ struct otx2_nic {
 
 	/* Block address of NIX either BLKADDR_NIX0 or BLKADDR_NIX1 */
 	int			nix_blkaddr;
+
+	struct otx2_ptp		*ptp;
+	struct hwtstamp_config	tstamp;
 };
 
 static inline bool is_otx2_lbkvf(struct pci_dev *pdev)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index d59f5a9..0341d969 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -13,8 +13,10 @@
 #include <linux/stddef.h>
 #include <linux/etherdevice.h>
 #include <linux/log2.h>
+#include <linux/net_tstamp.h>
 
 #include "otx2_common.h"
+#include "otx2_ptp.h"
 
 #define DRV_NAME	"octeontx2-nicpf"
 #define DRV_VF_NAME	"octeontx2-nicvf"
@@ -663,6 +665,31 @@ static u32 otx2_get_link(struct net_device *netdev)
 	return pfvf->linfo.link_up;
 }
 
+static int otx2_get_ts_info(struct net_device *netdev,
+			    struct ethtool_ts_info *info)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+
+	if (!pfvf->ptp)
+		return ethtool_op_get_ts_info(netdev, info);
+
+	info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE |
+				SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE |
+				SOF_TIMESTAMPING_TX_HARDWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	info->phc_index = otx2_ptp_clock_index(pfvf);
+
+	info->tx_types = (1 << HWTSTAMP_TX_OFF) | (1 << HWTSTAMP_TX_ON);
+
+	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
+			   (1 << HWTSTAMP_FILTER_ALL);
+
+	return 0;
+}
+
 static const struct ethtool_ops otx2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
@@ -687,6 +714,7 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.set_msglevel		= otx2_set_msglevel,
 	.get_pauseparam		= otx2_get_pauseparam,
 	.set_pauseparam		= otx2_set_pauseparam,
+	.get_ts_info		= otx2_get_ts_info,
 };
 
 void otx2_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 75a8c40..f5f874a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -21,6 +21,7 @@
 #include "otx2_common.h"
 #include "otx2_txrx.h"
 #include "otx2_struct.h"
+#include "otx2_ptp.h"
 
 #define DRV_NAME	"octeontx2-nicpf"
 #define DRV_STRING	"Marvell OcteonTX2 NIC Physical Function Driver"
@@ -41,6 +42,9 @@ enum {
 	TYPE_PFVF,
 };
 
+static int otx2_config_hw_tx_tstamp(struct otx2_nic *pfvf, bool enable);
+static int otx2_config_hw_rx_tstamp(struct otx2_nic *pfvf, bool enable);
+
 static int otx2_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	bool if_up = netif_running(netdev);
@@ -1281,7 +1285,8 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 	hw->pool_cnt = hw->rqpool_cnt + hw->sqpool_cnt;
 
 	/* Get the size of receive buffers to allocate */
-	pf->rbsize = RCV_FRAG_LEN(pf->netdev->mtu + OTX2_ETH_HLEN);
+	pf->rbsize = RCV_FRAG_LEN(OTX2_HW_TIMESTAMP_LEN + pf->netdev->mtu +
+				  OTX2_ETH_HLEN);
 
 	mutex_lock(&mbox->lock);
 	/* NPA init */
@@ -1547,6 +1552,16 @@ int otx2_open(struct net_device *netdev)
 
 	otx2_set_cints_affinity(pf);
 
+	/* When reinitializing enable time stamping if it is enabled before */
+	if (pf->flags & OTX2_FLAG_TX_TSTAMP_ENABLED) {
+		pf->flags &= ~OTX2_FLAG_TX_TSTAMP_ENABLED;
+		otx2_config_hw_tx_tstamp(pf, true);
+	}
+	if (pf->flags & OTX2_FLAG_RX_TSTAMP_ENABLED) {
+		pf->flags &= ~OTX2_FLAG_RX_TSTAMP_ENABLED;
+		otx2_config_hw_rx_tstamp(pf, true);
+	}
+
 	pf->flags &= ~OTX2_FLAG_INTF_DOWN;
 	/* 'intf_down' may be checked on any cpu */
 	smp_wmb();
@@ -1738,6 +1753,143 @@ static void otx2_reset_task(struct work_struct *work)
 	rtnl_unlock();
 }
 
+static int otx2_config_hw_rx_tstamp(struct otx2_nic *pfvf, bool enable)
+{
+	struct msg_req *req;
+	int err;
+
+	if (pfvf->flags & OTX2_FLAG_RX_TSTAMP_ENABLED && enable)
+		return 0;
+
+	mutex_lock(&pfvf->mbox.lock);
+	if (enable)
+		req = otx2_mbox_alloc_msg_cgx_ptp_rx_enable(&pfvf->mbox);
+	else
+		req = otx2_mbox_alloc_msg_cgx_ptp_rx_disable(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return err;
+	}
+
+	mutex_unlock(&pfvf->mbox.lock);
+	if (enable)
+		pfvf->flags |= OTX2_FLAG_RX_TSTAMP_ENABLED;
+	else
+		pfvf->flags &= ~OTX2_FLAG_RX_TSTAMP_ENABLED;
+	return 0;
+}
+
+static int otx2_config_hw_tx_tstamp(struct otx2_nic *pfvf, bool enable)
+{
+	struct msg_req *req;
+	int err;
+
+	if (pfvf->flags & OTX2_FLAG_TX_TSTAMP_ENABLED && enable)
+		return 0;
+
+	mutex_lock(&pfvf->mbox.lock);
+	if (enable)
+		req = otx2_mbox_alloc_msg_nix_lf_ptp_tx_enable(&pfvf->mbox);
+	else
+		req = otx2_mbox_alloc_msg_nix_lf_ptp_tx_disable(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return err;
+	}
+
+	mutex_unlock(&pfvf->mbox.lock);
+	if (enable)
+		pfvf->flags |= OTX2_FLAG_TX_TSTAMP_ENABLED;
+	else
+		pfvf->flags &= ~OTX2_FLAG_TX_TSTAMP_ENABLED;
+	return 0;
+}
+
+static int otx2_config_hwtstamp(struct net_device *netdev, struct ifreq *ifr)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct hwtstamp_config config;
+
+	if (!pfvf->ptp)
+		return -ENODEV;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	/* reserved for future extensions */
+	if (config.flags)
+		return -EINVAL;
+
+	switch (config.tx_type) {
+	case HWTSTAMP_TX_OFF:
+		otx2_config_hw_tx_tstamp(pfvf, false);
+		break;
+	case HWTSTAMP_TX_ON:
+		otx2_config_hw_tx_tstamp(pfvf, true);
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (config.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		otx2_config_hw_rx_tstamp(pfvf, false);
+		break;
+	case HWTSTAMP_FILTER_ALL:
+	case HWTSTAMP_FILTER_SOME:
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		otx2_config_hw_rx_tstamp(pfvf, true);
+		config.rx_filter = HWTSTAMP_FILTER_ALL;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	memcpy(&pfvf->tstamp, &config, sizeof(config));
+
+	return copy_to_user(ifr->ifr_data, &config,
+			    sizeof(config)) ? -EFAULT : 0;
+}
+
+static int otx2_ioctl(struct net_device *netdev, struct ifreq *req, int cmd)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct hwtstamp_config *cfg = &pfvf->tstamp;
+
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return otx2_config_hwtstamp(netdev, req);
+	case SIOCGHWTSTAMP:
+		return copy_to_user(req->ifr_data, cfg,
+				    sizeof(*cfg)) ? -EFAULT : 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_open		= otx2_open,
 	.ndo_stop		= otx2_stop,
@@ -1748,6 +1900,7 @@ static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_set_features	= otx2_set_features,
 	.ndo_tx_timeout		= otx2_tx_timeout,
 	.ndo_get_stats64	= otx2_get_stats64,
+	.ndo_do_ioctl		= otx2_ioctl,
 };
 
 static int otx2_wq_init(struct otx2_nic *pf)
@@ -1920,6 +2073,9 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Assign default mac address */
 	otx2_get_mac_from_af(netdev);
 
+	/* Don't check for error.  Proceed without ptp */
+	otx2_ptp_init(pf);
+
 	/* NPA's pool is a stack to which SW frees buffer pointers via Aura.
 	 * HW allocates buffer pointer from stack and uses it for DMA'ing
 	 * ingress packet. In some scenarios HW can free back allocated buffer
@@ -1952,7 +2108,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
-		goto err_detach_rsrc;
+		goto err_ptp_destroy;
 	}
 
 	err = otx2_wq_init(pf);
@@ -1972,6 +2128,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 err_unreg_netdev:
 	unregister_netdev(netdev);
+err_ptp_destroy:
+	otx2_ptp_destroy(pf);
 err_detach_rsrc:
 	otx2_detach_resources(&pf->mbox);
 err_disable_mbox_intr:
@@ -2113,6 +2271,11 @@ static void otx2_remove(struct pci_dev *pdev)
 
 	pf = netdev_priv(netdev);
 
+	if (pf->flags & OTX2_FLAG_TX_TSTAMP_ENABLED)
+		otx2_config_hw_tx_tstamp(pf, false);
+	if (pf->flags & OTX2_FLAG_RX_TSTAMP_ENABLED)
+		otx2_config_hw_rx_tstamp(pf, false);
+
 	cancel_work_sync(&pf->reset_task);
 	/* Disable link notifications */
 	otx2_cgx_config_linkevents(pf, false);
@@ -2122,6 +2285,7 @@ static void otx2_remove(struct pci_dev *pdev)
 	if (pf->otx2_wq)
 		destroy_workqueue(pf->otx2_wq);
 
+	otx2_ptp_destroy(pf);
 	otx2_detach_resources(&pf->mbox);
 	otx2_disable_mbox_intr(pf);
 	otx2_pfaf_mbox_destroy(pf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
new file mode 100644
index 0000000..7bcf524
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
@@ -0,0 +1,212 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 PTP support for ethernet driver
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#include "otx2_common.h"
+#include "otx2_ptp.h"
+
+static int otx2_ptp_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
+{
+	struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
+					    ptp_info);
+	struct ptp_req *req;
+	int err;
+
+	if (!ptp->nic)
+		return -ENODEV;
+
+	req = otx2_mbox_alloc_msg_ptp_op(&ptp->nic->mbox);
+	if (!req)
+		return -ENOMEM;
+
+	req->op = PTP_OP_ADJFINE;
+	req->scaled_ppm = scaled_ppm;
+
+	err = otx2_sync_mbox_msg(&ptp->nic->mbox);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static u64 ptp_cc_read(const struct cyclecounter *cc)
+{
+	struct otx2_ptp *ptp = container_of(cc, struct otx2_ptp, cycle_counter);
+	struct ptp_req *req;
+	struct ptp_rsp *rsp;
+	int err;
+
+	if (!ptp->nic)
+		return 0;
+
+	req = otx2_mbox_alloc_msg_ptp_op(&ptp->nic->mbox);
+	if (!req)
+		return 0;
+
+	req->op = PTP_OP_GET_CLOCK;
+
+	err = otx2_sync_mbox_msg(&ptp->nic->mbox);
+	if (err)
+		return 0;
+
+	rsp = (struct ptp_rsp *)otx2_mbox_get_rsp(&ptp->nic->mbox.mbox, 0,
+						  &req->hdr);
+	if (IS_ERR(rsp))
+		return 0;
+
+	return rsp->clk;
+}
+
+static int otx2_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
+{
+	struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
+					    ptp_info);
+	struct otx2_nic *pfvf = ptp->nic;
+
+	mutex_lock(&pfvf->mbox.lock);
+	timecounter_adjtime(&ptp->time_counter, delta);
+	mutex_unlock(&pfvf->mbox.lock);
+
+	return 0;
+}
+
+static int otx2_ptp_gettime(struct ptp_clock_info *ptp_info,
+			    struct timespec64 *ts)
+{
+	struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
+					    ptp_info);
+	struct otx2_nic *pfvf = ptp->nic;
+	u64 nsec;
+
+	mutex_lock(&pfvf->mbox.lock);
+	nsec = timecounter_read(&ptp->time_counter);
+	mutex_unlock(&pfvf->mbox.lock);
+
+	*ts = ns_to_timespec64(nsec);
+
+	return 0;
+}
+
+static int otx2_ptp_settime(struct ptp_clock_info *ptp_info,
+			    const struct timespec64 *ts)
+{
+	struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
+					    ptp_info);
+	struct otx2_nic *pfvf = ptp->nic;
+	u64 nsec;
+
+	nsec = timespec64_to_ns(ts);
+
+	mutex_lock(&pfvf->mbox.lock);
+	timecounter_init(&ptp->time_counter, &ptp->cycle_counter, nsec);
+	mutex_unlock(&pfvf->mbox.lock);
+
+	return 0;
+}
+
+static int otx2_ptp_enable(struct ptp_clock_info *ptp_info,
+			   struct ptp_clock_request *rq, int on)
+{
+	return -EOPNOTSUPP;
+}
+
+int otx2_ptp_init(struct otx2_nic *pfvf)
+{
+	struct otx2_ptp *ptp_ptr;
+	struct cyclecounter *cc;
+	struct ptp_req *req;
+	int err;
+
+	mutex_lock(&pfvf->mbox.lock);
+	/* check if PTP block is available */
+	req = otx2_mbox_alloc_msg_ptp_op(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->op = PTP_OP_GET_CLOCK;
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return err;
+	}
+	mutex_unlock(&pfvf->mbox.lock);
+
+	ptp_ptr = kzalloc(sizeof(*ptp_ptr), GFP_KERNEL);
+	if (!ptp_ptr) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	ptp_ptr->nic = pfvf;
+
+	cc = &ptp_ptr->cycle_counter;
+	cc->read = ptp_cc_read;
+	cc->mask = CYCLECOUNTER_MASK(64);
+	cc->mult = 1;
+	cc->shift = 0;
+
+	timecounter_init(&ptp_ptr->time_counter, &ptp_ptr->cycle_counter,
+			 ktime_to_ns(ktime_get_real()));
+
+	ptp_ptr->ptp_info = (struct ptp_clock_info) {
+		.owner          = THIS_MODULE,
+		.name           = "OcteonTX2 PTP",
+		.max_adj        = 1000000000ull,
+		.n_ext_ts       = 0,
+		.n_pins         = 0,
+		.pps            = 0,
+		.adjfine        = otx2_ptp_adjfine,
+		.adjtime        = otx2_ptp_adjtime,
+		.gettime64      = otx2_ptp_gettime,
+		.settime64      = otx2_ptp_settime,
+		.enable         = otx2_ptp_enable,
+	};
+
+	ptp_ptr->ptp_clock = ptp_clock_register(&ptp_ptr->ptp_info, pfvf->dev);
+	if (IS_ERR_OR_NULL(ptp_ptr->ptp_clock)) {
+		err = ptp_ptr->ptp_clock ?
+		      PTR_ERR(ptp_ptr->ptp_clock) : -ENODEV;
+		kfree(ptp_ptr);
+		goto error;
+	}
+
+	pfvf->ptp = ptp_ptr;
+
+error:
+	return err;
+}
+
+void otx2_ptp_destroy(struct otx2_nic *pfvf)
+{
+	struct otx2_ptp *ptp = pfvf->ptp;
+
+	if (!ptp)
+		return;
+
+	ptp_clock_unregister(ptp->ptp_clock);
+	kfree(ptp);
+	pfvf->ptp = NULL;
+}
+
+int otx2_ptp_clock_index(struct otx2_nic *pfvf)
+{
+	if (!pfvf->ptp)
+		return -ENODEV;
+
+	return ptp_clock_index(pfvf->ptp->ptp_clock);
+}
+
+int otx2_ptp_tstamp2time(struct otx2_nic *pfvf, u64 tstamp, u64 *tsns)
+{
+	if (!pfvf->ptp)
+		return -ENODEV;
+
+	*tsns = timecounter_cyc2time(&pfvf->ptp->time_counter, tstamp);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h
new file mode 100644
index 0000000..706d63a
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell OcteonTx2 PTP support for ethernet driver */
+
+#ifndef OTX2_PTP_H
+#define OTX2_PTP_H
+
+int otx2_ptp_init(struct otx2_nic *pfvf);
+void otx2_ptp_destroy(struct otx2_nic *pfvf);
+
+int otx2_ptp_clock_index(struct otx2_nic *pfvf);
+int otx2_ptp_tstamp2time(struct otx2_nic *pfvf, u64 tstamp, u64 *tsns);
+
+#endif
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 3a5b34a..1f90426 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -16,6 +16,7 @@
 #include "otx2_common.h"
 #include "otx2_struct.h"
 #include "otx2_txrx.h"
+#include "otx2_ptp.h"
 
 #define CQE_ADDR(CQ, idx) ((CQ)->cqe_base + ((CQ)->cqe_size * (idx)))
 
@@ -81,8 +82,11 @@ static void otx2_snd_pkt_handler(struct otx2_nic *pfvf,
 				 int budget, int *tx_pkts, int *tx_bytes)
 {
 	struct nix_send_comp_s *snd_comp = &cqe->comp;
+	struct skb_shared_hwtstamps ts;
 	struct sk_buff *skb = NULL;
+	u64 timestamp, tsns;
 	struct sg_list *sg;
+	int err;
 
 	if (unlikely(snd_comp->status) && netif_msg_tx_err(pfvf))
 		net_err_ratelimited("%s: TX%d: Error in send CQ status:%x\n",
@@ -94,6 +98,18 @@ static void otx2_snd_pkt_handler(struct otx2_nic *pfvf,
 	if (unlikely(!skb))
 		return;
 
+	if (skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) {
+		timestamp = ((u64 *)sq->timestamps->base)[snd_comp->sqe_id];
+		if (timestamp != 1) {
+			err = otx2_ptp_tstamp2time(pfvf, timestamp, &tsns);
+			if (!err) {
+				memset(&ts, 0, sizeof(ts));
+				ts.hwtstamp = ns_to_ktime(tsns);
+				skb_tstamp_tx(skb, &ts);
+			}
+		}
+	}
+
 	*tx_bytes += skb->len;
 	(*tx_pkts)++;
 	otx2_dma_unmap_skb_frags(pfvf, sg);
@@ -101,16 +117,47 @@ static void otx2_snd_pkt_handler(struct otx2_nic *pfvf,
 	sg->skb = (u64)NULL;
 }
 
+static void otx2_set_rxtstamp(struct otx2_nic *pfvf,
+			      struct sk_buff *skb, void *data)
+{
+	u64 tsns;
+	int err;
+
+	if (!(pfvf->flags & OTX2_FLAG_RX_TSTAMP_ENABLED))
+		return;
+
+	/* The first 8 bytes is the timestamp */
+	err = otx2_ptp_tstamp2time(pfvf, be64_to_cpu(*(__be64 *)data), &tsns);
+	if (err)
+		return;
+
+	skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(tsns);
+}
+
 static void otx2_skb_add_frag(struct otx2_nic *pfvf, struct sk_buff *skb,
-			      u64 iova, int len)
+			      u64 iova, int len, struct nix_rx_parse_s *parse)
 {
 	struct page *page;
+	int off = 0;
 	void *va;
 
 	va = phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain, iova));
+
+	if (likely(!skb_shinfo(skb)->nr_frags)) {
+		/* Check if data starts at some nonzero offset
+		 * from the start of the buffer.  For now the
+		 * only possible offset is 8 bytes in the case
+		 * where packet is prepended by a timestamp.
+		 */
+		if (parse->laptr) {
+			otx2_set_rxtstamp(pfvf, skb, va);
+			off = OTX2_HW_TIMESTAMP_LEN;
+		}
+	}
+
 	page = virt_to_page(va);
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
-			va - page_address(page), len, pfvf->rbsize);
+			va - page_address(page) + off, len - off, pfvf->rbsize);
 
 	otx2_dma_unmap_page(pfvf, iova - OTX2_HEAD_ROOM,
 			    pfvf->rbsize, DMA_FROM_DEVICE);
@@ -239,7 +286,7 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 	if (unlikely(!skb))
 		return;
 
-	otx2_skb_add_frag(pfvf, skb, cqe->sg.seg_addr, cqe->sg.seg_size);
+	otx2_skb_add_frag(pfvf, skb, cqe->sg.seg_addr, cqe->sg.seg_size, parse);
 	cq->pool_ptrs++;
 
 	otx2_set_rxhash(pfvf, cqe, skb);
@@ -482,10 +529,27 @@ static void otx2_sqe_add_ext(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 			ipv6_hdr(skb)->payload_len =
 				htons(ext->lso_sb - skb_network_offset(skb));
 		}
+	} else if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+		ext->tstmp = 1;
 	}
+
 	*offset += sizeof(*ext);
 }
 
+static void otx2_sqe_add_mem(struct otx2_snd_queue *sq, int *offset,
+			     int alg, u64 iova)
+{
+	struct nix_sqe_mem_s *mem;
+
+	mem = (struct nix_sqe_mem_s *)(sq->sqe_base + *offset);
+	mem->subdc = NIX_SUBDC_MEM;
+	mem->alg = alg;
+	mem->wmem = 1; /* wait for the memory operation */
+	mem->addr = iova;
+
+	*offset += sizeof(*mem);
+}
+
 /* Add SQE header subdescriptor structure */
 static void otx2_sqe_add_hdr(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 			     struct nix_sqe_hdr_s *sqe_hdr,
@@ -736,6 +800,21 @@ static int otx2_get_sqe_count(struct otx2_nic *pfvf, struct sk_buff *skb)
 	return skb_shinfo(skb)->gso_segs;
 }
 
+static void otx2_set_txtstamp(struct otx2_nic *pfvf, struct sk_buff *skb,
+			      struct otx2_snd_queue *sq, int *offset)
+{
+	u64 iova;
+
+	if (!skb_shinfo(skb)->gso_size &&
+	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+		iova = sq->timestamps->iova + (sq->head * sizeof(u64));
+		otx2_sqe_add_mem(sq, offset, NIX_SENDMEMALG_E_SETTSTMP, iova);
+	} else {
+		skb_tx_timestamp(skb);
+	}
+}
+
 bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 			struct sk_buff *skb, u16 qidx)
 {
@@ -789,6 +868,8 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 		return false;
 	}
 
+	otx2_set_txtstamp(pfvf, skb, sq, &offset);
+
 	sqe_hdr->sizem1 = (offset / 16) - 1;
 
 	netdev_tx_sent_queue(txq, skb->len);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index da97f2d4..73af156 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -91,6 +91,7 @@ struct otx2_snd_queue {
 	struct qmem		*sqe;
 	struct qmem		*tso_hdrs;
 	struct sg_list		*sg;
+	struct qmem		*timestamps;
 	struct queue_stats	stats;
 	u16			sqb_count;
 	u64			*sqb_ptrs;
-- 
2.7.4

