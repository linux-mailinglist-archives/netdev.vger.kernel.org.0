Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE5C34324C
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 13:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhCUMKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 08:10:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64980 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229946AbhCUMK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 08:10:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12LC5irE023822;
        Sun, 21 Mar 2021 05:10:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=nzGx6efE0XpJB10gNl0tVpNOWvZuY/gn5GjG2NXsVbA=;
 b=ht5B9bPXBR9Ueh4XvnPiTvzuFUZ5o01mXhaAmzaU8GOV4dOvEM43lKb9RCOTQZ5D1Ju9
 mpq9XeZsNAuNnIN2KzpDOdX3eV3lC+c3oZHtdJwpLcRnZBMprrZ6D54J2Oiu2uZ/CDb8
 nRn1upg01/LDMWdSVi8mhALoyU4tLbTMsdVyO9Xi/ylp18o+3bVZn3P4WhMQcTuKxn6T
 Ai0JdSV/Thl+5wiI/dAFmekIfUH1DWOfpfhAK89vFcR/lrllJnEC0hXLvUbNnXtx84sG
 6SPi3TSDUZUUFS0VzhR/ZYfSVPj6xlxYUcXdzstpm8+GPWz9E1N0S64GRy3LwiwT1q7b iA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37dedrab33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 21 Mar 2021 05:10:24 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 21 Mar
 2021 05:10:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 21 Mar 2021 05:10:23 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 89F593F7045;
        Sun, 21 Mar 2021 05:10:20 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH 6/8] octeontx2-pf: Support to enable EDSA/Higig2 pkts parsing
Date:   Sun, 21 Mar 2021 17:39:56 +0530
Message-ID: <20210321120958.17531-7-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210321120958.17531-1-hkelam@marvell.com>
References: <20210321120958.17531-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-21_01:2021-03-19,2021-03-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When switch headers like EDSA, Higig2 etc are present in ingress
or egress pkts the pkt parsing done by NPC needs to take additional
headers into account. KPU profile handles these using specific PKINDs
(the iKPU index) to start parsing pkts differently.

This patch enables user to configure these PKINDs into hardware for
proper pkt parsing. Patch also handles changes to max frame size due to
additional headers in pkt.

higig2:
            ethtool --set-priv-flags eth0 higig2 on/off
edsa:
            ethtool --set-priv-flags eth0 edsa on/off

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/nic/otx2_common.c       |   2 +
 .../marvell/octeontx2/nic/otx2_common.h       |  22 +++
 .../marvell/octeontx2/nic/otx2_ethtool.c      | 153 +++++++++++++++++-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   8 +
 .../marvell/octeontx2/nic/otx2_txrx.c         |   1 +
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  10 ++
 6 files changed, 188 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index cf7875d51d8..b9a5cd35061 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -230,6 +230,8 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 		return -ENOMEM;
 	}
 
+	/* Add EDSA/HIGIG2 header len to maxlen */
+	pfvf->max_frs = mtu + OTX2_ETH_HLEN + pfvf->addl_mtu;
 	req->maxlen = pfvf->max_frs;
 
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 45730d0d92f..73e927a7843 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -303,6 +303,7 @@ struct otx2_nic {
 	struct net_device	*netdev;
 	struct dev_hw_ops	*hw_ops;
 	void			*iommu_domain;
+	u16			xtra_hdr;
 	u16			max_frs;
 	u16			rbsize; /* Receive buffer size */
 
@@ -345,6 +346,25 @@ struct otx2_nic {
 	struct refill_work	*refill_wrk;
 	struct workqueue_struct	*otx2_wq;
 	struct work_struct	rx_mode_work;
+
+#define OTX2_PRIV_FLAG_PAM4			BIT(0)
+#define OTX2_PRIV_FLAG_EDSA_HDR			BIT(1)
+#define OTX2_PRIV_FLAG_HIGIG2_HDR		BIT(2)
+#define OTX2_PRIV_FLAG_DEF_MODE			BIT(3)
+#define OTX2_IS_EDSA_ENABLED(flags)		((flags) &              \
+						 OTX2_PRIV_FLAG_EDSA_HDR)
+#define OTX2_IS_HIGIG2_ENABLED(flags)		((flags) &              \
+						 OTX2_PRIV_FLAG_HIGIG2_HDR)
+#define OTX2_IS_DEF_MODE_ENABLED(flags)		((flags) &              \
+						 OTX2_PRIV_FLAG_DEF_MODE)
+	u32		        ethtool_flags;
+
+	/* extended DSA and EDSA  header lengths are 8/16 bytes
+	 * so take max length 16 bytes here
+	 */
+#define OTX2_EDSA_HDR_LEN			16
+#define OTX2_HIGIG2_HDR_LEN			16
+	u32			addl_mtu;
 	struct otx2_mac_table	*mac_table;
 
 	/* Ethtool stuff */
@@ -796,6 +816,8 @@ int otx2_open(struct net_device *netdev);
 int otx2_stop(struct net_device *netdev);
 int otx2_set_real_num_queues(struct net_device *netdev,
 			     int tx_queues, int rx_queues);
