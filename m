Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188D12B3056
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgKNTxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:53:37 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64312 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726156AbgKNTxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 14:53:36 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AEJphOg030021;
        Sat, 14 Nov 2020 11:53:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=tghz5pLmDIhsM/KCBAniAtCj0QZV+Q//HtnJPgu8Cw0=;
 b=QQoLZ1kz6pIyB95Fzqma0DyupEfJ3aN2CbbFlApC1vnvlbf/4h7W01A9Cq/qb1HX8Kca
 LT7irf/v1ZxuznMJ1NBnZOl1pAGa6U6UfGfN47aysWkwlw3ajhj8kq4UbXznc3sJvylQ
 2kNUFGJLsEqac7m8eG9lc0mZ4x7YTeCrJFJ/HUlWlAoxocnOLUUpABR6UvNbss464nhD
 vPO7Q7ccfV1jmqb/DIYvXgt8PF4734+AyYKF2DxdTmDERfChTHE2lEI9Bz116mKc0Lcz
 lekF7RQzSoyepd36+3aeZKet1FryHOvi8U6zwr/hcwHpxUZt1/Tqb1wnnwK1bKZLHKLc ig== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 34tdfts052-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 11:53:31 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:53:30 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:53:29 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 14 Nov 2020 11:53:29 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id B57DE3F703F;
        Sat, 14 Nov 2020 11:53:25 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <saeed@kernel.org>,
        <alexander.duyck@gmail.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [PATCH v4 net-next 05/13] octeontx2-pf: Add support for ethtool ntuple filters
Date:   Sun, 15 Nov 2020 01:22:55 +0530
Message-ID: <20201114195303.25967-6-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20201114195303.25967-1-naveenm@marvell.com>
References: <20201114195303.25967-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-14_07:2020-11-13,2020-11-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

This patch adds support for adding and deleting ethtool ntuple
filters. The filters for ether, ipv4, ipv6, tcp, udp and sctp
are supported. The mask is also supported. The supported actions
are drop and direct to a queue. Additionally we support FLOW_EXT
field vlan_tci and FLOW_MAC_EXT.

The NIX PF will allocate total 32 MCAM entries for the use of
ethtool ntuple filters. The Administrative Function(AF) will
install/delete the MCAM rules when NIX PF sends mailbox message
to install/delete the ntuple filters.

Ethtool ntuple filters support is restricted to PFs as of now
and PF can install ntuple filters to direct the traffic to its
VFs. Hence added a separate callback for VFs to get/set RSS
configuration.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  31 ++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  58 +-
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 603 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  18 +-
 5 files changed, 707 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index b2c6385707c9..4193ae3bde6b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_OCTEONTX2_PF) += octeontx2_nicpf.o
 obj-$(CONFIG_OCTEONTX2_VF) += octeontx2_nicvf.o
 
 octeontx2_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o \
-		     otx2_ptp.o
+		     otx2_ptp.o otx2_flows.o
 octeontx2_nicvf-y := otx2_vf.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 386cb08497e4..2387c40a2a8f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -18,6 +18,7 @@
 #include <linux/timecounter.h>
 
 #include <mbox.h>
+#include <npc.h>
 #include "otx2_reg.h"
 #include "otx2_txrx.h"
 #include <rvu_trace.h>
