Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE8630AE49
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhBARpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbhBARmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:42:25 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6DDC06174A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 09:41:45 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 33so11943980pgv.0
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 09:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=WhoU2kUvRuKMZfhfUtEuI8scs93aknEYSDxR+JVYRps=;
        b=KU98d4krPaUHsAn32CGyAdUpfMcKfAapZLi1h3ETI4Xj2cS7ct5tAL0PBk3hNyh+4F
         f6C/L+DBV2fcxpoocnFtCLDzgBwqhGXFW6ud1+842/nqwdI+9r5VPoGxxwJGrKfH5lae
         dUmNB6zMv9UgKnJTBDW5Vi9at6S4Mqh6I/8LSC/kN8yqBZhVX/9IucdkYtFi7U5leEe7
         /rCvm03724Lsa3nzkzckikvsjoMGEOTQWejsyC/z8MrAkLzTR3gOZNBeS5N0ipPmnzB0
         2PHl0NtY47LwwgL4bfd7plCyaUyJCbcrbhm8pPdhnvyOT1XfIDzC6kVCwiMRJyULFAxR
         9SWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WhoU2kUvRuKMZfhfUtEuI8scs93aknEYSDxR+JVYRps=;
        b=uiza6Cjmaia64bEwMgGhoLI+1kmeaor726ZEzvZmEue28h5hWBMUiU6b6//cmoK2fz
         UmzIp0VvCGE/VAQZYJ346KxMJXq4wZUs0XvRHxyaGuD26ROtuk2ZWoakNnZUS43wRNWe
         AQLmCdEYllYONQhnnutlyteXgdFwDPe4jm8dTOQ9OAcup73hPovpCJpZwizRwzwCzF1g
         h0h+0ZCdLRkg7p36BMcBZjznWQfSa1XNtXacuB7RZ00RrbvRSpWhlLDCv7LLtXqrNP7R
         Ed8BayXxKjDfS8POlhF2jblpmwst8+QucqSqs8QfxnVTUHpudVyQBxUCQpsDfRx6bqH6
         t4Xg==
X-Gm-Message-State: AOAM5329T+JTXxOdMhvu6iuKlhJwf/YkMdlLE9IpzhAHsWZtn+938bQo
        pCtghbjjc3aAktLCBmBzQCbI2v5GxmZh
X-Google-Smtp-Source: ABdhPJxYsQxjrFxUSp6rGrQlYXbAoG2YgSnC1Ew0mkrettkb5q23dtZ2knuV71S2ho709iC7ldWQ2VAh4Up0
Sender: "brianvv via sendgmr" <brianvv@brianvv.c.googlers.com>
X-Received: from brianvv.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:348])
 (user=brianvv job=sendgmr) by 2002:a17:90a:3f08:: with SMTP id
 l8mr75900pjc.1.1612201304394; Mon, 01 Feb 2021 09:41:44 -0800 (PST)
Date:   Mon,  1 Feb 2021 17:41:31 +0000
In-Reply-To: <20210201174132.3534118-1-brianvv@google.com>
Message-Id: <20210201174132.3534118-4-brianvv@google.com>
Mime-Version: 1.0
References: <20210201174132.3534118-1-brianvv@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net-next v3 3/4] net: use indirect call helpers for dst_mtu
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch avoids the indirect call for the common case:
ip6_mtu and ipv4_mtu

Signed-off-by: Brian Vazquez <brianvv@google.com>
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
index 41d8f801b75f..4d83700d5602 100644
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
2.30.0.365.g02bc693789-goog

