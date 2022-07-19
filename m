Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFCC57A0AB
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238736AbiGSOIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiGSOIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:08:06 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A94545DC;
        Tue, 19 Jul 2022 06:24:44 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id z23so27153366eju.8;
        Tue, 19 Jul 2022 06:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zRfpMv1HKDT/oo8oqXnhx+r8KcTgD+wCKHWhLlEb4rU=;
        b=iktN3DZvWK/vd2WnLrhvt+I0fQSFBY1mzhJ08Fw69hn3Z8aHqRxvqKAckEQM2zvUIP
         zpjxVH8Y2vF3+F/wAhKEXiXMURSrOnX2nV2rt+1bwXr9hlo0h0AptypEoRAn86Cf7xTj
         Nbgtp1En4xlaxpsjHdunXWIAw4TGb6B7RVngJN9lntsKNnJmuPBYiw/4GFwOvRpZCEaB
         P066hP7AWTTKdObf2/rjIK82HL40CuLHAjimiUjq9qV3LJCRfy/1Zty0MuWeEkP7R6bW
         4wsztxNpzaXYXpuS6uS4g8NGO7I2H8zjibK2OpI9stbf9+qrAHS9HFaS5ujtUvy/79pe
         VPZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zRfpMv1HKDT/oo8oqXnhx+r8KcTgD+wCKHWhLlEb4rU=;
        b=byMmuc3Fe4RD5DHxynG5ibRD4D7lKjM1WlG+Va9L9lK41AgPRworOcSlfV11IYSKO4
         htvMNvLGoaj0hNqTy6XbsdIHqHkrIPmVvD/RMFhZyGYnphfjh9OroorFfcs30p2k8zBc
         ZwvMFs4NA0HyqRwc1th7amhlDksnNQm5ldxsmMsnSKRaNAxjU5R1uu7Afbi7+c1p+cVj
         I8qDuY7NYZG5ztUOjgw5DZLJ9bHfSiiwoEwOz6eZP7LP35v087UZOnrdgOxiGebn3IX4
         4f71MKqFhov9m3tHAwvctEMppXlPsAT2yx4f1VNRV8DDdCuMyxeyjXpzevrY45x88Tkt
         zhug==
X-Gm-Message-State: AJIora+Ja520yW6PasoPomkj8YTfI0xmqSquShAkK6OFLV98ZVLyv94x
        UGLq+A1W3hlgEV7TXzDtSsS9urBndBlnrA==
X-Google-Smtp-Source: AGRyM1sYNgu4agkDt09fZfnolvX14fevpag01tW9eD8CiLaigogbitJBqCaZb7epYHukw6q/qeKjTw==
X-Received: by 2002:a17:907:a075:b0:72b:33e7:d63a with SMTP id ia21-20020a170907a07500b0072b33e7d63amr29632870ejc.533.1658237082378;
        Tue, 19 Jul 2022 06:24:42 -0700 (PDT)
Received: from localhost (icdhcp-1-189.epfl.ch. [128.178.116.189])
        by smtp.gmail.com with ESMTPSA id f23-20020a50fe17000000b0043a734c7393sm10481550edt.31.2022.07.19.06.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:24:42 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v6 07/13] net: netfilter: Add kfuncs to allocate and insert CT
