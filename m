Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D2218D805
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 19:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgCTS5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 14:57:53 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:38597 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCTS5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 14:57:53 -0400
Received: by mail-pj1-f65.google.com with SMTP id m15so2888732pje.3
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 11:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r4rb264qhk/2aICukXMEjEP5D2PDdP9qDbfxocNHAWE=;
        b=WwD90k1aCP3i7Tqsp13t0Mapm5MPWfyCjGGh7VuhHO8ASl6gIh9dWcVnTTGRL8ZCoH
         jEMZ0Ajw5LacoEDcURHWId67ZAYk1EXT7x8owmuGB2js2hioyYjbmXbIubM1Nk+8Gkac
         Ei06PKvBjpuwWklUVyhaMYfQ5RMFXwZ1kxNmgQbxpoBQwv8Dbv+unnrFQP+N8zE0u7do
         jCUJDCC+qpyxANGzET/DZMAWiwAfYhR8THhf8vXPwokIsF/3fJVpn5zZQkw47jRkmlDv
         hysCuCcxQWf0SutC7A4xrNy08O7aoKWJ+4eMs9V4g9SVPmFZzqQdH9+6OyijVmLZ0Z/z
         n6JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r4rb264qhk/2aICukXMEjEP5D2PDdP9qDbfxocNHAWE=;
        b=F/ajW68ucD6F2TZXqFuaCo7kJRmKhGvrCULdpjkjtyowE2Cj7E2lDlcHQaw4qXeFZr
         xbZqlbufaUdgSpuweE7JkB2h5intk3bnWvl03wf3D94HArK74vg0ouFabgOcmH4i0NNj
         fUtd3hWx9wyVUzBjmM8v/h+TsIsYQl3Si/rn1rdHXNqlkb9W3Z9sqnXcvAC0sjP2tfu2
         sR6PuppKyzVmpNE/vci03bK72SO3pna7aTyRI1DUajp7zwbD9I97UbgwJ4VkE4794ImJ
         HItrPTxScpP4fL0up3I22fxUkNIpdbYEb7zl9drnsDlRtQu6CHA5RjtXi0gOwRYhPaib
         dw1Q==
X-Gm-Message-State: ANhLgQ32DZOdEW6AfRrS+R8+4FxCCh1jHsld8M2rO3WveYO+qub79aZl
        2F3P83VNaF2AP6jUEU1SHiKmw0513o4=
X-Google-Smtp-Source: ADFU+vtCBgI94jgEL5BC07DCfTI+xSRF1VoA9rBHYecCu8rZpiyDOBfAprxRnUH1DbNIxd9OGD2qZQ==
X-Received: by 2002:a17:90a:ad97:: with SMTP id s23mr11044969pjq.179.1584730671443;
        Fri, 20 Mar 2020 11:57:51 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id l59sm2407044pjb.2.2020.03.20.11.57.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Mar 2020 11:57:50 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        andrew@lunn.ch, Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v4 net-next 4/8] octeontx2-vf: Ethtool support
Date:   Sat, 21 Mar 2020 00:27:22 +0530
Message-Id: <1584730646-15953-5-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tomasz Duszynski <tduszynski@marvell.com>

Added ethtool support for VF devices for
 - Driver stats, Tx/Rx perqueue stats
 - Set/show Rx/Tx queue count
 - Set/show Rx/Tx ring sizes
 - Set/show IRQ coalescing parameters
 - RSS configuration etc

It's the PF which owns the interface, hence VF
cannot display underlying CGX interface stats.
Except for this rest ethtool support reuses PF's
APIs.

Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   1 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 128 ++++++++++++++++++---
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   2 +
 3 files changed, 117 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index f817b3f..701bdfa 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -631,6 +631,7 @@ void otx2_update_lmac_stats(struct otx2_nic *pfvf);
 int otx2_update_rq_stats(struct otx2_nic *pfvf, int qidx);
 int otx2_update_sq_stats(struct otx2_nic *pfvf, int qidx);
 void otx2_set_ethtool_ops(struct net_device *netdev);
