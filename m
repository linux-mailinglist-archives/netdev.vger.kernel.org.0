Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B026528E1
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 23:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbiLTWVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 17:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbiLTWU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 17:20:56 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C9CB5D
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 14:20:54 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id e7-20020a636907000000b00486a75ac49dso6429761pgc.19
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 14:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F4KpgBgmxtqPss0z6NnuyIHtGf9yFTOSo0Z+jprIOPs=;
        b=gsa4/O+w2cghvuYvGEzw249i/n4Ppz2mUGsT0fB4hJPKNw/mp4VV1hDVKw8oowy3u0
         mNhMbhGYT2jwCn/J+LgauMGrslqeZpu98dpbacg4buLA9JsszvWFLUvU50AKjDa9wsH6
         l6vTLFgKsAqR+NsQZY7Ja3vUurM/fBax3pwBGREkmxlDsikPMtDCSJ1TI8o81yKl3W7a
         nIY/o7l69Yj4IpPQJlxY9hDc8cHB/u6h7p4d1WpcBrDaB7N/7ZvF6ukksKd39ptkktLm
         en3hACKCueJHw40cvj7sOnBufaC+k/66u/EJ78ULN6hhGJ+Mb5Q0nxeHG2baScmTxM6t
         UEgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F4KpgBgmxtqPss0z6NnuyIHtGf9yFTOSo0Z+jprIOPs=;
        b=e48GI2IKrxUVXzigVPGd2eLG3Uf8pI/sufGyTc5K42zzxpLURqPQWZlwkJObPJ+nBx
         8REe7QL2EL3oE9iKfYHiI2IQ0ypRnMT9nIt6r4/KbvdzkJmR1EzYfDB6Kndqh6eBlVhZ
         M70C+AWddRfcyYqhpOQVFNetxYFU17YfUm38CsYHSXVWUshR9kYRNdUTNbpAr6maL3kG
         aoaHtvAkRFGeugDxJMI7xpi1XqQTSo6I7qioRq4FwDa0Q/xFGQGyfvmLWIFH840vv7eO
         GT+yK2R3TXF6cwEcW61wZ1bCay3k81FmV3b/XGcyx2Us8JMWPtMIgDGtIgdZnec3ZjDN
         oOrQ==
X-Gm-Message-State: AFqh2ko1cFL6/QrdF/1FkRT96rLuzy2aGD4IAwfHCQMxYsaPLjmQhwa6
        UjN5jC8NZvP0D3EOUCFigvpB2EU=
X-Google-Smtp-Source: AMrXdXv5ZpEoBUCRcttIdOWNcvstS/OJD+JSUVS07VDbA2zasweOzJ85clsZ22UXwlfEqmaqkCjN6zg=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90b:3144:b0:219:629a:8ad8 with SMTP id
 ip4-20020a17090b314400b00219629a8ad8mr2992281pjb.159.1671574854407; Tue, 20
 Dec 2022 14:20:54 -0800 (PST)
Date:   Tue, 20 Dec 2022 14:20:31 -0800
In-Reply-To: <20221220222043.3348718-1-sdf@google.com>
Mime-Version: 1.0
References: <20221220222043.3348718-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220222043.3348718-6-sdf@google.com>
Subject: [PATCH bpf-next v5 05/17] bpf: Introduce device-bound XDP programs
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

New flag BPF_F_XDP_DEV_BOUND_ONLY plus all the infra to have a way
to associate a netdev with a BPF program at load time.

Some existing 'offloaded' routines are renamed to 'dev_bound' for
consistency with the rest.

netdevsim checks are dropped in favor of generic check in dev_xdp_attach.

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
 drivers/net/netdevsim/bpf.c    |   4 --
 include/linux/bpf.h            |  24 ++++++--
 include/uapi/linux/bpf.h       |   5 ++
 kernel/bpf/core.c              |   4 +-
 kernel/bpf/offload.c           | 109 +++++++++++++++++++++++++--------
 kernel/bpf/syscall.c           |   9 +--
 net/core/dev.c                 |   5 ++
 tools/include/uapi/linux/bpf.h |   5 ++
 8 files changed, 126 insertions(+), 39 deletions(-)

diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index 50854265864d..f60eb97e3a62 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -315,10 +315,6 @@ nsim_setup_prog_hw_checks(struct netdevsim *ns, struct netdev_bpf *bpf)
 		NSIM_EA(bpf->extack, "xdpoffload of non-bound program");
 		return -EINVAL;
 	}
-	if (!bpf_offload_dev_match(bpf->prog, ns->netdev)) {
-		NSIM_EA(bpf->extack, "program bound to different dev");
-		return -EINVAL;
-	}
 
 	state = bpf->prog->aux->offload->dev_priv;
 	if (WARN_ON(strcmp(state->state, "xlated"))) {
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 630f259d0447..4c9649e69993 100644
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
@@ -2451,7 +2452,7 @@ void __bpf_free_used_maps(struct bpf_prog_aux *aux,
 bool bpf_prog_get_ok(struct bpf_prog *, enum bpf_prog_type *, bool);
 
 int bpf_prog_offload_compile(struct bpf_prog *prog);
-void bpf_prog_offload_destroy(struct bpf_prog *prog);
+void bpf_prog_dev_bound_destroy(struct bpf_prog *prog);
 int bpf_prog_offload_info_fill(struct bpf_prog_info *info,
 			       struct bpf_prog *prog);
 
@@ -2479,7 +2480,13 @@ bool bpf_offload_dev_match(struct bpf_prog *prog, struct net_device *netdev);
 void unpriv_ebpf_notify(int new_state);
 
 #if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
-int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr);
+int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr);
+void bpf_dev_bound_netdev_unregister(struct net_device *dev);
+
+static inline bool bpf_prog_is_dev_bound(const struct bpf_prog_aux *aux)
+{
+	return aux->dev_bound;
+}
 
 static inline bool bpf_prog_is_offloaded(const struct bpf_prog_aux *aux)
 {
@@ -2507,12 +2514,21 @@ void sock_map_unhash(struct sock *sk);
 void sock_map_destroy(struct sock *sk);
 void sock_map_close(struct sock *sk, long timeout);
 #else
-static inline int bpf_prog_offload_init(struct bpf_prog *prog,
+static inline int bpf_prog_dev_bound_init(struct bpf_prog *prog,
 					union bpf_attr *attr)
 {
 	return -EOPNOTSUPP;
 }
 
+static inline void bpf_dev_bound_netdev_unregister(struct net_device *dev)
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
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index bc1a3d232ae4..d0b6ac896699 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1156,6 +1156,11 @@ enum bpf_link_type {
  */
 #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
 
+/* If BPF_F_XDP_DEV_BOUND_ONLY is used in BPF_PROG_LOAD command, the loaded
+ * program becomes device-bound but can access XDP metadata.
+ */
+#define BPF_F_XDP_DEV_BOUND_ONLY	(1U << 6)
+
 /* link_create.kprobe_multi.flags used in LINK_CREATE command for
  * BPF_TRACE_KPROBE_MULTI attach type to create return probe.
  */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index e9d64e26ef5b..bafcb7a3ae6f 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2554,8 +2554,8 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 #endif
 	bpf_free_used_maps(aux);
 	bpf_free_used_btfs(aux);
-	if (bpf_prog_is_offloaded(aux))
-		bpf_prog_offload_destroy(aux->prog);
+	if (bpf_prog_is_dev_bound(aux))
+		bpf_prog_dev_bound_destroy(aux->prog);
 #ifdef CONFIG_PERF_EVENTS
 	if (aux->prog->has_callchain_buf)
 		put_callchain_buffers();
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index deb06498da0b..e803824c1ddd 100644
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
@@ -89,19 +89,17 @@ static int __bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
 	INIT_LIST_HEAD(&ondev->progs);
 	INIT_LIST_HEAD(&ondev->maps);
 
-	down_write(&bpf_devs_lock);
 	err = rhashtable_insert_fast(&offdevs, &ondev->l, offdevs_params);
 	if (err) {
 		netdev_warn(netdev, "failed to register for BPF offload\n");
-		goto err_unlock_free;
+		goto err_free;
 	}
 
-	list_add(&ondev->offdev_netdevs, &offdev->netdevs);
-	up_write(&bpf_devs_lock);
+	if (offdev)
+		list_add(&ondev->offdev_netdevs, &offdev->netdevs);
 	return 0;
 
-err_unlock_free:
-	up_write(&bpf_devs_lock);
+err_free:
 	kfree(ondev);
 	return err;
 }
@@ -149,24 +147,26 @@ static void __bpf_map_offload_destroy(struct bpf_offloaded_map *offmap)
 static void __bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
 						struct net_device *netdev)
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
@@ -185,11 +185,9 @@ static void __bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
 	WARN_ON(!list_empty(&ondev->progs));
 	WARN_ON(!list_empty(&ondev->maps));
 	kfree(ondev);
-unlock:
-	up_write(&bpf_devs_lock);
 }
 
