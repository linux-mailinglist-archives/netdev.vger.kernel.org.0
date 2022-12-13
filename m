Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE51364ADAE
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 03:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbiLMCgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 21:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234130AbiLMCgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 21:36:15 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78241AF31
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:12 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 7-20020a631547000000b00478959ba320so8757033pgv.19
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P0AA5h8Ik63MZ6KrfvJ4IJRwQNCDa9Gzm9cthJyMxv8=;
        b=WtDM+4e/11lfGkaeaFpm0mhsi8L0ReKqluev9Lz7e9VoA/eUVD32+R2zSazg3pdMz7
         UOrVCUssKOdMNBAQla+1Sht1gMAtfBbGyVWwztOhAIqFqewQUwQ+UY7bw33ZUkRp466O
         woYgikqHVcvPZEdWeRg+tv2tqW6ABTLbglkaCjOfyhrCVvLn/sjCJfSL+deCXGqXIQTu
         8l+yeoKI5wmbE5x2IFZP8vq1kf7QqEPKum94XvF7v66TT01zAiVX+zkzaNiKAekLa0Yu
         YT5qV5eH1HQEPlPLyz8bFIejbkYFheDy9j9TGInglNn8Z1+VCjBzRgBIFPup4hgpVhG5
         BKFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P0AA5h8Ik63MZ6KrfvJ4IJRwQNCDa9Gzm9cthJyMxv8=;
        b=eWODD9YyKa32xPFtKrii4STpaX2mCv+mc+CFqLLwxvwk1SF8hplAeyteHtgmVLtIhf
         dTeR0eB2Azk41OzuSdcmzBzMb9d/+TDIZ/l/zyWyp/eBJFYuXntQft4avOCP2BrXsEBL
         ZbB3azZ6KWKFD+yc+QfHBF/8CNzNoY7b1SirC9w3j96G1ilkJWjU0ZiHCUt4WnTOIV/F
         0pi/2xI7IRwGBeEeHZEqc0a8aRp/SHRZ7/AKts3VhT016cGTAYBx0+Pn7Fm1xgBjM8ru
         lY+EQJz4Edt3g7et2ekHahJPWbZQtaSjv7GjQGdFb6RRovO0hLFkPZMQdEVK0izdS3Zk
         9m5Q==
X-Gm-Message-State: ANoB5plzUPqVlpgxz4Cw+1Ce+OA5W4Z9WSDSS3lnj+tES9Cop+7mVw/E
        RstyMC92MVuPg1thDg1rd/eDzik=
X-Google-Smtp-Source: AA0mqf7nCqN6EnU/l7THmMeMve70AzFdZopeRncWoDUWqVebYHIvl6lId4G0Uh+oSMC12K1OdTIpPGA=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:ca92:b0:189:a2d4:7f5 with SMTP id
 v18-20020a170902ca9200b00189a2d407f5mr42517471pld.23.1670898972154; Mon, 12
 Dec 2022 18:36:12 -0800 (PST)
Date:   Mon, 12 Dec 2022 18:35:53 -0800
In-Reply-To: <20221213023605.737383-1-sdf@google.com>
Mime-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213023605.737383-4-sdf@google.com>
Subject: [PATCH bpf-next v4 03/15] bpf: Introduce device-bound XDP programs
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

Also moved a bunch of code around to avoid forward declarations.

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
 drivers/net/netdevsim/bpf.c    |   4 -
 include/linux/bpf.h            |  24 ++-
 include/uapi/linux/bpf.h       |   5 +
 kernel/bpf/core.c              |   4 +-
 kernel/bpf/offload.c           | 293 ++++++++++++++++++++-------------
 kernel/bpf/syscall.c           |   9 +-
 net/core/dev.c                 |   5 +
 tools/include/uapi/linux/bpf.h |   5 +
 8 files changed, 218 insertions(+), 131 deletions(-)

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
index f8d3a93703f3..ca22e8b8bd82 100644
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
index 464ca3f01fe7..fa28603a48e7 100644
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
index 641ab412ad7e..d434a994ee04 100644
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
index f5769a8ecbee..f714c941f8ea 100644
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
@@ -56,7 +56,6 @@ static const struct rhashtable_params offdevs_params = {
 };
 
 static struct rhashtable offdevs;
