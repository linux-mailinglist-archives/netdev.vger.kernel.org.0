Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357366EE426
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 16:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbjDYOqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 10:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbjDYOqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 10:46:03 -0400
Received: from out-41.mta1.migadu.com (out-41.mta1.migadu.com [IPv6:2001:41d0:203:375::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91781BF4
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 07:46:01 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682433959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=M+Kciq4hJIDYLEDnU0UIcGmZY1J3YxtbOm5Cg6g5pVg=;
        b=LFw5nBu2KadgbWyvmbsRvjD/6sieiKQWyAp/6dVO1crcGazdwQhfgdXbhOZk1yTjMbgyaG
        soH4NCIHENOdI3mja/k8Huvvl4hHtlOEtbyXjsbst+WYb4FHE+GB4wJNbVdxd5urcBs6ej
        61RhANkSFbxulmIRXoVcDrUEEDyWojY=
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     cai.huoqing@linux.dev
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] netdevsim: fib: Make use of rhashtable_iter
Date:   Tue, 25 Apr 2023 22:45:55 +0800
Message-Id: <20230425144556.98799-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        TO_EQ_FM_DIRECT_MX,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Iterating 'fib_rt_ht' by rhashtable_walk_next and rhashtable_iter directly
instead of using list_for_each, because each entry of fib_rt_ht can be
found by rhashtable API. And remove fib_rt_list.

Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
---
 drivers/net/netdevsim/fib.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index a1f91ff8ec56..1a50c8e14665 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -48,7 +48,6 @@ struct nsim_fib_data {
 	struct nsim_per_fib_data ipv6;
 	struct nsim_fib_entry nexthops;
 	struct rhashtable fib_rt_ht;
-	struct list_head fib_rt_list;
 	struct mutex fib_lock; /* Protects FIB HT and list */
 	struct notifier_block nexthop_nb;
 	struct rhashtable nexthop_ht;
@@ -75,7 +74,6 @@ struct nsim_fib_rt_key {
 struct nsim_fib_rt {
 	struct nsim_fib_rt_key key;
 	struct rhash_head ht_node;
-	struct list_head list;	/* Member of fib_rt_list */
 };
 
 struct nsim_fib4_rt {
@@ -247,12 +245,6 @@ static void nsim_fib_rt_init(struct nsim_fib_data *data,
 	fib_rt->key.prefix_len = prefix_len;
 	fib_rt->key.family = family;
 	fib_rt->key.tb_id = tb_id;
-	list_add(&fib_rt->list, &data->fib_rt_list);
-}
-
-static void nsim_fib_rt_fini(struct nsim_fib_rt *fib_rt)
-{
-	list_del(&fib_rt->list);
 }
 
 static struct nsim_fib_rt *nsim_fib_rt_lookup(struct rhashtable *fib_rt_ht,
@@ -295,7 +287,6 @@ nsim_fib4_rt_create(struct nsim_fib_data *data,
 static void nsim_fib4_rt_destroy(struct nsim_fib4_rt *fib4_rt)
 {
 	fib_info_put(fib4_rt->fi);
-	nsim_fib_rt_fini(&fib4_rt->common);
 	kfree(fib4_rt);
 }
 
@@ -570,7 +561,6 @@ nsim_fib6_rt_create(struct nsim_fib_data *data,
 	for (i--; i >= 0; i--) {
 		nsim_fib6_rt_nh_del(fib6_rt, rt_arr[i]);
 	}
-	nsim_fib_rt_fini(&fib6_rt->common);
 	kfree(fib6_rt);
 	return ERR_PTR(err);
 }
@@ -582,7 +572,6 @@ static void nsim_fib6_rt_destroy(struct nsim_fib6_rt *fib6_rt)
 	list_for_each_entry_safe(iter, tmp, &fib6_rt->nh_list, list)
 		nsim_fib6_rt_nh_del(fib6_rt, iter->rt);
 	WARN_ON_ONCE(!list_empty(&fib6_rt->nh_list));
-	nsim_fib_rt_fini(&fib6_rt->common);
 	kfree(fib6_rt);
 }
 
@@ -1091,7 +1080,9 @@ static void nsim_fib_dump_inconsistent(struct notifier_block *nb)
 {
 	struct nsim_fib_data *data = container_of(nb, struct nsim_fib_data,
 						  fib_nb);
-	struct nsim_fib_rt *fib_rt, *fib_rt_tmp;
+	struct nsim_fib_rt *fib_rt;
+	struct rhashtable_iter hti;
+	struct rhash_head *pos;
 
 	/* Flush the work to make sure there is no race with notifications. */
 	flush_work(&data->fib_event_work);
@@ -1099,9 +1090,12 @@ static void nsim_fib_dump_inconsistent(struct notifier_block *nb)
 	/* The notifier block is still not registered, so we do not need to
 	 * take any locks here.
 	 */
-	list_for_each_entry_safe(fib_rt, fib_rt_tmp, &data->fib_rt_list, list) {
-		rhashtable_remove_fast(&data->fib_rt_ht, &fib_rt->ht_node,
+	rhashtable_walk_enter(&data->fib_rt_ht, &hti);
+	rhashtable_walk_start(&hti);
+	while ((pos = rhashtable_walk_next(&hti))) {
+		rhashtable_remove_fast(&data->fib_rt_ht, hti.p,
 				       nsim_fib_rt_ht_params);
+		fib_rt = rhashtable_walk_peek(&hti);
 		nsim_fib_rt_free(fib_rt, data);
 	}
 
@@ -1501,17 +1495,24 @@ static void nsim_fib_flush_work(struct work_struct *work)
 {
 	struct nsim_fib_data *data = container_of(work, struct nsim_fib_data,
 						  fib_flush_work);
-	struct nsim_fib_rt *fib_rt, *fib_rt_tmp;
+	struct nsim_fib_rt *fib_rt;
+	struct rhashtable_iter hti;
+	struct rhash_head *pos;
+
 
 	/* Process pending work. */
 	flush_work(&data->fib_event_work);
 
 	mutex_lock(&data->fib_lock);
-	list_for_each_entry_safe(fib_rt, fib_rt_tmp, &data->fib_rt_list, list) {
-		rhashtable_remove_fast(&data->fib_rt_ht, &fib_rt->ht_node,
+	rhashtable_walk_enter(&data->fib_rt_ht, &hti);
+	rhashtable_walk_start(&hti);
+	while ((pos = rhashtable_walk_next(&hti))) {
+		rhashtable_remove_fast(&data->fib_rt_ht, hti.p,
 				       nsim_fib_rt_ht_params);
+		fib_rt = rhashtable_walk_peek(&hti);
 		nsim_fib_rt_free(fib_rt, data);
 	}
+
 	mutex_unlock(&data->fib_lock);
 }
 
@@ -1571,7 +1572,6 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 		goto err_debugfs_exit;
 
 	mutex_init(&data->fib_lock);
-	INIT_LIST_HEAD(&data->fib_rt_list);
 	err = rhashtable_init(&data->fib_rt_ht, &nsim_fib_rt_ht_params);
 	if (err)
 		goto err_rhashtable_nexthop_destroy;
@@ -1661,7 +1661,6 @@ void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data)
 	rhashtable_free_and_destroy(&data->nexthop_ht, nsim_nexthop_free,
 				    data);
 	WARN_ON_ONCE(!list_empty(&data->fib_event_queue));
-	WARN_ON_ONCE(!list_empty(&data->fib_rt_list));
 	mutex_destroy(&data->fib_lock);
 	mutex_destroy(&data->nh_lock);
 	nsim_fib_debugfs_exit(data);
-- 
2.34.1

