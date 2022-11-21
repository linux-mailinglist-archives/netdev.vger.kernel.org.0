Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2EB6632C0A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiKUS0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiKUS0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:26:00 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5202ED02D2
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:25:58 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 138-20020a630290000000b004708e8a8dcfso7276014pgc.11
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qJP1roNVztoT+rR4fEg1P2UNNoIGJSxA7B7wMS9AQHs=;
        b=UPbmH7yiBsnEWi8x2FbxujNPgqFUq9chmh903AQcFucMIR57BjpWjCFFoXqHL7UOW5
         aWNXOotLtQlVprn1yi3Cfi73tSDCR88yHLQWUjX3ox4zrDPktAKcS53oQ5Oc11fqxR4i
         TfxC0kswCvBUUrlzmY6ujKRhWMsjuy/uR1hCQybJoH6HVxip7CLUNSclUxA/y5a2S1KO
         mqmjvTAkDW7lZsmvscZHVk3nWMXg2tPyeL8ucGsIYL9+DS2iqTOSDxdrk3ab2rvLX0tm
         LjmYBIlijurwnImZ5hkqF/1cyMbU4bl5pYSmMEKDTps60izF5EmPaw2jbqTTlmRsU8+u
         haNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qJP1roNVztoT+rR4fEg1P2UNNoIGJSxA7B7wMS9AQHs=;
        b=29yBtugU+a7K4CinCFqfME2EVssVhN1p6LQcmibgHTNh4GeeqRLR+xW9rQz/ujpOaT
         Y+hVl9Ff4eDE8HAFEOVc7eRIx8sepX6lzsQff1eIUFFTrn/4HdccfErzTtV/AsaMyF90
         hx00H+tfR6N8HihnySbACmhnOu5eLiAKaH3HsM2aRByCVvGSM6i5CWBZ9ww/qaaaCdp3
         lk2ger+CrsCRuoWhV85Z6u91hga1cCshBk8xGdJYRAwPv1aDcMtayPlnOMZMJ8+FokQC
         t+r/NSiRy62TtRL2wUzfMGNYHFpMd6e1+JVoQACcgrGdtNmDx1ra2OurToPNA1jXvvRQ
         RHXw==
X-Gm-Message-State: ANoB5pnb4QZHfg0ULgs37KFlMjN0beuIr4NdQPfdC/8BF8IabvK5kYkM
        x0wxLe9cI6x1byo9K5VU2+Fnhdk=
X-Google-Smtp-Source: AA0mqf7cidmciSuQZ15kDJg8qGG5UECXVkrpy9KZ9xu/+TfbrRyFrAqmlAYCsyaBELB32euuqnM14Q0=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90b:1217:b0:213:36b7:1b77 with SMTP id
 gl23-20020a17090b121700b0021336b71b77mr27499248pjb.94.1669055157545; Mon, 21
 Nov 2022 10:25:57 -0800 (PST)
Date:   Mon, 21 Nov 2022 10:25:46 -0800
In-Reply-To: <20221121182552.2152891-1-sdf@google.com>
Mime-Version: 1.0
References: <20221121182552.2152891-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221121182552.2152891-3-sdf@google.com>
Subject: [PATCH bpf-next v2 2/8] bpf: XDP metadata RX kfuncs
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

There is an ndo handler per kfunc, the verifier replaces a call to the
generic kfunc with a call to the per-device one.

For XDP, we define a new kfunc set (xdp_metadata_kfunc_ids) which
implements all possible metatada kfuncs. Not all devices have to
implement them. If kfunc is not supported by the target device,
the default implementation is called instead.

Upon loading, if BPF_F_XDP_HAS_METADATA is passed via prog_flags,
we treat prog_index as target device for kfunc resolution.

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
 include/linux/netdevice.h      |  5 ++++
 include/net/xdp.h              | 20 +++++++++++++
 include/uapi/linux/bpf.h       |  5 ++++
 kernel/bpf/core.c              |  1 +
 kernel/bpf/syscall.c           | 17 ++++++++++-
 kernel/bpf/verifier.c          | 33 +++++++++++++++++++++
 net/core/dev.c                 |  5 ++++
 net/core/xdp.c                 | 52 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  5 ++++
 10 files changed, 143 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c9eafa67f2a2..01d62355d068 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1302,6 +1302,7 @@ struct bpf_prog_aux {
 		struct work_struct work;
 		struct rcu_head	rcu;
 	};