-int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
+int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr)
 {
 	struct bpf_offload_netdev *ondev;
 	struct bpf_prog_offload *offload;
@@ -199,7 +197,7 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
 	    attr->prog_type != BPF_PROG_TYPE_XDP)
 		return -EINVAL;
 
-	if (attr->prog_flags)
+	if (attr->prog_flags & ~BPF_F_XDP_DEV_BOUND_ONLY)
 		return -EINVAL;
 
 	offload = kzalloc(sizeof(*offload), GFP_USER);
@@ -214,11 +212,23 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
 	if (err)
 		goto err_maybe_put;
 
+	prog->aux->offload_requested = !(attr->prog_flags & BPF_F_XDP_DEV_BOUND_ONLY);
+
 	down_write(&bpf_devs_lock);
 	ondev = bpf_offload_find_netdev(offload->netdev);
 	if (!ondev) {
-		err = -EINVAL;
-		goto err_unlock;
+		if (bpf_prog_is_offloaded(prog->aux)) {
+			err = -EINVAL;
+			goto err_unlock;
+		}
+
+		/* When only binding to the device, explicitly
+		 * create an entry in the hashtable.
+		 */
+		err = __bpf_offload_dev_netdev_register(NULL, offload->netdev);
+		if (err)
+			goto err_unlock;
+		ondev = bpf_offload_find_netdev(offload->netdev);
 	}
 	offload->offdev = ondev->offdev;
 	prog->aux->offload = offload;
@@ -321,12 +331,41 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
 	up_read(&bpf_devs_lock);
 }
 
-void bpf_prog_offload_destroy(struct bpf_prog *prog)
+static void __bpf_prog_dev_bound_destroy(struct bpf_prog *prog)
+{
+	struct bpf_prog_offload *offload = prog->aux->offload;
+
+	if (offload->dev_state)
+		offload->offdev->ops->destroy(prog);
+
+	/* Make sure BPF_PROG_GET_NEXT_ID can't find this dead program */
+	bpf_prog_free_id(prog, true);
+
+	kfree(offload);
+	prog->aux->offload = NULL;
+}
+
+void bpf_prog_dev_bound_destroy(struct bpf_prog *prog)
 {
+	struct bpf_offload_netdev *ondev;
+	struct net_device *netdev;
+
+	rtnl_lock();
 	down_write(&bpf_devs_lock);
-	if (prog->aux->offload)
-		__bpf_prog_offload_destroy(prog);
+	if (prog->aux->offload) {
+		list_del_init(&prog->aux->offload->offloads);
+
+		netdev = prog->aux->offload->netdev;
+		if (netdev) {
+			ondev = bpf_offload_find_netdev(netdev);
+			if (ondev && !ondev->offdev && list_empty(&ondev->progs))
+				__bpf_offload_dev_netdev_unregister(NULL, netdev);
+		}
+
+		__bpf_prog_dev_bound_destroy(prog);
+	}
 	up_write(&bpf_devs_lock);
+	rtnl_unlock();
 }
 
 static int bpf_prog_offload_translate(struct bpf_prog *prog)
