Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9165441456A
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 11:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbhIVJol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 05:44:41 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:16281 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbhIVJoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 05:44:34 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HDtcT6G9hz8snm;
        Wed, 22 Sep 2021 17:42:17 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 22 Sep 2021 17:43:02 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 22 Sep 2021 17:43:02 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <jonathan.lemon@gmail.com>,
        <alobakin@pm.me>, <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
Subject: [PATCH net-next 6/7] skbuff: only use pp_magic identifier for a skb' head page
Date:   Wed, 22 Sep 2021 17:41:30 +0800
Message-ID: <20210922094131.15625-7-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210922094131.15625-1-linyunsheng@huawei.com>
References: <20210922094131.15625-1-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As pp_magic is used to identify pp page for a skb's frag page
in previous patch, so do the similar handling for the head
page of a skb too.

And it seems head to frag converting for a skb during GRO and
GSO processing does not need handling when using pp_magic to
identify pp page for a skb' head page and frag page, see
NAPI_GRO_FREE_STOLEN_HEAD for GRO in skb_gro_receive() and
skb_head_frag_to_page_desc() for GSO in skb_segment().

As pp_magic only exist in the head page of a compound page,
and the freeing of a head page for a skb is eventually operated
on the head page of a compound page for both pp and non-pp
page, so use virt_to_head_page() and __page_frag_cache_drain()
in skb_free_head() to avoid unnecessary virt_to_head_page()
calling in page_frag_free().

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/linux/skbuff.h | 15 ---------------
 net/core/skbuff.c      | 11 +++++++++--
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a2d3b6fe0c32..b77ee060b64d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4728,20 +4728,5 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
 }
 #endif
 
-static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
-{
-	struct page *page;
-
-	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
-		return false;
-
-	page = virt_to_head_page(data);
-	if (!page_pool_is_pp_page(page))
-		return false;
-
-	page_pool_return_skb_page(page);
-	return true;
-}
-
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index db8af3eff255..3718898da499 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -647,9 +647,16 @@ static void skb_free_head(struct sk_buff *skb)
 	unsigned char *head = skb->head;
 
 	if (skb->head_frag) {
-		if (skb_pp_recycle(skb, head))
+		struct page *page = virt_to_head_page(head);
+
+#ifdef CONFIG_PAGE_POOL
+		if (page_pool_is_pp_page(page)) {
+			page_pool_return_skb_page(page);
 			return;
-		skb_free_frag(head);
+		}
+#endif
+
+		__page_frag_cache_drain(page, 1);
 	} else {
 		kfree(head);
 	}
-- 
2.33.0

