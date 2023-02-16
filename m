Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03B6699A02
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBPQ3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjBPQ3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:29:15 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25635442CE
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:14 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-532e96672b3so25756737b3.13
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xaHOszewmcG/9H5yxJLH8P54Tg1PRq8Bi3Xvki6MWRs=;
        b=qzGfILrcEYGOH0VsrBw6pIPNjj7S7JEb4xE0J22LVnFSP2bY3Xu8KQjsW/jrkaL/qk
         /a5cf/kt3gsH/9QLS/zRrHhOTl34pmOXak4P/pyauFet5rtcfCaqxjioXQIfNC92Yi8u
         1hWmmsst1aGrRPgwScgM11Sv4MVe9yxw0UNgUlZLZJyuSwVYbYG9YtYLThfHMoP96xiR
         WAZUfbrPJXtQRQS/T7x5md4AntJVu6PTbok41dZmXO0Jp5hJUcN4c/zlCmFpFpOusj+q
         G0RLHMq+p5mLIlyC+9wjPTmm+jBOhjZ0R8UBjoiv6nM9K/J/GP4UD80+7seAiUgR5nlC
         wH/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xaHOszewmcG/9H5yxJLH8P54Tg1PRq8Bi3Xvki6MWRs=;
        b=jTodJPaAGXFT4xf26hmthmuRuLrh+On5rJyiE5cBaTypaSdXtN6qRnAx2HHb8iXA6k
         vJ6J0CbEHPAFfq8r5EUcOk97Mp993ca7oZNterqhOXJnw/wD+wa8c4mcNFNnfyTGlHyH
         d/okYGpZ6QYp2835nx7H6CFJjYMVRlYggQt2mWz+zp3oumqIeG6sUqrQCY3zmRkfkjgH
         QQaNsKfM0Vo78MTxqKI/xxwBbdhRlf0eXrVqJTV3CyWwXo9ruQe0sPB7wAU1QLSMpek1
         NPjLdlymQVN9Lon198z/iFh0vsEcmlD66D2q9+1aV7abjTa3s5ov61ELisfevtQe5JL/
         ruyg==
X-Gm-Message-State: AO0yUKX3KOFWLv7ct4FlIcHc3dVAi+1ks5OReqi78D4timibu0nG7Pha
        6h4Hpz8fqTyrN/N+SHqykM43uPSWv4LR7A==
X-Google-Smtp-Source: AK7set8XoErGLDR1+YAY3hF3OrtqH41/YuE2OVzIBKO981g2GZOLAM+QdIYho+2sLN23b09AWNjeGwp/C4Rw0A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:802:0:b0:92a:dcf8:c83f with SMTP id
 x2-20020a5b0802000000b0092adcf8c83fmr630568ybp.120.1676564953336; Thu, 16 Feb
 2023 08:29:13 -0800 (PST)
Date:   Thu, 16 Feb 2023 16:28:35 +0000
In-Reply-To: <20230216162842.1633734-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230216162842.1633734-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230216162842.1633734-2-edumazet@google.com>
Subject: [PATCH net-next 1/8] ipv6: icmp6: add drop reason support to ndisc_recv_ns()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change ndisc_recv_ns() to return a drop reason.

For the moment, return PKT_TOO_SMALL, NOT_SPECIFIED
or SKB_CONSUMED.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ndisc.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 9548b5a44714f98975a8b7194bc81cbb0f72697f..039722f83c668ad59eb63ffde98e18ad8947bdcc 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -783,7 +783,7 @@ void ndisc_update(const struct net_device *dev, struct neighbour *neigh,
 	ndisc_ops_update(dev, neigh, flags, icmp6_type, ndopts);
 }
 
