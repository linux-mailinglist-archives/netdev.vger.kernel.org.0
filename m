Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B65D3DD256
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhHBIw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:52:59 -0400
Received: from relay.sw.ru ([185.231.240.75]:44442 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233051AbhHBIwv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 04:52:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=ooj4bmnFtWIlob/rxQyLW0bJMWnLx9bltRAb79Bbt6M=; b=Kk7deZGvPbio5bwk6VX
        LjPWvNsMn1GADoBZwtlGjHT+2JcSqFBy3ux7qN8T0Alk5QEIDVtxTBhts5RDCidjZPJLrYA0bTNVa
        AscRA6WMp88wFr2bNCQAGxqJcNY3nUsNXRhGH8ykPtdZLu/FAwZVbGOsiRgGIReedSb7ToZmcVw=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mATgf-0060OO-Cp; Mon, 02 Aug 2021 11:52:41 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET v3 5/7] vrf: use skb_expand_head in vrf_finish_output
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <15eba3b2-80e2-5547-8ad9-167d810ad7e3@virtuozzo.com>
 <cover.1627891754.git.vvs@virtuozzo.com>
Message-ID: <e4ca1ef1-56f3-5bce-eec8-617e24bc7b1a@virtuozzo.com>
Date:   Mon, 2 Aug 2021 11:52:40 +0300
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

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 drivers/net/vrf.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 2b1b944..726adf0 100644
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
+			skb->dev->stats.tx_errors++;
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
 	vrf_tx_error(skb->dev, skb);
-	return ret;
+	return -EINVAL;
 }
 
 static int vrf_output(struct net *net, struct sock *sk, struct sk_buff *skb)
-- 
1.8.3.1

