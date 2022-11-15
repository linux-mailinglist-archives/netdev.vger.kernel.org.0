Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF4F629062
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiKODEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237390AbiKODDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:03:12 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FEEE3B
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:18 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id q6-20020a170902dac600b001873ef77938so10354433plx.18
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FVcjJTYs3qCTkpvcT8nqvJ1EIP9Gk9gj05zdIvg+G/4=;
        b=HN4cBokocanuFyOXb64l/iL3pA0M2RMz4yk+DugW6A4fe3ZodPd4y1Jq4ie7ScmAzB
         j5Vo4Eg9wj3prU+naUqkMs1BTGvJ1JeMFH9NdRr2e4IKbH8rzaAH+M/wtXiRyz6i92XG
         eaQH6ILLJYL22e3ix1hH8rp1ATNgsJP+U2dTcNqg66vZ0LniGf5NprJsTGzOVXRbgGwV
         bRbGTOwDQHoQkvxFCbLdz7/GIJ4A/waf7UagTm0ETBRrCoM6ZRFwK89tsN0S/aRe3euS
         ltQL8rTMBy6r0RlYMwr1zRpdUWShOf3AmZzDX/cw+SpajUofndbQwoTb+wTuLF8olsAv
         VkiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FVcjJTYs3qCTkpvcT8nqvJ1EIP9Gk9gj05zdIvg+G/4=;
        b=x3bE6IQxMK59m5wS6rmVQ/7AWMVqPyhXriHoIQdZx+8oQ7ufBG2uIrAs6DQjCX0VqD
         rR1kT5VMVFU0UA3DbgMbX7zOmY048Vhk07DWZ2T/BzbL4KLzw3b4O3mH0bOVsPb431oh
         SYVEHrk7WJwqFvJoOuQ8v08lKWuLJaSGOe5qS56M5dvX5nR/X73vnaHsoC2Nqwf36+rU
         Hse0lrtgeGL8exBbigAqHEUwFxmqin1tACDn8EeyDMeBZt8kw9l2NFI1a1tudJigOnN8
         tTqQvQmdajvSG6qNh4rhjYch9orlqd+CBHJn9rKfz4ke1rbYxFbnxJ/+8XnPOze3vCci
         pRaA==
X-Gm-Message-State: ANoB5pmE4Fzr+8QtTnqv5sXJ0IrVF5blFj/6ul4DUwfcYxQctsGwf1Ng
        km7aGEYAMQBi58OvqqkqbbzB7U0=
X-Google-Smtp-Source: AA0mqf4hbdUGs+Tmj8aE8WP87yMZZUpn7lQ8UzARwIt9yagVEkHYPOg3xaTZGtc4XTTSjMx2Ns4fDns=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:9503:b0:20a:eab5:cf39 with SMTP id
 t3-20020a17090a950300b0020aeab5cf39mr74515pjo.1.1668481337155; Mon, 14 Nov
 2022 19:02:17 -0800 (PST)
Date:   Mon, 14 Nov 2022 19:02:02 -0800
In-Reply-To: <20221115030210.3159213-1-sdf@google.com>
Mime-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115030210.3159213-4-sdf@google.com>
Subject: [PATCH bpf-next 03/11] bpf: Support inlined/unrolled kfuncs for xdp metadata
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kfuncs have to be defined with KF_UNROLL for an attempted unroll.
For now, only XDP programs can have their kfuncs unrolled, but
we can extend this later on if more programs would like to use it.

For XDP, we define a new kfunc set (xdp_metadata_kfunc_ids) which
implements all possible metatada kfuncs. Not all devices have to
implement them. If unrolling is not supported by the target device,
the default implementation is called instead. The default
implementation is unconditionally unrolled to 'return false/0/NULL'
for now.

Upon loading, if BPF_F_XDP_HAS_METADATA is passed via prog_flags,
we treat prog_index as target device for kfunc unrolling.
net_device_ops gains new ndo_unroll_kfunc which does the actual
dirty work per device.