Date:   Tue, 19 Jul 2022 15:24:24 +0200
Message-Id: <20220719132430.19993-8-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719132430.19993-1-memxor@gmail.com>
References: <20220719132430.19993-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11577; i=memxor@gmail.com; h=from:subject; bh=lLspzCVrhd4Jvc73ASnMdPHnQmldx+MOLcFCT+M8Zdo=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi1rBlRCbddqJSuRe6L0NthtorA1dFj2T+mEFM//qx YIcTEGuJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtawZQAKCRBM4MiGSL8RyvkOD/ 944LFFQXVOZencHgNs9aimp5N8aI6Ijaf9pZRURf1zK7d3MNA474wIpHjwLR6KGd1isxF9yWpBc8mv pShJfZdDCqvJIsEIcQaEsml6Z0KhTguaQe6Ufs7N4fGwPBmcmIOXPaqUaCcXhF82dmcPm0VzhObiLe gQATtyZB+RFawsG2qBvCj0YVlvU764Ng8BlQv4rlWavTsCKp7AOwStrnTDLqw0rGSpmvEOKpd6XGJJ PJNVrIsVGBGpOqHu63Pmk0Gph/TdNpu2sDP5SNrn7ahlcMbGiwdlaRCa1/WZ8ZVH1Eq7h88j7WCPlt l5JNo/qoPZ3UBLiJ+IFhd3JCLw99h69YRdruEH0Vhca0Q+v+H/DI7Ei1RGgUm3ocnBBCS7NkZSHjM5 gel+p1bcgFhGwWwW3xDjsf8XDUUlv4Oyh2c8p0sBF7WpHTcbCcqtlG5HORAzaSk3WGkeXi4bAwDwMc rWTNUygVgF8tUBQYOcaNr58QT1lxXt2JsgFnvuuNsUUITZgazhq+Gxg6IH0ggPhgxjtCx07WbaoRQA 0ZA9KLTcBg6GOoI34YmHQNacum87z08lKEewvdyJfcaAVx/aYLCDJjW3E6A+pWklPALu/33zPjAPrW Q8XhVQdB0RJfbfDnNlsOJID3vWO2M2CZUg56PrQBDomy/SpkvciWKBEAP2gw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce bpf_xdp_ct_alloc, bpf_skb_ct_alloc and bpf_ct_insert_entry
kfuncs in order to insert a new entry from XDP and TC programs.
Introduce bpf_nf_ct_tuple_parse utility routine to consolidate common
code.

We extract out a helper __nf_ct_set_timeout, used by the ctnetlink and
nf_conntrack_bpf code, extract it out to nf_conntrack_core, so that
nf_conntrack_bpf doesn't need a dependency on CONFIG_NF_CT_NETLINK.
Later this helper will be reused as a helper to set timeout of allocated
but not yet inserted CT entry.

The allocation functions return struct nf_conn___init instead of
nf_conn, to distinguish allocated CT from an already inserted or looked
up CT. This is later used to enforce restrictions on what kfuncs
allocated CT can be used with.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/net/netfilter/nf_conntrack_core.h |  15 ++
 net/netfilter/nf_conntrack_bpf.c          | 208 +++++++++++++++++++---
 net/netfilter/nf_conntrack_netlink.c      |   8 +-
 3 files changed, 204 insertions(+), 27 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 37866c8386e2..83a60c684e6c 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -84,4 +84,19 @@ void nf_conntrack_lock(spinlock_t *lock);
 
 extern spinlock_t nf_conntrack_expect_lock;
 
+/* ctnetlink code shared by both ctnetlink and nf_conntrack_bpf */
+
+#if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
+    (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES) || \
+    IS_ENABLED(CONFIG_NF_CT_NETLINK))
+
+static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
+{
+	if (timeout > INT_MAX)
+		timeout = INT_MAX;
+	WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
+}
+
+#endif
+
 #endif /* _NF_CONNTRACK_CORE_H */
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 0ba3cbde72ec..6c43160ff036 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -55,6 +55,94 @@ enum {
 	NF_BPF_CT_OPTS_SZ = 12,
 };
 
