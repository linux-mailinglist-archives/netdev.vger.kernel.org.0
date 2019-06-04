Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A855A33DA5
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 06:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFDECe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 00:02:34 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18076 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbfFDECe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 00:02:34 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3943AF26C5A7EC46D866;
        Tue,  4 Jun 2019 12:02:32 +0800 (CST)
Received: from huawei.com (10.175.100.202) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Tue, 4 Jun 2019
 12:02:23 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <idosch@mellanox.com>,
        <daniel@iogearbox.net>, <petrm@mellanox.com>, <jiri@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <mingfangsen@huawei.com>, <wangxiaogang3@huawei.com>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: ipvlan: Fix ipvlan device tso disabled while NETIF_F_IP_CSUM is set
Date:   Tue, 4 Jun 2019 06:07:34 +0000
Message-ID: <1559628454-138692-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.202]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's some NICs, such as hinic, with NETIF_F_IP_CSUM and NETIF_F_TSO
on but NETIF_F_HW_CSUM off. And ipvlan device features will be
NETIF_F_TSO on with NETIF_F_IP_CSUM and NETIF_F_IP_CSUM both off as
IPVLAN_FEATURES only care about NETIF_F_HW_CSUM. So TSO will be
disabled in netdev_fix_features.
For example:
Features for enp129s0f0:
rx-checksumming: on
tx-checksumming: on
        tx-checksum-ipv4: on
        tx-checksum-ip-generic: off [fixed]
        tx-checksum-ipv6: on

Fixes: a188222b6ed2 ("net: Rename NETIF_F_ALL_CSUM to NETIF_F_CSUM_MASK")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 drivers/net/ipvlan/ipvlan_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index bbeb1623e2d5..717fce6edeb7 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -112,7 +112,7 @@ static void ipvlan_port_destroy(struct net_device *dev)
 }
 
 #define IPVLAN_FEATURES \
-	(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST | \
+	(NETIF_F_SG | NETIF_F_CSUM_MASK | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST | \
 	 NETIF_F_GSO | NETIF_F_TSO | NETIF_F_GSO_ROBUST | \
 	 NETIF_F_TSO_ECN | NETIF_F_TSO6 | NETIF_F_GRO | NETIF_F_RXCSUM | \
 	 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER)
-- 
2.21.GIT