-static void ndisc_recv_ns(struct sk_buff *skb)
+static enum skb_drop_reason ndisc_recv_ns(struct sk_buff *skb)
 {
 	struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
 	const struct in6_addr *saddr = &ipv6_hdr(skb)->saddr;
@@ -797,18 +797,17 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 	struct inet6_dev *idev = NULL;
 	struct neighbour *neigh;
 	int dad = ipv6_addr_any(saddr);
-	bool inc;
 	int is_router = -1;
+	SKB_DR(reason);
 	u64 nonce = 0;
+	bool inc;
 
-	if (skb->len < sizeof(struct nd_msg)) {
-		ND_PRINTK(2, warn, "NS: packet too short\n");
-		return;
-	}
+	if (skb->len < sizeof(struct nd_msg))
+		return SKB_DROP_REASON_PKT_TOO_SMALL;
 
 	if (ipv6_addr_is_multicast(&msg->target)) {
 		ND_PRINTK(2, warn, "NS: multicast target address\n");
-		return;
+		return reason;
 	}
 
 	/*
@@ -817,12 +816,12 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 	 */
 	if (dad && !ipv6_addr_is_solict_mult(daddr)) {
 		ND_PRINTK(2, warn, "NS: bad DAD packet (wrong destination)\n");
-		return;
+		return reason;
 	}
 
 	if (!ndisc_parse_options(dev, msg->opt, ndoptlen, &ndopts)) {
 		ND_PRINTK(2, warn, "NS: invalid ND options\n");
-		return;
+		return reason;
 	}
 
 	if (ndopts.nd_opts_src_lladdr) {
@@ -830,7 +829,7 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 		if (!lladdr) {
 			ND_PRINTK(2, warn,
 				  "NS: invalid link-layer address length\n");
-			return;
+			return reason;
 		}
 
 		/* RFC2461 7.1.1:
@@ -841,7 +840,7 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 		if (dad) {
 			ND_PRINTK(2, warn,
 				  "NS: bad DAD packet (link-layer address option)\n");
-			return;
+			return reason;
 		}
 	}
 	if (ndopts.nd_opts_nonce && ndopts.nd_opts_nonce->nd_opt_len == 1)
@@ -869,7 +868,7 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 				 * so fail our DAD process
 				 */
 				addrconf_dad_failure(skb, ifp);
-				return;
+				return reason;
 			} else {
 				/*
 				 * This is not a dad solicitation.
@@ -901,7 +900,7 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 		idev = in6_dev_get(dev);
 		if (!idev) {
 			/* XXX: count this drop? */
-			return;
+			return reason;
 		}
 
 		if (ipv6_chk_acast_addr(net, dev, &msg->target) ||
@@ -958,6 +957,7 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 			      true, (ifp != NULL && inc), inc);
 		if (neigh)
 			neigh_release(neigh);
+		reason = SKB_CONSUMED;
 	}
 
 out:
@@ -965,6 +965,7 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 		in6_ifa_put(ifp);
 	else
 		in6_dev_put(idev);
+	return reason;
 }
 
 static int accept_untracked_na(struct net_device *dev, struct in6_addr *saddr)
@@ -1781,8 +1782,9 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 
 static void pndisc_redo(struct sk_buff *skb)
 {
-	ndisc_recv_ns(skb);
-	kfree_skb(skb);
+	enum skb_drop_reason reason = ndisc_recv_ns(skb);
+
+	kfree_skb_reason(skb, reason);
 }
 
 static int ndisc_is_multicast(const void *pkey)
@@ -1834,7 +1836,7 @@ enum skb_drop_reason ndisc_rcv(struct sk_buff *skb)
 	switch (msg->icmph.icmp6_type) {
 	case NDISC_NEIGHBOUR_SOLICITATION:
 		memset(NEIGH_CB(skb), 0, sizeof(struct neighbour_cb));
-		ndisc_recv_ns(skb);
+		reason = ndisc_recv_ns(skb);
 		break;
 
 	case NDISC_NEIGHBOUR_ADVERTISEMENT:
-- 
2.39.1.581.gbfd45094c4-goog