The kfunc unrolling itself largely follows the existing map_gen_lookup
unrolling example, so there is nothing new here.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/bpf/kfuncs.rst   |  8 +++++
 include/linux/bpf.h            |  1 +
 include/linux/btf.h            |  1 +
 include/linux/btf_ids.h        |  4 +++
 include/linux/netdevice.h      |  5 +++
 include/net/xdp.h              | 24 +++++++++++++
 include/uapi/linux/bpf.h       |  5 +++
 kernel/bpf/syscall.c           | 28 ++++++++++++++-
 kernel/bpf/verifier.c          | 65 ++++++++++++++++++++++++++++++++++
 net/core/dev.c                 |  7 ++++
 net/core/xdp.c                 | 39 ++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  5 +++
 12 files changed, 191 insertions(+), 1 deletion(-)

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index 0f858156371d..1723de2720bb 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -169,6 +169,14 @@ rebooting or panicking. Due to this additional restrictions apply to these
 calls. At the moment they only require CAP_SYS_BOOT capability, but more can be
 added later.
 
+2.4.8 KF_UNROLL flag
+-----------------------
+
+The KF_UNROLL flag is used for kfuncs that the verifier can attempt to unroll.
+Unrolling is currently implemented only for XDP programs' metadata kfuncs.
+The main motivation behind unrolling is to remove function call overhead
+and allow efficient inlined kfuncs to be generated.
+
 2.5 Registering the kfuncs
 --------------------------
 
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 798aec816970..bf8936522dd9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1240,6 +1240,7 @@ struct bpf_prog_aux {
 		struct work_struct work;
 		struct rcu_head	rcu;
 	};
+	const struct net_device_ops *xdp_kfunc_ndo;
 };
 
 struct bpf_prog {
diff --git a/include/linux/btf.h b/include/linux/btf.h
index d80345fa566b..950cca997a5a 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -51,6 +51,7 @@
 #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
 #define KF_SLEEPABLE    (1 << 5) /* kfunc may sleep */
 #define KF_DESTRUCTIVE  (1 << 6) /* kfunc performs destructive actions */
+#define KF_UNROLL       (1 << 7) /* kfunc unrolling can be attempted */
 
 /*
  * Return the name of the passed struct, if exists, or halt the build if for
diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index c9744efd202f..eb448e9c79bb 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -195,6 +195,10 @@ asm(							\
 __BTF_ID_LIST(name, local)				\
 __BTF_SET8_START(name, local)
 
+#define BTF_SET8_START_GLOBAL(name)			\
+__BTF_ID_LIST(name, global)				\
+__BTF_SET8_START(name, global)
+
 #define BTF_SET8_END(name)				\
 asm(							\
 ".pushsection " BTF_IDS_SECTION ",\"a\";      \n"	\
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 02a2318da7c7..2096b4f00e4b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -73,6 +73,8 @@ struct udp_tunnel_info;
 struct udp_tunnel_nic_info;
 struct udp_tunnel_nic;
 struct bpf_prog;
+struct bpf_insn;
+struct bpf_patch;
 struct xdp_buff;
 
 void synchronize_net(void);
@@ -1604,6 +1606,9 @@ struct net_device_ops {
 	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
 						  const struct skb_shared_hwtstamps *hwtstamps,
 						  bool cycles);
+	void			(*ndo_unroll_kfunc)(const struct bpf_prog *prog,
+						    u32 func_id,
+						    struct bpf_patch *patch);
 };
 
 /**
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 55dbc68bfffc..2a82a98f2f9f 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -7,6 +7,7 @@
 #define __LINUX_NET_XDP_H__
 
 #include <linux/skbuff.h> /* skb_shared_info */
+#include <linux/btf_ids.h> /* btf_id_set8 */
 
 /**
  * DOC: XDP RX-queue information
@@ -409,4 +410,27 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 
 #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
 
+#define XDP_METADATA_KFUNC_xxx	\
+	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED, \
+			   bpf_xdp_metadata_rx_timestamp_supported) \
+	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
+			   bpf_xdp_metadata_rx_timestamp) \
+
+enum {
+#define XDP_METADATA_KFUNC(name, str) name,
+XDP_METADATA_KFUNC_xxx
+#undef XDP_METADATA_KFUNC
+MAX_XDP_METADATA_KFUNC,
+};
+
+#ifdef CONFIG_DEBUG_INFO_BTF
+extern struct btf_id_set8 xdp_metadata_kfunc_ids;
+static inline u32 xdp_metadata_kfunc_id(int id)
+{
+	return xdp_metadata_kfunc_ids.pairs[id].id;
+}
+#else
+static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
+#endif
+
 #endif /* __LINUX_NET_XDP_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index fb4c911d2a03..b444b1118c4f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1156,6 +1156,11 @@ enum bpf_link_type {
  */
 #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
 
+/* If BPF_F_XDP_HAS_METADATA is used in BPF_PROG_LOAD command, the loaded
+ * program becomes device-bound but can access it's XDP metadata.
+ */
+#define BPF_F_XDP_HAS_METADATA	(1U << 6)
+
 /* link_create.kprobe_multi.flags used in LINK_CREATE command for
  * BPF_TRACE_KPROBE_MULTI attach type to create return probe.
  */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 85532d301124..597c41949910 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2426,6 +2426,20 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
 /* last field in 'union bpf_attr' used by this command */
 #define	BPF_PROG_LOAD_LAST_FIELD core_relo_rec_size
 
+static int xdp_resolve_netdev(struct bpf_prog *prog, int ifindex)
+{
+	struct net *net = current->nsproxy->net_ns;
+	struct net_device *dev;
+
+	for_each_netdev(net, dev) {
+		if (dev->ifindex == ifindex) {
+			prog->aux->xdp_kfunc_ndo = dev->netdev_ops;
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
 static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 {
 	enum bpf_prog_type type = attr->prog_type;
@@ -2443,7 +2457,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				 BPF_F_TEST_STATE_FREQ |
 				 BPF_F_SLEEPABLE |
 				 BPF_F_TEST_RND_HI32 |
-				 BPF_F_XDP_HAS_FRAGS))
+				 BPF_F_XDP_HAS_FRAGS |
+				 BPF_F_XDP_HAS_METADATA))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
@@ -2531,6 +2546,17 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
 	prog->aux->xdp_has_frags = attr->prog_flags & BPF_F_XDP_HAS_FRAGS;
 
+	if (attr->prog_flags & BPF_F_XDP_HAS_METADATA) {
+		/* Reuse prog_ifindex to carry request to unroll
+		 * metadata kfuncs.
+		 */
+		prog->aux->offload_requested = false;
+
+		err = xdp_resolve_netdev(prog, attr->prog_ifindex);
+		if (err < 0)
+			goto free_prog;
+	}
+
 	err = security_bpf_prog_alloc(prog->aux);
 	if (err)
 		goto free_prog;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 07c0259dfc1a..b657ed6eb277 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/bpf.h>
+#include <linux/bpf_patch.h>
 #include <linux/btf.h>
 #include <linux/bpf_verifier.h>
 #include <linux/filter.h>
@@ -14015,6 +14016,43 @@ static int fixup_call_args(struct bpf_verifier_env *env)
 	return err;
 }
 
