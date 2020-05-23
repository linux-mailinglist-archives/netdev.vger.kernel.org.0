Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD1F1DF518
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387646AbgEWGGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387621AbgEWGGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 02:06:14 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D3EC061A0E;
        Fri, 22 May 2020 23:06:14 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x10so5280301plr.4;
        Fri, 22 May 2020 23:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DYYuBbmjZN1uf+fco4QdNTuW+lqtTjBskn/6iuWPi+Q=;
        b=r+Fv5RR3gy5puOgQDuqdlBquXAblSTtibFBH/RXXpQ8Y3cpXA3le1J4vgYpsKjb1Fp
         pR9hqr1cHBsD7MksEfYL/VvIrJhHB3T+Hdg0FfTxmvDz7vkD5178Sl1onSzMHkJuBx28
         Vuv3uw5DFAwjmmSuiIbW02roJtm3wZJGbOWdeRf4UIJ/9KxlCzeukFDLvs760u7sD3Bk
         mp8DfrUqKiIZitLTgXU469IG9ZNskkKx/3F/Mp+JP8LXF4eCBV1b+sUTSFJpkv3xIzHG
         /GEytYYoH/WPcbGqkZZSTKDRfw24RClawmVzclP9jzOa6JnYwmyWb5bxw1IFEAg2yH9Y
         j3xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DYYuBbmjZN1uf+fco4QdNTuW+lqtTjBskn/6iuWPi+Q=;
        b=ZtigloW0bjsmKGnUokYdBDkGHEVkm+cOpGSe+sXUJUMLYQPDj0mUG7VP8FBEMGNc3Z
         za5Vyy54Nn0mhWK5umvqCw2xSeGPxToPHuzey1RsiXX/NBuXzfGTNIcShGqgpObMLvhT
         en0rP244hVV3dPETRjPUS+re1ghpuSgHoMjmPNkDS9OiLe8FLrlccmMcSjGKGGvwerf1
         ZeTiia0bC97ltbC4UhpLh7845FXcU6rsETKKy/ML0f9aSAxMbhP8EyZRk2ynvBSLScKg
         mz57GuVcuzKJyiqGttLQRG9+EWqapuaKu+ru/qftQ6W897OFzv5+QX5XXxR1awjEP2Rl
         Sk5A==
X-Gm-Message-State: AOAM532RgGiyAHYvpH8sG3o3BZY3djftBEWVnYnUS8p4iL4k0RL1ya5o
        6lvsK1UAEVg0FkUd+LQJ6Z2VCgDMur9/Hw==
X-Google-Smtp-Source: ABdhPJyrTNLL0YOWbjU3/jrnL/UNCLXjxm/zqVl7+2/k9nIGmLzR7+mM9RNZUCq54584C8Ygcd2hTw==
X-Received: by 2002:a17:90a:589:: with SMTP id i9mr8508043pji.156.1590213973595;
        Fri, 22 May 2020 23:06:13 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a2sm8259780pfl.12.2020.05.22.23.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 23:06:13 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 bpf-next 1/2] xdp: add a new helper for dev map multicast support
Date:   Sat, 23 May 2020 14:05:36 +0800
Message-Id: <20200523060537.264096-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200523060537.264096-1-liuhangbin@gmail.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200523060537.264096-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is for xdp multicast support. In this implementation we
add a new helper to accept two maps: forward map and exclude map.
We will redirect the packet to all the interfaces in *forward map*, but
exclude the interfaces that in *exclude map*.

To achive this I add a new ex_map for struct bpf_redirect_info.
in the helper I set tgt_value to NULL to make a difference with
bpf_xdp_redirect_map()

We also add a flag *BPF_F_EXCLUDE_INGRESS* incase you don't want to
create a exclude map for each interface and just want to exclude the
ingress interface.

The general data path is kept in net/core/filter.c. The native data
path is in kernel/bpf/devmap.c so we can use direct calls to
get better performace.

v3: Based on Toke's suggestion, do the following update
a) Update bpf_redirect_map_multi() description in bpf.h.
b) Fix exclude_ifindex checking order in dev_in_exclude_map().
c) Fix one more xdpf clone in dev_map_enqueue_multi().
d) Go find next one in dev_map_enqueue_multi() if the interface is not
   able to forward instead of abort the whole loop.
e) Remove READ_ONCE/WRITE_ONCE for ex_map.

