Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D31452B7E2
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 12:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbiERKoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 06:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbiERKoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 06:44:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EEA527E1;
        Wed, 18 May 2022 03:44:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D238861844;
        Wed, 18 May 2022 10:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC52C385A5;
        Wed, 18 May 2022 10:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652870672;
        bh=kT/jnEQNpeBlpEcZUpr7ZWcrr71EhvLE5BtzAvIHFtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4pvtGhxVG7JBqjsXNeXclg0FHx7aNzKBtEuMdM8GIAgE1ShzcivLfSde438iNTFV
         SDNEK3NXNnSHsoeZOMr3pmAq1XNI8egKkAX75Awjtgas1z3i19wn6QOL01bN0B3Smr
         povzmCYPac16AVOL6uM+5aiP5tY7OpFItBQBEzc1lY8KnuaOr34TjVMK7LMJSFNtuF
         NRaSedcxPaym2vvbon9Z74e9XtYCyHBhj8mHYtSkuuVgqRESvDYkjH1kNvTEqpiThL
         nFEm3TZbVn5luFWnLr2ObBDRALwcw9YwPgNRisKTmWZFV3RBmm0R2w+T/jH5tjakia
         XNqUlwKJ385Gg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH v3 bpf-next 4/5] net: netfilter: add kfunc helper to add a new ct entry
Date:   Wed, 18 May 2022 12:43:37 +0200
Message-Id: <40e7ce4b79c86c46e5fbf22e9cafb51b9172da19.1652870182.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1652870182.git.lorenzo@kernel.org>
References: <cover.1652870182.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bpf_xdp_ct_add and bpf_skb_ct_add kfunc helpers in order to
add a new entry to ct map from an ebpf program.
Introduce bpf_nf_ct_tuple_parse utility routine.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/netfilter/nf_conntrack_bpf.c | 212 +++++++++++++++++++++++++++----
 1 file changed, 189 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index a9271418db88..3d31b602fdf1 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -55,41 +55,114 @@ enum {
 	NF_BPF_CT_OPTS_SZ = 12,
 };
 
