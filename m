Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B43220DAC
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 15:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731450AbgGONIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 09:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729900AbgGONIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 09:08:49 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A27C061755;
        Wed, 15 Jul 2020 06:08:48 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d4so3051866pgk.4;
        Wed, 15 Jul 2020 06:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aRHMNTv8z+Wwy6cMtx2tu7zxIrTfXWxsSMoECJcA2iU=;
        b=Yzfsk+brqvWnhecbfZl/ndzJnZdwhYED35Tu7qPLOqEQ1n5N+KWOyeD5fKD5okRJ+C
         on8NsKclAM+/Ng3327GrJ3oQv03qM1aYx84wtDokLbF9IOCjGoSjaTz/gtfgTg7BATPO
         E42tAHSyAtdUuxzM5So3UOzTNsNP1aY0jrdIb88A9l15masW8jl8p9m3Mm2dHS7DIEz5
         pXEln767L15Om5v0FymX6Vfv3BbwXBS+QqT8iTRhMH4uahP4FDazhrheQ7rFvexpRERt
         TX0VpR+JWkrYWElWGdkgHGo793xBsQO016KRP6SubEIoL6l30TnYmxEfk4SScFiRyLBW
         05fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aRHMNTv8z+Wwy6cMtx2tu7zxIrTfXWxsSMoECJcA2iU=;
        b=WevmlUC/HBQTaK2IKQhAy0ajVPzLLh/Qy6DTkMULdy+TrQbIZJmTfZgHC40urYGWxE
         Ybv6aFujJ8Zhw8pgNO7Ce0nw41y+nUppl9NfCIMjVSj7TgU8wwQsJbVFmzwaxrEnhm4Y
         erLsb6uaJlsKBlsh3pbYKQP7xXK4hzIgN1+jfX085eoUPr0fddQxUPtXZ5tCOsesPH3F
         BTdjrQemMWe27Q/FmTsGdnOKtVpSWyLpaYYs9AED32qOjC76qK//jLDekjvpyPQiMCRx
         nJ4mHqIV2ky76iFFUK+7TXXuAVe2MKlsz7jgdGW1Rp0dWXzhIlDW60shI0qjxZI5ZVFl
         VosQ==
X-Gm-Message-State: AOAM531cWIoeZHb5qu571airHJM/Ko+qvMtKp3NnxuBBp+anmlYwvlW7
        d7NkCyyd3bVQR1FGRlSMzLXGZzQ2iKCX6Q==
X-Google-Smtp-Source: ABdhPJyWltkloWh52moNLfu8E1LPfgBKUN2R1LkZWZj42ij42j5M8jDmho3CBe9e7OPqU+5ALnHXNg==
X-Received: by 2002:a63:e018:: with SMTP id e24mr7885118pgh.175.1594818527168;
        Wed, 15 Jul 2020 06:08:47 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t126sm2167700pfd.214.2020.07.15.06.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 06:08:45 -0700 (PDT)
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
Subject: [PATCHv8 bpf-next 1/3] xdp: add a new helper for dev map multicast support
Date:   Wed, 15 Jul 2020 21:08:14 +0800
Message-Id: <20200715130816.2124232-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200715130816.2124232-1-liuhangbin@gmail.com>
References: <20200714063257.1694964-1-liuhangbin@gmail.com>
 <20200715130816.2124232-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is for xdp multicast support. which has been discussed
before[0], The goal is to be able to implement an OVS-like data plane in
XDP, i.e., a software switch that can forward XDP frames to multiple ports.

To achieve this, an application needs to specify a group of interfaces
to forward a packet to. It is also common to want to exclude one or more
physical interfaces from the forwarding operation - e.g., to forward a
packet to all interfaces in the multicast group except the interface it
arrived on. While this could be done simply by adding more groups, this
quickly leads to a combinatorial explosion in the number of groups an
application has to maintain.

To avoid the combinatorial explosion, we propose to include the ability
to specify an "exclude group" as part of the forwarding operation. This
needs to be a group (instead of just a single port index), because a
physical interface can be part of a logical grouping, such as a bond
device.

Thus, the logical forwarding operation becomes a "set difference"
operation, i.e. "forward to all ports in group A that are not also in
group B". This series implements such an operation using device maps to
represent the groups. This means that the XDP program specifies two
device maps, one containing the list of netdevs to redirect to, and the
other containing the exclude list.

To achieve this, I re-implement a new helper bpf_redirect_map_multi()
to accept two maps, the forwarding map and exclude map. The forwarding
map could be DEVMAP or DEVMAP_HASH, but the exclude map *must* be
DEVMAP_HASH to get better performace. If user don't want to use exclude
map and just want simply stop redirecting back to ingress device, they
can use flag BPF_F_EXCLUDE_INGRESS.

As both bpf_xdp_redirect_map() and this new helpers are using struct
bpf_redirect_info, I add a new ex_map and set tgt_value to NULL in the
new helper to make a difference with bpf_xdp_redirect_map().

