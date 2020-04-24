Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFB71B701E
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 10:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgDXI4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 04:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgDXI43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 04:56:29 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE32C09B045;
        Fri, 24 Apr 2020 01:56:29 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id di6so4292380qvb.10;
        Fri, 24 Apr 2020 01:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ckST6BfpsFay2Q0IEwNAz/X8C8FRvXwhlDHyzBKhEEQ=;
        b=YNNsWuHvg6fuoTM23h1oGDzgT8gKCsP+vmsgxzmNxZZkdHaZYlNj2Yoqa2sXP7ScjY
         5XNYsa1ImmHWErOH6BVcMW5yPJfYNJiqm4g08GQetPFmncAi+CT9sRhBm4j1afXHyRYl
         09W111kFa/X453o7fxuVYkmmUXEk0xWIxTt08Dn8PEA8f2OUh9ODvoHgjV8MDABqM6OG
         0qvLyJXgFB7/zLun2mtDmtBkvwKtqTXdHwdDH+6a+mZDakUEN3bQsleghYiJCS7dYalw
         vZNiOjeWCCC3uCkcMsIVVXt1g+ZarBLF1VwXrPcsLCSrKE3Xn8GwI+CAYw0zBDeI9Dvf
         Vm7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ckST6BfpsFay2Q0IEwNAz/X8C8FRvXwhlDHyzBKhEEQ=;
        b=qZ9oEvX7idIU1bU3Zz19AGlJUHeOPD034+pniuuw1il10wJXYBkUwCTwB9Y07HT7iP
         vtX8alrmUSykXukxZcGgZSXaOwp5orO5vV8asoulILJhLeZnmyiVYs/+KcB6oQoQueUN
         U/2bp6XRPy93dE2BNXx89DFx9viDjZf1frYWLgXbJAk2ZyfFqzZ4y6c15Yihzs+YR4c+
         ApHl+sH2Nf3VQk35yE0QMj1cvipbOav+U7a1Eh7W0GR1wmUIVM46oRpKKT92GuPoxJsr
         4XVigmqigZr3iiEnO+uJLyop0JjPi7mU0B/d0q4venTMeAJjbOzm4EkQFw+12Y+0bk0O
         5hPg==
X-Gm-Message-State: AGi0PuZqqLabLU20GikVHHmb4I78cXYeAFBlMYkYf5SIaiWLNZBxH3EE
        RxtFTcnWzi4MHXqASDxlfpQicIm34Hc=
X-Google-Smtp-Source: APiQypJNb89pY9WUdofaBzciUWKB6Kk4AzSDLYlrdlCEflGYYSXfeIq4ZPoqkvGhu/1OxJ8Zut6DcQ==
X-Received: by 2002:ad4:42c7:: with SMTP id f7mr8348926qvr.127.1587718587957;
        Fri, 24 Apr 2020 01:56:27 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z18sm3390842qti.47.2020.04.24.01.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 01:56:27 -0700 (PDT)
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
Subject: [RFC PATCHv2 bpf-next 1/2] xdp: add a new helper for dev map multicast support
Date:   Fri, 24 Apr 2020 16:56:09 +0800
Message-Id: <20200424085610.10047-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200424085610.10047-1-liuhangbin@gmail.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200424085610.10047-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a prototype for xdp multicast support. In this implemention we
add a new helper to accept two maps, forward map and exclude map.
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

v2: add new syscall bpf_xdp_redirect_map_multi() which could accept
include/exclude maps directly.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/linux/bpf.h            |  20 ++++++
 include/linux/filter.h         |   1 +
 include/net/xdp.h              |   1 +
 include/uapi/linux/bpf.h       |  23 ++++++-
 kernel/bpf/devmap.c            | 114 +++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c          |   6 ++
 net/core/filter.c              |  98 ++++++++++++++++++++++++++--
 net/core/xdp.c                 |  26 ++++++++
 tools/include/uapi/linux/bpf.h |  23 ++++++-
 9 files changed, 305 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fd2b2322412d..3fd2903def3f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1161,6 +1161,11 @@ int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
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
 
@@ -1297,6 +1302,21 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
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
index 9b5aa5c483cc..5b4e1ccd2d37 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -614,6 +614,7 @@ struct bpf_redirect_info {
 	u32 tgt_index;
 	void *tgt_value;
 	struct bpf_map *map;
+	struct bpf_map *ex_map;
 	u32 kern_flags;
 };
 
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 40c6d3398458..a214dce8579c 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -92,6 +92,7 @@ static inline void xdp_scrub_frame(struct xdp_frame *frame)
 }
 
 struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
+struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf);
 
 /* Convert xdp_buff to xdp_frame */
 static inline
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2e29a671d67e..1dbe42290223 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3025,6 +3025,21 @@ union bpf_attr {
  *		* **-EOPNOTSUPP**	Unsupported operation, for example a
  *					call from outside of TC ingress.
  *		* **-ESOCKTNOSUPPORT**	Socket type not supported (reuseport).
+ *
+ * int bpf_redirect_map_multi(struct bpf_map *map, struct bpf_map *ex_map, u64 flags)
+ * 	Description
+ * 		Redirect the packet to all the interfaces in *map*, and
+ * 		exclude the interfaces that in *ex_map*. The *ex_map* could
+ * 		be NULL.
+ *
+ * 		Currently the *flags* only supports *BPF_F_EXCLUDE_INGRESS*,
+ * 		which could exlcude redirect to the ingress device.
+ *
+ * 		See also bpf_redirect_map(), which supports redirecting
+ * 		packet to a specific ifindex in the map.
+ * 	Return
+ * 		**XDP_REDIRECT** on success, or **XDP_ABORTED** on error.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3151,7 +3166,8 @@ union bpf_attr {
 	FN(xdp_output),			\
 	FN(get_netns_cookie),		\
 	FN(get_current_ancestor_cgroup_id),	\
-	FN(sk_assign),
+	FN(sk_assign),			\
+	FN(redirect_map_multi),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3280,6 +3296,11 @@ enum bpf_lwt_encap_mode {
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
index 58bdca5d978a..34b171f7826c 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -456,6 +456,120 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
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
+	if (!map)
+		return false;
+
+	if (obj->dev->ifindex == exclude_ifindex)
+		return true;
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
+			return -EOPNOTSUPP;
+
+		err = xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
+		if (unlikely(err))
+			return err;
+
+		nxdpf = xdpf_clone(xdpf);
+		if (unlikely(!nxdpf))
+			return -ENOMEM;
+
+		bq_enqueue(dev, nxdpf, dev_rx);
+
+find_next:
+		err = devmap_get_next_key(map, &key, &next_key);
+		if (err)
+			break;
+		key = next_key;
+	}
+
+	return 0;
+}
+
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 38cfcf701eeb..f77213a0e354 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3880,6 +3880,7 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_MAP_TYPE_DEVMAP:
 	case BPF_MAP_TYPE_DEVMAP_HASH:
 		if (func_id != BPF_FUNC_redirect_map &&
+		    func_id != BPF_FUNC_redirect_map_multi &&
 		    func_id != BPF_FUNC_map_lookup_elem)
 			goto error;
 		break;
@@ -3970,6 +3971,11 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
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
index 7d6ceaa54d21..94d1530e5ac6 100644
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
+	struct bpf_map *ex_map = READ_ONCE(ri->ex_map);
 	struct bpf_map *map = READ_ONCE(ri->map);
 	u32 index = ri->tgt_index;
 	void *fwd = ri->tgt_value;
@@ -3552,7 +3559,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 
 		err = dev_xdp_enqueue(fwd, xdp, dev);
 	} else {
-		err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
+		err = __bpf_tx_xdp_map(dev, fwd, map, xdp, ex_map, exclude_ingress);
 	}
 
 	if (unlikely(err))
@@ -3566,6 +3573,49 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
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
+				return -EOVERFLOW;
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
+	return 0;
+}
+
 static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       struct sk_buff *skb,
 				       struct xdp_buff *xdp,
@@ -3573,6 +3623,8 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       struct bpf_map *map)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	bool exclude_ingress = !!(ri->flags & BPF_F_EXCLUDE_INGRESS);
+	struct bpf_map *ex_map = READ_ONCE(ri->ex_map);
 	u32 index = ri->tgt_index;
 	void *fwd = ri->tgt_value;
 	int err = 0;
@@ -3583,9 +3635,16 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 
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
@@ -3699,6 +3758,33 @@ static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
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
+
+	WRITE_ONCE(ri->map, map);
+	WRITE_ONCE(ri->ex_map, ex_map);
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
@@ -6304,6 +6390,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_redirect_proto;
 	case BPF_FUNC_redirect_map:
 		return &bpf_xdp_redirect_map_proto;
+	case BPF_FUNC_redirect_map_multi:
+		return &bpf_xdp_redirect_map_multi_proto;
 	case BPF_FUNC_xdp_adjust_tail:
 		return &bpf_xdp_adjust_tail_proto;
 	case BPF_FUNC_fib_lookup:
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 4c7ea85486af..70dfb4910f84 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -496,3 +496,29 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp)
 	return xdpf;
 }
 EXPORT_SYMBOL_GPL(xdp_convert_zc_to_xdp_frame);
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
index 2e29a671d67e..1dbe42290223 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3025,6 +3025,21 @@ union bpf_attr {
  *		* **-EOPNOTSUPP**	Unsupported operation, for example a
  *					call from outside of TC ingress.
  *		* **-ESOCKTNOSUPPORT**	Socket type not supported (reuseport).
+ *
+ * int bpf_redirect_map_multi(struct bpf_map *map, struct bpf_map *ex_map, u64 flags)
+ * 	Description
+ * 		Redirect the packet to all the interfaces in *map*, and
+ * 		exclude the interfaces that in *ex_map*. The *ex_map* could
+ * 		be NULL.
+ *
+ * 		Currently the *flags* only supports *BPF_F_EXCLUDE_INGRESS*,
+ * 		which could exlcude redirect to the ingress device.
+ *
+ * 		See also bpf_redirect_map(), which supports redirecting
+ * 		packet to a specific ifindex in the map.
+ * 	Return
+ * 		**XDP_REDIRECT** on success, or **XDP_ABORTED** on error.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3151,7 +3166,8 @@ union bpf_attr {
 	FN(xdp_output),			\
 	FN(get_netns_cookie),		\
 	FN(get_current_ancestor_cgroup_id),	\
-	FN(sk_assign),
+	FN(sk_assign),			\
+	FN(redirect_map_multi),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3280,6 +3296,11 @@ enum bpf_lwt_encap_mode {
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
2.19.2

