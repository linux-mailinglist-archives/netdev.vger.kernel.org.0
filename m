Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5112D7590
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405932AbgLKM1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405899AbgLKM1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:27:40 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAE6C061248
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:26 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id a12so13065993lfl.6
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P3S4hFr4sUY3q9oJIspkv2JQh9Jprg+/KchwSNWk44w=;
        b=MBQgcXdxOWCH2B4vDU0nx25MIWrkYAOLyVL8t1eC1cRxA14QK0jHUT1wh/YTVz9Q1M
         3o15MNEFKlOQlfc1gJ/B6Q7GMyJccGxW6Ci2Z83Yk/iiyTYDW6lNrT5F9YIJEJTZfWrF
         T4KL22Sc29xqdnm5RGJcT8Lkhylxhoaf14V1yJ+9fjZttvFBFbAmaTpoIQpEwyl5r2Pw
         A/7k44mouXEaA3IVxxeVZJP5uFJbjxgIx8VfgrzaYANjqb9N7z1dbLt/Y/rYDsRAEnJ5
         YBAZnJ6sy6yoCy2yHES1O7uAEIZa1je8e/qdJDnJPhGVJfp8/yrunxw2Iew9sXflpFCx
         hvyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P3S4hFr4sUY3q9oJIspkv2JQh9Jprg+/KchwSNWk44w=;
        b=n5iW+TGaJxd+XthA5STuLzdmrIEmjzCfaODK8Cvc3vjsLm4eB4bha0RMK57z0Ac6vN
         3KcY01lRD+wkKptjoUmXWixAvkQsMu1dFMC1iEqyWJoxP6v4PQHxuMPONfAb4eXczPpC
         mzXY8+fJQGrwtcwQlO3RK0EUfPG7nZOMu5aLHgl9nnqdwMoUoRtj+Gc+dXuSeHnScqHJ
         kNkrpy7vpndssrxvXGeAQRXLGuwxbCzOl1gj5j65t6FASAJnqAZgO+BvkZ91fbBhvtGK
         cVP4V3TAfDW8SBmQj29N9FX2JGydrmbEyBQ5tALIMtDti7epvK/V3we3TmeF3QLQLP+G
         W1PA==
X-Gm-Message-State: AOAM531M8/n6118WkXUvow+HL05/kv/TX6Ma7MMUM8sQCvvSP/j7HLpr
        zig3pXnbKMW6lJR4a2BGrUAASnTHWl5pmQ==
X-Google-Smtp-Source: ABdhPJzPohI11G+HnJ/Twoe+TNrvdYtl8yb/GvwW/m3uRetacM+LsWbH8Ph11AByhqPvjLNrDski7A==
X-Received: by 2002:ac2:59c6:: with SMTP id x6mr4749108lfn.82.1607689584591;
        Fri, 11 Dec 2020 04:26:24 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id s8sm335818lfi.21.2020.12.11.04.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 04:26:24 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 12/12] gtp: add dst_cache to tunnels
Date:   Fri, 11 Dec 2020 13:26:12 +0100
Message-Id: <20201211122612.869225-13-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201211122612.869225-1-jonas@norrbonn.se>
References: <20201211122612.869225-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Destination caching on a per-tunnel basis is a performance win, so we
enable this unconditionally for the module.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/Kconfig |  1 +
 drivers/net/gtp.c   | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 260f9f46668b..f79277222125 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -276,6 +276,7 @@ config GTP
 	tristate "GPRS Tunneling Protocol datapath (GTP-U)"
 	depends on INET
 	select NET_UDP_TUNNEL
+	select DST_CACHE
 	help
 	  This allows one to create gtp virtual interfaces that provide
 	  the GPRS Tunneling Protocol datapath (GTP-U). This tunneling protocol
diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 40bbbe8cfad6..6708738681d2 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -64,6 +64,8 @@ struct pdp_ctx {
 	struct sock		*sk;
 	struct net_device       *dev;
 
+	struct dst_cache dst_cache;
+
 	atomic_t		tx_seq;
 	struct rcu_head		rcu_head;
 };
@@ -577,9 +579,15 @@ static struct rtable *gtp_get_v4_rt(struct sk_buff *skb,
 				    __be32 *saddr)
 {
 	const struct sock *sk = pctx->sk;
+	struct dst_cache *dst_cache;
 	struct rtable *rt = NULL;
 	struct flowi4 fl4;
 
+	dst_cache = (struct dst_cache *)&pctx->dst_cache;
+	rt = dst_cache_get_ip4(dst_cache, saddr);
+	if (rt)
+		return rt;
+
 	memset(&fl4, 0, sizeof(fl4));
 	fl4.flowi4_oif		= sk->sk_bound_dev_if;
 	fl4.daddr		= ipv4(&pctx->peer_addr);
@@ -600,6 +608,8 @@ static struct rtable *gtp_get_v4_rt(struct sk_buff *skb,
 
 	*saddr = fl4.saddr;
 
+	dst_cache_set_ip4(dst_cache, &rt->dst, *saddr);
+
 	return rt;
 }
 
@@ -610,8 +620,14 @@ static struct dst_entry *gtp_get_v6_dst(struct sk_buff *skb,
 {
 	const struct sock *sk = pctx->sk;
 	struct dst_entry *dst = NULL;
+	struct dst_cache *dst_cache;
 	struct flowi6 fl6;
 
+	dst_cache = (struct dst_cache *)&pctx->dst_cache;
+	dst = dst_cache_get_ip6(dst_cache, saddr);
+	if (dst)
+		return dst;
+
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.flowi6_mark = skb->mark;
 	fl6.flowi6_proto = IPPROTO_UDP;
@@ -630,6 +646,8 @@ static struct dst_entry *gtp_get_v6_dst(struct sk_buff *skb,
 
 	*saddr = fl6.saddr;
 
+	dst_cache_set_ip6(dst_cache, dst, saddr);
+
 	return dst;
 }
 
@@ -1236,6 +1254,8 @@ static void pdp_fill(struct pdp_ctx *pctx, struct genl_info *info)
 	pctx->gtp_version = nla_get_u32(info->attrs[GTPA_VERSION]);
 	pctx->flags = 0;
 
+	dst_cache_reset(&pctx->dst_cache);
+
 	if (info->attrs[GTPA_PEER_IPV6]) {
 		pctx->flags |= PDP_F_PEER_V6;
 		pctx->peer_addr = nla_get_in6_addr(info->attrs[GTPA_PEER_IPV6]);
@@ -1331,6 +1351,11 @@ static struct pdp_ctx *gtp_pdp_add(struct gtp_dev *gtp, struct sock *sk,
 	if (pctx == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	if (dst_cache_init(&pctx->dst_cache, GFP_ATOMIC)) {
+		kfree(pctx);
+		return ERR_PTR(-ENOBUFS);
+	}
+
 	sock_hold(sk);
 	pctx->sk = sk;
 	pctx->dev = gtp->dev;
@@ -1374,6 +1399,8 @@ static void pdp_context_free(struct rcu_head *head)
 {
 	struct pdp_ctx *pctx = container_of(head, struct pdp_ctx, rcu_head);
 
+	dst_cache_destroy(&pctx->dst_cache);
+
 	sock_put(pctx->sk);
 	kfree(pctx);
 }
-- 
2.27.0

