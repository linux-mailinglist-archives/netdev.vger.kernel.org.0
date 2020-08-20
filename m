Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E181A24BB7B
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 14:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbgHTM3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 08:29:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34814 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729347AbgHTM3h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 08:29:37 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7A43D86F04766B046245;
        Thu, 20 Aug 2020 20:29:34 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Thu, 20 Aug 2020
 20:29:28 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <martin.varghese@nokia.com>, <pshelar@ovn.org>, <fw@strlen.de>,
        <dcaratti@redhat.com>, <edumazet@google.com>,
        <steffen.klassert@secunet.com>, <pabeni@redhat.com>,
        <shmulik@metanetworks.com>, <kyk.segfault@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Check the expect of skb->data at mac header
Date:   Thu, 20 Aug 2020 08:28:22 -0400
Message-ID: <20200820122822.46608-1-linmiaohe@huawei.com>
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

skb_mpls_push() and skb_mpls_pop() expect skb->data at mac header. Check
this assumption or we would get wrong mac_header and network_header.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/core/skbuff.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e18184ffa9c3..52d2ad54aa97 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5590,6 +5590,7 @@ static void skb_mod_eth_type(struct sk_buff *skb, struct ethhdr *hdr,
 int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
 		  int mac_len, bool ethernet)
 {
+	int offset = skb->data - skb_mac_header(skb);
 	struct mpls_shim_hdr *lse;
 	int err;
 
@@ -5600,6 +5601,9 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
 	if (skb->encapsulation)
 		return -EINVAL;
 
+	if (WARN_ONCE(offset, "We got skb with skb->data not at mac header (offset %d)\n", offset))
+		return -EINVAL;
+
 	err = skb_cow_head(skb, MPLS_HLEN);
 	if (unlikely(err))
 		return err;
@@ -5643,11 +5647,15 @@ EXPORT_SYMBOL_GPL(skb_mpls_push);
 int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
 		 bool ethernet)
 {
+	int offset = skb->data - skb_mac_header(skb);
 	int err;
 
 	if (unlikely(!eth_p_mpls(skb->protocol)))
 		return 0;
 
+	if (WARN_ONCE(offset, "We got skb with skb->data not at mac header (offset %d)\n", offset))
+		return -EINVAL;
+
 	err = skb_ensure_writable(skb, mac_len + MPLS_HLEN);
 	if (unlikely(err))
 		return err;
-- 
2.19.1

