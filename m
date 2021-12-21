Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775E347BE75
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 11:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbhLUKut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 05:50:49 -0500
Received: from inva021.nxp.com ([92.121.34.21]:59802 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229761AbhLUKus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 05:50:48 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 7AB14201A00;
        Tue, 21 Dec 2021 11:50:47 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 428352019FE;
        Tue, 21 Dec 2021 11:50:47 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 81357183AC4F;
        Tue, 21 Dec 2021 18:50:45 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, kuba@kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, xiaoliang.yang_1@nxp.com,
        marouen.ghodhbane@nxp.com
Subject: [PATCH net-next] net: dsa: tag_ocelot: use traffic class to map priority on injected header
Date:   Tue, 21 Dec 2021 19:02:09 +0800
Message-Id: <20211221110209.31309-1-xiaoliang.yang_1@nxp.com>
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

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Marouen Ghodhbane <marouen.ghodhbane@nxp.com>
---
 net/dsa/tag_ocelot.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 4ba460c5a880..0d81f172b7a6 100644
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

