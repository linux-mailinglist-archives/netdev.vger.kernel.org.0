Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111CD59703
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 11:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfF1JMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 05:12:41 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42833 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfF1JMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 05:12:40 -0400
Received: by mail-ed1-f66.google.com with SMTP id z25so10020494edq.9
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 02:12:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=om0akaaUdoQwuZ3hexhLblJmqMNhPd/yLc6ZJMmtB0I=;
        b=bLiTrkmxfsR3W+LGR4YeR7djRk4OTJuLmbZf6+Jf/E6Li4pQlIq65NMcRbRc7oZw0A
         1xjr6F3zS0VJpIsJIbQTjJLUYAEvkO9S+IgrrPvp2ztF/lgdiextwjDAO+JCL8hUBwTI
         qo1FzoxOLBDuO4h1eZ2nqWR2poBm6YoxDshxZtaa68U62v/nq2MDeXUtk7OAALgsB9l0
         E6iymOfnBvae5YLU7hh1aquAfTJR1p2dSZVcq9YYBFc3q0Ma301EJIEyLidJGSkGEHjV
         9iAgf8jlrIBNiodriha+TaXRqbOSBS+Db3gM4ws0AYKK0NbqhS4wWTDB6oLzubrVKkc+
         PnhQ==
X-Gm-Message-State: APjAAAV+9i2VglKZ2Da410kwrrx67qLTc5rcN3LrkAFPSdcd2RlaitkE
        TYCBvZc3Ddde6JyUpJaY71VOww==
X-Google-Smtp-Source: APXvYqx0puuwLV1ENiyFTzSBL43XLBUz8L5Lb2bMe7YU5n2MgRmFJtuxjkT+eCsdGuFLolHThOdXzg==
X-Received: by 2002:a17:906:1dcc:: with SMTP id v12mr7633197ejh.110.1561713157591;
        Fri, 28 Jun 2019 02:12:37 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id n15sm507836edd.49.2019.06.28.02.12.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:12:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 02AC0181CAB; Fri, 28 Jun 2019 11:12:35 +0200 (CEST)
Subject: [PATCH bpf-next v6 4/5] bpf_xdp_redirect_map: Perform map lookup in
 eBPF helper
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Fri, 28 Jun 2019 11:12:34 +0200
Message-ID: <156171315494.9468.11139252807255216312.stgit@alrua-x1>
In-Reply-To: <156171315462.9468.3367572649463706996.stgit@alrua-x1>
References: <156171315462.9468.3367572649463706996.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The bpf_redirect_map() helper used by XDP programs doesn't return any
indication of whether it can successfully redirect to the map index it was
given. Instead, BPF programs have to track this themselves, leading to
programs using duplicate maps to track which entries are populated in the
devmap.

This patch fixes this by moving the map lookup into the bpf_redirect_map()
helper, which makes it possible to return failure to the eBPF program. The
lower bits of the flags argument is used as the return code, which means
that existing users who pass a '0' flag argument will get XDP_ABORTED.

With this, a BPF program can check the return code from the helper call and
react by, for instance, substituting a different redirect. This works for
any type of map used for redirect.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/filter.h     |    1 +
 include/trace/events/xdp.h |    5 ++---
 include/uapi/linux/bpf.h   |    7 +++++--
 net/core/filter.c          |   32 ++++++++++++++++++--------------
 4 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index af8601340dae..f2a03f232386 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -580,6 +580,7 @@ struct bpf_skb_data_end {
 struct bpf_redirect_info {
 	u32 flags;
 	u32 tgt_index;
+	void *tgt_value;
 	struct bpf_map *map;
 	struct bpf_map *map_to_flush;
 	u32 kern_flags;
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index bb5e380e2ef3..393f3d7ca819 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -146,9 +146,8 @@ struct _bpf_dtab_netdev {
 #endif /* __DEVMAP_OBJ_TYPE */
 
 #define devmap_ifindex(fwd, map)				\
-	(!fwd ? 0 :						\
-	 ((map->map_type == BPF_MAP_TYPE_DEVMAP) ?		\
-	  ((struct _bpf_dtab_netdev *)fwd)->dev->ifindex : 0))
+	((map->map_type == BPF_MAP_TYPE_DEVMAP) ?		\
+	  ((struct _bpf_dtab_netdev *)fwd)->dev->ifindex : 0)
 
 #define _trace_xdp_redirect_map(dev, xdp, fwd, map, idx)		\
 	 trace_xdp_redirect_map(dev, xdp, devmap_ifindex(fwd, map),	\
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b077507efa3f..59f3fe61b2b0 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1568,8 +1568,11 @@ union bpf_attr {
  * 		but this is only implemented for native XDP (with driver
  * 		support) as of this writing).
  *
- * 		All values for *flags* are reserved for future usage, and must
- * 		be left at zero.
+ * 		The lower two bits of *flags* are used as the return code if
+ * 		the map lookup fails. This is so that the return value can be
+ * 		one of the XDP program return codes up to XDP_TX, as chosen by
+ * 		the caller. Any higher bits in the *flags* argument must be
+ * 		unset.
  *
  * 		When used to redirect packets to net devices, this helper
  * 		provides a high performance increase over **bpf_redirect**\ ().
diff --git a/net/core/filter.c b/net/core/filter.c
index 1d7f5f7f32cf..f9fcc8168e1c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3605,17 +3605,13 @@ static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
 			       struct bpf_redirect_info *ri)
 {
 	u32 index = ri->tgt_index;
-	void *fwd = NULL;
+	void *fwd = ri->tgt_value;
 	int err;
 
 	ri->tgt_index = 0;
+	ri->tgt_value = NULL;
 	WRITE_ONCE(ri->map, NULL);
 
-	fwd = __xdp_map_lookup_elem(map, index);
-	if (unlikely(!fwd)) {
-		err = -EINVAL;
-		goto err;
-	}
 	if (ri->map_to_flush && unlikely(ri->map_to_flush != map))
 		xdp_do_flush_map();
 
@@ -3652,18 +3648,13 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 	u32 index = ri->tgt_index;
-	void *fwd = NULL;
+	void *fwd = ri->tgt_value;
 	int err = 0;
 
 	ri->tgt_index = 0;
+	ri->tgt_value = NULL;
 	WRITE_ONCE(ri->map, NULL);
 
-	fwd = __xdp_map_lookup_elem(map, index);
-	if (unlikely(!fwd)) {
-		err = -EINVAL;
-		goto err;
-	}
-
 	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
 		struct bpf_dtab_netdev *dst = fwd;
 
@@ -3732,6 +3723,7 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
 
 	ri->flags = flags;
 	ri->tgt_index = ifindex;
+	ri->tgt_value = NULL;
 	WRITE_ONCE(ri->map, NULL);
 
 	return XDP_REDIRECT;
@@ -3750,9 +3742,21 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 
-	if (unlikely(flags))
+	/* Lower bits of the flags are used as return code on lookup failure */
+	if (unlikely(flags > XDP_TX))
 		return XDP_ABORTED;
 
+	ri->tgt_value = __xdp_map_lookup_elem(map, ifindex);
+	if (unlikely(!ri->tgt_value)) {
+		/* If the lookup fails we want to clear out the state in the
+		 * redirect_info struct completely, so that if an eBPF program
+		 * performs multiple lookups, the last one always takes
+		 * precedence.
+		 */
+		WRITE_ONCE(ri->map, NULL);
+		return flags;
+	}
+
 	ri->flags = flags;
 	ri->tgt_index = ifindex;
 	WRITE_ONCE(ri->map, map);

