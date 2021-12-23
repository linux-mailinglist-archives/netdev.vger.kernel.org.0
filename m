Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5656F47DF5C
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 08:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346736AbhLWHKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 02:10:54 -0500
Received: from inva020.nxp.com ([92.121.34.13]:39290 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235212AbhLWHKy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 02:10:54 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 298661A2AA7;
        Thu, 23 Dec 2021 08:10:53 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E67C91A03E7;
        Thu, 23 Dec 2021 08:10:52 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id D0D78183AC72;
        Thu, 23 Dec 2021 15:10:50 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, kuba@kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, xiaoliang.yang_1@nxp.com,
        marouen.ghodhbane@nxp.com
Subject: [PATCH v2 net] net: dsa: tag_ocelot: use traffic class to map priority on injected header
Date:   Thu, 23 Dec 2021 15:22:11 +0800
Message-Id: <20211223072211.33130-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For Ocelot switches, the CPU injected frames have an injection header
where it can specify the QoS class of the packet and the DSA tag, now it
uses the SKB priority to set that. If a traffic class to priority
mapping is configured on the netdevice (with mqprio for example ...), it
won't be considered for CPU injected headers. This patch make the QoS
class aligned to the priority to traffic class mapping if it exists.

Fixes: 8dce89aa5f32 ("net: dsa: ocelot: add tagger for Ocelot/Felix switches")
Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Marouen Ghodhbane <marouen.ghodhbane@nxp.com>
---
v1->v2:
 - Add fix tag and resend to net branch.

 net/dsa/tag_ocelot.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index de1c849a0a70..4ed74d509d6a 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -47,9 +47,13 @@ static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
 	void *injection;
 	__be32 *prefix;
 	u32 rew_op = 0;
+	u64 qos_class;
 
 	ocelot_xmit_get_vlan_info(skb, dp, &vlan_tci, &tag_type);
 
+	qos_class = netdev_get_num_tc(netdev) ?
+		    netdev_get_prio_tc_map(netdev, skb->priority) : skb->priority;
+
 	injection = skb_push(skb, OCELOT_TAG_LEN);
 	prefix = skb_push(skb, OCELOT_SHORT_PREFIX_LEN);
 
@@ -57,7 +61,7 @@ static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
 	memset(injection, 0, OCELOT_TAG_LEN);
 	ocelot_ifh_set_bypass(injection, 1);
 	ocelot_ifh_set_src(injection, ds->num_ports);
-	ocelot_ifh_set_qos_class(injection, skb->priority);
+	ocelot_ifh_set_qos_class(injection, qos_class);
 	ocelot_ifh_set_vlan_tci(injection, vlan_tci);
 	ocelot_ifh_set_tag_type(injection, tag_type);
 
-- 
2.17.1