+static int bpf_nf_ct_tuple_parse(struct bpf_sock_tuple *bpf_tuple,
+				 u32 tuple_len, u8 protonum, u8 dir,
+				 struct nf_conntrack_tuple *tuple)
+{
+	union nf_inet_addr *src = dir ? &tuple->dst.u3 : &tuple->src.u3;
+	union nf_inet_addr *dst = dir ? &tuple->src.u3 : &tuple->dst.u3;
+	union nf_conntrack_man_proto *sport = dir ? (void *)&tuple->dst.u
+						  : &tuple->src.u;
+	union nf_conntrack_man_proto *dport = dir ? &tuple->src.u
+						  : (void *)&tuple->dst.u;
+
+	if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
+		return -EPROTO;
+
+	memset(tuple, 0, sizeof(*tuple));
+
+	switch (tuple_len) {
+	case sizeof(bpf_tuple->ipv4):
+		tuple->src.l3num = AF_INET;
+		src->ip = bpf_tuple->ipv4.saddr;
+		sport->tcp.port = bpf_tuple->ipv4.sport;
+		dst->ip = bpf_tuple->ipv4.daddr;
+		dport->tcp.port = bpf_tuple->ipv4.dport;
+		break;
+	case sizeof(bpf_tuple->ipv6):
+		tuple->src.l3num = AF_INET6;
+		memcpy(src->ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
+		sport->tcp.port = bpf_tuple->ipv6.sport;
+		memcpy(dst->ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
+		dport->tcp.port = bpf_tuple->ipv6.dport;
+		break;
+	default:
+		return -EAFNOSUPPORT;
+	}
+	tuple->dst.protonum = protonum;
+	tuple->dst.dir = dir;
+
+	return 0;
+}
+
+static struct nf_conn *
+__bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
+			u32 tuple_len, struct bpf_ct_opts *opts, u32 opts_len,
+			u32 timeout)
+{
+	struct nf_conntrack_tuple otuple, rtuple;
+	struct nf_conn *ct;
+	int err;
+
+	if (!opts || !bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
+	    opts_len != NF_BPF_CT_OPTS_SZ)
+		return ERR_PTR(-EINVAL);
+
+	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
+		return ERR_PTR(-EINVAL);
+
+	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
+				    IP_CT_DIR_ORIGINAL, &otuple);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
+				    IP_CT_DIR_REPLY, &rtuple);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	if (opts->netns_id >= 0) {
+		net = get_net_ns_by_id(net, opts->netns_id);
+		if (unlikely(!net))
+			return ERR_PTR(-ENONET);
+	}
+
+	ct = nf_conntrack_alloc(net, &nf_ct_zone_dflt, &otuple, &rtuple,
+				GFP_ATOMIC);
+	if (IS_ERR(ct))
+		goto out;
+
+	memset(&ct->proto, 0, sizeof(ct->proto));
+	__nf_ct_set_timeout(ct, timeout * HZ);
+	ct->status |= IPS_CONFIRMED;
+
+out:
+	if (opts->netns_id >= 0)
+		put_net(net);
+
+	return ct;
+}
+
 static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 					  struct bpf_sock_tuple *bpf_tuple,
 					  u32 tuple_len, struct bpf_ct_opts *opts,
@@ -63,6 +151,7 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 	struct nf_conntrack_tuple_hash *hash;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conn *ct;
+	int err;
 
 	if (!opts || !bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
 	    opts_len != NF_BPF_CT_OPTS_SZ)
@@ -72,27 +161,10 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
 	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
 		return ERR_PTR(-EINVAL);
 
