Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4D02FBB60
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391187AbhASPil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390832AbhASPhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:37:50 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC42C061575;
        Tue, 19 Jan 2021 07:37:10 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id h7so415505lfc.6;
        Tue, 19 Jan 2021 07:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i4w3bZuLfrJkmf9BkM/u7+HKCeUtJU84EklOrB2XMPI=;
        b=PBajJlrkZrjHFsq2TdWP88VM9M/OVzk2ypQu20/Q0wMgELBNkEPDI3EQORNIvF74PU
         kIFt47jqc8RfODLoniwrZHYtKU/dKDkpuqWG2lPgZHCWwSwGPg9rOq70FR64lLpo+tSz
         2npC7/husCLVPtuUv394avV9vP9oYfil4y4KjEQIQijVnVHgbl3wrcSFzsdmT3+pf41j
         iCxaJ0OMJ4z6enZZ/FkxPZ0Fy8/hNLZLZoKmoNRWxC2/FzQgM507GvqPNbmzgEFNH3fn
         U8xtSLQVi1i5/YRITDdPcnibS3zvI53+qT27VJ3S6UhITUUwpiejiJ1FDOjHXMYV8Mn4
         X25g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i4w3bZuLfrJkmf9BkM/u7+HKCeUtJU84EklOrB2XMPI=;
        b=ejMgLOdjXh3Xt1UbJ0V53nHDJWfvOoOmIzI0frp7ualOD5/RJLWjCV3pFup/2+A13p
         PTawzNHYC7MY4QqDIfnSoENiPp58fGMzRHyHqgT2Y19PzHKb2D7l7BHL7wtRzDCbcGgO
         UUZJeBpOCPSni/JKn/GINle+K9V8Wj6D+PxbW9V2JFc43p8AlNOxg3i0XUK2dBOwwi5V
         NEmUxtatheBIllyKoILn/Ptd8WdAKzHVyC6/1GGuUx5wUdOh2wV9NAQETRPGOpYuIC8y
         MPEukyxd0lI0fK9qWiJbTgvsCT41KLqAOcaARlljHMqRyCEM61JZyER6fly9tT84nBnI
         ZeGw==
X-Gm-Message-State: AOAM5307oJwvN/KDPlDGclU4tD2WshCMIH1D0VG2sH4aNrCmIDPhcvck
        u3NqAj0mKjD2KrnTf6jpnylO+BAFML83xQ==
X-Google-Smtp-Source: ABdhPJyefg83nhT+5S3clkof/5UuzOFgxk+ITucEPfi+MoRlLJWyAP6ks14pAh13bph3hzyv4qzRPA==
X-Received: by 2002:ac2:58ee:: with SMTP id v14mr2135737lfo.298.1611070628823;
        Tue, 19 Jan 2021 07:37:08 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id z2sm2309075lfd.142.2021.01.19.07.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 07:37:07 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 1/8] xdp: restructure redirect actions
Date:   Tue, 19 Jan 2021 16:36:48 +0100
Message-Id: <20210119153655.153999-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210119153655.153999-1-bjorn.topel@gmail.com>
References: <20210119153655.153999-1-bjorn.topel@gmail.com>
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

Future commits will introduce yet another redirect target via the a
new helper, bpf_redirect_xsk(). To pave the way for that, we introduce
an explicit redirect type to bpf_redirect_info. This makes the code
easier to follow, and makes it easier to add new redirect targets.

Further, using an explicit type in bpf_redirect_info has a slight
positive performance impact by avoiding a pointer indirection for the
map type lookup, and instead use the hot cacheline for
bpf_redirect_info.

