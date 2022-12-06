Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35EA643B74
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 03:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbiLFCq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 21:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbiLFCqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 21:46:16 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67ACD20344
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 18:46:01 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id z10-20020a170902ccca00b001898329db72so15222539ple.21
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 18:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0OLqzO8RGNlSfD/Je2xYu1Ol1vgBvw0wxdpIz5zNg3A=;
        b=B3qNkZacyvpd1JaDw1zq2VRb7IQY00aoGH3udNtcYw9B64tIOYv9HhlgVGMg7wXFcY
         ZRE1xcRBycbdH33xIcsUvRuvrmdvGGew8yLmmKlI9pp2VITdem/T8BpFcml9qAMvFLYi
         lDH5JQpmmmPaZysRz16DrI2FfoNTWaqR87hK/csY3fuFS0b6va0APIDe1x2rdBDIKYhl
         k+M8scCOAAc6uyYrKTJk45usY/P4bmS/CYNLCQd+1GVvXzKGAufIAg9VvSxg+3VLgZBb
         iIzglWXhLTYYrKw27M7i2eAZ49lcg5YX9Eu0nJ+MF8l7GyZPnzQ6mpaIo4Ho1VWCIT7x
         Finw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0OLqzO8RGNlSfD/Je2xYu1Ol1vgBvw0wxdpIz5zNg3A=;
        b=T554L2dqSv7JBobkBcJIFP05zfYVnMzEXfo6HJ5XtwdTMxMTs7QMqdZtUqUE2XudXX
         aRL1XyhR0bD/1k4nXirvEBdqPdbKjS28UKwhQ4LpVZr8dmsivH9fSU1BoA1l+YYS/rwW
         +k6NUkZZEMRvrk/Lk2B9N+Pdo80uSSyUleC0i0+358B91bo7SH/J88ApOfNbGu2mcaGB
         pEOQg5U2h6cGQ4Yd0OG/zJoWbJlh0DcqpXeD9udp/Zf0FDJ1LKr8LYt4pmxXIscE7+wm
         Kb/SGGX/XoYb4eKuCWvLgQcL5piTEC8AGYPY+gxZQwmlAt8M78ZavGDTvwIuzPXDpM/8
         24AA==
X-Gm-Message-State: ANoB5pkg2umN8mIovT613crttjG0Xf7MO5w14DKNjlJsi+GEx7nOhh9t
        mZ3yuUMrbiZ/fodrPFidlVYqec0=
X-Google-Smtp-Source: AA0mqf4dfQvnncObQVShEXSNzmyhX1ZV5v+p4WbsQGt0sZQOnHRDZ/NwHsUYOcdEj9BLOKcA5zfzZeA=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:aa7:86c7:0:b0:562:45f0:df50 with SMTP id
 h7-20020aa786c7000000b0056245f0df50mr68920250pfo.16.1670294760901; Mon, 05
 Dec 2022 18:46:00 -0800 (PST)
Date:   Mon,  5 Dec 2022 18:45:45 -0800
In-Reply-To: <20221206024554.3826186-1-sdf@google.com>
Mime-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206024554.3826186-4-sdf@google.com>
Subject: [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
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
 include/linux/bpf.h            |  20 +++-
 include/linux/netdevice.h      |   5 +
 include/net/xdp.h              |  29 ++++++
 include/uapi/linux/bpf.h       |   5 +
 kernel/bpf/arraymap.c          |  17 +++-
 kernel/bpf/core.c              |   2 +-
 kernel/bpf/offload.c           | 162 ++++++++++++++++++++++++++++-----
 kernel/bpf/syscall.c           |   7 +-
 kernel/bpf/verifier.c          |  24 ++++-
 net/core/dev.c                 |   5 +
 net/core/xdp.c                 |  58 ++++++++++++
 tools/include/uapi/linux/bpf.h |   5 +
 12 files changed, 304 insertions(+), 35 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d5d479dae118..b46b60f4eae1 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1261,7 +1261,8 @@ struct bpf_prog_aux {
 	enum bpf_prog_type saved_dst_prog_type;
 	enum bpf_attach_type saved_dst_attach_type;
 	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
-	bool offload_requested;
+	bool dev_bound; /* Program is bound to the netdev. */
+	bool offload_requested; /* Program is bound and offloaded to the netdev. */
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
 	bool func_proto_unreliable;
 	bool sleepable;
@@ -2476,10 +2477,18 @@ void bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
 				       struct net_device *netdev);
 bool bpf_offload_dev_match(struct bpf_prog *prog, struct net_device *netdev);
 
+void *bpf_offload_resolve_kfunc(struct bpf_prog *prog, u32 func_id);
+
 void unpriv_ebpf_notify(int new_state);
 
 #if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
 int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr);
