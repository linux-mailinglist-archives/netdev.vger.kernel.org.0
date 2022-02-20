Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E974BCEDA
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243909AbiBTNtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:49:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243916AbiBTNtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:49:15 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D511653732;
        Sun, 20 Feb 2022 05:48:53 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id s16so12001635pgs.13;
        Sun, 20 Feb 2022 05:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v7r7FHu3QAUhr3+7QG+/dRRC3q80hrKg8AEc1n+/igo=;
        b=kHV+QJWieq0jGqRzueAF4rk9YMSlkJUsWMJ3wTg9+D5mbEVNh9ZjZKV2OOgbZJrdSS
         0ZMivsWI1P3+twe5PtEM56UQJE6a8tpF50RdHFXMvCYuL5bmLxmxYrkba9Z8s5ZJ9J0b
         jO0wrxgeYgiJzktjgdjzjWdXHlPpUMlOsK3vktXyFyuHitM1wq3rvJ2L1OgFOoOFJV21
         /3WdnPWA4WS4WhyZksbJHHjmBSLZSNEw407pTHU++Z1dc8s5uC4510c4MZw0/LPTmCql
         C2MyQgHK3S+W7Gefgabgfvqn+6wTmV1/uiMmn1kCAet8cub2h8qEhXhuTuryw7dggfXt
         LWZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v7r7FHu3QAUhr3+7QG+/dRRC3q80hrKg8AEc1n+/igo=;
        b=ThBUZ51Ar44Py30x7qmynSpBSTILQ5VjW+Jia20sdZogjELv73f+5ul5cnRuuIHoZC
         +B+5nV9llOQqzluSi6X1XRnG/otviqtUCat51d/viQAZtteqGCALXsj+rRXizFUZ1xn4
         LImzlLTmTI/cGYa6f+c0f8Yg405dQIeS2jywdSEykegWxeMQHT7Bbn44A/ce3gKQiCHF
         +5e22J6YF25cNMUbsxKOXOzss6Kv5Krp1q3l6NC2w0UlHz3vOKtIMZgwY8nwaY0Cnz32
         SCf1IDjfq/oCrDLcw8Nx+C2m21bthPIlRFv4+0AIvLct7U5Duo0p5mc0lSBkmSMqv2zm
         7fCA==
X-Gm-Message-State: AOAM5313IfAF0QVsJJyH8MYZEc08UuBMuDCZrQvRHKeM7YnSHxb7xHl4
        KsEMjt1zidzEfH8+3F+MfvGsUuZWdm8=
X-Google-Smtp-Source: ABdhPJzK6kwqZpGGf6MnW/pEFOYgmd5WWEWPXLCg7HUqFdLFyn7nGenJJvSrroh8qdfi6ANthhc8vg==
X-Received: by 2002:a05:6a00:124b:b0:4f0:eaa7:4677 with SMTP id u11-20020a056a00124b00b004f0eaa74677mr11208398pfi.85.1645364933191;
        Sun, 20 Feb 2022 05:48:53 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id v13sm10118464pfu.196.2022.02.20.05.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:48:52 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 12/15] net/netfilter: Add bpf_ct_kptr_get helper
