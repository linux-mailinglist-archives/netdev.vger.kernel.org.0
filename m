Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D8F254472
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 13:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbgH0Ll2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 07:41:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:52428 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728804AbgH0LlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 07:41:15 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3DB081522D01B034F7A2;
        Thu, 27 Aug 2020 19:23:15 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 27 Aug 2020
 19:23:07 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pshelar@ovn.org>,
        <fw@strlen.de>, <martin.varghese@nokia.com>, <edumazet@google.com>,
        <dcaratti@redhat.com>, <steffen.klassert@secunet.com>,
        <pabeni@redhat.com>, <shmulik@metanetworks.com>,
        <kyk.segfault@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: exit immediately when encounter ipv6 fragment in skb_checksum_setup_ipv6()
Date:   Thu, 27 Aug 2020 07:21:59 -0400
Message-ID: <20200827112159.43242-1-linmiaohe@huawei.com>
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

skb_checksum_setup_ipv6() always return -EPROTO if ipv6 packet is fragment.
So we should not continue to parse other header type in this case. Also
remove unnecessary local variable 'fragment'.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/core/skbuff.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c3496bd8e99e..4dc92290becd 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4894,11 +4894,9 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
 	u8 nexthdr;
 	unsigned int off;
 	unsigned int len;
-	bool fragment;
 	bool done;
 	__sum16 *csum;
 
-	fragment = false;
 	done = false;
 
 	off = sizeof(struct ipv6hdr);
@@ -4956,8 +4954,11 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
 
 			hp = OPT_HDR(struct frag_hdr, skb, off);
 
-			if (hp->frag_off & htons(IP6_OFFSET | IP6_MF))
-				fragment = true;
+			/* Exit immediately when encounter ipv6 fragment. */
+			if (hp->frag_off & htons(IP6_OFFSET | IP6_MF)) {
+				err = -EPROTO;
+				goto out;
+			}
 
 			nexthdr = hp->nexthdr;
 			off += sizeof(struct frag_hdr);
@@ -4970,8 +4971,7 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
 	}
 
 	err = -EPROTO;
-
-	if (!done || fragment)
+	if (!done)
 		goto out;
 
 	csum = skb_checksum_setup_ip(skb, nexthdr, off);
-- 
2.19.1

