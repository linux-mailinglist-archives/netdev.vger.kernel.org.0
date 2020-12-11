Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908B52D82C9
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 00:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437294AbgLKXfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 18:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437381AbgLKXfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 18:35:05 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F02C0617A7
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 15:33:49 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id y10so6137022pll.20
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 15:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=thwvCtn6LNG/FDpSFGyZ6Wmg72wk3C6bCvqdBXCPvKo=;
        b=FIuaksvGvkKtX+5FR+B0iR8RemWNhfGv00aXcmWx8E7IqNojRQ/hCyAgrVB6t4vBvA
         Dp/sBQYWuuxyY4vOQPLhFsSWuPzY1W2rP9wIeClP0zjHixs0EpW3griB4K22dqhOaPhE
         O68J55M/2qwYoltluFqVfLAH5GpRu+x+LkteVfKPIxA1MXPtTSlqpTNcoT+2vAt5iOTN
         AMyrCt82xJZTJaPxS5KCCCQfvyRZ4yUpMo5s2b3mJ/16UWqATWP1yQApz4iTbbjjS5Ty
         IG9lxEUCtglX9dbAfG2d18aTmeqIBPXKQS+tMjtlVmN884emGJEAFZumdAr0lvcqG/vV
         +j2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=thwvCtn6LNG/FDpSFGyZ6Wmg72wk3C6bCvqdBXCPvKo=;
        b=axsff9VK2EJ+s1aySGz8WASYe4VbYvIrSvs6I+NJku+rNzjzaF4A3NNmT8d1Ch5uKM
         l5p/vgiosCv1e/SdVNPwMopUyA7D+46r5cQ2Izo9BtdpjE/XuHgU2RjF0g1mjNeJ/+IY
         SfsDlyae/UoevhMNvZmsklXdAc+kbtSq8elptZsev32RhVGWfzqUxJvyWFFWE3om1Pp3
         33xI75IlbMfdvxk0ykY3z/7EdK4p32C2zgvgamcjGYwKKIzXVUmaScpntXSIa334TNlc
         Lr7BxGJrOvK/RU1Zta83THkiOzg+vcafaTO9bYVGDGm2wrMryj6POWvOhN1hw35FbRpJ
         TPAQ==
X-Gm-Message-State: AOAM532yNFWP88t7X1moKgTzp+mEEiWE1Agu15g/XizE7Ng7d4riz7Ec
        8kK20dbEGS9UImU0HWqswk20DetxfAwg
X-Google-Smtp-Source: ABdhPJwEhcxHUBsZCXOR0qWmolDifG0WHmKorUeyRqRrsQBeJ4iTvOvSWPUW+MyMfpGIBIP7KaLLnyVlMOpn
Sender: "brianvv via sendgmr" <brianvv@brianvv.c.googlers.com>
X-Received: from brianvv.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:348])
 (user=brianvv job=sendgmr) by 2002:a62:1d10:0:b029:163:deb3:5df2 with SMTP id
 d16-20020a621d100000b0290163deb35df2mr13787965pfd.68.1607729628547; Fri, 11
 Dec 2020 15:33:48 -0800 (PST)
Date:   Fri, 11 Dec 2020 23:33:39 +0000
In-Reply-To: <20201211233340.1503242-1-brianvv@google.com>
Message-Id: <20201211233340.1503242-4-brianvv@google.com>
Mime-Version: 1.0
References: <20201211233340.1503242-1-brianvv@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net-next v2 3/4] net: use indirect call helpers for dst_mtu
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: brianvv <brianvv@google.com>

This patch avoids the indirect call for the common case:
ip6_mtu and ipv4_mtu

Signed-off-by: brianvv <brianvv@google.com>
---
 include/net/dst.h | 4 +++-
 net/ipv4/route.c  | 6 ++++--
 net/ipv6/route.c  | 6 ++++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 3932e9931f08..9f474a79ed7d 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -194,9 +194,11 @@ dst_feature(const struct dst_entry *dst, u32 feature)
 	return dst_metric(dst, RTAX_FEATURES) & feature;
 }
 
+INDIRECT_CALLABLE_DECLARE(unsigned int ip6_mtu(const struct dst_entry *));
+INDIRECT_CALLABLE_DECLARE(unsigned int ipv4_mtu(const struct dst_entry *));
 static inline u32 dst_mtu(const struct dst_entry *dst)
 {
-	return dst->ops->mtu(dst);
+	return INDIRECT_CALL_INET(dst->ops->mtu, ip6_mtu, ipv4_mtu, dst);
 }
 
 /* RTT metrics are stored in milliseconds for user ABI, but used as jiffies */
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index e26652ff7059..4fac91f8bd6c 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -135,7 +135,8 @@ static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
 
 static struct dst_entry *ipv4_dst_check(struct dst_entry *dst, u32 cookie);
 static unsigned int	 ipv4_default_advmss(const struct dst_entry *dst);
-static unsigned int	 ipv4_mtu(const struct dst_entry *dst);
+INDIRECT_CALLABLE_SCOPE
+unsigned int		ipv4_mtu(const struct dst_entry *dst);
 static struct dst_entry *ipv4_negative_advice(struct dst_entry *dst);
 static void		 ipv4_link_failure(struct sk_buff *skb);
 static void		 ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
@@ -1311,7 +1312,7 @@ static unsigned int ipv4_default_advmss(const struct dst_entry *dst)
 	return min(advmss, IPV4_MAX_PMTU - header_size);
 }
 
-static unsigned int ipv4_mtu(const struct dst_entry *dst)
+INDIRECT_CALLABLE_SCOPE unsigned int ipv4_mtu(const struct dst_entry *dst)
 {
 	const struct rtable *rt = (const struct rtable *)dst;
 	unsigned int mtu = rt->rt_pmtu;
@@ -1333,6 +1334,7 @@ static unsigned int ipv4_mtu(const struct dst_entry *dst)
 
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
+EXPORT_SYMBOL(ipv4_mtu);
 
 static void ip_del_fnhe(struct fib_nh_common *nhc, __be32 daddr)
 {
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 188e114b29b4..22caee290b6c 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -83,7 +83,8 @@ enum rt6_nud_state {
 
 static struct dst_entry	*ip6_dst_check(struct dst_entry *dst, u32 cookie);
 static unsigned int	 ip6_default_advmss(const struct dst_entry *dst);
-static unsigned int	 ip6_mtu(const struct dst_entry *dst);
+INDIRECT_CALLABLE_SCOPE
+unsigned int		ip6_mtu(const struct dst_entry *dst);
 static struct dst_entry *ip6_negative_advice(struct dst_entry *);
 static void		ip6_dst_destroy(struct dst_entry *);
 static void		ip6_dst_ifdown(struct dst_entry *,
@@ -3089,7 +3090,7 @@ static unsigned int ip6_default_advmss(const struct dst_entry *dst)
 	return mtu;
 }
 
-static unsigned int ip6_mtu(const struct dst_entry *dst)
+INDIRECT_CALLABLE_SCOPE unsigned int ip6_mtu(const struct dst_entry *dst)
 {
 	struct inet6_dev *idev;
 	unsigned int mtu;
@@ -3111,6 +3112,7 @@ static unsigned int ip6_mtu(const struct dst_entry *dst)
 
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
+EXPORT_SYMBOL(ip6_mtu);
 
 /* MTU selection:
  * 1. mtu on route is locked - use it
-- 
2.29.2.576.ga3fc446d84-goog

