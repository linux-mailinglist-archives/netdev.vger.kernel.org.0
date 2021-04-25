Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2C736A688
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 12:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhDYKPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 06:15:16 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:33804 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229466AbhDYKPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 06:15:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UWfrnwm_1619345673;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UWfrnwm_1619345673)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 25 Apr 2021 18:14:34 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] esp: drop unneeded assignment in esp4_gro_receive()
Date:   Sun, 25 Apr 2021 18:14:32 +0800
Message-Id: <1619345672-31802-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Making '!=' operation with 0 directly after calling
the function xfrm_parse_spi() is more efficient,
assignment to err is redundant.

Eliminate the following clang_analyzer warning:
net/ipv4/esp4_offload.c:41:7: warning: Although the value stored to
'err' is used in the enclosing expression, the value is never actually
read from 'err'

No functional change, only more efficient.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 net/ipv4/esp4_offload.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 33687cf..be019a1 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -33,12 +33,11 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 	struct xfrm_state *x;
 	__be32 seq;
 	__be32 spi;
-	int err;
 
 	if (!pskb_pull(skb, offset))
 		return NULL;
 
-	if ((err = xfrm_parse_spi(skb, IPPROTO_ESP, &spi, &seq)) != 0)
+	if (xfrm_parse_spi(skb, IPPROTO_ESP, &spi, &seq) != 0)
 		goto out;
 
 	xo = xfrm_offload(skb);
-- 
1.8.3.1