v2: Add new syscall bpf_xdp_redirect_map_multi() which could accept
include/exclude maps directly.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/linux/bpf.h            |  20 ++++++
 include/linux/filter.h         |   1 +
 include/net/xdp.h              |   1 +
 include/uapi/linux/bpf.h       |  22 +++++-
 kernel/bpf/devmap.c            | 124 +++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c          |   6 ++
 net/core/filter.c              | 101 +++++++++++++++++++++++++--
 net/core/xdp.c                 |  26 +++++++
 tools/include/uapi/linux/bpf.h |  22 +++++-
 9 files changed, 316 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index efe8836b5c48..d1c169bec6b5 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1240,6 +1240,11 @@ int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
 int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
+bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map,
+			int exclude_ifindex);
+int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+			  struct bpf_map *map, struct bpf_map *ex_map,
+			  bool exclude_ingress);
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog);
 
@@ -1377,6 +1382,21 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 	return 0;
 }
 
+static inline
+bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map,
+			int exclude_ifindex)
+{
+	return false;
+}
+
+static inline
+int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+			  struct bpf_map *map, struct bpf_map *ex_map,
+			  bool exclude_ingress)
+{
+	return 0;
+}
+
 struct sk_buff;
 
 static inline int dev_map_generic_redirect(struct bpf_dtab_netdev *dst,
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 73d06a39e2d6..5d9c6ac6ade3 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -612,6 +612,7 @@ struct bpf_redirect_info {
 	u32 tgt_index;
 	void *tgt_value;
 	struct bpf_map *map;
+	struct bpf_map *ex_map;
 	u32 kern_flags;
 };
 
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 90f11760bd12..967684aa096a 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -105,6 +105,7 @@ void xdp_warn(const char *msg, const char *func, const int line);
 #define XDP_WARN(msg) xdp_warn(msg, __func__, __LINE__)
 
 struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
+struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf);
 
 /* Convert xdp_buff to xdp_frame */
 static inline
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 97e1fd19ff58..000b0cf961ea 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3157,6 +3157,20 @@ union bpf_attr {
  *		**bpf_sk_cgroup_id**\ ().
  *	Return
  *		The id is returned or 0 in case the id could not be retrieved.
+ *
+ * int bpf_redirect_map_multi(struct bpf_map *map, struct bpf_map *ex_map, u64 flags)
+ * 	Description
+ * 		Redirect the packet to ALL the interfaces in *map*, but
+ * 		exclude the interfaces in *ex_map* (which may be NULL).
+ *
+ * 		Currently the *flags* only supports *BPF_F_EXCLUDE_INGRESS*,
+ * 		which additionally excludes the current ingress device.
+ *
+ * 		See also bpf_redirect_map(), which supports redirecting
+ * 		packet to a specific ifindex in the map.
+ * 	Return
+ * 		**XDP_REDIRECT** on success, or **XDP_ABORTED** on error.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3288,7 +3302,8 @@ union bpf_attr {
 	FN(seq_printf),			\
 	FN(seq_write),			\
 	FN(sk_cgroup_id),		\
-	FN(sk_ancestor_cgroup_id),
+	FN(sk_ancestor_cgroup_id),	\
+	FN(redirect_map_multi),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3417,6 +3432,11 @@ enum bpf_lwt_encap_mode {
 	BPF_LWT_ENCAP_IP,
 };
 
+/* BPF_FUNC_redirect_map_multi flags. */
+enum {
+	BPF_F_EXCLUDE_INGRESS		= (1ULL << 0),
+};
+
 #define __bpf_md_ptr(type, name)	\
 union {					\
 	type name;			\
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index a51d9fb7a359..ecc5c44a5bab 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -455,6 +455,130 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 	return __xdp_enqueue(dev, xdp, dev_rx);
 }
 
+/* Use direct call in fast path instead of  map->ops->map_get_next_key() */
+static int devmap_get_next_key(struct bpf_map *map, void *key, void *next_key)
+{
+
+	switch (map->map_type) {
+	case BPF_MAP_TYPE_DEVMAP:
+		return dev_map_get_next_key(map, key, next_key);
+	case BPF_MAP_TYPE_DEVMAP_HASH:
+		return dev_map_hash_get_next_key(map, key, next_key);
+	default:
+		break;
+	}
+
+	return -ENOENT;
+}
+
+bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map,
+			int exclude_ifindex)
+{
+	struct bpf_dtab_netdev *in_obj = NULL;
+	u32 key, next_key;
+	int err;
+
+	if (obj->dev->ifindex == exclude_ifindex)
+		return true;
+
+	if (!map)
+		return false;
+
+	devmap_get_next_key(map, NULL, &key);
+
+	for (;;) {
+		switch (map->map_type) {
+		case BPF_MAP_TYPE_DEVMAP:
+			in_obj = __dev_map_lookup_elem(map, key);
+			break;
+		case BPF_MAP_TYPE_DEVMAP_HASH:
+			in_obj = __dev_map_hash_lookup_elem(map, key);
+			break;
+		default:
+			break;
+		}
+
+		if (in_obj && in_obj->dev->ifindex == obj->dev->ifindex)
+			return true;
+
+		err = devmap_get_next_key(map, &key, &next_key);
+
+		if (err)
+			break;
+
+		key = next_key;
+	}
+
+	return false;
+}
+
+int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+			  struct bpf_map *map, struct bpf_map *ex_map,
+			  bool exclude_ingress)
+{
+	struct bpf_dtab_netdev *obj = NULL;
+	struct xdp_frame *xdpf, *nxdpf;
+	struct net_device *dev;
+	bool first = true;
+	u32 key, next_key;
+	int err;
+
+	devmap_get_next_key(map, NULL, &key);
+
+	xdpf = convert_to_xdp_frame(xdp);
+	if (unlikely(!xdpf))
+		return -EOVERFLOW;
+
+	for (;;) {
+		switch (map->map_type) {
+		case BPF_MAP_TYPE_DEVMAP:
+			obj = __dev_map_lookup_elem(map, key);
+			break;
+		case BPF_MAP_TYPE_DEVMAP_HASH:
+			obj = __dev_map_hash_lookup_elem(map, key);
+			break;
+		default:
+			break;
+		}
+
+		if (!obj || dev_in_exclude_map(obj, ex_map,
+					       exclude_ingress ? dev_rx->ifindex : 0))
+			goto find_next;
+
+		dev = obj->dev;
+
+		if (!dev->netdev_ops->ndo_xdp_xmit)
+			goto find_next;
+
+		err = xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
+		if (unlikely(err))
+			goto find_next;
+
+		if (!first) {
+			nxdpf = xdpf_clone(xdpf);
+			if (unlikely(!nxdpf))
+				return -ENOMEM;
+
+			bq_enqueue(dev, nxdpf, dev_rx);
+		} else {
+			bq_enqueue(dev, xdpf, dev_rx);
+			first = false;
+		}
+
+find_next:
+		err = devmap_get_next_key(map, &key, &next_key);
+		if (err)
+			break;
+		key = next_key;
+	}
+
+	/* didn't find anywhere to forward to, free buf */
+	if (first)
+		xdp_return_frame_rx_napi(xdpf);
+
+	return 0;
+}
+
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d2e27dba4ac6..a5857953248d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3946,6 +3946,7 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_MAP_TYPE_DEVMAP:
 	case BPF_MAP_TYPE_DEVMAP_HASH:
 		if (func_id != BPF_FUNC_redirect_map &&
+		    func_id != BPF_FUNC_redirect_map_multi &&
 		    func_id != BPF_FUNC_map_lookup_elem)
 			goto error;
 		break;
