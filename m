Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464EC2294C5
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 11:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731257AbgGVJXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 05:23:22 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7813 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728360AbgGVJXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 05:23:22 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B51F97DE6915831AF274;
        Wed, 22 Jul 2020 17:23:19 +0800 (CST)
Received: from huawei.com (10.179.179.12) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Wed, 22 Jul 2020
 17:23:10 +0800
From:   guodeqing <geffrey.guo@huawei.com>
To:     <davem@davemloft.net>
CC:     <kuba@kernel.org>, <maheshb@google.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <geffrey.guo@huawei.com>
Subject: [PATCH,v2] ipvlan: add the check of ip header checksum
Date:   Wed, 22 Jul 2020 17:18:19 +0800
Message-ID: <1595409499-25008-1-git-send-email-geffrey.guo@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.179.179.12]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ip header checksum can be error in the following steps.
$ ip netns add ns1
$ ip link add gw link eth0 type ipvlan
$ ip addr add 168.16.0.1/24 dev gw
$ ip link set dev gw up
$ ip link add ip1 link eth0 type ipvlan
$ ip link set ip1 netns ns1
$ ip netns exec ns1 ip link set ip1 up
$ ip netns exec ns1 ip addr add 168.16.0.2/24 dev ip1
$ ip netns exec ns1 tc qdisc add dev ip1 root netem corrupt 50%
$ ip netns exec ns1 ping 168.16.0.1

This is because the netem will modify the packet randomly. the
corrupted packets should be dropped derectly, otherwise it may
cause a problem.

Here I add the check of ip header checksum and drop the illegal
packets in l3/l3s mode.

Signed-off-by: guodeqing <geffrey.guo@huawei.com>
---
 drivers/net/ipvlan/ipvlan_core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index 8801d09..ccf3193 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -160,6 +160,10 @@ void *ipvlan_get_L3_hdr(struct ipvl_port *port, struct sk_buff *skb, int *type)
 		pktlen = ntohs(ip4h->tot_len);
 		if (ip4h->ihl < 5 || ip4h->version != 4)
 			return NULL;
+
+		if (unlikely(ip_fast_csum((u8 *)ip4h, ip4h->ihl)))
+			return NULL;
+
 		if (skb->len < pktlen || pktlen < (ip4h->ihl * 4))
 			return NULL;
 
@@ -569,8 +573,10 @@ static int ipvlan_xmit_mode_l3(struct sk_buff *skb, struct net_device *dev)
 	int addr_type;
 
 	lyr3h = ipvlan_get_L3_hdr(ipvlan->port, skb, &addr_type);
-	if (!lyr3h)
-		goto out;
+	if (!lyr3h) {
+		kfree_skb(skb);
+		return NET_XMIT_DROP;
+	}
 
 	if (!ipvlan_is_vepa(ipvlan->port)) {
 		addr = ipvlan_addr_lookup(ipvlan->port, lyr3h, addr_type, true);
@@ -582,7 +588,7 @@ static int ipvlan_xmit_mode_l3(struct sk_buff *skb, struct net_device *dev)
 			return ipvlan_rcv_frame(addr, &skb, true);
 		}
 	}
-out:
+
 	ipvlan_skb_crossing_ns(skb, ipvlan->phy_dev);
 	return ipvlan_process_outbound(skb);
 }
-- 
2.7.4

