Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D47343256
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 13:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhCUMLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 08:11:11 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20486 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229865AbhCUMKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 08:10:33 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12LC5Gka023748;
        Sun, 21 Mar 2021 05:10:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=zwVx+wR5OhC7ZoK056QNe3ePXhS5uTQuAYji+YUtm9Q=;
 b=cFWQfggZiEAwCLJOOYzoiwSpMzzZfRgEW72loqg+lk+x/mNPrU7b0ADdN8JrwV8g5nJq
 uu+PlWj/niR3+OWXVYTREcs+wrlHLStbote1QBtcQf2ZWl1yiySu4S3XMzlBcaFAX9ou
 5niceKUcbp48mDFgtB2QnPGiFCQcC1Z3Kw1K0bPVulZZcHvarfqAKsK7cLpHSumzGLqU
 KoILlt2bJ8GcwfUNH7p7821IKFfJ7CZiRN7Rd0OLZrt5O5jVBgwYhJ6EGpVqJO19FEbV
 ev/VN1mUW3QntpIW0pijnd/YxfDeBwv/wWxj4Q2rfjcpNpyxdpieViwHTuLQgaiuPJW+ 7g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 37dedrab35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 21 Mar 2021 05:10:31 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 21 Mar
 2021 05:10:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 21 Mar 2021 05:10:30 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 4DD953F704B;
        Sun, 21 Mar 2021 05:10:27 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH 8/8] octeontx2-pf: Add ntuple filter support for FDSA
Date:   Sun, 21 Mar 2021 17:39:58 +0530
Message-ID: <20210321120958.17531-9-hkelam@marvell.com>
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

Marvell switches support FDSA (Forward DSA). FDSA has
4 bytes length and it contains Src port and vlan field.
KPU profile is updated to parse  FDSA packet and extract Src port.
The extracted Src port is placed in vlan field of KEX key.

This patch adds ntuple filter support to FDSA tag.
So that user can send traffic to either PF or VF based on
Src port or Vlan id. All rules installed for FDSA has default
action as RSS. Upon enabling FDSA , vf vlan rules will be disabled.

To enable fdsa tag
    ethtool --set-priv-flags eth0 fdsa on

To send traffic with Srcport 30 to PF
    ethtool -U eth0 flow-type ether  user-def 0x1e

To send traffic with vlan id 30 to PF
    ethtool -U eth0 flow-type ether  dst xx vlan 30 m 0xf000

To send traffic with Srcport 20 to vf 0
    ethtool -U eth0 flow-type ether vf 0 user-def 0x14

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/nic/otx2_common.h       | 16 ++++-
 .../marvell/octeontx2/nic/otx2_ethtool.c      | 49 +++++++++++++++-
 .../marvell/octeontx2/nic/otx2_flows.c        | 58 ++++++++++++++++---
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 13 ++++-
 4 files changed, 121 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 73e927a7843..3aa61125f84 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -223,6 +223,12 @@ struct otx2_hw {
 	u64			*nix_lmt_base;
 };
 