@@ -4038,6 +4039,11 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		    map->map_type != BPF_MAP_TYPE_XSKMAP)
 			goto error;
 		break;
+	case BPF_FUNC_redirect_map_multi:
+		if (map->map_type != BPF_MAP_TYPE_DEVMAP &&
+		    map->map_type != BPF_MAP_TYPE_DEVMAP_HASH)
+			goto error;
+		break;
 	case BPF_FUNC_sk_redirect_map:
 	case BPF_FUNC_msg_redirect_map:
 	case BPF_FUNC_sock_map_update:
diff --git a/net/core/filter.c b/net/core/filter.c
index bd2853d23b50..f07eb1408f70 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3473,12 +3473,17 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
 };
 
 static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
-			    struct bpf_map *map, struct xdp_buff *xdp)
+			    struct bpf_map *map, struct xdp_buff *xdp,
+			    struct bpf_map *ex_map, bool exclude_ingress)
 {
 	switch (map->map_type) {
 	case BPF_MAP_TYPE_DEVMAP:
 	case BPF_MAP_TYPE_DEVMAP_HASH:
-		return dev_map_enqueue(fwd, xdp, dev_rx);
+		if (fwd)
+			return dev_map_enqueue(fwd, xdp, dev_rx);
+		else
+			return dev_map_enqueue_multi(xdp, dev_rx, map, ex_map,
+						     exclude_ingress);
 	case BPF_MAP_TYPE_CPUMAP:
 		return cpu_map_enqueue(fwd, xdp, dev_rx);
 	case BPF_MAP_TYPE_XSKMAP:
@@ -3534,6 +3539,8 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 		    struct bpf_prog *xdp_prog)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	bool exclude_ingress = !!(ri->flags & BPF_F_EXCLUDE_INGRESS);
+	struct bpf_map *ex_map = ri->ex_map;
 	struct bpf_map *map = READ_ONCE(ri->map);
 	u32 index = ri->tgt_index;
 	void *fwd = ri->tgt_value;
@@ -3541,6 +3548,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 
 	ri->tgt_index = 0;
 	ri->tgt_value = NULL;
+	ri->ex_map = NULL;
 	WRITE_ONCE(ri->map, NULL);
 
 	if (unlikely(!map)) {
@@ -3552,7 +3560,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 
 		err = dev_xdp_enqueue(fwd, xdp, dev);
 	} else {
-		err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
+		err = __bpf_tx_xdp_map(dev, fwd, map, xdp, ex_map, exclude_ingress);
 	}
 
 	if (unlikely(err))
@@ -3566,6 +3574,50 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 }
 EXPORT_SYMBOL_GPL(xdp_do_redirect);
 
