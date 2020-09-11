Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE4E2656C8
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 03:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgIKB6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 21:58:18 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58084 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725298AbgIKB6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 21:58:15 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8E8368154E49A4853951;
        Fri, 11 Sep 2020 09:58:14 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.202.211) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Fri, 11 Sep 2020 09:58:07 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linuxarm@huawei.com>, Barry Song <song.bao.hua@hisilicon.com>,
        "Salil Mehta" <salil.mehta@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>
Subject: [PATCH net-next] net: hns: use IRQ_NOAUTOEN to avoid irq is enabled due to request_irq
Date:   Fri, 11 Sep 2020 13:55:10 +1200
Message-ID: <20200911015510.31420-1-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.202.211]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than doing request_irq and then disabling the irq immediately, it
should be safer to use IRQ_NOAUTOEN flag for the irq. It removes any gap
between request_irq() and disable_irq().

Cc: Salil Mehta <salil.mehta@huawei.com>
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 22522f8a5299..34cc469656e8 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -11,6 +11,7 @@
 #include <linux/io.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
@@ -1293,6 +1294,7 @@ static int hns_nic_init_irq(struct hns_nic_priv *priv)
 
 		rd->ring->ring_name[RCB_RING_NAME_LEN - 1] = '\0';
 
+		irq_set_status_flags(rd->ring->irq, IRQ_NOAUTOEN);
 		ret = request_irq(rd->ring->irq,
 				  hns_irq_handle, 0, rd->ring->ring_name, rd);
 		if (ret) {
@@ -1300,7 +1302,6 @@ static int hns_nic_init_irq(struct hns_nic_priv *priv)
 				   rd->ring->irq);
 			goto out_free_irq;
 		}
-		disable_irq(rd->ring->irq);
 
 		cpu = hns_nic_init_affinity_mask(h->q_num, i,
 						 rd->ring, &rd->mask);
-- 
2.25.1


