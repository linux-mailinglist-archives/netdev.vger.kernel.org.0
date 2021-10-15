Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0188A42EF97
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 13:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238481AbhJOL0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 07:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238457AbhJOL0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 07:26:19 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49335C061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 04:24:12 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id e12so25946613wra.4
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 04:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=scltVqB0ADiyG2kyTo2Yvt+Yks0Dgd2QhYZsV3VCMSk=;
        b=CqSKHXaaVC/9b8Rcjd/zhxzMAtN/2nENA4jbage0RmBDwBJLVce0cjYHuDR1TE1fcr
         1NExAhhAH7uYkDJ9naMUbqbEI8uIZorlcIjt84ez/EWqC2YJj9ppxbKLcm4pggOVZx9W
         tr9cQ5cKKkAneToZpn22TuaHjGzILtIpGMsK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=scltVqB0ADiyG2kyTo2Yvt+Yks0Dgd2QhYZsV3VCMSk=;
        b=uxBa2mavTCcVUKAwi4wnfB/cbetDQRqRCj15wUGvklQxMldCd/Yc+zOzZT2FhiDKo4
         1iWrWpcz9O0Bj5piukFOdJJEOuE/RYMcbll58JFSSxslDIKEyFR8pFcq7glXcke4B0Nd
         9gqRe3Mo2UDKlxkUkHUjrpNqkgdxeHKjWUMMAS0AAk6a0bYG54Yo5Jb1WjLJkJWP5MDa
         Vegar/k6arG5vQhQtaZRmci/vLtZMSL5saCgA1ptJpSJcCvea1W7eQmBwSFevpMfxXQW
         dhekJzEfWziiN8PXIwN6b8yAh/zTmXao4aTIfULs0GRJB5Ll8XL+KLczCRT6G7dongW/
         cU+A==
X-Gm-Message-State: AOAM532RsfcNKEmtRV3/eDGoNGpwUMCmOW46RdQmpN/zQ0vjYzYJXd4f
        jtiNJxlyMJr+SpR1BxjXk7zSiQ==
X-Google-Smtp-Source: ABdhPJxigk/8CrjqrkPhu3WRHxLMOrjGGSrxpqrl6Jbhf/Ed4u2jxRh1jSnevbt9jyVuD+BXEnfduA==
X-Received: by 2002:adf:8bcf:: with SMTP id w15mr13820673wra.144.1634297050872;
        Fri, 15 Oct 2021 04:24:10 -0700 (PDT)
Received: from kharboze.dr-pashinator-m-d.gmail.com.beta.tailscale.net ([2a02:390:85ca:6:be5f:f4ff:fe85:e406])
        by smtp.gmail.com with ESMTPSA id o12sm4631223wrv.78.2021.10.15.04.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 04:24:10 -0700 (PDT)
From:   Mark Pashmfouroush <markpash@cloudflare.com>
To:     markpash@cloudflare.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Brendan Jackman <jackmanb@google.com>,
        Joe Stringer <joe@cilium.io>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 1/2] bpf: Add ifindex to bpf_sk_lookup
Date:   Fri, 15 Oct 2021 12:23:29 +0100
Message-Id: <20211015112336.1973229-2-markpash@cloudflare.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015112336.1973229-1-markpash@cloudflare.com>
References: <20211015112336.1973229-1-markpash@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It may be helpful to have access to the ifindex during bpf socket
lookup. Add this to the bpf_sk_lookup API.

Signed-off-by: Mark Pashmfouroush <markpash@cloudflare.com>

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 47f80adbe744..54ffd8036be6 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1370,6 +1370,7 @@ struct bpf_sk_lookup_kern {
 		const struct in6_addr *daddr;
 	} v6;
 	struct sock	*selected_sk;
+	u32		ifindex;
 	bool		no_reuseport;
 };
 
