Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BC93C7861
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 22:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236155AbhGMVBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 17:01:36 -0400
Received: from relay.sw.ru ([185.231.240.75]:56872 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235060AbhGMVBf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 17:01:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=Zrmp38HLQSSBOIHCzrhOGN2I10/GGB7t9iYmdElr2i4=; b=oMb4Zx3XkPrKaEbUyM5
        Wje5X6G4fTPCuW8lq2suLGXW4TgOCp3OBmHH00y2+c8S2v3SusR25Qn+9XuCa5+lRKj94uTuhRNP/
        iXlyHbEjI3G1wn0S0pYAjM0i8kU7eYZurzXkFfp9sddH2FQI/V2+x06yB+T2hZ8RISMH1qTvwjw=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m3PUJ-003san-IH; Tue, 13 Jul 2021 23:58:43 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET v2 7/7] bpf: use skb_expand_head in bpf_out_neigh_v4/6
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
References: <55c9e2ae-b060-baa2-460c-90eb3e9ded5c@virtuozzo.com>
 <cover.1626206993.git.vvs@virtuozzo.com>
Message-ID: <47012e92-9978-cab1-68e4-9565ebe96994@virtuozzo.com>
Date:   Tue, 13 Jul 2021 23:58:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1626206993.git.vvs@virtuozzo.com>
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
index 65ab4e2..25a6950 100644
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

