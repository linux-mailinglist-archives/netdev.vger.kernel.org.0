Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2436E8123
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 20:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjDSSUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 14:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbjDSSUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 14:20:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EA1558A
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 11:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C18763DC4
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70290C433D2;
        Wed, 19 Apr 2023 18:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681928408;
        bh=I9EuDuLUvZ9rf5DgWq2dm2vhzMJhAdph1Ce8l/FSvaQ=;
        h=From:To:Cc:Subject:Date:From;
        b=h8kqzAUWimsNWHZAMdGWgsmi2r08xNILQyGRzlNX8Ms6ey50jVFYd8EZSWvgeEFYE
         yDYl1LBZnoa3aWrIsUNI9fbiZ3/D91xcbUQ7MvJ4FYP2dsYL0mr2YSQlQHrmIB+z7r
         ryBFjOKvBEjynfRr9ha5wKe9vqjeFJzS06DnMCwduDhwjsqg05B/qVr19WiO591zEn
         ttFT4BTUhYADz3pEz5lAvCyeEWz77s2RDlH5PXmfM7EAqZdM2bP094YeqTJ7WuN2eZ
         +Op4GXfSHs0p+UXfm2YwErgRP66sz/yh+QtpnNbNw98nyoyz0w435J7Lnc7rhUVign
         xeIDJS3jcT4sg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>, hawk@kernel.org,
        ilias.apalodimas@linaro.org, tariqt@nvidia.com
Subject: [PATCH net-next] page_pool: unlink from napi during destroy
Date:   Wed, 19 Apr 2023 11:20:06 -0700
Message-Id: <20230419182006.719923-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper points out that we must prevent recycling into cache
after page_pool_destroy() is called, because page_pool_destroy()
is not synchronized with recycling (some pages may still be
outstanding when destroy() gets called).

I assumed this will not happen because NAPI can't be scheduled
if its page pool is being destroyed. But I missed the fact that
NAPI may get reused. For instance when user changes ring configuration
driver may allocate a new page pool, stop NAPI, swap, start NAPI,
and then destroy the old pool. The NAPI is running so old page
pool will think it can recycle to the cache, but the consumer
at that point is the destroy() path, not NAPI.

To avoid extra synchronization let the drivers do "unlinking"
during the "swap" stage while NAPI is indeed disabled.

Fixes: 8c48eea3adf3 ("page_pool: allow caching from safely localized NAPI")
Reported-by: Jesper Dangaard Brouer <jbrouer@redhat.com>
Link: https://lore.kernel.org/all/e8df2654-6a5b-3c92-489d-2fe5e444135f@redhat.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
bnxt does not do the live swap so no need to change it.
But let's export the API, anyway, I'm sure others will
need it. And knowing driver authors they will hack some
workaround into the driver rather than export the helper.

CC: hawk@kernel.org
CC: ilias.apalodimas@linaro.org
CC: tariqt@nvidia.com
---
 include/net/page_pool.h |  5 +++++
 net/core/page_pool.c    | 18 +++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 91b808dade82..c8ec2f34722b 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -247,6 +247,7 @@ struct page_pool *page_pool_create(const struct page_pool_params *params);
 struct xdp_mem_info;
 
 #ifdef CONFIG_PAGE_POOL
+void page_pool_unlink_napi(struct page_pool *pool);
 void page_pool_destroy(struct page_pool *pool);
 void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
 			   struct xdp_mem_info *mem);
@@ -254,6 +255,10 @@ void page_pool_release_page(struct page_pool *pool, struct page *page);
 void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 			     int count);
 #else
+static inline void page_pool_unlink_napi(struct page_pool *pool)
+{
+}
+
 static inline void page_pool_destroy(struct page_pool *pool)
 {
 }
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 2f6bf422ed30..caa30a5a5abc 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -838,6 +838,21 @@ void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
 	pool->xdp_mem_id = mem->id;
 }
 
+void page_pool_unlink_napi(struct page_pool *pool)
+{
+	if (!pool->p.napi)
+		return;
+
+	/* To avoid races with recycling and additional barriers make sure
+	 * pool and NAPI are unlinked when NAPI is disabled.
+	 */
+	WARN_ON(!test_bit(NAPI_STATE_SCHED, &pool->p.napi->state) ||
+		READ_ONCE(pool->p.napi->list_owner) != -1);
+
+	WRITE_ONCE(pool->p.napi, NULL);
+}
+EXPORT_SYMBOL(page_pool_unlink_napi);
+
 void page_pool_destroy(struct page_pool *pool)
 {
 	if (!pool)
@@ -846,6 +861,7 @@ void page_pool_destroy(struct page_pool *pool)
 	if (!page_pool_put(pool))
 		return;
 
+	page_pool_unlink_napi(pool);
 	page_pool_free_frag(pool);
 
 	if (!page_pool_release(pool))
@@ -899,7 +915,7 @@ bool page_pool_return_skb_page(struct page *page, bool napi_safe)
 	 * in the same context as the consumer would run, so there's
 	 * no possible race.
 	 */
-	napi = pp->p.napi;
+	napi = READ_ONCE(pp->p.napi);
 	allow_direct = napi_safe && napi &&
 		READ_ONCE(napi->list_owner) == smp_processor_id();
 
-- 
2.39.2

