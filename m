Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4C66528E9
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 23:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbiLTWVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 17:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234223AbiLTWVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 17:21:00 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B51E097
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 14:20:59 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id hg4-20020a17090b300400b002215a3c02c3so5813141pjb.4
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 14:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+iEzEKXoUPsGeXg+JBFcmbcOcWdflKLSTGw3eIzic8g=;
        b=Hshv6YdED8/ogdjBg09/8t2PY7Hcp1j3kFouGlD3VihrPBjkj0s8R2IM1rguSGWXuy
         KMCB+x5lBPI2MF3RjcfMO/+9XarhTN8GwRMJIUl+YfDUD2c9EpUzxUzU5KV2YVlgQbQV
         JPAMW91iumzBykJLGzm2xBUKo+zm7N5/+6vmaBXsl5/qPpp9X5cv1HEDMgJkfIjXe+QE
         He/IeKyB32LitLrChXK7l22UHWlqbbmUsggxUCad/7aJoNhMemr6wr2/6iLm+qSVS0Xe
         p9jvOMME3tDfBSVJ0T1ZzHaon3z7HnqiIvyxNVPQre8yFc+KnWz4KUXfKeJQy2ukzMTh
         y8pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+iEzEKXoUPsGeXg+JBFcmbcOcWdflKLSTGw3eIzic8g=;
        b=7N0oXXNt56kNM9tOcupEjjmutSmSzka5iFyJdhQHWADk5/62ZJP3bldHU082j2TYZr
         Xij4PmS9UaWVkP1u/vOrYQFVJrKpTivYnop2SHbYaY2TWgIwl+CRzVmMUQYSWigjyJjt
         1NuWhZnp0R+pC0psldn8PAlFyxY0Cqk0tV27P8VnfHItBe+SvI3c2P+GNhBJw+oyzZwu
         iqDeMLve1ggPlNTUjG3aacGR1IZrJdEtfHwDqe26qXIpjjXSS7C6r4ow3VF+4TOosYft
         7LMdPKVsr3D5GlvdgWazk+dGHC9uCvBKk3+DAgD3j3dWT8Ch41dH//qgqTYxCytcplMN
         P6Mg==
X-Gm-Message-State: AFqh2ko9u45A5o23xu4hushDRLNbc8aksY5SowldUwFnBp9SkHQEqDVy
        q/y5OeA8rjbOujqJSUNDq7qzX8c=
X-Google-Smtp-Source: AMrXdXsxbzLrwCEDhcDanRt1DhO1eKSY8H0iYVQdMONxNGOr46OSn560Graice9XXwMrtOXkwi2jWEY=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90b:701:b0:219:1d0a:34a6 with SMTP id
 s1-20020a17090b070100b002191d0a34a6mr51172pjz.1.1671574858134; Tue, 20 Dec
 2022 14:20:58 -0800 (PST)
Date:   Tue, 20 Dec 2022 14:20:33 -0800
In-Reply-To: <20221220222043.3348718-1-sdf@google.com>
Mime-Version: 1.0
References: <20221220222043.3348718-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220222043.3348718-8-sdf@google.com>
Subject: [PATCH bpf-next v5 07/17] bpf: XDP metadata RX kfuncs
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

Define a new kfunc set (xdp_metadata_kfunc_ids) which implements all possible
XDP metatada kfuncs. Not all devices have to implement them. If kfunc is not
supported by the target device, the default implementation is called instead.
The verifier, at load time, replaces a call to the generic kfunc with a call
to the per-device one. Per-device kfunc pointers are stored in separate
struct xdp_metadata_ops.

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
 include/linux/bpf.h       |  9 ++++++-
 include/linux/netdevice.h |  7 ++++++
 include/net/xdp.h         | 21 ++++++++++++++++
 kernel/bpf/core.c         |  8 +++++++
 kernel/bpf/offload.c      | 28 ++++++++++++++++++++++
 kernel/bpf/verifier.c     | 41 +++++++++++++++++++++++++++++++-
 net/bpf/test_run.c        |  3 +++
 net/core/xdp.c            | 50 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 165 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4c9649e69993..969f53691dd4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2480,6 +2480,7 @@ bool bpf_offload_dev_match(struct bpf_prog *prog, struct net_device *netdev);
 void unpriv_ebpf_notify(int new_state);
 
 #if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
+void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id);
 int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr);
 void bpf_dev_bound_netdev_unregister(struct net_device *dev);
 
