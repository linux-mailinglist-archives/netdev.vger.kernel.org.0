Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC53C3B0DED
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhFVT7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbhFVT7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 15:59:39 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD10C061574;
        Tue, 22 Jun 2021 12:57:22 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id a2so671960pgi.6;
        Tue, 22 Jun 2021 12:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2M+/jke7oI/v1bHKeQ1t1eI5gEmwcggeXPdID1191qU=;
        b=teWAd6YuPkd333afwFpTpH0QbS2uOehze7j9VxgKDhHdO1tpcV22V4zREcUyGo1iOU
         rV0oAKdAIbZQA8qMUGSp5tYx8+kQDC7XvkfdFG3hLHDajWfaxb6inM7aNI4kAYEF6QSC
         m77FcJmv1NDBrlsTOHPtPiVxKZPQ2G+Pj3RebL3L39ajb4kxKBSkhjlzF5+y/MOiVlFA
         4Ty9IbFoCAl/6070xER/mqDh56UF10fuDBdHjuxc5ExDoQ8oOxzhyPqbDv01aE4dkunu
         7F/P5zp321rJVLzY1NudaFtLkJuQrzkyI1VV8vtY3TmaSY2YaOf9Y3RaqcQKxwc7Z+rs
         5UOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2M+/jke7oI/v1bHKeQ1t1eI5gEmwcggeXPdID1191qU=;
        b=sx/8cP3jlqw6j48CPMgBBzHWVCg/7IGHKpjFoBaqI0t8+7t9LmYHAZGZRAO/OQE2Ij
         TPpfhKzQGIv9he/ricjq/jkh8QKOopUwm+C88nzWGdYROG/QoksvUm/fXdYRzlFAi8W7
         vKkh34DR57PFSsnKM2P4ID006kIgTCbBx5FcIg4q+/XgOX0hM7RuTXqXc4uU9fV/T7pr
         ZyXDNI5oiC2pYhWDhfusfkLpOaimYEG7JdN9TGFGy3Ii47XbU7b11IrrAely+Y30exp1
         E4qAhGzqin9fb4VuTlkZzhNY/GCWhpELa6EiWIwa02tPu4g6FfEPBFKNdeQjnOPd44p5
         maUg==
X-Gm-Message-State: AOAM5316DqHptYBd2zUAtmAsqgxN7SZ+uKS8iNRRvbN42CVn0ifIlT6i
        pAMVmpFv91xNsr0K1ASsAQfsZfpr2gA=
X-Google-Smtp-Source: ABdhPJxuGUAnvy+Dg+4LAsJz1+8jVMJPJvXg30/RguGRkv7I72e7VAFrc+fxXp8n12ZBi01cUM9oYQ==
X-Received: by 2002:a65:520a:: with SMTP id o10mr334564pgp.172.1624391841788;
        Tue, 22 Jun 2021 12:57:21 -0700 (PDT)
Received: from localhost ([2402:3a80:11bb:33b3:7f0c:3646:8bde:417e])
        by smtp.gmail.com with ESMTPSA id z6sm20829937pgs.24.2021.06.22.12.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 12:57:21 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v2 4/5] bpf: devmap: implement devmap prog execution for generic XDP
Date:   Wed, 23 Jun 2021 01:25:26 +0530
Message-Id: <20210622195527.1110497-5-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622195527.1110497-1-memxor@gmail.com>
References: <20210622195527.1110497-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This lifts the restriction on running devmap BPF progs in generic
redirect mode. To match native XDP behavior, it is invoked right before
generic_xdp_tx is called, and only supports XDP_PASS/XDP_ABORTED/
XDP_DROP actions.

We also return 0 even if devmap program drops the packet, as
semantically redirect has already succeeded and the devmap prog is the
last point before TX of the packet to device where it can deliver a
verdict on the packet.

This also means it must take care of freeing the skb, as
xdp_do_generic_redirect callers only do that in case an error is
returned.

Since devmap entry prog is supported, remove the check in
generic_xdp_install entirely.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h |  1 -
 kernel/bpf/devmap.c | 49 ++++++++++++++++++++++++++++++++++++---------
 net/core/dev.c      | 18 -----------------
 3 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 095aaa104c56..4afbff308ca3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1508,7 +1508,6 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
 			   struct bpf_prog *xdp_prog, struct bpf_map *map,
 			   bool exclude_ingress);
-bool dev_map_can_have_prog(struct bpf_map *map);
 
 void __cpu_map_flush(void);
 int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 2a75e6c2d27d..49f03e8e5561 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -318,16 +318,6 @@ static int dev_map_hash_get_next_key(struct bpf_map *map, void *key,
 	return -ENOENT;
 }
 
-bool dev_map_can_have_prog(struct bpf_map *map)
-{
-	if ((map->map_type == BPF_MAP_TYPE_DEVMAP ||
-	     map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) &&
-	    map->value_size != offsetofend(struct bpf_devmap_val, ifindex))
-		return true;
-
-	return false;
-}
-
 static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
 				struct xdp_frame **frames, int n,
 				struct net_device *dev)
@@ -499,6 +489,37 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 	return 0;
 }
 
+static u32 dev_map_bpf_prog_run_skb(struct sk_buff *skb, struct bpf_dtab_netdev *dst)
+{
+	struct xdp_txq_info txq = { .dev = dst->dev };
+	struct xdp_buff xdp;
+	u32 act;
+
+	if (!dst->xdp_prog)
+		return XDP_PASS;
+
+	__skb_pull(skb, skb->mac_len);
+	xdp.txq = &txq;
+
+	act = bpf_prog_run_generic_xdp(skb, &xdp, dst->xdp_prog);
+	switch (act) {
+	case XDP_PASS:
+		__skb_push(skb, skb->mac_len);
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(dst->dev, dst->xdp_prog, act);
+		fallthrough;
+	case XDP_DROP:
+		kfree_skb(skb);
+		break;
+	}
+
+	return act;
+}
+
 int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 		    struct net_device *dev_rx)
 {
@@ -614,6 +635,14 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 	err = xdp_ok_fwd_dev(dst->dev, skb->len);
 	if (unlikely(err))
 		return err;
+
+	/* Redirect has already succeeded semantically at this point, so we just
+	 * return 0 even if packet is dropped. Helper below takes care of
+	 * freeing skb.
+	 */
+	if (dev_map_bpf_prog_run_skb(skb, dst) != XDP_PASS)
+		return 0;
+
 	skb->dev = dst->dev;
 	generic_xdp_tx(skb, xdp_prog);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index a00421e9ee16..9d9c78496459 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5633,24 +5633,6 @@ static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 	struct bpf_prog *new = xdp->prog;
 	int ret = 0;
 
-	if (new) {
-		u32 i;
-
-		mutex_lock(&new->aux->used_maps_mutex);
-
-		/* generic XDP does not work with DEVMAPs that can
-		 * have a bpf_prog installed on an entry
-		 */
-		for (i = 0; i < new->aux->used_map_cnt; i++) {
-			if (dev_map_can_have_prog(new->aux->used_maps[i])) {
-				mutex_unlock(&new->aux->used_maps_mutex);
-				return -EINVAL;
-			}
-		}
-
-		mutex_unlock(&new->aux->used_maps_mutex);
-	}
-
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		rcu_assign_pointer(dev->xdp_prog, new);
-- 
2.31.1

