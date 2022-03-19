Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92554DE54B
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 04:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241894AbiCSDQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 23:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241301AbiCSDQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 23:16:44 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8802521BC4D;
        Fri, 18 Mar 2022 20:15:24 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KL5YW27kVzCqk5;
        Sat, 19 Mar 2022 11:13:19 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 19 Mar 2022 11:15:22 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Sat, 19 Mar
 2022 11:15:22 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
CC:     <davem@davemloft.net>, <stephan@gerhold.net>
Subject: [PATCH -next] net: wwan: qcom_bam_dmux: fix wrong pointer passed to IS_ERR()
Date:   Sat, 19 Mar 2022 11:24:50 +0800
Message-ID: <20220319032450.3288224-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should check dmux->tx after calling dma_request_chan().

Fixes: 21a0ffd9b38c ("net: wwan: Add Qualcomm BAM-DMUX WWAN network driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/wwan/qcom_bam_dmux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/qcom_bam_dmux.c b/drivers/net/wwan/qcom_bam_dmux.c
index 5dfa2eba6014..17d46f4d2913 100644
--- a/drivers/net/wwan/qcom_bam_dmux.c
+++ b/drivers/net/wwan/qcom_bam_dmux.c
@@ -755,7 +755,7 @@ static int __maybe_unused bam_dmux_runtime_resume(struct device *dev)
 		return 0;
 
 	dmux->tx = dma_request_chan(dev, "tx");
-	if (IS_ERR(dmux->rx)) {
+	if (IS_ERR(dmux->tx)) {
 		dev_err(dev, "Failed to request TX DMA channel: %pe\n", dmux->tx);
 		dmux->tx = NULL;
 		bam_dmux_runtime_suspend(dev);
-- 
2.25.1

