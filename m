Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E822E2B2C
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 11:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgLYKgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 05:36:24 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9689 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728667AbgLYKgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 05:36:23 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D2Nbz5KMdzkwDn
        for <netdev@vger.kernel.org>; Fri, 25 Dec 2020 18:34:39 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Fri, 25 Dec 2020
 18:35:26 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jerry.lilijun@huawei.com>, <xudingke@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net] net: hns: fix return value check in __lb_other_process()
Date:   Fri, 25 Dec 2020 18:35:25 +0800
Message-ID: <1608892525-21384-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.243.127]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

The function skb_copy() could return NULL, the return value
need to be checked.

Fixes: b5996f11ea54 ("net: add Hisilicon Network Subsystem basic ethernet support")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index 7165da0ee9aa..ad18f0e20a23 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -415,6 +415,10 @@ static void __lb_other_process(struct hns_nic_ring_data *ring_data,
 	/* for mutl buffer*/
 	new_skb = skb_copy(skb, GFP_ATOMIC);
 	dev_kfree_skb_any(skb);
+	if (!new_skb) {
+		ndev->stats.rx_dropped++;
+		return;
+	}
 	skb = new_skb;
 
 	check_ok = 0;
-- 
2.23.0

