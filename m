Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097CD148D34
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 18:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390889AbgAXRqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 12:46:33 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43188 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390583AbgAXRqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 12:46:33 -0500
Received: by mail-pf1-f195.google.com with SMTP id s1so860370pfh.10
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 09:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/IufV2ZyWcYWLz9nu/aTmWlLpzzvz9dA/IrSq0xiKzg=;
        b=QCiWpdLeblJNNfTnIb8i8qzA5xyZxuteVeamm0BJOa0Y9JiZnQPquRcQxafMhEw3mI
         LNvC49BmN0v9UImloi+5Vx64X0onkSDNUhEH+ltZofnaqfCTunTVIwIEfa52J7fMUQS0
         MnN8ew7/hY9n3Hli9z26n9RnKhk5yPVw9bIuPf2KlZI9na1l+jcCsHQNXB/egNiYQ4Bk
         BZCl2HMKH+kFo473nG6d7oy03+RfuBeDDZL/m3mBSzIoLwwArjhbhLWU/3wbK8afdAs5
         gjnLyhGBHA4FOdAsXXmocobF5dP1ma+rp9i1vpqlKDknK09OAbNdGfWZ7nrhfKe/YUBI
         EtCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/IufV2ZyWcYWLz9nu/aTmWlLpzzvz9dA/IrSq0xiKzg=;
        b=FzHmIOae6dak0MG3GTivTzGcCme14lVFaWQsCffuiJrNkXt5r4npNzbi9Lk6Z1P2iE
         Uzfguba2xk2yfaIad1TdFONFbGdDHDzyADCz5rBbRwOXiQOqo5OmUjAObM2xZSEqAcMd
         ZEp/LlV2eGdawHbPXdW/y6hvldyuVPuNpT2B5Rn/Esnu+o4fVWmeoM/ngUb41hb9t42l
         0mI0pR0g4k4YAP7S3Mhu4oIxC6drfan3mUZH9NSnMFSZY1HMrnZ0xuxnd7qkbA05Hn3m
         pcCCIv2BRPZY9RVX2s1/tjqSb8gdy6fXHQ8uZnO4gSHA+DX8W0MV+JCRecNVmBtGe+R+
         kzdQ==
X-Gm-Message-State: APjAAAWywHsgcb95cn4sXdxoK0b3+ofly7H6YW31pGQCpkbgN4lnwZP5
        9DN0cnxI1zxjW1HDYjNlw1sYLCgSSUc=
X-Google-Smtp-Source: APXvYqxG/Ufi7nHxsIRm7XNqFw0c/aPPM3bg8RZ3yN0rEoJl+uoRk8Tx6WEarDuiPEVDCfRIwR6+7g==
X-Received: by 2002:a63:465b:: with SMTP id v27mr5454747pgk.257.1579887991460;
        Fri, 24 Jan 2020 09:46:31 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id w11sm7310849pgs.60.2020.01.24.09.46.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 Jan 2020 09:46:30 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Sunil Goutham <sgoutham@marvell.com>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [PATCH v5 09/17] octeontx2-pf: MTU, MAC and RX mode config support
Date:   Fri, 24 Jan 2020 23:15:47 +0530
Message-Id: <1579887955-22172-10-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

This patch addes support to change interface MTU, MAC address
retrieval and config, RX mode ie unicast, multicast and promiscuous.
Also added link loopback support

Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   8 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  17 ++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 108 +++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   8 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 103 +++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   4 +
 6 files changed, 242 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index a589748..8bbc1f1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -210,7 +210,8 @@ M(NIX_SET_RX_CFG,	0x8010, nix_set_rx_cfg, nix_rx_cfg, msg_rsp)	\
 M(NIX_LSO_FORMAT_CFG,	0x8011, nix_lso_format_cfg,			\
 				 nix_lso_format_cfg,			\
 				 nix_lso_format_cfg_rsp)		\
-M(NIX_RXVLAN_ALLOC,	0x8012, nix_rxvlan_alloc, msg_req, msg_rsp)
+M(NIX_RXVLAN_ALLOC,	0x8012, nix_rxvlan_alloc, msg_req, msg_rsp)	\
+M(NIX_GET_MAC_ADDR, 0x8018, nix_get_mac_addr, msg_req, nix_get_mac_addr_rsp) \
 
 /* Messages initiated by AF (range 0xC00 - 0xDFF) */
 #define MBOX_UP_CGX_MESSAGES						\
