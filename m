Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DFA3402A5
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 11:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhCRKCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 06:02:46 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9758 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229890AbhCRKCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 06:02:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IA10P2004318;
        Thu, 18 Mar 2021 03:02:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=8wyKw4sQdoXP6B0eBeWnrlNLERdKi0NeHR4mlB/XMxE=;
 b=BwvmBkOV1SzrNYnd8t/QxpHxzazIL3dYZ0PKWr6VP0c52yemT0CloO8gI26NZDPdnEoX
 lw7QiVAxtgdpUa5ElCJy0/g+q+nG9Nwzv8j+QPI7zf6z7mmXbOV0TtLnnTRIdaR8LFl1
 VWrHK7XMSl+IdJ4vFipRofEQdc2gYhF7d2bpjV2WBnhua9ygg5Pp9ppjnjDQv1CxOR53
 skIdbjZ8Wszwd57pn+g2pjeLHlS1aArz+yv/zZyszVdxf7sJi9qXbqKkDaYyJRfjJrZx
 SAyi48y67W/Ogf5Vkf313o1SV8xAPdbkgcvkxx88+8jAib21y1AqWQOgdqD5NEb/q64M 8w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37b5vdnrff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 03:02:32 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Mar
 2021 03:02:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Mar 2021 03:02:31 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id E93E43F7043;
        Thu, 18 Mar 2021 03:02:27 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <jerinj@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, "Naveen Mamindlapalli" <naveenm@marvell.com>
Subject: [PATCH net-next 2/4] octeontx2-pf: Add tc flower hardware offload on ingress traffic
Date:   Thu, 18 Mar 2021 15:32:13 +0530
Message-ID: <20210318100215.15795-3-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20210318100215.15795-1-naveenm@marvell.com>
References: <20210318100215.15795-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_04:2021-03-17,2021-03-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for tc flower hardware offload on ingress
traffic. Since the tc-flower filter rules use the same set of MCAM
rules as the n-tuple filters, the n-tuple filters and tc flower
rules are mutually exclusive. When one of the feature is enabled
using ethtool, the other feature is disabled in the driver. By default
the driver enables n-tuple filters during initialization.

The following flow keys are supported.
    -> Ethernet: dst_mac
    -> L2 proto: all protocols
    -> VLAN (802.1q): vlan_id/vlan_prio
    -> IPv4: dst_ip/src_ip/ip_proto{tcp|udp|sctp|icmp}/ip_tos
    -> IPv6: ip_proto{icmpv6}
    -> L4(tcp/udp/sctp): dst_port/src_port

The following flow actions are supported.
    -> drop
    -> accept
    -> redirect
    -> vlan pop

The flow action supports multiple actions when vlan pop is specified
as the first action. The redirect action supports redirecting to the
PF/VF of same PCI device. Redirecting to other PCI NIX devices is not
supported.

Example #1: Add a tc filter rule to drop UDP traffic with dest port 80
    # ethtool -K eth0 hw-tc-offload on
    # tc qdisc add dev eth0 ingress
    # tc filter add dev eth0 protocol ip parent ffff: flower ip_proto \
          udp dst_port 80 action drop

Example #2: Add a tc filter rule to redirect ingress traffic on eth0
with vlan id 3 to eth6 (ex: eth0 vf0) after stripping the vlan hdr.
    # ethtool -K eth0 hw-tc-offload on
    # tc qdisc add dev eth0 ingress
    # tc filter add dev eth0 parent ffff: protocol 802.1Q flower \
          vlan_id 3 vlan_ethtype ipv4 action vlan pop action mirred \
          ingress redirect dev eth6

Example #3: List the ingress filter rules
    # tc -s filter show dev eth4 ingress

