Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B2048DB81
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 17:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbiAMQRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 11:17:42 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:56675 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229496AbiAMQRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 11:17:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V1kuTWp_1642090652;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V1kuTWp_1642090652)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Jan 2022 00:17:40 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] ipv6: ICMPV6: Use swap() instead of open coding it
Date:   Fri, 14 Jan 2022 00:17:31 +0800
Message-Id: <20220113161731.130554-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean the following coccicheck warning:

./net/ipv6/icmp.c:348:25-26: WARNING opportunity for swap().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/ipv6/icmp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 96c5cc0f30ce..8d2ab5f2f8b6 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -336,7 +336,6 @@ static void mip6_addr_swap(struct sk_buff *skb, const struct inet6_skb_parm *opt
 {
 	struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct ipv6_destopt_hao *hao;
-	struct in6_addr tmp;
 	int off;
 
 	if (opt->dsthao) {
@@ -344,9 +343,7 @@ static void mip6_addr_swap(struct sk_buff *skb, const struct inet6_skb_parm *opt
 		if (likely(off >= 0)) {
 			hao = (struct ipv6_destopt_hao *)
 					(skb_network_header(skb) + off);
-			tmp = iph->saddr;
-			iph->saddr = hao->addr;
-			hao->addr = tmp;
+			swap(iph->saddr, hao->addr);
 		}
 	}
 }
-- 
2.20.1.7.g153144c

