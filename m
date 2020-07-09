Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91672195A5
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 03:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgGIBai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 21:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgGIBah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 21:30:37 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E0AC061A0B;
        Wed,  8 Jul 2020 18:30:37 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g67so215731pgc.8;
        Wed, 08 Jul 2020 18:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3EuQp6FwTT2Fl7BUU5f990sQ4Ugr1LA6UldqWWgCsZc=;
        b=afw/0KYRZDFzplCjEHsoCB4muQ3BMb+o7xZJzqWtPkFYOZW5vTL9fsKnuAk9o4ACtC
         OpvrpTFLIpngCk7hvn3hfS1nv0u85sZxGKzXhe2iqf3QGA3m6JXh9gq1M39n/E3Fp+rV
         u26uNUnl/FwiYYg32XTgiFY5ltkChtkKMWOxslx8+kFY02pihtmbuyKD5cm5P9tnjJ1d
         mSrHXwzR9ZA8I5FY0nEbrlSkjOUD3bAcsi3rFJ3LBBnKxJOmeUaE38k2Qgk6VkhuytNv
         BYOb1pUaqKq+zJlc35s7sR30m1h2jMkVzwz5IZea6VnPEBwDanH7eNVFS96cAoVyAJ1V
         VYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3EuQp6FwTT2Fl7BUU5f990sQ4Ugr1LA6UldqWWgCsZc=;
        b=IK+f8lglYVxbG7i97J5druM20DDYKUq0xXxr5AFm+g7dzZ5I3eRXCfNoyBYzbwUOnT
         /D9rORpsRgSEWDVWCgmYtANKJrrrkfzA0N67mzRdx8AOvajP/PbWYSiv0ymtp6lypX5F
         iCwjIO+wsn4DP3VSnFpBlk3EUWGCmP+MIp7jDpK/762SU/PIsTmWESODfpOAHkrfAJQI
         e3ND44QevxayTiaNz4Be4Fs1KqfXk2UsgllWkYLsJLpk+tccD9iNUMFnQPQq5a5vPcr4
         Y7mtsX8Z6vJxbkF2ECkBDFd9izrCHw7ny1NPwLbLztg6zmmZCAmIW4ZkLZSz0Ng9hICr
         +Reg==
X-Gm-Message-State: AOAM530+XOLeKRQP0GwUcQKbZV0WFyHe+NETgyVFoaqgepN8CHhQHg2j
        /AjttxtXRn9MQXf8cQotcDXJdyCcX5vC+g==
X-Google-Smtp-Source: ABdhPJwTJu4e650ROuFlQ/dnlt84zoUjxf8wn6Qb/o5yq7vv8lvqOiolree+z994WpBFkXZfGRsZCQ==
X-Received: by 2002:a62:2641:: with SMTP id m62mr27039706pfm.263.1594258236382;
        Wed, 08 Jul 2020 18:30:36 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q14sm847157pgk.86.2020.07.08.18.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 18:30:35 -0700 (PDT)
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
Subject: [PATCHv6 bpf-next 1/3] xdp: add a new helper for dev map multicast support
Date:   Thu,  9 Jul 2020 09:30:06 +0800
Message-Id: <20200709013008.3900892-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200709013008.3900892-1-liuhangbin@gmail.com>
References: <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200709013008.3900892-1-liuhangbin@gmail.com>
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

v6: converted helper return types from int to long

v5:
a) Check devmap_get_next_key() return value.
b) Pass through flags to __bpf_tx_xdp_map() instead of bool value.
c) In function dev_map_enqueue_multi(), consume xdpf for the last
   obj instead of the first on.
d) Update helper description and code comments to explain that we
   use NULL target value to distinguish multicast and unicast
   forwarding.
e) Update memory model, memory id and frame_sz in xdpf_clone().

v4: Fix bpf_xdp_redirect_map_multi_proto arg2_type typo

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
 include/linux/bpf.h            |  20 +++++
 include/linux/filter.h         |   1 +
 include/net/xdp.h              |   1 +
 include/uapi/linux/bpf.h       |  22 +++++
 kernel/bpf/devmap.c            | 154 +++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c          |   6 ++
 net/core/filter.c              | 109 +++++++++++++++++++++--
 net/core/xdp.c                 |  29 +++++++
 tools/include/uapi/linux/bpf.h |  22 +++++
 9 files changed, 359 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 0cd7f6884c5c..b48d587b8b3b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1264,6 +1264,11 @@ int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
 int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
+bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map,
+			int exclude_ifindex);
+int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+			  struct bpf_map *map, struct bpf_map *ex_map,
+			  u32 flags);
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog);
 bool dev_map_can_have_prog(struct bpf_map *map);
@@ -1406,6 +1411,21 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
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
+			  u32 flags)
+{
+	return 0;
+}
+
 struct sk_buff;
 
 static inline int dev_map_generic_redirect(struct bpf_dtab_netdev *dst,
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 259377723603..cf5b5b1d9ae5 100644
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
index 609f819ed08b..deb6c104e698 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -110,6 +110,7 @@ void xdp_warn(const char *msg, const char *func, const int line);
 #define XDP_WARN(msg) xdp_warn(msg, __func__, __LINE__)
 
 struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
+struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf);
 
 static inline
 void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 548a749aebb3..a14e41309e73 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3319,6 +3319,22 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ * long bpf_redirect_map_multi(struct bpf_map *map, struct bpf_map *ex_map, u64 flags)
+ * 	Description
+ * 		This is a multicast implementation for XDP redirect. It will
+ * 		redirect the packet to ALL the interfaces in *map*, but
+ * 		exclude the interfaces in *ex_map*.
+ *
+ * 		Currently the *flags* only supports *BPF_F_EXCLUDE_INGRESS*,
+ * 		which additionally excludes the current ingress device.
+ *
+ * 		See also bpf_redirect_map() as a unicast implementation,
+ * 		which supports redirecting packet to a specific ifindex
+ * 		in the map. As both helpers use struct bpf_redirect_info
+ * 		to store the redirect info, we will use a a NULL tgt_value
+ * 		to distinguish multicast and unicast redirecting.
+ * 	Return
+ * 		**XDP_REDIRECT** on success, or **XDP_ABORTED** on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3463,6 +3479,7 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(redirect_map_multi),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -3624,6 +3641,11 @@ enum bpf_lwt_encap_mode {
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
index 10abb06065bb..617a51391971 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -512,6 +512,160 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 	return __xdp_enqueue(dev, xdp, dev_rx);
 }
 
