Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5058363C877
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 20:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236810AbiK2TfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 14:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236754AbiK2Te7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 14:34:59 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFA12DABE
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:34:57 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id i8-20020a170902c94800b0018712ccd6bbso14425411pla.1
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r67F02jqkgiFfD/51H5OIuixxdQraZ2+G8Y2F7L+7cw=;
        b=HN1SPk9JIaPlF2So4ev4yhJWJuY/wYqUHFCsdVyfgPlZ6fb5xHN6BudL4iEZ+r9t8c
         DSllFF0J95W0uZVjtp/+6QbEI4VQWbt81mZz7y0KXX+y8t2PUyeqlWalWBdkNndrUoMo
         LoMHyw1XHqqzozRnGE13UespJtQ8Rh/X7pIVKr5yg9xeURfgfOKGa47irM0uZ8wem02f
         Ty3SV21AHQaxGnMumCD6/1kppOpzS6bdTN5fRC0hbQmCXRzRWLm6d8HDGOsxdngoBZWb
         Y5GOGO5Hs+ASDrGlhUTrgjsHYfP2GQKmG+GJdrXlT08ci7iOfUDokwbyCPJRfAA1yQUA
         7vgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r67F02jqkgiFfD/51H5OIuixxdQraZ2+G8Y2F7L+7cw=;
        b=QqwSAK+U7W1RTPP7lr42pNlX1oNQnKtiKQ/s1wCw73g1ApfrpgOwj6qetC+74PQgu8
         MK2BICmsPfcMcTyzftZGi+tNViIT/lsv9W7mRN8CkRN1bS0L7iCW8Wk7cDb12BSGdcfV
         ZDPyTx+B8CtI4GBlJB3ii+2vbpBeTB2Lj35Kdfor9Kib+O/AZn9/2RiLq1nnSz/Sj64w
         5E532nXhj/90E+XJmw+UH140helOMNEQBsoU2fcdavl93odl0p0APbjJbGGKYm5fFZy/
         Zv7A7Tgec2zr0LIFjkQ2jR9fpir1h6hgNJN/THhRgcLaAi3lZGuj60U208C4+n0AHoMU
         uJGA==
X-Gm-Message-State: ANoB5pm//nQqKYarGcAxHdRMGZZajDekIbXaChq9fsv+AAmuY/UvTGU9
        twriuk6iTwRyxz7lAZjxNlqvdU8=
X-Google-Smtp-Source: AA0mqf5yQ/78wf9YL/yGs7HRByXTANmOq8FVC7mJFV5FvKUcwI7kS0D+mpXkGaKhnDBWmclgysvc+Xw=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:8548:b0:188:6300:57ad with SMTP id
 d8-20020a170902854800b00188630057admr44688186plo.7.1669750497385; Tue, 29 Nov
 2022 11:34:57 -0800 (PST)
Date:   Tue, 29 Nov 2022 11:34:43 -0800
In-Reply-To: <20221129193452.3448944-1-sdf@google.com>
Mime-Version: 1.0
References: <20221129193452.3448944-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221129193452.3448944-3-sdf@google.com>
Subject: [PATCH bpf-next v3 02/11] bpf: XDP metadata RX kfuncs
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
 include/linux/bpf.h            |  4 +++
 include/linux/netdevice.h      |  5 +++
 include/net/xdp.h              | 25 +++++++++++++++
 include/uapi/linux/bpf.h       |  5 +++
 kernel/bpf/syscall.c           | 24 +++++++++++++-
 kernel/bpf/verifier.c          | 37 +++++++++++++++++++++-
 net/core/dev.c                 |  5 +++
 net/core/xdp.c                 | 58 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  5 +++
 9 files changed, 166 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c6aa6912ea16..eef507e4d317 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1306,6 +1306,10 @@ struct bpf_prog_aux {
 		struct work_struct work;
 		struct rcu_head	rcu;
 	};