Also I keep the the general data path in net/core/filter.c, the native data
path in kernel/bpf/devmap.c so we can use direct calls to get better
performace.

[0] https://xdp-project.net/#Handling-multicast

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v8:
a) Update function dev_in_exclude_map():
   - remove duplicate ex_map map_type check in
   - lookup the element in dev map by obj dev index directly instead
     of looping all the map

v7:
a) Fix helper flag check
b) Limit the *ex_map* to use DEVMAP_HASH only and update function
   dev_in_exclude_map() to get better performance.

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
---
 include/linux/bpf.h            |  20 ++++++
 include/linux/filter.h         |   1 +
 include/net/xdp.h              |   1 +
 include/uapi/linux/bpf.h       |  26 +++++++
 kernel/bpf/devmap.c            | 124 +++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c          |   6 ++
 net/core/filter.c              | 111 +++++++++++++++++++++++++++--
 net/core/xdp.c                 |  29 ++++++++
 tools/include/uapi/linux/bpf.h |  26 +++++++
 9 files changed, 339 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c67c88ad35f8..ed1dc0a084f5 100644
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
index 0b0144752d78..cf7debed9bc0 100644
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
index 5e386389913a..54d5b42d282c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3320,6 +3320,26 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ * long bpf_redirect_map_multi(struct bpf_map *map, struct bpf_map *ex_map, u64 flags)
+ * 	Description
+ * 		This is a multicast implementation for XDP redirect. It will
+ * 		redirect the packet to ALL the interfaces in *map*, but
+ * 		exclude the interfaces in *ex_map*.
+ *
+ * 		The frowarding *map* could be either BPF_MAP_TYPE_DEVMAP or
+ * 		BPF_MAP_TYPE_DEVMAP_HASH. But the *ex_map* must be
+ * 		BPF_MAP_TYPE_DEVMAP_HASH to get better performance.
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
@@ -3464,6 +3484,7 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(redirect_map_multi),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -3625,6 +3646,11 @@ enum bpf_lwt_encap_mode {
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
index 10abb06065bb..1e6695f38f78 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -512,6 +512,130 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
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
+	if (obj->dev->ifindex == exclude_ifindex)
+		return true;
+
+	if (!map)
+		return false;
+
+	return __dev_map_hash_lookup_elem(map, obj->dev->ifindex) != NULL;
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
index 3c1efc9d08fd..487f973e1d64 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4109,6 +4109,7 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_MAP_TYPE_DEVMAP:
 	case BPF_MAP_TYPE_DEVMAP_HASH:
 		if (func_id != BPF_FUNC_redirect_map &&
+		    func_id != BPF_FUNC_redirect_map_multi &&
 		    func_id != BPF_FUNC_map_lookup_elem)
 			goto error;
 		break;
@@ -4201,6 +4202,11 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
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
index bdd2382e655d..9fc5ec554647 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3516,12 +3516,19 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
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
@@ -3578,12 +3585,14 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
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
@@ -3595,7 +3604,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 
 		err = dev_xdp_enqueue(fwd, xdp, dev);
 	} else {
-		err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
+		err = __bpf_tx_xdp_map(dev, fwd, map, xdp, ex_map, ri->flags);
 	}
 
 	if (unlikely(err))
@@ -3609,6 +3618,55 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
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
@@ -3616,19 +3674,30 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
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
@@ -3742,6 +3811,36 @@ static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
 	.arg3_type      = ARG_ANYTHING,
 };
 
+BPF_CALL_3(bpf_xdp_redirect_map_multi, struct bpf_map *, map,
+	   struct bpf_map *, ex_map, u64, flags)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+
+	/* Limit ex_map type to DEVMAP_HASH to get better performance */
+	if (unlikely(!map || ex_map->map_type != BPF_MAP_TYPE_DEVMAP_HASH ||
+		     flags & ~BPF_F_EXCLUDE_INGRESS))
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
@@ -6473,6 +6572,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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
index 5e386389913a..54d5b42d282c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3320,6 +3320,26 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ * long bpf_redirect_map_multi(struct bpf_map *map, struct bpf_map *ex_map, u64 flags)
+ * 	Description
+ * 		This is a multicast implementation for XDP redirect. It will
+ * 		redirect the packet to ALL the interfaces in *map*, but
+ * 		exclude the interfaces in *ex_map*.
+ *
+ * 		The frowarding *map* could be either BPF_MAP_TYPE_DEVMAP or
+ * 		BPF_MAP_TYPE_DEVMAP_HASH. But the *ex_map* must be
+ * 		BPF_MAP_TYPE_DEVMAP_HASH to get better performance.
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
@@ -3464,6 +3484,7 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(redirect_map_multi),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -3625,6 +3646,11 @@ enum bpf_lwt_encap_mode {
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

