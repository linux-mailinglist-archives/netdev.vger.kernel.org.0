Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4253F640575
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 12:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiLBLEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 06:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiLBLEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 06:04:37 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5600BC5AD;
        Fri,  2 Dec 2022 03:04:35 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NNqnL3QTyzRpvK;
        Fri,  2 Dec 2022 19:03:50 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 19:04:33 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2] octeontx2-pf: Fix potential memory leak in otx2_init_tc()
Date:   Fri, 2 Dec 2022 19:04:30 +0800
Message-ID: <20221202110430.1472991-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In otx2_init_tc(), if rhashtable_init() failed, it does not free
tc->tc_entries_bitmap which is allocated in otx2_tc_alloc_ent_bitmap().

Fixes: 2e2a8126ffac ("octeontx2-pf: Unify flow management variables")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
v2:
  - Remove patch 2 which is not a problem, see the following link:
    https://www.spinics.net/lists/netdev/msg864159.html
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index e64318c110fd..6a01ab1a6e6f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -1134,7 +1134,12 @@ int otx2_init_tc(struct otx2_nic *nic)
 		return err;
 
 	tc->flow_ht_params = tc_flow_ht_params;
-	return rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
+	err = rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
+	if (err) {
+		kfree(tc->tc_entries_bitmap);
+		tc->tc_entries_bitmap = NULL;
+	}
+	return err;
 }
 EXPORT_SYMBOL(otx2_init_tc);
 
-- 
2.25.1

