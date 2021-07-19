Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB013CCEF2
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 09:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbhGSH6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 03:58:22 -0400
Received: from relay.sw.ru ([185.231.240.75]:52586 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234899AbhGSH6W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 03:58:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=Qs4XlbPUE6apDQAFm0j0TfDJpKNeesqn0NIlAUMQvZg=; b=TDrzIglAE7CTyNlJXQX
        XRRcDWM4LgStXDf45HnxX6I2gojsVOjcgc1RwN7UXvnpSnof5AYlMpj2cAMKLi5d6nodnbEa6PuZT
        kIB66iAS0gjNXuGdGguH7eNH90EdKqdM6KVVvfd7GuPnwDIQQ3YHK3WVt6frgk5lifB/2jKjvrw=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m5O7P-004Ps3-1b; Mon, 19 Jul 2021 10:55:15 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET] ipv6: ip6_finish_output2: set sk into newly allocated
 nskb
References: <20210718.100457.250657299500744178.davem@davemloft.net>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Message-ID: <70c0744f-89ae-1869-7e3e-4fa292158f4b@virtuozzo.com>
Date:   Mon, 19 Jul 2021 10:55:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210718.100457.250657299500744178.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_set_owner_w() should set sk not to old skb but to new nskb.

Fixes: 5796015fa968("ipv6: allocate enough headroom in ip6_finish_output2()")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ipv6/ip6_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 01bea76..e1b9f7a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -74,7 +74,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 
 			if (likely(nskb)) {
 				if (skb->sk)
-					skb_set_owner_w(skb, skb->sk);
+					skb_set_owner_w(nskb, skb->sk);
 				consume_skb(skb);
 			} else {
 				kfree_skb(skb);
-- 
1.8.3.1

