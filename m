Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B854F3E2482
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 09:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243305AbhHFHut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 03:50:49 -0400
Received: from relay.sw.ru ([185.231.240.75]:36382 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243303AbhHFHun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 03:50:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=OA6nvNuOTkBp2v6M/MwmgL8Zt0WvZey0HynRSPLWDic=; b=Bl2S4YTeIGSm68wVebU
        9K634xZ46RFIsbgA3I/EBPir4vGLSFqQ6AyA/TVYs64zNNfzzb/n+h8rpB+XiK0TpqZfHBUtQKu2n
        MMLehn0V8Von7HsFt3IoydX3MMpDGoUAegFqkccT8D8algsgsB/G0X9A+gkuCirlpRHgP96xlss=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mBucb-006agE-1u; Fri, 06 Aug 2021 10:50:25 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET v4 5/7] vrf: use skb_expand_head in vrf_finish_output
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Julian Wiedmann <jwi@linux.ibm.com>
References: <ccce7edb-54dd-e6bf-1e84-0ec320d8886c@linux.ibm.com>
 <cover.1628235065.git.vvs@virtuozzo.com>
Message-ID: <7429ac6a-aac5-fd56-a109-55110cdf5b64@virtuozzo.com>
Date:   Fri, 6 Aug 2021 10:50:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1628235065.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike skb_realloc_headroom, new helper skb_expand_head
does not allocate a new skb if possible.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
v4: fixes null pointer dereference reported by Julian Wiedmann,
replace skb->dev by dev = skb_dst(skb)->dev
vrf_finish_output() is only called from vrf_output(),
it set skb->dev to skb_dst(skb)->dev and calls POSTROUTING netfilter
hooks, where output device should not be changed.
---
 drivers/net/vrf.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 2b1b944..168d4ef 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -857,30 +857,24 @@ static int vrf_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 	unsigned int hh_len = LL_RESERVED_SPACE(dev);
 	struct neighbour *neigh;
 	bool is_v6gw = false;
-	int ret = -EINVAL;
 
 	nf_reset_ct(skb);
 
 	/* Be paranoid, rather than too clever. */
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
-		struct sk_buff *skb2;
-
-		skb2 = skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));
-		if (!skb2) {
-			ret = -ENOMEM;
-			goto err;
+		skb = skb_expand_head(skb, hh_len);
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
 
 	neigh = ip_neigh_for_gw(rt, skb, &is_v6gw);
 	if (!IS_ERR(neigh)) {
+		int ret;
+
 		sock_confirm_neigh(skb, neigh);
 		/* if crossing protocols, can not use the cached header */
 		ret = neigh_output(neigh, skb, is_v6gw);
@@ -889,9 +883,8 @@ static int vrf_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 	}
 
 	rcu_read_unlock_bh();
-err:
-	vrf_tx_error(skb->dev, skb);
-	return ret;
+	vrf_tx_error(dev, skb);
+	return -EINVAL;
 }
 
 static int vrf_output(struct net *net, struct sock *sk, struct sk_buff *skb)
-- 
1.8.3.1

