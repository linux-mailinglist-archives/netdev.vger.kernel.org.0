Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E2F610240
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbiJ0UAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236890AbiJ0UAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:00:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D54E2DEE
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:00:24 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a2-20020a5b0002000000b006b48689da76so2468511ybp.16
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f+NDMLwTx3z6guRuLy0i3T+BrbbI2yk7jdZCWNoru5w=;
        b=kckCvJK1ZXuP0y/wT3kKWVuzeKfZ34hPXaWMB10PG64ne2ldY/dTc6cNbHAd43x+wd
         6a40em8FT9rfAGXWJfM+VXtAV3aE4mFVZGXRqRpyeXeUyRCbGStDNHOggmgnhav6qrkJ
         Z+N/BWOt2XGAezr6SlCfRXo3SqvOPQQC8w842asEuTNz0iX7rZDEVRRPmMKMsG+aQHsg
         vMPRNDdJFWAYFpshd9g3KujtU62mgC92oOXlQkKi1vpgXAE6wLOx7prr4apDn2PrV17x
         JhRaiaGMRJ8jYDK+BA7nEuIUqt3PXcMUg4Jgs+cSSHY4F7syvSKGBzm6sGJlJWPPh3x1
         INCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f+NDMLwTx3z6guRuLy0i3T+BrbbI2yk7jdZCWNoru5w=;
        b=i6HQ6N59DbwwMR0yn5gxhjjDsntWLI/LbWunfOEECKe2sBR4EvNM6hZwL/csDVNK37
         gK53wakOeBn2il5Ra5BAam2B+PDkg3WCgu5fMgSCKu1SAd/V7QihXy6UDfJkeZObnWXk
         7hAHAbRzMiFdtEyoC7Oify0JxwbxRSIczGXWA/3QzbnRSxvkb5lftS/gwq4zHO6LgxtD
         57TOxB+mrlLuU6Ksxt5lq6Nf9Gi9wX2PUmNpRxvjats455mNtmFM0F2EpX3IOEO/wd6c
         ul3GctuxlywcC1F9pRfnx2O24VFWh1/a/gqH8sicz0hBawREmbswiapEKer78JSSefXw
         tDvw==
X-Gm-Message-State: ACrzQf3UJExGD/8k4R0UiC4fPJh4vZyOSU841TzcUX7XjZnqsfuMPN2K
        lIiDkP5XKXe032tffq/q5WFXV/4=
X-Google-Smtp-Source: AMsMyM7shuumXhH3cueW3Q+n6aS7ZRgu8sfCPjdoy4zGJbuHTtQspR15iQdTXt9QZK+YQwVYN4EKwS4=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6902:124e:b0:668:222c:e8da with SMTP id
 t14-20020a056902124e00b00668222ce8damr44730950ybu.383.1666900823694; Thu, 27
 Oct 2022 13:00:23 -0700 (PDT)
Date:   Thu, 27 Oct 2022 13:00:15 -0700
In-Reply-To: <20221027200019.4106375-1-sdf@google.com>
Mime-Version: 1.0
References: <20221027200019.4106375-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221027200019.4106375-2-sdf@google.com>
Subject: [RFC bpf-next 1/5] bpf: Support inlined/unrolled kfuncs for xdp metadata
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
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
the default implementation is called instead. We might also unroll
this default implementation for performance sake in the future, but
that's something I'm putting off for now.

Upon loading, if BPF_F_XDP_HAS_METADATA is passed via prog_flags,
we treat prog_index as target device for kfunc unrolling.
net_device_ops gains new ndo_unroll_kfunc which does the actual
dirty work per device.

The kfunc unrolling itself largely follows the existing map_gen_lookup
unrolling example, so there is nothing new here.

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
 include/linux/btf_ids.h        |  4 +++
 include/linux/netdevice.h      |  3 ++
 include/net/xdp.h              | 22 +++++++++++++
 include/uapi/linux/bpf.h       |  5 +++
 kernel/bpf/syscall.c           | 28 +++++++++++++++-
 kernel/bpf/verifier.c          | 60 ++++++++++++++++++++++++++++++++++
 net/core/dev.c                 |  7 ++++
 net/core/xdp.c                 | 28 ++++++++++++++++
 tools/include/uapi/linux/bpf.h |  5 +++
 11 files changed, 163 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9fd68b0b3e9c..54983347e20e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1176,6 +1176,7 @@ struct bpf_prog_aux {
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
index a36edb0ec199..90052271a502 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -73,6 +73,7 @@ struct udp_tunnel_info;
 struct udp_tunnel_nic_info;
 struct udp_tunnel_nic;
 struct bpf_prog;
+struct bpf_insn;
 struct xdp_buff;
 
 void synchronize_net(void);
@@ -1609,6 +1610,8 @@ struct net_device_ops {
 	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
 						  const struct skb_shared_hwtstamps *hwtstamps,
 						  bool cycles);
+	int                     (*ndo_unroll_kfunc)(struct bpf_prog *prog,
+						    struct bpf_insn *insn);
 };
 
 /**
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 55dbc68bfffc..b465001936ac 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -7,6 +7,7 @@
 #define __LINUX_NET_XDP_H__
 
 #include <linux/skbuff.h> /* skb_shared_info */
