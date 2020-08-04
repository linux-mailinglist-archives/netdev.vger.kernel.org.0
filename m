Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE84323B9D5
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 13:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730246AbgHDLqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 07:46:00 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8758 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728157AbgHDLp7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 07:45:59 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F22B52BADDED43D36394;
        Tue,  4 Aug 2020 19:45:55 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Tue, 4 Aug 2020
 19:45:46 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pshelar@ovn.org>,
        <fw@strlen.de>, <martin.varghese@nokia.com>, <willemb@google.com>,
        <edumazet@google.com>, <dcaratti@redhat.com>,
        <steffen.klassert@secunet.com>, <pabeni@redhat.com>,
        <shmulik@metanetworks.com>, <kyk.segfault@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Fix potential out of bound write in skb_try_coalesce()
Date:   Tue, 4 Aug 2020 19:48:18 +0800
Message-ID: <1596541698-18938-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

The head_frag of skb would occupy one extra skb_frag_t. Take it into
account or out of bound write to skb frags may happen.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8a0c39e4ab0a..b489ba201fac 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5154,7 +5154,7 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 		unsigned int offset;
 
 		if (to_shinfo->nr_frags +
-		    from_shinfo->nr_frags >= MAX_SKB_FRAGS)
+		    from_shinfo->nr_frags + 1 >= MAX_SKB_FRAGS)
 			return false;
 
 		if (skb_head_is_locked(from))
-- 
2.19.1

