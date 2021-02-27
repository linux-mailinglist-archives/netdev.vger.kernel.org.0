Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0E0326D05
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 13:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhB0MWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 07:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhB0MWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 07:22:30 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E89C061786;
        Sat, 27 Feb 2021 04:21:49 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id p21so17922231lfu.11;
        Sat, 27 Feb 2021 04:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Woa7oUX5oIkrU1yvaVL2vgFdjRwSscWOqFjYb9ZHmw=;
        b=Kt2kMuwBowqYNCqltyQImn8d9i86ZhBhS3tue+B7uPRrzMpCOKqlUjrf7ueULjD2UG
         h1nudkR1vV+Zu+kjnXvfVHCES3c0owVhAFP6lCNLtw0pWiHWTqODQfdMu41zQkRXEpMp
         hgn/H8rCSnfaqUkQBClbedaqJSJ+nS371SDnqhh6rQjdOgbL61OL4/eMrEjyXA/S+f65
         rKKlp2DzqFYWSHO9Y1HgfBEE6nS5GA/FtIgjACgzAkwgA66oAh9AP4otdGw+gqHMTk+K
         WdTnfAVH9IC+KHRnE7y1yW050z2CQ26YxXAmcGR4ilr20ys7Sm69ASQztsSxuSqsPHCN
         mmIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Woa7oUX5oIkrU1yvaVL2vgFdjRwSscWOqFjYb9ZHmw=;
        b=FbB09iufCLFXU6MIDnv0kuG4o2I97bmjA0H3x3KxYHTPBiYTUN075xJzE8OW+Pg+FG
         1DDZ26eGWsdU2mS++F8O5+CjdF/X+hVWoZ5ot2RpX0ynpqWFbfUsIQuNY+Hc3amjMKfA
         kM2oMDScJLWt8eQNcoYUqCBp4rF4VKxHQaz7+TMQdO0fgc07Blv9enRBPb5muvIP+dVx
         s+gOwC01HnT5PZ2fhppkyiEK0RbA603MMjTFA/B2YLOKfZnZqgvWCFMIo6XGmFiHehKL
         MLwLibzQF1wOApLD4Y0Nfo1aR6YPlRq1dD7cyqutNh+BMgo8J+XuiCu0XxNPQ98UJalk
         tVuw==
X-Gm-Message-State: AOAM533hQ+I2EpLbsACoiCgl1NOiZKIVMc29ZiOT+UVNaX/YMWP9j4aG
        gKWhLcpquVPVFh9wG/gz1x8hLJWNglUMDA==
X-Google-Smtp-Source: ABdhPJw9cHVF/NfF+8sIcDOma/qUpvSvjbvsb0pm/PUbZZZjnVPduQEtcTo8AaZ6clcZ3infELj+YA==
X-Received: by 2002:ac2:53a1:: with SMTP id j1mr4446600lfh.298.1614428508130;
        Sat, 27 Feb 2021 04:21:48 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id u14sm1738091lfl.40.2021.02.27.04.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Feb 2021 04:21:47 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maciej.fijalkowski@intel.com, hawk@kernel.org, toke@redhat.com,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH bpf-next v5 2/2] bpf, xdp: restructure redirect actions
Date:   Sat, 27 Feb 2021 13:21:39 +0100
Message-Id: <20210227122139.183284-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210227122139.183284-1-bjorn.topel@gmail.com>
References: <20210227122139.183284-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The XDP_REDIRECT implementations for maps and non-maps are fairly
similar, but obviously need to take different code paths depending on
if the target is using a map or not. Today, the redirect targets for
XDP either uses a map, or is based on ifindex.

Here, an explicit redirect type is added to bpf_redirect_info, instead
of the actual map. Redirect type, map item/ifindex, and the map_id (if
any) is passed to xdp_do_redirect().

In addition to making the code easier to follow, using an explicit
type in bpf_redirect_info has a slight positive performance impact by
avoiding a pointer indirection for the map type lookup, and instead
use the cacheline for bpf_redirect_info.

Since the actual map is not passed via bpf_redirect_info anymore, the
map lookup is only done in the BPF helper. This means that the
bpf_clear_redirect_map() function can be removed. The actual map item
is RCU protected.