+void otx2vf_set_ethtool_ops(struct net_device *netdev);
 
 int otx2_open(struct net_device *netdev);
 int otx2_stop(struct net_device *netdev);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 017a295..d59f5a9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -17,6 +17,7 @@
 #include "otx2_common.h"
 
 #define DRV_NAME	"octeontx2-nicpf"
+#define DRV_VF_NAME	"octeontx2-nicvf"
 
 struct otx2_stat {
 	char name[ETH_GSTRING_LEN];
@@ -63,16 +64,6 @@ static const unsigned int otx2_n_dev_stats = ARRAY_SIZE(otx2_dev_stats);
 static const unsigned int otx2_n_drv_stats = ARRAY_SIZE(otx2_drv_stats);
 static const unsigned int otx2_n_queue_stats = ARRAY_SIZE(otx2_queue_stats);
 
-static void otx2_dev_open(struct net_device *netdev)
-{
-	otx2_open(netdev);
-}
-
-static void otx2_dev_stop(struct net_device *netdev)
-{
-	otx2_stop(netdev);
-}
-
 static void otx2_get_drvinfo(struct net_device *netdev,
 			     struct ethtool_drvinfo *info)
 {
@@ -232,7 +223,7 @@ static int otx2_set_channels(struct net_device *dev,
 		return -EINVAL;
 
 	if (if_up)
-		otx2_dev_stop(dev);
+		dev->netdev_ops->ndo_stop(dev);
 
 	err = otx2_set_real_num_queues(dev, channel->tx_count,
 				       channel->rx_count);
@@ -245,7 +236,7 @@ static int otx2_set_channels(struct net_device *dev,
 
 fail:
 	if (if_up)
-		otx2_dev_open(dev);
+		dev->netdev_ops->ndo_open(dev);
 
 	netdev_info(dev, "Setting num Tx rings to %d, Rx rings to %d success\n",
 		    pfvf->hw.tx_queues, pfvf->hw.rx_queues);
@@ -259,6 +250,9 @@ static void otx2_get_pauseparam(struct net_device *netdev,
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct cgx_pause_frm_cfg *req, *rsp;
 
+	if (is_otx2_lbkvf(pfvf->pdev))
+		return;
+
 	req = otx2_mbox_alloc_msg_cgx_cfg_pause_frm(&pfvf->mbox);
 	if (!req)
 		return;
@@ -279,6 +273,9 @@ static int otx2_set_pauseparam(struct net_device *netdev,
 	if (pause->autoneg)
 		return -EOPNOTSUPP;
 
+	if (is_otx2_lbkvf(pfvf->pdev))
+		return -EOPNOTSUPP;
+
 	if (pause->rx_pause)
 		pfvf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
 	else
@@ -336,14 +333,15 @@ static int otx2_set_ringparam(struct net_device *netdev,
 		return 0;
 
 	if (if_up)
-		otx2_dev_stop(netdev);
+		netdev->netdev_ops->ndo_stop(netdev);
 
 	/* Assigned to the nearest possible exponent. */
 	qs->sqe_cnt = tx_count;
 	qs->rqe_cnt = rx_count;
 
 	if (if_up)
-		otx2_dev_open(netdev);
+		netdev->netdev_ops->ndo_open(netdev);
+
 	return 0;
 }
 
@@ -659,6 +657,9 @@ static u32 otx2_get_link(struct net_device *netdev)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 
+	/* LBK link is internal and always UP */
+	if (is_otx2_lbkvf(pfvf->pdev))
+		return 1;
 	return pfvf->linfo.link_up;
 }
 
@@ -692,3 +693,102 @@ void otx2_set_ethtool_ops(struct net_device *netdev)
 {
 	netdev->ethtool_ops = &otx2_ethtool_ops;
 }
+
+/* VF's ethtool APIs */
+static void otx2vf_get_drvinfo(struct net_device *netdev,
+			       struct ethtool_drvinfo *info)
+{
+	struct otx2_nic *vf = netdev_priv(netdev);
+
+	strlcpy(info->driver, DRV_VF_NAME, sizeof(info->driver));
+	strlcpy(info->bus_info, pci_name(vf->pdev), sizeof(info->bus_info));
+}
+
+static void otx2vf_get_strings(struct net_device *netdev, u32 sset, u8 *data)
+{
+	struct otx2_nic *vf = netdev_priv(netdev);
+	int stats;
+
+	if (sset != ETH_SS_STATS)
+		return;
+
+	for (stats = 0; stats < otx2_n_dev_stats; stats++) {
+		memcpy(data, otx2_dev_stats[stats].name, ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
+	}
+
+	for (stats = 0; stats < otx2_n_drv_stats; stats++) {
+		memcpy(data, otx2_drv_stats[stats].name, ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
+	}
+
+	otx2_get_qset_strings(vf, &data, 0);
+
+	strcpy(data, "reset_count");
+	data += ETH_GSTRING_LEN;
+}
+
+static void otx2vf_get_ethtool_stats(struct net_device *netdev,
+				     struct ethtool_stats *stats, u64 *data)
+{
+	struct otx2_nic *vf = netdev_priv(netdev);
+	int stat;
+
+	otx2_get_dev_stats(vf);
+	for (stat = 0; stat < otx2_n_dev_stats; stat++)
+		*(data++) = ((u64 *)&vf->hw.dev_stats)
+				[otx2_dev_stats[stat].index];
+
+	for (stat = 0; stat < otx2_n_drv_stats; stat++)
+		*(data++) = atomic_read(&((atomic_t *)&vf->hw.drv_stats)
+						[otx2_drv_stats[stat].index]);
+
+	otx2_get_qset_stats(vf, stats, &data);
+	*(data++) = vf->reset_count;
+}
+
+static int otx2vf_get_sset_count(struct net_device *netdev, int sset)
+{
+	struct otx2_nic *vf = netdev_priv(netdev);
+	int qstats_count;
+
+	if (sset != ETH_SS_STATS)
+		return -EINVAL;
+
+	qstats_count = otx2_n_queue_stats *
+		       (vf->hw.rx_queues + vf->hw.tx_queues);
+
+	return otx2_n_dev_stats + otx2_n_drv_stats + qstats_count + 1;
+}
+
+static const struct ethtool_ops otx2vf_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES,
+	.get_link		= otx2_get_link,
+	.get_drvinfo		= otx2vf_get_drvinfo,
+	.get_strings		= otx2vf_get_strings,
+	.get_ethtool_stats	= otx2vf_get_ethtool_stats,
+	.get_sset_count		= otx2vf_get_sset_count,
+	.set_channels		= otx2_set_channels,
+	.get_channels		= otx2_get_channels,
+	.get_rxnfc		= otx2_get_rxnfc,
+	.set_rxnfc              = otx2_set_rxnfc,
+	.get_rxfh_key_size	= otx2_get_rxfh_key_size,
+	.get_rxfh_indir_size	= otx2_get_rxfh_indir_size,
+	.get_rxfh		= otx2_get_rxfh,
+	.set_rxfh		= otx2_set_rxfh,
+	.get_ringparam		= otx2_get_ringparam,
+	.set_ringparam		= otx2_set_ringparam,
+	.get_coalesce		= otx2_get_coalesce,
+	.set_coalesce		= otx2_set_coalesce,
+	.get_msglevel		= otx2_get_msglevel,
+	.set_msglevel		= otx2_set_msglevel,
+	.get_pauseparam		= otx2_get_pauseparam,
+	.set_pauseparam		= otx2_set_pauseparam,
+};
+
+void otx2vf_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &otx2vf_ethtool_ops;
+}
+EXPORT_SYMBOL(otx2vf_set_ethtool_ops);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 2b5c38d..b2727b6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -579,6 +579,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_detach_rsrc;
 	}
 
+	otx2vf_set_ethtool_ops(netdev);
+
 	/* Enable pause frames by default */
 	vf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
 	vf->flags |= OTX2_FLAG_TX_PAUSE_ENABLED;
-- 
2.7.4