The bpf_redirect_info flags member is not used by XDP, and not
read/written any more. The map member is only written to when
required/used, and not unconditionally.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/filter.h     |   9 ++
 include/trace/events/xdp.h |  46 +++++++----
 net/core/filter.c          | 164 ++++++++++++++++++-------------------
 3 files changed, 117 insertions(+), 102 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 7fdce5407214..5fc336a271c2 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -637,10 +637,19 @@ struct bpf_redirect_info {
 	u32 tgt_index;
 	void *tgt_value;
 	struct bpf_map *map;
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
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index 76a97176ab81..0e17b9a74f28 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -96,9 +96,10 @@ DECLARE_EVENT_CLASS(xdp_redirect_template,
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
@@ -111,12 +112,19 @@ DECLARE_EVENT_CLASS(xdp_redirect_template,
 	),
 
 	TP_fast_assign(
+		struct bpf_map *map = NULL;
+		u32 index = ri->tgt_index;
+
+		if (type == XDP_REDIR_DEV_MAP || type == XDP_REDIR_CPU_MAP ||
+		    type == XDP_REDIR_XSK_MAP)
+			map = READ_ONCE(ri->map);
+
 		__entry->prog_id	= xdp->aux->id;
 		__entry->act		= XDP_REDIRECT;
 		__entry->ifindex	= dev->ifindex;
 		__entry->err		= err;
 		__entry->to_ifindex	= map ? devmap_ifindex(tgt, map) :
-						index;
+						(u32)(long)tgt;
 		__entry->map_id		= map ? map->id : 0;
 		__entry->map_index	= map ? index : 0;
 	),
@@ -133,45 +141,49 @@ DEFINE_EVENT(xdp_redirect_template, xdp_redirect,
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
diff --git a/net/core/filter.c b/net/core/filter.c
index 9ab94e90d660..5f31e21be531 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3923,23 +3923,6 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
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
@@ -3948,22 +3931,6 @@ void xdp_do_flush(void)
 }
 EXPORT_SYMBOL_GPL(xdp_do_flush);
 
-static inline void *__xdp_map_lookup_elem(struct bpf_map *map, u32 index)
-{
-	switch (map->map_type) {
-	case BPF_MAP_TYPE_DEVMAP:
-		return __dev_map_lookup_elem(map, index);
-	case BPF_MAP_TYPE_DEVMAP_HASH:
-		return __dev_map_hash_lookup_elem(map, index);
-	case BPF_MAP_TYPE_CPUMAP:
-		return __cpu_map_lookup_elem(map, index);
-	case BPF_MAP_TYPE_XSKMAP:
-		return __xsk_map_lookup_elem(map, index);
-	default:
-		return NULL;
-	}
-}
-
 void bpf_clear_redirect_map(struct bpf_map *map)
 {
 	struct bpf_redirect_info *ri;
@@ -3985,34 +3952,42 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 		    struct bpf_prog *xdp_prog)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-	struct bpf_map *map = READ_ONCE(ri->map);
-	u32 index = ri->tgt_index;
+	enum xdp_redirect_type type = ri->tgt_type;
 	void *fwd = ri->tgt_value;
 	int err;
 
-	ri->tgt_index = 0;
+	ri->tgt_type = XDP_REDIR_UNSET;
 	ri->tgt_value = NULL;
-	WRITE_ONCE(ri->map, NULL);
 
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
@@ -4021,41 +3996,40 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
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
+	int err;
 
-	if (map->map_type == BPF_MAP_TYPE_DEVMAP ||
-	    map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
+	switch (type) {
+	case XDP_REDIR_DEV_MAP: {
 		struct bpf_dtab_netdev *dst = fwd;
 
 		err = dev_map_generic_redirect(dst, skb, xdp_prog);
 		if (unlikely(err))
 			goto err;
-	} else if (map->map_type == BPF_MAP_TYPE_XSKMAP) {
+		break;
+	}
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
 
@@ -4063,29 +4037,31 @@ int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
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
@@ -4098,10 +4074,9 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
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
@@ -4123,18 +4098,37 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
 	if (unlikely(flags > XDP_TX))
 		return XDP_ABORTED;
 
-	ri->tgt_value = __xdp_map_lookup_elem(map, ifindex);
+	switch (map->map_type) {
+	case BPF_MAP_TYPE_DEVMAP:
+		ri->tgt_value = __dev_map_lookup_elem(map, ifindex);
+		ri->tgt_type = XDP_REDIR_DEV_MAP;
+		break;
+	case BPF_MAP_TYPE_DEVMAP_HASH:
+		ri->tgt_value = __dev_map_hash_lookup_elem(map, ifindex);
+		ri->tgt_type = XDP_REDIR_DEV_MAP;
+		break;
+	case BPF_MAP_TYPE_CPUMAP:
+		ri->tgt_value = __cpu_map_lookup_elem(map, ifindex);
+		ri->tgt_type = XDP_REDIR_CPU_MAP;
+		break;
+	case BPF_MAP_TYPE_XSKMAP:
+		ri->tgt_value = __xsk_map_lookup_elem(map, ifindex);
+		ri->tgt_type = XDP_REDIR_XSK_MAP;
+		break;
+	default:
+		ri->tgt_value = NULL;
+	}
+
 	if (unlikely(!ri->tgt_value)) {
 		/* If the lookup fails we want to clear out the state in the
 		 * redirect_info struct completely, so that if an eBPF program
 		 * performs multiple lookups, the last one always takes
 		 * precedence.
 		 */
-		WRITE_ONCE(ri->map, NULL);
+		ri->tgt_type = XDP_REDIR_UNSET;
 		return flags;
 	}
 
-	ri->flags = flags;
 	ri->tgt_index = ifindex;
 	WRITE_ONCE(ri->map, map);
 
-- 
2.27.0