-	memset(&tuple, 0, sizeof(tuple));
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
-	tuple.dst.protonum = opts->l4proto;
+	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
+				    IP_CT_DIR_ORIGINAL, &tuple);
+	if (err < 0)
+		return ERR_PTR(err);
 
 	if (opts->netns_id >= 0) {
 		net = get_net_ns_by_id(net, opts->netns_id);
@@ -116,6 +188,43 @@ __diag_push();
 __diag_ignore_all("-Wmissing-prototypes",
 		  "Global functions as their definitions will be in nf_conntrack BTF");
 
+struct nf_conn___init {
+	struct nf_conn ct;
+};
+
+/* bpf_xdp_ct_alloc - Allocate a new CT entry
+ *
+ * Parameters:
+ * @xdp_ctx	- Pointer to ctx (xdp_md) in XDP program
+ *		    Cannot be NULL
+ * @bpf_tuple	- Pointer to memory representing the tuple to look up
+ *		    Cannot be NULL
+ * @tuple__sz	- Length of the tuple structure
+ *		    Must be one of sizeof(bpf_tuple->ipv4) or
+ *		    sizeof(bpf_tuple->ipv6)
+ * @opts	- Additional options for allocation (documented above)
+ *		    Cannot be NULL
+ * @opts__sz	- Length of the bpf_ct_opts structure
+ *		    Must be NF_BPF_CT_OPTS_SZ (12)
+ */
+struct nf_conn___init *
+bpf_xdp_ct_alloc(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
+		 u32 tuple__sz, struct bpf_ct_opts *opts, u32 opts__sz)
+{
+	struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
+	struct nf_conn *nfct;
+
+	nfct = __bpf_nf_ct_alloc_entry(dev_net(ctx->rxq->dev), bpf_tuple, tuple__sz,
+				       opts, opts__sz, 10);
+	if (IS_ERR(nfct)) {
+		if (opts)
+			opts->error = PTR_ERR(nfct);
+		return NULL;
+	}
+
+	return (struct nf_conn___init *)nfct;
+}
+
 /* bpf_xdp_ct_lookup - Lookup CT entry for the given tuple, and acquire a
  *		       reference to it
  *
@@ -150,6 +259,40 @@ bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 	return nfct;
 }
 
+/* bpf_skb_ct_alloc - Allocate a new CT entry
+ *
+ * Parameters:
+ * @skb_ctx	- Pointer to ctx (__sk_buff) in TC program
+ *		    Cannot be NULL
+ * @bpf_tuple	- Pointer to memory representing the tuple to look up
+ *		    Cannot be NULL
+ * @tuple__sz	- Length of the tuple structure
+ *		    Must be one of sizeof(bpf_tuple->ipv4) or
+ *		    sizeof(bpf_tuple->ipv6)
+ * @opts	- Additional options for allocation (documented above)
+ *		    Cannot be NULL
+ * @opts__sz	- Length of the bpf_ct_opts structure
+ *		    Must be NF_BPF_CT_OPTS_SZ (12)
+ */
+struct nf_conn___init *
+bpf_skb_ct_alloc(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
+		 u32 tuple__sz, struct bpf_ct_opts *opts, u32 opts__sz)
+{
+	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
+	struct nf_conn *nfct;
+	struct net *net;
+
+	net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
+	nfct = __bpf_nf_ct_alloc_entry(net, bpf_tuple, tuple__sz, opts, opts__sz, 10);
+	if (IS_ERR(nfct)) {
+		if (opts)
+			opts->error = PTR_ERR(nfct);
+		return NULL;
+	}
+
+	return (struct nf_conn___init *)nfct;
+}
+
 /* bpf_skb_ct_lookup - Lookup CT entry for the given tuple, and acquire a
  *		       reference to it
  *
@@ -184,6 +327,26 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 	return nfct;
 }
 
+/* bpf_ct_insert_entry - Add the provided entry into a CT map
+ *
+ * This must be invoked for referenced PTR_TO_BTF_ID.
+ *
+ * @nfct__ref	 - Pointer to referenced nf_conn___init object, obtained
+ *		   using bpf_xdp_ct_alloc or bpf_skb_ct_alloc.
+ */
+struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct__ref)
+{
+	struct nf_conn *nfct = (struct nf_conn *)nfct__ref;
+	int err;
+
+	err = nf_conntrack_hash_check_insert(nfct);
+	if (err < 0) {
+		nf_conntrack_free(nfct);
+		return NULL;
+	}
+	return nfct;
+}
+
 /* bpf_ct_release - Release acquired nf_conn object
  *
  * This must be invoked for referenced PTR_TO_BTF_ID, and the verifier rejects
@@ -204,8 +367,11 @@ void bpf_ct_release(struct nf_conn *nfct)
 __diag_pop()
 
 BTF_SET8_START(nf_ct_kfunc_set)
+BTF_ID_FLAGS(func, bpf_xdp_ct_alloc, KF_ACQUIRE, KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_xdp_ct_lookup, KF_ACQUIRE, KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_skb_ct_alloc, KF_ACQUIRE, KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_skb_ct_lookup, KF_ACQUIRE, KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_ct_insert_entry, KF_ACQUIRE, KF_RET_NULL, KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_ct_release, KF_RELEASE)
 BTF_SET8_END(nf_ct_kfunc_set)
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 722af5e309ba..0729b2f0d44f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2025,9 +2025,7 @@ static int ctnetlink_change_timeout(struct nf_conn *ct,
 {
 	u64 timeout = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
 
-	if (timeout > INT_MAX)
-		timeout = INT_MAX;
-	WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
+	__nf_ct_set_timeout(ct, timeout);
 
 	if (test_bit(IPS_DYING_BIT, &ct->status))
 		return -ETIME;
@@ -2292,9 +2290,7 @@ ctnetlink_create_conntrack(struct net *net,
 		goto err1;
 
 	timeout = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
-	if (timeout > INT_MAX)
-		timeout = INT_MAX;
-	ct->timeout = (u32)timeout + nfct_time_stamp;
+	__nf_ct_set_timeout(ct, timeout);
 
 	rcu_read_lock();
  	if (cda[CTA_HELP]) {
-- 
2.34.1

