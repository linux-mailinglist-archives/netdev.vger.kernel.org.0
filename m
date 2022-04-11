Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CA64FBE53
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346931AbiDKOIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347028AbiDKOHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:07:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49DF140C3
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:05:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4872D61252
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 14:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E043FC385A3;
        Mon, 11 Apr 2022 14:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649685938;
        bh=bOX7E8HOk39Z6/SfGfBHsDGQ4yxFFM0x4VAfCckNTh4=;
        h=From:To:Cc:Subject:Date:From;
        b=JY8BobDPGa4itZu9DZYdFoNmKp/PEVZPBgVx8YYGh2sYnoT9Aglna33yiA5Hy7XnQ
         gX2OaVa6kWLVfFs4QZ1b3tcVc5qVCq8KxoozcBSpKwRhtJpe4l1swEK75ZdP+QBNr3
         NEHrIb3N1zDOT5rqcBCIi3IgC5MhjF5Q7Dngt3vlEhzU3HvUw6TWcyzLkbgi45scaA
         aJcaIWV3Pm07Ncm+KjL+Y/SMc4qgGjdm7wN+hZzCPSGHUakICuzAQAkQFF6aRawVn5
         Ti4MdV3DUhdSu4ysgthdesxih2+rcBX09d7OsOxKh1FSMj602LKUU9OHCWDjcXhesQ
         pBd/qGnWQHuPw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, ilias.apalodimas@linaro.org, jbrouer@redhat.com,
        jdamato@fastly.com
Subject: [PATCH v2 net-next] page_pool: Add recycle stats to page_pool_put_page_bulk
Date:   Mon, 11 Apr 2022 16:05:26 +0200
Message-Id: <3712178b51c007cfaed910ea80e68f00c916b1fa.1649685634.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
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

Add missing recycle stats to page_pool_put_page_bulk routine.

Reviewed-by: Joe Damato <jdamato@fastly.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- rebase on net-next
---
 net/core/page_pool.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 1943c0f0307d..4af55d28ffa3 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -36,6 +36,12 @@
 		this_cpu_inc(s->__stat);						\
 	} while (0)
 
+#define recycle_stat_add(pool, __stat, val)						\
+	do {										\
+		struct page_pool_recycle_stats __percpu *s = pool->recycle_stats;	\
+		this_cpu_add(s->__stat, val);						\
+	} while (0)
+
 bool page_pool_get_stats(struct page_pool *pool,
 			 struct page_pool_stats *stats)
 {
@@ -63,6 +69,7 @@ EXPORT_SYMBOL(page_pool_get_stats);
 #else
 #define alloc_stat_inc(pool, __stat)
 #define recycle_stat_inc(pool, __stat)
+#define recycle_stat_add(pool, __stat, val)
 #endif
 
 static int page_pool_init(struct page_pool *pool,
@@ -566,9 +573,13 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 	/* Bulk producer into ptr_ring page_pool cache */
 	page_pool_ring_lock(pool);
 	for (i = 0; i < bulk_len; i++) {
-		if (__ptr_ring_produce(&pool->ring, data[i]))
-			break; /* ring full */
+		if (__ptr_ring_produce(&pool->ring, data[i])) {
+			/* ring full */
+			recycle_stat_inc(pool, ring_full);
+			break;
+		}
 	}
+	recycle_stat_add(pool, ring, i);
 	page_pool_ring_unlock(pool);
 
 	/* Hopefully all pages was return into ptr_ring */
-- 
2.35.1