@@ -228,6 +229,16 @@ struct otx2_ptp {
 
 #define OTX2_HW_TIMESTAMP_LEN	8
 
+struct otx2_flow_config {
+	u16			entry[NPC_MAX_NONCONTIG_ENTRIES];
+	u32			nr_flows;
+#define OTX2_MAX_NTUPLE_FLOWS	32
+#define OTX2_MCAM_COUNT		OTX2_MAX_NTUPLE_FLOWS
+	u32			ntuple_offset;
+	u32                     ntuple_max_flows;
+	struct list_head	flow_list;
+};
+
 struct otx2_nic {
 	void __iomem		*reg_base;
 	struct net_device	*netdev;
@@ -238,6 +249,8 @@ struct otx2_nic {
 #define OTX2_FLAG_RX_TSTAMP_ENABLED		BIT_ULL(0)
 #define OTX2_FLAG_TX_TSTAMP_ENABLED		BIT_ULL(1)
 #define OTX2_FLAG_INTF_DOWN			BIT_ULL(2)
+#define OTX2_FLAG_MCAM_ENTRIES_ALLOC		BIT_ULL(3)
+#define OTX2_FLAG_NTUPLE_SUPPORT		BIT_ULL(4)
 #define OTX2_FLAG_RX_PAUSE_ENABLED		BIT_ULL(9)
 #define OTX2_FLAG_TX_PAUSE_ENABLED		BIT_ULL(10)
 	u64			flags;
@@ -275,6 +288,8 @@ struct otx2_nic {
 
 	struct otx2_ptp		*ptp;
 	struct hwtstamp_config	tstamp;
+
+	struct otx2_flow_config	*flow_cfg;
 };
 
 static inline bool is_otx2_lbkvf(struct pci_dev *pdev)
@@ -644,4 +659,20 @@ int otx2_open(struct net_device *netdev);
 int otx2_stop(struct net_device *netdev);
 int otx2_set_real_num_queues(struct net_device *netdev,
 			     int tx_queues, int rx_queues);
+/* MCAM filter related APIs */
+int otx2_mcam_flow_init(struct otx2_nic *pf);
+int otx2_alloc_mcam_entries(struct otx2_nic *pfvf);
+void otx2_mcam_flow_del(struct otx2_nic *pf);
+int otx2_destroy_ntuple_flows(struct otx2_nic *pf);
+int otx2_destroy_mcam_flows(struct otx2_nic *pfvf);
+int otx2_get_flow(struct otx2_nic *pfvf,
+		  struct ethtool_rxnfc *nfc, u32 location);
+int otx2_get_all_flows(struct otx2_nic *pfvf,
+		       struct ethtool_rxnfc *nfc, u32 *rule_locs);
+int otx2_add_flow(struct otx2_nic *pfvf,
+		  struct ethtool_rx_flow_spec *fsp);
+int otx2_remove_flow(struct otx2_nic *pfvf, u32 location);
+int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
+			      struct npc_install_flow_req *req);
+
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 662fb80dbb9d..67171b66a56c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -551,6 +551,16 @@ static int otx2_get_rxnfc(struct net_device *dev,
 		nfc->data = pfvf->hw.rx_queues;
 		ret = 0;
 		break;
+	case ETHTOOL_GRXCLSRLCNT:
+		nfc->rule_cnt = pfvf->flow_cfg->nr_flows;
+		ret = 0;
+		break;
+	case ETHTOOL_GRXCLSRULE:
+		ret = otx2_get_flow(pfvf, nfc,  nfc->fs.location);
+		break;
+	case ETHTOOL_GRXCLSRLALL:
+		ret = otx2_get_all_flows(pfvf, nfc, rules);
+		break;
 	case ETHTOOL_GRXFH:
 		return otx2_get_rss_hash_opts(pfvf, nfc);
 	default:
@@ -560,6 +570,50 @@ static int otx2_get_rxnfc(struct net_device *dev,
 }
 
 static int otx2_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *nfc)
+{
+	bool ntuple = !!(dev->features & NETIF_F_NTUPLE);
+	struct otx2_nic *pfvf = netdev_priv(dev);
+	int ret = -EOPNOTSUPP;
+
+	switch (nfc->cmd) {
+	case ETHTOOL_SRXFH:
+		ret = otx2_set_rss_hash_opts(pfvf, nfc);
+		break;
+	case ETHTOOL_SRXCLSRLINS:
+		if (netif_running(dev) && ntuple)
+			ret = otx2_add_flow(pfvf, &nfc->fs);
+		break;
+	case ETHTOOL_SRXCLSRLDEL:
+		if (netif_running(dev) && ntuple)
+			ret = otx2_remove_flow(pfvf, nfc->fs.location);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int otx2vf_get_rxnfc(struct net_device *dev,
+			    struct ethtool_rxnfc *nfc, u32 *rules)
+{
+	struct otx2_nic *pfvf = netdev_priv(dev);
+	int ret = -EOPNOTSUPP;
+
+	switch (nfc->cmd) {
+	case ETHTOOL_GRXRINGS:
+		nfc->data = pfvf->hw.rx_queues;
+		ret = 0;
+		break;
+	case ETHTOOL_GRXFH:
+		return otx2_get_rss_hash_opts(pfvf, nfc);
+	default:
+		break;
+	}
+	return ret;
+}
+
+static int otx2vf_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *nfc)
 {
 	struct otx2_nic *pfvf = netdev_priv(dev);
 	int ret = -EOPNOTSUPP;
@@ -806,8 +860,8 @@ static const struct ethtool_ops otx2vf_ethtool_ops = {
 	.get_sset_count		= otx2vf_get_sset_count,
 	.set_channels		= otx2_set_channels,
 	.get_channels		= otx2_get_channels,
-	.get_rxnfc		= otx2_get_rxnfc,
-	.set_rxnfc              = otx2_set_rxnfc,
+	.get_rxnfc		= otx2vf_get_rxnfc,
+	.set_rxnfc              = otx2vf_set_rxnfc,
 	.get_rxfh_key_size	= otx2_get_rxfh_key_size,
 	.get_rxfh_indir_size	= otx2_get_rxfh_indir_size,
 	.get_rxfh		= otx2_get_rxfh,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
new file mode 100644
index 000000000000..e02293ec54b1
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -0,0 +1,603 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Physcial Function ethernet driver
+ *
+ * Copyright (C) 2020 Marvell.
+ */
+
+#include <net/ipv6.h>
+
+#include "otx2_common.h"
+
+#define OTX2_DEFAULT_ACTION	0x1
+
+struct otx2_flow {
+	struct ethtool_rx_flow_spec flow_spec;
+	struct list_head list;
+	u32 location;
+	u16 entry;
+	bool is_vf;
+	int vf;
+};
+
+int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
+{
+	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
+	struct npc_mcam_alloc_entry_req *req;
+	struct npc_mcam_alloc_entry_rsp *rsp;
+	int i;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	req = otx2_mbox_alloc_msg_npc_mcam_alloc_entry(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->contig = false;
+	req->count = OTX2_MCAM_COUNT;
+
+	/* Send message to AF */
+	if (otx2_sync_mbox_msg(&pfvf->mbox)) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -EINVAL;
+	}
+
+	rsp = (struct npc_mcam_alloc_entry_rsp *)otx2_mbox_get_rsp
+	       (&pfvf->mbox.mbox, 0, &req->hdr);
+
+	if (rsp->count != req->count)
+		netdev_info(pfvf->netdev,
+			    "Unable to allocate %d MCAM entries, got %d\n",
+			    req->count, rsp->count);
+
+	flow_cfg->ntuple_max_flows = rsp->count;
+	flow_cfg->ntuple_offset = 0;
+	pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
+
+	for (i = 0; i < rsp->count; i++)
+		flow_cfg->entry[i] = rsp->entry_list[i];
+
+	pfvf->flags |= OTX2_FLAG_MCAM_ENTRIES_ALLOC;
+
+	mutex_unlock(&pfvf->mbox.lock);
+
+	return 0;
+}
+
+int otx2_mcam_flow_init(struct otx2_nic *pf)
+{
+	int err;
+
+	pf->flow_cfg = devm_kzalloc(pf->dev, sizeof(struct otx2_flow_config),
+				    GFP_KERNEL);
+	if (!pf->flow_cfg)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&pf->flow_cfg->flow_list);
+
+	pf->flow_cfg->ntuple_max_flows = OTX2_MAX_NTUPLE_FLOWS;
+
+	err = otx2_alloc_mcam_entries(pf);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+void otx2_mcam_flow_del(struct otx2_nic *pf)
+{
+	otx2_destroy_mcam_flows(pf);
+}
+
+static struct otx2_flow *otx2_find_flow(struct otx2_nic *pfvf, u32 location)
+{
+	struct otx2_flow *iter;
+
+	list_for_each_entry(iter, &pfvf->flow_cfg->flow_list, list) {
+		if (iter->location == location)
+			return iter;
+	}
+
+	return NULL;
+}
+
+static void otx2_add_flow_to_list(struct otx2_nic *pfvf, struct otx2_flow *flow)
+{
+	struct list_head *head = &pfvf->flow_cfg->flow_list;
+	struct otx2_flow *iter;
+
+	list_for_each_entry(iter, &pfvf->flow_cfg->flow_list, list) {
+		if (iter->location > flow->location)
+			break;
+		head = &iter->list;
+	}
+
+	list_add(&flow->list, head);
+}
+
+int otx2_get_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc,
+		  u32 location)
+{
+	struct otx2_flow *iter;
+
+	if (location >= pfvf->flow_cfg->ntuple_max_flows)
+		return -EINVAL;
+
+	list_for_each_entry(iter, &pfvf->flow_cfg->flow_list, list) {
+		if (iter->location == location) {
+			nfc->fs = iter->flow_spec;
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
+int otx2_get_all_flows(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc,
+		       u32 *rule_locs)
+{
+	u32 location = 0;
+	int idx = 0;
+	int err = 0;
+
+	nfc->data = pfvf->flow_cfg->ntuple_max_flows;
+	while ((!err || err == -ENOENT) && idx < nfc->rule_cnt) {
+		err = otx2_get_flow(pfvf, nfc, location);
+		if (!err)
+			rule_locs[idx++] = location;
+		location++;
+	}
+
+	return err;
+}
+
+static void otx2_prepare_ipv4_flow(struct ethtool_rx_flow_spec *fsp,
+				   struct npc_install_flow_req *req,
+				   u32 flow_type)
+{
+	struct ethtool_usrip4_spec *ipv4_usr_mask = &fsp->m_u.usr_ip4_spec;
+	struct ethtool_usrip4_spec *ipv4_usr_hdr = &fsp->h_u.usr_ip4_spec;
+	struct ethtool_tcpip4_spec *ipv4_l4_mask = &fsp->m_u.tcp_ip4_spec;
+	struct ethtool_tcpip4_spec *ipv4_l4_hdr = &fsp->h_u.tcp_ip4_spec;
+	struct flow_msg *pmask = &req->mask;
+	struct flow_msg *pkt = &req->packet;
+
+	switch (flow_type) {
+	case IP_USER_FLOW:
+		if (ipv4_usr_mask->ip4src) {
+			memcpy(&pkt->ip4src, &ipv4_usr_hdr->ip4src,
+			       sizeof(pkt->ip4src));
+			memcpy(&pmask->ip4src, &ipv4_usr_mask->ip4src,
+			       sizeof(pmask->ip4src));
+			req->features |= BIT_ULL(NPC_SIP_IPV4);
+		}
+		if (ipv4_usr_mask->ip4dst) {
+			memcpy(&pkt->ip4dst, &ipv4_usr_hdr->ip4dst,
+			       sizeof(pkt->ip4dst));
+			memcpy(&pmask->ip4dst, &ipv4_usr_mask->ip4dst,
+			       sizeof(pmask->ip4dst));
+			req->features |= BIT_ULL(NPC_DIP_IPV4);
+		}
+		break;
+	case TCP_V4_FLOW:
+	case UDP_V4_FLOW:
+	case SCTP_V4_FLOW:
+		if (ipv4_l4_mask->ip4src) {
+			memcpy(&pkt->ip4src, &ipv4_l4_hdr->ip4src,
+			       sizeof(pkt->ip4src));
+			memcpy(&pmask->ip4src, &ipv4_l4_mask->ip4src,
+			       sizeof(pmask->ip4src));
+			req->features |= BIT_ULL(NPC_SIP_IPV4);
+		}
+		if (ipv4_l4_mask->ip4dst) {
+			memcpy(&pkt->ip4dst, &ipv4_l4_hdr->ip4dst,
+			       sizeof(pkt->ip4dst));
+			memcpy(&pmask->ip4dst, &ipv4_l4_mask->ip4dst,
+			       sizeof(pmask->ip4dst));
+			req->features |= BIT_ULL(NPC_DIP_IPV4);
+		}
+		if (ipv4_l4_mask->psrc) {
+			memcpy(&pkt->sport, &ipv4_l4_hdr->psrc,
+			       sizeof(pkt->sport));
+			memcpy(&pmask->sport, &ipv4_l4_mask->psrc,
+			       sizeof(pmask->sport));
+			if (flow_type == UDP_V4_FLOW)
+				req->features |= BIT_ULL(NPC_SPORT_UDP);
+			else if (flow_type == TCP_V4_FLOW)
+				req->features |= BIT_ULL(NPC_SPORT_TCP);
+			else
+				req->features |= BIT_ULL(NPC_SPORT_SCTP);
+		}
+		if (ipv4_l4_mask->pdst) {
+			memcpy(&pkt->dport, &ipv4_l4_hdr->pdst,
+			       sizeof(pkt->dport));
+			memcpy(&pmask->dport, &ipv4_l4_mask->pdst,
+			       sizeof(pmask->dport));
+			if (flow_type == UDP_V4_FLOW)
+				req->features |= BIT_ULL(NPC_DPORT_UDP);
+			else if (flow_type == TCP_V4_FLOW)
+				req->features |= BIT_ULL(NPC_DPORT_TCP);
+			else
+				req->features |= BIT_ULL(NPC_DPORT_SCTP);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static void otx2_prepare_ipv6_flow(struct ethtool_rx_flow_spec *fsp,
+				   struct npc_install_flow_req *req,
+				   u32 flow_type)
+{
+	struct ethtool_usrip6_spec *ipv6_usr_mask = &fsp->m_u.usr_ip6_spec;
+	struct ethtool_usrip6_spec *ipv6_usr_hdr = &fsp->h_u.usr_ip6_spec;
+	struct ethtool_tcpip6_spec *ipv6_l4_mask = &fsp->m_u.tcp_ip6_spec;
+	struct ethtool_tcpip6_spec *ipv6_l4_hdr = &fsp->h_u.tcp_ip6_spec;
+	struct flow_msg *pmask = &req->mask;
+	struct flow_msg *pkt = &req->packet;
+
+	switch (flow_type) {
+	case IPV6_USER_FLOW:
+		if (!ipv6_addr_any((struct in6_addr *)ipv6_usr_mask->ip6src)) {
+			memcpy(&pkt->ip6src, &ipv6_usr_hdr->ip6src,
+			       sizeof(pkt->ip6src));
+			memcpy(&pmask->ip6src, &ipv6_usr_mask->ip6src,
+			       sizeof(pmask->ip6src));
+			req->features |= BIT_ULL(NPC_SIP_IPV6);
+		}
+		if (!ipv6_addr_any((struct in6_addr *)ipv6_usr_mask->ip6dst)) {
+			memcpy(&pkt->ip6dst, &ipv6_usr_hdr->ip6dst,
+			       sizeof(pkt->ip6dst));
+			memcpy(&pmask->ip6dst, &ipv6_usr_mask->ip6dst,
+			       sizeof(pmask->ip6dst));
+			req->features |= BIT_ULL(NPC_DIP_IPV6);
+		}
+		break;
+	case TCP_V6_FLOW:
+	case UDP_V6_FLOW:
+	case SCTP_V6_FLOW:
+		if (!ipv6_addr_any((struct in6_addr *)ipv6_l4_mask->ip6src)) {
+			memcpy(&pkt->ip6src, &ipv6_l4_hdr->ip6src,
+			       sizeof(pkt->ip6src));
+			memcpy(&pmask->ip6src, &ipv6_l4_mask->ip6src,
+			       sizeof(pmask->ip6src));
+			req->features |= BIT_ULL(NPC_SIP_IPV6);
+		}
+		if (!ipv6_addr_any((struct in6_addr *)ipv6_l4_mask->ip6dst)) {
+			memcpy(&pkt->ip6dst, &ipv6_l4_hdr->ip6dst,
+			       sizeof(pkt->ip6dst));
+			memcpy(&pmask->ip6dst, &ipv6_l4_mask->ip6dst,
+			       sizeof(pmask->ip6dst));
+			req->features |= BIT_ULL(NPC_DIP_IPV6);
+		}
+		if (ipv6_l4_mask->psrc) {
+			memcpy(&pkt->sport, &ipv6_l4_hdr->psrc,
+			       sizeof(pkt->sport));
+			memcpy(&pmask->sport, &ipv6_l4_mask->psrc,
+			       sizeof(pmask->sport));
+			if (flow_type == UDP_V6_FLOW)
+				req->features |= BIT_ULL(NPC_SPORT_UDP);
+			else if (flow_type == TCP_V6_FLOW)
+				req->features |= BIT_ULL(NPC_SPORT_TCP);
+			else
+				req->features |= BIT_ULL(NPC_SPORT_SCTP);
+		}
+		if (ipv6_l4_mask->pdst) {
+			memcpy(&pkt->dport, &ipv6_l4_hdr->pdst,
+			       sizeof(pkt->dport));
+			memcpy(&pmask->dport, &ipv6_l4_mask->pdst,
+			       sizeof(pmask->dport));
+			if (flow_type == UDP_V6_FLOW)
+				req->features |= BIT_ULL(NPC_DPORT_UDP);
+			else if (flow_type == TCP_V6_FLOW)
+				req->features |= BIT_ULL(NPC_DPORT_TCP);
+			else
+				req->features |= BIT_ULL(NPC_DPORT_SCTP);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
+			      struct npc_install_flow_req *req)
+{
+	struct ethhdr *eth_mask = &fsp->m_u.ether_spec;
+	struct ethhdr *eth_hdr = &fsp->h_u.ether_spec;
+	struct flow_msg *pmask = &req->mask;
+	struct flow_msg *pkt = &req->packet;
+	u32 flow_type;
+
+	flow_type = fsp->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT);
+	switch (flow_type) {
+	/* bits not set in mask are don't care */
+	case ETHER_FLOW:
+		if (!is_zero_ether_addr(eth_mask->h_source)) {
+			ether_addr_copy(pkt->smac, eth_hdr->h_source);
+			ether_addr_copy(pmask->smac, eth_mask->h_source);
+			req->features |= BIT_ULL(NPC_SMAC);
+		}
+		if (!is_zero_ether_addr(eth_mask->h_dest)) {
+			ether_addr_copy(pkt->dmac, eth_hdr->h_dest);
+			ether_addr_copy(pmask->dmac, eth_mask->h_dest);
+			req->features |= BIT_ULL(NPC_DMAC);
+		}
+		if (eth_mask->h_proto) {
+			memcpy(&pkt->etype, &eth_hdr->h_proto,
+			       sizeof(pkt->etype));
+			memcpy(&pmask->etype, &eth_mask->h_proto,
+			       sizeof(pmask->etype));
+			req->features |= BIT_ULL(NPC_ETYPE);
+		}
+		break;
+	case IP_USER_FLOW:
+	case TCP_V4_FLOW:
+	case UDP_V4_FLOW:
+	case SCTP_V4_FLOW:
+		otx2_prepare_ipv4_flow(fsp, req, flow_type);
+		break;
+	case IPV6_USER_FLOW:
+	case TCP_V6_FLOW:
+	case UDP_V6_FLOW:
+	case SCTP_V6_FLOW:
+		otx2_prepare_ipv6_flow(fsp, req, flow_type);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	if (fsp->flow_type & FLOW_EXT) {
+		if (fsp->m_ext.vlan_etype)
+			return -EINVAL;
+		if (fsp->m_ext.vlan_tci) {
+			if (fsp->m_ext.vlan_tci != cpu_to_be16(VLAN_VID_MASK))
+				return -EINVAL;
+			if (be16_to_cpu(fsp->h_ext.vlan_tci) >= VLAN_N_VID)
+				return -EINVAL;
+
+			memcpy(&pkt->vlan_tci, &fsp->h_ext.vlan_tci,
+			       sizeof(pkt->vlan_tci));
+			memcpy(&pmask->vlan_tci, &fsp->m_ext.vlan_tci,
+			       sizeof(pmask->vlan_tci));
+			req->features |= BIT_ULL(NPC_OUTER_VID);
+		}
+
+		/* Not Drop/Direct to queue but use action in default entry */
+		if (fsp->m_ext.data[1] &&
+		    fsp->h_ext.data[1] == cpu_to_be32(OTX2_DEFAULT_ACTION))
+			req->op = NIX_RX_ACTION_DEFAULT;
+	}
+
+	if (fsp->flow_type & FLOW_MAC_EXT &&
+	    !is_zero_ether_addr(fsp->m_ext.h_dest)) {
+		ether_addr_copy(pkt->dmac, fsp->h_ext.h_dest);
+		ether_addr_copy(pmask->dmac, fsp->m_ext.h_dest);
+		req->features |= BIT_ULL(NPC_DMAC);
+	}
+
+	if (!req->features)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static int otx2_add_flow_msg(struct otx2_nic *pfvf, struct otx2_flow *flow)
+{
+	u64 ring_cookie = flow->flow_spec.ring_cookie;
+	struct npc_install_flow_req *req;
+	int err, vf = 0;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_npc_install_flow(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	err = otx2_prepare_flow_request(&flow->flow_spec, req);
+	if (err) {
+		/* free the allocated msg above */
+		otx2_mbox_reset(&pfvf->mbox.mbox, 0);
+		mutex_unlock(&pfvf->mbox.lock);
+		return err;
+	}
+
+	req->entry = flow->entry;
+	req->intf = NIX_INTF_RX;
+	req->set_cntr = 1;
+	req->channel = pfvf->hw.rx_chan_base;
+	if (ring_cookie == RX_CLS_FLOW_DISC) {
+		req->op = NIX_RX_ACTIONOP_DROP;
+	} else {
+		/* change to unicast only if action of default entry is not
+		 * requested by user
+		 */
+		if (req->op != NIX_RX_ACTION_DEFAULT)
+			req->op = NIX_RX_ACTIONOP_UCAST;
+		req->index = ethtool_get_flow_spec_ring(ring_cookie);
+		vf = ethtool_get_flow_spec_ring_vf(ring_cookie);
+		if (vf > pci_num_vf(pfvf->pdev)) {
+			mutex_unlock(&pfvf->mbox.lock);
+			return -EINVAL;
+		}
+	}
+
+	/* ethtool ring_cookie has (VF + 1) for VF */
+	if (vf) {
+		req->vf = vf;
+		flow->is_vf = true;
+		flow->vf = vf;
+	}
+
+	/* Send message to AF */
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
+	return err;
+}
+
+int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rx_flow_spec *fsp)
+{
+	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
+	u32 ring = ethtool_get_flow_spec_ring(fsp->ring_cookie);
+	struct otx2_flow *flow;
+	bool new = false;
+	int err;
+
+	if (!(pfvf->flags & OTX2_FLAG_NTUPLE_SUPPORT))
+		return -ENOMEM;
+
+	if (ring >= pfvf->hw.rx_queues && fsp->ring_cookie != RX_CLS_FLOW_DISC)
+		return -EINVAL;
+
+	if (fsp->location >= flow_cfg->ntuple_max_flows)
+		return -EINVAL;
+
+	flow = otx2_find_flow(pfvf, fsp->location);
+	if (!flow) {
+		flow = kzalloc(sizeof(*flow), GFP_ATOMIC);
+		if (!flow)
+			return -ENOMEM;
+		flow->location = fsp->location;
+		flow->entry = flow_cfg->entry[flow_cfg->ntuple_offset +
+						flow->location];
+		new = true;
+	}
+	/* struct copy */
+	flow->flow_spec = *fsp;
+
+	err = otx2_add_flow_msg(pfvf, flow);
+	if (err) {
+		if (new)
+			kfree(flow);
+		return err;
+	}
+
+	/* add the new flow installed to list */
+	if (new) {
+		otx2_add_flow_to_list(pfvf, flow);
+		flow_cfg->nr_flows++;
+	}
+
+	return 0;
+}
+
+static int otx2_remove_flow_msg(struct otx2_nic *pfvf, u16 entry, bool all)
+{
+	struct npc_delete_flow_req *req;
+	int err;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_npc_delete_flow(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->entry = entry;
+	if (all)
+		req->all = 1;
+
+	/* Send message to AF */
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
+	return err;
+}
+
+int otx2_remove_flow(struct otx2_nic *pfvf, u32 location)
+{
+	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
+	struct otx2_flow *flow;
+	int err;
+
+	if (location >= flow_cfg->ntuple_max_flows)
+		return -EINVAL;
+
+	flow = otx2_find_flow(pfvf, location);
+	if (!flow)
+		return -ENOENT;
+
+	err = otx2_remove_flow_msg(pfvf, flow->entry, false);
+	if (err)
+		return err;
+
+	list_del(&flow->list);
+	kfree(flow);
+	flow_cfg->nr_flows--;
+
+	return 0;
+}
+
+int otx2_destroy_ntuple_flows(struct otx2_nic *pfvf)
+{
+	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
+	struct npc_delete_flow_req *req;
+	struct otx2_flow *iter, *tmp;
+	int err;
+
+	if (!(pfvf->flags & OTX2_FLAG_NTUPLE_SUPPORT))
+		return 0;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_npc_delete_flow(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->start = flow_cfg->entry[flow_cfg->ntuple_offset];
+	req->end   = flow_cfg->entry[flow_cfg->ntuple_offset +
+				      flow_cfg->ntuple_max_flows - 1];
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
+
+	list_for_each_entry_safe(iter, tmp, &flow_cfg->flow_list, list) {
+		list_del(&iter->list);
+		kfree(iter);
+		flow_cfg->nr_flows--;
+	}
+	return err;
+}
+
+int otx2_destroy_mcam_flows(struct otx2_nic *pfvf)
+{
+	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
+	struct npc_mcam_free_entry_req *req;
+	struct otx2_flow *iter, *tmp;
+	int err;
+
+	if (!(pfvf->flags & OTX2_FLAG_MCAM_ENTRIES_ALLOC))
+		return 0;
+
+	/* remove all flows */
+	err = otx2_remove_flow_msg(pfvf, 0, true);
+	if (err)
+		return err;
+
+	list_for_each_entry_safe(iter, tmp, &flow_cfg->flow_list, list) {
+		list_del(&iter->list);
+		kfree(iter);
+		flow_cfg->nr_flows--;
+	}
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_npc_mcam_free_entry(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->all = 1;
+	/* Send message to AF to free MCAM entries */
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return err;
+	}
+
+	pfvf->flags &= ~OTX2_FLAG_MCAM_ENTRIES_ALLOC;
+	mutex_unlock(&pfvf->mbox.lock);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 672768630557..9cf3e19cf1d8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1733,7 +1733,6 @@ static void otx2_do_set_rx_mode(struct work_struct *work)
 
 	req->mode = NIX_RX_MODE_UCAST;
 
-	/* We don't support MAC address filtering yet */
 	if (netdev->flags & IFF_PROMISC)
 		req->mode |= NIX_RX_MODE_PROMISC;
 	else if (netdev->flags & (IFF_ALLMULTI | IFF_MULTICAST))
@@ -1747,11 +1746,16 @@ static int otx2_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
 	netdev_features_t changed = features ^ netdev->features;
+	bool ntuple = !!(features & NETIF_F_NTUPLE);
 	struct otx2_nic *pf = netdev_priv(netdev);
 
 	if ((changed & NETIF_F_LOOPBACK) && netif_running(netdev))
 		return otx2_cgx_config_loopback(pf,
 						features & NETIF_F_LOOPBACK);
+
+	if ((changed & NETIF_F_NTUPLE) && !ntuple)
+		otx2_destroy_ntuple_flows(pf);
+
 	return 0;
 }
 
@@ -2114,6 +2118,13 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_RXALL;
 
+	err = otx2_mcam_flow_init(pf);
+	if (err)
+		goto err_ptp_destroy;
+
+	if (pf->flags & OTX2_FLAG_NTUPLE_SUPPORT)
+		netdev->hw_features |= NETIF_F_NTUPLE;
+
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
 
@@ -2126,7 +2137,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
-		goto err_ptp_destroy;
+		goto err_del_mcam_entries;
 	}
 
 	err = otx2_wq_init(pf);
@@ -2146,6 +2157,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 err_unreg_netdev:
 	unregister_netdev(netdev);
+err_del_mcam_entries:
+	otx2_mcam_flow_del(pf);
 err_ptp_destroy:
 	otx2_ptp_destroy(pf);
 err_detach_rsrc:
@@ -2304,6 +2317,7 @@ static void otx2_remove(struct pci_dev *pdev)
 		destroy_workqueue(pf->otx2_wq);
 
 	otx2_ptp_destroy(pf);
+	otx2_mcam_flow_del(pf);
 	otx2_detach_resources(&pf->mbox);
 	otx2_disable_mbox_intr(pf);
 	otx2_pfaf_mbox_destroy(pf);
-- 
2.16.5

