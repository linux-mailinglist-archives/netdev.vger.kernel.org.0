Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C953DD25E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhHBIxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:53:16 -0400
Received: from relay.sw.ru ([185.231.240.75]:44498 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233093AbhHBIxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 04:53:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=rCy2NaJChVwaNZpi28B6dE5KboUh3ih3z6EATump7Xs=; b=N3dipEGAQ8LSDS7Kb96
        TqkGIdV/fNu4iEpFMh7lNMuQB36SGkeihSNNXsCuQb9ycSPuxBz8c5ruUohPe//Enme6C9WaScNLd
        /y7XXCfRltU12atpO3bogGp2RvO82FT5MZQvefndSiNdd4xINKT1LlmfF986PbM95eRaTI4gyvA=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mATgs-0060Oq-JS; Mon, 02 Aug 2021 11:52:54 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET v3 7/7] bpf: use skb_expand_head in bpf_out_neigh_v4/6
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
References: <15eba3b2-80e2-5547-8ad9-167d810ad7e3@virtuozzo.com>
 <cover.1627891754.git.vvs@virtuozzo.com>
Message-ID: <09a3da40-bb50-ceff-994a-1799e86697c2@virtuozzo.com>
Date:   Mon, 2 Aug 2021 11:52:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1627891754.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike skb_realloc_headroom, new helper skb_expand_head
does not allocate a new skb if possible.

Additionally this patch replaces commonly used dereferencing with variables.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/core/filter.c | 27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d70187c..9c2f434 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2179,17 +2179,9 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb,
 	skb->tstamp = 0;
 
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
-		struct sk_buff *skb2;
-
-		skb2 = skb_realloc_headroom(skb, hh_len);
-		if (unlikely(!skb2)) {
-			kfree_skb(skb);
+		skb = skb_expand_head(skb, hh_len);
+		if (!skb)
 			return -ENOMEM;
-		}
-		if (skb->sk)
-			skb_set_owner_w(skb2, skb->sk);
-		consume_skb(skb);
-		skb = skb2;
 	}
 
 	rcu_read_lock_bh();
@@ -2213,8 +2205,7 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb,
 	}
 	rcu_read_unlock_bh();
 	if (dst)
-		IP6_INC_STATS(dev_net(dst->dev),
-			      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
+		IP6_INC_STATS(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
 out_drop:
 	kfree_skb(skb);
 	return -ENETDOWN;
@@ -2286,17 +2277,9 @@ static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb,
 	skb->tstamp = 0;
 
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
-		struct sk_buff *skb2;
-
-		skb2 = skb_realloc_headroom(skb, hh_len);
-		if (unlikely(!skb2)) {
-			kfree_skb(skb);
+		skb = skb_expand_head(skb, hh_len);
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

