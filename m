Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC44A2D6DE1
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 03:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391711AbgLKCAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 21:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391602AbgLKB7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 20:59:50 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1670AC0617A6
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 17:58:35 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id f11so5357602qth.23
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 17:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=thwvCtn6LNG/FDpSFGyZ6Wmg72wk3C6bCvqdBXCPvKo=;
        b=a8/DNSDqSFYuM4vlu1Nh8GoAoU/a0wAqBG4bORngP+gURnE0AIhr6hxeKYy6LArvlv
         ngaB6UXYn8N24qxxq/ph04+wGnd9v1eLX+q+K8p2B2WDfXPexQ5H2ZmUmov+o2DfryuW
         0WWg1W7ZjOEiJDkjl2gCn/iZk98tXAGcAZet5pHYZrFa9+PT0XA4e6Eu2Ecl9trOJ12G
         NpypZ/VaR82IQg8Mg1NlyoW4qaKry964GMsxWjwpDXslPje6NNyeCnMIEjwHSyCJlOD4
         eNAN6xxSAPl1078mCOnMpBLF3/T00FMtkQJsx6Kho6h9249YPNfu+k2D9P/cxccqzJVj
         y15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=thwvCtn6LNG/FDpSFGyZ6Wmg72wk3C6bCvqdBXCPvKo=;
        b=RmAA5YsAdK316s2KH1+ucWtsxQIupeUpJ/N5x/dF5RRJbRhMwHWbU3dIJQtrwOR11D
         UFadA7iWdx1UYW4by4s5FMYl04rZWv8rInhsTZCP+O3Kyern8BJFUCSHMgxrxqi4yWcz
         G4W8bPkDA9Oo3R0rSS6c1etVdCWFiN/Yp21cOIG+b5XdpaTQVB61EGCbsHDTVWmz8gPA
         yiUT1Tao863pLCrk5U78/qQhpjn5hToucMWkXrO0gOldmFybz61hIyXi+jou6Gh5cOMk
         0iH3XmGfiUKMVxDvAKylT7zY+kpDxLgFagLTLsGvKCBMiFYaRutP5UHdwkfEdtzm3D7m
         7Dpw==
X-Gm-Message-State: AOAM532UWefJW1+ZWfbi4QJaYTAoRYtYMveNd0FLyA75cnZTKYOcTmT4
        gejlNi7P31wH2EF4rbQGsCkNQSZ944uF
X-Google-Smtp-Source: ABdhPJx7gsbztHObw/y4GRJUsg39iVn+hJbBAH5jUIDp67itH5xGkV2prSgrsFigpVawrfizaleNQH+GKtaq
Sender: "brianvv via sendgmr" <brianvv@brianvv.c.googlers.com>
X-Received: from brianvv.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:348])
 (user=brianvv job=sendgmr) by 2002:a0c:f20f:: with SMTP id
 h15mr12835454qvk.54.1607651914229; Thu, 10 Dec 2020 17:58:34 -0800 (PST)
Date:   Fri, 11 Dec 2020 01:58:22 +0000
In-Reply-To: <20201211015823.1079574-1-brianvv@google.com>
Message-Id: <20201211015823.1079574-4-brianvv@google.com>
Mime-Version: 1.0
References: <20201211015823.1079574-1-brianvv@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net-next 3/4] net: use indirect call helpers for dst_mtu
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