@@ -2514,8 +2515,14 @@ void sock_map_unhash(struct sock *sk);
 void sock_map_destroy(struct sock *sk);
 void sock_map_close(struct sock *sk, long timeout);
 #else
+static inline void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog,
+						u32 func_id)
+{
+	return NULL;
+}
+
 static inline int bpf_prog_dev_bound_init(struct bpf_prog *prog,
-					union bpf_attr *attr)
+					  union bpf_attr *attr)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index aad12a179e54..b41d18490595 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -74,6 +74,7 @@ struct udp_tunnel_nic_info;
 struct udp_tunnel_nic;
 struct bpf_prog;
 struct xdp_buff;
+struct xdp_md;
 
 void synchronize_net(void);
 void netdev_set_default_ethtool_ops(struct net_device *dev,
@@ -1618,6 +1619,11 @@ struct net_device_ops {
 						  bool cycles);
 };
 
+struct xdp_metadata_ops {
+	int	(*xmo_rx_timestamp)(const struct xdp_md *ctx, u64 *timestamp);
+	int	(*xmo_rx_hash)(const struct xdp_md *ctx, u32 *hash);
+};
+
 /**
  * enum netdev_priv_flags - &struct net_device priv_flags
  *
@@ -2050,6 +2056,7 @@ struct net_device {
 	unsigned int		flags;
 	unsigned long long	priv_flags;
 	const struct net_device_ops *netdev_ops;
+	const struct xdp_metadata_ops *xdp_metadata_ops;
 	int			ifindex;
 	unsigned short		gflags;
 	unsigned short		hard_header_len;
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 55dbc68bfffc..91292aa13bc0 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -409,4 +409,25 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 
 #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
 
+#define XDP_METADATA_KFUNC_xxx	\
+	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
+			   bpf_xdp_metadata_rx_timestamp) \
+	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_HASH, \
+			   bpf_xdp_metadata_rx_hash) \
+
+enum {
+#define XDP_METADATA_KFUNC(name, _) name,
+XDP_METADATA_KFUNC_xxx
+#undef XDP_METADATA_KFUNC
+MAX_XDP_METADATA_KFUNC,
+};
+
+#ifdef CONFIG_NET
+u32 bpf_xdp_metadata_kfunc_id(int id);
+bool bpf_dev_bound_kfunc_id(u32 btf_id);
+#else
+static inline u32 bpf_xdp_metadata_kfunc_id(int id) { return 0; }
+static inline bool bpf_dev_bound_kfunc_id(u32 btf_id) { return false; }
+#endif
+
 #endif /* __LINUX_NET_XDP_H__ */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index bafcb7a3ae6f..6d81b14361e3 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2097,6 +2097,14 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
 	if (fp->kprobe_override)
 		return false;
 
