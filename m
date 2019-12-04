Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB48112935
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 11:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfLDKWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 05:22:22 -0500
Received: from mx58.baidu.com ([61.135.168.58]:29179 "EHLO
        tc-sys-mailedm02.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726899AbfLDKWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 05:22:22 -0500
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Dec 2019 05:22:20 EST
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm02.tc.baidu.com (Postfix) with ESMTP id 648AA11C0062;
        Wed,  4 Dec 2019 18:14:25 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, saeedm@mellanox.com
Subject: [PATCH] page_pool: mark unbound node page as reusable pages
Date:   Wed,  4 Dec 2019 18:14:25 +0800
Message-Id: <1575454465-15386-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

some drivers uses page pool, but not require to allocate
page from bound node, so pool.p.nid is NUMA_NO_NODE, and
this fixed patch will block this kind of driver to
recycle

Fixes: d5394610b1ba ("page_pool: Don't recycle non-reusable pages")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
---
 net/core/page_pool.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index a6aefe989043..4054db683178 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -317,7 +317,9 @@ static bool __page_pool_recycle_direct(struct page *page,
  */
 static bool pool_page_reusable(struct page_pool *pool, struct page *page)
 {
-	return !page_is_pfmemalloc(page) && page_to_nid(page) == pool->p.nid;
+	return !page_is_pfmemalloc(page) &&
+		(page_to_nid(page) == pool->p.nid ||
+		 pool->p.nid == NUMA_NO_NODE);
 }
 
 void __page_pool_put_page(struct page_pool *pool, struct page *page,
-- 
2.16.2

