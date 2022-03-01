Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF694C8AA0
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 12:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbiCALYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 06:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234402AbiCALYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 06:24:41 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A57D91AC6;
        Tue,  1 Mar 2022 03:23:58 -0800 (PST)
X-UUID: 1679023a156949ada20265f131d342a6-20220301
X-UUID: 1679023a156949ada20265f131d342a6-20220301
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <lena.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2115268812; Tue, 01 Mar 2022 19:23:14 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 1 Mar 2022 19:23:13 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Mar 2022 19:23:12 +0800
From:   lena wang <lena.wang@mediatek.com>
To:     <pabeni@redhat.com>, <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Dongseok Yi <dseok.yi@samsung.com>
CC:     <wsd_upstream@mediatek.com>, lena wang <lena.wang@mediatek.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH net v2] net: fix up skbs delta_truesize in UDP GRO frag_list
Date:   Tue, 1 Mar 2022 19:17:09 +0800
Message-ID: <1646133431-8948-1-git-send-email-lena.wang@mediatek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The truesize for a UDP GRO packet is added by main skb and skbs in main
skb's frag_list:
skb_gro_receive_list
        p->truesize += skb->truesize;

The commit 53475c5dd856 ("net: fix use-after-free when UDP GRO with
shared fraglist") introduced a truesize increase for frag_list skbs.
When uncloning skb, it will call pskb_expand_head and trusesize for
frag_list skbs may increase. This can occur when allocators uses
__netdev_alloc_skb and not jump into __alloc_skb. This flow does not
use ksize(len) to calculate truesize while pskb_expand_head uses.
skb_segment_list
err = skb_unclone(nskb, GFP_ATOMIC);
pskb_expand_head
        if (!skb->sk || skb->destructor == sock_edemux)
                skb->truesize += size - osize;

If we uses increased truesize adding as delta_truesize, it will be
larger than before and even larger than previous total truesize value
if skbs in frag_list are abundant. The main skb truesize will become
smaller and even a minus value or a huge value for an unsigned int
parameter. Then the following memory check will drop this abnormal skb.

To avoid this error we should use the original truesize to segment the
main skb.

Fixes: 53475c5dd856 ("net: fix use-after-free when UDP GRO with shared fraglist")
Signed-off-by: lena wang <lena.wang@mediatek.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
---
change since v1:
1) add the fix tag.
2) add net subtree to the subject
---
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9d0388bed0c1..8b7356cffea7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3876,6 +3876,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		list_skb = list_skb->next;
 
 		err = 0;
+		delta_truesize += nskb->truesize;
 		if (skb_shared(nskb)) {
 			tmp = skb_clone(nskb, GFP_ATOMIC);
 			if (tmp) {
@@ -3900,7 +3901,6 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		tail = nskb;
 
 		delta_len += nskb->len;
-		delta_truesize += nskb->truesize;
 
 		skb_push(nskb, -skb_network_offset(nskb) + offset);
 
-- 
2.18.0

