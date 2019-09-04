Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E87A7F41
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 11:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbfIDJY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 05:24:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6638 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727387AbfIDJY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 05:24:27 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 168A0551EB4C7E8EE852;
        Wed,  4 Sep 2019 17:24:25 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 17:24:17 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <tsbogend@alpha.franken.de>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Mao Wenan <maowenan@huawei.com>
Subject: [PATCH net] net: sonic: remove dev_kfree_skb before return NETDEV_TX_BUSY
Date:   Wed, 4 Sep 2019 17:42:11 +0800
Message-ID: <20190904094211.117454-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When dma_map_single is failed to map buffer, skb can't be freed
before sonic driver return to stack with NETDEV_TX_BUSY, because
this skb may be requeued to qdisc, it might trigger use-after-free.

Fixes: d9fb9f384292 ("*sonic/natsemi/ns83829: Move the National Semi-conductor drivers")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/ethernet/natsemi/sonic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index d0a01e8f000a..248a8f22a33b 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -233,7 +233,6 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	laddr = dma_map_single(lp->device, skb->data, length, DMA_TO_DEVICE);
 	if (!laddr) {
 		printk(KERN_ERR "%s: failed to map tx DMA buffer.\n", dev->name);
-		dev_kfree_skb(skb);
 		return NETDEV_TX_BUSY;
 	}
 
-- 
2.20.1