@@ -618,6 +619,11 @@ struct nix_set_mac_addr {
 	u8 mac_addr[ETH_ALEN]; /* MAC address to be set for this pcifunc */
 };
 
+struct nix_get_mac_addr_rsp {
+	struct mbox_msghdr hdr;
+	u8 mac_addr[ETH_ALEN];
+};
+
 struct nix_mark_format_cfg {
 	struct mbox_msghdr hdr;
 	u8 offset;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 8a59f7d..eb5e542 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2546,6 +2546,23 @@ int rvu_mbox_handler_nix_set_mac_addr(struct rvu *rvu,
 	return 0;
 }
 
+int rvu_mbox_handler_nix_get_mac_addr(struct rvu *rvu,
+				      struct msg_req *req,
+				      struct nix_get_mac_addr_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_pfvf *pfvf;
+
+	if (!is_nixlf_attached(rvu, pcifunc))
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+
+	ether_addr_copy(rsp->mac_addr, pfvf->mac_addr);
+
+	return 0;
+}
+
 int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
 				     struct msg_rsp *rsp)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index e9bd2d6..836b3c8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -15,6 +15,97 @@
 #include "otx2_common.h"
 #include "otx2_struct.h"
 
+/* Sync MAC address with RVU AF */
+static int otx2_hw_set_mac_addr(struct otx2_nic *pfvf, u8 *mac)
+{
+	struct nix_set_mac_addr *req;
+	int err;
+
+	otx2_mbox_lock(&pfvf->mbox);
+	req = otx2_mbox_alloc_msg_nix_set_mac_addr(&pfvf->mbox);
+	if (!req) {
+		otx2_mbox_unlock(&pfvf->mbox);
+		return -ENOMEM;
+	}
+
+	ether_addr_copy(req->mac_addr, mac);
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	otx2_mbox_unlock(&pfvf->mbox);
+	return err;
+}
+
+static int otx2_hw_get_mac_addr(struct otx2_nic *pfvf,
+				struct net_device *netdev)
+{
+	struct nix_get_mac_addr_rsp *rsp;
+	struct mbox_msghdr *msghdr;
+	struct msg_req *req;
+	int err;
+
+	otx2_mbox_lock(&pfvf->mbox);
+	req = otx2_mbox_alloc_msg_nix_get_mac_addr(&pfvf->mbox);
+	if (!req) {
+		otx2_mbox_unlock(&pfvf->mbox);
+		return -ENOMEM;
+	}
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err) {
+		otx2_mbox_unlock(&pfvf->mbox);
+		return err;
+	}
+
+	msghdr = otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+	if (!msghdr) {
+		otx2_mbox_unlock(&pfvf->mbox);
+		return -ENOMEM;
+	}
+	rsp = (struct nix_get_mac_addr_rsp *)msghdr;
+	ether_addr_copy(netdev->dev_addr, rsp->mac_addr);
+	otx2_mbox_unlock(&pfvf->mbox);
+
+	return 0;
+}
+
+int otx2_set_mac_address(struct net_device *netdev, void *p)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct sockaddr *addr = p;
+
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	if (!otx2_hw_set_mac_addr(pfvf, addr->sa_data))
+		memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	else
+		return -EPERM;
+
+	return 0;
+}
+
+int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
+{
+	struct nix_frs_cfg *req;
+	int err;
+
+	otx2_mbox_lock(&pfvf->mbox);
+	req = otx2_mbox_alloc_msg_nix_set_hw_frs(&pfvf->mbox);
+	if (!req) {
+		otx2_mbox_unlock(&pfvf->mbox);
+		return -ENOMEM;
+	}
+
+	/* SMQ config limits maximum pkt size that can be transmitted */
+	req->update_smq = true;
+	pfvf->max_frs = mtu +  OTX2_ETH_HLEN;
+	req->maxlen = pfvf->max_frs;
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	otx2_mbox_unlock(&pfvf->mbox);
+	return err;
+}
+
 void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
 {
 	/* Configure CQE interrupt coalescing parameters
@@ -63,6 +154,20 @@ dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
 	return iova;
 }
 
+void otx2_get_mac_from_af(struct net_device *netdev)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	int err;
+
+	err = otx2_hw_get_mac_addr(pfvf, netdev);
+	if (err)
+		dev_warn(pfvf->dev, "Failed to read mac from hardware\n");
+
+	/* If AF doesn't provide a valid MAC, generate a random one */
+	if (!is_valid_ether_addr(netdev->dev_addr))
+		eth_hw_addr_random(netdev);
+}
+
 static int otx2_get_link(struct otx2_nic *pfvf)
 {
 	int link = 0;
@@ -97,6 +202,9 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 	/* Set topology e.t.c configuration */
 	if (lvl == NIX_TXSCH_LVL_SMQ) {
 		req->reg[0] = NIX_AF_SMQX_CFG(schq);
+		req->regval[0] = ((pfvf->netdev->mtu  + OTX2_ETH_HLEN) << 8) |
+				   OTX2_MIN_MTU;
+
 		req->regval[0] |= (0x20ULL << 51) | (0x80ULL << 39) |
 				  (0x2ULL << 36);
 		req->num_regs++;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index e764da9..c13001c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -133,6 +133,7 @@ struct otx2_nic {
 	void __iomem		*reg_base;
 	struct net_device	*netdev;
 	void			*iommu_domain;
+	u16			max_frs;
 	u16			rbsize; /* Receive buffer size */
 
 #define OTX2_FLAG_INTF_DOWN			BIT_ULL(2)
@@ -469,7 +470,9 @@ static inline void otx2_dma_unmap_page(struct otx2_nic *pfvf,
 /* MSI-X APIs */
 void otx2_free_cints(struct otx2_nic *pfvf, int n);
 void otx2_set_cints_affinity(struct otx2_nic *pfvf);
-
+int otx2_set_mac_address(struct net_device *netdev, void *p);
+int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu);
+void otx2_get_mac_from_af(struct net_device *netdev);
 void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx);
 
 /* RVU block related APIs */
@@ -503,4 +506,7 @@ void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
 			       struct nix_lf_alloc_rsp *rsp);
 void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
 				  struct nix_txsch_alloc_rsp *rsp);