The bpf_redirect_info flags member is not used by XDP, and not
read/written any more. The map member is only written to when
required/used, and not unconditionally.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/filter.h     |  20 ++++--
 include/trace/events/xdp.h |  66 ++++++++++-------
 kernel/bpf/cpumap.c        |   4 +-
 kernel/bpf/devmap.c        |   7 +-
 net/core/filter.c          | 144 +++++++++++++++----------------------
 net/xdp/xskmap.c           |   4 +-
 6 files changed, 121 insertions(+), 124 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 008691fd3b58..a7752badc2ec 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -646,11 +646,20 @@ struct bpf_redirect_info {
 	u32 flags;
 	u32 tgt_index;
 	void *tgt_value;
-	struct bpf_map *map;
+	u32 map_id;
+	u32 tgt_type;
 	u32 kern_flags;
 	struct bpf_nh_params nh;
 };
 
+enum xdp_redirect_type {
+	XDP_REDIR_UNSET,
+	XDP_REDIR_DEV_IFINDEX,
+	XDP_REDIR_DEV_MAP,
+	XDP_REDIR_CPU_MAP,
+	XDP_REDIR_XSK_MAP,
+};
+
 DECLARE_PER_CPU(struct bpf_redirect_info, bpf_redirect_info);
 
 /* flags for bpf_redirect_info kern_flags */
@@ -1473,7 +1482,8 @@ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 
 static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex, u64 flags,
-						  void *lookup_elem(struct bpf_map *map, u32 key))
+						  void *lookup_elem(struct bpf_map *map, u32 key),
+						  enum xdp_redirect_type type)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 
@@ -1488,13 +1498,13 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
 		 * performs multiple lookups, the last one always takes
 		 * precedence.
 		 */
-		WRITE_ONCE(ri->map, NULL);
+		ri->tgt_type = XDP_REDIR_UNSET;
 		return flags;
 	}
 
-	ri->flags = flags;
 	ri->tgt_index = ifindex;
-	WRITE_ONCE(ri->map, map);
+	ri->tgt_type = type;
+	ri->map_id = map->id;
 
 	return XDP_REDIRECT;
 }
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index 76a97176ab81..538321735447 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -86,19 +86,15 @@ struct _bpf_dtab_netdev {
 };
 #endif /* __DEVMAP_OBJ_TYPE */
 
-#define devmap_ifindex(tgt, map)				\
-	(((map->map_type == BPF_MAP_TYPE_DEVMAP ||	\
-		  map->map_type == BPF_MAP_TYPE_DEVMAP_HASH)) ? \
-	  ((struct _bpf_dtab_netdev *)tgt)->dev->ifindex : 0)
-
 DECLARE_EVENT_CLASS(xdp_redirect_template,
 
 	TP_PROTO(const struct net_device *dev,
 		 const struct bpf_prog *xdp,
 		 const void *tgt, int err,
-		 const struct bpf_map *map, u32 index),
+		 enum xdp_redirect_type type,
+		 const struct bpf_redirect_info *ri),
 
-	TP_ARGS(dev, xdp, tgt, err, map, index),
+	TP_ARGS(dev, xdp, tgt, err, type, ri),
 
 	TP_STRUCT__entry(
 		__field(int, prog_id)
@@ -111,14 +107,30 @@ DECLARE_EVENT_CLASS(xdp_redirect_template,
 	),
 
 	TP_fast_assign(
+		u32 ifindex = 0, map_id = 0, index = ri->tgt_index;
+
+		switch (type) {
+		case XDP_REDIR_DEV_MAP:
+			ifindex = ((struct _bpf_dtab_netdev *)tgt)->dev->ifindex;
+			fallthrough;
+		case XDP_REDIR_CPU_MAP:
+		case XDP_REDIR_XSK_MAP:
+			map_id = ri->map_id;
+			break;
+		case XDP_REDIR_DEV_IFINDEX:
+			ifindex = (u32)(long)tgt;
+			break;
+		default:
+			break;
+		}
+
 		__entry->prog_id	= xdp->aux->id;
 		__entry->act		= XDP_REDIRECT;
 		__entry->ifindex	= dev->ifindex;
 		__entry->err		= err;
-		__entry->to_ifindex	= map ? devmap_ifindex(tgt, map) :
-						index;
-		__entry->map_id		= map ? map->id : 0;
-		__entry->map_index	= map ? index : 0;
+		__entry->to_ifindex	= ifindex;
+		__entry->map_id		= map_id;
+		__entry->map_index	= index;
 	),
 
 	TP_printk("prog_id=%d action=%s ifindex=%d to_ifindex=%d err=%d"
@@ -133,45 +145,49 @@ DEFINE_EVENT(xdp_redirect_template, xdp_redirect,
 	TP_PROTO(const struct net_device *dev,
 		 const struct bpf_prog *xdp,
 		 const void *tgt, int err,
-		 const struct bpf_map *map, u32 index),
-	TP_ARGS(dev, xdp, tgt, err, map, index)
+		 enum xdp_redirect_type type,
+		 const struct bpf_redirect_info *ri),
+	TP_ARGS(dev, xdp, tgt, err, type, ri)
 );
 
 DEFINE_EVENT(xdp_redirect_template, xdp_redirect_err,
 	TP_PROTO(const struct net_device *dev,
 		 const struct bpf_prog *xdp,
 		 const void *tgt, int err,
-		 const struct bpf_map *map, u32 index),
-	TP_ARGS(dev, xdp, tgt, err, map, index)
+		 enum xdp_redirect_type type,
+		 const struct bpf_redirect_info *ri),
+	TP_ARGS(dev, xdp, tgt, err, type, ri)
 );
 
 #define _trace_xdp_redirect(dev, xdp, to)				\
