Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97CDC4A9C9
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbfFRS02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:26:28 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34098 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfFRS02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:26:28 -0400
Received: by mail-pf1-f195.google.com with SMTP id c85so8148660pfc.1
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 11:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2F/7HrSaq4HN4leZCeGphvq0LzpgNEDY/DjINVDcoZ8=;
        b=pulipwSIt/lrwx7JUaUosKVgEhtOf+VjX9gGmlhll9DH3l7tXU92D3uq8+DHXYhExa
         9gKOYUVDNFjLZs+FdL+5Wb3jRHvwdRahCSjSikfNuJ7EJDJkiuubTu5TBnFUfczx8r6I
         RXCLqutLSUuCWysiKgVjCP0V5v8rwNFptC0k9r1QEqhnQvucFaASRfL9xeQgipSYIuC7
         CZaJKBIF8OcC0vjKgiB+GM0mQ7Y88Flys9zeyoAvzlMnw0Ac23lgre+iaeSsgXmgiSop
         d8x53M0yKnBP2pxEPpFOX3wEpatMqxmZz7xuXQlrczGnWDXRQBXO52idq57NIaOdX/8N
         Gx1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2F/7HrSaq4HN4leZCeGphvq0LzpgNEDY/DjINVDcoZ8=;
        b=tqTtzsOtGsHrFIxvEiuc79tAM9EeuemqOjOZmXvbPzEb+zYMxZhWNOF5vpMzUj8st3
         35o7LdcxY0XbJlN/F/OGrZLdwo9LsrabMJ53ixUFezZQ5rRkAnSgjV3+jBstqaHwNwlF
         lCzHJcIH6aswjdMU9CMrFXAPr/i5+oICJ7xLp/OwAM6X32tzrQgl1yKKoxzvKcls33vB
         snN4Pp+zu2vrVeAuzFWA+puqhYjy9Ar4mlc86oBAyys0alrgzMc7aPHD3/mOlyHKTPxl
         fpbHd84XMptxE0rO6NdVOdpLHzQOaenZAGM3TdUPeSzJLf/Tn94aq8OsqsS6GyxRGEuX
         1okQ==
X-Gm-Message-State: APjAAAXx8Zxt4+iMnRk+kCCrBwfJihzj6YUR/L27lCeXeIYotD4Q2Ou6
        nrFJm6qwfsvvCEQCb8E6ywY=
X-Google-Smtp-Source: APXvYqxGjcXqkq54Gk/99CGJjkIra4Up16/1Akpfa2xbWfMs+jRE4owj6dZ3xcsqdu3fFQXbE+e/JA==
X-Received: by 2002:aa7:97bb:: with SMTP id d27mr53458685pfq.93.1560882387398;
        Tue, 18 Jun 2019 11:26:27 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id h6sm2845859pjs.2.2019.06.18.11.26.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 11:26:26 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        David Ahern <dsahern@gmail.com>, Wei Wang <weiwan@google.com>
Subject: [PATCH net-next 4/5] ipv6: convert rx data path to not take refcnt on dst
Date:   Tue, 18 Jun 2019 11:25:42 -0700
Message-Id: <20190618182543.65477-5-tracywwnj@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190618182543.65477-1-tracywwnj@gmail.com>
References: <20190618182543.65477-1-tracywwnj@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>

ip6_route_input() is the key function to do the route lookup in the
rx data path. All the callers to this function are already holding rcu
lock. So it is fairly easy to convert it to not take refcnt on the dst:
We pass in flag RT6_LOOKUP_F_DST_NOREF and do skb_dst_set_noref().
This saves a few atomic inc or dec operations and should boost
performance overall.
This also makes the logic more aligned with v4.

Signed-off-by: Wei Wang <weiwan@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
---
 net/ipv6/route.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 33dc8af9a4bf..d2b287635aab 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2375,11 +2375,12 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 	return mhash >> 1;
 }
 
+/* Called with rcu held */
 void ip6_route_input(struct sk_buff *skb)
 {
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct net *net = dev_net(skb->dev);
-	int flags = RT6_LOOKUP_F_HAS_SADDR;
+	int flags = RT6_LOOKUP_F_HAS_SADDR | RT6_LOOKUP_F_DST_NOREF;
 	struct ip_tunnel_info *tun_info;
 	struct flowi6 fl6 = {
 		.flowi6_iif = skb->dev->ifindex,
@@ -2401,8 +2402,8 @@ void ip6_route_input(struct sk_buff *skb)
 	if (unlikely(fl6.flowi6_proto == IPPROTO_ICMPV6))
 		fl6.mp_hash = rt6_multipath_hash(net, &fl6, skb, flkeys);
 	skb_dst_drop(skb);
-	skb_dst_set(skb,
-		    ip6_route_input_lookup(net, skb->dev, &fl6, skb, flags));
+	skb_dst_set_noref(skb, ip6_route_input_lookup(net, skb->dev,
+						      &fl6, skb, flags));
 }
 
 static struct rt6_info *ip6_pol_route_output(struct net *net,
-- 
2.22.0.410.gd8fdbe21b5-goog

