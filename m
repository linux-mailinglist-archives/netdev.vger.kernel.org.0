Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95F73F5A73
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 11:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbhHXJIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 05:08:48 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:18031 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbhHXJIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 05:08:44 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gv37s2D9Tzbdyp;
        Tue, 24 Aug 2021 17:04:09 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 24 Aug 2021 17:07:58 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 24 Aug 2021 17:07:58 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <hawk@kernel.org>, <ilias.apalodimas@linaro.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>
Subject: [PATCH net-next v3] page_pool: use relaxed atomic for release side accounting
Date:   Tue, 24 Aug 2021 17:06:49 +0800
Message-ID: <1629796009-11010-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to synchronize the account updating, so
use the relaxed atomic to avoid some memory barrier in the
data path.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
V3: Drop patch 2.
V2: Remove unnecessary unliky() mark as pointed out by
    Heiner.
---
 net/core/page_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index e140905..1a69784 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -370,7 +370,7 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
 	/* This may be the last page returned, releasing the pool, so
 	 * it is not safe to reference pool afterwards.
 	 */
-	count = atomic_inc_return(&pool->pages_state_release_cnt);
+	count = atomic_inc_return_relaxed(&pool->pages_state_release_cnt);
 	trace_page_pool_state_release(pool, page, count);
 }
 EXPORT_SYMBOL(page_pool_release_page);
-- 
2.7.4

