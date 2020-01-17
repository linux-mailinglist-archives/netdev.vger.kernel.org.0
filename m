Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDB8A14113B
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbgAQS43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:56:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:5303 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728992AbgAQS4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 13:56:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2020 10:56:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,331,1574150400"; 
   d="scan'208";a="220819569"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jan 2020 10:56:19 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 4/9] igc: Add support for TSO
Date:   Fri, 17 Jan 2020 10:56:12 -0800
Message-Id: <20200117185617.1585693-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117185617.1585693-1-jeffrey.t.kirsher@intel.com>
References: <20200117185617.1585693-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

TCP segmentation offload allows a device to segment a single frame
into multiple frames with a data payload size specified in socket buffer.
As a result we can now send data approximately up to seven percents fast
than was previously possible on my system.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h |   4 +
 drivers/net/ethernet/intel/igc/igc_main.c    | 113 ++++++++++++++++++-
 2 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 2121fc34e300..9e34b0969322 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -282,6 +282,10 @@
 #define IGC_TXD_STAT_TC		0x00000004 /* Tx Underrun */
 #define IGC_TXD_EXTCMD_TSTAMP	0x00000010 /* IEEE1588 Timestamp packet */
 
+/* IPSec Encrypt Enable */
+#define IGC_ADVTXD_L4LEN_SHIFT	8  /* Adv ctxt L4LEN shift */
+#define IGC_ADVTXD_MSS_SHIFT	16 /* Adv ctxt MSS shift */
+
 /* Transmit Control */
 #define IGC_TCTL_EN		0x00000002 /* enable Tx */
 #define IGC_TCTL_PSP		0x00000008 /* pad short packets */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index a8f8d279f3b1..d9d5425fe8d9 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1000,6 +1000,10 @@ static u32 igc_tx_cmd_type(struct sk_buff *skb, u32 tx_flags)
 		       IGC_ADVTXD_DCMD_DEXT |
 		       IGC_ADVTXD_DCMD_IFCS;
 
+	/* set segmentation bits for TSO */
+	cmd_type |= IGC_SET_FLAG(tx_flags, IGC_TX_FLAGS_TSO,
+				 (IGC_ADVTXD_DCMD_TSE));
+
 	/* set timestamp bit if present */
 	cmd_type |= IGC_SET_FLAG(tx_flags, IGC_TX_FLAGS_TSTAMP,
 				 (IGC_ADVTXD_MAC_TSTAMP));
@@ -1171,6 +1175,100 @@ static int igc_tx_map(struct igc_ring *tx_ring,
 	return -1;
 }
 
