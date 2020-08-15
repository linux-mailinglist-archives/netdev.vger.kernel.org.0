Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C649245517
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 02:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgHPAhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 20:37:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9820 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726022AbgHPAha (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 20:37:30 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 250A529CA57D55BDBB3C;
        Sat, 15 Aug 2020 16:50:06 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Sat, 15 Aug 2020
 16:49:56 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pshelar@ovn.org>,
        <martin.varghese@nokia.com>, <fw@strlen.de>, <dcaratti@redhat.com>,
        <edumazet@google.com>, <steffen.klassert@secunet.com>,
        <pabeni@redhat.com>, <shmulik@metanetworks.com>,
        <kyk.segfault@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH v2] net: eliminate meaningless memcpy to data in pskb_carve_inside_nonlinear()
Date:   Sat, 15 Aug 2020 04:48:53 -0400
Message-ID: <20200815084853.20216-1-linmiaohe@huawei.com>
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

The frags of skb_shared_info of the data is assigned in following loop. It
is meaningless to do a memcpy of frags here.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/core/skbuff.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index afbc1a79dc8a..44b7010e4813 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5953,8 +5953,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 	size = SKB_WITH_OVERHEAD(ksize(data));
 
 	memcpy((struct skb_shared_info *)(data + size),
-	       skb_shinfo(skb), offsetof(struct skb_shared_info,
-					 frags[skb_shinfo(skb)->nr_frags]));
+	       skb_shinfo(skb), offsetof(struct skb_shared_info, frags[0]));
 	if (skb_orphan_frags(skb, gfp_mask)) {
 		kfree(data);
 		return -ENOMEM;
-- 
2.19.1

