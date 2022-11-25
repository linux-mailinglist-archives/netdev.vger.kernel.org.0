Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCC063821A
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 02:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiKYB3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 20:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKYB3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 20:29:42 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63C231C
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 17:29:41 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NJHJG02K4zJnfJ;
        Fri, 25 Nov 2022 09:26:21 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 25 Nov
 2022 09:29:39 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <tchornyi@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <yevhen.orlov@plvision.eu>, <oleksandr.mazur@plvision.eu>,
        <netdev@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH] net: marvell: prestera: Fix a NULL vs IS_ERR() check in some functions
Date:   Fri, 25 Nov 2022 09:27:51 +0800
Message-ID: <20221125012751.23249-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rhashtable_lookup_fast() returns NULL when failed instead of error
pointer.

Fixes: 396b80cb5cc8 ("net: marvell: prestera: Add neighbour cache accounting")
Fixes: 0a23ae237171 ("net: marvell: prestera: Add router nexthops ABI")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_router.c    | 2 +-
 drivers/net/ethernet/marvell/prestera/prestera_router_hw.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 4046be0e86ff..a9a1028cb17b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -457,7 +457,7 @@ prestera_kern_neigh_cache_find(struct prestera_switch *sw,
 	n_cache =
 	 rhashtable_lookup_fast(&sw->router->kern_neigh_cache_ht, key,
 				__prestera_kern_neigh_cache_ht_params);
-	return IS_ERR(n_cache) ? NULL : n_cache;
+	return n_cache;
 }
 
 static void
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
index aa080dc57ff0..02faaea2aefa 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
@@ -330,7 +330,7 @@ prestera_nh_neigh_find(struct prestera_switch *sw,
 
 	nh_neigh = rhashtable_lookup_fast(&sw->router->nh_neigh_ht,
 					  key, __prestera_nh_neigh_ht_params);
-	return IS_ERR(nh_neigh) ? NULL : nh_neigh;
+	return nh_neigh;
 }
 
 struct prestera_nh_neigh *
@@ -484,7 +484,7 @@ __prestera_nexthop_group_find(struct prestera_switch *sw,
 
 	nh_grp = rhashtable_lookup_fast(&sw->router->nexthop_group_ht,
 					key, __prestera_nexthop_group_ht_params);
-	return IS_ERR(nh_grp) ? NULL : nh_grp;
+	return nh_grp;
 }
 
 static struct prestera_nexthop_group *
-- 
2.17.1