-static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
-					  struct bpf_sock_tuple *bpf_tuple,
-					  u32 tuple_len, u8 protonum,
-					  s32 netns_id, u8 *dir)
+static int bpf_nf_ct_tuple_parse(struct bpf_sock_tuple *bpf_tuple,
+				 u32 tuple_len, u8 protonum, u8 dir,
+				 struct nf_conntrack_tuple *tuple)
 {
-	struct nf_conntrack_tuple_hash *hash;
-	struct nf_conntrack_tuple tuple;
-	struct nf_conn *ct;
+	union nf_inet_addr *src = dir ? &tuple->dst.u3 : &tuple->src.u3;
+	union nf_inet_addr *dst = dir ? &tuple->src.u3 : &tuple->dst.u3;
+	union nf_conntrack_man_proto *sport = dir ? (void *)&tuple->dst.u
+						  : &tuple->src.u;
+	union nf_conntrack_man_proto *dport = dir ? &tuple->src.u
+						  : (void *)&tuple->dst.u;
 
 	if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
-		return ERR_PTR(-EPROTO);
-	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
-		return ERR_PTR(-EINVAL);
+		return -EPROTO;
+
+	memset(tuple, 0, sizeof(*tuple));
 
-	memset(&tuple, 0, sizeof(tuple));
 	switch (tuple_len) {
 	case sizeof(bpf_tuple->ipv4):
-		tuple.src.l3num = AF_INET;
-		tuple.src.u3.ip = bpf_tuple->ipv4.saddr;
-		tuple.src.u.tcp.port = bpf_tuple->ipv4.sport;
-		tuple.dst.u3.ip = bpf_tuple->ipv4.daddr;
-		tuple.dst.u.tcp.port = bpf_tuple->ipv4.dport;
+		tuple->src.l3num = AF_INET;
+		src->ip = bpf_tuple->ipv4.saddr;
+		sport->tcp.port = bpf_tuple->ipv4.sport;
+		dst->ip = bpf_tuple->ipv4.daddr;
+		dport->tcp.port = bpf_tuple->ipv4.dport;
 		break;
 	case sizeof(bpf_tuple->ipv6):
-		tuple.src.l3num = AF_INET6;
-		memcpy(tuple.src.u3.ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
-		tuple.src.u.tcp.port = bpf_tuple->ipv6.sport;
-		memcpy(tuple.dst.u3.ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
-		tuple.dst.u.tcp.port = bpf_tuple->ipv6.dport;
+		tuple->src.l3num = AF_INET6;
+		memcpy(src->ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
+		sport->tcp.port = bpf_tuple->ipv6.sport;
+		memcpy(dst->ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
+		dport->tcp.port = bpf_tuple->ipv6.dport;
 		break;
 	default:
-		return ERR_PTR(-EAFNOSUPPORT);
+		return -EAFNOSUPPORT;
 	}
+	tuple->dst.protonum = protonum;
+	tuple->dst.dir = dir;
+
+	return 0;
+}
 
-	tuple.dst.protonum = protonum;
+struct nf_conn *
+__bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
+			u32 tuple_len, u8 protonum, s32 netns_id, u32 timeout)
+{
+	struct nf_conntrack_tuple otuple, rtuple;
+	struct nf_conn *ct;
+	int err;
+
+	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
+		return ERR_PTR(-EINVAL);
+
+	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, protonum,
+				    IP_CT_DIR_ORIGINAL, &otuple);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, protonum,
+				    IP_CT_DIR_REPLY, &rtuple);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	if (netns_id >= 0) {
+		net = get_net_ns_by_id(net, netns_id);
+		if (unlikely(!net))
+			return ERR_PTR(-ENONET);
+	}
+
+	ct = nf_conntrack_alloc(net, &nf_ct_zone_dflt, &otuple, &rtuple,
+				GFP_ATOMIC);
+	if (IS_ERR(ct))
+		goto out;
+
+	ct->timeout = timeout * HZ + jiffies;
+	ct->status |= IPS_CONFIRMED;
+
+	memset(&ct->proto, 0, sizeof(ct->proto));
+	if (protonum == IPPROTO_TCP)
+		ct->proto.tcp.state = TCP_CONNTRACK_ESTABLISHED;
+
+	err = nf_conntrack_hash_check_insert(ct);
+	if (err < 0) {
+		nf_conntrack_free(ct);
+		ct = ERR_PTR(err);
+	}
+out:
+	if (netns_id >= 0)
+		put_net(net);
+
+	return ct;
+}
+
+static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
+					  struct bpf_sock_tuple *bpf_tuple,
+					  u32 tuple_len, u8 protonum,
+					  s32 netns_id, u8 *dir)
+{
+	struct nf_conntrack_tuple_hash *hash;
+	struct nf_conntrack_tuple tuple;
+	struct nf_conn *ct;
+	int err;
+
+	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
+		return ERR_PTR(-EINVAL);
+
+	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, protonum,
+				    IP_CT_DIR_ORIGINAL, &tuple);
+	if (err < 0)
+		return ERR_PTR(err);
 
 	if (netns_id >= 0) {
 		net = get_net_ns_by_id(net, netns_id);
@@ -114,6 +187,50 @@ __diag_push();
 __diag_ignore_all("-Wmissing-prototypes",
 		  "Global functions as their definitions will be in nf_conntrack BTF");
 
+/* bpf_xdp_ct_add - Add a new CT entry for the given tuple and acquire a
+ *		    reference to it
+ *
+ * Parameters:
+ * @xdp_ctx	- Pointer to ctx (xdp_md) in XDP program
+ *		    Cannot be NULL
+ * @bpf_tuple	- Pointer to memory representing the tuple to look up
+ *		    Cannot be NULL
+ * @tuple__sz	- Length of the tuple structure
+ *		    Must be one of sizeof(bpf_tuple->ipv4) or
+ *		    sizeof(bpf_tuple->ipv6)
+ * @opts	- Additional options for lookup (documented above)
+ *		    Cannot be NULL
+ * @opts__sz	- Length of the bpf_ct_opts structure
+ *		    Must be NF_BPF_CT_OPTS_SZ (12)
+ */
+struct nf_conn *
+bpf_xdp_ct_add(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
+	       u32 tuple__sz, struct bpf_ct_opts *opts, u32 opts__sz)
+{
+	struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
+	struct nf_conn *nfct;
+
+	BUILD_BUG_ON(sizeof(struct bpf_ct_opts) != NF_BPF_CT_OPTS_SZ);
+	if (!opts)
+		return NULL;
+
+	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
+	    opts__sz != NF_BPF_CT_OPTS_SZ) {
+		opts->error = -EINVAL;
+		return NULL;
+	}
+
+	nfct =  __bpf_nf_ct_alloc_entry(dev_net(ctx->rxq->dev), bpf_tuple,
+					tuple__sz, opts->l4proto,
+					opts->netns_id, 10);
+	if (IS_ERR_OR_NULL(nfct)) {
+		opts->error = PTR_ERR(nfct);
+		return NULL;
+	}
+
+	return nfct;
+}
+
 /* bpf_xdp_ct_lookup - Lookup CT entry for the given tuple, and acquire a
  *		       reference to it
  *
@@ -157,6 +274,51 @@ bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 	return nfct;
 }
 
+/* bpf_skb_ct_add - Add a new CT entry for the given tuple and acquire a
+ *		    reference to it
+ *
+ * Parameters:
+ * @skb_ctx	- Pointer to ctx (__sk_buff) in TC program
+ *		    Cannot be NULL
+ * @bpf_tuple	- Pointer to memory representing the tuple to look up
+ *		    Cannot be NULL
+ * @tuple__sz	- Length of the tuple structure
+ *		    Must be one of sizeof(bpf_tuple->ipv4) or
+ *		    sizeof(bpf_tuple->ipv6)
+ * @opts	- Additional options for lookup (documented above)
+ *		    Cannot be NULL
+ * @opts__sz	- Length of the bpf_ct_opts structure
+ *		    Must be NF_BPF_CT_OPTS_SZ (12)
+ */
+struct nf_conn *
+bpf_skb_ct_add(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
+	       u32 tuple__sz, struct bpf_ct_opts *opts, u32 opts__sz)
+{
+	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
+	struct nf_conn *nfct;
+	struct net *net;
+
+	BUILD_BUG_ON(sizeof(struct bpf_ct_opts) != NF_BPF_CT_OPTS_SZ);
+	if (!opts)
+		return NULL;
+
+	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
+	    opts__sz != NF_BPF_CT_OPTS_SZ) {
+		opts->error = -EINVAL;
+		return NULL;
+	}
+
+	net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
+	nfct = __bpf_nf_ct_alloc_entry(net, bpf_tuple, tuple__sz,
+				       opts->l4proto, opts->netns_id, 10);
+	if (IS_ERR_OR_NULL(nfct)) {
+		opts->error = PTR_ERR(nfct);
+		return NULL;
+	}
+
+	return nfct;
+}
+
 /* bpf_skb_ct_lookup - Lookup CT entry for the given tuple, and acquire a
  *		       reference to it
  *
@@ -238,19 +400,23 @@ void bpf_ct_refresh_timeout(struct nf_conn *nfct__ref, u32 timeout)
 __diag_pop()
 
 BTF_SET_START(nf_ct_xdp_check_kfunc_ids)
+BTF_ID(func, bpf_xdp_ct_add)
 BTF_ID(func, bpf_xdp_ct_lookup)
 BTF_ID(func, bpf_ct_release)
 BTF_ID(func, bpf_ct_refresh_timeout);
 BTF_SET_END(nf_ct_xdp_check_kfunc_ids)
 
 BTF_SET_START(nf_ct_tc_check_kfunc_ids)
+BTF_ID(func, bpf_skb_ct_add)
 BTF_ID(func, bpf_skb_ct_lookup)
 BTF_ID(func, bpf_ct_release)
 BTF_ID(func, bpf_ct_refresh_timeout);
 BTF_SET_END(nf_ct_tc_check_kfunc_ids)
 
 BTF_SET_START(nf_ct_acquire_kfunc_ids)
+BTF_ID(func, bpf_xdp_ct_add)
 BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_skb_ct_add)
 BTF_ID(func, bpf_skb_ct_lookup)
 BTF_SET_END(nf_ct_acquire_kfunc_ids)
 
-- 
2.35.3

