Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE00A42787D
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 11:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244476AbhJIJlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 05:41:10 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13716 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbhJIJlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 05:41:05 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HRKjB4krKzWjdh;
        Sat,  9 Oct 2021 17:37:34 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 9 Oct 2021 17:39:06 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 9 Oct 2021 17:39:06 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <akpm@linux-foundation.org>,
        <hawk@kernel.org>, <ilias.apalodimas@linaro.org>,
        <peterz@infradead.org>, <yuzhao@google.com>, <jhubbard@nvidia.com>,
        <will@kernel.org>, <willy@infradead.org>, <jgg@ziepe.ca>,
        <mcroce@microsoft.com>, <willemb@google.com>,
        <cong.wang@bytedance.com>, <pabeni@redhat.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <memxor@gmail.com>, <vvs@virtuozzo.com>, <linux-mm@kvack.org>,
        <edumazet@google.com>, <alexander.duyck@gmail.com>,
        <dsahern@gmail.com>
Subject: [PATCH net-next -v5 3/4] mm: introduce __get_page() and __put_page()
Date:   Sat, 9 Oct 2021 17:37:23 +0800
Message-ID: <20211009093724.10539-4-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211009093724.10539-1-linyunsheng@huawei.com>
References: <20211009093724.10539-1-linyunsheng@huawei.com>
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

Introduce __get_page() and __put_page() to operate on the
base page or head of a compound page for the cases when a
page is known to be a base page or head of a compound page.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/linux/mm.h | 21 ++++++++++++++-------
 mm/swap.c          |  6 +++---
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 73a52aba448f..5683313c3e9d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -902,7 +902,7 @@ static inline struct page *virt_to_head_page(const void *x)
 	return compound_head(page);
 }
 
-void __put_page(struct page *page);
+void __put_single_or_compound_page(struct page *page);
 
 void put_pages_list(struct list_head *pages);
 
@@ -1203,9 +1203,8 @@ static inline bool is_pci_p2pdma_page(const struct page *page)
 #define page_ref_zero_or_close_to_overflow(page) \
 	((unsigned int) page_ref_count(page) + 127u <= 127u)
 
-static inline void get_page(struct page *page)
+static inline void __get_page(struct page *page)
 {
-	page = compound_head(page);
 	/*
 	 * Getting a normal page or the head of a compound page
 	 * requires to already have an elevated page->_refcount.
@@ -1214,6 +1213,11 @@ static inline void get_page(struct page *page)
 	page_ref_inc(page);
 }
 
+static inline void get_page(struct page *page)
+{
+	__get_page(compound_head(page));
+}
+
 bool __must_check try_grab_page(struct page *page, unsigned int flags);
 struct page *try_grab_compound_head(struct page *page, int refs,
 				    unsigned int flags);
@@ -1228,10 +1232,8 @@ static inline __must_check bool try_get_page(struct page *page)
 	return true;
 }
 
-static inline void put_page(struct page *page)
+static inline void __put_page(struct page *page)
 {
-	page = compound_head(page);
-
 	/*
 	 * For devmap managed pages we need to catch refcount transition from
 	 * 2 to 1, when refcount reach one it means the page is free and we
@@ -1244,7 +1246,12 @@ static inline void put_page(struct page *page)
 	}
 
 	if (put_page_testzero(page))
-		__put_page(page);
+		__put_single_or_compound_page(page);
+}
+
+static inline void put_page(struct page *page)
+{
+	__put_page(compound_head(page));
 }
 
 /*
diff --git a/mm/swap.c b/mm/swap.c
index af3cad4e5378..565cbde1caea 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -111,7 +111,7 @@ static void __put_compound_page(struct page *page)
 	destroy_compound_page(page);
 }
 
-void __put_page(struct page *page)
+void __put_single_or_compound_page(struct page *page)
 {
 	if (is_zone_device_page(page)) {
 		put_dev_pagemap(page->pgmap);
@@ -128,7 +128,7 @@ void __put_page(struct page *page)
 	else
 		__put_single_page(page);
 }
-EXPORT_SYMBOL(__put_page);
+EXPORT_SYMBOL(__put_single_or_compound_page);
 
 /**
  * put_pages_list() - release a list of pages
@@ -1153,7 +1153,7 @@ void put_devmap_managed_page(struct page *page)
 	if (count == 1)
 		free_devmap_managed_page(page);
 	else if (!count)
-		__put_page(page);
+		__put_single_or_compound_page(page);
 }
 EXPORT_SYMBOL(put_devmap_managed_page);
 #endif
-- 
2.33.0

