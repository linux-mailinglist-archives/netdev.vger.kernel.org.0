Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0874452EA
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 13:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhKDM0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 08:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhKDM0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 08:26:07 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4930BC061714
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 05:23:29 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id o14so8265629wra.12
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 05:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=spmYJipK+FPsViFDUmLlWUTbhxKUZWrNxSbmuoJB78Y=;
        b=Ar8twA72/AObNEpxn7NZGBTVAVR4k4arwM+1FYFxbn9YLRQv+32PaFVMMEsDrkzeJ+
         Yq3c33oxzpkNdcwZ2XkjXt05TZ8Lw0rX6tyjRc+0DG/TdXVqcVspeJWJzpapj2X57mEu
         GMRqsoIP0ui/vbm7ipiferM9im/aKaNDIUHVI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=spmYJipK+FPsViFDUmLlWUTbhxKUZWrNxSbmuoJB78Y=;
        b=fNeyK1uRrtQg17tMuqzEffzPuANXji9znaUtACrZ4/4fcWFJ9ZFq60j1G4uCkVYAMl
         rP9KXOea34VZcSGrghE+u8Ajgp31roDmE96WROotjfPObPxEgoVDCWOctyYfA3XVYnom
         1nrl1pO2GKL4awQ7BP9FnOGJfOuBwLfPfNBF84Yi9XcrOzF/ggR4HGZSKePA7UMjkW+K
         Xor+uDklNnL7iWp7MO8jpH96/UOLinIBftgnOB+Wh1oM1tuxKs3DjIRG9lPufuwySoZv
         Rbi2420ci/BHMFlwf7nq4OnAQoKj3VPhHayaxdp7FsOkm0VjXToOvd5YLtokreAkoMpK
         wWgw==
X-Gm-Message-State: AOAM5323J6cayFJEVTJt7sv/l3xdZ2Mkbsj4vW+Ut7PXw91hJS+TH7Th
        Oni+H3/Uyg78CyQnufgm7oM18g==
X-Google-Smtp-Source: ABdhPJyXRo8qqreJlFh+XGlDreWO0GO+exI8jbbbQxg3kaLUVbpXKFSXi5HOdyE5lWutmgMqqceamA==
X-Received: by 2002:a5d:6e91:: with SMTP id k17mr64180890wrz.260.1636028607883;
        Thu, 04 Nov 2021 05:23:27 -0700 (PDT)
Received: from kharboze.dr-pashinator-m-d.gmail.com.beta.tailscale.net (cust97-dsl60.idnet.net. [212.69.60.97])
        by smtp.gmail.com with ESMTPSA id a4sm4797535wmb.39.2021.11.04.05.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 05:23:27 -0700 (PDT)
From:   Mark Pashmfouroush <markpash@cloudflare.com>
To:     markpash@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 1/2] bpf: Add ifindex to bpf_sk_lookup
Date:   Thu,  4 Nov 2021 12:23:03 +0000
Message-Id: <20211104122304.962104-2-markpash@cloudflare.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211104122304.962104-1-markpash@cloudflare.com>
References: <20211104122304.962104-1-markpash@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It may be helpful to have access to the ifindex during bpf socket
lookup. An example may be to scope certain socket lookup logic to
specific interfaces, i.e. an interface may be made exempt from custom
lookup code.

Add the ifindex of the arriving connection to the bpf_sk_lookup API.

Signed-off-by: Mark Pashmfouroush <markpash@cloudflare.com>

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 24b7ed2677af..0012a5176a32 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1374,6 +1374,7 @@ struct bpf_sk_lookup_kern {
 		const struct in6_addr *daddr;
 	} v6;
 	struct sock	*selected_sk;
+	u32		ifindex;
 	bool		no_reuseport;
 };
 
@@ -1436,7 +1437,7 @@ extern struct static_key_false bpf_sk_lookup_enabled;
 static inline bool bpf_sk_lookup_run_v4(struct net *net, int protocol,
 					const __be32 saddr, const __be16 sport,
 					const __be32 daddr, const u16 dport,
-					struct sock **psk)
+					const int ifindex, struct sock **psk)
 {
 	struct bpf_prog_array *run_array;
 	struct sock *selected_sk = NULL;
@@ -1452,6 +1453,7 @@ static inline bool bpf_sk_lookup_run_v4(struct net *net, int protocol,
 			.v4.daddr	= daddr,
 			.sport		= sport,
 			.dport		= dport,
+			.ifindex	= ifindex,
 		};
 		u32 act;
 
@@ -1474,7 +1476,7 @@ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
 					const __be16 sport,
 					const struct in6_addr *daddr,
 					const u16 dport,
-					struct sock **psk)
+					const int ifindex, struct sock **psk)
 {
 	struct bpf_prog_array *run_array;
 	struct sock *selected_sk = NULL;
@@ -1490,6 +1492,7 @@ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
 			.v6.daddr	= daddr,
 			.sport		= sport,
 			.dport		= dport,
+			.ifindex	= ifindex,
 		};
 		u32 act;
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ba5af15e25f5..5b8618a4d485 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6296,6 +6296,7 @@ struct bpf_sk_lookup {
 	__u32 local_ip4;	/* Network byte order */
 	__u32 local_ip6[4];	/* Network byte order */
 	__u32 local_port;	/* Host byte order */
+	__u32 ifindex;		/* The arriving interface. Determined by inet_iif. */
 };
 
 /*
diff --git a/net/core/filter.c b/net/core/filter.c
index 8e8d3b49c297..1b83111a996f 100644
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
index 75737267746f..30ab717ff1b8 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -307,7 +307,7 @@ static inline struct sock *inet_lookup_run_bpf(struct net *net,
 					       struct inet_hashinfo *hashinfo,
 					       struct sk_buff *skb, int doff,
 					       __be32 saddr, __be16 sport,
-					       __be32 daddr, u16 hnum)
+					       __be32 daddr, u16 hnum, const int dif)
 {
 	struct sock *sk, *reuse_sk;
 	bool no_reuseport;
@@ -315,8 +315,8 @@ static inline struct sock *inet_lookup_run_bpf(struct net *net,
 	if (hashinfo != &tcp_hashinfo)
 		return NULL; /* only TCP is supported */
 