+struct vfvlan {
+	u16 vlan;
+	__be16 proto;
+	u8 qos;
+};
+
 struct otx2_vf_config {
 	struct otx2_nic *pf;
 	struct delayed_work link_event_work;
@@ -230,6 +236,7 @@ struct otx2_vf_config {
 	u8 mac[ETH_ALEN];
 	u16 vlan;
 	int tx_vtag_idx;
+	struct vfvlan rule;
 };
 
 struct flr_work {
@@ -350,7 +357,9 @@ struct otx2_nic {
 #define OTX2_PRIV_FLAG_PAM4			BIT(0)
 #define OTX2_PRIV_FLAG_EDSA_HDR			BIT(1)
 #define OTX2_PRIV_FLAG_HIGIG2_HDR		BIT(2)
-#define OTX2_PRIV_FLAG_DEF_MODE			BIT(3)
+#define OTX2_PRIV_FLAG_FDSA_HDR			BIT(3)
+#define OTX2_INTF_MOD_MASK			GENMASK(3, 1)
+#define OTX2_PRIV_FLAG_DEF_MODE			BIT(4)
 #define OTX2_IS_EDSA_ENABLED(flags)		((flags) &              \
 						 OTX2_PRIV_FLAG_EDSA_HDR)
 #define OTX2_IS_HIGIG2_ENABLED(flags)		((flags) &              \
@@ -364,6 +373,7 @@ struct otx2_nic {
 	 */
 #define OTX2_EDSA_HDR_LEN			16
 #define OTX2_HIGIG2_HDR_LEN			16
+#define OTX2_FDSA_HDR_LEN			4
 	u32			addl_mtu;
 	struct otx2_mac_table	*mac_table;
 
@@ -831,14 +841,14 @@ int otx2_get_all_flows(struct otx2_nic *pfvf,
 int otx2_add_flow(struct otx2_nic *pfvf,
 		  struct ethtool_rxnfc *nfc);
 int otx2_remove_flow(struct otx2_nic *pfvf, u32 location);
-int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
-			      struct npc_install_flow_req *req);
 void otx2_rss_ctx_flow_del(struct otx2_nic *pfvf, int ctx_id);
 int otx2_del_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_add_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_enable_rxvlan(struct otx2_nic *pf, bool enable);
 int otx2_install_rxvlan_offload_flow(struct otx2_nic *pfvf);
 u16 otx2_get_max_mtu(struct otx2_nic *pfvf);
+int otx2_do_set_vf_vlan(struct otx2_nic *pf, int vf, u16 vlan, u8 qos,
+			__be16 proto);
 /* tc support */
 int otx2_init_tc(struct otx2_nic *nic);
 void otx2_shutdown_tc(struct otx2_nic *nic);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index c1405611489..523bb089b9e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -26,6 +26,7 @@ static const char otx2_priv_flags_strings[][ETH_GSTRING_LEN] = {
 	"pam4",
 	"edsa",
 	"higig2",
+	"fdsa",
 };
 
 struct otx2_stat {
@@ -1286,6 +1287,9 @@ int otx2_set_npc_parse_mode(struct otx2_nic *pfvf, bool unbind)
 	} else if (OTX2_IS_EDSA_ENABLED(pfvf->ethtool_flags)) {
 		req->mode = OTX2_PRIV_FLAGS_EDSA;
 		interface_mode = OTX2_PRIV_FLAG_EDSA_HDR;
+	} else if (pfvf->ethtool_flags & OTX2_PRIV_FLAG_FDSA_HDR) {
+		req->mode = OTX2_PRIV_FLAGS_FDSA;
+		interface_mode = OTX2_PRIV_FLAG_FDSA_HDR;
 	} else {
 		req->mode = OTX2_PRIV_FLAGS_DEFAULT;
 		interface_mode = OTX2_PRIV_FLAG_DEF_MODE;
@@ -1364,6 +1368,28 @@ static int otx2_enable_addl_header(struct net_device *netdev, int bitpos,
 	return 0;
 }
 
+/* This function disables vfvlan rules upon enabling
+ * fdsa and vice versa
+ */
+static void otx2_endis_vfvlan_rules(struct otx2_nic *pfvf, bool enable)
+{
+	struct vfvlan *rule;
+	int vf;
+
+	for (vf = 0; vf < pci_num_vf(pfvf->pdev); vf++) {
+		/* pass vlan as 0 to disable rule */
+		if (enable) {
+			otx2_do_set_vf_vlan(pfvf, vf, 0, 0, 0);
+		} else {
+			rule = &pfvf->vf_configs[vf].rule;
+			otx2_do_set_vf_vlan(pfvf, vf, rule->vlan, rule->qos,
+					    rule->proto);
+		}
+	}
+}
+
+#define OTX2_IS_INTFMOD_SET(flags) hweight32((flags) & OTX2_INTF_MOD_MASK)
+
 static int otx2_set_priv_flags(struct net_device *netdev, u32 new_flags)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
@@ -1392,15 +1418,34 @@ static int otx2_set_priv_flags(struct net_device *netdev, u32 new_flags)
 		break;
 	case OTX2_PRIV_FLAG_EDSA_HDR:
 		/* HIGIG & EDSA  are mutual exclusive */
-		if (enable && OTX2_IS_HIGIG2_ENABLED(pfvf->ethtool_flags))
+		if (enable && OTX2_IS_INTFMOD_SET(pfvf->ethtool_flags)) {
+			netdev_info(netdev,
+				    "Disable mutually exclusive modes higig2/fdsa\n");
 			return -EINVAL;
+		}
 		return otx2_enable_addl_header(netdev, bitnr,
 					       OTX2_EDSA_HDR_LEN, enable);
 	case OTX2_PRIV_FLAG_HIGIG2_HDR:
-		if (enable && OTX2_IS_EDSA_ENABLED(pfvf->ethtool_flags))
+		if (enable && OTX2_IS_INTFMOD_SET(pfvf->ethtool_flags)) {
+			netdev_info(netdev,
+				    "Disable mutually exclusive modes edsa/fdsa\n");
 			return -EINVAL;
+		}
 		return otx2_enable_addl_header(netdev, bitnr,
 					       OTX2_HIGIG2_HDR_LEN, enable);
+	case OTX2_PRIV_FLAG_FDSA_HDR:
+		if (enable && OTX2_IS_INTFMOD_SET(pfvf->ethtool_flags)) {
+			netdev_info(netdev,
+				    "Disable mutually exclusive modes edsa/higig2\n");
+			return -EINVAL;
+		}
+		otx2_enable_addl_header(netdev, bitnr,
+					OTX2_FDSA_HDR_LEN, enable);
+		if (enable)
+			netdev_warn(netdev,
+				    "Disabling VF VLAN rules as FDSA & VFVLAN are mutual exclusive\n");
+		otx2_endis_vfvlan_rules(pfvf, enable);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index fa7a46aa15e..4e22798ea6c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -9,6 +9,8 @@
 #include "otx2_common.h"
 
 #define OTX2_DEFAULT_ACTION	0x1
+#define FDSA_MAX_SPORT		32
+#define FDSA_SPORT_MASK         0xf8
 
 struct otx2_flow {
 	struct ethtool_rx_flow_spec flow_spec;
@@ -556,8 +558,18 @@ static int otx2_prepare_ipv6_flow(struct ethtool_rx_flow_spec *fsp,
 	return 0;
 }
 
-int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
-			      struct npc_install_flow_req *req)
+static void otx2_prepare_fdsa_flow_request(struct npc_install_flow_req *req)
+{
+	/* Strip FDSA tag */
+	req->features |= BIT_ULL(NPC_FDSA_VAL);
+	req->vtag0_valid = true;
+	req->vtag0_type = NIX_AF_LFX_RX_VTAG_TYPE6;
+	req->op = NIX_RX_ACTION_DEFAULT;
+}
+
+static int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
+				     struct npc_install_flow_req *req,
+				     struct otx2_nic *pfvf)
 {
 	struct ethhdr *eth_mask = &fsp->m_u.ether_spec;
 	struct ethhdr *eth_hdr = &fsp->h_u.ether_spec;
@@ -612,6 +624,9 @@ int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 		return -EOPNOTSUPP;
 	}
 	if (fsp->flow_type & FLOW_EXT) {
+		int skip_user_def = false;
+		u16 fdsa_sport = 0;
+
 		if (fsp->m_ext.vlan_etype)
 			return -EINVAL;
 		if (fsp->m_ext.vlan_tci) {
@@ -624,13 +639,36 @@ int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 			       sizeof(pkt->vlan_tci));
 			memcpy(&pmask->vlan_tci, &fsp->m_ext.vlan_tci,
 			       sizeof(pmask->vlan_tci));
-			req->features |= BIT_ULL(NPC_OUTER_VID);
+			if (pfvf->ethtool_flags & OTX2_PRIV_FLAG_FDSA_HDR) {
+				otx2_prepare_fdsa_flow_request(req);
+				skip_user_def = true;
+			} else {
+				req->features |= BIT_ULL(NPC_OUTER_VID);
+			}
+		}
+
+		if (fsp->m_ext.data[1] && !skip_user_def) {
+			if (pfvf->ethtool_flags & OTX2_PRIV_FLAG_FDSA_HDR) {
+				if (be32_to_cpu(fsp->h_ext.data[1]) >=
+						FDSA_MAX_SPORT)
+					return -EINVAL;
+				/* FDSA source port is 5 bit value ..starts
+				 * from b3..b7. Derive source port value
+				 * from h_ext.data.
+				 */
+				fdsa_sport = be32_to_cpu(fsp->h_ext.data[1]);
+				pkt->vlan_tci = cpu_to_be16(fdsa_sport << 3);
+				pmask->vlan_tci = cpu_to_be16(FDSA_SPORT_MASK);
+				otx2_prepare_fdsa_flow_request(req);
+			} else if (fsp->h_ext.data[1] ==
+					cpu_to_be32(OTX2_DEFAULT_ACTION)) {
+				/* Not Drop/Direct to queue but use action
+				 * in default entry
+				 */
+				req->op = NIX_RX_ACTION_DEFAULT;
+			}
 		}
 
-		/* Not Drop/Direct to queue but use action in default entry */
-		if (fsp->m_ext.data[1] &&
-		    fsp->h_ext.data[1] == cpu_to_be32(OTX2_DEFAULT_ACTION))
-			req->op = NIX_RX_ACTION_DEFAULT;
 	}
 
 	if (fsp->flow_type & FLOW_MAC_EXT &&
@@ -659,7 +697,7 @@ static int otx2_add_flow_msg(struct otx2_nic *pfvf, struct otx2_flow *flow)
 		return -ENOMEM;
 	}
 
-	err = otx2_prepare_flow_request(&flow->flow_spec, req);
+	err = otx2_prepare_flow_request(&flow->flow_spec, req, pfvf);
 	if (err) {
 		/* free the allocated msg above */
 		otx2_mbox_reset(&pfvf->mbox.mbox, 0);
@@ -949,6 +987,10 @@ int otx2_enable_rxvlan(struct otx2_nic *pf, bool enable)
 	if (!(pf->flags & OTX2_FLAG_RX_VLAN_SUPPORT))
 		return -ENOMEM;
 
+	/* FDSA & RXVLAN are mutually exclusive */
+	if (pf->ethtool_flags & OTX2_PRIV_FLAG_FDSA_HDR)
+		enable = false;
+
 	if (enable) {
 		err = otx2_install_rxvlan_offload_flow(pf);
 		if (err)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 977da158f1d..a967710a801 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2058,8 +2058,8 @@ static int otx2_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
 	return ret;
 }
 
-static int otx2_do_set_vf_vlan(struct otx2_nic *pf, int vf, u16 vlan, u8 qos,
-			       __be16 proto)
+int otx2_do_set_vf_vlan(struct otx2_nic *pf, int vf, u16 vlan, u8 qos,
+			__be16 proto)
 {
 	struct otx2_flow_config *flow_cfg = pf->flow_cfg;
 	struct nix_vtag_config_rsp *vtag_rsp;
@@ -2118,6 +2118,8 @@ static int otx2_do_set_vf_vlan(struct otx2_nic *pf, int vf, u16 vlan, u8 qos,
 			flow_cfg->entry[flow_cfg->vf_vlan_offset + idx];
 		err = otx2_sync_mbox_msg(&pf->mbox);
 
+		if (!(pf->ethtool_flags & OTX2_PRIV_FLAG_FDSA_HDR))
+			memset(&config->rule, 0, sizeof(config->rule));
 		goto out;
 	}
 
@@ -2191,6 +2193,10 @@ static int otx2_do_set_vf_vlan(struct otx2_nic *pf, int vf, u16 vlan, u8 qos,
 	req->set_cntr = 1;
 
 	err = otx2_sync_mbox_msg(&pf->mbox);
+	/* Update these values to reinstall the vfvlan rule */
+	config->rule.vlan = vlan;
+	config->rule.proto = proto;
+	config->rule.qos = qos;
 out:
 	config->vlan = vlan;
 	mutex_unlock(&pf->mbox.lock);
@@ -2219,6 +2225,9 @@ static int otx2_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan, u8 qos,
 	if (!(pf->flags & OTX2_FLAG_VF_VLAN_SUPPORT))
 		return -EOPNOTSUPP;
 
+	if (pf->ethtool_flags & OTX2_PRIV_FLAG_FDSA_HDR)
+		return -EOPNOTSUPP;
+
 	return otx2_do_set_vf_vlan(pf, vf, vlan, qos, proto);
 }
 
-- 
2.17.1

