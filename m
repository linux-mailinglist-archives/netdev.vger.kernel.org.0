Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABC25EC0CD
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 13:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiI0LPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 07:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiI0LPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 07:15:02 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3EC4BA56;
        Tue, 27 Sep 2022 04:14:58 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4McH5G0hhVzpSxj;
        Tue, 27 Sep 2022 19:12:02 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 19:14:57 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 19:14:56 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <shenjian15@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 4/4] net: hns3: delete unnecessary vf value judgement when get vport id
Date:   Tue, 27 Sep 2022 19:12:05 +0800
Message-ID: <20220927111205.18060-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220927111205.18060-1-huangguangbin2@huawei.com>
References: <20220927111205.18060-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hdev->vport->vport_id is equal to hdev->vport[0].vport_id, so
delete unnecessary vf value judgement.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6962a9d69cf8..b566c0d782ad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6487,8 +6487,6 @@ static bool hclge_is_cls_flower_active(struct hnae3_handle *handle)
 static int hclge_fd_parse_ring_cookie(struct hclge_dev *hdev, u64 ring_cookie,
 				      u16 *vport_id, u8 *action, u16 *queue_id)
 {
-	struct hclge_vport *vport = hdev->vport;
-
 	if (ring_cookie == RX_CLS_FLOW_DISC) {
 		*action = HCLGE_FD_ACTION_DROP_PACKET;
 	} else {
@@ -6506,7 +6504,7 @@ static int hclge_fd_parse_ring_cookie(struct hclge_dev *hdev, u64 ring_cookie,
 			return -EINVAL;
 		}
 
-		*vport_id = vf ? hdev->vport[vf].vport_id : vport->vport_id;
+		*vport_id = hdev->vport[vf].vport_id;
 		tqps = hdev->vport[vf].nic.kinfo.num_tqps;
 
 		if (ring >= tqps) {
-- 
2.33.0

