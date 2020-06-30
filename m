Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427F620EE9E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgF3Ggv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 02:36:51 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43538 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730002AbgF3Ggu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 02:36:50 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BD9EAC538907F94E2103;
        Tue, 30 Jun 2020 14:36:47 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Tue, 30 Jun 2020 14:36:40 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net] hinic: fix passing non negative value to ERR_PTR
Date:   Tue, 30 Jun 2020 14:35:54 +0800
Message-ID: <20200630063554.14639-1-luobin9@huawei.com>
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

Fixes: 7dd29ee12865 ("net-next/hinic: add sriov feature support")
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