-	 trace_xdp_redirect(dev, xdp, NULL, 0, NULL, to)
+	trace_xdp_redirect(dev, xdp, NULL, 0, XDP_REDIR_DEV_IFINDEX, NULL)
 
 #define _trace_xdp_redirect_err(dev, xdp, to, err)			\
-	 trace_xdp_redirect_err(dev, xdp, NULL, err, NULL, to)
+	trace_xdp_redirect_err(dev, xdp, NULL, err, XDP_REDIR_DEV_IFINDEX, NULL)
 
-#define _trace_xdp_redirect_map(dev, xdp, to, map, index)		\
-	 trace_xdp_redirect(dev, xdp, to, 0, map, index)
+#define _trace_xdp_redirect_map(dev, xdp, to, type, ri)		\
+	trace_xdp_redirect(dev, xdp, to, 0, type, ri)
 
-#define _trace_xdp_redirect_map_err(dev, xdp, to, map, index, err)	\
-	 trace_xdp_redirect_err(dev, xdp, to, err, map, index)
+#define _trace_xdp_redirect_map_err(dev, xdp, to, type, ri, err)	\
+	trace_xdp_redirect_err(dev, xdp, to, err, type, ri)
 
 /* not used anymore, but kept around so as not to break old programs */
 DEFINE_EVENT(xdp_redirect_template, xdp_redirect_map,
 	TP_PROTO(const struct net_device *dev,
 		 const struct bpf_prog *xdp,
 		 const void *tgt, int err,
-		 const struct bpf_map *map, u32 index),
-	TP_ARGS(dev, xdp, tgt, err, map, index)
+		 enum xdp_redirect_type type,
+		 const struct bpf_redirect_info *ri),
+	TP_ARGS(dev, xdp, tgt, err, type, ri)
 );
 
 DEFINE_EVENT(xdp_redirect_template, xdp_redirect_map_err,
 	TP_PROTO(const struct net_device *dev,
 		 const struct bpf_prog *xdp,
 		 const void *tgt, int err,
-		 const struct bpf_map *map, u32 index),
-	TP_ARGS(dev, xdp, tgt, err, map, index)
+		 enum xdp_redirect_type type,
+		 const struct bpf_redirect_info *ri),
+	TP_ARGS(dev, xdp, tgt, err, type, ri)
 );
 
 TRACE_EVENT(xdp_cpumap_kthread,
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 7352d4160b7f..01b333e594d0 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -543,7 +543,6 @@ static void cpu_map_free(struct bpf_map *map)
 	 * complete.
 	 */
 
-	bpf_clear_redirect_map(map);
 	synchronize_rcu();
 
 	/* For cpu_map the remote CPUs can still be using the entries
@@ -602,7 +601,8 @@ static int cpu_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 
 static int cpu_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
 {
-	return __bpf_xdp_redirect_map(map, ifindex, flags, __cpu_map_lookup_elem);
+	return __bpf_xdp_redirect_map(map, ifindex, flags, __cpu_map_lookup_elem,
+				      XDP_REDIR_CPU_MAP);
 }
 
 static int cpu_map_btf_id;
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f7f42448259f..99f5670f7273 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -197,7 +197,6 @@ static void dev_map_free(struct bpf_map *map)
 	list_del_rcu(&dtab->list);
 	spin_unlock(&dev_map_lock);
 
-	bpf_clear_redirect_map(map);
 	synchronize_rcu();
 
 	/* Make sure prior __dev_map_entry_free() have completed. */
@@ -737,12 +736,14 @@ static int dev_map_hash_update_elem(struct bpf_map *map, void *key, void *value,
 
 static int dev_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
 {
-	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_lookup_elem);
+	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_lookup_elem,
+				      XDP_REDIR_DEV_MAP);
 }
 
 static int dev_hash_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
 {
-	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_hash_lookup_elem);
+	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_hash_lookup_elem,
+				      XDP_REDIR_DEV_MAP);
 }
 
 static int dev_map_btf_id;
