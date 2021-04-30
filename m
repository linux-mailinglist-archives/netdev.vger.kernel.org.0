Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5766B36F789
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 11:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbhD3JHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 05:07:09 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3973 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhD3JHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 05:07:06 -0400
Received: from dggeml754-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FWmdB33qGzYfrk;
        Fri, 30 Apr 2021 17:03:58 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggeml754-chm.china.huawei.com (10.1.199.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 30 Apr 2021 17:06:16 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 30 Apr 2021 17:06:16 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/4] net: hns3: fix for vxlan gpe tx checksum bug
Date:   Fri, 30 Apr 2021 17:06:19 +0800
Message-ID: <1619773582-17828-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1619773582-17828-1-git-send-email-tanhuazhong@huawei.com>
References: <1619773582-17828-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

When skb->ip_summed is CHECKSUM_PARTIAL, for non-tunnel udp packet,
which has a dest port as the IANA assigned, the hardware is expected
to do the checksum offload, but the hardware whose version is below
V3 will not do the checksum offload when udp dest port is 4790.

So fixes it by doing the checksum in software for this case.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 5dc6de5..a2b9a8a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -824,7 +824,7 @@ static int hns3_get_l4_protocol(struct sk_buff *skb, u8 *ol4_proto,
  * and it is udp packet, which has a dest port as the IANA assigned.
  * the hardware is expected to do the checksum offload, but the
  * hardware will not do the checksum offload when udp dest port is
- * 4789 or 6081.
+ * 4789, 4790 or 6081.
  */
 static bool hns3_tunnel_csum_bug(struct sk_buff *skb)
 {
@@ -842,7 +842,8 @@ static bool hns3_tunnel_csum_bug(struct sk_buff *skb)
 
 	if (!(!skb->encapsulation &&
 	      (l4.udp->dest == htons(IANA_VXLAN_UDP_PORT) ||
-	      l4.udp->dest == htons(GENEVE_UDP_PORT))))
+	      l4.udp->dest == htons(GENEVE_UDP_PORT) ||
+	      l4.udp->dest == htons(4790))))
 		return false;
 
 	skb_checksum_help(skb);
-- 
2.7.4

