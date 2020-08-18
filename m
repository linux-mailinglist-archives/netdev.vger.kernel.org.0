Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE52248448
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 13:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHRL6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 07:58:34 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9835 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726370AbgHRL6d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 07:58:33 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 20A847032FD65771EB2D;
        Tue, 18 Aug 2020 19:58:28 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Tue, 18 Aug 2020
 19:58:18 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <martin.varghese@nokia.com>, <fw@strlen.de>, <pshelar@ovn.org>,
        <dcaratti@redhat.com>, <edumazet@google.com>,
        <steffen.klassert@secunet.com>, <pabeni@redhat.com>,
        <shmulik@metanetworks.com>, <kyk.segfault@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Relax the npages test against MAX_SKB_FRAGS
Date:   Tue, 18 Aug 2020 07:57:12 -0400
Message-ID: <20200818115712.36497-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The npages test against MAX_SKB_FRAGS can be relaxed if we succeed to
allocate high order pages as the note in comment said.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/core/skbuff.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2f7dd689bccc..ca432bbfd90b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5758,13 +5758,6 @@ struct sk_buff *alloc_skb_with_frags(unsigned long header_len,
 	struct page *page;
 	int i;
 
-	*errcode = -EMSGSIZE;
-	/* Note this test could be relaxed, if we succeed to allocate
-	 * high order pages...
-	 */
-	if (npages > MAX_SKB_FRAGS)
-		return NULL;
-
 	*errcode = -ENOBUFS;
 	skb = alloc_skb(header_len, gfp_mask);
 	if (!skb)
@@ -5775,6 +5768,10 @@ struct sk_buff *alloc_skb_with_frags(unsigned long header_len,
 	for (i = 0; npages > 0; i++) {
 		int order = max_page_order;
 
+		if (unlikely(i >= MAX_SKB_FRAGS)) {
+			*errcode = -EMSGSIZE;
+			goto failure;
+		}
 		while (order) {
 			if (npages >= 1 << order) {
 				page = alloc_pages((gfp_mask & ~__GFP_DIRECT_RECLAIM) |
-- 
2.19.1

