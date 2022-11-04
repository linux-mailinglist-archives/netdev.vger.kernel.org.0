Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E74D618EF4
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiKDD1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiKDD0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:26:07 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE72654A
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 20:25:37 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id v1-20020aa78081000000b005636d8a1947so1712591pff.0
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 20:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k8vC9asssgoYIIsbrAgtOzkrHQJD4SKRHxy5a1maTOc=;
        b=mQ5SqP1okQHxfCwPKsoo/MW0C+Gu7+jWW7ovyAmjACx/Nj/N6ujMQYhaLvjI3bc4rf
         r/ybNtgNamJM1kABKutPIKT8VFTNgjo7mL12YQoOk8AqyI7JOaL3Wr0cDVpzLU8A35rE
         Ilg49UDeMkvq4ER1wfD6FBXDcDI230No7Okl13zhgG09NYCc8I7fJW6UomlVGwkbOeXk
         HcElH5Eolg/J3hW14+1VvM9LSReWT3FSPf/hKkb59ftoY6+5v1qvPN0z4L97XJ6qdjjP
         ElaolkEyKgtmiCK//JvxChUuy0oBeA/n/HfwzEMcKBpfDUJGW/T+Aek+Ij7XaKb0f3c0
         ea2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k8vC9asssgoYIIsbrAgtOzkrHQJD4SKRHxy5a1maTOc=;
        b=GbGbMPCwdBxGK7OggPlMXPj5CjJNdfHmyKGKTzwfDNcbg/OVUWnjh2ynBzq/vkkK5L
         8C86RKi1niouAV3bmeM5M0jF5gmT11cm2bfYZLWxgUi9CAtbPWW08WTacXaB/AIlA1KH
         a0vSFRUatXu7hSmMTH22GyastWuPtyN8qL3ExwO1VmPHgPSeha2YSPd94M8aCCSP9gFN
         MVu4+c1IHBEEgbHuQKnaFP9kY/lbBh7V8P7WAlyrqZMkJHBC/Vn1Ru+5WuYq4n4Frq+Z
         grcwKyDUrekuYTBpdmnDBRZq8+PUB9YFL5KpprQug+7cPygjC4jLzZyx2J/gUjpOTMHS
         GA6Q==
X-Gm-Message-State: ACrzQf2VTEva6Vn7Mi7ox0zZSjnIqKLdExWMNeeOEYr/KKNj4+t+fbEJ
        EUw2w8XrUvJ3ewQ/n1wyiDzrP5c=
X-Google-Smtp-Source: AMsMyM711NVJ4sAh8nGRqY8XcA7BbCj2ze2Q/d0+StQXC7/msB8nweCUdqLSWH4qU0qqoNoyXV6z0Ew=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:4ac3:b0:56d:6e51:60eb with SMTP id
 ds3-20020a056a004ac300b0056d6e5160ebmr24903792pfb.58.1667532337341; Thu, 03
 Nov 2022 20:25:37 -0700 (PDT)
Date:   Thu,  3 Nov 2022 20:25:20 -0700
In-Reply-To: <20221104032532.1615099-1-sdf@google.com>
Mime-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104032532.1615099-3-sdf@google.com>
Subject: [RFC bpf-next v2 02/14] bpf: Support inlined/unrolled kfuncs for xdp metadata
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
 include/linux/bpf.h            |  1 +
 include/linux/btf.h            |  1 +
 include/linux/btf_ids.h        |  4 ++
 include/linux/netdevice.h      |  5 +++
 include/net/xdp.h              | 24 ++++++++++++
 include/uapi/linux/bpf.h       |  5 +++
 kernel/bpf/syscall.c           | 28 +++++++++++++-
 kernel/bpf/verifier.c          | 67 ++++++++++++++++++++++++++++++++++
 net/core/dev.c                 |  7 ++++
 net/core/xdp.c                 | 39 ++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  5 +++
 11 files changed, 185 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8d948bfcb984..54b353a88a03 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1188,6 +1188,7 @@ struct bpf_prog_aux {
 		struct work_struct work;
 		struct rcu_head	rcu;
 	};
+	const struct net_device_ops *xdp_kfunc_ndo;
 };
 
 struct bpf_prog {
diff --git a/include/linux/btf.h b/include/linux/btf.h
index f9aababc5d78..23ad5f8313e4 100644
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
index 4b5052db978f..33171e5cf83a 100644
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
@@ -1609,6 +1611,9 @@ struct net_device_ops {
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
index 94659f6b3395..6938fc4f1ec5 100644
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
index 5887592eeb93..4b76eee03a10 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2461,6 +2461,20 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
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
@@ -2478,7 +2492,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				 BPF_F_TEST_STATE_FREQ |
 				 BPF_F_SLEEPABLE |
 				 BPF_F_TEST_RND_HI32 |
-				 BPF_F_XDP_HAS_FRAGS))
+				 BPF_F_XDP_HAS_FRAGS |
+				 BPF_F_XDP_HAS_METADATA))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
@@ -2566,6 +2581,17 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
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
index 82c07fe0bfb1..4e5c5ff35d5f 100644
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
@@ -13865,6 +13866,45 @@ static int fixup_call_args(struct bpf_verifier_env *env)
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
+	if (!aux->xdp_kfunc_ndo)
+		return 0;
+
+	aux->xdp_kfunc_ndo->ndo_unroll_kfunc(env->prog, func_id, patch);
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
@@ -14028,6 +14068,33 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
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
index 2e4f1c97b59e..c64d9ea9be3a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9259,6 +9259,13 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 			return -EOPNOTSUPP;
 		}
 
+		if (new_prog &&
+		    new_prog->aux->xdp_kfunc_ndo &&
+		    new_prog->aux->xdp_kfunc_ndo != dev->netdev_ops) {
+			NL_SET_ERR_MSG(extack, "Target device was specified at load time; can only attach to the same device type");
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
index 94659f6b3395..6938fc4f1ec5 100644
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

