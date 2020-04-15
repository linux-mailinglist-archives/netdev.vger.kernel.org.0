Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9101A97A6
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408179AbgDOIzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404948AbgDOIzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 04:55:05 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C56DC061A0C;
        Wed, 15 Apr 2020 01:55:05 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id g74so16330842qke.13;
        Wed, 15 Apr 2020 01:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uOlf/C4Se3FrKp5cGmASqJRvvld/N2S8+S3f+5IIano=;
        b=nlqLL/SJKYnz9KaDNuVZyrlpoY1gedpjdSOWR6XB1SK+qmbpVdRDS8SLmVKvJmH5nF
         LU+1MZ/7iZmDZOez3+UHkAjaZ7hoqnMgfxvYW/4I9XMC0aBGebqYaWNYHFR5XkxPxMcV
         rUkh2vsjTnMA1TDIoUBu/5z08yRq96t42wVGhjOyMm3WfW03vu6HYzkBDXlX/E8Hipr3
         0eOGeD6IaxhvxI48qOeEMmFOomi19ASKuoCaLzX0EEp87kW7sDrW99pS943gGH4hSve5
         DdRKBvM9X7NPDK5ZBJvLn1d9LGb2M6Vdx/FPiKDPtTO5fOrJiHRLQ0UxikiE7drbOaYJ
         /L+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uOlf/C4Se3FrKp5cGmASqJRvvld/N2S8+S3f+5IIano=;
        b=op9hlMP5E5iZ3N5B+CaB+uDfxUV3SnLF9vBJfu8o8yri1ETmLSSPDNHGlD8sQfFm7U
         aUZNMaM7kJ/iDRotKKSwelaLtyDK6VI28k2n78mugqhCrF8p4q8OwXVOJRwkC+C7sMqr
         98eS5BOCsGaryD9dVDOV2aohVcHek6luORYTxOx7Wm5HgsoyT9KKuodRxTRjt2g/kW8r
         Okp0lprBWi0eSwL/kybIlBZayIT2uk6zOytLfsgUP/35ooA0uzFT7uJ0SIMuPt1uRu1d
         FLsZbl635ODx3GEqyBtuv7AsGwihqjSYdHIuR8LkbugfM638fscqya2OFAmH3C0O0R7p
         G7rA==
X-Gm-Message-State: AGi0Pua87J18KI3E1a/RPM2hA0zzABG13uMyynz+clixt0hGN0VzTGdP
        WKzLBUBcXl5EgSTKQsSLQFm1DT6KINQ=
X-Google-Smtp-Source: APiQypKyh7eaw8lYC0u6OoRUAplONHBMT3lBgEzK0DfMUjtUDoyNRvut5oke6OGjEVTINJtgqInz5A==
X-Received: by 2002:a05:620a:1084:: with SMTP id g4mr24609272qkk.52.1586940904136;
        Wed, 15 Apr 2020 01:55:04 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o22sm1882750qtm.90.2020.04.15.01.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 01:55:03 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [RFC PATCH bpf-next 1/2] xdp: add dev map multicast support
Date:   Wed, 15 Apr 2020 16:54:36 +0800
Message-Id: <20200415085437.23028-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200415085437.23028-1-liuhangbin@gmail.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a prototype for xdp multicast support. In this implemention we
use map-in-map to store the multicast groups, because we may have both
include and exclude groups on one interface.

The include and exclude groups are seperated by a 32 bits map key.
the high 16 bits keys are used for include groups and low 16 bits
keys are for exclude groups.

The general data path is kept in net/core/filter.c. The native data
path is in kernel/bpf/devmap.c so we can use direct calls to
get better performace.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/linux/bpf.h   |  29 +++++++++++
 include/net/xdp.h     |   1 +
 kernel/bpf/arraymap.c |   2 +-
 kernel/bpf/devmap.c   | 118 ++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/hashtab.c  |   2 +-
 kernel/bpf/verifier.c |  15 +++++-
 net/core/filter.c     |  69 +++++++++++++++++++++++-
 net/core/xdp.c        |  26 ++++++++++
 8 files changed, 256 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fd2b2322412d..72797667bca8 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1156,11 +1156,17 @@ struct sk_buff;
 
 struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key);
 struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key);
+void *array_of_map_lookup_elem(struct bpf_map *map, void *key);
+void *htab_of_map_lookup_elem(struct bpf_map *map, void *key);
 void __dev_flush(void);
 int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
 int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
+bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map);
+int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+			  struct bpf_map *map, u32 index);
+
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog);
 
@@ -1276,6 +1282,16 @@ static inline struct net_device  *__dev_map_hash_lookup_elem(struct bpf_map *map
 	return NULL;
 }
 
