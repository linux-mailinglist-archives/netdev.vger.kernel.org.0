Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28D62548F9
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgH0PRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:17:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10285 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728753AbgH0Lge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 07:36:34 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EBEC1A285DC439BF461F;
        Thu, 27 Aug 2020 19:19:15 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 27 Aug 2020
 19:19:07 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pshelar@ovn.org>,
        <fw@strlen.de>, <martin.varghese@nokia.com>, <edumazet@google.com>,
        <dcaratti@redhat.com>, <steffen.klassert@secunet.com>,
        <pabeni@redhat.com>, <shmulik@metanetworks.com>,
        <kyk.segfault@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Call ip_hdrlen() when skbuff is not fragment
Date:   Thu, 27 Aug 2020 07:17:59 -0400
Message-ID: <20200827111759.40336-1-linmiaohe@huawei.com>
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

When skbuff is fragment, we exit immediately and leave ip_hdrlen() as
unused. And remove the unnecessary local variable fragment.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/core/skbuff.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4dc92290becd..0b24aed04060 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4843,28 +4843,20 @@ static __sum16 *skb_checksum_setup_ip(struct sk_buff *skb,
 static int skb_checksum_setup_ipv4(struct sk_buff *skb, bool recalculate)
 {
 	unsigned int off;
-	bool fragment;
 	__sum16 *csum;
 	int err;
 
-	fragment = false;
-
 	err = skb_maybe_pull_tail(skb,
 				  sizeof(struct iphdr),
 				  MAX_IP_HDR_LEN);
 	if (err < 0)
 		goto out;
 
-	if (ip_is_fragment(ip_hdr(skb)))
-		fragment = true;
-
-	off = ip_hdrlen(skb);
-
 	err = -EPROTO;
-
-	if (fragment)
+	if (ip_is_fragment(ip_hdr(skb)))
 		goto out;
 
+	off = ip_hdrlen(skb);
 	csum = skb_checksum_setup_ip(skb, ip_hdr(skb)->protocol, off);
 	if (IS_ERR(csum))
 		return PTR_ERR(csum);
-- 
2.19.1