+	struct net_device *xdp_netdev; /* xdp metadata kfuncs */
 };
 
 struct bpf_prog {
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ddc59ef98500..2878e4869dc8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -74,6 +74,7 @@ struct udp_tunnel_nic_info;
 struct udp_tunnel_nic;
 struct bpf_prog;
 struct xdp_buff;
+struct xdp_md;
 
 void synchronize_net(void);
 void netdev_set_default_ethtool_ops(struct net_device *dev,
@@ -1604,6 +1605,10 @@ struct net_device_ops {
 	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
 						  const struct skb_shared_hwtstamps *hwtstamps,
 						  bool cycles);
+	bool			(*ndo_xdp_rx_timestamp_supported)(const struct xdp_md *ctx);
+	u64			(*ndo_xdp_rx_timestamp)(const struct xdp_md *ctx);
+	bool			(*ndo_xdp_rx_hash_supported)(const struct xdp_md *ctx);
+	u32			(*ndo_xdp_rx_hash)(const struct xdp_md *ctx);
 };
 
 /**
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 55dbc68bfffc..348aefd467ed 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -7,6 +7,7 @@
 #define __LINUX_NET_XDP_H__
 
 #include <linux/skbuff.h> /* skb_shared_info */
+#include <linux/btf_ids.h> /* btf_id_set8 */
 
 /**
  * DOC: XDP RX-queue information
@@ -409,4 +410,23 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 
 #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
 
+#define XDP_METADATA_KFUNC_xxx	\
+	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED, \
+			   bpf_xdp_metadata_rx_timestamp_supported) \
+	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
+			   bpf_xdp_metadata_rx_timestamp) \
+	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_HASH_SUPPORTED, \
+			   bpf_xdp_metadata_rx_hash_supported) \
+	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_HASH, \
+			   bpf_xdp_metadata_rx_hash) \
+
+enum {
+#define XDP_METADATA_KFUNC(name, str) name,
+XDP_METADATA_KFUNC_xxx
+#undef XDP_METADATA_KFUNC
+MAX_XDP_METADATA_KFUNC,
+};
+
+u32 xdp_metadata_kfunc_id(int id);
+
 #endif /* __LINUX_NET_XDP_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ab86145df760..55eda6f0d39b 100644
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
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 2e57fc839a5c..32cb07a8939c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2576,6 +2576,7 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 	} else {
 		bpf_jit_free(aux->prog);
 	}
+	dev_put(aux->xdp_netdev);
 }
 
 void bpf_prog_free(struct bpf_prog *fp)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 35972afb6850..ece7f9234b2d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2491,7 +2491,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				 BPF_F_TEST_STATE_FREQ |
 				 BPF_F_SLEEPABLE |
 				 BPF_F_TEST_RND_HI32 |
-				 BPF_F_XDP_HAS_FRAGS))
+				 BPF_F_XDP_HAS_FRAGS |
+				 BPF_F_XDP_HAS_METADATA))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
@@ -2579,6 +2580,20 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
 	prog->aux->xdp_has_frags = attr->prog_flags & BPF_F_XDP_HAS_FRAGS;
 
+	if (attr->prog_flags & BPF_F_XDP_HAS_METADATA) {
+		/* Reuse prog_ifindex to bind to the device
+		 * for XDP metadata kfuncs.
+		 */
+		prog->aux->offload_requested = false;
+
+		prog->aux->xdp_netdev = dev_get_by_index(current->nsproxy->net_ns,
+							 attr->prog_ifindex);
+		if (!prog->aux->xdp_netdev) {
+			err = -EINVAL;
+			goto free_prog;
+		}
+	}
+
 	err = security_bpf_prog_alloc(prog->aux);
 	if (err)
 		goto free_prog;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9528a066cfa5..315876fa9d30 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15171,6 +15171,25 @@ static int fixup_call_args(struct bpf_verifier_env *env)
 	return err;
 }
 
