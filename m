Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616C53DD25C
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhHBIxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:53:11 -0400
Received: from relay.sw.ru ([185.231.240.75]:44462 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233069AbhHBIw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 04:52:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=LZDj+Rl8XjJSfORqoOhYb7G114M/+nHSCpKbOxlgHdo=; b=aRJ+0Dcol/tJhRYVIto
        q/4cZNxWQGbLBHbDNatys6W85da2cc8V2mQrvrcqS5n94fU8ZP9HKDclIX1a6rMHO3+KyiZIxX+No
        Ct5JMGZI3ags0YKOE5z85LHngTWCh0E+mhRUZz2zkpugdhI1xZAF8uDXLuJB/bMfQ4+yXJfcu7c=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mATgl-0060Oa-Jt; Mon, 02 Aug 2021 11:52:47 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET v3 6/7] ax25: use skb_expand_head
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Joerg Reuter <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <15eba3b2-80e2-5547-8ad9-167d810ad7e3@virtuozzo.com>
 <cover.1627891754.git.vvs@virtuozzo.com>
Message-ID: <1c156cb1-af0d-d110-7786-67e3290e9345@virtuozzo.com>
Date:   Mon, 2 Aug 2021 11:52:47 +0300
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

Use skb_expand_head() in ax25_transmit_buffer and ax25_rt_build_path.
Unlike skb_realloc_headroom, new helper does not allocate a new skb if possible.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ax25/ax25_ip.c    |  4 +---
 net/ax25/ax25_out.c   | 13 +++----------
 net/ax25/ax25_route.c | 13 +++----------
 3 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/net/ax25/ax25_ip.c b/net/ax25/ax25_ip.c
index e4f63dd..3624977 100644
--- a/net/ax25/ax25_ip.c
+++ b/net/ax25/ax25_ip.c
@@ -193,10 +193,8 @@ netdev_tx_t ax25_ip_xmit(struct sk_buff *skb)
 	skb_pull(skb, AX25_KISS_HEADER_LEN);
 
 	if (digipeat != NULL) {
-		if ((ourskb = ax25_rt_build_path(skb, src, dst, route->digipeat)) == NULL) {
-			kfree_skb(skb);
+		if ((ourskb = ax25_rt_build_path(skb, src, dst, route->digipeat)) == NULL)
 			goto put;
-		}
 
 		skb = ourskb;
 	}
diff --git a/net/ax25/ax25_out.c b/net/ax25/ax25_out.c
index f53751b..22f2f66 100644
--- a/net/ax25/ax25_out.c
+++ b/net/ax25/ax25_out.c
@@ -325,7 +325,6 @@ void ax25_kick(ax25_cb *ax25)
 
 void ax25_transmit_buffer(ax25_cb *ax25, struct sk_buff *skb, int type)
 {
-	struct sk_buff *skbn;
 	unsigned char *ptr;
 	int headroom;
 
@@ -336,18 +335,12 @@ void ax25_transmit_buffer(ax25_cb *ax25, struct sk_buff *skb, int type)
 
 	headroom = ax25_addr_size(ax25->digipeat);
 
-	if (skb_headroom(skb) < headroom) {
-		if ((skbn = skb_realloc_headroom(skb, headroom)) == NULL) {
+	if (unlikely(skb_headroom(skb) < headroom)) {
+		skb = skb_expand_head(skb, headroom);
+		if (!skb) {
 			printk(KERN_CRIT "AX.25: ax25_transmit_buffer - out of memory\n");
-			kfree_skb(skb);
 			return;
 		}
-
-		if (skb->sk != NULL)
-			skb_set_owner_w(skbn, skb->sk);
-
-		consume_skb(skb);
-		skb = skbn;
 	}
 
 	ptr = skb_push(skb, headroom);
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index b40e0bc..d0b2e09 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -441,24 +441,17 @@ int ax25_rt_autobind(ax25_cb *ax25, ax25_address *addr)
 struct sk_buff *ax25_rt_build_path(struct sk_buff *skb, ax25_address *src,
 	ax25_address *dest, ax25_digi *digi)
 {
-	struct sk_buff *skbn;
 	unsigned char *bp;
 	int len;
 
 	len = digi->ndigi * AX25_ADDR_LEN;
 
-	if (skb_headroom(skb) < len) {
-		if ((skbn = skb_realloc_headroom(skb, len)) == NULL) {
+	if (unlikely(skb_headroom(skb) < len)) {
+		skb = skb_expand_head(skb, len);
+		if (!skb) {
 			printk(KERN_CRIT "AX.25: ax25_dg_build_path - out of memory\n");
 			return NULL;
 		}
-
-		if (skb->sk != NULL)
-			skb_set_owner_w(skbn, skb->sk);
-
-		consume_skb(skb);
-
-		skb = skbn;
 	}
 
 	bp = skb_push(skb, len);
-- 
1.8.3.1

