Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A5E1E42D4
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 15:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbgE0NAB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 May 2020 09:00:01 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2150 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730045AbgE0NAB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 09:00:01 -0400
Received: from DGGEML403-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 6274EA3AC46CB98C2FC5;
        Wed, 27 May 2020 20:59:58 +0800 (CST)
Received: from DGGEML523-MBX.china.huawei.com ([169.254.4.221]) by
 DGGEML403-HUB.china.huawei.com ([fe80::74d9:c659:fbec:21fa%31]) with mapi id
 14.03.0487.000; Wed, 27 May 2020 20:59:52 +0800
From:   Fengtiantian <fengtiantian@huawei.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING [GENERAL" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        "Jiri Pirko" <jiri@mellanox.com>, Arnd Bergmann <arnd@arndb.de>,
        Hadar Hen Zion <hadarh@mellanox.com>
CC:     "Huangweidong (C)" <weidong.huang@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: [patch] flow_dissector:  Fix wrong vlan header offset in
 __skb_flow_dissect
Thread-Topic: [patch] flow_dissector:  Fix wrong vlan header offset in
 __skb_flow_dissect
Thread-Index: AdY0IeXHJXIXgx+ATVmoGwihjqqNXQ==
Date:   Wed, 27 May 2020 12:59:52 +0000
Message-ID: <2A6E6328DF026B458DBF90B38941F981871A42F1@DGGEML523-MBX.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.149.160]
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We use the openvswitch 2.7.0 and find the issue when ovs use the skb_get_hash() to get the hash of QinQ skb. Because the
__skb_flow_dissect() get the wrong vlan protocol headers.

Someone report bonding driver has the same issue use the
__skb_flow_dissect() to count hash in bond_xmit_hash:
https://lore.kernel.org/netdev/00a5d09f-a23e-661f-60c0-
75fba6227451@huawei.com/T/.

Because in netif_receive_skb, the skb_network_header points to vlan head, but in dev_hard_start_xmit, the skb_network_header points to IP header. So use the skb_network_offset to get the vlan head is not reliable.

Should we use the skb_mac_offset instead the skb_network_offset to get the vlan head when proto is ETH_P_8021AD or ETH_P_8021Q?

Signed-off-by: Feng tiantian <fengtiantian@huawei.com>
---
 net/core/flow_dissector.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c index 415b95f..9a77d5d 100644
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