Date:   Sun, 20 Feb 2022 19:18:10 +0530
Message-Id: <20220220134813.3411982-13-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9318; h=from:subject; bh=fN4g0NsdFmVTHRi7ezE3E/ZN+uig0L4IYC7S4pnjH60=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZYTo+bmM8pp/rh3EIrMhbhLK9xV6cJ7gRXpSif /qkFJgeJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGWAAKCRBM4MiGSL8Ryja/D/ 9QSz/4px2Q7U+6712nl2OxXmGQk+k6QbEWUab0LPdANl+E6B9qn/rybtXi7o013DzRB+X2wAye9dkc QGiIwqvlbdQSumKkzI4kk1t6lW2IIzLdCkA8wXOC3vw2xzQaaMDnVQJvM41WCyagf5JN4X/DciOjx8 pbjfaVJRR6hhndngIMVkI1bEJFbscK0Urd+KBPqUO1rXxMo/nvfv2/OOdD7G/azw/GDRGzAh0jVCxW tiZdjCUs9lWy1018/xSVNWZLOIBD3H1sym5sEXkjqAA8XIlGGeU+oPD4X0mVrsrJWupOwODKPEwkwY FvkKKE9PPI7mqj7/Lu3vh8SbxOpV/CegFg0W9VrNR7o/IIdG4ts/8Wy+o4hjZzFHFABTXW6ZWY965g k/IAJP9CvJHKpclaJjDv9OSEZfjpkApQdpwYcUeCi9AgmdaT1+rOfFYqHWrjio6v7V7dyM3TlqMWxT uolP00ZVzdZGf6MQKcJfXORxMa5JzQTl4SWxPUWJBl37YdPQ5/3MP/BvMOeQe39os/pTsM5WVfZi9Q Mcudx0rqjkEa6c/na54Bqh8/WeXvD/ytDpcvJSsZCHWBkZGv/VRzkJsAW3CqdT1qOg+4l70Gbd6ooH BclvVppaI4Tsu/P8G+Ht7A0gpDlQDJQN3TamXrc4jhdI+W2QeYVtq2wTcmKA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Require some more feedback on whether this is OK, before refactoring
netfilter functions to share code to increment reference and match the
tuple. Also probably need to work on allowing taking reference to struct
net * to save another lookup inside this function.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/net/netfilter/nf_conntrack_core.h |  17 +++
 net/netfilter/nf_conntrack_bpf.c          | 132 +++++++++++++++++-----
 net/netfilter/nf_conntrack_core.c         |  17 ---
 3 files changed, 119 insertions(+), 47 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 13807ea94cd2..09389769dce3 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -51,6 +51,23 @@ nf_conntrack_find_get(struct net *net,
 
 int __nf_conntrack_confirm(struct sk_buff *skb);
 
+static inline bool
+nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
+		const struct nf_conntrack_tuple *tuple,
+		const struct nf_conntrack_zone *zone,
+		const struct net *net)
+{
+	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
+
+	/* A conntrack can be recreated with the equal tuple,
+	 * so we need to check that the conntrack is confirmed
+	 */
+	return nf_ct_tuple_equal(tuple, &h->tuple) &&
+	       nf_ct_zone_equal(ct, zone, NF_CT_DIRECTION(h)) &&
+	       nf_ct_is_confirmed(ct) &&
+	       net_eq(net, nf_ct_net(ct));
+}
+
 /* Confirm a connection: returns NF_DROP if packet must be dropped. */
 static inline int nf_conntrack_confirm(struct sk_buff *skb)
 {
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 8ad3f52579f3..26211a5ec0c4 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -52,6 +52,30 @@ enum {
 	NF_BPF_CT_OPTS_SZ = 12,
 };
 
+static int bpf_fill_nf_tuple(struct nf_conntrack_tuple *tuple,
+			     struct bpf_sock_tuple *bpf_tuple, u32 tuple_len)
+{
+	switch (tuple_len) {
+	case sizeof(bpf_tuple->ipv4):
+		tuple->src.l3num = AF_INET;
+		tuple->src.u3.ip = bpf_tuple->ipv4.saddr;
+		tuple->src.u.tcp.port = bpf_tuple->ipv4.sport;
+		tuple->dst.u3.ip = bpf_tuple->ipv4.daddr;
+		tuple->dst.u.tcp.port = bpf_tuple->ipv4.dport;
+		break;
+	case sizeof(bpf_tuple->ipv6):
+		tuple->src.l3num = AF_INET6;
+		memcpy(tuple->src.u3.ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
+		tuple->src.u.tcp.port = bpf_tuple->ipv6.sport;
+		memcpy(tuple->dst.u3.ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
+		tuple->dst.u.tcp.port = bpf_tuple->ipv6.dport;
+		break;
+	default:
+		return -EAFNOSUPPORT;
+	}
+	return 0;
+}
+
 static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 					  struct bpf_sock_tuple *bpf_tuple,
 					  u32 tuple_len, u8 protonum,
@@ -59,6 +83,7 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 {
 	struct nf_conntrack_tuple_hash *hash;
 	struct nf_conntrack_tuple tuple;
+	int ret;
 
 	if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
 		return ERR_PTR(-EPROTO);
@@ -66,25 +91,9 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 		return ERR_PTR(-EINVAL);
 
 	memset(&tuple, 0, sizeof(tuple));
-	switch (tuple_len) {
-	case sizeof(bpf_tuple->ipv4):
-		tuple.src.l3num = AF_INET;
-		tuple.src.u3.ip = bpf_tuple->ipv4.saddr;
-		tuple.src.u.tcp.port = bpf_tuple->ipv4.sport;
-		tuple.dst.u3.ip = bpf_tuple->ipv4.daddr;
-		tuple.dst.u.tcp.port = bpf_tuple->ipv4.dport;
-		break;
-	case sizeof(bpf_tuple->ipv6):
-		tuple.src.l3num = AF_INET6;
-		memcpy(tuple.src.u3.ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
-		tuple.src.u.tcp.port = bpf_tuple->ipv6.sport;
-		memcpy(tuple.dst.u3.ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
-		tuple.dst.u.tcp.port = bpf_tuple->ipv6.dport;
-		break;
-	default:
-		return ERR_PTR(-EAFNOSUPPORT);
-	}
-
+	ret = bpf_fill_nf_tuple(&tuple, bpf_tuple, tuple_len);
+	if (ret < 0)
+		return ERR_PTR(ret);
 	tuple.dst.protonum = protonum;
 
 	if (netns_id >= 0) {
@@ -208,50 +217,113 @@ void bpf_ct_release(struct nf_conn *nfct)
 	nf_ct_put(nfct);
 }
 
+/* TODO: Just a PoC, need to reuse code in __nf_conntrack_find_get for this */
+struct nf_conn *bpf_ct_kptr_get(struct nf_conn **ptr, struct bpf_sock_tuple *bpf_tuple,
+				u32 tuple__sz, u8 protonum, u8 direction)
+{
+	struct nf_conntrack_tuple tuple;
+	struct nf_conn *nfct;
+	struct net *net;
+	u64 *nfct_p;
+	int ret;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	if ((protonum != IPPROTO_TCP && protonum != IPPROTO_UDP) ||
+	    (direction != IP_CT_DIR_ORIGINAL && direction != IP_CT_DIR_REPLY))
+		return NULL;
+
+	/* ptr is actually pointer to u64 having address, hence recast u64 load
+	 * to native pointer width.
+	 */
+	nfct_p = (u64 *)ptr;
+	nfct = (struct nf_conn *)READ_ONCE(*nfct_p);
+	if (!nfct || unlikely(!refcount_inc_not_zero(&nfct->ct_general.use)))
+		return NULL;
+
+	memset(&tuple, 0, sizeof(tuple));
+	ret = bpf_fill_nf_tuple(&tuple, bpf_tuple, tuple__sz);
+	if (ret < 0)
+		goto end;
+	tuple.dst.protonum = protonum;
+
+	/* XXX: Need to allow passing in struct net *, or take netns_id, this is non-sense */
+	net = nf_ct_net(nfct);
+	if (!nf_ct_key_equal(&nfct->tuplehash[direction], &tuple,
+			     &nf_ct_zone_dflt, nf_ct_net(nfct)))
+		goto end;
+	return nfct;
+end:
+	nf_ct_put(nfct);
+	return NULL;
+}
+
 __diag_pop()
 
 BTF_SET_START(nf_ct_xdp_check_kfunc_ids)
 BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_ct_kptr_get)
 BTF_ID(func, bpf_ct_release)
 BTF_SET_END(nf_ct_xdp_check_kfunc_ids)
 
 BTF_SET_START(nf_ct_tc_check_kfunc_ids)
 BTF_ID(func, bpf_skb_ct_lookup)
+BTF_ID(func, bpf_ct_kptr_get)
 BTF_ID(func, bpf_ct_release)
 BTF_SET_END(nf_ct_tc_check_kfunc_ids)
 
 BTF_SET_START(nf_ct_acquire_kfunc_ids)
 BTF_ID(func, bpf_xdp_ct_lookup)
 BTF_ID(func, bpf_skb_ct_lookup)
+BTF_ID(func, bpf_ct_kptr_get)
 BTF_SET_END(nf_ct_acquire_kfunc_ids)
 
 BTF_SET_START(nf_ct_release_kfunc_ids)
 BTF_ID(func, bpf_ct_release)
 BTF_SET_END(nf_ct_release_kfunc_ids)
 
+BTF_SET_START(nf_ct_kptr_acquire_kfunc_ids)
+BTF_ID(func, bpf_ct_kptr_get)
+BTF_SET_END(nf_ct_kptr_acquire_kfunc_ids)
+
 /* Both sets are identical */
 #define nf_ct_ret_null_kfunc_ids nf_ct_acquire_kfunc_ids
 
 static const struct btf_kfunc_id_set nf_conntrack_xdp_kfunc_set = {
-	.owner        = THIS_MODULE,
-	.check_set    = &nf_ct_xdp_check_kfunc_ids,
-	.acquire_set  = &nf_ct_acquire_kfunc_ids,
-	.release_set  = &nf_ct_release_kfunc_ids,
-	.ret_null_set = &nf_ct_ret_null_kfunc_ids,
+	.owner            = THIS_MODULE,
+	.check_set        = &nf_ct_xdp_check_kfunc_ids,
+	.acquire_set      = &nf_ct_acquire_kfunc_ids,
+	.release_set      = &nf_ct_release_kfunc_ids,
+	.ret_null_set     = &nf_ct_ret_null_kfunc_ids,
+	.kptr_acquire_set = &nf_ct_kptr_acquire_kfunc_ids,
 };
 
 static const struct btf_kfunc_id_set nf_conntrack_tc_kfunc_set = {
-	.owner        = THIS_MODULE,
-	.check_set    = &nf_ct_tc_check_kfunc_ids,
-	.acquire_set  = &nf_ct_acquire_kfunc_ids,
-	.release_set  = &nf_ct_release_kfunc_ids,
-	.ret_null_set = &nf_ct_ret_null_kfunc_ids,
+	.owner            = THIS_MODULE,
+	.check_set        = &nf_ct_tc_check_kfunc_ids,
+	.acquire_set      = &nf_ct_acquire_kfunc_ids,
+	.release_set      = &nf_ct_release_kfunc_ids,
+	.ret_null_set     = &nf_ct_ret_null_kfunc_ids,
+	.kptr_acquire_set = &nf_ct_kptr_acquire_kfunc_ids,
 };
 
+BTF_ID_LIST(nf_conntrack_dtor_kfunc_ids)
+BTF_ID(struct, nf_conn)
+BTF_ID(func, bpf_ct_release)
+
 int register_nf_conntrack_bpf(void)
 {
+	const struct btf_id_dtor_kfunc nf_conntrack_dtor_kfunc[] = {
+		{
+			.btf_id       = nf_conntrack_dtor_kfunc_ids[0],
+			.kfunc_btf_id = nf_conntrack_dtor_kfunc_ids[1],
+		}
+	};
 	int ret;
 
-	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &nf_conntrack_xdp_kfunc_set);
+	ret = register_btf_id_dtor_kfuncs(nf_conntrack_dtor_kfunc,
+					  ARRAY_SIZE(nf_conntrack_dtor_kfunc),
+					  THIS_MODULE);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &nf_conntrack_xdp_kfunc_set);
 	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &nf_conntrack_tc_kfunc_set);
 }
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9b7f9c966f73..0aae98f60769 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -710,23 +710,6 @@ bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
 }
 EXPORT_SYMBOL_GPL(nf_ct_delete);
 
-static inline bool
-nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
-		const struct nf_conntrack_tuple *tuple,
-		const struct nf_conntrack_zone *zone,
-		const struct net *net)
-{
-	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
-
-	/* A conntrack can be recreated with the equal tuple,
-	 * so we need to check that the conntrack is confirmed
-	 */
-	return nf_ct_tuple_equal(tuple, &h->tuple) &&
-	       nf_ct_zone_equal(ct, zone, NF_CT_DIRECTION(h)) &&
-	       nf_ct_is_confirmed(ct) &&
-	       net_eq(net, nf_ct_net(ct));
-}
-
 static inline bool
 nf_ct_match(const struct nf_conn *ct1, const struct nf_conn *ct2)
 {
-- 
2.35.1