+void bpf_offload_bound_netdev_unregister(struct net_device *dev);
+
+static inline bool bpf_prog_is_dev_bound(const struct bpf_prog_aux *aux)
+{
+	return aux->dev_bound;
+}
 
 static inline bool bpf_prog_is_offloaded(const struct bpf_prog_aux *aux)
 {
@@ -2513,6 +2522,15 @@ static inline int bpf_prog_offload_init(struct bpf_prog *prog,
 	return -EOPNOTSUPP;
 }
 
+static inline void bpf_offload_bound_netdev_unregister(struct net_device *dev)
+{
+}
+
+static inline bool bpf_prog_is_dev_bound(const struct bpf_prog_aux *aux)
+{
+	return false;
+}
+
 static inline bool bpf_prog_is_offloaded(struct bpf_prog_aux *aux)
 {
 	return false;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5aa35c58c342..2eabb9157767 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -74,6 +74,7 @@ struct udp_tunnel_nic_info;
 struct udp_tunnel_nic;
 struct bpf_prog;
 struct xdp_buff;
+struct xdp_md;
 
 void synchronize_net(void);
 void netdev_set_default_ethtool_ops(struct net_device *dev,
@@ -1611,6 +1612,10 @@ struct net_device_ops {
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
index 55dbc68bfffc..c24aba5c363b 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -409,4 +409,33 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 
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
+#ifdef CONFIG_NET
+u32 xdp_metadata_kfunc_id(int id);
+#else
+static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
+#endif
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
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 484706959556..9b190b72ffce 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -881,12 +881,21 @@ static void *prog_fd_array_get_ptr(struct bpf_map *map,
 	if (IS_ERR(prog))
 		return prog;
 
-	if (!bpf_prog_map_compatible(map, prog)) {
-		bpf_prog_put(prog);
-		return ERR_PTR(-EINVAL);
-	}
+	/* When tail-calling from a non-dev-bound program to a dev-bound one,
+	 * XDP metadata helpers should be disabled. Until it's implemented,
+	 * prohibit adding dev-bound programs to tail-call maps.
+	 */
+	if (bpf_prog_is_dev_bound(prog->aux))
+		goto err;
+
+	if (!bpf_prog_map_compatible(map, prog))
+		goto err;
 
 	return prog;
+
+err:
+	bpf_prog_put(prog);
+	return ERR_PTR(-EINVAL);
 }
 
 static void prog_fd_array_put_ptr(void *ptr)
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 641ab412ad7e..71c6dc081f62 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2554,7 +2554,7 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 #endif
 	bpf_free_used_maps(aux);
 	bpf_free_used_btfs(aux);
-	if (bpf_prog_is_offloaded(aux))
+	if (bpf_prog_is_dev_bound(aux))
 		bpf_prog_offload_destroy(aux->prog);
 #ifdef CONFIG_PERF_EVENTS
 	if (aux->prog->has_callchain_buf)
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index f5769a8ecbee..bad8bab916eb 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -41,7 +41,7 @@ struct bpf_offload_dev {
 struct bpf_offload_netdev {
 	struct rhash_head l;
 	struct net_device *netdev;
-	struct bpf_offload_dev *offdev;
+	struct bpf_offload_dev *offdev; /* NULL when bound-only */
 	struct list_head progs;
 	struct list_head maps;
 	struct list_head offdev_netdevs;
@@ -58,6 +58,12 @@ static const struct rhashtable_params offdevs_params = {
 static struct rhashtable offdevs;
 static bool offdevs_inited;
 
+static int __bpf_offload_init(void);
+static int __bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
+					     struct net_device *netdev);
+static void __bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
+						struct net_device *netdev);
+
 static int bpf_dev_offload_check(struct net_device *netdev)
 {
 	if (!netdev)
@@ -87,13 +93,17 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
 	    attr->prog_type != BPF_PROG_TYPE_XDP)
 		return -EINVAL;
 
-	if (attr->prog_flags)
+	if (attr->prog_flags & ~BPF_F_XDP_HAS_METADATA)
 		return -EINVAL;
 
 	offload = kzalloc(sizeof(*offload), GFP_USER);
 	if (!offload)
 		return -ENOMEM;
 
+	err = __bpf_offload_init();
+	if (err)
+		return err;
+
 	offload->prog = prog;
 
 	offload->netdev = dev_get_by_index(current->nsproxy->net_ns,
@@ -102,11 +112,25 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
 	if (err)
 		goto err_maybe_put;
 
+	prog->aux->offload_requested = !(attr->prog_flags & BPF_F_XDP_HAS_METADATA);
+
 	down_write(&bpf_devs_lock);
 	ondev = bpf_offload_find_netdev(offload->netdev);
 	if (!ondev) {
-		err = -EINVAL;
-		goto err_unlock;
+		if (!prog->aux->offload_requested) {
+			/* When only binding to the device, explicitly
+			 * create an entry in the hashtable. See related
+			 * maybe_remove_bound_netdev.
+			 */
+			err = __bpf_offload_dev_netdev_register(NULL, offload->netdev);
+			if (err)
+				goto err_unlock;
+			ondev = bpf_offload_find_netdev(offload->netdev);
+		}
+		if (!ondev) {
+			err = -EINVAL;
+			goto err_unlock;
+		}
 	}
 	offload->offdev = ondev->offdev;
 	prog->aux->offload = offload;
@@ -209,6 +233,19 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
 	up_read(&bpf_devs_lock);
 }
 
+static void maybe_remove_bound_netdev(struct net_device *dev)
+{
+	struct bpf_offload_netdev *ondev;
+
+	rtnl_lock();
+	down_write(&bpf_devs_lock);
+	ondev = bpf_offload_find_netdev(dev);
+	if (ondev && !ondev->offdev && list_empty(&ondev->progs))
+		__bpf_offload_dev_netdev_unregister(NULL, dev);
+	up_write(&bpf_devs_lock);
+	rtnl_unlock();
+}
+
 static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
 {
 	struct bpf_prog_offload *offload = prog->aux->offload;
@@ -226,10 +263,17 @@ static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
 
 void bpf_prog_offload_destroy(struct bpf_prog *prog)
 {
+	struct net_device *netdev = NULL;
+
 	down_write(&bpf_devs_lock);
-	if (prog->aux->offload)
+	if (prog->aux->offload) {
+		netdev = prog->aux->offload->netdev;
 		__bpf_prog_offload_destroy(prog);
+	}
 	up_write(&bpf_devs_lock);
+
+	if (netdev)
+		maybe_remove_bound_netdev(netdev);
 }
 
 static int bpf_prog_offload_translate(struct bpf_prog *prog)
@@ -549,7 +593,7 @@ static bool __bpf_offload_dev_match(struct bpf_prog *prog,
 	struct bpf_offload_netdev *ondev1, *ondev2;
 	struct bpf_prog_offload *offload;
 
-	if (!bpf_prog_is_offloaded(prog->aux))
+	if (!bpf_prog_is_dev_bound(prog->aux))
 		return false;
 
 	offload = prog->aux->offload;
@@ -592,8 +636,8 @@ bool bpf_offload_prog_map_match(struct bpf_prog *prog, struct bpf_map *map)
 	return ret;
 }
 
-int bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
-				    struct net_device *netdev)
+static int __bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
+					     struct net_device *netdev)
 {
 	struct bpf_offload_netdev *ondev;
 	int err;
@@ -607,15 +651,14 @@ int bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
 	INIT_LIST_HEAD(&ondev->progs);
 	INIT_LIST_HEAD(&ondev->maps);
 
-	down_write(&bpf_devs_lock);
 	err = rhashtable_insert_fast(&offdevs, &ondev->l, offdevs_params);
 	if (err) {
 		netdev_warn(netdev, "failed to register for BPF offload\n");
 		goto err_unlock_free;
 	}
 
-	list_add(&ondev->offdev_netdevs, &offdev->netdevs);
-	up_write(&bpf_devs_lock);
+	if (offdev)
+		list_add(&ondev->offdev_netdevs, &offdev->netdevs);
 	return 0;
 
 err_unlock_free:
@@ -623,29 +666,42 @@ int bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
 	kfree(ondev);
 	return err;
 }
+
+int bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
+				    struct net_device *netdev)
+{
+	int err;
+
+	down_write(&bpf_devs_lock);
+	err = __bpf_offload_dev_netdev_register(offdev, netdev);
+	up_write(&bpf_devs_lock);
+	return err;
+}
 EXPORT_SYMBOL_GPL(bpf_offload_dev_netdev_register);
 
-void bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
-				       struct net_device *netdev)
+static void __bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
+						struct net_device *netdev)
 {
-	struct bpf_offload_netdev *ondev, *altdev;
+	struct bpf_offload_netdev *ondev, *altdev = NULL;
 	struct bpf_offloaded_map *offmap, *mtmp;
 	struct bpf_prog_offload *offload, *ptmp;
 
 	ASSERT_RTNL();
 
-	down_write(&bpf_devs_lock);
 	ondev = rhashtable_lookup_fast(&offdevs, &netdev, offdevs_params);
 	if (WARN_ON(!ondev))
-		goto unlock;
+		return;
 
 	WARN_ON(rhashtable_remove_fast(&offdevs, &ondev->l, offdevs_params));
-	list_del(&ondev->offdev_netdevs);
 
 	/* Try to move the objects to another netdev of the device */
-	altdev = list_first_entry_or_null(&offdev->netdevs,
-					  struct bpf_offload_netdev,
-					  offdev_netdevs);
+	if (offdev) {
+		list_del(&ondev->offdev_netdevs);
+		altdev = list_first_entry_or_null(&offdev->netdevs,
+						  struct bpf_offload_netdev,
+						  offdev_netdevs);
+	}
+
 	if (altdev) {
 		list_for_each_entry(offload, &ondev->progs, offloads)
 			offload->netdev = altdev->netdev;
@@ -664,15 +720,19 @@ void bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
 	WARN_ON(!list_empty(&ondev->progs));
 	WARN_ON(!list_empty(&ondev->maps));
 	kfree(ondev);
-unlock:
+}
+
+void bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
+				       struct net_device *netdev)
+{
+	down_write(&bpf_devs_lock);
+	__bpf_offload_dev_netdev_unregister(offdev, netdev);
 	up_write(&bpf_devs_lock);
 }
 EXPORT_SYMBOL_GPL(bpf_offload_dev_netdev_unregister);
 
-struct bpf_offload_dev *
-bpf_offload_dev_create(const struct bpf_prog_offload_ops *ops, void *priv)
+static int __bpf_offload_init(void)
 {
-	struct bpf_offload_dev *offdev;
 	int err;
 
 	down_write(&bpf_devs_lock);
@@ -680,12 +740,25 @@ bpf_offload_dev_create(const struct bpf_prog_offload_ops *ops, void *priv)
 		err = rhashtable_init(&offdevs, &offdevs_params);
 		if (err) {
 			up_write(&bpf_devs_lock);
-			return ERR_PTR(err);
+			return err;
 		}
 		offdevs_inited = true;
 	}
 	up_write(&bpf_devs_lock);
 
+	return 0;
+}
+
+struct bpf_offload_dev *
+bpf_offload_dev_create(const struct bpf_prog_offload_ops *ops, void *priv)
+{
+	struct bpf_offload_dev *offdev;
+	int err;
+
+	err = __bpf_offload_init();
+	if (err)
+		return ERR_PTR(err);
+
 	offdev = kzalloc(sizeof(*offdev), GFP_KERNEL);
 	if (!offdev)
 		return ERR_PTR(-ENOMEM);
@@ -710,3 +783,42 @@ void *bpf_offload_dev_priv(struct bpf_offload_dev *offdev)
 	return offdev->priv;
 }
 EXPORT_SYMBOL_GPL(bpf_offload_dev_priv);
