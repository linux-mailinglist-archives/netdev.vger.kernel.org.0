Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7A4258B9D
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 11:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgIAJby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 05:31:54 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12492 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgIAJbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 05:31:53 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0819Q0BR006616;
        Tue, 1 Sep 2020 02:31:50 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcq7rpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 02:31:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Sep
 2020 02:31:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Sep 2020 02:31:49 -0700
Received: from machine421.caveonetworks.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 685773F7045;
        Tue,  1 Sep 2020 02:31:48 -0700 (PDT)
From:   <sunil.kovvuri@gmail.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH net-next] octeontx2-pf: Add UDP segmentation offload support
Date:   Tue, 1 Sep 2020 15:01:42 +0530
Message-ID: <1598952702-23946-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_04:2020-09-01,2020-09-01 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Defines UDP segmentation algorithm in hardware and supports
offloading UDP segmentation.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 89 ++++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  5 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  6 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 25 +++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  3 +-
 5 files changed, 124 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index f893423..820fc66 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -365,6 +365,95 @@ int otx2_rss_init(struct otx2_nic *pfvf)
 	return 0;
 }
 
+/* Setup UDP segmentation algorithm in HW */
+static void otx2_setup_udp_segmentation(struct nix_lso_format_cfg *lso, bool v4)
+{
+	struct nix_lso_format *field;
+
+	field = (struct nix_lso_format *)&lso->fields[0];
+	lso->field_mask = GENMASK(18, 0);
+
+	/* IP's Length field */
+	field->layer = NIX_TXLAYER_OL3;
+	/* In ipv4, length field is at offset 2 bytes, for ipv6 it's 4 */
+	field->offset = v4 ? 2 : 4;
+	field->sizem1 = 1; /* i.e 2 bytes */
+	field->alg = NIX_LSOALG_ADD_PAYLEN;
+	field++;
+
+	/* No ID field in IPv6 header */
+	if (v4) {
+		/* Increment IPID */
+		field->layer = NIX_TXLAYER_OL3;
+		field->offset = 4;
+		field->sizem1 = 1; /* i.e 2 bytes */
+		field->alg = NIX_LSOALG_ADD_SEGNUM;
+		field++;
+	}
+
+	/* Update length in UDP header */
+	field->layer = NIX_TXLAYER_OL4;
+	field->offset = 4;
+	field->sizem1 = 1;
+	field->alg = NIX_LSOALG_ADD_PAYLEN;
+}
+
+/* Setup segmentation algorithms in HW and retrieve algorithm index */
+void otx2_setup_segmentation(struct otx2_nic *pfvf)
+{
+	struct nix_lso_format_cfg_rsp *rsp;
+	struct nix_lso_format_cfg *lso;
+	struct otx2_hw *hw = &pfvf->hw;
+	int err;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	/* UDPv4 segmentation */
+	lso = otx2_mbox_alloc_msg_nix_lso_format_cfg(&pfvf->mbox);
+	if (!lso)
+		goto fail;
+
+	/* Setup UDP/IP header fields that HW should update per segment */
+	otx2_setup_udp_segmentation(lso, true);
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err)
+		goto fail;
+
+	rsp = (struct nix_lso_format_cfg_rsp *)
+			otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &lso->hdr);
+	if (IS_ERR(rsp))
+		goto fail;
+
+	hw->lso_udpv4_idx = rsp->lso_format_idx;
+
+	/* UDPv6 segmentation */
+	lso = otx2_mbox_alloc_msg_nix_lso_format_cfg(&pfvf->mbox);
+	if (!lso)
+		goto fail;
+
+	/* Setup UDP/IP header fields that HW should update per segment */
+	otx2_setup_udp_segmentation(lso, false);
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err)
+		goto fail;
+
+	rsp = (struct nix_lso_format_cfg_rsp *)
+			otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &lso->hdr);
+	if (IS_ERR(rsp))
+		goto fail;
+
+	hw->lso_udpv6_idx = rsp->lso_format_idx;
+	mutex_unlock(&pfvf->mbox.lock);
+	return;
+fail:
+	mutex_unlock(&pfvf->mbox.lock);
+	netdev_info(pfvf->netdev,
+		    "Failed to get LSO index for UDP GSO offload, disabling\n");
+	pfvf->netdev->hw_features &= ~NETIF_F_GSO_UDP_L4;
+}
+
 void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
 {
 	/* Configure CQE interrupt coalescing parameters
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 689925b..ac47762 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -177,9 +177,11 @@ struct otx2_hw {
 	u16			rq_skid;
 	u8			cq_time_wait;
 
-	/* For TSO segmentation */
+	/* Segmentation */
 	u8			lso_tsov4_idx;
 	u8			lso_tsov6_idx;
+	u8			lso_udpv4_idx;
+	u8			lso_udpv6_idx;
 	u8			hw_tso;
 
 	/* MSI-X */
@@ -580,6 +582,7 @@ void otx2_tx_timeout(struct net_device *netdev, unsigned int txq);
 void otx2_get_mac_from_af(struct net_device *netdev);
 void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx);
 int otx2_config_pause_frm(struct otx2_nic *pfvf);
+void otx2_setup_segmentation(struct otx2_nic *pfvf);
 
 /* RVU block related APIs */
 int otx2_attach_npa_nix(struct otx2_nic *pfvf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index f5f874a..aac2845 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1501,6 +1501,9 @@ int otx2_open(struct net_device *netdev)
 	if (err)
 		goto err_disable_napi;
 
+	/* Setup segmentation algorithms, if failed, clear offload capability */
+	otx2_setup_segmentation(pf);
+
 	/* Initialize RSS */
 	err = otx2_rss_init(pf);
 	if (err)
@@ -2091,7 +2094,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	netdev->hw_features = (NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
 			       NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
-			       NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6);
+			       NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
+			       NETIF_F_GSO_UDP_L4);
 	netdev->features |= netdev->hw_features;
 
 	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_RXALL;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 1f90426..faaa322 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -524,10 +524,33 @@ static void otx2_sqe_add_ext(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 			 */
 			ip_hdr(skb)->tot_len =
 				htons(ext->lso_sb - skb_network_offset(skb));
-		} else {
+		} else if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6) {
 			ext->lso_format = pfvf->hw.lso_tsov6_idx;
+
 			ipv6_hdr(skb)->payload_len =
 				htons(ext->lso_sb - skb_network_offset(skb));
+		} else if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
+			__be16 l3_proto = vlan_get_protocol(skb);
+			struct udphdr *udph = udp_hdr(skb);
+			u16 iplen;
+
+			ext->lso_sb = skb_transport_offset(skb) +
+					sizeof(struct udphdr);
+
+			/* HW adds payload size to length fields in IP and
+			 * UDP headers while segmentation, hence adjust the
+			 * lengths to just header sizes.
+			 */
+			iplen = htons(ext->lso_sb - skb_network_offset(skb));
+			if (l3_proto == htons(ETH_P_IP)) {
+				ip_hdr(skb)->tot_len = iplen;
+				ext->lso_format = pfvf->hw.lso_udpv4_idx;
+			} else {
+				ipv6_hdr(skb)->payload_len = iplen;
+				ext->lso_format = pfvf->hw.lso_udpv6_idx;
+			}
+
+			udph->len = htons(sizeof(struct udphdr));
 		}
 	} else if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
 		ext->tstmp = 1;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 92a3db6..70e0d4c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -553,7 +553,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
 			      NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
-			      NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6;
+			      NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
+			      NETIF_F_GSO_UDP_L4;
 	netdev->features = netdev->hw_features;
 
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
-- 
2.7.4

