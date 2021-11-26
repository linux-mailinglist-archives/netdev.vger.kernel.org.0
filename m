Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757D845EDA4
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 13:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377393AbhKZMNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 07:13:14 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:31912 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377476AbhKZMLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 07:11:11 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J0tmT0KvWzcbJm;
        Fri, 26 Nov 2021 20:07:53 +0800 (CST)
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
Subject: [PATCH net 3/4] net: hns3: fix one incorrect value of page pool info when queried by debugfs
Date:   Fri, 26 Nov 2021 20:03:17 +0800
Message-ID: <20211126120318.33921-4-huangguangbin2@huawei.com>
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

From: Hao Chen <chenhao288@hisilicon.com>

Currently, when user queries page pool info by debugfs command
"cat page_pool_info", the cnt of allocated page for page pool may be
incorrect because of memory inconsistency problem caused by compiler
optimization.

So this patch uses READ_ONCE() to read value of pages_state_hold_cnt to
fix this problem.

Fixes: 850bfb912a6d ("net: hns3: debugfs add support dumping page pool info")
Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index fbb8a5f08222..081295bff765 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -1081,7 +1081,8 @@ static void hns3_dump_page_pool_info(struct hns3_enet_ring *ring,
 	u32 j = 0;
 
 	sprintf(result[j++], "%u", index);
-	sprintf(result[j++], "%u", ring->page_pool->pages_state_hold_cnt);
+	sprintf(result[j++], "%u",
+		READ_ONCE(ring->page_pool->pages_state_hold_cnt));
 	sprintf(result[j++], "%u",
 		atomic_read(&ring->page_pool->pages_state_release_cnt));
 	sprintf(result[j++], "%u", ring->page_pool->p.pool_size);
-- 
2.33.0