+
+int otx2_open(struct net_device *netdev);
+int otx2_stop(struct net_device *netdev);
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 8cb1cf5..60a67b9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -43,6 +43,24 @@ enum {
 	TYPE_PFVF,
 };
 
+static int otx2_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	bool if_up = netif_running(netdev);
+	int err = 0;
+
+	if (if_up)
+		otx2_stop(netdev);
+
+	netdev_info(netdev, "Changing MTU from %d to %d\n",
+		    netdev->mtu, new_mtu);
+	netdev->mtu = new_mtu;
+
+	if (if_up)
+		err = otx2_open(netdev);
+
+	return err;
+}
+
 static void otx2_queue_work(struct mbox *mw, struct workqueue_struct *mbox_wq,
 			    int first, int mdevs, u64 intr, int type)
 {
@@ -420,6 +438,27 @@ static int otx2_cgx_config_linkevents(struct otx2_nic *pf, bool enable)
 	return err;
 }
 
+static int otx2_cgx_config_loopback(struct otx2_nic *pf, bool enable)
+{
+	struct msg_req *msg;
+	int err;
+
+	otx2_mbox_lock(&pf->mbox);
+	if (enable)
+		msg = otx2_mbox_alloc_msg_cgx_intlbk_enable(&pf->mbox);
+	else
+		msg = otx2_mbox_alloc_msg_cgx_intlbk_disable(&pf->mbox);
+
+	if (!msg) {
+		otx2_mbox_unlock(&pf->mbox);
+		return -ENOMEM;
+	}
+
+	err = otx2_sync_mbox_msg(&pf->mbox);
+	otx2_mbox_unlock(&pf->mbox);
+	return err;
+}
+
 static int otx2_set_real_num_queues(struct net_device *netdev,
 				    int tx_queues, int rx_queues)
 {
@@ -519,7 +558,7 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 	hw->pool_cnt = hw->rqpool_cnt + hw->sqpool_cnt;
 
 	/* Get the size of receive buffers to allocate */
-	pf->rbsize = RCV_FRAG_LEN(pf->netdev->mtu);
+	pf->rbsize = RCV_FRAG_LEN(pf->netdev->mtu + OTX2_ETH_HLEN);
 
 	otx2_mbox_lock(mbox);
 	/* NPA init */
@@ -658,7 +697,7 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	otx2_mbox_unlock(mbox);
 }
 
-static int otx2_open(struct net_device *netdev)
+int otx2_open(struct net_device *netdev)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
 	struct otx2_cq_poll *cq_poll = NULL;
@@ -715,6 +754,11 @@ static int otx2_open(struct net_device *netdev)
 		napi_enable(&cq_poll->napi);
 	}
 
