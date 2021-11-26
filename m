Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1E345ED94
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 13:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377376AbhKZMNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 07:13:12 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:28178 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377479AbhKZMLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 07:11:11 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J0tkM1GqJz8vTj;
        Fri, 26 Nov 2021 20:06:03 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 26 Nov 2021 20:07:56 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 26 Nov 2021 20:07:55 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 4/4] net: hns3: fix incorrect components info of ethtool --reset command
Date:   Fri, 26 Nov 2021 20:03:18 +0800
Message-ID: <20211126120318.33921-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126120318.33921-1-huangguangbin2@huawei.com>
References: <20211126120318.33921-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently, HNS3 driver doesn't clear the reset flags of components after
successfully executing reset, it causes userspace info of
"Components reset" and "Components not reset" is incorrect.

So fix this problem by clear corresponding reset flag after reset process.

Fixes: ddccc5e368a3 ("net: hns3: add support for triggering reset by ethtool")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index c8442b86df94..c9b4568d7a8d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -987,6 +987,7 @@ static int hns3_set_reset(struct net_device *netdev, u32 *flags)
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
 	const struct hnae3_ae_ops *ops = h->ae_algo->ops;
 	const struct hns3_reset_type_map *rst_type_map;
+	enum ethtool_reset_flags rst_flags;
 	u32 i, size;
 
 	if (ops->ae_dev_resetting && ops->ae_dev_resetting(h))
@@ -1006,6 +1007,7 @@ static int hns3_set_reset(struct net_device *netdev, u32 *flags)
 	for (i = 0; i < size; i++) {
 		if (rst_type_map[i].rst_flags == *flags) {
 			rst_type = rst_type_map[i].rst_type;
+			rst_flags = rst_type_map[i].rst_flags;
 			break;
 		}
 	}
@@ -1021,6 +1023,8 @@ static int hns3_set_reset(struct net_device *netdev, u32 *flags)
 
 	ops->reset_event(h->pdev, h);
 
+	*flags &= ~rst_flags;
+
 	return 0;
 }
 
-- 
2.33.0

