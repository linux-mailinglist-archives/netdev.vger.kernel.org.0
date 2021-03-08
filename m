Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28867330C60
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 12:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhCHL31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 06:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbhCHL3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 06:29:18 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45E8C06174A;
        Mon,  8 Mar 2021 03:29:17 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id q25so20426699lfc.8;
        Mon, 08 Mar 2021 03:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A0+CNbSxReDBgDQHyQTUKFwQh9FQ920mq/fBldq3caw=;
        b=N4pOTbba7PSH3C1PZQoIrbKrcaRcLt0ZhHcw2/QRYw+YeJNukLvYZ3Sz3FZXJdYqLt
         6s6bCpWZ51vx1UrVk47XVQZHlufH7Mb8rFbxJ/jn7Ug/xvqcHyYDslIWiVNObLMPl6fs
         djcVodI9TrtUHs+wF0WNZvMSrKyZ7BUhzxXxCuGRKJ0IqrV68hOPrED6usSCUF8753tE
         UZJb257du8CmTVcipulNIQSmcltKRBwHjZJoFqI9AKne7Cw9trKgWvEKNgwIZQ+YhnUT
         j5P2lG040Q69yr9phM8MaPk3sRZM4N6VPwgFk2qUPoo6nzE9ZAdfUeuN1trlbbbKLHf8
         NCIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A0+CNbSxReDBgDQHyQTUKFwQh9FQ920mq/fBldq3caw=;
        b=uavC3iqIsk+p3B7FpEZI/3eCKsTTQ7pv1pMgwYOLPBJZY5yEo0hC0fSMw4qZueAimX
         PaHqiTrP4sNxdMDI3GHkgXyjIYZI1mu4AbA9lp08jhz40c9cBvTA0VlrmN9/4hQqAoLY
         uOzmFp6mRZtTc+zzeljLvr0pFOZD5DvP9OOGMiVZNY5Ph7jDVpTTh8dLNu+J+S9H6LyB
         G0LQDQHazG/nqyuk9FgiVwZocxqGu8AYvLGtMdSRos5oytoB5+n8jpwzu0jX5bqiuAAM
         fsJCDfLxUfsmJYkA0Ek5CIlQZ9hmMEdXkZzCqCQiYReGZLbMxTVWTA2mry55b/jkBHWL
         p3hQ==
X-Gm-Message-State: AOAM5337PnHd8A0Q14IQ/ua8Hcn95c/h1Suq5xWmVfDGoiw6OfDDooAA
        ySngKliXUdZ599bo+xPJ1ObytSgjLn34gA==
X-Google-Smtp-Source: ABdhPJw8kwe5RFE/PjEzV+k5w3cgw9j9Vwbpnp/FpA6LaRiYspXlgUwvMKe8k+z2IQq0gJPLKED21A==
X-Received: by 2002:a19:9144:: with SMTP id y4mr14528410lfj.219.1615202956293;
        Mon, 08 Mar 2021 03:29:16 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w23sm1456145lji.127.2021.03.08.03.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 03:29:15 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maciej.fijalkowski@intel.com, hawk@kernel.org, toke@redhat.com,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH bpf-next v6 2/2] bpf, xdp: restructure redirect actions
Date:   Mon,  8 Mar 2021 12:29:07 +0100
Message-Id: <20210308112907.559576-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210308112907.559576-1-bjorn.topel@gmail.com>
References: <20210308112907.559576-1-bjorn.topel@gmail.com>
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

Here, the map type and id are added to bpf_redirect_info, instead of
the actual map. Map type, map item/ifindex, and the map_id (if any) is
passed to xdp_do_redirect().