+	/* Underlying netdev for XDP metadata kfuncs resolution.
+	 * Note that the refcnt is held only during load/verification phase.
+	 */
+	struct net_device *xdp_netdev;
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
index 55dbc68bfffc..c8d438af8552 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -409,4 +409,29 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 
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
+struct xdp_md;
+bool bpf_xdp_metadata_rx_timestamp_supported(const struct xdp_md *ctx);
+u64 bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx);
+bool bpf_xdp_metadata_rx_hash_supported(const struct xdp_md *ctx);
+u32 bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx);
+
 #endif /* __LINUX_NET_XDP_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f89de51a45db..790650a81f2b 100644
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
index 35972afb6850..b65c700fa3ec 100644
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
@@ -2628,6 +2643,12 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	if (err)
 		goto free_used_maps;
 
+	/* Don't need to hold the device after loading is done.
+	 * We only need literal pointer comparison to ensure
+	 * we're attaching to the same device.
+	 */
+	dev_put(prog->aux->xdp_netdev);
+
 	/* Upon success of bpf_prog_alloc_id(), the BPF prog is
 	 * effectively publicly exposed. However, retrieving via
 	 * bpf_prog_get_fd_by_id() will take another reference,
@@ -2662,6 +2683,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	free_uid(prog->aux->user);
 	security_bpf_prog_free(prog->aux);
 free_prog:
+	dev_put(prog->aux->xdp_netdev);
 	if (prog->aux->attach_btf)
 		btf_put(prog->aux->attach_btf);
 	bpf_prog_free(prog);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6599d25dae38..1ee9581c8e4e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15277,6 +15277,26 @@ static int fixup_call_args(struct bpf_verifier_env *env)
 	return err;
 }
 
+static void *resolve_xdp_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
+{
+	const struct net_device_ops *netdev_ops;
+	struct bpf_prog_aux *aux = env->prog->aux;
+
+	netdev_ops = aux->xdp_netdev->netdev_ops;
+
+	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED))
+		return netdev_ops->ndo_xdp_rx_timestamp_supported;
+	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
+		return netdev_ops->ndo_xdp_rx_timestamp;
+	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH_SUPPORTED))
+		return netdev_ops->ndo_xdp_rx_hash_supported;
+	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
+		return netdev_ops->ndo_xdp_rx_hash;
+
+	/* fallback to default kfunc when not supported by netdev */
+	return NULL;
+}
+
 static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 			    struct bpf_insn *insn_buf, int insn_idx, int *cnt)
 {
@@ -15287,6 +15307,17 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		return -EINVAL;
 	}
 
+	*cnt = 0;
+
+	if (resolve_prog_type(env->prog) == BPF_PROG_TYPE_XDP) {
+		void *p = resolve_xdp_kfunc_call(env, insn->imm);
+
+		if (p) {
+			insn->imm = BPF_CALL_IMM(p);
+			return 0;
+		}
+	}
+
 	/* insn->imm has the btf func_id. Replace it with
 	 * an address (relative to __bpf_base_call).
 	 */
@@ -15297,7 +15328,6 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		return -EFAULT;
 	}
 
-	*cnt = 0;
 	insn->imm = desc->imm;
 	if (insn->off)
 		return 0;
@@ -15465,6 +15495,11 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
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
index 117e830cabb0..7ad11c7a8834 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9248,6 +9248,11 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 			NL_SET_ERR_MSG(extack, "BPF_XDP_CPUMAP programs can not be attached to a device");
 			return -EINVAL;
 		}
+		if (new_prog->aux->xdp_netdev &&
+		    new_prog->aux->xdp_netdev != dev) {
+			NL_SET_ERR_MSG(extack, "Cannot attach to a different target device");
+			return -EINVAL;
+		}
 	}
 
 	/* don't call drivers if the effective program didn't change */
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 844c9d99dc0e..8240805bfdb7 100644
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
@@ -709,3 +710,60 @@ struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
 
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
+BTF_ID_LIST(xdp_metadata_kfunc_ids_unsorted)
+#define XDP_METADATA_KFUNC(name, str) BTF_ID(func, str)
+XDP_METADATA_KFUNC_xxx
+#undef XDP_METADATA_KFUNC
+
+u32 xdp_metadata_kfunc_id(int id)
+{
+	/* xdp_metadata_kfunc_ids is sorted and can't be used */
+	return xdp_metadata_kfunc_ids_unsorted[id];
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
index f89de51a45db..790650a81f2b 100644
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

