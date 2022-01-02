Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD40482C01
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbiABQVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233476AbiABQVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:21:39 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93ECC061761;
        Sun,  2 Jan 2022 08:21:39 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id x15so23412700plg.1;
        Sun, 02 Jan 2022 08:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LH0xVtW2G9XAK9GnHWrH19YLmuHolIZgd7QhGAqlP/8=;
        b=HhiuaAo3lwC/qm+HefvxcWNfC9Jw87fn4QMXDwbohOxF2yeaGeH5ySm7zzxwzbJEjX
         7c4S0q/o+bLSva6PqC1hRdkBlmA+W5FYMhoJqyebW7M7iwJxViq3E0n5bM6/2AUaHUV9
         NfLS3hX7F02CGWL+YxREUAH9J/twdhKNFRMxO92G9LQ4aNtsH0nrdFWiKQlnVXYtKg0J
         0ThH0J1aHth2hnByiVChzLdbGlCzZOEpiLkNLzWHJFTxY6vsx72+7spUDuchw/oqUeRD
         /YR5xEgSE9JjNIklyoplHXEmpBrrfs4rT52WtcZM2Z2vyZuh6giiB9QMu0jCdFEw/uWv
         A4bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LH0xVtW2G9XAK9GnHWrH19YLmuHolIZgd7QhGAqlP/8=;
        b=erxo9qIs6HTdYneMHfMZt3fCM6gtGeQ59Otw0+9uPTc+0DVbW09nCZrIY3bZTfEwFu
         S3pXUy/HSGnhxxnTSTF5I1YYlzspfW6vwR/aDMopzmA3MAAAYq6R0xNmT8fiUoj70Ip2
         qUxfwlHK7v+pEOXDYPG2D6BzI1/7Diqz1+N5fDtRSxnUcEDihI8pcFcG+XzYZDrDoXy3
         mnLO5c6Z+lz8IBa54cwOt6/73QFdPkZ6lkezuG9mz+G+BHLrihCzJhrMdvJgg7An2b4J
         2lkFGM8uWdMbe6H0yRbMJNkQlQDpuL2LN4ZUi74v7QkleMQZsndDYaR1yMnfGOVJFZh6
         ZYcA==
X-Gm-Message-State: AOAM5317sagOQqDG4b7feYWWKGUMgD7MlHEQdMuFmvoCRK+7DjMnzaux
        DczoxRwPS+otB2IdzoYbjuTPSnjmjJI=
X-Google-Smtp-Source: ABdhPJyVKa4lqYHAv9pxsLpqn9znBoU6HR+0mHgRcocFIG9iNUJWn1ND+XOTLoHgel/7CERY+Hs6Mg==
X-Received: by 2002:a17:902:8605:b0:149:9a25:103c with SMTP id f5-20020a170902860500b001499a25103cmr20601196plo.155.1641140499019;
        Sun, 02 Jan 2022 08:21:39 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id f4sm32905508pfj.25.2022.01.02.08.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 08:21:38 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v6 07/11] net/netfilter: Add unstable CT lookup helpers for XDP and TC-BPF
Date:   Sun,  2 Jan 2022 21:51:11 +0530
Message-Id: <20220102162115.1506833-8-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220102162115.1506833-1-memxor@gmail.com>
References: <20220102162115.1506833-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12215; h=from:subject; bh=7XYccCt5SjnNcQCG7KmLyqJIpG+RuKr1Y/Y+PbrT3bU=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh0dCK5YrvG2u5ai+a3l5Q/gfMLUdd2J4K06FIT+LT cPJdbxiJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYdHQigAKCRBM4MiGSL8Ryls5D/ 0RZSJKaG+ct5Id8TLfkLZrn7/e2N62nF10GDTG8KLVf4+/y43yixSp6lc/GDnLurSO0dMRpk7Hmgjt WcFGlMr6tKGe3g4JX9d5iocUZnIsni68Tz9WmRdHxBzkvDT3RTXqzbRqtgkHgwz0DViOrhxECPDpf/ MoPitpYwBHAPMFKOMOqbFmXI6bOuDa8lOYewNfhEmJVewmJa71iU8RPXRb+Y6YmvJQsKCrAn5E6lD3 XaIZwtlwZz0rbO/G1cVLg/dJOa0AcEPKkQ/fD3B0diSwzoWZaFRImx9fAkpi2ACZC+yyg2OIQJe1rR MH9V1+Dh4JWvsN0r+7zVOuOVF3438xXgJJXdG3AgZtw3uMA9VqPezX7f02MSGI6AxBLAGcCTOYKTal FrIc0Ved7l7mxeJCZ8csKCMSQwjLJbgPS2cnTf+hqsrrWNSo6R18dfj6RTk5Cx3IMoutTMWLO/gbGp NvAG0NXz3Pd9yUyPgecmixCZbRR4OwdCCrbOLuYzK/8ZHsAI1IviADU5/EagZnHCRz2HNo0PJ2Q74N qC2yilvZbtaH7hOzz6ODARccpn0NejIVFI6IJop2Uc1o8/RFoOzFRmAjx33o3Lh3DWanBHW/sJEZ5H CKjQsJJ4ccvTnuddskwX6HTadzpGFZP6fnMBi8gzJ8qa+LhFzmWNff+/VDNQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds conntrack lookup helpers using the unstable kfunc call
interface for the XDP and TC-BPF hooks. The primary usecase is
implementing a synproxy in XDP, see Maxim's patchset [0].