+static int unroll_kfunc_call(struct bpf_verifier_env *env,
+			     struct bpf_insn *insn,
+			     struct bpf_patch *patch)
+{
+	enum bpf_prog_type prog_type;
+	struct bpf_prog_aux *aux;
+	struct btf *desc_btf;
+	u32 *kfunc_flags;
+	u32 func_id;
+
+	desc_btf = find_kfunc_desc_btf(env, insn->off);
+	if (IS_ERR(desc_btf))
+		return PTR_ERR(desc_btf);
+
+	prog_type = resolve_prog_type(env->prog);
+	func_id = insn->imm;
+
+	kfunc_flags = btf_kfunc_id_set_contains(desc_btf, prog_type, func_id);
+	if (!kfunc_flags)
+		return 0;
+	if (!(*kfunc_flags & KF_UNROLL))
+		return 0;
+	if (prog_type != BPF_PROG_TYPE_XDP)
+		return 0;
+
+	aux = env->prog->aux;
+	if (aux->xdp_kfunc_ndo && aux->xdp_kfunc_ndo->ndo_unroll_kfunc)
+		aux->xdp_kfunc_ndo->ndo_unroll_kfunc(env->prog, func_id, patch);
+	if (bpf_patch_len(patch) == 0) {
+		/* Default optimized kfunc implementation that
+		 * returns NULL/0/false.
+		 */
+		bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 0));
+	}
+	return bpf_patch_err(patch);
+}
+
 static int fixup_kfunc_call(struct bpf_verifier_env *env,
 			    struct bpf_insn *insn)
 {
@@ -14178,6 +14216,33 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 		if (insn->src_reg == BPF_PSEUDO_CALL)
 			continue;
 		if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL) {
+			struct bpf_patch patch = {};
+
+			if (bpf_prog_is_dev_bound(env->prog->aux)) {
+				verbose(env, "no metadata kfuncs offload\n");
+				return -EINVAL;
+			}
+
+			ret = unroll_kfunc_call(env, insn, &patch);
+			if (ret < 0) {
+				verbose(env, "failed to unroll kfunc with func_id=%d\n", insn->imm);
+				return cnt;
+			}
+			cnt = bpf_patch_len(&patch);
+			if (cnt) {
+				new_prog = bpf_patch_insn_data(env, i + delta,
+							       bpf_patch_data(&patch),
+							       bpf_patch_len(&patch));
+				bpf_patch_free(&patch);
+				if (!new_prog)
+					return -ENOMEM;
+
+				delta    += cnt - 1;
+				env->prog = prog = new_prog;
+				insn      = new_prog->insnsi + i + delta;
+				continue;
+			}
+
 			ret = fixup_kfunc_call(env, insn);
 			if (ret)
 				return ret;
diff --git a/net/core/dev.c b/net/core/dev.c
index 117e830cabb0..a2227f4f4a0b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9258,6 +9258,13 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 			return -EOPNOTSUPP;
 		}
 
