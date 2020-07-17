Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652D022397E
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgGQKg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgGQKfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 06:35:50 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FE9C061755
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:35:49 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id e8so12071828ljb.0
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ptxfL7Xr1J07+Gsn5ltxunp+d5SmfRGnPLIhAz/tBZI=;
        b=WZEizxpSHnPfVeUN6j85UgDJCENDmPrhfAJatcgRr4taObmvxVKW6h1psigR2SjKjQ
         BrdLX1l1QvSIbHNCH6PCPKkMXDnN2ncHKYkvAmV8UjDKcdYzOqYnEPkgRMiE8D1X3BIY
         0mGZcS+2MlOMDinJpNgkAY8ixfcsqAvJ35X/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ptxfL7Xr1J07+Gsn5ltxunp+d5SmfRGnPLIhAz/tBZI=;
        b=nPOHClWBVi+2/XZpNPzyQebt7tE9X5CGc5rv0728KIGj0yqcmC7jRg0hspQuUAZFIS
         QT/L0hTzlJJFNtfJBTYvqaYtNUePT6JrqcD7VpShjBoaqSMNSVpOQ825hSckPWRnYhf3
         jcEV6Sw5+fnG2y1pO4mwUEqrAqEEHegaE+KO+gSDHiZ2FR+Vhqpt92DdTYE5+s97St6T
         75OIo5O9MhEGhpNu8+WU6htKzSCSFffIpnUl9q0CJD0J9dK8mGwOwZeJfrjlEdgqOn4B
         04w+YlF8aGwRQ17trjhqlE6GdRLEig5pt1fO55NhQejfh8VvCO7XlCMA+7mRgfZLFT39
         U1ww==
X-Gm-Message-State: AOAM530e9yvqdmNwgldYsuAv3gc98BskQ5liPzGo808vOk7yin7+j9Xk
        5yG6P5ZpALXaXA2IzRF9vNGV5w==
X-Google-Smtp-Source: ABdhPJyEc0jNYlYwFHH07V0WXjTL6zfRYkBLfJcXB3owc/qEnoACnY4//X7dmO3ZznkKxwl09eUscA==
X-Received: by 2002:a2e:9619:: with SMTP id v25mr4347063ljh.324.1594982147820;
        Fri, 17 Jul 2020 03:35:47 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id d23sm1787621lfm.85.2020.07.17.03.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 03:35:47 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH bpf-next v5 06/15] inet6: Run SK_LOOKUP BPF program on socket lookup
Date:   Fri, 17 Jul 2020 12:35:27 +0200
Message-Id: <20200717103536.397595-7-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200717103536.397595-1-jakub@cloudflare.com>
References: <20200717103536.397595-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following ipv4 stack changes, run a BPF program attached to netns before
looking up a listening socket. Program can return a listening socket to use
as result of socket lookup, fail the lookup, or take no action.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v5:
    - Simplify prog runners now that only SK_DROP/PASS can be returned.
    
    v4:
    - Adapt to changes in BPF prog return codes.
    - Invert return value from bpf_sk_lookup_run_v6 to true on skip reuseport.
    
    v3:
    - Use a static_key to minimize the hook overhead when not used. (Alexei)
    - Don't copy struct in6_addr when populating BPF prog context. (Martin)
    - Adapt for running an array of attached programs. (Alexei)
    - Adapt for optionally skipping reuseport selection. (Martin)

 include/linux/filter.h      | 39 +++++++++++++++++++++++++++++++++++++
 net/ipv6/inet6_hashtables.c | 35 +++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index c4f54c216347..8252572db918 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1386,4 +1386,43 @@ static inline bool bpf_sk_lookup_run_v4(struct net *net, int protocol,
 	return no_reuseport;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
+					const struct in6_addr *saddr,
+					const __be16 sport,
+					const struct in6_addr *daddr,
+					const u16 dport,
+					struct sock **psk)
+{
+	struct bpf_prog_array *run_array;
+	struct sock *selected_sk = NULL;
+	bool no_reuseport = false;
+
+	rcu_read_lock();
+	run_array = rcu_dereference(net->bpf.run_array[NETNS_BPF_SK_LOOKUP]);
+	if (run_array) {
+		struct bpf_sk_lookup_kern ctx = {
+			.family		= AF_INET6,
+			.protocol	= protocol,
+			.v6.saddr	= saddr,
+			.v6.daddr	= daddr,
+			.sport		= sport,
+			.dport		= dport,
+		};
+		u32 act;
+
+		act = BPF_PROG_SK_LOOKUP_RUN_ARRAY(run_array, ctx, BPF_PROG_RUN);
+		if (act == SK_PASS) {
+			selected_sk = ctx.selected_sk;
+			no_reuseport = ctx.no_reuseport;
+		} else {
+			selected_sk = ERR_PTR(-ECONNREFUSED);
+		}
+	}
+	rcu_read_unlock();
+	*psk = selected_sk;
+	return no_reuseport;
+}
+#endif /* IS_ENABLED(CONFIG_IPV6) */
+
 #endif /* __LINUX_FILTER_H__ */
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 03942eef8ab6..2d3add9e6116 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -21,6 +21,8 @@
 #include <net/ip.h>
 #include <net/sock_reuseport.h>
 
+extern struct inet_hashinfo tcp_hashinfo;
+
 u32 inet6_ehashfn(const struct net *net,
 		  const struct in6_addr *laddr, const u16 lport,
 		  const struct in6_addr *faddr, const __be16 fport)
@@ -159,6 +161,31 @@ static struct sock *inet6_lhash2_lookup(struct net *net,
 	return result;
 }
 
+static inline struct sock *inet6_lookup_run_bpf(struct net *net,
+						struct inet_hashinfo *hashinfo,
+						struct sk_buff *skb, int doff,
+						const struct in6_addr *saddr,
+						const __be16 sport,
+						const struct in6_addr *daddr,
+						const u16 hnum)
+{
+	struct sock *sk, *reuse_sk;
+	bool no_reuseport;
+
+	if (hashinfo != &tcp_hashinfo)
+		return NULL; /* only TCP is supported */
+
+	no_reuseport = bpf_sk_lookup_run_v6(net, IPPROTO_TCP,
+					    saddr, sport, daddr, hnum, &sk);
+	if (no_reuseport || IS_ERR_OR_NULL(sk))
+		return sk;
+
+	reuse_sk = lookup_reuseport(net, sk, skb, doff, saddr, sport, daddr, hnum);
+	if (reuse_sk)
+		sk = reuse_sk;
+	return sk;
+}
+
 struct sock *inet6_lookup_listener(struct net *net,
 		struct inet_hashinfo *hashinfo,
 		struct sk_buff *skb, int doff,
@@ -170,6 +197,14 @@ struct sock *inet6_lookup_listener(struct net *net,
 	struct sock *result = NULL;
 	unsigned int hash2;
 
+	/* Lookup redirect from BPF */
+	if (static_branch_unlikely(&bpf_sk_lookup_enabled)) {
+		result = inet6_lookup_run_bpf(net, hashinfo, skb, doff,
+					      saddr, sport, daddr, hnum);
+		if (result)
+			goto done;
+	}
+
 	hash2 = ipv6_portaddr_hash(net, daddr, hnum);
 	ilb2 = inet_lhash2_bucket(hashinfo, hash2);
 
-- 
2.25.4

