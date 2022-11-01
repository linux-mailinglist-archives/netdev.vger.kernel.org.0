Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD99161453A
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 08:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiKAHsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 03:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiKAHsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 03:48:22 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9CF1D9;
        Tue,  1 Nov 2022 00:48:21 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N1hvd0nVGzHvVw;
        Tue,  1 Nov 2022 15:47:56 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 15:48:05 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 15:48:04 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <shenjian15@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net] net: hns3: fix get wrong value of function hclge_get_dscp_prio()
Date:   Tue, 1 Nov 2022 15:48:38 +0800
Message-ID: <20221101074838.53834-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the argument struct hnae3_handle *h of function hclge_get_dscp_prio()
can be other client registered in hnae3 layer, we need to transform it
into hnae3_handle of local nic client to get right dscp settings for
other clients.

Fixes: dfea275e06c2 ("net: hns3: optimize converting dscp to priority process of hns3_nic_select_queue()")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6962a9d69cf8..987271da6e9b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -12984,14 +12984,16 @@ static void hclge_clean_vport_config(struct hnae3_ae_dev *ae_dev, int num_vfs)
 static int hclge_get_dscp_prio(struct hnae3_handle *h, u8 dscp, u8 *tc_mode,
 			       u8 *priority)
 {
+	struct hclge_vport *vport = hclge_get_vport(h);
+
 	if (dscp >= HNAE3_MAX_DSCP)
 		return -EINVAL;
 
 	if (tc_mode)
-		*tc_mode = h->kinfo.tc_map_mode;
+		*tc_mode = vport->nic.kinfo.tc_map_mode;
 	if (priority)
-		*priority = h->kinfo.dscp_prio[dscp] == HNAE3_PRIO_ID_INVALID ? 0 :
-			    h->kinfo.dscp_prio[dscp];
+		*priority = vport->nic.kinfo.dscp_prio[dscp] == HNAE3_PRIO_ID_INVALID ? 0 :
+			    vport->nic.kinfo.dscp_prio[dscp];
 
 	return 0;
 }
-- 
2.33.0

