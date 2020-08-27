Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8619B254479
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 13:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbgH0LnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 07:43:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10331 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728834AbgH0Lmz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 07:42:55 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B3045BEE75981B411CD0;
        Thu, 27 Aug 2020 19:25:01 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 27 Aug 2020
 19:24:51 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pshelar@ovn.org>,
        <fw@strlen.de>, <martin.varghese@nokia.com>, <edumazet@google.com>,
        <dcaratti@redhat.com>, <steffen.klassert@secunet.com>,
        <pabeni@redhat.com>, <shmulik@metanetworks.com>,
        <kyk.segfault@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: exit immediately when off = 0 in skb_headers_offset_update()
Date:   Thu, 27 Aug 2020 07:23:42 -0400
Message-ID: <20200827112342.44526-1-linmiaohe@huawei.com>
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

In the case of off = 0, skb_headers_offset_update() do nothing indeed.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/core/skbuff.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 18ed56316e56..f67f0da20a5b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1459,6 +1459,8 @@ EXPORT_SYMBOL(skb_clone);
 
 void skb_headers_offset_update(struct sk_buff *skb, int off)
 {
+	if (unlikely(off == 0))
+		return;
 	/* Only adjust this if it actually is csum_start rather than csum */
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		skb->csum_start += off;
-- 
2.19.1