Export get_net_ns_by_id as nf_conntrack_bpf.c needs to call it.

This object is only built when CONFIG_DEBUG_INFO_BTF_MODULES is enabled.

  [0]: https://lore.kernel.org/bpf/20211019144655.3483197-1-maximmi@nvidia.com

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/net/netfilter/nf_conntrack_bpf.h |  23 ++
 net/core/net_namespace.c                 |   1 +
 net/netfilter/Makefile                   |   5 +
 net/netfilter/nf_conntrack_bpf.c         | 257 +++++++++++++++++++++++
 net/netfilter/nf_conntrack_core.c        |   8 +
 5 files changed, 294 insertions(+)
 create mode 100644 include/net/netfilter/nf_conntrack_bpf.h
 create mode 100644 net/netfilter/nf_conntrack_bpf.c

diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
new file mode 100644
index 000000000000..a473b56842c5
--- /dev/null
+++ b/include/net/netfilter/nf_conntrack_bpf.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _NF_CONNTRACK_BPF_H
+#define _NF_CONNTRACK_BPF_H
+
+#include <linux/btf.h>
+#include <linux/kconfig.h>
+
+#if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
+    (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
+
+extern int register_nf_conntrack_bpf(void);
+
+#else
+
+static inline int register_nf_conntrack_bpf(void)
+{
+	return 0;
+}
+
+#endif
+
+#endif /* _NF_CONNTRACK_BPF_H */
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 9b7171c40434..3b471781327f 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -299,6 +299,7 @@ struct net *get_net_ns_by_id(const struct net *net, int id)
 
 	return peer;
 }
