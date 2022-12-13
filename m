Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1C3B64ADB2
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 03:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbiLMCgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 21:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234236AbiLMCgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 21:36:32 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1241D32F
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:16 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id i4-20020a17090332c400b0018f82951826so4178585plr.20
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aaTD9DtSYMCbnO/EY+KiLmSkv7hwjtULTL1SptPB+YU=;
        b=pDZsPSvSjd/n4M0AH7Acv2WSn6IQ33MkGH994y1WNR9qiRyj89tkuXUkX6MyVx6OY3
         d1uU5DK55+8gyIJiP6eJxDi+0ndu5fqKLBDfIgO/ZYJlgtz1R7p/QIWzQcZecm4bcZ0U
         Y+LE6Fe75+llrau+QdCBL9DbCfsnXl6IY0p5WzKlNiRy0Ulmu2UcmgIzukQgTFKZgVrL
         N0cuCWq0adlyk7CKe7sUxOUes7F0tVojL4SjwcDjfNYxyFwhKVKaS2yJ2b/WfvdoEv6h
         3s3KDoB0fG203GkgjQV19iEQb5eXfQTDEpCBY8rNGSbQ9PPfzRYWaL4zn2jwMdK7kG6c
         2Q1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aaTD9DtSYMCbnO/EY+KiLmSkv7hwjtULTL1SptPB+YU=;
        b=tQ64COTrn7fOhxw00MBPfGSGLTRSlQmN6WtVA3nOyJ6FsAMbzd2Ke7sy+OroREm78T
         EDa4JnsLy+KsknXCKzm0ifHjEYZLNVdVLZz+IQRVCDRrhZIlI2iz6L3PYcJoxRDlU11n
         quq4Oy2/7jrzkdZ7uZM0VPEa3Ggz5gbwobYQ6OhY4fElSqx4u9eznrEev1piSVr1sWIF
         sC2fuCrTyA7X45zyRNRd+MeWPBuS2ctG2a/GSZjzfEwFAUMF+tZ8JYj55nL7lXzH2ya1
         t3qa0E+CbMii+BGLEq92oae12Kxs3tgqBSp1TqLvNshZTClSRGMiiDtf3ecZFNGMO/Zk
         7kbg==
X-Gm-Message-State: ANoB5pnCmlM27Fi3qviaJgwzn+kCFO2OseDKzZD19Uui+m94ZWjoyOpi
        Y5Uyg+hVeQalW3bBqJDnUKIj8BM=
X-Google-Smtp-Source: AA0mqf7D8B2okxUV5pMM2kVVp/R2bGRBum5pVPQA7csDCjwkUZOjcG3qElwHceei/SWgc4DJYX6K6mY=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:2483:b0:56c:12c0:aaf1 with SMTP id
 c3-20020a056a00248300b0056c12c0aaf1mr80175603pfv.50.1670898975555; Mon, 12
 Dec 2022 18:36:15 -0800 (PST)
Date:   Mon, 12 Dec 2022 18:35:55 -0800
In-Reply-To: <20221213023605.737383-1-sdf@google.com>
Mime-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213023605.737383-6-sdf@google.com>
Subject: [PATCH bpf-next v4 05/15] bpf: XDP metadata RX kfuncs
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
 include/linux/bpf.h       |  2 ++
 include/linux/netdevice.h |  7 +++++++
 include/net/xdp.h         | 25 ++++++++++++++++++++++
 kernel/bpf/core.c         |  7 +++++++
 kernel/bpf/offload.c      | 23 ++++++++++++++++++++
 kernel/bpf/verifier.c     | 29 +++++++++++++++++++++++++-
 net/core/xdp.c            | 44 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 136 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ca22e8b8bd82..de6279725f41 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2477,6 +2477,8 @@ void bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
 				       struct net_device *netdev);
 bool bpf_offload_dev_match(struct bpf_prog *prog, struct net_device *netdev);
 
+void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id);
+
 void unpriv_ebpf_notify(int new_state);
 
 #if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5aa35c58c342..63786091c60d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -74,6 +74,7 @@ struct udp_tunnel_nic_info;
 struct udp_tunnel_nic;
 struct bpf_prog;
 struct xdp_buff;
