Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A6F2B7842
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 09:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgKRIOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 03:14:55 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7930 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgKRIOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 03:14:55 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CbbFT6phLz6yM6;
        Wed, 18 Nov 2020 16:14:37 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Wed, 18 Nov 2020 16:14:42 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <linmiaohe@huawei.com>,
        <martin.varghese@nokia.com>, <pshelar@ovn.org>,
        <pabeni@redhat.com>, <fw@strlen.de>, <viro@zeniv.linux.org.uk>,
        <gnault@redhat.com>, <steffen.klassert@secunet.com>,
        <kyk.segfault@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net/core: use xx_zalloc instead xx_alloc and memset
Date:   Wed, 18 Nov 2020 16:15:08 +0800
Message-ID: <1605687308-57318-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use kmem_cache_zalloc instead kmem_cache_alloc and memset.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 net/core/skbuff.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c9a5a3c..3449c1c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -313,12 +313,10 @@ struct sk_buff *__build_skb(void *data, unsigned int frag_size)
 {
 	struct sk_buff *skb;
 
-	skb = kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
+	skb = kmem_cache_zalloc(skbuff_head_cache, GFP_ATOMIC);
 	if (unlikely(!skb))
 		return NULL;
 
-	memset(skb, 0, offsetof(struct sk_buff, tail));
-
 	return __build_skb_around(skb, data, frag_size);
 }
 
@@ -6170,12 +6168,10 @@ static void *skb_ext_get_ptr(struct skb_ext *ext, enum skb_ext_id id)
  */
 struct skb_ext *__skb_ext_alloc(gfp_t flags)
 {
-	struct skb_ext *new = kmem_cache_alloc(skbuff_ext_cache, flags);
+	struct skb_ext *new = kmem_cache_zalloc(skbuff_ext_cache, flags);
 
-	if (new) {
-		memset(new->offset, 0, sizeof(new->offset));
+	if (new)
 		refcount_set(&new->refcnt, 1);
-	}
 
 	return new;
 }
-- 
2.7.4

