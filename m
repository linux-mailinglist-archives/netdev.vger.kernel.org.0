Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27FF8AF3E6
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 03:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfIKBTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 21:19:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:43384 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726043AbfIKBTC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 21:19:02 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A34B2D290D4AACE16FC9;
        Wed, 11 Sep 2019 09:18:59 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Wed, 11 Sep 2019 09:18:52 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <tsbogend@alpha.franken.de>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Mao Wenan <maowenan@huawei.com>
Subject: [PATCH v2 net] net: sonic: replace dev_kfree_skb in sonic_send_packet
Date:   Wed, 11 Sep 2019 09:36:23 +0800
Message-ID: <20190911013623.36897-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <a48a6690-eeb4-91d2-bed8-439d14b63e2f@cogentembedded.com>
References: <a48a6690-eeb4-91d2-bed8-439d14b63e2f@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sonic_send_packet will be processed in irq or non-irq 
context, so it would better use dev_kfree_skb_any
instead of dev_kfree_skb.

Fixes: d9fb9f384292 ("*sonic/natsemi/ns83829: Move the National Semi-conductor drivers")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 v2: change 'none irq' to 'non-irq'.
 drivers/net/ethernet/natsemi/sonic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 18fd62fbfb64..b339125b2f09 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -233,7 +233,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	laddr = dma_map_single(lp->device, skb->data, length, DMA_TO_DEVICE);
 	if (!laddr) {
 		pr_err_ratelimited("%s: failed to map tx DMA buffer.\n", dev->name);
-		dev_kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
 
-- 
2.20.1