@@ -1432,7 +1433,7 @@ extern struct static_key_false bpf_sk_lookup_enabled;
 static inline bool bpf_sk_lookup_run_v4(struct net *net, int protocol,
 					const __be32 saddr, const __be16 sport,
 					const __be32 daddr, const u16 dport,
-					struct sock **psk)
+					const int ifindex, struct sock **psk)
 {
 	struct bpf_prog_array *run_array;
 	struct sock *selected_sk = NULL;
@@ -1448,6 +1449,7 @@ static inline bool bpf_sk_lookup_run_v4(struct net *net, int protocol,
 			.v4.daddr	= daddr,
 			.sport		= sport,
 			.dport		= dport,
+			.ifindex	= ifindex,
 		};
 		u32 act;
 
@@ -1470,7 +1472,7 @@ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
 					const __be16 sport,
 					const struct in6_addr *daddr,
 					const u16 dport,
-					struct sock **psk)
+					const int ifindex, struct sock **psk)
 {
 	struct bpf_prog_array *run_array;
 	struct sock *selected_sk = NULL;
@@ -1486,6 +1488,7 @@ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
 			.v6.daddr	= daddr,
 			.sport		= sport,
 			.dport		= dport,
+			.ifindex	= ifindex,
 		};
 		u32 act;
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6fc59d61937a..9bd3e8b8a659 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6262,6 +6262,7 @@ struct bpf_sk_lookup {
 	__u32 local_ip4;	/* Network byte order */
 	__u32 local_ip6[4];	/* Network byte order */
 	__u32 local_port;	/* Host byte order */
+	__u32 ifindex;		/* Maps to skb->dev->ifindex */
 };
 
 /*
diff --git a/net/core/filter.c b/net/core/filter.c
index 4bace37a6a44..9514c6bbd117 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10491,6 +10491,7 @@ static bool sk_lookup_is_valid_access(int off, int size,
 	case bpf_ctx_range_till(struct bpf_sk_lookup, local_ip6[0], local_ip6[3]):
 	case bpf_ctx_range(struct bpf_sk_lookup, remote_port):
 	case bpf_ctx_range(struct bpf_sk_lookup, local_port):
+	case bpf_ctx_range(struct bpf_sk_lookup, ifindex):
 		bpf_ctx_record_field_size(info, sizeof(__u32));
 		return bpf_ctx_narrow_access_ok(off, size, sizeof(__u32));
 
@@ -10580,6 +10581,12 @@ static u32 sk_lookup_convert_ctx_access(enum bpf_access_type type,
 				      bpf_target_off(struct bpf_sk_lookup_kern,
 						     dport, 2, target_size));
 		break;
+
+	case offsetof(struct bpf_sk_lookup, ifindex):
+		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
+				      bpf_target_off(struct bpf_sk_lookup_kern,
+						     ifindex, 4, target_size));
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 80aeaf9e6e16..088bb6c27114 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -305,7 +305,7 @@ static inline struct sock *inet_lookup_run_bpf(struct net *net,
 					       struct inet_hashinfo *hashinfo,
 					       struct sk_buff *skb, int doff,
 					       __be32 saddr, __be16 sport,
-					       __be32 daddr, u16 hnum)
+					       __be32 daddr, u16 hnum, const int dif)
 {
 	struct sock *sk, *reuse_sk;
 	bool no_reuseport;
@@ -313,8 +313,8 @@ static inline struct sock *inet_lookup_run_bpf(struct net *net,
 	if (hashinfo != &tcp_hashinfo)
 		return NULL; /* only TCP is supported */
 
-	no_reuseport = bpf_sk_lookup_run_v4(net, IPPROTO_TCP,
-					    saddr, sport, daddr, hnum, &sk);
+	no_reuseport = bpf_sk_lookup_run_v4(net, IPPROTO_TCP, saddr, sport,
+					    daddr, hnum, dif, &sk);
 	if (no_reuseport || IS_ERR_OR_NULL(sk))
 		return sk;
 