+
+void bpf_offload_bound_netdev_unregister(struct net_device *dev)
+{
+	struct bpf_offload_netdev *ondev;
+
+	ASSERT_RTNL();
+
+	down_write(&bpf_devs_lock);
+	ondev = bpf_offload_find_netdev(dev);
+	if (ondev && !ondev->offdev)
+		__bpf_offload_dev_netdev_unregister(NULL, ondev->netdev);
+	up_write(&bpf_devs_lock);
+}
+
+void *bpf_offload_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
+{
+	const struct net_device_ops *netdev_ops;
+	void *p = NULL;
+
+	down_read(&bpf_devs_lock);
+	if (!prog->aux->offload || !prog->aux->offload->netdev)
+		goto out;
+
+	netdev_ops = prog->aux->offload->netdev->netdev_ops;
+
+	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED))
+		p = netdev_ops->ndo_xdp_rx_timestamp_supported;
+	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
+		p = netdev_ops->ndo_xdp_rx_timestamp;
+	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH_SUPPORTED))
+		p = netdev_ops->ndo_xdp_rx_hash_supported;
+	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
+		p = netdev_ops->ndo_xdp_rx_hash;
+	/* fallback to default kfunc when not supported by netdev */
+out:
+	up_read(&bpf_devs_lock);
+
+	return p;
+}
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 13bc96035116..b345a273f7d0 100644
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
@@ -2575,7 +2576,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	prog->aux->attach_btf = attach_btf;
 	prog->aux->attach_btf_id = attr->attach_btf_id;
 	prog->aux->dst_prog = dst_prog;
