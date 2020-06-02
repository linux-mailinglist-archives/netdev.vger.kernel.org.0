Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8D71EB52C
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 07:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgFBFY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 01:24:27 -0400
Received: from inva020.nxp.com ([92.121.34.13]:44738 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbgFBFYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 01:24:20 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DEE9D1A0B71;
        Tue,  2 Jun 2020 07:24:18 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1B0311A0B79;
        Tue,  2 Jun 2020 07:24:09 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 776FE402E4;
        Tue,  2 Jun 2020 13:23:57 +0800 (SGT)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, linux-devel@linux.nxdi.nxp.com
Subject: [PATCH v2 net-next 10/10] net: dsa: tag_ocelot: use VLAN information from tagging header when available
Date:   Tue,  2 Jun 2020 13:18:28 +0800
Message-Id: <20200602051828.5734-11-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When the Extraction Frame Header contains a valid classified VLAN, use
that instead of the VLAN header present in the packet.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_ocelot.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index b0c98ee4e13b..253188b0e56b 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -181,9 +181,16 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 				  struct net_device *netdev,
 				  struct packet_type *pt)
 {
+	struct dsa_port *cpu_dp = netdev->dsa_ptr;
+	struct dsa_switch *ds = cpu_dp->ds;
+	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port;
 	u64 src_port, qos_class;
 	u8 *start = skb->data;
+	struct ethhdr *hdr;
 	u8 *extraction;
+	u64 vlan_tci;
+	u16 vid;
 
 	/* Revert skb->data by the amount consumed by the DSA master,
 	 * so it points to the beginning of the frame.
@@ -211,6 +218,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 
 	packing(extraction, &src_port,  46, 43, OCELOT_TAG_LEN, UNPACK, 0);
 	packing(extraction, &qos_class, 19, 17, OCELOT_TAG_LEN, UNPACK, 0);
+	packing(extraction, &vlan_tci,  15,  0, OCELOT_TAG_LEN, UNPACK, 0);
 
 	skb->dev = dsa_master_find_slave(netdev, 0, src_port);
 	if (!skb->dev)
@@ -225,6 +233,27 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	skb->offload_fwd_mark = 1;
 	skb->priority = qos_class;
 
+	/* The VID from the extraction header contains the classified VLAN. But
+	 * if VLAN awareness is off and no retagging is done via VCAP IS1, that
+	 * classified VID will always be the pvid of the src_port.
+	 * port. We want Linux to see the classified VID, but only if the switch
+	 * intended to send the packet as untagged, i.e. if the VID is different
+	 * than the CPU port's untagged (native) VID.
+	 */
+	vid = vlan_tci & VLAN_VID_MASK;
+	hdr = eth_hdr(skb);
+	ocelot_port = ocelot->ports[src_port];
+	if (hdr->h_proto == htons(ETH_P_8021Q) && vid != ocelot_port->pvid) {
+		u16 dummy_vlan_tci;
+
+		skb_push_rcsum(skb, ETH_HLEN);
+		__skb_vlan_pop(skb, &dummy_vlan_tci);
+		skb_pull_rcsum(skb, ETH_HLEN);
+		skb_reset_network_header(skb);
+		skb_reset_transport_header(skb);
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tci);
+	}
+
 	return skb;
 }
 
-- 
2.17.1