For ifindex-based redirect, used by the bpf_redirect() XDP BFP helper,
a special map type/id are used. Map type of UNSPEC together with map id
equal to INT_MAX has the special meaning of an ifindex based
redirect. Note that valid map ids are 1 inclusive, INT_MAX exclusive
([1,INT_MAX[).

In addition to making the code easier to follow, using explicit type
and id in bpf_redirect_info has a slight positive performance impact
by avoiding a pointer indirection for the map type lookup, and instead
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
 include/linux/filter.h     |  10 ++-
 include/trace/events/xdp.h |  62 ++++++++------
 kernel/bpf/cpumap.c        |   1 -
 kernel/bpf/devmap.c        |   1 -
 net/core/filter.c          | 170 ++++++++++++++++---------------------
 net/xdp/xskmap.c           |   1 -
 6 files changed, 116 insertions(+), 129 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 008691fd3b58..b2b85b2cad8e 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -646,7 +646,8 @@ struct bpf_redirect_info {
 	u32 flags;
 	u32 tgt_index;
 	void *tgt_value;
-	struct bpf_map *map;
+	u32 map_id;
+	enum bpf_map_type map_type;
 	u32 kern_flags;
 	struct bpf_nh_params nh;
 };
@@ -1488,13 +1489,14 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
 		 * performs multiple lookups, the last one always takes
 		 * precedence.
 		 */
-		WRITE_ONCE(ri->map, NULL);
+		ri->map_id = INT_MAX; /* Valid map id idr range: [1,INT_MAX[ */
+		ri->map_type = BPF_MAP_TYPE_UNSPEC;
 		return flags;
 	}
 
-	ri->flags = flags;
 	ri->tgt_index = ifindex;
-	WRITE_ONCE(ri->map, map);
+	ri->map_id = map->id;
+	ri->map_type = map->map_type;
 
 	return XDP_REDIRECT;
 }
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index 76a97176ab81..fcad3645a70b 100644
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
+		 enum bpf_map_type map_type,
+		 u32 map_id, u32 index),
 