+#include <linux/btf_ids.h> /* btf_id_set8 */
 
 /**
  * DOC: XDP RX-queue information
@@ -83,6 +84,7 @@ struct xdp_buff {
 	struct xdp_txq_info *txq;
 	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
 	u32 flags; /* supported values defined in xdp_buff_flags */
+	void *priv;
 };
 
 static __always_inline bool xdp_buff_has_frags(struct xdp_buff *xdp)
@@ -409,4 +411,24 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 
 #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
 
+#define XDP_METADATA_KFUNC_xxx	\
+	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_HAVE_RX_TIMESTAMP, \
+			   bpf_xdp_metadata_have_rx_timestamp) \
+	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
+			   bpf_xdp_metadata_rx_timestamp) \
+
+extern struct btf_id_set8 xdp_metadata_kfunc_ids;
+
+enum {
+#define XDP_METADATA_KFUNC(name, str) name,
+XDP_METADATA_KFUNC_xxx
+#undef XDP_METADATA_KFUNC
+MAX_XDP_METADATA_KFUNC,
+};
+
+static inline u32 xdp_metadata_kfunc_id(int id)
+{
+	return xdp_metadata_kfunc_ids.pairs[id].id;
+}
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
index 11df90962101..5376604961bc 100644
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
index 8f849a763b79..3e734e15ffa3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13864,6 +13864,37 @@ static int fixup_call_args(struct bpf_verifier_env *env)
 	return err;
 }
 
+static int unroll_kfunc_call(struct bpf_verifier_env *env,
+			     struct bpf_insn *insn)
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
+	return aux->xdp_kfunc_ndo->ndo_unroll_kfunc(env->prog, insn);
+}
+
 static int fixup_kfunc_call(struct bpf_verifier_env *env,
 			    struct bpf_insn *insn)
 {
@@ -14027,6 +14058,35 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 		if (insn->src_reg == BPF_PSEUDO_CALL)
 			continue;
 		if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL) {
+			if (bpf_prog_is_dev_bound(env->prog->aux)) {
+				verbose(env, "no metadata kfuncs offload\n");
+				return -EINVAL;
+			}
+
+			insn_buf[0] = *insn;
+
+			cnt = unroll_kfunc_call(env, insn_buf);
+			if (cnt < 0) {
+				verbose(env, "failed to unroll kfunc with func_id=%d\n", insn->imm);
+				return cnt;
+			}
+			if (cnt > 0) {
+				if (cnt >= ARRAY_SIZE(insn_buf)) {
+					verbose(env, "bpf verifier is misconfigured (kfunc unroll)\n");
+					return -EINVAL;
+				}
+
+				new_prog = bpf_patch_insn_data(env, i + delta,
+							       insn_buf, cnt);
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
index fa53830d0683..8d3e34d073a8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9254,6 +9254,13 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
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
index 844c9d99dc0e..ea4ff00cb22b 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2017 Jesper Dangaard Brouer, Red Hat Inc.
  */
 #include <linux/bpf.h>
+#include <linux/btf_ids.h>
 #include <linux/filter.h>
 #include <linux/types.h>
 #include <linux/mm.h>
@@ -709,3 +710,30 @@ struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
 
 	return nxdpf;
 }
+
+noinline int bpf_xdp_metadata_have_rx_timestamp(struct xdp_md *ctx)
+{
+	return false;
+}
+
+noinline __u32 bpf_xdp_metadata_rx_timestamp(struct xdp_md *ctx)
+{
+	return 0;
+}
+
+BTF_SET8_START_GLOBAL(xdp_metadata_kfunc_ids)
+#define XDP_METADATA_KFUNC(name, str) BTF_ID_FLAGS(func, str, KF_UNROLL)
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
2.38.1.273.g43a17bfeac-goog

