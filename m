Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F8825C30C
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 16:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgICOnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 10:43:16 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45838 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729355AbgICOgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 10:36:53 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DE721AFE559109854FAC;
        Thu,  3 Sep 2020 22:36:44 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Sep 2020 22:36:38 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC V2 net-next 2/2] net: disable UDP GSO features when CSUM is disable
Date:   Thu, 3 Sep 2020 22:34:19 +0800
Message-ID: <1599143659-62176-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599143659-62176-1-git-send-email-tanhuazhong@huawei.com>
References: <1599143659-62176-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CSUM is not available, UDP GSO should be disable as well.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 net/core/dev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index d42c9ea..0c78306 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9402,6 +9402,18 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 		features &= ~NETIF_F_TSO6;
 	}
 
+	if ((features & NETIF_F_GSO_UDP_L4) && !(features & NETIF_F_HW_CSUM) &&
+	    !(features & NETIF_F_IP_CSUM)) {
+		netdev_dbg(dev, "Dropping UDP GSO features since no CSUM feature.\n");
+		features &= ~NETIF_F_GSO_UDP_L4;
+	}
+
+	if ((features & NETIF_F_GSO_UDPV6_L4) && !(features & NETIF_F_HW_CSUM) &&
+	    !(features & NETIF_F_IPV6_CSUM)) {
+		netdev_dbg(dev, "Dropping UDPV6 GSO features since no CSUM feature.\n");
+		features &= ~NETIF_F_GSO_UDPV6_L4;
+	}
+
 	/* TSO with IPv4 ID mangling requires IPv4 TSO be enabled */
 	if ((features & NETIF_F_TSO_MANGLEID) && !(features & NETIF_F_TSO))
 		features &= ~NETIF_F_TSO_MANGLEID;
-- 
2.7.4

