Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8F8114E33
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 10:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfLFJdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 04:33:00 -0500
Received: from mx134-tc.baidu.com ([61.135.168.134]:28261 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726065AbfLFJdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 04:33:00 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id D02D82040041;
        Fri,  6 Dec 2019 17:32:47 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, saeedm@mellanox.com, linyunsheng@huawei.com
Subject: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE condition
Date:   Fri,  6 Dec 2019 17:32:47 +0800
Message-Id: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

some drivers uses page pool, but not require to allocate
pages from bound node, or simply assign pool.p.nid to
NUMA_NO_NODE, and the commit d5394610b1ba ("page_pool:
Don't recycle non-reusable pages") will block this kind
of driver to recycle

so take page as reusable when page belongs to current
memory node if nid is NUMA_NO_NODE

v1-->v2: add check with numa_mem_id from Yunsheng

Fixes: d5394610b1ba ("page_pool: Don't recycle non-reusable pages")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Suggested-by: Yunsheng Lin <linyunsheng@huawei.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
---
 net/core/page_pool.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index a6aefe989043..3c8b51ccd1c1 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -312,12 +312,17 @@ static bool __page_pool_recycle_direct(struct page *page,
 /* page is NOT reusable when:
  * 1) allocated when system is under some pressure. (page_is_pfmemalloc)
  * 2) belongs to a different NUMA node than pool->p.nid.
+ * 3) belongs to a different memory node than current context
+ * if pool->p.nid is NUMA_NO_NODE
  *
  * To update pool->p.nid users must call page_pool_update_nid.
  */
 static bool pool_page_reusable(struct page_pool *pool, struct page *page)
 {
-	return !page_is_pfmemalloc(page) && page_to_nid(page) == pool->p.nid;
+	return !page_is_pfmemalloc(page) &&
+		(page_to_nid(page) == pool->p.nid ||
+		(pool->p.nid == NUMA_NO_NODE &&
+		page_to_nid(page) == numa_mem_id()));
 }
 
 void __page_pool_put_page(struct page_pool *pool, struct page *page,
-- 
2.16.2

