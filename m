Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C884818B1
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbhL3Chb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbhL3Ch1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:37:27 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9283C061746;
        Wed, 29 Dec 2021 18:37:27 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id b22so20181278pfb.5;
        Wed, 29 Dec 2021 18:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qOUV2uaAvPrTRP14OzI1vl6Xpe7e8E6MUHtsRcMRtMs=;
        b=L/BdPfJ6TT960jAEXa6D/kSk7EbU83VM5d/jJGxhNKJKe1r+aKZPwPxAXnCArjGLCW
         9wTm21la1GK/M4FJ3tqqS8qVN+XokwsUC2N6NZbmew3NOS1SwNscQyldNOqx+FqIO8bE
         q63gJcnA/GYSfga96YEmi+1rumEzZzsDyWwe+60DSsvPyTrFz/BEjDrN806whhEnDpAW
         GWKD+ykA29eaCoS5te5fJQAPnLRv3gBEKCu1pjReYlFD52MK+BSatJTjAB6KowJ9cEwU
         VUUc4Mi259b/dtbcSWA80VoFVavAOBLHlqePegrxpGNSfCHgxWCTCVPL8RpjF8CAzxr5
         yx+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qOUV2uaAvPrTRP14OzI1vl6Xpe7e8E6MUHtsRcMRtMs=;
        b=xxlmw853EMSFTV/JJbCzwrZLYp23is8agwJ0jXQys93J1MnBoxAW75XpaD7nXS2lsX
         1sQJ24KuRrXBI2pwzEwvMh28vhztWgZfs+hgVemaB6DZN1XlTB7pnv1e736YTFz+L332
         6sVjNNw1mJeIfg32L3kjYaVEWloojPEoxB0HCCP76ZSWj16rBC98fQl481FIsPpgznQP
         5cHoWU+oteAkDM4/Ut7OQ8HVBQsr6jJ4VJJTLimAIfy9CmNw+FdT+NNZgPJyQ89vux4v
         gYu7urc7CmLIBP2yW1GJFGvXJbp9ho3p9gJj3eZVLscRuOu4mU5j2ygOSRCZR3Yx6FAl
         BkCQ==
X-Gm-Message-State: AOAM530cFRaCtl2hFETX9RmjaSu6YGx0IhIyumFKnm1RskQhyfElGsw1
        DBbzARiYGEgJHFUBL8zoGh14SsHwzLw=
X-Google-Smtp-Source: ABdhPJzGBRvTilZPSVpzFf+TlGt+khv0gRkFtOc5YemorBUsZXRA/B2CoUd0cIKbC/mNPyuva+WwIg==
X-Received: by 2002:a05:6a00:1944:b0:438:d002:6e35 with SMTP id s4-20020a056a00194400b00438d0026e35mr29169706pfk.20.1640831846964;
        Wed, 29 Dec 2021 18:37:26 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id h5sm19966223pjc.27.2021.12.29.18.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 18:37:26 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v5 6/9] net/netfilter: Add unstable CT lookup helpers for XDP and TC-BPF
Date:   Thu, 30 Dec 2021 08:07:02 +0530
Message-Id: <20211230023705.3860970-7-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211230023705.3860970-1-memxor@gmail.com>
References: <20211230023705.3860970-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10253; h=from:subject; bh=Y+zjP3SqLhg1aE+Sm+9oXbIVxoeKmZzxClWvMb1iDCk=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhzRr+SbOW/bAF6uYhaBBa9Z5l+AF31Pqb/oezi6rZ Go1zWvmJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYc0a/gAKCRBM4MiGSL8Ryu8SD/ 9srbSPY9mTitiKPF3yKjLvf9WE9qrR3LP0+VK3GcU6HsqEBB5888SJyxDGUz2ene+FtEVdlda/5V4L irBMxIfTJadIyxWmhHY5heq2jUkI6DuVA3XW5NXsA/GwXmXBJPDkvhxZKzAuzxNxwWCfA4O2kISupw COtMgvOYJNG9bH1i0cTij8WgyKV8qjFPVi2mVXbpzTT4DxiZmBrBBiZZec+ip//dOkCzHr/qpCjPxf MSO77HM3Y00J6aW46UbDZljBIbekbl0ABbUn5Eup3rd6x0I+dAgnAoszl2/puyPWYHkAh4AKA7qYzF Hg7AO0LlENnxAF5wWurUdWqfozA2vIprP6c11EcP+OJGDkkrHy1JtRiCWWQ3sccb6MCbUJ9ByPRk2/ zYDiIcT5eYlpPqAo4VFFWjcd5g/pX3Fww05kHyefjeeRICc7InGmpJlaaXISpLLLTyXsbt20+4Wd46 MK6Bj/vJ4w4J85a9LvwwH0h08xmXM1Km36jfKIMh24KsGZLzalEF94Fa5mIpPR5BDi7BE+vQqT8eaZ okzn3OpIaDRNXx7/6dVRDrGLi5x5nl96G/l8+hF/8ziSjM7UEzGFhfHkCF/tqz8tou9KVl3R8pWXLB Ythf/iKI3LTIP/C15xKBuAntkYWf9eVcXit9GybMxDP1vkY3szNyMtChD+xA==
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
 net/core/net_namespace.c         |   1 +
 net/netfilter/Makefile           |   5 +
 net/netfilter/nf_conntrack_bpf.c | 253 +++++++++++++++++++++++++++++++
 3 files changed, 259 insertions(+)
 create mode 100644 net/netfilter/nf_conntrack_bpf.c

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
index 000000000000..878d5bf947e1
--- /dev/null
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -0,0 +1,253 @@
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
+/* XDP hook allowed kfuncs */
+BTF_KFUNC_SET_START(xdp, check, nf_conntrack)
+BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_ct_release)
+BTF_KFUNC_SET_END(xdp, check, nf_conntrack)
+
+/* XDP hook acquire kfuncs */
+BTF_KFUNC_SET_START(xdp, acquire, nf_conntrack)
+BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_KFUNC_SET_END(xdp, acquire, nf_conntrack)
+
+/* XDP hook release kfuncs */
+BTF_KFUNC_SET_START(xdp, release, nf_conntrack)
+BTF_ID(func, bpf_ct_release)
+BTF_KFUNC_SET_END(xdp, release, nf_conntrack)
+
+/* XDP hook 'ret type NULL' kfuncs */
+BTF_KFUNC_SET_START(xdp, ret_null, nf_conntrack)
+BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_KFUNC_SET_END(xdp, ret_null, nf_conntrack)
+
+/* TC hook allowed kfuncs */
+BTF_KFUNC_SET_START(tc, check, nf_conntrack)
+BTF_ID(func, bpf_skb_ct_lookup)
+BTF_ID(func, bpf_ct_release)
+BTF_KFUNC_SET_END(tc, check, nf_conntrack)
+
+/* TC hook acquire kfuncs */
+BTF_KFUNC_SET_START(tc, acquire, nf_conntrack)
+BTF_ID(func, bpf_skb_ct_lookup)
+BTF_KFUNC_SET_END(tc, acquire, nf_conntrack)
+
+/* TC hook release kfuncs */
+BTF_KFUNC_SET_START(tc, release, nf_conntrack)
+BTF_ID(func, bpf_ct_release)
+BTF_KFUNC_SET_END(tc, release, nf_conntrack)
+
+/* TC hook 'ret type NULL' kfuncs */
+BTF_KFUNC_SET_START(tc, ret_null, nf_conntrack)
+BTF_ID(func, bpf_skb_ct_lookup)
+BTF_KFUNC_SET_END(tc, ret_null, nf_conntrack)
-- 
2.34.1

