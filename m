Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F0B1D301B
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 14:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgENMnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 08:43:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59340 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726117AbgENMnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 08:43:00 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 108BAD8A4B1C2E6F9133;
        Thu, 14 May 2020 20:42:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 14 May 2020 20:42:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/5] net: hns3: remove unnecessary frag list checking in hns3_nic_net_xmit()
Date:   Thu, 14 May 2020 20:41:26 +0800
Message-ID: <1589460086-61130-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589460086-61130-1-git-send-email-tanhuazhong@huawei.com>
References: <1589460086-61130-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb_has_frag_list() in hns3_nic_net_xmit() is redundant, since
skb_walk_frags() includes this checking implicitly.

Reported-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index c79d6a3..9fe40c7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1445,9 +1445,6 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	bd_num += ret;
 
-	if (!skb_has_frag_list(skb))
-		goto out;
-
 	skb_walk_frags(skb, frag_skb) {
 		ret = hns3_fill_skb_to_desc(ring, frag_skb,
 					    DESC_TYPE_FRAGLIST_SKB);
@@ -1456,7 +1453,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 		bd_num += ret;
 	}
-out:
+
 	pre_ntu = ring->next_to_use ? (ring->next_to_use - 1) :
 					(ring->desc_num - 1);
 	ring->desc[pre_ntu].tx.bdtp_fe_sc_vld_ra_ri |=
-- 
2.7.4