@@ -338,7 +338,7 @@ struct sock *__inet_lookup_listener(struct net *net,
 	/* Lookup redirect from BPF */
 	if (static_branch_unlikely(&bpf_sk_lookup_enabled)) {
 		result = inet_lookup_run_bpf(net, hashinfo, skb, doff,
-					     saddr, sport, daddr, hnum);
+					     saddr, sport, daddr, hnum, dif);
 		if (result)
 			goto done;
 	}
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 2a7825a5b842..f4ddfa38449e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -459,7 +459,7 @@ static struct sock *udp4_lookup_run_bpf(struct net *net,
 					struct udp_table *udptable,
 					struct sk_buff *skb,
 					__be32 saddr, __be16 sport,
-					__be32 daddr, u16 hnum)
+					__be32 daddr, u16 hnum, const int dif)
 {
 	struct sock *sk, *reuse_sk;
 	bool no_reuseport;
@@ -467,8 +467,8 @@ static struct sock *udp4_lookup_run_bpf(struct net *net,
 	if (udptable != &udp_table)
 		return NULL; /* only UDP is supported */
 
-	no_reuseport = bpf_sk_lookup_run_v4(net, IPPROTO_UDP,
-					    saddr, sport, daddr, hnum, &sk);
+	no_reuseport = bpf_sk_lookup_run_v4(net, IPPROTO_UDP, saddr, sport,
+					    daddr, hnum, dif, &sk);
 	if (no_reuseport || IS_ERR_OR_NULL(sk))
 		return sk;
 
@@ -504,7 +504,7 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
 	/* Lookup redirect from BPF */
 	if (static_branch_unlikely(&bpf_sk_lookup_enabled)) {
 		sk = udp4_lookup_run_bpf(net, udptable, skb,
-					 saddr, sport, daddr, hnum);
+					 saddr, sport, daddr, hnum, dif);
 		if (sk) {
 			result = sk;
 			goto done;
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 55c290d55605..8d25cb5d124b 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -165,7 +165,7 @@ static inline struct sock *inet6_lookup_run_bpf(struct net *net,
 						const struct in6_addr *saddr,
 						const __be16 sport,
 						const struct in6_addr *daddr,
-						const u16 hnum)
+						const u16 hnum, const int dif)
 {
 	struct sock *sk, *reuse_sk;
 	bool no_reuseport;
@@ -173,8 +173,8 @@ static inline struct sock *inet6_lookup_run_bpf(struct net *net,
 	if (hashinfo != &tcp_hashinfo)
 		return NULL; /* only TCP is supported */
 
-	no_reuseport = bpf_sk_lookup_run_v6(net, IPPROTO_TCP,
-					    saddr, sport, daddr, hnum, &sk);
+	no_reuseport = bpf_sk_lookup_run_v6(net, IPPROTO_TCP, saddr, sport,
+					    daddr, hnum, dif, &sk);
 	if (no_reuseport || IS_ERR_OR_NULL(sk))
 		return sk;
 
@@ -198,7 +198,7 @@ struct sock *inet6_lookup_listener(struct net *net,
 	/* Lookup redirect from BPF */
 	if (static_branch_unlikely(&bpf_sk_lookup_enabled)) {
 		result = inet6_lookup_run_bpf(net, hashinfo, skb, doff,
-					      saddr, sport, daddr, hnum);
+					      saddr, sport, daddr, hnum, dif);
 		if (result)
 			goto done;
 	}
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index e505bb007e9f..77ba0917b3ea 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -194,7 +194,7 @@ static inline struct sock *udp6_lookup_run_bpf(struct net *net,
 					       const struct in6_addr *saddr,
 					       __be16 sport,
 					       const struct in6_addr *daddr,
-					       u16 hnum)
+					       u16 hnum, const int dif)
 {
 	struct sock *sk, *reuse_sk;
 	bool no_reuseport;
@@ -202,8 +202,8 @@ static inline struct sock *udp6_lookup_run_bpf(struct net *net,
 	if (udptable != &udp_table)
 		return NULL; /* only UDP is supported */
 
-	no_reuseport = bpf_sk_lookup_run_v6(net, IPPROTO_UDP,
-					    saddr, sport, daddr, hnum, &sk);
+	no_reuseport = bpf_sk_lookup_run_v6(net, IPPROTO_UDP, saddr, sport,
+					    daddr, hnum, dif, &sk);
 	if (no_reuseport || IS_ERR_OR_NULL(sk))
 		return sk;
 
@@ -239,7 +239,7 @@ struct sock *__udp6_lib_lookup(struct net *net,
 	/* Lookup redirect from BPF */
 	if (static_branch_unlikely(&bpf_sk_lookup_enabled)) {
 		sk = udp6_lookup_run_bpf(net, udptable, skb,
-					 saddr, sport, daddr, hnum);
+					 saddr, sport, daddr, hnum, dif);
 		if (sk) {
 			result = sk;
 			goto done;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 6fc59d61937a..9bd3e8b8a659 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -6262,6 +6262,7 @@ struct bpf_sk_lookup {
 	__u32 local_ip4;	/* Network byte order */
 	__u32 local_ip6[4];	/* Network byte order */
 	__u32 local_port;	/* Host byte order */
+	__u32 ifindex;		/* Maps to skb->dev->ifindex */
 };
 
 /*
-- 
2.31.1

