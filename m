Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6650D3C5D45
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhGLNaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:30:18 -0400
Received: from relay.sw.ru ([185.231.240.75]:49728 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234651AbhGLNaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 09:30:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=oVLqaRerUNUUvBWSQ6/QuqbFXlum72VBI6Uq+5WdkfI=; b=KybgMFAQyGKZhipKOoJ
        fT3l+z0yF8GlQFcALPUlq55hkj7cOiVE7/R1Ilwl5hiYUGKHqJF5JF5ofSvCgFtCVfggVXY9eH/A0
        mNVZ7aT+drha3qA0f3BJtSDMU23w8ByIiRRCjFd78f7VyTWjFW9PtQRwnQQD98MI3edCMkGSh9Q=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m2vy2-003iEA-Ly; Mon, 12 Jul 2021 16:27:26 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET 7/7] bpf: use pskb_realloc_headroom in bpf_out_neigh_v4/6
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <74e90fba-df9f-5078-13de-41df54d2b257@virtuozzo.com>
 <cover.1626093470.git.vvs@virtuozzo.com>
Message-ID: <5396c84f-81c3-8097-2504-61e4654b7f92@virtuozzo.com>
Date:   Mon, 12 Jul 2021 16:27:26 +0300
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

Additionally this patch replaces commonly used dereferencing with variables.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/core/filter.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 65ab4e2..cf6cd93 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2179,17 +2179,10 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb,
 	skb->tstamp = 0;
 
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
-		struct sk_buff *skb2;
+		skb = pskb_realloc_headroom(skb, hh_len);
 
-		skb2 = skb_realloc_headroom(skb, hh_len);
-		if (unlikely(!skb2)) {
-			kfree_skb(skb);
+		if (!skb)
 			return -ENOMEM;
-		}
-		if (skb->sk)
-			skb_set_owner_w(skb2, skb->sk);
-		consume_skb(skb);
-		skb = skb2;
 	}
 
 	rcu_read_lock_bh();
@@ -2286,17 +2279,10 @@ static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb,
 	skb->tstamp = 0;
 
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
-		struct sk_buff *skb2;
+		skb = pskb_realloc_headroom(skb, hh_len);
 
-		skb2 = skb_realloc_headroom(skb, hh_len);
-		if (unlikely(!skb2)) {
-			kfree_skb(skb);
+		if (!skb)
 			return -ENOMEM;
-		}
-		if (skb->sk)
-			skb_set_owner_w(skb2, skb->sk);
-		consume_skb(skb);
-		skb = skb2;
 	}
 
 	rcu_read_lock_bh();
-- 
1.8.3.1

