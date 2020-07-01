Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C5E21026D
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 05:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgGADRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 23:17:34 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6791 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbgGADRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 23:17:33 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EF416CDBD0BBF699E9A2;
        Wed,  1 Jul 2020 11:17:30 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Wed, 1 Jul 2020 11:17:20 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net v1] hinic: fix passing non negative value to ERR_PTR
Date:   Wed, 1 Jul 2020 11:16:33 +0800
Message-ID: <20200701031633.24249-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_dev_cap and set_resources_state functions may return a positive
value because of hardware failure, and the positive return value
can not be passed to ERR_PTR directly.

Fixes: 7dd29ee12865 ("hinic: add sriov feature support")
Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 0245da02efbb..b735bc537508 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -814,6 +814,8 @@ struct hinic_hwdev *hinic_init_hwdev(struct pci_dev *pdev)
 err_init_msix:
 err_pfhwdev_alloc:
 	hinic_free_hwif(hwif);
+	if (err > 0)
+		err = -EIO;
 	return ERR_PTR(err);
 }
 
-- 
2.17.1