+int otx2_set_npc_parse_mode(struct otx2_nic *pfvf, bool unbind);
+
 /* MCAM filter related APIs */
 int otx2_mcam_flow_init(struct otx2_nic *pf);
 int otx2_alloc_mcam_entries(struct otx2_nic *pfvf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 552ecae1dbe..c1405611489 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -23,8 +23,9 @@
 #define DRV_VF_NAME	"octeontx2-nicvf"
 
 static const char otx2_priv_flags_strings[][ETH_GSTRING_LEN] = {
-#define OTX2_PRIV_FLAGS_PAM4 BIT(0)
 	"pam4",
+	"edsa",
+	"higig2",
 };
 
 struct otx2_stat {
@@ -1233,7 +1234,7 @@ static int otx2_set_link_ksettings(struct net_device *netdev,
 	return err;
 }
 
-static int otx2_set_priv_flags(struct net_device *netdev, u32 priv_flags)
+static int otx2_set_phy_mod_type(struct net_device *netdev, bool enable)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct cgx_phy_mod_type *req;
@@ -1253,7 +1254,7 @@ static int otx2_set_priv_flags(struct net_device *netdev, u32 priv_flags)
 	if (!req)
 		goto end;
 
-	req->mod = priv_flags & OTX2_PRIV_FLAGS_PAM4;
+	req->mod = enable;
 	if (!otx2_sync_mbox_msg(&pfvf->mbox))
 		rc = 0;
 
@@ -1262,21 +1263,157 @@ static int otx2_set_priv_flags(struct net_device *netdev, u32 priv_flags)
 	return rc;
 }
 
+int otx2_set_npc_parse_mode(struct otx2_nic *pfvf, bool unbind)
+{
+	struct npc_set_pkind *req;
+	u32 interface_mode = 0;
+	int rc = -ENOMEM;
+
+	if (OTX2_IS_DEF_MODE_ENABLED(pfvf->ethtool_flags))
+		return 0;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_npc_set_pkind(&pfvf->mbox);
+	if (!req)
+		goto end;
+
+	if (unbind) {
+		req->mode = OTX2_PRIV_FLAGS_DEFAULT;
+		interface_mode = OTX2_PRIV_FLAG_DEF_MODE;
+	} else if (OTX2_IS_HIGIG2_ENABLED(pfvf->ethtool_flags)) {
+		req->mode = OTX2_PRIV_FLAGS_HIGIG;
+		interface_mode = OTX2_PRIV_FLAG_HIGIG2_HDR;
+	} else if (OTX2_IS_EDSA_ENABLED(pfvf->ethtool_flags)) {
+		req->mode = OTX2_PRIV_FLAGS_EDSA;
+		interface_mode = OTX2_PRIV_FLAG_EDSA_HDR;
+	} else {
+		req->mode = OTX2_PRIV_FLAGS_DEFAULT;
+		interface_mode = OTX2_PRIV_FLAG_DEF_MODE;
+	}
+
+	req->dir  = PKIND_RX;
+
+	/* req AF to change pkind on both the dir */
+	if (req->mode == OTX2_PRIV_FLAGS_HIGIG ||
+	    req->mode == OTX2_PRIV_FLAGS_DEFAULT)
+		req->dir |= PKIND_TX;
+
+	if (!otx2_sync_mbox_msg(&pfvf->mbox))
+		rc = 0;
+	else
+		pfvf->ethtool_flags &= ~interface_mode;
+end:
+	mutex_unlock(&pfvf->mbox.lock);
+	return rc;
+}
+
 static u32 otx2_get_priv_flags(struct net_device *netdev)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct cgx_fw_data *rsp;
-	u32 priv_flags = 0;
 
 	rsp = otx2_get_fwdata(pfvf);
 
-	if (IS_ERR(rsp))
+	if (IS_ERR(rsp)) {
+		pfvf->ethtool_flags &= ~OTX2_PRIV_FLAG_PAM4;
+	} else {
+		if (rsp->fwdata.phy.misc.mod_type)
+			pfvf->ethtool_flags |= OTX2_PRIV_FLAG_PAM4;
+		else
+			pfvf->ethtool_flags &= ~OTX2_PRIV_FLAG_PAM4;
+	}
+	return pfvf->ethtool_flags;
+}
+
+static int otx2_enable_addl_header(struct net_device *netdev, int bitpos,
+				   u32 len, bool enable)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	bool if_up = netif_running(netdev);
+
+	if (enable) {
+		pfvf->ethtool_flags |= BIT(bitpos);
+		pfvf->ethtool_flags &= ~OTX2_PRIV_FLAG_DEF_MODE;
+	} else {
+		pfvf->ethtool_flags &= ~BIT(bitpos);
+		len = 0;
+	}
+
+	if (if_up)
+		otx2_stop(netdev);
+
+	/* Update max FRS so that additional hdrs are considered */
+	pfvf->addl_mtu = len;
+
+	/* Incase HIGIG2 mode is set packet will have 16 bytes of
+	 * extra header at start of packet which stack does not need.
+	 */
+	if (OTX2_IS_HIGIG2_ENABLED(pfvf->ethtool_flags))
+		pfvf->xtra_hdr = 16;
+	else
+		pfvf->xtra_hdr = 0;
+
+	/* NPC parse mode will be updated here */
+	if (if_up) {
+		otx2_open(netdev);
+
+		if (!enable)
+			pfvf->ethtool_flags |= OTX2_PRIV_FLAG_DEF_MODE;
+	}
+
+	return 0;
+}
+
+static int otx2_set_priv_flags(struct net_device *netdev, u32 new_flags)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	bool enable = false;
+	int bitnr, rc = 0;
+	u32 chg_flags;
+
+	/* Get latest PAM4 settings */
+	otx2_get_priv_flags(netdev);
+
+	chg_flags = new_flags ^ pfvf->ethtool_flags;
+	if (!chg_flags)
 		return 0;
 