diff --git a/net/core/filter.c b/net/core/filter.c
index 960299a3744f..cb6a6df3318b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3909,23 +3909,6 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
-static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
-			    struct bpf_map *map, struct xdp_buff *xdp)
-{
-	switch (map->map_type) {
-	case BPF_MAP_TYPE_DEVMAP:
-	case BPF_MAP_TYPE_DEVMAP_HASH:
-		return dev_map_enqueue(fwd, xdp, dev_rx);
-	case BPF_MAP_TYPE_CPUMAP:
-		return cpu_map_enqueue(fwd, xdp, dev_rx);
-	case BPF_MAP_TYPE_XSKMAP:
-		return __xsk_map_redirect(fwd, xdp);
-	default:
-		return -EBADRQC;
-	}
-	return 0;
-}
-
 void xdp_do_flush(void)
 {
 	__dev_flush();
@@ -3934,55 +3917,45 @@ void xdp_do_flush(void)
 }
 EXPORT_SYMBOL_GPL(xdp_do_flush);
 
-void bpf_clear_redirect_map(struct bpf_map *map)
-{
-	struct bpf_redirect_info *ri;
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		ri = per_cpu_ptr(&bpf_redirect_info, cpu);
-		/* Avoid polluting remote cacheline due to writes if
-		 * not needed. Once we pass this test, we need the
-		 * cmpxchg() to make sure it hasn't been changed in
-		 * the meantime by remote CPU.
-		 */
-		if (unlikely(READ_ONCE(ri->map) == map))
-			cmpxchg(&ri->map, map, NULL);
-	}
-}
-
 int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 		    struct bpf_prog *xdp_prog)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-	struct bpf_map *map = READ_ONCE(ri->map);
-	u32 index = ri->tgt_index;
+	enum xdp_redirect_type type = ri->tgt_type;
 	void *fwd = ri->tgt_value;
 	int err;
 
-	ri->tgt_index = 0;
-	ri->tgt_value = NULL;
-	WRITE_ONCE(ri->map, NULL);
+	ri->tgt_type = XDP_REDIR_UNSET;
 
-	if (unlikely(!map)) {
-		fwd = dev_get_by_index_rcu(dev_net(dev), index);
+	switch (type) {
+	case XDP_REDIR_DEV_IFINDEX:
+		fwd = dev_get_by_index_rcu(dev_net(dev), (u32)(long)fwd);
 		if (unlikely(!fwd)) {
 			err = -EINVAL;
-			goto err;
+			break;
 		}
-
 		err = dev_xdp_enqueue(fwd, xdp, dev);
-	} else {
-		err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
+		break;
+	case XDP_REDIR_DEV_MAP:
+		err = dev_map_enqueue(fwd, xdp, dev);
+		break;
+	case XDP_REDIR_CPU_MAP:
+		err = cpu_map_enqueue(fwd, xdp, dev);
+		break;
+	case XDP_REDIR_XSK_MAP:
+		err = __xsk_map_redirect(fwd, xdp);
+		break;
+	default:
+		err = -EBADRQC;
 	}
 
 	if (unlikely(err))
 		goto err;
 
-	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map, index);
+	_trace_xdp_redirect_map(dev, xdp_prog, fwd, type, ri);
 	return 0;
 err:
-	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map, index, err);
+	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, type, ri, err);
 	return err;
 }
 EXPORT_SYMBOL_GPL(xdp_do_redirect);
@@ -3991,41 +3964,37 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       struct sk_buff *skb,
 				       struct xdp_buff *xdp,
 				       struct bpf_prog *xdp_prog,