-	prog->aux->offload_requested = !!attr->prog_ifindex;
+	prog->aux->dev_bound = !!attr->prog_ifindex;
 	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
 	prog->aux->xdp_has_frags = attr->prog_flags & BPF_F_XDP_HAS_FRAGS;
 
@@ -2598,7 +2599,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	atomic64_set(&prog->aux->refcnt, 1);
 	prog->gpl_compatible = is_gpl ? 1 : 0;
 
-	if (bpf_prog_is_offloaded(prog->aux)) {
+	if (bpf_prog_is_dev_bound(prog->aux)) {
 		err = bpf_prog_offload_init(prog, attr);
 		if (err)
 			goto free_prog_sec;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index fc4e313a4d2e..00951a59ee26 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15323,6 +15323,24 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		return -EINVAL;
 	}
 
+	*cnt = 0;
+
+	if (resolve_prog_type(env->prog) == BPF_PROG_TYPE_XDP) {
+		if (bpf_prog_is_offloaded(env->prog->aux)) {
+			verbose(env, "no metadata kfuncs offload\n");
+			return -EINVAL;
+		}
+
+		if (bpf_prog_is_dev_bound(env->prog->aux)) {
+			void *p = bpf_offload_resolve_kfunc(env->prog, insn->imm);
+
+			if (p) {
+				insn->imm = BPF_CALL_IMM(p);
+				return 0;
+			}
+		}
+	}
+
 	/* insn->imm has the btf func_id. Replace it with
 	 * an address (relative to __bpf_base_call).
 	 */
@@ -15333,7 +15351,6 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		return -EFAULT;
 	}
 
-	*cnt = 0;
 	insn->imm = desc->imm;
 	if (insn->off)
 		return 0;
@@ -16340,6 +16357,11 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
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
diff --git a/net/core/dev.c b/net/core/dev.c
index 5b221568dfd4..862e03fcffa6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9228,6 +9228,10 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 			NL_SET_ERR_MSG(extack, "Using device-bound program without HW_MODE flag is not supported");
 			return -EINVAL;
 		}
+		if (bpf_prog_is_dev_bound(new_prog->aux) && !bpf_offload_dev_match(new_prog, dev)) {
+			NL_SET_ERR_MSG(extack, "Cannot attach to a different target device");
+			return -EINVAL;
+		}
 		if (new_prog->expected_attach_type == BPF_XDP_DEVMAP) {
 			NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached to a device");
 			return -EINVAL;
@@ -10813,6 +10817,7 @@ void unregister_netdevice_many_notify(struct list_head *head,
 		/* Shutdown queueing discipline. */
 		dev_shutdown(dev);
 
+		bpf_offload_bound_netdev_unregister(dev);
 		dev_xdp_uninstall(dev);
 
 		netdev_offload_xstats_disable_all(dev);
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
2.39.0.rc0.267.gcb52ba06e7-goog