+static int igc_tso(struct igc_ring *tx_ring,
+		   struct igc_tx_buffer *first,
+		   u8 *hdr_len)
+{
+	u32 vlan_macip_lens, type_tucmd, mss_l4len_idx;
+	struct sk_buff *skb = first->skb;
+	union {
+		struct iphdr *v4;
+		struct ipv6hdr *v6;
+		unsigned char *hdr;
+	} ip;
+	union {
+		struct tcphdr *tcp;
+		struct udphdr *udp;
+		unsigned char *hdr;
+	} l4;
+	u32 paylen, l4_offset;
+	int err;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		return 0;
+
+	if (!skb_is_gso(skb))
+		return 0;
+
+	err = skb_cow_head(skb, 0);
+	if (err < 0)
+		return err;
+
+	ip.hdr = skb_network_header(skb);
+	l4.hdr = skb_checksum_start(skb);
+
+	/* ADV DTYP TUCMD MKRLOC/ISCSIHEDLEN */
+	type_tucmd = IGC_ADVTXD_TUCMD_L4T_TCP;
+
+	/* initialize outer IP header fields */
+	if (ip.v4->version == 4) {
+		unsigned char *csum_start = skb_checksum_start(skb);
+		unsigned char *trans_start = ip.hdr + (ip.v4->ihl * 4);
+
+		/* IP header will have to cancel out any data that
+		 * is not a part of the outer IP header
+		 */
+		ip.v4->check = csum_fold(csum_partial(trans_start,
+						      csum_start - trans_start,
+						      0));
+		type_tucmd |= IGC_ADVTXD_TUCMD_IPV4;
+
+		ip.v4->tot_len = 0;
+		first->tx_flags |= IGC_TX_FLAGS_TSO |
+				   IGC_TX_FLAGS_CSUM |
+				   IGC_TX_FLAGS_IPV4;
+	} else {
+		ip.v6->payload_len = 0;
+		first->tx_flags |= IGC_TX_FLAGS_TSO |
+				   IGC_TX_FLAGS_CSUM;
+	}
+
+	/* determine offset of inner transport header */
+	l4_offset = l4.hdr - skb->data;
+
+	/* remove payload length from inner checksum */
+	paylen = skb->len - l4_offset;
+	if (type_tucmd & IGC_ADVTXD_TUCMD_L4T_TCP) {
+		/* compute length of segmentation header */
+		*hdr_len = (l4.tcp->doff * 4) + l4_offset;
+		csum_replace_by_diff(&l4.tcp->check,
+				     (__force __wsum)htonl(paylen));
+	} else {
+		/* compute length of segmentation header */
+		*hdr_len = sizeof(*l4.udp) + l4_offset;
+		csum_replace_by_diff(&l4.udp->check,
+				     (__force __wsum)htonl(paylen));
+	}
+
+	/* update gso size and bytecount with header size */
+	first->gso_segs = skb_shinfo(skb)->gso_segs;
+	first->bytecount += (first->gso_segs - 1) * *hdr_len;
+
+	/* MSS L4LEN IDX */
+	mss_l4len_idx = (*hdr_len - l4_offset) << IGC_ADVTXD_L4LEN_SHIFT;
+	mss_l4len_idx |= skb_shinfo(skb)->gso_size << IGC_ADVTXD_MSS_SHIFT;
+
+	/* VLAN MACLEN IPLEN */
+	vlan_macip_lens = l4.hdr - ip.hdr;
+	vlan_macip_lens |= (ip.hdr - skb->data) << IGC_ADVTXD_MACLEN_SHIFT;
+	vlan_macip_lens |= first->tx_flags & IGC_TX_FLAGS_VLAN_MASK;
+
+	igc_tx_ctxtdesc(tx_ring, first, vlan_macip_lens,
+			type_tucmd, mss_l4len_idx);
+
+	return 1;
+}
+
 static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 				       struct igc_ring *tx_ring)
 {
@@ -1180,6 +1278,7 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 	u32 tx_flags = 0;
 	unsigned short f;
 	u8 hdr_len = 0;
+	int tso = 0;
 
 	/* need: 1 descriptor per page * PAGE_SIZE/IGC_MAX_DATA_PER_TXD,
 	 *	+ 1 desc for skb_headlen/IGC_MAX_DATA_PER_TXD,
@@ -1226,10 +1325,20 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 	first->tx_flags = tx_flags;
 	first->protocol = protocol;
 
-	igc_tx_csum(tx_ring, first);
+	tso = igc_tso(tx_ring, first, &hdr_len);
+	if (tso < 0)
+		goto out_drop;
+	else if (!tso)
+		igc_tx_csum(tx_ring, first);
 
 	igc_tx_map(tx_ring, first, hdr_len);
 
+	return NETDEV_TX_OK;
+
+out_drop:
+	dev_kfree_skb_any(first->skb);
+	first->skb = NULL;
+
 	return NETDEV_TX_OK;
 }
 
@@ -4589,6 +4698,8 @@ static int igc_probe(struct pci_dev *pdev,
 
 	/* Add supported features to the features list*/
 	netdev->features |= NETIF_F_SG;
+	netdev->features |= NETIF_F_TSO;
+	netdev->features |= NETIF_F_TSO6;
 	netdev->features |= NETIF_F_RXCSUM;
 	netdev->features |= NETIF_F_HW_CSUM;
 	netdev->features |= NETIF_F_SCTP_CRC;
-- 
2.24.1

