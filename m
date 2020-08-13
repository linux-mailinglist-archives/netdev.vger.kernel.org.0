Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E2D2439AB
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 14:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgHMMOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 08:14:35 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58782 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726583AbgHMMOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Aug 2020 08:14:31 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 00BB8D67E5A4D6550FBD;
        Thu, 13 Aug 2020 20:14:26 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Thu, 13 Aug 2020
 20:14:15 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <fw@strlen.de>,
        <martin.varghese@nokia.com>, <pshelar@ovn.org>,
        <dcaratti@redhat.com>, <edumazet@google.com>,
        <steffen.klassert@secunet.com>, <pabeni@redhat.com>,
        <shmulik@metanetworks.com>, <kyk.segfault@gmail.com>,
        <sowmini.varadhan@oracle.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: add missing skb_uarg refcount increment in pskb_carve_inside_header()
Date:   Thu, 13 Aug 2020 08:13:10 -0400
Message-ID: <20200813121310.23016-1-linmiaohe@huawei.com>
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

If the skb is zcopied, we should increase the skb_uarg refcount before we
involve skb_release_data(). See pskb_expand_head() as a reference.

Fixes: 6fa01ccd8830 ("skbuff: Add pskb_extract() helper function")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/core/skbuff.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 475f9aa51b57..975600558e8b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5842,6 +5842,8 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 			kfree(data);
 			return -ENOMEM;
 		}
+		if (skb_zcopy(skb))
+			refcount_inc(&skb_uarg(skb)->refcnt);
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
 			skb_frag_ref(skb, i);
 		if (skb_has_frag_list(skb))
-- 
2.19.1

