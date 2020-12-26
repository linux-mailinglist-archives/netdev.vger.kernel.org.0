Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B642E2DAD
	for <lists+netdev@lfdr.de>; Sat, 26 Dec 2020 09:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgLZIK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 03:10:59 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9691 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgLZIK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 03:10:58 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D2xKn3qvqzkvwQ
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 16:09:17 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Sat, 26 Dec 2020
 16:10:06 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <liuyonglong@huawei.com>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net v2] net: hns: fix return value check in __lb_other_process()
Date:   Sat, 26 Dec 2020 16:10:05 +0800
Message-ID: <1608970205-24512-1-git-send-email-wangyunjian@huawei.com>
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
index 7165da0ee9aa..a6e3f07caf99 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -415,6 +415,10 @@ static void __lb_other_process(struct hns_nic_ring_data *ring_data,
 	/* for mutl buffer*/
 	new_skb = skb_copy(skb, GFP_ATOMIC);
 	dev_kfree_skb_any(skb);
+	if (!new_skb) {
+		netdev_err(ndev, "skb alloc failed\n");
+		return;
+	}
 	skb = new_skb;
 
 	check_ok = 0;
-- 
2.23.0

