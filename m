Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0E62280B9
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgGUNOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:14:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7811 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726687AbgGUNOX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 09:14:23 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 30030EBE669E1EAB3CAB;
        Tue, 21 Jul 2020 21:14:19 +0800 (CST)
Received: from huawei.com (10.179.179.12) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Tue, 21 Jul 2020
 21:14:11 +0800
From:   guodeqing <geffrey.guo@huawei.com>
To:     <davem@davemloft.net>
CC:     <kuba@kernel.org>, <maheshb@google.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <geffrey.guo@huawei.com>
Subject: [PATCH] ipvlan: add the check of ip header checksum
Date:   Tue, 21 Jul 2020 21:09:22 +0800
Message-ID: <1595336962-98677-1-git-send-email-geffrey.guo@huawei.com>
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

The ip header of a packet maybe modified when it steps in
ipvlan_process_v4_outbound because of the netem, the corruptted
packets should be dropped.

Here I add the check of ip header to drop the corruptted packets
and to avoid a problem in some cases.

Signed-off-by: guodeqing <geffrey.guo@huawei.com>
---
 drivers/net/ipvlan/ipvlan_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index 8801d09..22cef89 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -428,6 +428,12 @@ static int ipvlan_process_v4_outbound(struct sk_buff *skb)
 		.saddr = ip4h->saddr,
 	};
 
+	if (ip4h->ihl < 5)
+		goto err;
+
+	if (unlikely(ip_fast_csum((u8 *)ip4h, ip4h->ihl)))
+		goto err;
+
 	rt = ip_route_output_flow(net, &fl4, NULL);
 	if (IS_ERR(rt))
 		goto err;
-- 
2.7.4

