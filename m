Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1B940C6D9
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 15:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237739AbhION5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 09:57:43 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:16215 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234691AbhION5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 09:57:38 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4H8hYb2mZxz1DGwc;
        Wed, 15 Sep 2021 21:55:15 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 21:56:16 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 21:56:15 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 5/6] net: hns3: check vlan id before using it
Date:   Wed, 15 Sep 2021 21:52:10 +0800
Message-ID: <20210915135211.9129-6-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915135211.9129-1-huangguangbin2@huawei.com>
References: <20210915135211.9129-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: liaoguojia <liaoguojia@huawei.com>

The input parameters may not be reliable, so check the vlan id before
using it, otherwise may set wrong vlan id into hardware.

Fixes: dc8131d846d4 ("net: hns3: Fix for packet loss due wrong filter config in VLAN tbls")
Signed-off-by: liaoguojia <liaoguojia@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index afc88a41a89c..14e9daf09f8c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9817,6 +9817,9 @@ static int hclge_set_vlan_filter_hw(struct hclge_dev *hdev, __be16 proto,
 	if (is_kill && !vlan_id)
 		return 0;
 
+	if (vlan_id >= VLAN_N_VID)
+		return -EINVAL;
+
 	ret = hclge_set_vf_vlan_common(hdev, vport_id, is_kill, vlan_id);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-- 
2.33.0

