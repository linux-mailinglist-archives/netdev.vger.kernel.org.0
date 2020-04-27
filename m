Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BFE1BA700
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 16:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgD0OzP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Apr 2020 10:55:15 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:55742 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727010AbgD0OzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 10:55:14 -0400
Received: from DGGEML404-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id A4C13DB0F1E6D0AEA991;
        Mon, 27 Apr 2020 22:55:10 +0800 (CST)
Received: from DGGEML422-HUB.china.huawei.com (10.1.199.39) by
 DGGEML404-HUB.china.huawei.com (10.3.17.39) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 27 Apr 2020 22:55:10 +0800
Received: from DGGEML523-MBX.china.huawei.com ([169.254.4.80]) by
 dggeml422-hub.china.huawei.com ([10.1.199.39]) with mapi id 14.03.0487.000;
 Mon, 27 Apr 2020 22:55:04 +0800
From:   Fengtiantian <fengtiantian@huawei.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING [GENERAL" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
CC:     "Huangweidong (C)" <weidong.huang@huawei.com>
Subject: Fix vlan header offset in __skb_flow_dissect
Thread-Topic: Fix vlan header offset in __skb_flow_dissect
Thread-Index: AdYcltlLAUkerg4YRUKhy1eOb6UWJQ==
Date:   Mon, 27 Apr 2020 14:55:03 +0000
Message-ID: <2A6E6328DF026B458DBF90B38941F981871794C2@DGGEML523-MBX.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.242.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We use the openvswitch 2.7.0 and find the issue when ovs use
the skb_get_hash() to get the hash of QinQ skb. Because the
__skb_flow_dissect() get the wrong vlan protocol headers.

Someone report bonding driver has the same issue use the
__skb_flow_dissect() to count hash in bond_xmit_hash:
https://lore.kernel.org/netdev/00a5d09f-a23e-661f-60c0-
75fba6227451@huawei.com/T/.

Because in netif_receive_skb, the skb_network_header points
to vlan head, but in dev_hard_start_xmit, the skb_network_header
points to IP header. So use the skb_network_offset to get the
vlan head is not reliable.

Should we use the skb_mac_offset instead the skb_network_offset
to get the vlan head when proto is ETH_P_8021AD or ETH_P_8021Q?

Signed-off-by: Feng tiantian <fengtiantian@huawei.com>
---
 net/core/flow_dissector.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 415b95f..9a77d5d 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -629,6 +629,13 @@ bool __skb_flow_dissect(const struct sk_buff *skb,
 			 skb->vlan_proto : skb->protocol;
 		nhoff = skb_network_offset(skb);
 		hlen = skb_headlen(skb);
+
+		if (proto == htons(ETH_P_8021AD) ||
+		    proto == htons(ETH_P_8021Q)) {
+			if (skb_mac_header_was_set(skb))
+				nhoff = skb_mac_offset(skb) + ETH_HLEN;
+		}
+
 #if IS_ENABLED(CONFIG_NET_DSA)
 		if (unlikely(skb->dev && netdev_uses_dsa(skb->dev))) {
 			const struct dsa_device_ops *ops;
-- 
1.8.3.1

