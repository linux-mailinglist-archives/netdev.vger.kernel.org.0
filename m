Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43555DF4A8
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbfJUSBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:01:47 -0400
Received: from mga17.intel.com ([192.55.52.151]:30875 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729321AbfJUSBr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 14:01:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 11:01:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,324,1566889200"; 
   d="scan'208";a="196186056"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 11:01:46 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 4/5] igc: Add Rx checksum support
Date:   Mon, 21 Oct 2019 11:01:42 -0700
Message-Id: <20191021180143.11775-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021180143.11775-1-jeffrey.t.kirsher@intel.com>
References: <20191021180143.11775-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Extend the socket buffer field process and add Rx checksum functionality
Minor: fix indentation with tab instead of spaces.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h |  5 ++-
 drivers/net/ethernet/intel/igc/igc_main.c    | 43 ++++++++++++++++++++
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 03f1aca3f57f..f3788f0b95b4 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -282,7 +282,10 @@
 #define IGC_RCTL_BAM		0x00008000 /* broadcast enable */
 
 /* Receive Descriptor bit definitions */
-#define IGC_RXD_STAT_EOP	0x02    /* End of Packet */
+#define IGC_RXD_STAT_EOP	0x02	/* End of Packet */
+#define IGC_RXD_STAT_IXSM	0x04	/* Ignore checksum */
+#define IGC_RXD_STAT_UDPCS	0x10	/* UDP xsum calculated */
+#define IGC_RXD_STAT_TCPCS	0x20	/* TCP xsum calculated */
 
 #define IGC_RXDEXT_STATERR_CE		0x01000000
 #define IGC_RXDEXT_STATERR_SE		0x02000000
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 7d2f479b57cf..a16c657a1506 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1201,6 +1201,46 @@ static netdev_tx_t igc_xmit_frame(struct sk_buff *skb,
 	return igc_xmit_frame_ring(skb, igc_tx_queue_mapping(adapter, skb));
 }
 
+static void igc_rx_checksum(struct igc_ring *ring,
+			    union igc_adv_rx_desc *rx_desc,
+			    struct sk_buff *skb)
+{
+	skb_checksum_none_assert(skb);
+
+	/* Ignore Checksum bit is set */
+	if (igc_test_staterr(rx_desc, IGC_RXD_STAT_IXSM))
+		return;
+
+	/* Rx checksum disabled via ethtool */
+	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+		return;
+
+	/* TCP/UDP checksum error bit is set */
+	if (igc_test_staterr(rx_desc,
+			     IGC_RXDEXT_STATERR_TCPE |
+			     IGC_RXDEXT_STATERR_IPE)) {
+		/* work around errata with sctp packets where the TCPE aka
+		 * L4E bit is set incorrectly on 64 byte (60 byte w/o crc)
+		 * packets (aka let the stack check the crc32c)
+		 */
+		if (!(skb->len == 60 &&
+		      test_bit(IGC_RING_FLAG_RX_SCTP_CSUM, &ring->flags))) {
+			u64_stats_update_begin(&ring->rx_syncp);
+			ring->rx_stats.csum_err++;
+			u64_stats_update_end(&ring->rx_syncp);
+		}
+		/* let the stack verify checksum errors */
+		return;
+	}
+	/* It must be a TCP or UDP packet with a valid checksum */
+	if (igc_test_staterr(rx_desc, IGC_RXD_STAT_TCPCS |
+				      IGC_RXD_STAT_UDPCS))
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+	dev_dbg(ring->dev, "cksum success: bits %08X\n",
+		le32_to_cpu(rx_desc->wb.upper.status_error));
+}
+
 static inline void igc_rx_hash(struct igc_ring *ring,
 			       union igc_adv_rx_desc *rx_desc,
 			       struct sk_buff *skb)
@@ -1227,6 +1267,8 @@ static void igc_process_skb_fields(struct igc_ring *rx_ring,
 {
 	igc_rx_hash(rx_ring, rx_desc, skb);
 
+	igc_rx_checksum(rx_ring, rx_desc, skb);
+
 	skb_record_rx_queue(skb, rx_ring->queue_index);
 
 	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
@@ -4391,6 +4433,7 @@ static int igc_probe(struct pci_dev *pdev,
 		goto err_sw_init;
 
 	/* Add supported features to the features list*/
+	netdev->features |= NETIF_F_RXCSUM;
 	netdev->features |= NETIF_F_HW_CSUM;
 	netdev->features |= NETIF_F_SCTP_CRC;
 
-- 
2.21.0

