Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C135340AD30
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhINMOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:14:03 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15413 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbhINMOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:14:00 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H82F019GZzR8W1;
        Tue, 14 Sep 2021 20:08:36 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 20:12:39 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 20:12:39 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <jonathan.lemon@gmail.com>,
        <alobakin@pm.me>, <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
Subject: [PATCH net-next v2 2/3] pool_pool: avoid calling compound_head() for skb frag page
Date:   Tue, 14 Sep 2021 20:11:13 +0800
Message-ID: <20210914121114.28559-3-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914121114.28559-1-linyunsheng@huawei.com>
References: <20210914121114.28559-1-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the page for a skb frag is always a head page, so make
sure skb_pp_recycle() passes a head page to avoid calling
compound_head() for skb frag page case.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/linux/skbuff.h | 2 +-
 net/core/page_pool.c   | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6bdb0db3e825..35eebc2310a5 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4722,7 +4722,7 @@ static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
 {
 	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
 		return false;
-	return page_pool_return_skb_page(virt_to_page(data));
+	return page_pool_return_skb_page(virt_to_head_page(data));
 }
 
 #endif	/* __KERNEL__ */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ba9f14deacf4..09d7b8614ef5 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -740,8 +740,6 @@ bool page_pool_return_skb_page(struct page *page)
 {
 	struct page_pool *pp;
 
-	page = compound_head(page);
-
 	/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
 	 * in order to preserve any existing bits, such as bit 0 for the
 	 * head page of compound page and bit 1 for pfmemalloc page, so
-- 
2.33.0

