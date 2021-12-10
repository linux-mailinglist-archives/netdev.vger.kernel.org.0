Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6FC470159
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbhLJNR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:17:56 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:28306 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235365AbhLJNRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 08:17:55 -0500
Received: from kwepemi500001.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J9WZN3CngzbjLx;
        Fri, 10 Dec 2021 21:14:04 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500001.china.huawei.com (7.221.188.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 21:14:18 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 21:14:18 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 1/2] net: hns3: fix use-after-free bug in hclgevf_send_mbx_msg
Date:   Fri, 10 Dec 2021 21:09:33 +0800
Message-ID: <20211210130934.36278-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211210130934.36278-1-huangguangbin2@huawei.com>
References: <20211210130934.36278-1-huangguangbin2@huawei.com>
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

From: Jie Wang <wangjie125@huawei.com>

Currently, the hns3_remove function firstly uninstall client instance,
and then uninstall acceletion engine device. The netdevice is freed in
client instance uninstall process, but acceletion engine device uninstall
process still use it to trace runtime information. This causes a use after
free problem.

So fixes it by check the instance register state to avoid use after free.

Fixes: d8355240cf8f ("net: hns3: add trace event support for PF/VF mailbox")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index fdc66fae0960..c5ac6ecf36e1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -114,7 +114,8 @@ int hclgevf_send_mbx_msg(struct hclgevf_dev *hdev,
 
 	memcpy(&req->msg, send_msg, sizeof(struct hclge_vf_to_pf_msg));
 
-	trace_hclge_vf_mbx_send(hdev, req);
+	if (test_bit(HCLGEVF_STATE_NIC_REGISTERED, &hdev->state))
+		trace_hclge_vf_mbx_send(hdev, req);
 
 	/* synchronous send */
 	if (need_resp) {
-- 
2.33.0