+struct xdp_md;
 
 void synchronize_net(void);
 void netdev_set_default_ethtool_ops(struct net_device *dev,
@@ -1613,6 +1614,11 @@ struct net_device_ops {
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
@@ -2044,6 +2050,7 @@ struct net_device {
 	unsigned int		flags;
 	unsigned long long	priv_flags;
 	const struct net_device_ops *netdev_ops;
+	const struct xdp_metadata_ops *xdp_metadata_ops;
 	int			ifindex;
 	unsigned short		gflags;
 	unsigned short		hard_header_len;
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 55dbc68bfffc..152c3a9c1127 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -409,4 +409,29 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 
 #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
 
+#define XDP_METADATA_KFUNC_xxx	\
+	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
+			   bpf_xdp_metadata_rx_timestamp) \
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
+struct xdp_md;
+int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp);
+int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash);
+
+#ifdef CONFIG_NET
+u32 xdp_metadata_kfunc_id(int id);
+bool xdp_is_metadata_kfunc_id(u32 btf_id);
+#else
+static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
+static inline bool xdp_is_metadata_kfunc_id(u32 btf_id) { return false; }
+#endif
+
 #endif /* __LINUX_NET_XDP_H__ */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index d434a994ee04..c3e501e3e39c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2097,6 +2097,13 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
 	if (fp->kprobe_override)
 		return false;
 
+	/* When tail-calling from a non-dev-bound program to a dev-bound one,
+	 * XDP metadata helpers should be disabled. Until it's implemented,
+	 * prohibit adding dev-bound programs to tail-call maps.
+	 */
+	if (bpf_prog_is_dev_bound(fp->aux))
+		return false;
+
 	spin_lock(&map->owner.lock);
 	if (!map->owner.type) {
 		/* There's no owner yet where we could check for
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index f714c941f8ea..3b6c9023f24d 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -757,6 +757,29 @@ void bpf_dev_bound_netdev_unregister(struct net_device *dev)
 	up_write(&bpf_devs_lock);
 }
 
+void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
+{
+	const struct xdp_metadata_ops *ops;
+	void *p = NULL;
+
+	down_read(&bpf_devs_lock);
+	if (!prog->aux->offload || !prog->aux->offload->netdev)
+		goto out;
+
+	ops = prog->aux->offload->netdev->xdp_metadata_ops;
+	if (!ops)
+		goto out;
+
+	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
+		p = ops->xmo_rx_timestamp;
+	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
+		p = ops->xmo_rx_hash;
+out:
+	up_read(&bpf_devs_lock);
+
+	return p;
+}
+
 static int __init bpf_offload_init(void)
 {
 	int err;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 203d8cfeda70..e61fe0472b9b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15479,12 +15479,35 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
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
+	if (xdp_is_metadata_kfunc_id(insn->imm)) {
+		if (!bpf_prog_is_dev_bound(env->prog->aux)) {
+			verbose(env, "metadata kfuncs require device-bound program\n");
+			return -EINVAL;
+		}
+
+		if (bpf_prog_is_offloaded(env->prog->aux)) {
+			verbose(env, "metadata kfuncs can't be offloaded\n");
+			return -EINVAL;
+		}
+
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
@@ -15495,7 +15518,6 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		return -EFAULT;
 	}
 
-	*cnt = 0;
 	insn->imm = desc->imm;
 	if (insn->off)
 		return 0;
@@ -16502,6 +16524,11 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
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
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 844c9d99dc0e..b0d4080249d7 100644
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
@@ -709,3 +710,46 @@ struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
 
 	return nxdpf;
 }
+
+noinline int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
+{
+	return -EOPNOTSUPP;
+}
+
+noinline int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash)
+{
+	return -EOPNOTSUPP;
+}
+
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
+
+bool xdp_is_metadata_kfunc_id(u32 btf_id)
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
2.39.0.rc1.256.g54fd8350bd-goog