-	if (rsp->fwdata.phy.misc.mod_type)
-		priv_flags |= OTX2_PRIV_FLAGS_PAM4;
+	/* Some are mutually exclusive, so allow only change at a time */
+	if (hweight32(chg_flags) != 1)
+		return -EINVAL;
+
+	bitnr = ffs(chg_flags) - 1;
+	if (new_flags & BIT(bitnr))
+		enable = true;
+
+	switch (BIT(bitnr)) {
+	case OTX2_PRIV_FLAG_PAM4:
+		rc = otx2_set_phy_mod_type(netdev, enable);
+		break;
+	case OTX2_PRIV_FLAG_EDSA_HDR:
+		/* HIGIG & EDSA  are mutual exclusive */
+		if (enable && OTX2_IS_HIGIG2_ENABLED(pfvf->ethtool_flags))
+			return -EINVAL;
+		return otx2_enable_addl_header(netdev, bitnr,
+					       OTX2_EDSA_HDR_LEN, enable);
+	case OTX2_PRIV_FLAG_HIGIG2_HDR:
+		if (enable && OTX2_IS_EDSA_ENABLED(pfvf->ethtool_flags))
+			return -EINVAL;
+		return otx2_enable_addl_header(netdev, bitnr,
+					       OTX2_HIGIG2_HDR_LEN, enable);
+	default:
+		break;
+	}
+
+	/* save the change */
+	if (!rc) {
+		if (enable)
+			pfvf->ethtool_flags |= BIT(bitnr);
+		else
+			pfvf->ethtool_flags &= ~BIT(bitnr);
+	}
 
-	return priv_flags;
+	return rc;
 }
 
 static const struct ethtool_ops otx2_ethtool_ops = {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 772a29ba850..977da158f1d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1639,6 +1639,9 @@ int otx2_open(struct net_device *netdev)
 	/* Restore pause frame settings */
 	otx2_config_pause_frm(pf);
 
+	/* Set NPC parsing mode */
+	otx2_set_npc_parse_mode(pf, false);
+
 	err = otx2_rxtx_enable(pf, true);
 	if (err)
 		goto err_tx_stop_queues;
@@ -2511,6 +2514,9 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
 	pf->flags |= OTX2_FLAG_TX_PAUSE_ENABLED;
 
+	/* Set interface mode as Default */
+	pf->ethtool_flags |= OTX2_PRIV_FLAG_DEF_MODE;
+
 	return 0;
 
 err_mcam_flow_del:
@@ -2671,6 +2677,8 @@ static void otx2_remove(struct pci_dev *pdev)
 	if (pf->flags & OTX2_FLAG_RX_TSTAMP_ENABLED)
 		otx2_config_hw_rx_tstamp(pf, false);
 
+	otx2_set_npc_parse_mode(pf, true);
+
 	cancel_work_sync(&pf->reset_task);
 	/* Disable link notifications */
 	otx2_cgx_config_linkevents(pf, false);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 22ec03a618b..14292e35ace 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -154,6 +154,7 @@ static void otx2_skb_add_frag(struct otx2_nic *pfvf, struct sk_buff *skb,
 			otx2_set_rxtstamp(pfvf, skb, va);
 			off = OTX2_HW_TIMESTAMP_LEN;
 		}
+		off += pfvf->xtra_hdr;
 	}
 
 	page = virt_to_page(va);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 085be90a03e..eb0c009357f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -377,6 +377,13 @@ static netdev_tx_t otx2vf_xmit(struct sk_buff *skb, struct net_device *netdev)
 	struct otx2_snd_queue *sq;
 	struct netdev_queue *txq;
 
+	/* Check for minimum and maximum packet length */
+	if (skb->len <= ETH_HLEN ||
+	    (!skb_shinfo(skb)->gso_size && skb->len > vf->max_frs)) {
+		dev_kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
 	sq = &vf->qset.sq[qidx];
 	txq = netdev_get_tx_queue(netdev, qidx);
 
@@ -612,6 +619,9 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	vf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
 	vf->flags |= OTX2_FLAG_TX_PAUSE_ENABLED;
 
+	/* Set interface mode as Default */
+	vf->ethtool_flags |= OTX2_PRIV_FLAG_DEF_MODE;
+
 	return 0;
 
 err_detach_rsrc:
-- 
2.17.1