-	TP_ARGS(dev, xdp, tgt, err, map, index),
+	TP_ARGS(dev, xdp, tgt, err, map_type, map_id, index),
 
 	TP_STRUCT__entry(
 		__field(int, prog_id)
@@ -111,14 +107,22 @@ DECLARE_EVENT_CLASS(xdp_redirect_template,
 	),
 
 	TP_fast_assign(
+		u32 ifindex = 0, map_index = index;
+
+		if (map_type == BPF_MAP_TYPE_DEVMAP || map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
+			ifindex = ((struct _bpf_dtab_netdev *)tgt)->dev->ifindex;
+		} else if (map_type == BPF_MAP_TYPE_UNSPEC && map_id == INT_MAX) {
+			ifindex = index;
+			map_index = 0;
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
+		__entry->map_index	= map_index;
 	),
 
 	TP_printk("prog_id=%d action=%s ifindex=%d to_ifindex=%d err=%d"
@@ -133,45 +137,49 @@ DEFINE_EVENT(xdp_redirect_template, xdp_redirect,
 	TP_PROTO(const struct net_device *dev,
 		 const struct bpf_prog *xdp,
 		 const void *tgt, int err,
-		 const struct bpf_map *map, u32 index),
-	TP_ARGS(dev, xdp, tgt, err, map, index)
+		 enum bpf_map_type map_type,
+		 u32 map_id, u32 index),
+	TP_ARGS(dev, xdp, tgt, err, map_type, map_id, index)
 );
 
 DEFINE_EVENT(xdp_redirect_template, xdp_redirect_err,
 	TP_PROTO(const struct net_device *dev,
 		 const struct bpf_prog *xdp,
 		 const void *tgt, int err,
-		 const struct bpf_map *map, u32 index),
-	TP_ARGS(dev, xdp, tgt, err, map, index)
+		 enum bpf_map_type map_type,
+		 u32 map_id, u32 index),
+	TP_ARGS(dev, xdp, tgt, err, map_type, map_id, index)
 );
 
-#define _trace_xdp_redirect(dev, xdp, to)				\
-	 trace_xdp_redirect(dev, xdp, NULL, 0, NULL, to)
+#define _trace_xdp_redirect(dev, xdp, to)						\
+	 trace_xdp_redirect(dev, xdp, NULL, 0, BPF_MAP_TYPE_UNSPEC, INT_MAX, to)
 
-#define _trace_xdp_redirect_err(dev, xdp, to, err)			\
-	 trace_xdp_redirect_err(dev, xdp, NULL, err, NULL, to)
+#define _trace_xdp_redirect_err(dev, xdp, to, err)					\
+	 trace_xdp_redirect_err(dev, xdp, NULL, err, BPF_MAP_TYPE_UNSPEC, INT_MAX, to)
 
-#define _trace_xdp_redirect_map(dev, xdp, to, map, index)		\
-	 trace_xdp_redirect(dev, xdp, to, 0, map, index)
+#define _trace_xdp_redirect_map(dev, xdp, to, map_type, map_id, index) \
+	 trace_xdp_redirect(dev, xdp, to, 0, map_type, map_id, index)
 
-#define _trace_xdp_redirect_map_err(dev, xdp, to, map, index, err)	\
-	 trace_xdp_redirect_err(dev, xdp, to, err, map, index)
+#define _trace_xdp_redirect_map_err(dev, xdp, to, map_type, map_id, index, err) \
+	 trace_xdp_redirect_err(dev, xdp, to, err, map_type, map_id, index)
 
 /* not used anymore, but kept around so as not to break old programs */
 DEFINE_EVENT(xdp_redirect_template, xdp_redirect_map,
 	TP_PROTO(const struct net_device *dev,
 		 const struct bpf_prog *xdp,
 		 const void *tgt, int err,
-		 const struct bpf_map *map, u32 index),
-	TP_ARGS(dev, xdp, tgt, err, map, index)
+		 enum bpf_map_type map_type,
+		 u32 map_id, u32 index),
+	TP_ARGS(dev, xdp, tgt, err, map_type, map_id, index)
 );
 
 DEFINE_EVENT(xdp_redirect_template, xdp_redirect_map_err,
 	TP_PROTO(const struct net_device *dev,
 		 const struct bpf_prog *xdp,
 		 const void *tgt, int err,
-		 const struct bpf_map *map, u32 index),
-	TP_ARGS(dev, xdp, tgt, err, map, index)
+		 enum bpf_map_type map_type,
+		 u32 map_id, u32 index),
+	TP_ARGS(dev, xdp, tgt, err, map_type, map_id, index)
 );
 
 TRACE_EVENT(xdp_cpumap_kthread,
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 7352d4160b7f..0cf2791d5099 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -543,7 +543,6 @@ static void cpu_map_free(struct bpf_map *map)
 	 * complete.
 	 */
 
-	bpf_clear_redirect_map(map);
 	synchronize_rcu();
 
 	/* For cpu_map the remote CPUs can still be using the entries
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f7f42448259f..7a5ad7331c3b 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -197,7 +197,6 @@ static void dev_map_free(struct bpf_map *map)
 	list_del_rcu(&dtab->list);
 	spin_unlock(&dev_map_lock);
 
-	bpf_clear_redirect_map(map);
 	synchronize_rcu();
 
 	/* Make sure prior __dev_map_entry_free() have completed. */
diff --git a/net/core/filter.c b/net/core/filter.c
index 183b0aa6b027..b6732000d8a2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3918,23 +3918,6 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
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
@@ -3943,55 +3926,52 @@ void xdp_do_flush(void)
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
+	enum bpf_map_type map_type = ri->map_type;
 	void *fwd = ri->tgt_value;
+	u32 map_id = ri->map_id;
 	int err;
 
-	ri->tgt_index = 0;
-	ri->tgt_value = NULL;
-	WRITE_ONCE(ri->map, NULL);
+	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
+	ri->map_type = BPF_MAP_TYPE_UNSPEC;
 
-	if (unlikely(!map)) {
-		fwd = dev_get_by_index_rcu(dev_net(dev), index);
-		if (unlikely(!fwd)) {
-			err = -EINVAL;
-			goto err;
+	switch (map_type) {
+	case BPF_MAP_TYPE_DEVMAP:
+		fallthrough;
+	case BPF_MAP_TYPE_DEVMAP_HASH:
+		err = dev_map_enqueue(fwd, xdp, dev);
+		break;
+	case BPF_MAP_TYPE_CPUMAP:
+		err = cpu_map_enqueue(fwd, xdp, dev);
+		break;
+	case BPF_MAP_TYPE_XSKMAP:
+		err = __xsk_map_redirect(fwd, xdp);
+		break;
+	case BPF_MAP_TYPE_UNSPEC:
+		if (map_id == INT_MAX) {
+			fwd = dev_get_by_index_rcu(dev_net(dev), ri->tgt_index);
+			if (unlikely(!fwd)) {
+				err = -EINVAL;
+				break;
+			}
+			err = dev_xdp_enqueue(fwd, xdp, dev);
+			break;
 		}
-
-		err = dev_xdp_enqueue(fwd, xdp, dev);
-	} else {
-		err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
+		fallthrough;
+	default:
+		err = -EBADRQC;
 	}
 
 	if (unlikely(err))
 		goto err;
 
-	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map, index);
+	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);
 	return 0;
 err:
-	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map, index, err);
+	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index, err);
 	return err;
 }
 EXPORT_SYMBOL_GPL(xdp_do_redirect);
