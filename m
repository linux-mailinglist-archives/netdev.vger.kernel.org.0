Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AD65355AA
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349225AbiEZVgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349213AbiEZVgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:36:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C484E8BA1;
        Thu, 26 May 2022 14:36:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7351761BBD;
        Thu, 26 May 2022 21:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D231C34116;
        Thu, 26 May 2022 21:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653600973;
        bh=32ijmS+Vw0CgALGmJCM7pejNr0t6CWOCYaVkDcHKlQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2O/uN5xEesuI4F67HCK8xwTpPo7/IRiX9Uc44FJa6P7pFF205Hw5KDxZeyEM8qhr
         tBnVIchGPIAl9+gveuNx9Gm+qiE3XGiZ4tsGXIBGkKzCH7dDQixUnF8uUhlbzgCLXM
         +BalQ2zqcm18T+fxvK8QgHV4A9v50LZf2EUig0Kgfy0UbtjpIi+o5oindL2pRzSONX
         +GVk+dql/GfVKXoB7jxXmk3Q0+/MmATDTJ+G2M88Dvo14txE6gNKNpJbfpQkVRGYWB
         Nqio+3trBprSgCzjqyt7L+vIrB/oXINGGjnhqy9hR/u6jxySVDNOmmYnXRyC1uNSWN
         q5vlNtp6K2j9Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: [PATCH v4 bpf-next 12/14] net: netfilter: add kfunc helpers to alloc and insert a new ct entry
Date:   Thu, 26 May 2022 23:35:00 +0200
Message-Id: <86705f38237703c3f065930a2fac8563f9c81e1d.1653600578.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653600577.git.lorenzo@kernel.org>
References: <cover.1653600577.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bpf_xdp_ct_alloc, bpf_skb_ct_alloc and bpf_ct_insert_entry
kfunc helpers in order to add a new entry to ct map from an ebpf program.
Introduce bpf_nf_ct_tuple_parse utility routine.

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/netfilter/nf_conntrack_bpf.c | 249 ++++++++++++++++++++++++++++---
 1 file changed, 226 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index c50f4c1e5b3a..70731b57b2d4 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -57,41 +57,106 @@ enum {
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
+	}
+	tuple->dst.protonum = protonum;
+	tuple->dst.dir = dir;
+
+	return 0;
+}
+
+static struct nf_conn *
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
 	}
 
-	tuple.dst.protonum = protonum;
+	ct = nf_conntrack_alloc(net, &nf_ct_zone_dflt, &otuple, &rtuple,
+				GFP_ATOMIC);
+	if (IS_ERR(ct))
+		goto out;
+
+	memset(&ct->proto, 0, sizeof(ct->proto));
+	ct->timeout = timeout * HZ + jiffies;
+	ct->status |= IPS_CONFIRMED;
+
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
@@ -116,6 +181,49 @@ __diag_push();
 __diag_ignore_all("-Wmissing-prototypes",
 		  "Global functions as their definitions will be in nf_conntrack BTF");
 
+/* bpf_xdp_ct_alloc - Alloc a new CT entry for the given tuple
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
+bpf_xdp_ct_alloc(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
+		 u32 tuple__sz, struct bpf_ct_opts *opts, u32 opts__sz)
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
@@ -159,6 +267,50 @@ bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
 	return nfct;
 }
 
+/* bpf_skb_ct_alloc - Alloc a new CT entry for the given tuple
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
+bpf_skb_ct_alloc(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
+		 u32 tuple__sz, struct bpf_ct_opts *opts, u32 opts__sz)
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
@@ -202,6 +354,40 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 	return nfct;
 }
 
+/* bpf_ct_insert_entry - Add the provided entry into a CT map
+ *
+ * This must be invoked for referenced PTR_TO_BTF_ID.
+ *
+ * @nfct__ref	 - Pointer to referenced nf_conn object
+ */
+const struct nf_conn *
+bpf_ct_insert_entry(struct nf_conn *nfct__ref, struct bpf_ct_opts *opts,
+		    u32 opts__sz)
+{
+	int err;
+
+	BUILD_BUG_ON(sizeof(struct bpf_ct_opts) != NF_BPF_CT_OPTS_SZ);
+
+	if (!nfct__ref)
+		return NULL;
+
+	if (!opts || opts->reserved[0] || opts->reserved[1] ||
+	    opts__sz != NF_BPF_CT_OPTS_SZ) {
+		nf_conntrack_free(nfct__ref);
+		opts->error = -EINVAL;
+		return NULL;
+	}
+
+	err = nf_conntrack_hash_check_insert(nfct__ref);
+	if (err < 0) {
+		nf_conntrack_free(nfct__ref);
+		opts->error = err;
+		return NULL;
+	}
+
+	return nfct__ref;
+}
+
 /* bpf_ct_release - Release acquired nf_conn object
  *
  * This must be invoked for referenced PTR_TO_BTF_ID, and the verifier rejects
@@ -243,23 +429,31 @@ void bpf_ct_refresh_timeout(const struct nf_conn *nfct__ref, u32 timeout)
 __diag_pop()
 
 BTF_SET_START(nf_ct_xdp_check_kfunc_ids)
+BTF_ID(func, bpf_xdp_ct_alloc)
 BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_ct_insert_entry)
 BTF_ID(func, bpf_ct_release)
 BTF_ID(func, bpf_ct_refresh_timeout);
 BTF_SET_END(nf_ct_xdp_check_kfunc_ids)
 
 BTF_SET_START(nf_ct_tc_check_kfunc_ids)
+BTF_ID(func, bpf_skb_ct_alloc)
 BTF_ID(func, bpf_skb_ct_lookup)
+BTF_ID(func, bpf_ct_insert_entry)
 BTF_ID(func, bpf_ct_release)
 BTF_ID(func, bpf_ct_refresh_timeout);
 BTF_SET_END(nf_ct_tc_check_kfunc_ids)
 
 BTF_SET_START(nf_ct_acquire_kfunc_ids)
+BTF_ID(func, bpf_xdp_ct_alloc)
 BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_skb_ct_alloc)
 BTF_ID(func, bpf_skb_ct_lookup)
+BTF_ID(func, bpf_ct_insert_entry)
 BTF_SET_END(nf_ct_acquire_kfunc_ids)
 
 BTF_SET_START(nf_ct_release_kfunc_ids)
+BTF_ID(func, bpf_ct_insert_entry)
 BTF_ID(func, bpf_ct_release)
 BTF_SET_END(nf_ct_release_kfunc_ids)
 
@@ -267,12 +461,21 @@ BTF_SET_END(nf_ct_release_kfunc_ids)
 #define nf_ct_ret_null_kfunc_ids nf_ct_acquire_kfunc_ids
 
 BTF_ID_LIST(nf_ct_acq_rel_pairs)
+BTF_ID(func, bpf_xdp_ct_alloc)
+BTF_ID(func, bpf_ct_insert_entry)
+
+BTF_ID(func, bpf_skb_ct_alloc)
+BTF_ID(func, bpf_ct_insert_entry)
+
 BTF_ID(func, bpf_xdp_ct_lookup)
 BTF_ID(func, bpf_ct_release)
 
 BTF_ID(func, bpf_skb_ct_lookup)
 BTF_ID(func, bpf_ct_release)
 
+BTF_ID(func, bpf_ct_insert_entry)
+BTF_ID(func, bpf_ct_release)
+
 static const struct btf_kfunc_id_set nf_conntrack_xdp_kfunc_set = {
 	.owner             = THIS_MODULE,
 	.check_set         = &nf_ct_xdp_check_kfunc_ids,
-- 
2.35.3

