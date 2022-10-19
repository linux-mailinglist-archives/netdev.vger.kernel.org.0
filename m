Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482FC604293
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 13:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbiJSLHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 07:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiJSLGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 07:06:55 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DB6175792
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 03:35:48 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Msm8j4FTVzpVYt;
        Wed, 19 Oct 2022 17:46:45 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 19 Oct
 2022 17:50:03 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <keescook@chromium.org>, <gustavoars@kernel.org>,
        <gregkh@linuxfoundation.org>, <ast@kernel.org>,
        <peter.chen@kernel.org>, <bin.chen@corigine.com>,
        <luobin9@huawei.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net,v2 3/4] net: hinic: fix the issue of CMDQ memory leaks
Date:   Wed, 19 Oct 2022 17:57:53 +0800
Message-ID: <20221019095754.189119-4-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221019095754.189119-1-shaozhengchao@huawei.com>
References: <20221019095754.189119-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When hinic_set_cmdq_depth() fails in hinic_init_cmdqs(), the cmdq memory is
not released correctly. Fix it.

Fixes: 72ef908bb3ff ("hinic: add three net_device_ops of vf")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index 78190e88cd75..d39eec9c62bf 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -924,7 +924,7 @@ int hinic_init_cmdqs(struct hinic_cmdqs *cmdqs, struct hinic_hwif *hwif,
 
 err_set_cmdq_depth:
 	hinic_ceq_unregister_cb(&func_to_io->ceqs, HINIC_CEQ_CMDQ);
-
+	free_cmdq(&cmdqs->cmdq[HINIC_CMDQ_SYNC]);
 err_cmdq_ctxt:
 	hinic_wqs_cmdq_free(&cmdqs->cmdq_pages, cmdqs->saved_wqs,
 			    HINIC_MAX_CMDQ_TYPES);
-- 
2.17.1

