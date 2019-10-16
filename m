Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5F84D8937
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732778AbfJPHUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:20:10 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4168 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730643AbfJPHUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 03:20:10 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8EBA7940BD9616D1673B;
        Wed, 16 Oct 2019 15:20:08 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 16 Oct 2019 15:20:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 11/12] net: hns3: do not allocate linear data for fraglist skb
Date:   Wed, 16 Oct 2019 15:17:10 +0800
Message-ID: <1571210231-29154-12-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
References: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Currently, napi_alloc_skb() is used to allocate skb for fraglist
when the head skb is not enough to hold the remaining data, and
the remaining data is added to the frags part of the fraglist skb,
leaving the linear part unused.

So this patch passes length of 0 to allocate fraglist skb with
zero size of linear data.

Fixes: 81ae0e0491f3 ("net: hns3: Add skb chain when num of RX buf exceeds MAX_SKB_FRAGS")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 6172eb2..14111af 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2866,8 +2866,7 @@ static int hns3_add_frag(struct hns3_enet_ring *ring, struct hns3_desc *desc,
 			return -ENXIO;
 
 		if (unlikely(ring->frag_num >= MAX_SKB_FRAGS)) {
-			new_skb = napi_alloc_skb(&ring->tqp_vector->napi,
-						 HNS3_RX_HEAD_SIZE);
+			new_skb = napi_alloc_skb(&ring->tqp_vector->napi, 0);
 			if (unlikely(!new_skb)) {
 				hns3_rl_err(ring_to_netdev(ring),
 					    "alloc rx fraglist skb fail\n");
-- 
2.7.4

