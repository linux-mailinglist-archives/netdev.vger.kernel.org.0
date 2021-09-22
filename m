Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71E9414192
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 08:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhIVGS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 02:18:58 -0400
Received: from mx429.baidu.com ([119.249.100.165]:5975 "EHLO mx419.baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232367AbhIVGSz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 02:18:55 -0400
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by mx419.baidu.com (Postfix) with ESMTP id BBED81818245F
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 14:17:19 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id B3D15D9932
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 14:17:19 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org
Subject: [PATCH][net-next] skbuff: pass the result of data ksize to __build_skb_around
Date:   Wed, 22 Sep 2021 14:17:19 +0800
Message-Id: <1632291439-823-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid to call ksize again in __build_skb_around by passing
the result of data ksize to __build_skb_around

nginx stress test shows this change can reduce ksize cpu usage,
and give a little performance boost

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/core/skbuff.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9240af2..1e0a930 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -397,8 +397,9 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 {
 	struct kmem_cache *cache;
 	struct sk_buff *skb;
-	u8 *data;
+	unsigned int osize;
 	bool pfmemalloc;
+	u8 *data;
 
 	cache = (flags & SKB_ALLOC_FCLONE)
 		? skbuff_fclone_cache : skbuff_head_cache;
@@ -430,7 +431,8 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	 * Put skb_shared_info exactly at the end of allocated zone,
 	 * to allow max possible filling before reallocation.
 	 */
-	size = SKB_WITH_OVERHEAD(ksize(data));
+	osize = ksize(data);
+	size = SKB_WITH_OVERHEAD(osize);
 	prefetchw(data + size);
 
 	/*
@@ -439,7 +441,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	 * the tail pointer in struct sk_buff!
 	 */
 	memset(skb, 0, offsetof(struct sk_buff, tail));
-	__build_skb_around(skb, data, 0);
+	__build_skb_around(skb, data, osize);
 	skb->pfmemalloc = pfmemalloc;
 
 	if (flags & SKB_ALLOC_FCLONE) {
-- 
1.7.1