+/* Use direct call in fast path instead of map->ops->map_get_next_key() */
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
+	struct bpf_dtab_netdev *ex_obj = NULL;
+	u32 key, next_key;
+	int err;
+
+	if (obj->dev->ifindex == exclude_ifindex)
+		return true;
+
+	if (!map)
+		return false;
+
+	err = devmap_get_next_key(map, NULL, &key);
+	if (err)
+		return false;
+
+	for (;;) {
+		switch (map->map_type) {
+		case BPF_MAP_TYPE_DEVMAP:
+			ex_obj = __dev_map_lookup_elem(map, key);
+			break;
+		case BPF_MAP_TYPE_DEVMAP_HASH:
+			ex_obj = __dev_map_hash_lookup_elem(map, key);
+			break;
+		default:
+			break;
+		}
+
+		if (ex_obj && ex_obj->dev->ifindex == obj->dev->ifindex)
+			return true;
+
+		err = devmap_get_next_key(map, &key, &next_key);
+		if (err)
+			break;
+
+		key = next_key;
+	}
+
+	return false;
+}
+
+static struct bpf_dtab_netdev *devmap_get_next_obj(struct xdp_buff *xdp, struct bpf_map *map,
+						   struct bpf_map *ex_map, u32 *key,
+						   u32 *next_key, int ex_ifindex)
+{
+	struct bpf_dtab_netdev *obj;
+	struct net_device *dev;
+	u32 *tmp_key = key;
+	int err;
+
+	err = devmap_get_next_key(map, tmp_key, next_key);
+	if (err)
+		return NULL;
+
+	for (;;) {
+		switch (map->map_type) {
+		case BPF_MAP_TYPE_DEVMAP:
+			obj = __dev_map_lookup_elem(map, *next_key);
+			break;
+		case BPF_MAP_TYPE_DEVMAP_HASH:
+			obj = __dev_map_hash_lookup_elem(map, *next_key);
+			break;
+		default:
+			break;
+		}
+
+		if (!obj || dev_in_exclude_map(obj, ex_map, ex_ifindex))
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
+		return obj;
+
+find_next:
+		tmp_key = next_key;
+		err = devmap_get_next_key(map, tmp_key, next_key);
+		if (err)
+			break;
+	}
+
+	return NULL;
+}
+
+int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+			  struct bpf_map *map, struct bpf_map *ex_map,
+			  u32 flags)
+{
+	struct bpf_dtab_netdev *obj = NULL, *next_obj = NULL;
+	struct xdp_frame *xdpf, *nxdpf;
+	bool last_one = false;
+	int ex_ifindex;
+	u32 key, next_key;
+
+	ex_ifindex = flags & BPF_F_EXCLUDE_INGRESS ? dev_rx->ifindex : 0;
+
+	/* Find first available obj */
+	obj = devmap_get_next_obj(xdp, map, ex_map, NULL, &key, ex_ifindex);
+	if (!obj)
+		return 0;
+
+	xdpf = xdp_convert_buff_to_frame(xdp);
+	if (unlikely(!xdpf))
+		return -EOVERFLOW;
+
+	for (;;) {
+		/* Check if we still have one more available obj */
+		next_obj = devmap_get_next_obj(xdp, map, ex_map, &key,
+					       &next_key, ex_ifindex);
+		if (!next_obj)
+			last_one = true;
+
+		if (last_one) {
+			bq_enqueue(obj->dev, xdpf, dev_rx);
+			return 0;
+		}
+
+		nxdpf = xdpf_clone(xdpf);
+		if (unlikely(!nxdpf)) {
+			xdp_return_frame_rx_napi(xdpf);
+			return -ENOMEM;
+		}
+
+		bq_enqueue(obj->dev, nxdpf, dev_rx);
+
+		/* Deal with next obj */
+		obj = next_obj;
+		key = next_key;
+	}
+}
+
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b608185e1ffd..ceaf28ec111a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4110,6 +4110,7 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_MAP_TYPE_DEVMAP:
 	case BPF_MAP_TYPE_DEVMAP_HASH:
 		if (func_id != BPF_FUNC_redirect_map &&
+		    func_id != BPF_FUNC_redirect_map_multi &&
 		    func_id != BPF_FUNC_map_lookup_elem)
 			goto error;
 		break;
@@ -4202,6 +4203,11 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
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
index ddcc0d6209e1..673d12a051ef 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3515,12 +3515,19 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
 };
 
 static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
-			    struct bpf_map *map, struct xdp_buff *xdp)
+			    struct bpf_map *map, struct xdp_buff *xdp,
+			    struct bpf_map *ex_map, u32 flags)
 {
 	switch (map->map_type) {
 	case BPF_MAP_TYPE_DEVMAP:
 	case BPF_MAP_TYPE_DEVMAP_HASH:
-		return dev_map_enqueue(fwd, xdp, dev_rx);
+		/* We use a NULL fwd value to distinguish multicast
+		 * and unicast forwarding
+		 */
+		if (fwd)
+			return dev_map_enqueue(fwd, xdp, dev_rx);
+		else
+			return dev_map_enqueue_multi(xdp, dev_rx, map, ex_map, flags);
 	case BPF_MAP_TYPE_CPUMAP:
 		return cpu_map_enqueue(fwd, xdp, dev_rx);
 	case BPF_MAP_TYPE_XSKMAP:
@@ -3577,12 +3584,14 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 	struct bpf_map *map = READ_ONCE(ri->map);
+	struct bpf_map *ex_map = ri->ex_map;
 	u32 index = ri->tgt_index;
 	void *fwd = ri->tgt_value;
 	int err;
 
 	ri->tgt_index = 0;
 	ri->tgt_value = NULL;
+	ri->ex_map = NULL;
 	WRITE_ONCE(ri->map, NULL);
 
 	if (unlikely(!map)) {
@@ -3594,7 +3603,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 
 		err = dev_xdp_enqueue(fwd, xdp, dev);
 	} else {
-		err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
+		err = __bpf_tx_xdp_map(dev, fwd, map, xdp, ex_map, ri->flags);
 	}
 
 	if (unlikely(err))
@@ -3608,6 +3617,55 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 }
 EXPORT_SYMBOL_GPL(xdp_do_redirect);
 
+static int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
+				  struct bpf_prog *xdp_prog,
+				  struct bpf_map *map, struct bpf_map *ex_map,
+				  u32 flags)
+
+{
+	struct bpf_dtab_netdev *dst;
+	struct sk_buff *nskb;
+	bool exclude_ingress;
+	u32 key, next_key;
+	void *fwd;
+	int err;
+
+	/* Get first key from forward map */
+	err = map->ops->map_get_next_key(map, NULL, &key);
+	if (err)
+		return err;
+
+	exclude_ingress = !!(flags & BPF_F_EXCLUDE_INGRESS);
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
+			/* Try forword next one no mater the current forward
+			 * succeed or not */
+			dev_map_generic_redirect(dst, nskb, xdp_prog);
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
@@ -3615,19 +3673,30 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       struct bpf_map *map)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
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
+		/* We use a NULL fwd value to distinguish multicast
+		 * and unicast forwarding
+		 */
+		if (fwd) {
+			struct bpf_dtab_netdev *dst = fwd;
+
+			err = dev_map_generic_redirect(dst, skb, xdp_prog);
+		} else {
+			err = dev_map_redirect_multi(dev, skb, xdp_prog, map,
+						     ex_map, ri->flags);
+		}
 
