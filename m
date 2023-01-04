Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2F565DF6F
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 23:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240397AbjADWAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 17:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240380AbjADWAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 17:00:04 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128AA3FA0C
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 14:00:00 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id l21-20020a17090aec1500b00225e3da1786so9503021pjy.7
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 14:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gQMBRxw8JPua4o+63ZS647M21B9IqneBpUt1tZQtk/U=;
        b=Dt1Mcvj0Jp5pI0qxHV2yG8rA0m/2eWdJIE6IuyvKCS4Hox+g06yudAXoB0AVgiVret
         jXAHlMe7xnShP9UemmNbvxnMg2FxG9ORuxgU1fqC18XqcoKYy5Ut299Fq/NgildoAXDL
         TpjsBELnu3jOKUFTOjhSXKy3O/AYyAIIv1dR2KDC7zAwlcO++55ZZl7H4vpK3QeFdv+4
         bUyoy8n0Djp9iRMNVhcvmGEM21mNVCTuqSamUaiauagTlzxvdBqNWU3IX5JGUCZj/YRz
         1Yj8yg9aaa9QZ8SkUpLXmao2aekvwa/5HFw8t+wuQBaamLnGQHwnUCSoTOryvFa/aAhB
         kYWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gQMBRxw8JPua4o+63ZS647M21B9IqneBpUt1tZQtk/U=;
        b=RipiqJQ2BvS4wuGY1+yGxg6IJnOYwkMUOe+nmSHlBZeaoIlTU5RjzucgJVmvt39jt2
         JpRU1so7n9wVup8ugumViTTqmg4GpWRCGm3ew/z3k6Z72hrvQdzMtuda5uEzK72BEckz
         dRCavS5098cdOL27f398b5TfXN9sVYakiJzttj60q/id1i3TA4TKg20eYAaOyASj0+Av
         CZvX9tjYzOXDoR/BcJyv1NoKNahqPdbaZtkGL0bKCy4Dl4ZCUbwcer4BNSBePqBRgP6r
         xiyNxPIkhyhFzrXzS/SLZsLt3JNQeDqwEcEReRA51UOs6aX3NYbi9DBVvhBVkU3P+Udp
         IqlA==
X-Gm-Message-State: AFqh2ko88rEgBs6TORxjMWwIRJ/df6OMdmliaVUZVEGZkmtXAK36a70O
        r2DBkpxMlSRoTlN0Ev+UU7LlMJ4=
X-Google-Smtp-Source: AMrXdXsFbI7UUWs5vd35ZJOqvdHZgIcWSoJMmufX8I5DG2L4k7DbOJqKeWPcFMr9OIfHPxTTpMO4dB8=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90b:68e:b0:226:2e5:2e1a with SMTP id
 m14-20020a17090b068e00b0022602e52e1amr2153780pjz.145.1672869599507; Wed, 04
 Jan 2023 13:59:59 -0800 (PST)
Date:   Wed,  4 Jan 2023 13:59:37 -0800
In-Reply-To: <20230104215949.529093-1-sdf@google.com>
Mime-Version: 1.0
References: <20230104215949.529093-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230104215949.529093-6-sdf@google.com>
Subject: [PATCH bpf-next v6 05/17] bpf: Introduce device-bound XDP programs
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
 drivers/net/netdevsim/bpf.c    |  4 --
 include/linux/bpf.h            | 24 +++++++--
 include/uapi/linux/bpf.h       |  5 ++
 kernel/bpf/core.c              |  4 +-
 kernel/bpf/offload.c           | 97 ++++++++++++++++++++++++----------
 kernel/bpf/syscall.c           |  9 ++--
 net/core/dev.c                 |  5 ++
 tools/include/uapi/linux/bpf.h |  5 ++
 8 files changed, 112 insertions(+), 41 deletions(-)

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
index 87eacbefda05..3f245025bcf1 100644
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
index deb06498da0b..9bbf1edc9f9e 100644
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
@@ -199,12 +197,12 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
 	    attr->prog_type != BPF_PROG_TYPE_XDP)
 		return -EINVAL;
 
-	if (attr->prog_flags)
+	if (attr->prog_flags & ~BPF_F_XDP_DEV_BOUND_ONLY)
 		return -EINVAL;
 
-	offload = kzalloc(sizeof(*offload), GFP_USER);
-	if (!offload)
-		return -ENOMEM;
+	if (attr->prog_type == BPF_PROG_TYPE_SCHED_CLS &&
+	    attr->prog_flags & BPF_F_XDP_DEV_BOUND_ONLY)
+		return -EINVAL;
 
 	offload->prog = prog;
 
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
@@ -321,12 +331,25 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
 	up_read(&bpf_devs_lock);
 }
 
-void bpf_prog_offload_destroy(struct bpf_prog *prog)
+void bpf_prog_dev_bound_destroy(struct bpf_prog *prog)
 {
+	struct bpf_offload_netdev *ondev;
+	struct net_device *netdev;
+
+	rtnl_lock();
 	down_write(&bpf_devs_lock);
-	if (prog->aux->offload)
+	if (prog->aux->offload) {
+		list_del_init(&prog->aux->offload->offloads);
+
+		netdev = prog->aux->offload->netdev;
 		__bpf_prog_offload_destroy(prog);
+
+		ondev = bpf_offload_find_netdev(netdev);
+		if (!ondev->offdev && list_empty(&ondev->progs))
+			__bpf_offload_dev_netdev_unregister(NULL, netdev);
+	}
 	up_write(&bpf_devs_lock);
+	rtnl_unlock();
 }
 
 static int bpf_prog_offload_translate(struct bpf_prog *prog)
@@ -621,7 +644,7 @@ static bool __bpf_offload_dev_match(struct bpf_prog *prog,
 	struct bpf_offload_netdev *ondev1, *ondev2;
 	struct bpf_prog_offload *offload;
 
-	if (!bpf_prog_is_offloaded(prog->aux))
+	if (!bpf_prog_is_dev_bound(prog->aux))
 		return false;
 
 	offload = prog->aux->offload;
@@ -667,14 +690,21 @@ bool bpf_offload_prog_map_match(struct bpf_prog *prog, struct bpf_map *map)
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
 
@@ -708,6 +738,19 @@ void *bpf_offload_dev_priv(struct bpf_offload_dev *offdev)
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
index 5f7eac057cdc..191a4312f4b7 100644
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