@@ -621,7 +660,7 @@ static bool __bpf_offload_dev_match(struct bpf_prog *prog,
 	struct bpf_offload_netdev *ondev1, *ondev2;
 	struct bpf_prog_offload *offload;
 
-	if (!bpf_prog_is_offloaded(prog->aux))
+	if (!bpf_prog_is_dev_bound(prog->aux))
 		return false;
 
 	offload = prog->aux->offload;
@@ -667,14 +706,21 @@ bool bpf_offload_prog_map_match(struct bpf_prog *prog, struct bpf_map *map)
 int bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
 				    struct net_device *netdev)
 {
-	return __bpf_offload_dev_netdev_register(offdev, netdev);
+	int err;
+
+	down_write(&bpf_devs_lock);
+	err = __bpf_offload_dev_netdev_register(offdev, netdev);
+	up_write(&bpf_devs_lock);
+	return err;
 }
 EXPORT_SYMBOL_GPL(bpf_offload_dev_netdev_register);
 
 void bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
 				       struct net_device *netdev)
 {
+	down_write(&bpf_devs_lock);
 	__bpf_offload_dev_netdev_unregister(offdev, netdev);
+	up_write(&bpf_devs_lock);
 }
 EXPORT_SYMBOL_GPL(bpf_offload_dev_netdev_unregister);
 
@@ -708,6 +754,19 @@ void *bpf_offload_dev_priv(struct bpf_offload_dev *offdev)
 }
 EXPORT_SYMBOL_GPL(bpf_offload_dev_priv);
 
+void bpf_dev_bound_netdev_unregister(struct net_device *dev)
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
 static int __init bpf_offload_init(void)
 {
 	return rhashtable_init(&offdevs, &offdevs_params);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 13bc96035116..11c558be4992 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2491,7 +2491,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				 BPF_F_TEST_STATE_FREQ |
 				 BPF_F_SLEEPABLE |
 				 BPF_F_TEST_RND_HI32 |
-				 BPF_F_XDP_HAS_FRAGS))
+				 BPF_F_XDP_HAS_FRAGS |
+				 BPF_F_XDP_DEV_BOUND_ONLY))
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
 
@@ -2598,8 +2599,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	atomic64_set(&prog->aux->refcnt, 1);
 	prog->gpl_compatible = is_gpl ? 1 : 0;
 
-	if (bpf_prog_is_offloaded(prog->aux)) {
-		err = bpf_prog_offload_init(prog, attr);
+	if (bpf_prog_is_dev_bound(prog->aux)) {
+		err = bpf_prog_dev_bound_init(prog, attr);
 		if (err)
 			goto free_prog_sec;
 	}
diff --git a/net/core/dev.c b/net/core/dev.c
index 7d31c57ddd7e..573b819c219a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9228,6 +9228,10 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 			NL_SET_ERR_MSG(extack, "Using offloaded program without HW_MODE flag is not supported");
 			return -EINVAL;
 		}
+		if (bpf_prog_is_dev_bound(new_prog->aux) && !bpf_offload_dev_match(new_prog, dev)) {
+			NL_SET_ERR_MSG(extack, "Program bound to different device");
+			return -EINVAL;
+		}
 		if (new_prog->expected_attach_type == BPF_XDP_DEVMAP) {
 			NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached to a device");
 			return -EINVAL;
@@ -10830,6 +10834,7 @@ void unregister_netdevice_many_notify(struct list_head *head,
 		dev_shutdown(dev);
 
 		dev_xdp_uninstall(dev);
+		bpf_dev_bound_netdev_unregister(dev);
 
 		netdev_offload_xstats_disable_all(dev);
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index bc1a3d232ae4..d0b6ac896699 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1156,6 +1156,11 @@ enum bpf_link_type {
  */
 #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
 
+/* If BPF_F_XDP_DEV_BOUND_ONLY is used in BPF_PROG_LOAD command, the loaded
+ * program becomes device-bound but can access XDP metadata.
+ */
+#define BPF_F_XDP_DEV_BOUND_ONLY	(1U << 6)
+
 /* link_create.kprobe_multi.flags used in LINK_CREATE command for
  * BPF_TRACE_KPROBE_MULTI attach type to create return probe.
  */
-- 
2.39.0.314.g84b9a713c41-goog

