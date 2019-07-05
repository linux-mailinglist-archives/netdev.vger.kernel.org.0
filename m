Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43AD9600D0
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 08:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfGEGK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 02:10:59 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44644 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725772AbfGEGK7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 02:10:59 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6BCCC188B2DA79EDC3BB;
        Fri,  5 Jul 2019 14:10:57 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 14:10:50 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <dingtianhong@huawei.com>, <xiaojiangfeng@huawei.com>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <leeyou.li@huawei.com>, <xiekunxun@huawei.com>,
        <jianping.liu@huawei.com>, <nixiaoming@huawei.com>
Subject: [PATCH 02/10] net: hisilicon: Cleanup for got restricted __be32
Date:   Fri, 5 Jul 2019 14:10:44 +0800
Message-ID: <1562307044-103602-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.167]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the following warning from sparse:
hip04_eth.c:468:25: warning: incorrect type in assignment
hip04_eth.c:468:25:    expected unsigned int [usertype] send_addr
hip04_eth.c:468:25:    got restricted __be32 [usertype]
hip04_eth.c:469:25: warning: incorrect type in assignment
hip04_eth.c:469:25:    expected unsigned int [usertype] send_size
hip04_eth.c:469:25:    got restricted __be32 [usertype]
hip04_eth.c:470:19: warning: incorrect type in assignment
hip04_eth.c:470:19:    expected unsigned int [usertype] cfg
hip04_eth.c:470:19:    got restricted __be32 [usertype]
hip04_eth.c:472:23: warning: incorrect type in assignment
hip04_eth.c:472:23:    expected unsigned int [usertype] wb_addr
hip04_eth.c:472:23:    got restricted __be32 [usertype]

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 2b5112b..31f13cf 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -465,11 +465,11 @@ static void hip04_start_tx_timer(struct hip04_priv *priv)
 
 	priv->tx_skb[tx_head] = skb;
 	priv->tx_phys[tx_head] = phys;
-	desc->send_addr = cpu_to_be32(phys);
-	desc->send_size = cpu_to_be32(skb->len);
-	desc->cfg = cpu_to_be32(TX_CLEAR_WB | TX_FINISH_CACHE_INV);
+	desc->send_addr = (__force u32)cpu_to_be32(phys);
+	desc->send_size = (__force u32)cpu_to_be32(skb->len);
+	desc->cfg = (__force u32)cpu_to_be32(TX_CLEAR_WB | TX_FINISH_CACHE_INV);
 	phys = priv->tx_desc_dma + tx_head * sizeof(struct tx_desc);
-	desc->wb_addr = cpu_to_be32(phys);
+	desc->wb_addr = (__force u32)cpu_to_be32(phys);
 	skb_tx_timestamp(skb);
 
 	hip04_set_xmit_desc(priv, phys);
-- 
1.8.5.6