+		if (new_prog &&
+		    new_prog->aux->xdp_kfunc_ndo &&
+		    new_prog->aux->xdp_kfunc_ndo != dev->netdev_ops) {
+			NL_SET_ERR_MSG(extack, "Cannot attach to a different target device");
+			return -EINVAL;
+		}
+
 		err = dev_xdp_install(dev, mode, bpf_op, extack, flags, new_prog);
 		if (err)
 			return err;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 844c9d99dc0e..22f1e44700eb 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -4,6 +4,8 @@
  * Copyright (c) 2017 Jesper Dangaard Brouer, Red Hat Inc.
  */
 #include <linux/bpf.h>
+#include <linux/bpf_patch.h>
+#include <linux/btf_ids.h>
 #include <linux/filter.h>
 #include <linux/types.h>
 #include <linux/mm.h>
@@ -709,3 +711,40 @@ struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
 
 	return nxdpf;
 }
+
+/* Indicates whether particular device supports rx_timestamp metadata.
+ * This is an optional helper to support marking some branches as
+ * "dead code" in the BPF programs.
+ */
+noinline int bpf_xdp_metadata_rx_timestamp_supported(const struct xdp_md *ctx)
+{
+	/* payload is ignored, see default case in unroll_kfunc_call */
+	return false;
+}
+
+/* Returns rx_timestamp metadata or 0 when the frame doesn't have it.
+ */
+noinline const __u64 bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx)
+{
+	/* payload is ignored, see default case in unroll_kfunc_call */
+	return 0;
+}
+
+#ifdef CONFIG_DEBUG_INFO_BTF
+BTF_SET8_START_GLOBAL(xdp_metadata_kfunc_ids)
+#define XDP_METADATA_KFUNC(name, str) BTF_ID_FLAGS(func, str, KF_RET_NULL | KF_UNROLL)
+XDP_METADATA_KFUNC_xxx
+#undef XDP_METADATA_KFUNC
+BTF_SET8_END(xdp_metadata_kfunc_ids)
+
+static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &xdp_metadata_kfunc_ids,
+};
+
+static int __init xdp_metadata_init(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadata_kfunc_set);
+}
+late_initcall(xdp_metadata_init);
+#endif
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index fb4c911d2a03..b444b1118c4f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1156,6 +1156,11 @@ enum bpf_link_type {
  */
 #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
 
+/* If BPF_F_XDP_HAS_METADATA is used in BPF_PROG_LOAD command, the loaded
+ * program becomes device-bound but can access it's XDP metadata.
+ */
+#define BPF_F_XDP_HAS_METADATA	(1U << 6)
+
 /* link_create.kprobe_multi.flags used in LINK_CREATE command for
  * BPF_TRACE_KPROBE_MULTI attach type to create return probe.
  */
-- 
2.38.1.431.g37b22c650d-goog

