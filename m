Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450FE333746
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhCJI2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:28:42 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13080 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhCJI23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 03:28:29 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DwQC23BPhzMknJ;
        Wed, 10 Mar 2021 16:26:06 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Wed, 10 Mar 2021 16:28:14 +0800
From:   l00371289 <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <alobakin@pm.me>, <jonathan.lemon@gmail.com>, <willemb@google.com>,
        <linmiaohe@huawei.com>, <gnault@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: [PATCH net-next] skbuff: remove some unnecessary operation in skb_segment_list()
Date:   Wed, 10 Mar 2021 16:28:58 +0800
Message-ID: <1615364938-52943-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

gro list uses skb_shinfo(skb)->frag_list to link two skb together,
and NAPI_GRO_CB(p)->last->next is used when there are more skb,
see skb_gro_receive_list(). gso expects that each segmented skb is
linked together using skb->next, so only the first skb->next need
to set to skb_shinfo(skb)-> frag_list when doing gso list segment.

It is the same reason that nskb->next does not need to be set to
list_skb before goto the error handling, because nskb->next already
pointers to list_skb.

And nskb is also the last skb at the end of loop, so remove tail
variable and use nskb instead.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 net/core/skbuff.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c421c8f..e8320b5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3732,13 +3732,13 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 	unsigned int tnl_hlen = skb_tnl_header_len(skb);
 	unsigned int delta_truesize = 0;
 	unsigned int delta_len = 0;
-	struct sk_buff *tail = NULL;
 	struct sk_buff *nskb, *tmp;
 	int err;
 
 	skb_push(skb, -skb_network_offset(skb) + offset);
 
 	skb_shinfo(skb)->frag_list = NULL;
+	skb->next = list_skb;
 
 	do {
 		nskb = list_skb;
@@ -3756,17 +3756,8 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 			}
 		}
 
-		if (!tail)
-			skb->next = nskb;
-		else
-			tail->next = nskb;
-
-		if (unlikely(err)) {
-			nskb->next = list_skb;
+		if (unlikely(err))
 			goto err_linearize;
-		}
-
-		tail = nskb;
 
 		delta_len += nskb->len;
 		delta_truesize += nskb->truesize;
@@ -3793,7 +3784,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 
 	skb_gso_reset(skb);
 
-	skb->prev = tail;
+	skb->prev = nskb;
 
 	if (skb_needs_linearize(skb, features) &&
 	    __skb_linearize(skb))
-- 
2.7.4

