Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3820A24550B
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 02:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgHPAdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 20:33:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:36510 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726063AbgHPAdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 20:33:15 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1D3D6CB48D85CE87ED0C;
        Sat, 15 Aug 2020 16:45:42 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Sat, 15 Aug 2020
 16:45:35 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pshelar@ovn.org>,
        <fw@strlen.de>, <martin.varghese@nokia.com>, <edumazet@google.com>,
        <dcaratti@redhat.com>, <steffen.klassert@secunet.com>,
        <pabeni@redhat.com>, <shmulik@metanetworks.com>,
        <kyk.segfault@gmail.com>, <jiri@mellanox.com>,
        <vyasevic@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Fix potential wrong skb->protocol in skb_vlan_untag()
Date:   Sat, 15 Aug 2020 04:44:31 -0400
Message-ID: <20200815084431.16813-1-linmiaohe@huawei.com>
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

We may access the two bytes after vlan_hdr in vlan_set_encap_proto(). So
we should pull VLAN_HLEN + sizeof(unsigned short) in skb_vlan_untag() or
we may access the wrong data.

Fixes: 0d5501c1c828 ("net: Always untag vlan-tagged traffic on input.")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/core/skbuff.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7e2e502ef519..5c3b906aeef3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5418,8 +5418,8 @@ struct sk_buff *skb_vlan_untag(struct sk_buff *skb)
 	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (unlikely(!skb))
 		goto err_free;
-
-	if (unlikely(!pskb_may_pull(skb, VLAN_HLEN)))
+	/* We may access the two bytes after vlan_hdr in vlan_set_encap_proto(). */
+	if (unlikely(!pskb_may_pull(skb, VLAN_HLEN + sizeof(unsigned short))))
 		goto err_free;
 
 	vhdr = (struct vlan_hdr *)skb->data;
-- 
2.19.1

