Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98C2566323
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 08:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiGEG02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 02:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiGEG0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 02:26:24 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB25A1AB;
        Mon,  4 Jul 2022 23:26:23 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=mqaio@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VIQzUB7_1657002379;
Received: from localhost(mailfrom:mqaio@linux.alibaba.com fp:SMTPD_---0VIQzUB7_1657002379)
          by smtp.aliyun-inc.com;
          Tue, 05 Jul 2022 14:26:19 +0800
From:   Qiao Ma <mqaio@linux.alibaba.com>
To:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, gustavoars@kernel.org, cai.huoqing@linux.dev,
        aviad.krawczyk@huawei.com, zhaochen6@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 3/3] net: hinic: fix bug that u64_stats_sync is not initialized
Date:   Tue,  5 Jul 2022 14:26:01 +0800
Message-Id: <7723937608e9f23b2a904615ae447beaf9f28586.1657001998.git.mqaio@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <0146c84b4161172e7a3d407a940593aa723496ea.1657001998.git.mqaio@linux.alibaba.com>
References: <cover.1657001998.git.mqaio@linux.alibaba.com>
 <8cadab244a67bac6b69324de9264f4db61680896.1657001998.git.mqaio@linux.alibaba.com>
 <0146c84b4161172e7a3d407a940593aa723496ea.1657001998.git.mqaio@linux.alibaba.com>
In-Reply-To: <cover.1657001998.git.mqaio@linux.alibaba.com>
References: <cover.1657001998.git.mqaio@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In get_drv_queue_stats(), the local variable {txq|rxq}_stats
should be initialized first before calling into
hinic_{rxq|txq}_get_stats(), this patch fixes it.

Fixes: edd384f682cc ("net-next/hinic: Add ethtool and stats")
Signed-off-by: Qiao Ma <mqaio@linux.alibaba.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index 93192f58ac88..75e9711bd2ba 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -1371,6 +1371,9 @@ static void get_drv_queue_stats(struct hinic_dev *nic_dev, u64 *data)
 	u16 i = 0, j = 0, qid = 0;
 	char *p;
 
+	u64_stats_init(&txq_stats.syncp);
+	u64_stats_init(&rxq_stats.syncp);
+
 	for (qid = 0; qid < nic_dev->num_qps; qid++) {
 		if (!nic_dev->txqs)
 			break;
-- 
1.8.3.1