Example #4: Delete tc flower filter rule with handle 0x1
    # tc filter del dev eth0 ingress protocol ip pref 49152 \
      handle 1 flower

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   2 +-
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  19 +
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |   5 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  37 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   | 488 +++++++++++++++++++++
 6 files changed, 551 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index c8836d48a614..741da112fdf0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -2002,7 +2002,7 @@ static void rvu_dbg_npc_mcam_show_flows(struct seq_file *s,
 			seq_printf(s, "mask 0x%x\n", ntohs(rule->mask.etype));
 			break;
 		case NPC_OUTER_VID:
-			seq_printf(s, "%d ", ntohs(rule->packet.vlan_tci));
+			seq_printf(s, "0x%x ", ntohs(rule->packet.vlan_tci));
 			seq_printf(s, "mask 0x%x\n",
 				   ntohs(rule->mask.vlan_tci));
 			break;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index 745aa8a19499..457c94793e63 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_OCTEONTX2_PF) += rvu_nicpf.o
 obj-$(CONFIG_OCTEONTX2_VF) += rvu_nicvf.o
 
 rvu_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o \
-		     otx2_ptp.o otx2_flows.o cn10k.o
+		     otx2_ptp.o otx2_flows.o otx2_tc.o cn10k.o
 rvu_nicvf-y := otx2_vf.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index a518c2283f18..992aa93178e1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -18,6 +18,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
 #include <linux/soc/marvell/octeontx2/asm.h>
+#include <net/pkt_cls.h>
 
 #include <mbox.h>
 #include <npc.h>
@@ -264,6 +265,7 @@ struct otx2_flow_config {
 #define OTX2_MAX_NTUPLE_FLOWS	32
 #define OTX2_MAX_UNICAST_FLOWS	8
 #define OTX2_MAX_VLAN_FLOWS	1
+#define OTX2_MAX_TC_FLOWS	OTX2_MAX_NTUPLE_FLOWS
 #define OTX2_MCAM_COUNT		(OTX2_MAX_NTUPLE_FLOWS + \
 				 OTX2_MAX_UNICAST_FLOWS + \
 				 OTX2_MAX_VLAN_FLOWS)
@@ -274,10 +276,20 @@ struct otx2_flow_config {
 #define OTX2_PER_VF_VLAN_FLOWS	2 /* rx+tx per VF */
 #define OTX2_VF_VLAN_RX_INDEX	0
 #define OTX2_VF_VLAN_TX_INDEX	1
+	u32			tc_flower_offset;
 	u32                     ntuple_max_flows;
+	u32			tc_max_flows;
 	struct list_head	flow_list;
 };
 
