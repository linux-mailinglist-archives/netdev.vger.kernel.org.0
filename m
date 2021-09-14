Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5FA40A4E3
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 05:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239185AbhINDvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 23:51:20 -0400
Received: from out0.migadu.com ([94.23.1.103]:64629 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238424AbhINDvT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 23:51:19 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1631591401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=d3Ti+xU/m2mhoHM45+Aq1RhmFTGFJaIipaoBsexQmRI=;
        b=aoQ7gIpYbZWUFbq+zxhOTFRKPhFnjJ9qoeC+psB6ErTHfuKQZUOHSnrRU3+qHh0nRoxiFG
        IyGbbAjbPYeIXZF923OwZ44zyRxtje0Yu9PHQjOhlMedL3ygnWvJNFEBW+Agex1f5iZxrz
        ge28Q4NOI17iPOypwDl4CQw5bTLdws8=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>,
        kernel test robot <oliver.sang@intel.com>
Subject: [PATCH net-next v2] skbuff: inline page_frag_alloc_align()
Date:   Tue, 14 Sep 2021 11:49:35 +0800
Message-Id: <20210914034935.19137-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The __alloc_frag_align() is short, and only called by two functions,
so inline page_frag_alloc_align() for reduce the overhead of calls.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/skbuff.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2170bea2c7de..7c2ab27fcbf9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -134,34 +134,31 @@ struct napi_alloc_cache {
 static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
 static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
 
-static void *__alloc_frag_align(unsigned int fragsz, gfp_t gfp_mask,
-				unsigned int align_mask)
+void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
 {
 	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
 
-	return page_frag_alloc_align(&nc->page, fragsz, gfp_mask, align_mask);
-}
-
-void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
-{
 	fragsz = SKB_DATA_ALIGN(fragsz);
 
-	return __alloc_frag_align(fragsz, GFP_ATOMIC, align_mask);
+	return page_frag_alloc_align(&nc->page, fragsz, GFP_ATOMIC, align_mask);
 }
 EXPORT_SYMBOL(__napi_alloc_frag_align);
 
 void *__netdev_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
 {
-	struct page_frag_cache *nc;
 	void *data;
 
 	fragsz = SKB_DATA_ALIGN(fragsz);
 	if (in_hardirq() || irqs_disabled()) {
-		nc = this_cpu_ptr(&netdev_alloc_cache);
+		struct page_frag_cache *nc = this_cpu_ptr(&netdev_alloc_cache);
+
 		data = page_frag_alloc_align(nc, fragsz, GFP_ATOMIC, align_mask);
 	} else {
+		struct napi_alloc_cache *nc;
+
 		local_bh_disable();
-		data = __alloc_frag_align(fragsz, GFP_ATOMIC, align_mask);
+		nc = this_cpu_ptr(&napi_alloc_cache);
+		data = page_frag_alloc_align(&nc->page, fragsz, GFP_ATOMIC, align_mask);
 		local_bh_enable();
 	}
 	return data;
-- 
2.32.0