+EXPORT_SYMBOL_GPL(get_net_ns_by_id);
 
 /*
  * setup_net runs the initializers for the network namespace object.
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index aab20e575ecd..39338c957d77 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -14,6 +14,11 @@ nf_conntrack-$(CONFIG_NF_CONNTRACK_LABELS) += nf_conntrack_labels.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_DCCP) += nf_conntrack_proto_dccp.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_SCTP) += nf_conntrack_proto_sctp.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_GRE) += nf_conntrack_proto_gre.o
+ifeq ($(CONFIG_NF_CONNTRACK),m)
+nf_conntrack-$(CONFIG_DEBUG_INFO_BTF_MODULES) += nf_conntrack_bpf.o
+else ifeq ($(CONFIG_NF_CONNTRACK),y)
+nf_conntrack-$(CONFIG_DEBUG_INFO_BTF) += nf_conntrack_bpf.o
+endif
 
 obj-$(CONFIG_NETFILTER) = netfilter.o
 
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
new file mode 100644
index 000000000000..127fe63ad6df
--- /dev/null
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -0,0 +1,257 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Unstable Conntrack Helpers for XDP and TC-BPF hook
+ *
+ * These are called from the XDP and SCHED_CLS BPF programs. Note that it is
+ * allowed to break compatibility for these functions since the interface they
+ * are exposed through to BPF programs is explicitly unstable.
+ */
+
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/types.h>
+#include <linux/btf_ids.h>
+#include <linux/net_namespace.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+
+/* bpf_ct_opts - Options for CT lookup helpers
+ *
+ * Members:
+ * @netns_id   - Specify the network namespace for lookup
+ *		 Values:
+ *		   BPF_F_CURRENT_NETNS (-1)
+ *		     Use namespace associated with ctx (xdp_md, __sk_buff)
+ *		   [0, S32_MAX]
+ *		     Network Namespace ID
+ * @error      - Out parameter, set for any errors encountered
+ *		 Values:
+ *		   -EINVAL - Passed NULL for bpf_tuple pointer
+ *		   -EINVAL - opts->reserved is not 0
+ *		   -EINVAL - netns_id is less than -1
+ *		   -EINVAL - opts__sz isn't NF_BPF_CT_OPTS_SZ (12)
+ *		   -EPROTO - l4proto isn't one of IPPROTO_TCP or IPPROTO_UDP
+ *		   -ENONET - No network namespace found for netns_id
+ *		   -ENOENT - Conntrack lookup could not find entry for tuple
+ *		   -EAFNOSUPPORT - tuple__sz isn't one of sizeof(tuple->ipv4)
+ *				   or sizeof(tuple->ipv6)
+ * @l4proto    - Layer 4 protocol
+ *		 Values:
+ *		   IPPROTO_TCP, IPPROTO_UDP
+ * @reserved   - Reserved member, will be reused for more options in future
+ *		 Values:
+ *		   0
+ */
+struct bpf_ct_opts {
+	s32 netns_id;
+	s32 error;
+	u8 l4proto;
+	u8 reserved[3];
+};
+
+enum {
+	NF_BPF_CT_OPTS_SZ = 12,
+};
+
+static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
+					  struct bpf_sock_tuple *bpf_tuple,
+					  u32 tuple_len, u8 protonum,
+					  s32 netns_id)
+{
+	struct nf_conntrack_tuple_hash *hash;
+	struct nf_conntrack_tuple tuple;
+
+	if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
+		return ERR_PTR(-EPROTO);
+	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
+		return ERR_PTR(-EINVAL);
+
+	memset(&tuple, 0, sizeof(tuple));
+	switch (tuple_len) {
+	case sizeof(bpf_tuple->ipv4):
+		tuple.src.l3num = AF_INET;
+		tuple.src.u3.ip = bpf_tuple->ipv4.saddr;
+		tuple.src.u.tcp.port = bpf_tuple->ipv4.sport;
+		tuple.dst.u3.ip = bpf_tuple->ipv4.daddr;
+		tuple.dst.u.tcp.port = bpf_tuple->ipv4.dport;
+		break;
+	case sizeof(bpf_tuple->ipv6):
+		tuple.src.l3num = AF_INET6;
+		memcpy(tuple.src.u3.ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
+		tuple.src.u.tcp.port = bpf_tuple->ipv6.sport;
+		memcpy(tuple.dst.u3.ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
+		tuple.dst.u.tcp.port = bpf_tuple->ipv6.dport;
+		break;
+	default:
+		return ERR_PTR(-EAFNOSUPPORT);
+	}
+
+	tuple.dst.protonum = protonum;
+
+	if (netns_id >= 0) {
+		net = get_net_ns_by_id(net, netns_id);
+		if (unlikely(!net))
+			return ERR_PTR(-ENONET);
+	}
+
+	hash = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tuple);
+	if (netns_id >= 0)
+		put_net(net);
+	if (!hash)
+		return ERR_PTR(-ENOENT);
+	return nf_ct_tuplehash_to_ctrack(hash);
+}
+
+__diag_push();
+__diag_ignore(GCC, 8, "-Wmissing-prototypes",
+	      "Global functions as their definitions will be in nf_conntrack BTF");
+
+/* bpf_xdp_ct_lookup - Lookup CT entry for the given tuple, and acquire a
+ *		       reference to it
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
+bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx, struct bpf_sock_tuple *bpf_tuple,
+		  u32 tuple__sz, struct bpf_ct_opts *opts, u32 opts__sz)
+{
+	struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
+	struct net *caller_net;
+	struct nf_conn *nfct;
+
+	BUILD_BUG_ON(sizeof(struct bpf_ct_opts) != NF_BPF_CT_OPTS_SZ);
+
+	if (!opts)
+		return NULL;
+	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
+	    opts->reserved[2] || opts__sz != NF_BPF_CT_OPTS_SZ) {
+		opts->error = -EINVAL;
+		return NULL;
+	}
+	caller_net = dev_net(ctx->rxq->dev);
+	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts->l4proto,
+				  opts->netns_id);
+	if (IS_ERR(nfct)) {
+		opts->error = PTR_ERR(nfct);
+		return NULL;
+	}
+	return nfct;
+}
+
+/* bpf_skb_ct_lookup - Lookup CT entry for the given tuple, and acquire a
+ *		       reference to it
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
+bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
+		  u32 tuple__sz, struct bpf_ct_opts *opts, u32 opts__sz)
+{
+	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
+	struct net *caller_net;
+	struct nf_conn *nfct;
+
+	BUILD_BUG_ON(sizeof(struct bpf_ct_opts) != NF_BPF_CT_OPTS_SZ);
+
+	if (!opts)
+		return NULL;
+	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
+	    opts->reserved[2] || opts__sz != NF_BPF_CT_OPTS_SZ) {
+		opts->error = -EINVAL;
+		return NULL;
+	}
+	caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
+	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, tuple__sz, opts->l4proto,
+				  opts->netns_id);
+	if (IS_ERR(nfct)) {
+		opts->error = PTR_ERR(nfct);
+		return NULL;
+	}
+	return nfct;
+}
+
+/* bpf_ct_release - Release acquired nf_conn object
+ *
+ * This must be invoked for referenced PTR_TO_BTF_ID, and the verifier rejects
+ * the program if any references remain in the program in all of the explored
+ * states.
+ *
+ * Parameters:
+ * @nf_conn	 - Pointer to referenced nf_conn object, obtained using
+ *		   bpf_xdp_ct_lookup or bpf_skb_ct_lookup.
+ */
+void bpf_ct_release(struct nf_conn *nfct)
+{
+	if (!nfct)
+		return;
+	nf_ct_put(nfct);
+}
+
+__diag_pop()
+
+BTF_SET_START(nf_ct_xdp_check_kfunc_ids)
+BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_ct_release)
+BTF_SET_END(nf_ct_xdp_check_kfunc_ids)
+
+BTF_SET_START(nf_ct_tc_check_kfunc_ids)
+BTF_ID(func, bpf_skb_ct_lookup)
+BTF_ID(func, bpf_ct_release)
+BTF_SET_END(nf_ct_tc_check_kfunc_ids)
+
+BTF_SET_START(nf_ct_acquire_kfunc_ids)
+BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_skb_ct_lookup)
+BTF_SET_END(nf_ct_acquire_kfunc_ids)
+
+BTF_SET_START(nf_ct_release_kfunc_ids)
+BTF_ID(func, bpf_ct_release)
+BTF_SET_END(nf_ct_release_kfunc_ids)
+
+/* Both sets are identical */
+#define nf_ct_ret_null_kfunc_ids nf_ct_acquire_kfunc_ids
+
+static const struct btf_kfunc_id_set nf_conntrack_xdp_kfunc_set = {
+	.owner        = THIS_MODULE,
+	.check_set    = &nf_ct_xdp_check_kfunc_ids,
+	.acquire_set  = &nf_ct_acquire_kfunc_ids,
+	.release_set  = &nf_ct_release_kfunc_ids,
+	.ret_null_set = &nf_ct_ret_null_kfunc_ids,
+};
+
+static const struct btf_kfunc_id_set nf_conntrack_tc_kfunc_set = {
+	.owner        = THIS_MODULE,
+	.check_set    = &nf_ct_tc_check_kfunc_ids,
+	.acquire_set  = &nf_ct_acquire_kfunc_ids,
+	.release_set  = &nf_ct_release_kfunc_ids,
+	.ret_null_set = &nf_ct_ret_null_kfunc_ids,
+};
+
+int register_nf_conntrack_bpf(void)
+{
+	int ret;
+
+	ret = register_btf_kfunc_id_set(BTF_KFUNC_HOOK_XDP, &nf_conntrack_xdp_kfunc_set);
+	return ret ?: register_btf_kfunc_id_set(BTF_KFUNC_HOOK_TC, &nf_conntrack_tc_kfunc_set);
+}
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9fbce31baf75..d8b61a0f6202 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -34,6 +34,7 @@
 #include <linux/rculist_nulls.h>
 
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_bpf.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
@@ -2745,8 +2746,15 @@ int nf_conntrack_init_start(void)
 	conntrack_gc_work_init(&conntrack_gc_work);
 	queue_delayed_work(system_power_efficient_wq, &conntrack_gc_work.dwork, HZ);
 
+	ret = register_nf_conntrack_bpf();
+	if (ret < 0)
+		goto err_kfunc;
+
 	return 0;
 
+err_kfunc:
+	cancel_delayed_work_sync(&conntrack_gc_work.dwork);
+	nf_conntrack_proto_fini();
 err_proto:
 	nf_conntrack_seqadj_fini();
 err_seqadj:
-- 
2.34.1