+static int fixup_xdp_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
+{
+	struct bpf_prog_aux *aux = env->prog->aux;
+	void *resolved = NULL;
+
+	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED))
+		resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_timestamp_supported;
+	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
+		resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_timestamp;
+	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH_SUPPORTED))
+		resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_hash_supported;
+	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
+		resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_hash;
+
+	if (resolved)
+		return BPF_CALL_IMM(resolved);
+	return 0;
+}
+
 static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 			    struct bpf_insn *insn_buf, int insn_idx, int *cnt)
 {
@@ -15181,6 +15200,15 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		return -EINVAL;
 	}
 
+	if (resolve_prog_type(env->prog) == BPF_PROG_TYPE_XDP) {
+		int imm = fixup_xdp_kfunc_call(env, insn->imm);
+
+		if (imm) {
+			insn->imm = imm;
+			return 0;
+		}
+	}
+
 	/* insn->imm has the btf func_id. Replace it with
 	 * an address (relative to __bpf_base_call).
 	 */
@@ -15359,6 +15387,11 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 		if (insn->src_reg == BPF_PSEUDO_CALL)
 			continue;
 		if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL) {
+			if (bpf_prog_is_dev_bound(env->prog->aux)) {
+				verbose(env, "no metadata kfuncs offload\n");
+				return -EINVAL;
+			}
+
 			ret = fixup_kfunc_call(env, insn, insn_buf, i + delta, &cnt);
 			if (ret)
 				return ret;
diff --git a/net/core/dev.c b/net/core/dev.c
index 117e830cabb0..b4021b7575a2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9248,6 +9248,11 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 			NL_SET_ERR_MSG(extack, "BPF_XDP_CPUMAP programs can not be attached to a device");
 			return -EINVAL;
 		}
+		if (new_prog->aux->xdp_netdev &&
+		    new_prog->aux->xdp_netdev->netdev_ops != dev->netdev_ops) {
+			NL_SET_ERR_MSG(extack, "Cannot attach to a different target device");
+			return -EINVAL;
+		}
 	}
 
 	/* don't call drivers if the effective program didn't change */
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 844c9d99dc0e..e43f7d4ef4cf 100644
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
@@ -709,3 +710,54 @@ struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
 
 	return nxdpf;
 }
+
+noinline bool bpf_xdp_metadata_rx_timestamp_supported(const struct xdp_md *ctx)
+{
+	return false;
+}
+
+noinline u64 bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx)
+{
+	return 0;
+}
+
+noinline bool bpf_xdp_metadata_rx_hash_supported(const struct xdp_md *ctx)
+{
+	return false;
+}
+
+noinline u32 bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx)
+{
+	return 0;
+}
+
+#ifdef CONFIG_DEBUG_INFO_BTF
+BTF_SET8_START(xdp_metadata_kfunc_ids)
+#define XDP_METADATA_KFUNC(name, str) BTF_ID_FLAGS(func, str, 0)
+XDP_METADATA_KFUNC_xxx
+#undef XDP_METADATA_KFUNC
+BTF_SET8_END(xdp_metadata_kfunc_ids)
+
+static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &xdp_metadata_kfunc_ids,
+};
+
+u32 xdp_metadata_kfunc_id(int id)
+{
+	return xdp_metadata_kfunc_ids.pairs[id].id;
+}
+EXPORT_SYMBOL_GPL(xdp_metadata_kfunc_id);
+
+static int __init xdp_metadata_init(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadata_kfunc_set);
+}
+late_initcall(xdp_metadata_init);
+#else /* CONFIG_DEBUG_INFO_BTF */
+u32 xdp_metadata_kfunc_id(int id)
+{
+	return -1;
+}
+EXPORT_SYMBOL_GPL(xdp_metadata_kfunc_id);
+#endif /* CONFIG_DEBUG_INFO_BTF */
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 6580448e9f77..6b01ac70f564 100644
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
2.38.1.584.g0f3c55d4c2-goog