-static bool offdevs_inited;
 
 static int bpf_dev_offload_check(struct net_device *netdev)
 {
@@ -72,12 +71,124 @@ bpf_offload_find_netdev(struct net_device *netdev)
 {
 	lockdep_assert_held(&bpf_devs_lock);
 
-	if (!offdevs_inited)
-		return NULL;
 	return rhashtable_lookup_fast(&offdevs, &netdev, offdevs_params);
 }
 
-int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
+static int __bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
+					     struct net_device *netdev)
+{
+	struct bpf_offload_netdev *ondev;
+	int err;
+
+	ondev = kzalloc(sizeof(*ondev), GFP_KERNEL);
+	if (!ondev)
+		return -ENOMEM;
+
+	ondev->netdev = netdev;
+	ondev->offdev = offdev;
+	INIT_LIST_HEAD(&ondev->progs);
+	INIT_LIST_HEAD(&ondev->maps);
+
+	err = rhashtable_insert_fast(&offdevs, &ondev->l, offdevs_params);
+	if (err) {
+		netdev_warn(netdev, "failed to register for BPF offload\n");
+		goto err_unlock_free;
+	}
+
+	if (offdev)
+		list_add(&ondev->offdev_netdevs, &offdev->netdevs);
+	return 0;
+
+err_unlock_free:
+	up_write(&bpf_devs_lock);
+	kfree(ondev);
+	return err;
+}
+
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
+	list_del_init(&offload->offloads);
+	kfree(offload);
+	prog->aux->offload = NULL;
+}
+
+static int bpf_map_offload_ndo(struct bpf_offloaded_map *offmap,
+			       enum bpf_netdev_command cmd)
+{
+	struct netdev_bpf data = {};
+	struct net_device *netdev;
+
+	ASSERT_RTNL();
+
+	data.command = cmd;
+	data.offmap = offmap;
+	/* Caller must make sure netdev is valid */
+	netdev = offmap->netdev;
+
+	return netdev->netdev_ops->ndo_bpf(netdev, &data);
+}
+
+static void __bpf_map_offload_destroy(struct bpf_offloaded_map *offmap)
+{
+	WARN_ON(bpf_map_offload_ndo(offmap, BPF_OFFLOAD_MAP_FREE));
+	/* Make sure BPF_MAP_GET_NEXT_ID can't find this dead map */
+	bpf_map_free_id(&offmap->map, true);
+	list_del_init(&offmap->offloads);
+	offmap->netdev = NULL;
+}
+
+static void __bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
+						struct net_device *netdev)
+{
+	struct bpf_offload_netdev *ondev, *altdev = NULL;
+	struct bpf_offloaded_map *offmap, *mtmp;
+	struct bpf_prog_offload *offload, *ptmp;
+
+	ASSERT_RTNL();
+
+	ondev = rhashtable_lookup_fast(&offdevs, &netdev, offdevs_params);
+	if (WARN_ON(!ondev))
+		return;
+
+	WARN_ON(rhashtable_remove_fast(&offdevs, &ondev->l, offdevs_params));
+
+	/* Try to move the objects to another netdev of the device */
+	if (offdev) {
+		list_del(&ondev->offdev_netdevs);
+		altdev = list_first_entry_or_null(&offdev->netdevs,
+						  struct bpf_offload_netdev,
+						  offdev_netdevs);
+	}
+
+	if (altdev) {
+		list_for_each_entry(offload, &ondev->progs, offloads)
+			offload->netdev = altdev->netdev;
+		list_splice_init(&ondev->progs, &altdev->progs);
+
+		list_for_each_entry(offmap, &ondev->maps, offloads)
+			offmap->netdev = altdev->netdev;
+		list_splice_init(&ondev->maps, &altdev->maps);
+	} else {
+		list_for_each_entry_safe(offload, ptmp, &ondev->progs, offloads)
+			__bpf_prog_dev_bound_destroy(offload->prog);
+		list_for_each_entry_safe(offmap, mtmp, &ondev->maps, offloads)
+			__bpf_map_offload_destroy(offmap);
+	}
+
+	WARN_ON(!list_empty(&ondev->progs));
+	WARN_ON(!list_empty(&ondev->maps));
+	kfree(ondev);
+}
+
+int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr)
 {
 	struct bpf_offload_netdev *ondev;
 	struct bpf_prog_offload *offload;
@@ -87,7 +198,7 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
 	    attr->prog_type != BPF_PROG_TYPE_XDP)
 		return -EINVAL;
 
-	if (attr->prog_flags)
+	if (attr->prog_flags & ~BPF_F_XDP_DEV_BOUND_ONLY)
 		return -EINVAL;
 
 	offload = kzalloc(sizeof(*offload), GFP_USER);
@@ -102,11 +213,25 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
 	if (err)
 		goto err_maybe_put;
 
