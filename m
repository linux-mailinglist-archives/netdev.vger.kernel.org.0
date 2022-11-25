Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FD26384A5
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 08:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiKYHph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 02:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKYHpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 02:45:36 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67622EF07;
        Thu, 24 Nov 2022 23:45:35 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NJRdz5jMPzJnwM;
        Fri, 25 Nov 2022 15:42:15 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 15:45:33 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: [PATCH net 1/2] octeontx2-pf: Fix potential memory leak in otx2_init_tc()
Date:   Fri, 25 Nov 2022 15:45:30 +0800
Message-ID: <ec5a566e880cb2f2127db21377d004864d90799c.1669361183.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1669361183.git.william.xuanziyang@huawei.com>
References: <cover.1669361183.git.william.xuanziyang@huawei.com>
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

