Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104986206FC
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 03:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiKHCtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 21:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233262AbiKHCtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 21:49:21 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7017F13D35
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 18:49:20 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N5ssb55s5zpWJr;
        Tue,  8 Nov 2022 10:45:39 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 10:49:18 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <tchornyi@marvell.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <vadym.kochan@plvision.eu>, <andrii.savka@plvision.eu>,
        <oleksandr.mazur@plvision.eu>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net] net: marvell: prestera: fix memory leak in prestera_rxtx_switch_init()
Date:   Tue, 8 Nov 2022 10:56:07 +0800
Message-ID: <20221108025607.338450-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When prestera_sdma_switch_init() failed, the memory pointed to by
sw->rxtx isn't released. Fix it. Only be compiled, not be tested.

Fixes: 501ef3066c89 ("net: marvell: prestera: Add driver for Prestera family ASIC devices")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
index 42ee963e9f75..9277a8fd1339 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
@@ -776,6 +776,7 @@ static netdev_tx_t prestera_sdma_xmit(struct prestera_sdma *sdma,
 int prestera_rxtx_switch_init(struct prestera_switch *sw)
 {
 	struct prestera_rxtx *rxtx;
+	int err;
 
 	rxtx = kzalloc(sizeof(*rxtx), GFP_KERNEL);
 	if (!rxtx)
@@ -783,7 +784,11 @@ int prestera_rxtx_switch_init(struct prestera_switch *sw)
 
 	sw->rxtx = rxtx;
 
-	return prestera_sdma_switch_init(sw);
+	err = prestera_sdma_switch_init(sw);
+	if (err)
+		kfree(rxtx);
+
+	return err;
 }
 
 void prestera_rxtx_switch_fini(struct prestera_switch *sw)
-- 
2.17.1