+static void *array_of_map_lookup_elem(struct bpf_map *map, void *key)
+{
+
+}
+
+static void *htab_of_map_lookup_elem(struct bpf_map *map, void *key)
+{
+
+}
+
 static inline void __dev_flush(void)
 {
 }
@@ -1297,6 +1313,19 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 	return 0;
 }
 
+static inline
+bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map)
+{
+	return true;
+}
+
+static inline
+int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+			  struct bpf_map *map, u32 index)
+{
+	return 0;
+}
+
 struct sk_buff;
 
 static inline int dev_map_generic_redirect(struct bpf_dtab_netdev *dst,
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
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 95d77770353c..26ac66a05015 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -1031,7 +1031,7 @@ static void array_of_map_free(struct bpf_map *map)
 	fd_array_map_free(map);
 }
 
-static void *array_of_map_lookup_elem(struct bpf_map *map, void *key)
+void *array_of_map_lookup_elem(struct bpf_map *map, void *key)
 {
 	struct bpf_map **inner_map = array_map_lookup_elem(map, key);
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 58bdca5d978a..3a60cb209ae1 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -85,6 +85,9 @@ static DEFINE_PER_CPU(struct list_head, dev_flush_list);
 static DEFINE_SPINLOCK(dev_map_lock);
 static LIST_HEAD(dev_map_list);
 
+static void *dev_map_lookup_elem(struct bpf_map *map, void *key);
+static void *dev_map_hash_lookup_elem(struct bpf_map *map, void *key);
+
 static struct hlist_head *dev_map_create_hash(unsigned int entries)
 {
 	int i;
@@ -456,6 +459,121 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
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
+bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map)
+{
+	struct bpf_dtab_netdev *in_obj = NULL;
+	u32 key, next_key;
+	int err;
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
+			  struct bpf_map *map, u32 index)
+{
+	struct bpf_dtab_netdev *obj = NULL;
+	struct bpf_map *in_map, *ex_map;
+	struct xdp_frame *xdpf, *nxdpf;
+	struct net_device *dev;
+	u32 in_index, ex_index;
+	u32 key, next_key;
+	int err;
+
+	in_index = index >> 16;
+	in_index = in_index << 16;
+	ex_index = in_index ^ index;
+
+	in_map = map->ops->map_lookup_elem(map, &in_index);
+	/* ex_map could be NULL */
+	ex_map = map->ops->map_lookup_elem(map, &ex_index);
+
+	devmap_get_next_key(in_map, NULL, &key);
+
+	xdpf = convert_to_xdp_frame(xdp);
+	if (unlikely(!xdpf))
+		return -EOVERFLOW;
+
+	for (;;) {
+		switch (in_map->map_type) {
+		case BPF_MAP_TYPE_DEVMAP:
+			obj = __dev_map_lookup_elem(in_map, key);
+			break;
+		case BPF_MAP_TYPE_DEVMAP_HASH:
+			obj = __dev_map_hash_lookup_elem(in_map, key);
+			break;
+		default:
+			break;
+		}
+		if (!obj)
+			goto find_next;
+
+		if (ex_map && !dev_in_exclude_map(obj, ex_map)) {
+			dev = obj->dev;
+
+			if (!dev->netdev_ops->ndo_xdp_xmit)
+				return -EOPNOTSUPP;
+
+			err = xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
+			if (unlikely(err))
+				return err;
+
+			nxdpf = xdpf_clone(xdpf);
+			if (unlikely(!nxdpf))
+				return -ENOMEM;
+
+			bq_enqueue(dev, nxdpf, dev_rx);
+		}
+find_next:
+		err = devmap_get_next_key(in_map, &key, &next_key);
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
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index d541c8486c95..4e0a2eebd38d 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1853,7 +1853,7 @@ static struct bpf_map *htab_of_map_alloc(union bpf_attr *attr)
 	return map;
 }
 
-static void *htab_of_map_lookup_elem(struct bpf_map *map, void *key)
+void *htab_of_map_lookup_elem(struct bpf_map *map, void *key)
 {
 	struct bpf_map **inner_map  = htab_map_lookup_elem(map, key);
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 04c6630cc18f..84d23418823a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3898,7 +3898,9 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		break;
 	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
 	case BPF_MAP_TYPE_HASH_OF_MAPS:
-		if (func_id != BPF_FUNC_map_lookup_elem)
+		/* Used by multicast redirect */
+		if (func_id != BPF_FUNC_redirect_map &&
+		    func_id != BPF_FUNC_map_lookup_elem)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_SOCKMAP:
@@ -3968,8 +3970,17 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (map->map_type != BPF_MAP_TYPE_DEVMAP &&
 		    map->map_type != BPF_MAP_TYPE_DEVMAP_HASH &&
 		    map->map_type != BPF_MAP_TYPE_CPUMAP &&
-		    map->map_type != BPF_MAP_TYPE_XSKMAP)
+		    map->map_type != BPF_MAP_TYPE_XSKMAP &&
+		    map->map_type != BPF_MAP_TYPE_ARRAY_OF_MAPS &&
+		    map->map_type != BPF_MAP_TYPE_HASH_OF_MAPS)
 			goto error;
+		if (map->map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS ||
+		    map->map_type == BPF_MAP_TYPE_HASH_OF_MAPS) {
+			/* FIXME: Maybe we should also strict the key size here ?? */
+			if (map->inner_map_meta->map_type != BPF_MAP_TYPE_DEVMAP &&
+			    map->inner_map_meta->map_type != BPF_MAP_TYPE_DEVMAP_HASH)
+				goto error;
+		}
 		break;
 	case BPF_FUNC_sk_redirect_map:
 	case BPF_FUNC_msg_redirect_map:
diff --git a/net/core/filter.c b/net/core/filter.c
index 7628b947dbc3..7d2076f5b0a4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3473,12 +3473,17 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
 };
 
 static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
-			    struct bpf_map *map, struct xdp_buff *xdp)
+			    struct bpf_map *map, struct xdp_buff *xdp,
+			    u32 index)
 {
 	switch (map->map_type) {
 	case BPF_MAP_TYPE_DEVMAP:
+		/* fall through */
 	case BPF_MAP_TYPE_DEVMAP_HASH:
 		return dev_map_enqueue(fwd, xdp, dev_rx);
+	case BPF_MAP_TYPE_HASH_OF_MAPS:
+	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
+		return dev_map_enqueue_multi(xdp, dev_rx, map, index);
 	case BPF_MAP_TYPE_CPUMAP:
 		return cpu_map_enqueue(fwd, xdp, dev_rx);
 	case BPF_MAP_TYPE_XSKMAP:
@@ -3508,6 +3513,10 @@ static inline void *__xdp_map_lookup_elem(struct bpf_map *map, u32 index)
 		return __cpu_map_lookup_elem(map, index);
 	case BPF_MAP_TYPE_XSKMAP:
 		return __xsk_map_lookup_elem(map, index);
+	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
+		return array_of_map_lookup_elem(map, (index >> 16) << 16);
+	case BPF_MAP_TYPE_HASH_OF_MAPS:
+		return htab_of_map_lookup_elem(map, (index >> 16) << 16);
 	default:
 		return NULL;
 	}
@@ -3552,7 +3561,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 
 		err = dev_xdp_enqueue(fwd, xdp, dev);
 	} else {
-		err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
+		err = __bpf_tx_xdp_map(dev, fwd, map, xdp, index);
 	}
 
 	if (unlikely(err))
