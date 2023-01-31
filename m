Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8965682477
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 07:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjAaGgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 01:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjAaGgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 01:36:02 -0500
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B673668E;
        Mon, 30 Jan 2023 22:36:00 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VaVVipP_1675146949;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VaVVipP_1675146949)
          by smtp.aliyun-inc.com;
          Tue, 31 Jan 2023 14:35:57 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] ipv6: ICMPV6: Use swap() instead of open coding it
Date:   Tue, 31 Jan 2023 14:34:56 +0800
Message-Id: <20230131063456.76302-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Swap is a function interface that provides exchange function. To avoid
code duplication, we can use swap function.

./net/ipv6/icmp.c:344:25-26: WARNING opportunity for swap().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3896
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/ipv6/icmp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 79c769c0d113..c9346515e24d 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -332,7 +332,6 @@ static void mip6_addr_swap(struct sk_buff *skb, const struct inet6_skb_parm *opt
 {
 	struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct ipv6_destopt_hao *hao;
-	struct in6_addr tmp;
 	int off;
 
 	if (opt->dsthao) {
@@ -340,9 +339,7 @@ static void mip6_addr_swap(struct sk_buff *skb, const struct inet6_skb_parm *opt
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

