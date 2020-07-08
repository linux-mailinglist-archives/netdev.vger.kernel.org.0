Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1ABC217DC1
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 05:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgGHDu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 23:50:56 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41096 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729501AbgGHDuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 23:50:54 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6C8DDBE0C5FF8AC956C4;
        Wed,  8 Jul 2020 11:50:52 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 8 Jul 2020 11:50:43 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC net-next 2/2] net: disable UDP GSO feature when CSUM is disabled
Date:   Wed, 8 Jul 2020 11:48:56 +0800
Message-ID: <1594180136-15912-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594180136-15912-1-git-send-email-tanhuazhong@huawei.com>
References: <1594180136-15912-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since UDP GSO feature is depended on checksum offload, so disable
UDP GSO feature when CSUM is disabled, then from user-space also
can see UDP GSO feature is disabled.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 net/core/dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index c02bae9..dcb6b35 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9095,6 +9095,12 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 		features &= ~NETIF_F_TSO6;
 	}
 
+	if ((features & NETIF_F_GSO_UDP_L4) && !(features & NETIF_F_HW_CSUM) &&
+	    (!(features & NETIF_F_IP_CSUM) || !(features & NETIF_F_IPV6_CSUM))) {
+		netdev_dbg(dev, "Dropping UDP GSO features since no CSUM feature.\n");
+		features &= ~NETIF_F_GSO_UDP_L4;
+	}
+
 	/* TSO with IPv4 ID mangling requires IPv4 TSO be enabled */
 	if ((features & NETIF_F_TSO_MANGLEID) && !(features & NETIF_F_TSO))
 		features &= ~NETIF_F_TSO_MANGLEID;
-- 
2.7.4

