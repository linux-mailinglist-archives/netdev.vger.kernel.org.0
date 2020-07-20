Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4A8226BF2
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbgGTQqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:46:04 -0400
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:30487 "EHLO
        bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730328AbgGTQp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3119; q=dns/txt; s=iport;
  t=1595263557; x=1596473157;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Vdjo6hmqo0zLm1DR6bYASgDhovS0RKIR/PWgbRmhkv4=;
  b=iER91zsDStYg6kxHzwcD/cI4oCz7yFlYn5ocbodVe1PUwFXKUPd0DBSA
   Vn4egPYEMb3/lZGwCukCXzmUaO4g2Ng1odQfZxel8WM8tLHjLPmOR2yGi
   odSSvUqupb5zK2hA7IO6zbX2bwZm/G5SPMpqMqaPrFbceuwhE9cmzmNvS
   4=;
X-IronPort-AV: E=Sophos;i="5.75,375,1589241600"; 
   d="scan'208";a="126215549"
Received: from vla196-nat.cisco.com (HELO bgl-core-4.cisco.com) ([72.163.197.24])
  by bgl-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 20 Jul 2020 16:45:52 +0000
Received: from SRIRAKR2-M-R0A8.cisco.com ([10.65.70.250])
        by bgl-core-4.cisco.com (8.15.2/8.15.2) with ESMTP id 06KGjq3j001338;
        Mon, 20 Jul 2020 16:45:52 GMT
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
Subject: [PATCH v3] net: hyperv: add support for vlans in netvsc driver
Date:   Mon, 20 Jul 2020 22:15:51 +0530
Message-Id: <20200720164551.14153-1-srirakr2@cisco.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.65.70.250, [10.65.70.250]
X-Outbound-Node: bgl-core-4.cisco.com
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
 drivers/net/hyperv/netvsc_drv.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 6267f706e8ee..2a25b4352369 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -605,6 +605,29 @@ static int netvsc_xmit(struct sk_buff *skb, struct net_device *net, bool xdp_tx)
 		*hash_info = hash;
 	}
 
+	/* When using AF_PACKET we need to remove VLAN from frame
+	 * and indicate VLAN information in SKB so HOST OS will
+	 * transmit the VLAN frame
+	 */
+	if (skb->protocol == htons(ETH_P_8021Q)) {
+		u16 vlan_tci = 0;
+		skb_reset_mac_header(skb);
+		if (eth_type_vlan(eth_hdr(skb)->h_proto)) {
+			int pop_err;
+			pop_err = __skb_vlan_pop(skb, &vlan_tci);
+			if (likely(pop_err == 0)) {
+				__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tci);
+
+				/* Update the NDIS header pkt lengths */
+				packet->total_data_buflen -= VLAN_HLEN;
+				rndis_msg->msg_len = packet->total_data_buflen;
+				rndis_msg->msg.pkt.data_len = packet->total_data_buflen;
+
+			} else {
+				netdev_err(net,"Pop vlan err %x\n",pop_err);
+			}
+		}
+	}
 	if (skb_vlan_tag_present(skb)) {
 		struct ndis_pkt_8021q_info *vlan;
 
-- 
2.24.0

