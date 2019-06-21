Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA2C74DE1D
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 02:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfFUAhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 20:37:08 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36108 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbfFUAhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 20:37:06 -0400
Received: by mail-pf1-f195.google.com with SMTP id r7so2621135pfl.3
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 17:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2F/7HrSaq4HN4leZCeGphvq0LzpgNEDY/DjINVDcoZ8=;
        b=s0utfgVBSfdkUFA8M67pmmCMOjqOkgobg/RdNFRuq6xyoFp+P74J9XW9DaMczzNKJ1
         MXV4UWjKTFNnpLwyXgdrOaIgmdMcErkmcpwd+/t4DeUeYtxPTAwTNIzoLlv0F70liEbS
         Dfz1SVEO75pnYlJsI1GroHqdLk21hV4eA4ZaRG8vCbHsJ4RqAnJO/loWnHXBDMKxVtFs
         unjyvkq/Yqb1C/WZ8sv/UHRsYLFLSmov8oVFhTzD8o2N1j/G+/ml9DL44S48MUqUSBBC
         oQJVs78b4sW4pmRM9vBGQ+FHr6T9J9TIeTouFbZlkFip5RH2nC7Vo+O1VGRLWFjKAU/k
         oSbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2F/7HrSaq4HN4leZCeGphvq0LzpgNEDY/DjINVDcoZ8=;
        b=bWtn0bmH4T0qzKqulm+QQFf9sBwK6kew4M67O1reegbu/BSUdoufrGFILrfBzy/io/
         1q2lga2opI7+SlfNozMJFkwgnD75EbA8skoVTOLNRmknxrGPLwVwhl5CTC4Gz9lAGc5g
         FkHflL7tLKWcf++G/dMAzBmzqGu5VDs+4fxPKKQKeIMXRL9oLJJ04Y2G99qvWf+8J8l3
         tHOP8e+r2Hb96256UyRo1So896XtPv2Exj/qq5q+R6gKzp65NSkyK+vmW0mDvmYdYP4w
         pdYtbvrrsbeBItgdXi4K83vwOpRt2e8f1kzgtI8IxCYAG0uFN6eMC1WQO3s/OLYaJuOD
         PR5A==
X-Gm-Message-State: APjAAAWgp3aDg+cQCkUGJBVrmCjUTeZCYNzy80zSlv5dPYRjlvPcNG+m
        OwvApCgjsT9HBPrX/qehjR4=
X-Google-Smtp-Source: APXvYqxxVOv3Q+okGzLPsOXVmhllBbFTniqMCp9Vyz/NnKBBn80igoMEljR5rBnYfxDhnDTLZ+BeiA==
X-Received: by 2002:a65:500d:: with SMTP id f13mr15067563pgo.151.1561077425898;
        Thu, 20 Jun 2019 17:37:05 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id 2sm588206pff.174.2019.06.20.17.37.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 17:37:05 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Wei Wang <weiwan@google.com>
Subject: [PATCH v3 net-next 4/5] ipv6: convert rx data path to not take refcnt on dst
Date:   Thu, 20 Jun 2019 17:36:40 -0700
Message-Id: <20190621003641.168591-5-tracywwnj@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190621003641.168591-1-tracywwnj@gmail.com>
References: <20190621003641.168591-1-tracywwnj@gmail.com>
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