-		err = dev_map_generic_redirect(dst, skb, xdp_prog);
 		if (unlikely(err))
 			goto err;
 	} else if (map->map_type == BPF_MAP_TYPE_XSKMAP) {
@@ -3741,6 +3810,34 @@ static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
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
+	/* Set the tgt_value to NULL to distinguish with bpf_xdp_redirect_map */
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
+	.arg2_type      = ARG_CONST_MAP_PTR,
+	.arg3_type      = ARG_ANYTHING,
+};
+
 static unsigned long bpf_skb_copy(void *dst_buff, const void *skb,
 				  unsigned long off, unsigned long len)
 {
@@ -6464,6 +6561,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_redirect_proto;
 	case BPF_FUNC_redirect_map:
 		return &bpf_xdp_redirect_map_proto;
+	case BPF_FUNC_redirect_map_multi:
+		return &bpf_xdp_redirect_map_multi_proto;
 	case BPF_FUNC_xdp_adjust_tail:
 		return &bpf_xdp_adjust_tail_proto;
 	case BPF_FUNC_fib_lookup:
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 3c45f99e26d5..9b43d0a208a7 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -476,3 +476,32 @@ void xdp_warn(const char *msg, const char *func, const int line)
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
+	nxdpf->frame_sz = PAGE_SIZE;
+	nxdpf->mem.type = MEM_TYPE_PAGE_ORDER0;
+	nxdpf->mem.id = 0;
+
+	return nxdpf;
+}
+EXPORT_SYMBOL_GPL(xdpf_clone);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 548a749aebb3..a14e41309e73 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3319,6 +3319,22 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ * long bpf_redirect_map_multi(struct bpf_map *map, struct bpf_map *ex_map, u64 flags)
+ * 	Description
+ * 		This is a multicast implementation for XDP redirect. It will
+ * 		redirect the packet to ALL the interfaces in *map*, but
+ * 		exclude the interfaces in *ex_map*.
+ *
+ * 		Currently the *flags* only supports *BPF_F_EXCLUDE_INGRESS*,
+ * 		which additionally excludes the current ingress device.
+ *
+ * 		See also bpf_redirect_map() as a unicast implementation,
+ * 		which supports redirecting packet to a specific ifindex
+ * 		in the map. As both helpers use struct bpf_redirect_info
+ * 		to store the redirect info, we will use a a NULL tgt_value
+ * 		to distinguish multicast and unicast redirecting.
+ * 	Return
+ * 		**XDP_REDIRECT** on success, or **XDP_ABORTED** on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3463,6 +3479,7 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(redirect_map_multi),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -3624,6 +3641,11 @@ enum bpf_lwt_encap_mode {
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

