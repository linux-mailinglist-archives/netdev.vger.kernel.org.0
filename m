Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EAC3C5D41
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhGLNaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:30:04 -0400
Received: from relay.sw.ru ([185.231.240.75]:49680 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234550AbhGLNaC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 09:30:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=6C5q1qZLgzA0flXfJ1uNtbk6wxdWzsUQzpBj7aDLaW8=; b=k2DOrEAxThK9s8h1RPE
        IZhZdQMYWwGTZwTyl8U8QGD1jYyi0qLTmpU6X0gCCTdnwychX9XtpfeEmnJ3QeaKEKkyTV9ATaz0G
        2EYwx2uuIlbRkQzP7Py895qFE/alV7634WDMOviqnIXLmXJtscAC/b1WIMxnv8fhfAZRVsP48Ac=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m2vxo-003iDg-1o; Mon, 12 Jul 2021 16:27:12 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET 5/7] vrf: use pskb_realloc_headroom in vrf_finish_output
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <74e90fba-df9f-5078-13de-41df54d2b257@virtuozzo.com>
 <cover.1626093470.git.vvs@virtuozzo.com>
Message-ID: <b17496f3-7471-319d-62f7-d289e6962778@virtuozzo.com>
Date:   Mon, 12 Jul 2021 16:27:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1626093470.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike skb_realloc_headroom, new helper pskb_realloc_headroom
does not allocate a new skb if possible.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 drivers/net/vrf.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 28a6c4c..74b9538 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -863,18 +863,12 @@ static int vrf_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 
 	/* Be paranoid, rather than too clever. */
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
-		struct sk_buff *skb2;
+		skb = pskb_realloc_headroom(skb, hh_len);
 
-		skb2 = skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));
-		if (!skb2) {
-			ret = -ENOMEM;
-			goto err;
+		if (!skb) {
+			dev->stats.tx_errors++;
+			return -ENOMEM;
 		}
-		if (skb->sk)
-			skb_set_owner_w(skb2, skb->sk);
-
-		consume_skb(skb);
-		skb = skb2;
 	}
 
 	rcu_read_lock_bh();
-- 
1.8.3.1