+	/* XDP programs inserted into maps are not guaranteed to run on
+	 * a particular netdev (and can run outside driver context entirely
+	 * in the case of devmap and cpumap). Until device checks
+	 * are implemented, prohibit adding dev-bound programs to program maps.
+	 */
+	if (bpf_prog_is_dev_bound(fp->aux))
+		return false;
+
 	spin_lock(&map->owner.lock);
 	if (!map->owner.type) {
 		/* There's no owner yet where we could check for
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index e803824c1ddd..0e3fc743e0a8 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -767,6 +767,34 @@ void bpf_dev_bound_netdev_unregister(struct net_device *dev)
 	up_write(&bpf_devs_lock);
 }
 
+void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
+{
+	const struct xdp_metadata_ops *ops;
+	void *p = NULL;
+
+	/* We don't hold bpf_devs_lock while resolving several
+	 * kfuncs and can race with the unregister_netdevice().
+	 * We rely on bpf_dev_bound_match() check at attach
+	 * to render this program unusable.
+	 */
+	down_read(&bpf_devs_lock);
+	if (!prog->aux->offload || !prog->aux->offload->netdev)
+		goto out;
+
+	ops = prog->aux->offload->netdev->xdp_metadata_ops;
+	if (!ops)
+		goto out;
+
+	if (func_id == bpf_xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
+		p = ops->xmo_rx_timestamp;
+	else if (func_id == bpf_xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
+		p = ops->xmo_rx_hash;
+out:
+	up_read(&bpf_devs_lock);
+
+	return p;
+}
+
 static int __init bpf_offload_init(void)
 {
 	return rhashtable_init(&offdevs, &offdevs_params);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index fdfdcab4a59d..320451a0be3e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2081,6 +2081,22 @@ static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env, s16 offset)
 	return btf_vmlinux ?: ERR_PTR(-ENOENT);
 }
 
+int bpf_dev_bound_kfunc_check(struct bpf_verifier_env *env,
+			      struct bpf_prog_aux *prog_aux)
+{
+	if (!bpf_prog_is_dev_bound(prog_aux)) {
+		verbose(env, "metadata kfuncs require device-bound program\n");
+		return -EINVAL;
+	}
+
+	if (bpf_prog_is_offloaded(prog_aux)) {
+		verbose(env, "metadata kfuncs can't be offloaded\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 {
 	const struct btf_type *func, *func_proto;
@@ -2183,6 +2199,12 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 		return -EINVAL;
 	}
 
+	if (bpf_dev_bound_kfunc_id(func_id)) {
+		err = bpf_dev_bound_kfunc_check(env, prog_aux);
+		if (err)
+			return err;
+	}
+
 	desc = &tab->descs[tab->nr_descs++];
 	desc->func_id = func_id;
 	desc->imm = call_imm;
@@ -15480,12 +15502,25 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 			    struct bpf_insn *insn_buf, int insn_idx, int *cnt)
 {
 	const struct bpf_kfunc_desc *desc;
+	void *xdp_kfunc;
 
 	if (!insn->imm) {
 		verbose(env, "invalid kernel function call not eliminated in verifier pass\n");
 		return -EINVAL;
 	}
 
+	*cnt = 0;
+
+	if (bpf_dev_bound_kfunc_id(insn->imm)) {
+		xdp_kfunc = bpf_dev_bound_resolve_kfunc(env->prog, insn->imm);
+		if (xdp_kfunc) {
+			insn->imm = BPF_CALL_IMM(xdp_kfunc);
+			return 0;
+		}
+
+		/* fallback to default kfunc when not supported by netdev */
+	}
+
 	/* insn->imm has the btf func_id. Replace it with
 	 * an address (relative to __bpf_call_base).
 	 */
@@ -15496,7 +15531,6 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		return -EFAULT;
 	}
 
-	*cnt = 0;
 	insn->imm = desc->imm;
 	if (insn->off)
 		return 0;
@@ -16503,6 +16537,11 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 	if (tgt_prog) {
 		struct bpf_prog_aux *aux = tgt_prog->aux;
 
+		if (bpf_prog_is_dev_bound(tgt_prog->aux)) {
+			bpf_log(log, "Replacing device-bound programs not supported\n");
+			return -EINVAL;
+		}
+
 		for (i = 0; i < aux->func_info_cnt; i++)
 			if (aux->func_info[i].type_id == btf_id) {
 				subprog = i;
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2723623429ac..8da0d73b368e 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1300,6 +1300,9 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (kattr->test.flags & ~BPF_F_TEST_XDP_LIVE_FRAMES)
 		return -EINVAL;
 
+	if (bpf_prog_is_dev_bound(prog->aux))
+		return -EINVAL;
+
 	if (do_live) {
 		if (!batch_size)
 			batch_size = NAPI_POLL_WEIGHT;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 844c9d99dc0e..ec016ee5c046 100644
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
@@ -709,3 +710,52 @@ struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
 
 	return nxdpf;
 }
+
+__diag_push();
+__diag_ignore_all("-Wmissing-prototypes",
+		  "Global functions as their definitions will be in vmlinux BTF");
+
+int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
+{
+	return -EOPNOTSUPP;
+}
+
+int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash)
+{
+	return -EOPNOTSUPP;
+}
+
+__diag_pop();
+
+BTF_SET8_START(xdp_metadata_kfunc_ids)
+#define XDP_METADATA_KFUNC(_, name) BTF_ID_FLAGS(func, name, 0)
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
+u32 bpf_xdp_metadata_kfunc_id(int id)
+{
+	/* xdp_metadata_kfunc_ids is sorted and can't be used */
+	return xdp_metadata_kfunc_ids_unsorted[id];
+}
+
+bool bpf_dev_bound_kfunc_id(u32 btf_id)
+{
+	return btf_id_set8_contains(&xdp_metadata_kfunc_ids, btf_id);
+}
+
+static int __init xdp_metadata_init(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadata_kfunc_set);
+}
+late_initcall(xdp_metadata_init);
-- 
2.39.0.314.g84b9a713c41-goog