+	prog->aux->offload_requested = !(attr->prog_flags & BPF_F_XDP_DEV_BOUND_ONLY);
+
 	down_write(&bpf_devs_lock);
 	ondev = bpf_offload_find_netdev(offload->netdev);
 	if (!ondev) {
-		err = -EINVAL;
-		goto err_unlock;
+		if (!bpf_prog_is_offloaded(prog->aux)) {
+			/* When only binding to the device, explicitly
+			 * create an entry in the hashtable. See related
+			 * bpf_dev_bound_try_remove_netdev.
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
@@ -209,27 +334,28 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
 	up_read(&bpf_devs_lock);
 }
 
-static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
+static void bpf_dev_bound_try_remove_netdev(struct net_device *dev)
 {
-	struct bpf_prog_offload *offload = prog->aux->offload;
-
-	if (offload->dev_state)
-		offload->offdev->ops->destroy(prog);
+	struct bpf_offload_netdev *ondev;
 
-	/* Make sure BPF_PROG_GET_NEXT_ID can't find this dead program */
-	bpf_prog_free_id(prog, true);
+	if (!dev)
+		return;
 
-	list_del_init(&offload->offloads);
-	kfree(offload);
-	prog->aux->offload = NULL;
+	ondev = bpf_offload_find_netdev(dev);
+	if (ondev && !ondev->offdev && list_empty(&ondev->progs))
+		__bpf_offload_dev_netdev_unregister(NULL, dev);
 }
 
-void bpf_prog_offload_destroy(struct bpf_prog *prog)
+void bpf_prog_dev_bound_destroy(struct bpf_prog *prog)
 {
+	rtnl_lock();
 	down_write(&bpf_devs_lock);
-	if (prog->aux->offload)
-		__bpf_prog_offload_destroy(prog);
+	if (prog->aux->offload) {
+		bpf_dev_bound_try_remove_netdev(prog->aux->offload->netdev);
+		__bpf_prog_dev_bound_destroy(prog);
+	}
 	up_write(&bpf_devs_lock);
+	rtnl_unlock();
 }
 
 static int bpf_prog_offload_translate(struct bpf_prog *prog)
@@ -343,22 +469,6 @@ int bpf_prog_offload_info_fill(struct bpf_prog_info *info,
 const struct bpf_prog_ops bpf_offload_prog_ops = {
 };
 
-static int bpf_map_offload_ndo(struct bpf_offloaded_map *offmap,
-			       enum bpf_netdev_command cmd)
-{
-	struct netdev_bpf data = {};
-	struct net_device *netdev;
-
-	ASSERT_RTNL();
-
-	data.command = cmd;
-	data.offmap = offmap;
-	/* Caller must make sure netdev is valid */
-	netdev = offmap->netdev;
-
-	return netdev->netdev_ops->ndo_bpf(netdev, &data);
-}
-
 struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
 {
 	struct net *net = current->nsproxy->net_ns;
@@ -408,15 +518,6 @@ struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
 	return ERR_PTR(err);
 }
 
-static void __bpf_map_offload_destroy(struct bpf_offloaded_map *offmap)
-{
-	WARN_ON(bpf_map_offload_ndo(offmap, BPF_OFFLOAD_MAP_FREE));
-	/* Make sure BPF_MAP_GET_NEXT_ID can't find this dead map */
-	bpf_map_free_id(&offmap->map, true);
-	list_del_init(&offmap->offloads);
-	offmap->netdev = NULL;
-}
-
 void bpf_map_offload_map_free(struct bpf_map *map)
 {
 	struct bpf_offloaded_map *offmap = map_to_offmap(map);
@@ -549,7 +650,7 @@ static bool __bpf_offload_dev_match(struct bpf_prog *prog,
 	struct bpf_offload_netdev *ondev1, *ondev2;
 	struct bpf_prog_offload *offload;
 
-	if (!bpf_prog_is_offloaded(prog->aux))
+	if (!bpf_prog_is_dev_bound(prog->aux))
 		return false;
 
 	offload = prog->aux->offload;
@@ -595,32 +696,11 @@ bool bpf_offload_prog_map_match(struct bpf_prog *prog, struct bpf_map *map)
 int bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
 				    struct net_device *netdev)
 {
-	struct bpf_offload_netdev *ondev;
 	int err;
 
-	ondev = kzalloc(sizeof(*ondev), GFP_KERNEL);
-	if (!ondev)
-		return -ENOMEM;
-
-	ondev->netdev = netdev;
-	ondev->offdev = offdev;
-	INIT_LIST_HEAD(&ondev->progs);
-	INIT_LIST_HEAD(&ondev->maps);
-
 	down_write(&bpf_devs_lock);
-	err = rhashtable_insert_fast(&offdevs, &ondev->l, offdevs_params);
-	if (err) {
-		netdev_warn(netdev, "failed to register for BPF offload\n");
-		goto err_unlock_free;
-	}
-
-	list_add(&ondev->offdev_netdevs, &offdev->netdevs);
-	up_write(&bpf_devs_lock);
-	return 0;
-
-err_unlock_free:
+	err = __bpf_offload_dev_netdev_register(offdev, netdev);
 	up_write(&bpf_devs_lock);
-	kfree(ondev);
 	return err;
 }
 EXPORT_SYMBOL_GPL(bpf_offload_dev_netdev_register);
@@ -628,43 +708,8 @@ EXPORT_SYMBOL_GPL(bpf_offload_dev_netdev_register);
 void bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
 				       struct net_device *netdev)
 {
-	struct bpf_offload_netdev *ondev, *altdev;
-	struct bpf_offloaded_map *offmap, *mtmp;
-	struct bpf_prog_offload *offload, *ptmp;
-
-	ASSERT_RTNL();
-
 	down_write(&bpf_devs_lock);
-	ondev = rhashtable_lookup_fast(&offdevs, &netdev, offdevs_params);
-	if (WARN_ON(!ondev))
-		goto unlock;
-
-	WARN_ON(rhashtable_remove_fast(&offdevs, &ondev->l, offdevs_params));
-	list_del(&ondev->offdev_netdevs);
-
-	/* Try to move the objects to another netdev of the device */
-	altdev = list_first_entry_or_null(&offdev->netdevs,
-					  struct bpf_offload_netdev,
-					  offdev_netdevs);
-	if (altdev) {
-		list_for_each_entry(offload, &ondev->progs, offloads)
-			offload->netdev = altdev->netdev;
-		list_splice_init(&ondev->progs, &altdev->progs);
-
-		list_for_each_entry(offmap, &ondev->maps, offloads)
-			offmap->netdev = altdev->netdev;
-		list_splice_init(&ondev->maps, &altdev->maps);
-	} else {
-		list_for_each_entry_safe(offload, ptmp, &ondev->progs, offloads)
-			__bpf_prog_offload_destroy(offload->prog);
-		list_for_each_entry_safe(offmap, mtmp, &ondev->maps, offloads)
-			__bpf_map_offload_destroy(offmap);
-	}
-
-	WARN_ON(!list_empty(&ondev->progs));
-	WARN_ON(!list_empty(&ondev->maps));
-	kfree(ondev);
-unlock:
+	__bpf_offload_dev_netdev_unregister(offdev, netdev);
 	up_write(&bpf_devs_lock);
 }
 EXPORT_SYMBOL_GPL(bpf_offload_dev_netdev_unregister);
@@ -673,18 +718,6 @@ struct bpf_offload_dev *
 bpf_offload_dev_create(const struct bpf_prog_offload_ops *ops, void *priv)
 {
 	struct bpf_offload_dev *offdev;
-	int err;
-
-	down_write(&bpf_devs_lock);
-	if (!offdevs_inited) {
-		err = rhashtable_init(&offdevs, &offdevs_params);
-		if (err) {
-			up_write(&bpf_devs_lock);
-			return ERR_PTR(err);
-		}
-		offdevs_inited = true;
-	}
-	up_write(&bpf_devs_lock);
 
 	offdev = kzalloc(sizeof(*offdev), GFP_KERNEL);
 	if (!offdev)
@@ -710,3 +743,29 @@ void *bpf_offload_dev_priv(struct bpf_offload_dev *offdev)
 	return offdev->priv;
 }
 EXPORT_SYMBOL_GPL(bpf_offload_dev_priv);
+
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
+static int __init bpf_offload_init(void)
+{
+	int err;
+
+	down_write(&bpf_devs_lock);
+	err = rhashtable_init(&offdevs, &offdevs_params);
+	up_write(&bpf_devs_lock);
+
+	return err;
+}
+
+late_initcall(bpf_offload_init);
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
index 5d51999cba30..194f8116aad4 100644
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
@@ -10813,6 +10817,7 @@ void unregister_netdevice_many_notify(struct list_head *head,
 		/* Shutdown queueing discipline. */
 		dev_shutdown(dev);
 
+		bpf_dev_bound_netdev_unregister(dev);
 		dev_xdp_uninstall(dev);
 
 		netdev_offload_xstats_disable_all(dev);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 464ca3f01fe7..fa28603a48e7 100644
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
2.39.0.rc1.256.g54fd8350bd-goog