+static int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
+				  struct bpf_prog *xdp_prog,
+				  struct bpf_map *map, struct bpf_map *ex_map,
+				  bool exclude_ingress)
+
+{
+	struct bpf_dtab_netdev *dst;
+	struct sk_buff *nskb;
+	u32 key, next_key;
+	int err;
+	void *fwd;
+
+	/* Get first key from forward map */
+	map->ops->map_get_next_key(map, NULL, &key);
+
+	for (;;) {
+		fwd = __xdp_map_lookup_elem(map, key);
+		if (fwd) {
+			dst = (struct bpf_dtab_netdev *)fwd;
+			if (dev_in_exclude_map(dst, ex_map,
+					       exclude_ingress ? dev->ifindex : 0))
+				goto find_next;
+
+			nskb = skb_clone(skb, GFP_ATOMIC);
+			if (!nskb)
+				return -ENOMEM;
+
+			err = dev_map_generic_redirect(dst, nskb, xdp_prog);
+			if (unlikely(err))
+				return err;
+		}
+
+find_next:
+		err = map->ops->map_get_next_key(map, &key, &next_key);
+		if (err)
+			break;
+
+		key = next_key;
+	}
+
+	consume_skb(skb);
+	return 0;
+}
+
 static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       struct sk_buff *skb,
 				       struct xdp_buff *xdp,
@@ -3573,19 +3625,29 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       struct bpf_map *map)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	bool exclude_ingress = !!(ri->flags & BPF_F_EXCLUDE_INGRESS);
+	struct bpf_map *ex_map = ri->ex_map;
 	u32 index = ri->tgt_index;
 	void *fwd = ri->tgt_value;
 	int err = 0;
 
 	ri->tgt_index = 0;
 	ri->tgt_value = NULL;
+	ri->ex_map = NULL;
 	WRITE_ONCE(ri->map, NULL);
 
 	if (map->map_type == BPF_MAP_TYPE_DEVMAP ||
 	    map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
-		struct bpf_dtab_netdev *dst = fwd;
+		if (fwd) {
+			struct bpf_dtab_netdev *dst = fwd;
+
+			err = dev_map_generic_redirect(dst, skb, xdp_prog);
+		} else {
+			/* Deal with multicast maps */
+			err = dev_map_redirect_multi(dev, skb, xdp_prog, map,
+						     ex_map, exclude_ingress);
+		}
 
-		err = dev_map_generic_redirect(dst, skb, xdp_prog);
 		if (unlikely(err))
 			goto err;
 	} else if (map->map_type == BPF_MAP_TYPE_XSKMAP) {
@@ -3699,6 +3761,33 @@ static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
 	.arg3_type      = ARG_ANYTHING,
 };
 
