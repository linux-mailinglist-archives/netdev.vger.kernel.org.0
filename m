Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBB814C3A4
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 00:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbfFSWcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 18:32:19 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45586 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730259AbfFSWcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 18:32:16 -0400
Received: by mail-pg1-f195.google.com with SMTP id s21so421046pga.12
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 15:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2F/7HrSaq4HN4leZCeGphvq0LzpgNEDY/DjINVDcoZ8=;
        b=TdjyCxLKljYJgdc3avWSMPBdR3f/4Rd6iJpo9SpTQe1k7YBmtwTHjSDr2+WTf1HjOh
         ciqeBJPzZ3dAZ+FLAR4qRk6TWZWI6hgzI7v+xSyQNJC0wGpMqQjDUNddyuwek+m+z1cE
         1rkgLIYUTECr6wBGP3cAIvvp+5ptMjL/HDiYrgvoO8xFSFXQ1DPx9s6zUQDSgUbqdO1B
         l1g7CBA+75hYKABOWfpvSo9mZdecfbFe+4Uz+rVYSgVJWxrvq7cNGaEgOeMnFbJXoObq
         KmZU4jeAItFAZMLxvILzhjMOUZ6q3y7kRxFk/Rxrj3aCOjxjFUiK+meC6ez9l+pP1puS
         RAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2F/7HrSaq4HN4leZCeGphvq0LzpgNEDY/DjINVDcoZ8=;
        b=h+Oz28rVKqcNxNNBTk8ctO2ADUkDsa3siXUY5J3PozXUGq+rvNEX3O9ZZPCPVwawsC
         +6PkKCp6/En/0/eDP4Vkbt/fb3VR8ZYehtsVFEKwZniiffNaxiZ1nYp7rG7XNDKJkyJh
         xdt23PtYBV/nDPqDektSJC6LnREqnx/swtck+ccThN8uB+ILvbrMNbKiT8g+zNI3tikQ
         APCcoIvAQ1In2EyJqjiDTGMKlidOYss6AZyqL3OqaJ+srCw5xE32dOtfNgv+yRj/Ck2W
         w1j8EorkP3C620ueFjBCMXTtFEARh/s6OLDlo6y1hJ2+g37KlpfsIWalRNy5j9JJt3sP
         ibTA==
X-Gm-Message-State: APjAAAV3AqEtW1YSCqWAQcNDwNUljISgLNR4Jf/jJ9hdXJ4fTF1DIZH3
        8q0ExyWL0mesO4Kepw7VLug=
X-Google-Smtp-Source: APXvYqzKlFLjUHKssMHCPrxwAPvpEVn0K94MJzc4K+cYQAOLEkApGJKyYGgj2Auf6VXXenH4xN0yPg==
X-Received: by 2002:a17:90b:d8b:: with SMTP id bg11mr13647863pjb.30.1560983535930;
        Wed, 19 Jun 2019 15:32:15 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id g8sm20037687pgd.29.2019.06.19.15.32.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 15:32:15 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>, Wei Wang <weiwan@google.com>
Subject: [PATCH v2 net-next 4/5] ipv6: convert rx data path to not take refcnt on dst
Date:   Wed, 19 Jun 2019 15:31:57 -0700
Message-Id: <20190619223158.35829-5-tracywwnj@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190619223158.35829-1-tracywwnj@gmail.com>
References: <20190619223158.35829-1-tracywwnj@gmail.com>
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