-				       struct bpf_map *map)
+				       void *fwd,
+				       enum xdp_redirect_type type)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-	u32 index = ri->tgt_index;
-	void *fwd = ri->tgt_value;
-	int err = 0;
-
-	ri->tgt_index = 0;
-	ri->tgt_value = NULL;
-	WRITE_ONCE(ri->map, NULL);
-
-	if (map->map_type == BPF_MAP_TYPE_DEVMAP ||
-	    map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
-		struct bpf_dtab_netdev *dst = fwd;
+	int err;
 
-		err = dev_map_generic_redirect(dst, skb, xdp_prog);
+	switch (type) {
+	case XDP_REDIR_DEV_MAP:
+		err = dev_map_generic_redirect(fwd, skb, xdp_prog);
 		if (unlikely(err))
 			goto err;
-	} else if (map->map_type == BPF_MAP_TYPE_XSKMAP) {
+		break;
+	case XDP_REDIR_XSK_MAP: {
 		struct xdp_sock *xs = fwd;
 
 		err = xsk_generic_rcv(xs, xdp);
 		if (err)
 			goto err;
 		consume_skb(skb);
-	} else {
+		break;
+	}
+	default:
 		/* TODO: Handle BPF_MAP_TYPE_CPUMAP */
 		err = -EBADRQC;
 		goto err;
 	}
 
-	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map, index);
+	_trace_xdp_redirect_map(dev, xdp_prog, fwd, type, ri);
 	return 0;
 err:
-	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map, index, err);
+	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, type, ri, err);
 	return err;
 }
 
@@ -4033,29 +4002,31 @@ int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
 			    struct xdp_buff *xdp, struct bpf_prog *xdp_prog)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-	struct bpf_map *map = READ_ONCE(ri->map);
-	u32 index = ri->tgt_index;
-	struct net_device *fwd;
+	enum xdp_redirect_type type = ri->tgt_type;
+	void *fwd = ri->tgt_value;
 	int err = 0;
 
-	if (map)
-		return xdp_do_generic_redirect_map(dev, skb, xdp, xdp_prog,
-						   map);
-	ri->tgt_index = 0;
-	fwd = dev_get_by_index_rcu(dev_net(dev), index);
-	if (unlikely(!fwd)) {
-		err = -EINVAL;
-		goto err;
-	}
+	ri->tgt_type = XDP_REDIR_UNSET;
+	ri->tgt_value = NULL;
 
-	err = xdp_ok_fwd_dev(fwd, skb->len);
-	if (unlikely(err))
-		goto err;
+	if (type == XDP_REDIR_DEV_IFINDEX) {
+		fwd = dev_get_by_index_rcu(dev_net(dev), (u32)(long)fwd);
+		if (unlikely(!fwd)) {
+			err = -EINVAL;
+			goto err;
+		}
 
-	skb->dev = fwd;
-	_trace_xdp_redirect(dev, xdp_prog, index);
-	generic_xdp_tx(skb, xdp_prog);
-	return 0;
+		err = xdp_ok_fwd_dev(fwd, skb->len);
+		if (unlikely(err))
+			goto err;
+
+		skb->dev = fwd;
+		_trace_xdp_redirect(dev, xdp_prog, index);
+		generic_xdp_tx(skb, xdp_prog);
+		return 0;
+	}
+
+	return xdp_do_generic_redirect_map(dev, skb, xdp, xdp_prog, fwd, type);
 err:
 	_trace_xdp_redirect_err(dev, xdp_prog, index, err);
 	return err;
@@ -4068,10 +4039,9 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
 	if (unlikely(flags))
 		return XDP_ABORTED;
 
-	ri->flags = flags;
-	ri->tgt_index = ifindex;
-	ri->tgt_value = NULL;
-	WRITE_ONCE(ri->map, NULL);
+	ri->tgt_type = XDP_REDIR_DEV_IFINDEX;
+	ri->tgt_index = 0;
+	ri->tgt_value = (void *)(long)ifindex;
 
 	return XDP_REDIRECT;
 }
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 711acb3636b3..2c58d88aa69d 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -87,7 +87,6 @@ static void xsk_map_free(struct bpf_map *map)
 {
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
 
-	bpf_clear_redirect_map(map);
 	synchronize_net();
 	bpf_map_area_free(m);
 }
@@ -229,7 +228,8 @@ static int xsk_map_delete_elem(struct bpf_map *map, void *key)
 
 static int xsk_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
 {
-	return __bpf_xdp_redirect_map(map, ifindex, flags, __xsk_map_lookup_elem);
+	return __bpf_xdp_redirect_map(map, ifindex, flags, __xsk_map_lookup_elem,
+				      XDP_REDIR_XSK_MAP);
 }
 
 void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
-- 
2.27.0