-	no_reuseport = bpf_sk_lookup_run_v4(net, IPPROTO_TCP,
-					    saddr, sport, daddr, hnum, &sk);
+	no_reuseport = bpf_sk_lookup_run_v4(net, IPPROTO_TCP, saddr, sport,
+					    daddr, hnum, dif, &sk);
 	if (no_reuseport || IS_ERR_OR_NULL(sk))
 		return sk;
 
@@ -340,7 +340,7 @@ struct sock *__inet_lookup_listener(struct net *net,
 	/* Lookup redirect from BPF */
 	if (static_branch_unlikely(&bpf_sk_lookup_enabled)) {
 		result = inet_lookup_run_bpf(net, hashinfo, skb, doff,
-					     saddr, sport, daddr, hnum);
+					     saddr, sport, daddr, hnum, dif);
 		if (result)
 			goto done;
 	}
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 2fffcf2b54f3..5fceee3de65d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -460,7 +460,7 @@ static struct sock *udp4_lookup_run_bpf(struct net *net,
 					struct udp_table *udptable,
 					struct sk_buff *skb,
 					__be32 saddr, __be16 sport,
-					__be32 daddr, u16 hnum)
+					__be32 daddr, u16 hnum, const int dif)
 {
 	struct sock *sk, *reuse_sk;
 	bool no_reuseport;
@@ -468,8 +468,8 @@ static struct sock *udp4_lookup_run_bpf(struct net *net,
 	if (udptable != &udp_table)
 		return NULL; /* only UDP is supported */
 
-	no_reuseport = bpf_sk_lookup_run_v4(net, IPPROTO_UDP,
-					    saddr, sport, daddr, hnum, &sk);
+	no_reuseport = bpf_sk_lookup_run_v4(net, IPPROTO_UDP, saddr, sport,
+					    daddr, hnum, dif, &sk);
 	if (no_reuseport || IS_ERR_OR_NULL(sk))
 		return sk;
 
@@ -505,7 +505,7 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
 	/* Lookup redirect from BPF */
 	if (static_branch_unlikely(&bpf_sk_lookup_enabled)) {
 		sk = udp4_lookup_run_bpf(net, udptable, skb,
-					 saddr, sport, daddr, hnum);
+					 saddr, sport, daddr, hnum, dif);
 		if (sk) {
 			result = sk;
 			goto done;
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 67c9114835c8..4514444e96c8 100644
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
index 12c12619ee35..ea4ea525f94a 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -195,7 +195,7 @@ static inline struct sock *udp6_lookup_run_bpf(struct net *net,
 					       const struct in6_addr *saddr,
 					       __be16 sport,
 					       const struct in6_addr *daddr,
-					       u16 hnum)
+					       u16 hnum, const int dif)
 {
 	struct sock *sk, *reuse_sk;
 	bool no_reuseport;
@@ -203,8 +203,8 @@ static inline struct sock *udp6_lookup_run_bpf(struct net *net,
 	if (udptable != &udp_table)
 		return NULL; /* only UDP is supported */
 
-	no_reuseport = bpf_sk_lookup_run_v6(net, IPPROTO_UDP,
-					    saddr, sport, daddr, hnum, &sk);
+	no_reuseport = bpf_sk_lookup_run_v6(net, IPPROTO_UDP, saddr, sport,
+					    daddr, hnum, dif, &sk);
 	if (no_reuseport || IS_ERR_OR_NULL(sk))
 		return sk;
 
@@ -240,7 +240,7 @@ struct sock *__udp6_lib_lookup(struct net *net,
 	/* Lookup redirect from BPF */
 	if (static_branch_unlikely(&bpf_sk_lookup_enabled)) {
 		sk = udp6_lookup_run_bpf(net, udptable, skb,
-					 saddr, sport, daddr, hnum);
+					 saddr, sport, daddr, hnum, dif);
 		if (sk) {
 			result = sk;
 			goto done;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ba5af15e25f5..5b8618a4d485 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -6296,6 +6296,7 @@ struct bpf_sk_lookup {
 	__u32 local_ip4;	/* Network byte order */
 	__u32 local_ip6[4];	/* Network byte order */
 	__u32 local_port;	/* Host byte order */
+	__u32 ifindex;		/* The arriving interface. Determined by inet_iif. */
 };
 
 /*
-- 
2.31.1

