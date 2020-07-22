Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC472291B4
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 09:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731685AbgGVHIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 03:08:14 -0400
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:5624 "EHLO
        bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgGVHIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 03:08:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4015; q=dns/txt; s=iport;
  t=1595401692; x=1596611292;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Smiy237MIFJj+6OWALRzgIJFYKqit4eKK+OJhzqDNq0=;
  b=gKMmofTDCZJfyu0HD2R8cbT+/3MaBFXmG2mwsVKVthnjpuXDeG/IoVBv
   0wDuKO2qcoL6UVe3ouLF/0PqrkOIGTcQ9qwfJw5Mgyoln8DhvRFx2xmqK
   TJpjKuaTTYoxC6uC7xB6i249SRJ0zc+5tFzMX2ygW174aLD4AaaVYr1xg
   w=;
X-IronPort-AV: E=Sophos;i="5.75,381,1589241600"; 
   d="scan'208";a="156253655"
Received: from vla196-nat.cisco.com (HELO bgl-core-2.cisco.com) ([72.163.197.24])
  by bgl-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 22 Jul 2020 07:08:10 +0000
Received: from SRIRAKR2-M-R0A8.cisco.com ([10.65.42.168])
        by bgl-core-2.cisco.com (8.15.2/8.15.2) with ESMTP id 06M789Ie006529;
        Wed, 22 Jul 2020 07:08:09 GMT
From:   Sriram Krishnan <srirakr2@cisco.com>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Cc:     mbumgard@cisco.com, ugm@cisco.com, nimm@cisco.com,
        xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5] hv_netvsc: add support for vlans in AF_PACKET mode
Date:   Wed, 22 Jul 2020 12:38:07 +0530
Message-Id: <20200722070809.70876-1-srirakr2@cisco.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.65.42.168, [10.65.42.168]
X-Outbound-Node: bgl-core-2.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vlan tagged packets are getting dropped when used with DPDK that uses
the AF_PACKET interface on a hyperV guest.

The packet layer uses the tpacket interface to communicate the vlans
information to the upper layers. On Rx path, these drivers can read the
vlan info from the tpacket header but on the Tx path, this information
is still within the packet frame and requires the paravirtual drivers to
push this back into the NDIS header which is then used by the host OS to
form the packet.

This transition from the packet frame to NDIS header is currently missing
hence causing the host OS to drop the all vlan tagged packets sent by
the drivers that use AF_PACKET (ETH_P_ALL) such as DPDK.

Here is an overview of the changes in the vlan header in the packet path:

The RX path (userspace handles everything):
  1. RX VLAN packet is stripped by HOST OS and placed in NDIS header
  2. Guest Kernel RX hv_netvsc packets and moves VLAN info from NDIS
     header into kernel SKB
  3. Kernel shares packets with user space application with PACKET_MMAP.
     The SKB VLAN info is copied to tpacket layer and indication set
     TP_STATUS_VLAN_VALID.
  4. The user space application will re-insert the VLAN info into the frame.

The TX path:
  1. The user space application has the VLAN info in the frame.
  2. Guest kernel gets packets from the application with PACKET_MMAP.
  3. The kernel later sends the frame to the hv_netvsc driver. The only way
     to send VLANs is when the SKB is setup & the VLAN is is stripped from the
     frame.
  4. TX VLAN is re-inserted by HOST OS based on the NDIS header. If it sees
     a VLAN in the frame the packet is dropped.

Cc: xe-linux-external@cisco.com
Cc: Sriram Krishnan <srirakr2@cisco.com>
Signed-off-by: Sriram Krishnan <srirakr2@cisco.com>
---
 drivers/net/hyperv/hyperv_net.h |  1 +
 drivers/net/hyperv/netvsc_drv.c | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index abda736e7c7d..2181d4538ab7 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -897,6 +897,7 @@ struct netvsc_ethtool_stats {
 	unsigned long rx_no_memory;
 	unsigned long stop_queue;
 	unsigned long wake_queue;
+	unsigned long vlan_error;
 };
 
 struct netvsc_ethtool_pcpu_stats {
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 6267f706e8ee..3e9bd93f54ed 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -605,6 +605,28 @@ static int netvsc_xmit(struct sk_buff *skb, struct net_device *net, bool xdp_tx)
 		*hash_info = hash;
 	}
 
+	/* When using AF_PACKET we need to drop VLAN header from
+	 * the frame and update the SKB to allow the HOST OS
+	 * to transmit the 802.1Q packet
+	 */
+	if (skb->protocol == htons(ETH_P_8021Q)) {
+		u16 vlan_tci = 0;
+		skb_reset_mac_header(skb);
+		if (eth_type_vlan(eth_hdr(skb)->h_proto)) {
+			if (unlikely(__skb_vlan_pop(skb, &vlan_tci) != 0)) {
+				++net_device_ctx->eth_stats.vlan_error;
+				goto drop;
+ 			}
+
+			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tci);
+			/* Update the NDIS header pkt lengths */
+			packet->total_data_buflen -= VLAN_HLEN;
+			packet->total_bytes -= VLAN_HLEN;
+			rndis_msg->msg_len = packet->total_data_buflen;
+			rndis_msg->msg.pkt.data_len = packet->total_data_buflen;
+		}
+	}
+
 	if (skb_vlan_tag_present(skb)) {
 		struct ndis_pkt_8021q_info *vlan;
 
@@ -1427,6 +1449,7 @@ static const struct {
 	{ "rx_no_memory", offsetof(struct netvsc_ethtool_stats, rx_no_memory) },
 	{ "stop_queue", offsetof(struct netvsc_ethtool_stats, stop_queue) },
 	{ "wake_queue", offsetof(struct netvsc_ethtool_stats, wake_queue) },
+	{ "vlan_error", offsetof(struct netvsc_ethtool_stats, vlan_error) },
 }, pcpu_stats[] = {
 	{ "cpu%u_rx_packets",
 		offsetof(struct netvsc_ethtool_pcpu_stats, rx_packets) },
-- 
2.24.0

