Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1563FF8F3
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 04:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346212AbhICCuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 22:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbhICCuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 22:50:51 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C000C061575;
        Thu,  2 Sep 2021 19:49:52 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1630637389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HGCXowfEnV6ruBeSK2//8S5xZwMjtZ0J8SMNgYXpQ9A=;
        b=m926Otzh2RX9emcx5ctpDv2UxocxYNQB9MLeJzATW/1H7z8W90isidryCo4wIP+cIjSLas
        NPoXlLZ47EC0zh1f22ZPDEuYUN2uKuq+Iq2WIJ5F5rso34nq6q7dVd9tGrGqGSwaHyUlCZ
        bQl9UMoOc//E/IZ3WI/Zryu5HIMEu6o=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] skbuff: inline page_frag_alloc_align()
Date:   Fri,  3 Sep 2021 10:49:26 +0800
Message-Id: <20210903024926.4221-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The __alloc_frag_align() is short, and only called by __napi_alloc_...
and __netdev_alloc_frag_align(). so inline page_frag_alloc_align()
for reduce the overhead of calls.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/skbuff.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f9311762cc47..1751232f3c97 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -134,34 +134,30 @@ struct napi_alloc_cache {
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
+		struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
+
 		local_bh_disable();
-		data = __alloc_frag_align(fragsz, GFP_ATOMIC, align_mask);
+		data = page_frag_alloc_align(&nc->page, fragsz, GFP_ATOMIC, align_mask);
 		local_bh_enable();
 	}
 	return data;
-- 
2.32.0