+struct otx2_tc_info {
+	/* hash table to store TC offloaded flows */
+	struct rhashtable		flow_table;
+	struct rhashtable_params	flow_ht_params;
+	DECLARE_BITMAP(tc_entries_bitmap, OTX2_MAX_TC_FLOWS);
+	unsigned long			num_entries;
+};
+
 struct dev_hw_ops {
 	int	(*sq_aq_init)(void *dev, u16 qidx, u16 sqb_aura);
 	void	(*sqe_flush)(void *dev, struct otx2_snd_queue *sq,
@@ -305,6 +317,7 @@ struct otx2_nic {
 #define OTX2_FLAG_PF_SHUTDOWN			BIT_ULL(8)
 #define OTX2_FLAG_RX_PAUSE_ENABLED		BIT_ULL(9)
 #define OTX2_FLAG_TX_PAUSE_ENABLED		BIT_ULL(10)
+#define OTX2_FLAG_TC_FLOWER_SUPPORT		BIT_ULL(11)
 	u64			flags;
 
 	struct otx2_qset	qset;
@@ -347,6 +360,7 @@ struct otx2_nic {
 	struct hwtstamp_config	tstamp;
 
 	struct otx2_flow_config	*flow_cfg;
+	struct otx2_tc_info	tc_info;
 };
 
 static inline bool is_otx2_lbkvf(struct pci_dev *pdev)
@@ -802,4 +816,9 @@ int otx2_add_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_enable_rxvlan(struct otx2_nic *pf, bool enable);
 int otx2_install_rxvlan_offload_flow(struct otx2_nic *pfvf);
 u16 otx2_get_max_mtu(struct otx2_nic *pfvf);
+/* tc support */
+int otx2_init_tc(struct otx2_nic *nic);
+void otx2_shutdown_tc(struct otx2_nic *nic);
+int otx2_setup_tc(struct net_device *netdev, enum tc_setup_type type,
+		  void *type_data);
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 3264cb793f02..fa7a46aa15ef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -57,10 +57,13 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 		flow_cfg->ntuple_max_flows = rsp->count;
 		flow_cfg->ntuple_offset = 0;
 		pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
+		flow_cfg->tc_max_flows = flow_cfg->ntuple_max_flows;
+		pfvf->flags |= OTX2_FLAG_TC_FLOWER_SUPPORT;
 	} else {
 		flow_cfg->vf_vlan_offset = 0;
 		flow_cfg->ntuple_offset = flow_cfg->vf_vlan_offset +
 						vf_vlan_max_flows;
+		flow_cfg->tc_flower_offset = flow_cfg->ntuple_offset;
 		flow_cfg->unicast_offset = flow_cfg->ntuple_offset +
 						OTX2_MAX_NTUPLE_FLOWS;
 		flow_cfg->rx_vlan_offset = flow_cfg->unicast_offset +
@@ -69,6 +72,7 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 		pfvf->flags |= OTX2_FLAG_UCAST_FLTR_SUPPORT;
 		pfvf->flags |= OTX2_FLAG_RX_VLAN_SUPPORT;
 		pfvf->flags |= OTX2_FLAG_VF_VLAN_SUPPORT;
+		pfvf->flags |= OTX2_FLAG_TC_FLOWER_SUPPORT;
 	}
 
 	for (i = 0; i < rsp->count; i++)
@@ -93,6 +97,7 @@ int otx2_mcam_flow_init(struct otx2_nic *pf)
 	INIT_LIST_HEAD(&pf->flow_cfg->flow_list);
 
 	pf->flow_cfg->ntuple_max_flows = OTX2_MAX_NTUPLE_FLOWS;
+	pf->flow_cfg->tc_max_flows = pf->flow_cfg->ntuple_max_flows;
 
 	err = otx2_alloc_mcam_entries(pf);
 	if (err)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 53ab1814d74b..772a29ba8503 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1760,6 +1760,24 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 }
 
+static netdev_features_t otx2_fix_features(struct net_device *dev,
+					   netdev_features_t features)
+{
+	/* check if n-tuple filters are ON */
+	if ((features & NETIF_F_HW_TC) && (dev->features & NETIF_F_NTUPLE)) {
+		netdev_info(dev, "Disabling n-tuple filters\n");
+		features &= ~NETIF_F_NTUPLE;
+	}
+
+	/* check if tc hw offload is ON */
+	if ((features & NETIF_F_NTUPLE) && (dev->features & NETIF_F_HW_TC)) {
+		netdev_info(dev, "Disabling TC hardware offload\n");
+		features &= ~NETIF_F_HW_TC;
+	}
+
+	return features;
+}
+
 static void otx2_set_rx_mode(struct net_device *netdev)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
@@ -1822,6 +1840,12 @@ static int otx2_set_features(struct net_device *netdev,
 	if ((changed & NETIF_F_NTUPLE) && !ntuple)
 		otx2_destroy_ntuple_flows(pf);
 
+	if ((netdev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
+	    pf->tc_info.num_entries) {
+		netdev_err(netdev, "Can't disable TC hardware offload while flows are active\n");
+		return -EBUSY;
+	}
+
 	return 0;
 }
 
@@ -2220,6 +2244,7 @@ static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_open		= otx2_open,
 	.ndo_stop		= otx2_stop,
 	.ndo_start_xmit		= otx2_xmit,
+	.ndo_fix_features	= otx2_fix_features,
 	.ndo_set_mac_address    = otx2_set_mac_address,
 	.ndo_change_mtu		= otx2_change_mtu,
 	.ndo_set_rx_mode	= otx2_set_rx_mode,
@@ -2230,6 +2255,7 @@ static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_set_vf_mac		= otx2_set_vf_mac,
 	.ndo_set_vf_vlan	= otx2_set_vf_vlan,
 	.ndo_get_vf_config	= otx2_get_vf_config,
+	.ndo_setup_tc		= otx2_setup_tc,
 };
 
 static int otx2_wq_init(struct otx2_nic *pf)
@@ -2449,6 +2475,10 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 				       NETIF_F_HW_VLAN_STAG_RX;
 	netdev->features |= netdev->hw_features;
 
+	/* HW supports tc offload but mutually exclusive with n-tuple filters */
+	if (pf->flags & OTX2_FLAG_TC_FLOWER_SUPPORT)
+		netdev->hw_features |= NETIF_F_HW_TC;
+
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
 
@@ -2470,6 +2500,10 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	otx2_set_ethtool_ops(netdev);
 
+	err = otx2_init_tc(pf);
+	if (err)
+		goto err_mcam_flow_del;
+
 	/* Enable link notifications */
 	otx2_cgx_config_linkevents(pf, true);
 
@@ -2479,6 +2513,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
+err_mcam_flow_del:
+	otx2_mcam_flow_del(pf);
 err_unreg_netdev:
 	unregister_netdev(netdev);
 err_del_mcam_entries:
@@ -2646,6 +2682,7 @@ static void otx2_remove(struct pci_dev *pdev)
 
 	otx2_ptp_destroy(pf);
 	otx2_mcam_flow_del(pf);
+	otx2_shutdown_tc(pf);
 	otx2_detach_resources(&pf->mbox);
 	if (pf->hw.lmt_base)
 		iounmap(pf->hw.lmt_base);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
new file mode 100644
index 000000000000..a361eec568a2
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -0,0 +1,488 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Physcial Function ethernet driver
+ *
+ * Copyright (C) 2021 Marvell.
+ */
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/inetdevice.h>
+#include <linux/rhashtable.h>
+#include <net/flow_dissector.h>
+#include <net/pkt_cls.h>
+#include <net/tc_act/tc_gact.h>
+#include <net/tc_act/tc_mirred.h>
+#include <net/tc_act/tc_vlan.h>
+#include <net/ipv6.h>
+
+#include "otx2_common.h"
+
+struct otx2_tc_flow {
+	struct rhash_head		node;
+	unsigned long			cookie;
+	u16				entry;
+	unsigned int			bitpos;
+	struct rcu_head			rcu;
+};
+
+static int otx2_tc_parse_actions(struct otx2_nic *nic,
+				 struct flow_action *flow_action,
+				 struct npc_install_flow_req *req)
+{
+	struct flow_action_entry *act;
+	struct net_device *target;
+	struct otx2_nic *priv;
+	int i;
+
+	if (!flow_action_has_entries(flow_action)) {
+		netdev_info(nic->netdev, "no tc actions specified");
+		return -EINVAL;
+	}
+
+	flow_action_for_each(i, act, flow_action) {
+		switch (act->id) {
+		case FLOW_ACTION_DROP:
+			req->op = NIX_RX_ACTIONOP_DROP;
+			return 0;
+		case FLOW_ACTION_ACCEPT:
+			req->op = NIX_RX_ACTION_DEFAULT;
+			return 0;
+		case FLOW_ACTION_REDIRECT_INGRESS:
+			target = act->dev;
+			priv = netdev_priv(target);
+			/* npc_install_flow_req doesn't support passing a target pcifunc */
+			if (rvu_get_pf(nic->pcifunc) != rvu_get_pf(priv->pcifunc)) {
+				netdev_info(nic->netdev,
+					    "can't redirect to other pf/vf\n");
+				return -EOPNOTSUPP;
+			}
+			req->vf = priv->pcifunc & RVU_PFVF_FUNC_MASK;
+			req->op = NIX_RX_ACTION_DEFAULT;
+			return 0;
+		case FLOW_ACTION_VLAN_POP:
+			req->vtag0_valid = true;
+			/* use RX_VTAG_TYPE7 which is initialized to strip vlan tag */
+			req->vtag0_type = NIX_AF_LFX_RX_VTAG_TYPE7;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	}
+
+	return 0;
+}
+
+static int otx2_tc_prepare_flow(struct otx2_nic *nic,
+				struct flow_cls_offload *f,
+				struct npc_install_flow_req *req)
+{
+	struct flow_msg *flow_spec = &req->packet;
+	struct flow_msg *flow_mask = &req->mask;
+	struct flow_dissector *dissector;
+	struct flow_rule *rule;
+	u8 ip_proto = 0;
+
+	rule = flow_cls_offload_flow_rule(f);
+	dissector = rule->match.dissector;
+
+	if ((dissector->used_keys &
+	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
+	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_VLAN) |
+	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
+	      BIT(FLOW_DISSECTOR_KEY_IP))))  {
+		netdev_info(nic->netdev, "unsupported flow used key 0x%x",
+			    dissector->used_keys);
+		return -EOPNOTSUPP;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+
+		flow_rule_match_basic(rule, &match);
+
+		/* All EtherTypes can be matched, no hw limitation */
+		flow_spec->etype = match.key->n_proto;
+		flow_mask->etype = match.mask->n_proto;
+		req->features |= BIT_ULL(NPC_ETYPE);
+
+		if (match.mask->ip_proto &&
+		    (match.key->ip_proto != IPPROTO_TCP &&
+		     match.key->ip_proto != IPPROTO_UDP &&
+		     match.key->ip_proto != IPPROTO_SCTP &&
+		     match.key->ip_proto != IPPROTO_ICMP &&
+		     match.key->ip_proto != IPPROTO_ICMPV6)) {
+			netdev_info(nic->netdev,
+				    "ip_proto=0x%x not supported\n",
+				    match.key->ip_proto);
+			return -EOPNOTSUPP;
+		}
+		if (match.mask->ip_proto)
+			ip_proto = match.key->ip_proto;
+
+		if (ip_proto == IPPROTO_UDP)
+			req->features |= BIT_ULL(NPC_IPPROTO_UDP);
+		else if (ip_proto == IPPROTO_TCP)
+			req->features |= BIT_ULL(NPC_IPPROTO_TCP);
+		else if (ip_proto == IPPROTO_SCTP)
+			req->features |= BIT_ULL(NPC_IPPROTO_SCTP);
+		else if (ip_proto == IPPROTO_ICMP)
+			req->features |= BIT_ULL(NPC_IPPROTO_ICMP);
+		else if (ip_proto == IPPROTO_ICMPV6)
+			req->features |= BIT_ULL(NPC_IPPROTO_ICMP6);
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match;
+
+		flow_rule_match_eth_addrs(rule, &match);
+		if (!is_zero_ether_addr(match.mask->src)) {
+			netdev_err(nic->netdev, "src mac match not supported\n");
+			return -EOPNOTSUPP;
+		}
+
+		if (!is_zero_ether_addr(match.mask->dst)) {
+			ether_addr_copy(flow_spec->dmac, (u8 *)&match.key->dst);
+			ether_addr_copy(flow_mask->dmac,
+					(u8 *)&match.mask->dst);
+			req->features |= BIT_ULL(NPC_DMAC);
+		}
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
+		struct flow_match_ip match;
+
+		flow_rule_match_ip(rule, &match);
+		if ((ntohs(flow_spec->etype) != ETH_P_IP) &&
+		    match.mask->tos) {
+			netdev_err(nic->netdev, "tos not supported\n");
+			return -EOPNOTSUPP;
+		}
+		if (match.mask->ttl) {
+			netdev_err(nic->netdev, "ttl not supported\n");
+			return -EOPNOTSUPP;
+		}
+		flow_spec->tos = match.key->tos;
+		flow_mask->tos = match.mask->tos;
+		req->features |= BIT_ULL(NPC_TOS);
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+		u16 vlan_tci, vlan_tci_mask;
+
+		flow_rule_match_vlan(rule, &match);
+
+		if (ntohs(match.key->vlan_tpid) != ETH_P_8021Q) {
+			netdev_err(nic->netdev, "vlan tpid 0x%x not supported\n",
+				   ntohs(match.key->vlan_tpid));
+			return -EOPNOTSUPP;
+		}
+
+		if (match.mask->vlan_id ||
+		    match.mask->vlan_dei ||
+		    match.mask->vlan_priority) {
+			vlan_tci = match.key->vlan_id |
+				   match.key->vlan_dei << 12 |
+				   match.key->vlan_priority << 13;
+
+			vlan_tci_mask = match.mask->vlan_id |
+					match.key->vlan_dei << 12 |
+					match.key->vlan_priority << 13;
+
+			flow_spec->vlan_tci = htons(vlan_tci);
+			flow_mask->vlan_tci = htons(vlan_tci_mask);
+			req->features |= BIT_ULL(NPC_OUTER_VID);
+		}
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
+		struct flow_match_ipv4_addrs match;
+
+		flow_rule_match_ipv4_addrs(rule, &match);
+
+		flow_spec->ip4dst = match.key->dst;
+		flow_mask->ip4dst = match.mask->dst;
+		req->features |= BIT_ULL(NPC_DIP_IPV4);
+
+		flow_spec->ip4src = match.key->src;
+		flow_mask->ip4src = match.mask->src;
+		req->features |= BIT_ULL(NPC_SIP_IPV4);
+	} else if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
+		struct flow_match_ipv6_addrs match;
+
+		flow_rule_match_ipv6_addrs(rule, &match);
+
+		if (ipv6_addr_loopback(&match.key->dst) ||
+		    ipv6_addr_loopback(&match.key->src)) {
+			netdev_err(nic->netdev,
+				   "Flow matching on IPv6 loopback addr is not supported\n");
+			return -EOPNOTSUPP;
+		}
+
+		if (!ipv6_addr_any(&match.mask->dst)) {
+			memcpy(&flow_spec->ip6dst,
+			       (struct in6_addr *)&match.key->dst,
+			       sizeof(flow_spec->ip6dst));
+			memcpy(&flow_mask->ip6dst,
+			       (struct in6_addr *)&match.mask->dst,
+			       sizeof(flow_spec->ip6dst));
+			req->features |= BIT_ULL(NPC_DIP_IPV6);
+		}
+
+		if (!ipv6_addr_any(&match.mask->src)) {
+			memcpy(&flow_spec->ip6src,
+			       (struct in6_addr *)&match.key->src,
+			       sizeof(flow_spec->ip6src));
+			memcpy(&flow_mask->ip6src,
+			       (struct in6_addr *)&match.mask->src,
+			       sizeof(flow_spec->ip6src));
+			req->features |= BIT_ULL(NPC_SIP_IPV6);
+		}
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
+
+		flow_rule_match_ports(rule, &match);
+
+		flow_spec->dport = match.key->dst;
+		flow_mask->dport = match.mask->dst;
+		if (ip_proto == IPPROTO_UDP)
+			req->features |= BIT_ULL(NPC_DPORT_UDP);
+		else if (ip_proto == IPPROTO_TCP)
+			req->features |= BIT_ULL(NPC_DPORT_TCP);
+		else if (ip_proto == IPPROTO_SCTP)
+			req->features |= BIT_ULL(NPC_DPORT_SCTP);
+
+		flow_spec->sport = match.key->src;
+		flow_mask->sport = match.mask->src;
+		if (ip_proto == IPPROTO_UDP)
+			req->features |= BIT_ULL(NPC_SPORT_UDP);
+		else if (ip_proto == IPPROTO_TCP)
+			req->features |= BIT_ULL(NPC_SPORT_TCP);
+		else if (ip_proto == IPPROTO_SCTP)
+			req->features |= BIT_ULL(NPC_SPORT_SCTP);
+	}
+
+	return otx2_tc_parse_actions(nic, &rule->action, req);
+}
+
+static int otx2_del_mcam_flow_entry(struct otx2_nic *nic, u16 entry)
+{
+	struct npc_delete_flow_req *req;
+	int err;
+
+	mutex_lock(&nic->mbox.lock);
+	req = otx2_mbox_alloc_msg_npc_delete_flow(&nic->mbox);
+	if (!req) {
+		mutex_unlock(&nic->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->entry = entry;
+
+	/* Send message to AF */
+	err = otx2_sync_mbox_msg(&nic->mbox);
+	if (err) {
+		netdev_err(nic->netdev, "Failed to delete MCAM flow entry %d\n",
+			   entry);
+		mutex_unlock(&nic->mbox.lock);
+		return -EFAULT;
+	}
+	mutex_unlock(&nic->mbox.lock);
+
+	return 0;
+}
+
+static int otx2_tc_del_flow(struct otx2_nic *nic,
+			    struct flow_cls_offload *tc_flow_cmd)
+{
+	struct otx2_tc_info *tc_info = &nic->tc_info;
+	struct otx2_tc_flow *flow_node;
+
+	flow_node = rhashtable_lookup_fast(&tc_info->flow_table,
+					   &tc_flow_cmd->cookie,
+					   tc_info->flow_ht_params);
+	if (!flow_node) {
+		netdev_err(nic->netdev, "tc flow not found for cookie 0x%lx\n",
+			   tc_flow_cmd->cookie);
+		return -EINVAL;
+	}
+
+	otx2_del_mcam_flow_entry(nic, flow_node->entry);
+
+	WARN_ON(rhashtable_remove_fast(&nic->tc_info.flow_table,
+				       &flow_node->node,
+				       nic->tc_info.flow_ht_params));
+	kfree_rcu(flow_node, rcu);
+
+	clear_bit(flow_node->bitpos, tc_info->tc_entries_bitmap);
+	tc_info->num_entries--;
+
+	return 0;
+}
+
+static int otx2_tc_add_flow(struct otx2_nic *nic,
+			    struct flow_cls_offload *tc_flow_cmd)
+{
+	struct otx2_tc_info *tc_info = &nic->tc_info;
+	struct otx2_tc_flow *new_node, *old_node;
+	struct npc_install_flow_req *req;
+	int rc;
+
+	if (!(nic->flags & OTX2_FLAG_TC_FLOWER_SUPPORT))
+		return -ENOMEM;
+
+	/* allocate memory for the new flow and it's node */
+	new_node = kzalloc(sizeof(*new_node), GFP_KERNEL);
+	if (!new_node)
+		return -ENOMEM;
+	new_node->cookie = tc_flow_cmd->cookie;
+
+	mutex_lock(&nic->mbox.lock);
+	req = otx2_mbox_alloc_msg_npc_install_flow(&nic->mbox);
+	if (!req) {
+		mutex_unlock(&nic->mbox.lock);
+		return -ENOMEM;
+	}
+
+	rc = otx2_tc_prepare_flow(nic, tc_flow_cmd, req);
+	if (rc) {
+		otx2_mbox_reset(&nic->mbox.mbox, 0);
+		mutex_unlock(&nic->mbox.lock);
+		return rc;
+	}
+
+	/* If a flow exists with the same cookie, delete it */
+	old_node = rhashtable_lookup_fast(&tc_info->flow_table,
+					  &tc_flow_cmd->cookie,
+					  tc_info->flow_ht_params);
+	if (old_node)
+		otx2_tc_del_flow(nic, tc_flow_cmd);
+
+	if (bitmap_full(tc_info->tc_entries_bitmap, nic->flow_cfg->tc_max_flows)) {
+		netdev_err(nic->netdev, "Not enough MCAM space to add the flow\n");
+		otx2_mbox_reset(&nic->mbox.mbox, 0);
+		mutex_unlock(&nic->mbox.lock);
+		return -ENOMEM;
+	}
+
+	new_node->bitpos = find_first_zero_bit(tc_info->tc_entries_bitmap,
+					       nic->flow_cfg->tc_max_flows);
+	req->channel = nic->hw.rx_chan_base;
+	req->entry = nic->flow_cfg->entry[nic->flow_cfg->tc_flower_offset +
+					  nic->flow_cfg->tc_max_flows - new_node->bitpos];
+	req->intf = NIX_INTF_RX;
+	req->set_cntr = 1;
+	new_node->entry = req->entry;
+
+	/* Send message to AF */
+	rc = otx2_sync_mbox_msg(&nic->mbox);
+	if (rc) {
+		netdev_err(nic->netdev, "Failed to install MCAM flow entry\n");
+		mutex_unlock(&nic->mbox.lock);
+		goto out;
+	}
+	mutex_unlock(&nic->mbox.lock);
+
+	/* add new flow to flow-table */
+	rc = rhashtable_insert_fast(&nic->tc_info.flow_table, &new_node->node,
+				    nic->tc_info.flow_ht_params);
+	if (rc) {
+		otx2_del_mcam_flow_entry(nic, req->entry);
+		kfree_rcu(new_node, rcu);
+		goto out;
+	}
+
+	set_bit(new_node->bitpos, tc_info->tc_entries_bitmap);
+	tc_info->num_entries++;
+out:
+	return rc;
+}
+
+static int otx2_setup_tc_cls_flower(struct otx2_nic *nic,
+				    struct flow_cls_offload *cls_flower)
+{
+	switch (cls_flower->command) {
+	case FLOW_CLS_REPLACE:
+		return otx2_tc_add_flow(nic, cls_flower);
+	case FLOW_CLS_DESTROY:
+		return otx2_tc_del_flow(nic, cls_flower);
+	case FLOW_CLS_STATS:
+		return -EOPNOTSUPP;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int otx2_setup_tc_block_ingress_cb(enum tc_setup_type type,
+					  void *type_data, void *cb_priv)
+{
+	struct otx2_nic *nic = cb_priv;
+
+	if (!tc_cls_can_offload_and_chain0(nic->netdev, type_data))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		return otx2_setup_tc_cls_flower(nic, type_data);
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static LIST_HEAD(otx2_block_cb_list);
+
+static int otx2_setup_tc_block(struct net_device *netdev,
+			       struct flow_block_offload *f)
+{
+	struct otx2_nic *nic = netdev_priv(netdev);
+
+	if (f->block_shared)
+		return -EOPNOTSUPP;
+
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		return -EOPNOTSUPP;
+
+	return flow_block_cb_setup_simple(f, &otx2_block_cb_list,
+					  otx2_setup_tc_block_ingress_cb,
+					  nic, nic, true);
+}
+
+int otx2_setup_tc(struct net_device *netdev, enum tc_setup_type type,
+		  void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_BLOCK:
+		return otx2_setup_tc_block(netdev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static const struct rhashtable_params tc_flow_ht_params = {
+	.head_offset = offsetof(struct otx2_tc_flow, node),
+	.key_offset = offsetof(struct otx2_tc_flow, cookie),
+	.key_len = sizeof(((struct otx2_tc_flow *)0)->cookie),
+	.automatic_shrinking = true,
+};
+
+int otx2_init_tc(struct otx2_nic *nic)
+{
+	struct otx2_tc_info *tc = &nic->tc_info;
+
+	tc->flow_ht_params = tc_flow_ht_params;
+	return rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
+}
+
+void otx2_shutdown_tc(struct otx2_nic *nic)
+{
+	struct otx2_tc_info *tc = &nic->tc_info;
+
+	rhashtable_destroy(&tc->flow_table);
+}
-- 
2.16.5