+	/* Set maximum frame size allowed in HW */
+	err = otx2_hw_set_mtu(pf, netdev->mtu);
+	if (err)
+		goto err_disable_napi;
+
 	/* Register CQ IRQ handlers */
 	vec = pf->hw.nix_msixoff + NIX_LF_CINT_VEC_START;
 	for (qidx = 0; qidx < pf->hw.cint_cnt; qidx++) {
@@ -759,6 +803,7 @@ static int otx2_open(struct net_device *netdev)
 
 err_free_cints:
 	otx2_free_cints(pf, qidx);
+err_disable_napi:
 	otx2_disable_napi(pf);
 	otx2_free_hw_resources(pf);
 err_free_mem:
@@ -768,7 +813,7 @@ static int otx2_open(struct net_device *netdev)
 	return err;
 }
 
-static int otx2_stop(struct net_device *netdev)
+int otx2_stop(struct net_device *netdev)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
 	struct otx2_cq_poll *cq_poll = NULL;
@@ -847,10 +892,53 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 }
 
+static void otx2_set_rx_mode(struct net_device *netdev)
+{
+	struct otx2_nic *pf = netdev_priv(netdev);
+	struct nix_rx_mode *req;
+
+	if (!(netdev->flags & IFF_UP))
+		return;
+
+	otx2_mbox_lock(&pf->mbox);
+	req = otx2_mbox_alloc_msg_nix_set_rx_mode(&pf->mbox);
+	if (!req) {
+		otx2_mbox_unlock(&pf->mbox);
+		return;
+	}
+
+	req->mode = NIX_RX_MODE_UCAST;
+
+	/* We don't support MAC address filtering yet */
+	if (netdev->flags & IFF_PROMISC)
+		req->mode |= NIX_RX_MODE_PROMISC;
+	else if (netdev->flags & (IFF_ALLMULTI | IFF_MULTICAST))
+		req->mode |= NIX_RX_MODE_ALLMULTI;
+
+	otx2_sync_mbox_msg(&pf->mbox);
+	otx2_mbox_unlock(&pf->mbox);
+}
+
+static int otx2_set_features(struct net_device *netdev,
+			     netdev_features_t features)
+{
+	netdev_features_t changed = features ^ netdev->features;
+	struct otx2_nic *pf = netdev_priv(netdev);
+
+	if ((changed & NETIF_F_LOOPBACK) && netif_running(netdev))
+		return otx2_cgx_config_loopback(pf,
+						features & NETIF_F_LOOPBACK);
+	return 0;
+}
+
 static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_open		= otx2_open,
 	.ndo_stop		= otx2_stop,
 	.ndo_start_xmit		= otx2_xmit,
+	.ndo_set_mac_address    = otx2_set_mac_address,
+	.ndo_change_mtu		= otx2_change_mtu,
+	.ndo_set_rx_mode	= otx2_set_rx_mode,
+	.ndo_set_features	= otx2_set_features,
 };
 
 static int otx2_check_pf_usable(struct otx2_nic *nic)
@@ -1005,6 +1093,9 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	otx2_setup_dev_hw_settings(pf);
 
+	/* Assign default mac address */
+	otx2_get_mac_from_af(netdev);
+
 	/* NPA's pool is a stack to which SW frees buffer pointers via Aura.
 	 * HW allocates buffer pointer from stack and uses it for DMA'ing
 	 * ingress packet. In some scenarios HW can free back allocated buffer
@@ -1022,10 +1113,14 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			       NETIF_F_IPV6_CSUM | NETIF_F_SG);
 	netdev->features |= netdev->hw_features;
 
-	netdev->hw_features |= NETIF_F_RXALL;
+	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_RXALL;
 
 	netdev->netdev_ops = &otx2_netdev_ops;
 
+	/* MTU range: 64 - 9190 */
+	netdev->min_mtu = OTX2_MIN_MTU;
+	netdev->max_mtu = OTX2_MAX_MTU;
+
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index d9683c3..bad2259 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -22,6 +22,10 @@
 #define OTX2_DATA_ALIGN(X)	ALIGN(X, OTX2_ALIGN)
 #define OTX2_HEAD_ROOM		OTX2_ALIGN
 
+#define	OTX2_ETH_HLEN		(VLAN_ETH_HLEN + VLAN_HLEN)
+#define	OTX2_MIN_MTU		64
+#define	OTX2_MAX_MTU		(9212 - OTX2_ETH_HLEN)
+
 #define OTX2_MAX_FRAGS_IN_SQE	9
 
 /* Rx buffer size should be in multiples of 128bytes */
-- 
2.7.4