@@ -3566,6 +3575,55 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 }
 EXPORT_SYMBOL_GPL(xdp_do_redirect);
 
+static int dev_map_redirect_multi(struct sk_buff *skb, struct bpf_prog *xdp_prog,
+				  struct bpf_map *map, u32 index)
+
+{
+	struct bpf_map *in_map, *ex_map;
+	struct bpf_dtab_netdev *dst;
+	u32 in_index, ex_index;
+	struct sk_buff *nskb;
+	u32 key, next_key;
+	int err;
+	void *fwd;
+
+	in_index = index >> 16;
+	in_index = in_index << 16;
+	ex_index = in_index ^ index;
+
+	in_map = map->ops->map_lookup_elem(map, &in_index);
+	/* ex_map could be NULL */
+	ex_map = map->ops->map_lookup_elem(map, &ex_index);
+
+	in_map->ops->map_get_next_key(in_map, NULL, &key);
+
+	for (;;) {
+		fwd = __xdp_map_lookup_elem(in_map, key);
+		if (fwd) {
+			dst = (struct bpf_dtab_netdev *)fwd;
+			if (ex_map && dev_in_exclude_map(dst, ex_map))
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
+		err = in_map->ops->map_get_next_key(in_map, &key, &next_key);
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
@@ -3588,6 +3646,13 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 		err = dev_map_generic_redirect(dst, skb, xdp_prog);
 		if (unlikely(err))
 			goto err;
+	} else if (map->map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS ||
+		   map->map_type == BPF_MAP_TYPE_HASH_OF_MAPS) {
+		/* Do multicast redirecting */
+		err = dev_map_redirect_multi(skb, xdp_prog, map, index);
+		if (unlikely(err))
+			goto err;
+		consume_skb(skb);
 	} else if (map->map_type == BPF_MAP_TYPE_XSKMAP) {
 		struct xdp_sock *xs = fwd;
 
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
-- 
2.19.2