+BPF_CALL_3(bpf_xdp_redirect_map_multi, struct bpf_map *, map,
+	   struct bpf_map *, ex_map, u64, flags)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+
+	if (unlikely(!map || flags > BPF_F_EXCLUDE_INGRESS))
+		return XDP_ABORTED;
+
+	ri->tgt_index = 0;
+	ri->tgt_value = NULL;
+	ri->flags = flags;
+	ri->ex_map = ex_map;
+
+	WRITE_ONCE(ri->map, map);
+
+	return XDP_REDIRECT;
+}
+
+static const struct bpf_func_proto bpf_xdp_redirect_map_multi_proto = {
+	.func           = bpf_xdp_redirect_map_multi,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_CONST_MAP_PTR,
+	.arg1_type      = ARG_CONST_MAP_PTR,
+	.arg3_type      = ARG_ANYTHING,
+};
+
 static unsigned long bpf_skb_copy(void *dst_buff, const void *skb,
 				  unsigned long off, unsigned long len)
 {
@@ -6363,6 +6452,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_redirect_proto;
 	case BPF_FUNC_redirect_map:
 		return &bpf_xdp_redirect_map_proto;
+	case BPF_FUNC_redirect_map_multi:
+		return &bpf_xdp_redirect_map_multi_proto;
 	case BPF_FUNC_xdp_adjust_tail:
 		return &bpf_xdp_adjust_tail_proto;
 	case BPF_FUNC_fib_lookup:
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 90f44f382115..acdc63833b1f 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -475,3 +475,29 @@ void xdp_warn(const char *msg, const char *func, const int line)
 	WARN(1, "XDP_WARN: %s(line:%d): %s\n", func, line, msg);
 };
 EXPORT_SYMBOL_GPL(xdp_warn);
+
+struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
+{
+	unsigned int headroom, totalsize;
+	struct xdp_frame *nxdpf;
+	struct page *page;
+	void *addr;
+
+	headroom = xdpf->headroom + sizeof(*xdpf);
+	totalsize = headroom + xdpf->len;
+
+	if (unlikely(totalsize > PAGE_SIZE))
+		return NULL;
+	page = dev_alloc_page();
+	if (!page)
+		return NULL;
+	addr = page_to_virt(page);
+
+	memcpy(addr, xdpf, totalsize);
+
+	nxdpf = addr;
+	nxdpf->data = addr + headroom;
+
+	return nxdpf;
+}
+EXPORT_SYMBOL_GPL(xdpf_clone);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 97e1fd19ff58..000b0cf961ea 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3157,6 +3157,20 @@ union bpf_attr {
  *		**bpf_sk_cgroup_id**\ ().
  *	Return
  *		The id is returned or 0 in case the id could not be retrieved.
+ *
+ * int bpf_redirect_map_multi(struct bpf_map *map, struct bpf_map *ex_map, u64 flags)
+ * 	Description
+ * 		Redirect the packet to ALL the interfaces in *map*, but
+ * 		exclude the interfaces in *ex_map* (which may be NULL).
+ *
+ * 		Currently the *flags* only supports *BPF_F_EXCLUDE_INGRESS*,
+ * 		which additionally excludes the current ingress device.
+ *
+ * 		See also bpf_redirect_map(), which supports redirecting
+ * 		packet to a specific ifindex in the map.
+ * 	Return
+ * 		**XDP_REDIRECT** on success, or **XDP_ABORTED** on error.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3288,7 +3302,8 @@ union bpf_attr {
 	FN(seq_printf),			\
 	FN(seq_write),			\
 	FN(sk_cgroup_id),		\
-	FN(sk_ancestor_cgroup_id),
+	FN(sk_ancestor_cgroup_id),	\
+	FN(redirect_map_multi),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3417,6 +3432,11 @@ enum bpf_lwt_encap_mode {
 	BPF_LWT_ENCAP_IP,
 };
 
+/* BPF_FUNC_redirect_map_multi flags. */
+enum {
+	BPF_F_EXCLUDE_INGRESS		= (1ULL << 0),
+};
+
 #define __bpf_md_ptr(type, name)	\
 union {					\
 	type name;			\
-- 
2.25.4