@@ -4000,41 +3980,36 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       struct sk_buff *skb,
 				       struct xdp_buff *xdp,
 				       struct bpf_prog *xdp_prog,
-				       struct bpf_map *map)
+				       void *fwd,
+				       enum bpf_map_type map_type, u32 map_id)
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
+	switch (map_type) {
+	case BPF_MAP_TYPE_DEVMAP:
+		fallthrough;
+	case BPF_MAP_TYPE_DEVMAP_HASH:
+		err = dev_map_generic_redirect(fwd, skb, xdp_prog);
 		if (unlikely(err))
 			goto err;
-	} else if (map->map_type == BPF_MAP_TYPE_XSKMAP) {
-		struct xdp_sock *xs = fwd;
-
-		err = xsk_generic_rcv(xs, xdp);
+		break;
+	case BPF_MAP_TYPE_XSKMAP:
+		err = xsk_generic_rcv(fwd, xdp);
 		if (err)
 			goto err;
 		consume_skb(skb);
-	} else {
+		break;
+	default:
 		/* TODO: Handle BPF_MAP_TYPE_CPUMAP */
 		err = -EBADRQC;
 		goto err;
 	}
 
-	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map, index);
+	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);
 	return 0;
 err:
-	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map, index, err);
+	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index, err);
 	return err;
 }
 
@@ -4042,31 +4017,34 @@ int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
 			    struct xdp_buff *xdp, struct bpf_prog *xdp_prog)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-	struct bpf_map *map = READ_ONCE(ri->map);
-	u32 index = ri->tgt_index;
-	struct net_device *fwd;
-	int err = 0;
-
-	if (map)
-		return xdp_do_generic_redirect_map(dev, skb, xdp, xdp_prog,
-						   map);
-	ri->tgt_index = 0;
-	fwd = dev_get_by_index_rcu(dev_net(dev), index);
-	if (unlikely(!fwd)) {
-		err = -EINVAL;
-		goto err;
-	}
+	enum bpf_map_type map_type = ri->map_type;
+	void *fwd = ri->tgt_value;
+	u32 map_id = ri->map_id;
+	int err;
 
-	err = xdp_ok_fwd_dev(fwd, skb->len);
-	if (unlikely(err))
-		goto err;
+	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
+	ri->map_type = BPF_MAP_TYPE_UNSPEC;
 
-	skb->dev = fwd;
-	_trace_xdp_redirect(dev, xdp_prog, index);
-	generic_xdp_tx(skb, xdp_prog);
-	return 0;
+	if (map_type == BPF_MAP_TYPE_UNSPEC && map_id == INT_MAX) {
+		fwd = dev_get_by_index_rcu(dev_net(dev), ri->tgt_index);
+		if (unlikely(!fwd)) {
+			err = -EINVAL;
+			goto err;
+		}
+
+		err = xdp_ok_fwd_dev(fwd, skb->len);
+		if (unlikely(err))
+			goto err;
+
+		skb->dev = fwd;
+		_trace_xdp_redirect(dev, xdp_prog, ri->tgt_index);
+		generic_xdp_tx(skb, xdp_prog);
+		return 0;
+	}
+
+	return xdp_do_generic_redirect_map(dev, skb, xdp, xdp_prog, fwd, map_type, map_id);
 err:
-	_trace_xdp_redirect_err(dev, xdp_prog, index, err);
+	_trace_xdp_redirect_err(dev, xdp_prog, ri->tgt_index, err);
 	return err;
 }
 
@@ -4077,10 +4055,12 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
 	if (unlikely(flags))
 		return XDP_ABORTED;
 
-	ri->flags = flags;
+	/* NB! Map type UNSPEC and map_id == INT_MAX (never generated
+	 * by map_idr) is used for ifindex based XDP redirect.
+	 */
 	ri->tgt_index = ifindex;
-	ri->tgt_value = NULL;
-	WRITE_ONCE(ri->map, NULL);
+	ri->map_id = INT_MAX;
+	ri->map_type = BPF_MAP_TYPE_UNSPEC;
 
 	return XDP_REDIRECT;
 }
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index fbeb4870f798..67b4ce504852 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -87,7 +87,6 @@ static void xsk_map_free(struct bpf_map *map)
 {
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
 
-	bpf_clear_redirect_map(map);
 	synchronize_net();
 	bpf_map_area_free(m);
 }
-- 
2.27.0

