Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5379313DEB6
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 16:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgAPPWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 10:22:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52723 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729030AbgAPPWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 10:22:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579188166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qTz88aMEHmhi3MF7P1h7eho3i+lh7GrgNE8r6SuzHxk=;
        b=T9iaFna7JRce0zPUEMX/SxfxpKBKOPnx+lD5peEZ7i9rp/CvuqNOPyhl/2GVvlheI6mTcj
        dMnWiaJ/F89fHK6pchnla2WbYnVjvkzv8CcecXfJkPszUwqdbFxhJYq32jD1qpdRYqdoqP
        j0+zEHr7zIXMf973i0jjD4cOh+SdCbk=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-g0GD0uPvN9KMwWRC-svHlA-1; Thu, 16 Jan 2020 10:22:45 -0500
X-MC-Unique: g0GD0uPvN9KMwWRC-svHlA-1
Received: by mail-lf1-f69.google.com with SMTP id c16so3822653lfm.10
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 07:22:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qTz88aMEHmhi3MF7P1h7eho3i+lh7GrgNE8r6SuzHxk=;
        b=hysiUhsMdZOATxzE6UtCZ/kupIrSHQjEdL13kcLHatrtKng0ecSDpKyAGpJjiUuCHc
         TWeUcslANmXNESmDPth3FOpISMO4QVpbxP4WjmDDHSw9P5/7f4depdbitqavAm9R+Kqx
         73DwTJX+3MmCcLeN1wrLrkMwqGZ/QTIKwWB6qrwlN9X7dMGk9X8WAKhXhXlHSiMPIVDH
         sJxvDpQrC7autFlBbVnh4mFxVjZIT/Vf4Wn8h03L+J1/zjaKzlJkuSILceK22c0iehzg
         RDjeIn30XwUQ6lMM2i3vsDq6lhBwAmVL7UZC+alxuIGLHRH+arJ63XNGCboL/JGwT8cn
         /PIA==
X-Gm-Message-State: APjAAAVXQlOpL3tu1HxAEWcspJp5YH/9WicUEsq+QO2lc2bECe720Qfr
        erf64W7CQqhGU9XkCAEivKphgyUgPA45WhCGYtvN5GrY6oMmkfxOmYHKtnGDMzT3Z5X3Zj4FPhR
        Wc6+aLzb6tOdGq/7W
X-Received: by 2002:a19:23cb:: with SMTP id j194mr2535524lfj.79.1579188163265;
        Thu, 16 Jan 2020 07:22:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqzoOQsgy9a/x5lqF1VMaCgwRhjNI73QREB9H6a5Lus/qwXJLcFvAM4qQwI1lUWZdpbY/BM9sA==
X-Received: by 2002:a19:23cb:: with SMTP id j194mr2535503lfj.79.1579188162827;
        Thu, 16 Jan 2020 07:22:42 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g85sm10745203lfd.66.2020.01.16.07.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 07:22:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 20D881804D6; Thu, 16 Jan 2020 16:14:45 +0100 (CET)
Subject: [PATCH bpf-next v3 2/3] xdp: Use bulking for non-map XDP_REDIRECT and
 consolidate code paths
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date:   Thu, 16 Jan 2020 16:14:45 +0100
Message-ID: <157918768505.1458396.17518057312953572912.stgit@toke.dk>
In-Reply-To: <157918768284.1458396.8128704597152008763.stgit@toke.dk>
References: <157918768284.1458396.8128704597152008763.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Since the bulk queue used by XDP_REDIRECT now lives in struct net_device,
we can re-use the bulking for the non-map version of the bpf_redirect()
helper. This is a simple matter of having xdp_do_redirect_slow() queue the
frame on the bulk queue instead of sending it out with __bpf_tx_xdp().

Unfortunately we can't make the bpf_redirect() helper return an error if
the ifindex doesn't exit (as bpf_redirect_map() does), because we don't
have a reference to the network namespace of the ingress device at the time
the helper is called. So we have to leave it as-is and keep the device
lookup in xdp_do_redirect_slow().

Since this leaves less reason to have the non-map redirect code in a
separate function, so we get rid of the xdp_do_redirect_slow() function
entirely. This does lose us the tracepoint disambiguation, but fortunately
the xdp_redirect and xdp_redirect_map tracepoints use the same tracepoint
entry structures. This means both can contain a map index, so we can just
amend the tracepoint definitions so we always emit the xdp_redirect(_err)
tracepoints, but with the map ID only populated if a map is present. This
means we retire the xdp_redirect_map(_err) tracepoints entirely, but keep
the definitions around in case someone is still listening for them.

With this change, the performance of the xdp_redirect sample program goes
from 5Mpps to 8.4Mpps (a 68% increase).

Since the flush functions are no longer map-specific, rename the flush()
functions to drop _map from their names. One of the renamed functions is
the xdp_do_flush_map() callback used in all the xdp-enabled drivers. To
keep from having to update all drivers, use a #define to keep the old name
working, and only update the virtual drivers in this patch.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/tun.c          |    4 +-
 drivers/net/veth.c         |    2 -
 drivers/net/virtio_net.c   |    2 -
 include/linux/bpf.h        |   13 +++++-
 include/linux/filter.h     |   10 +++-
 include/trace/events/xdp.h |  101 +++++++++++++++++++-------------------------
 kernel/bpf/devmap.c        |   32 ++++++++++----
 net/core/filter.c          |   90 ++++++++-------------------------------
 8 files changed, 108 insertions(+), 146 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 683d371e6e82..3a5a6c655dda 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1718,7 +1718,7 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 		if (err < 0)
 			goto err_xdp;
 		if (err == XDP_REDIRECT)
-			xdp_do_flush_map();
+			xdp_do_flush();
 		if (err != XDP_PASS)
 			goto out;
 
@@ -2549,7 +2549,7 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 		}
 
 		if (flush)
-			xdp_do_flush_map();
+			xdp_do_flush();
 
 		rcu_read_unlock();
 		local_bh_enable();
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index a552df37a347..1c89017beebb 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -769,7 +769,7 @@ static int veth_poll(struct napi_struct *napi, int budget)
 	if (xdp_xmit & VETH_XDP_TX)
 		veth_xdp_flush(rq->dev, &bq);
 	if (xdp_xmit & VETH_XDP_REDIR)
-		xdp_do_flush_map();
+		xdp_do_flush();
 	xdp_clear_return_frame_no_direct();
 
 	return done;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4d7d5434cc5d..c458cd313281 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1432,7 +1432,7 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 		virtqueue_napi_complete(napi, rq->vq, received);
 
 	if (xdp_xmit & VIRTIO_XDP_REDIR)
-		xdp_do_flush_map();
+		xdp_do_flush();
 
 	if (xdp_xmit & VIRTIO_XDP_TX) {
 		sq = virtnet_xdp_sq(vi);
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3517e32149a4..8e3b8f4ad183 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1056,7 +1056,9 @@ struct sk_buff;
 
 struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key);
 struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key);
-void __dev_map_flush(void);
+void __dev_flush(void);
+int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
+		    struct net_device *dev_rx);
 int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
@@ -1169,13 +1171,20 @@ static inline struct net_device  *__dev_map_hash_lookup_elem(struct bpf_map *map
 	return NULL;
 }
 
-static inline void __dev_map_flush(void)
+static inline void __dev_flush(void)
 {
 }
 
 struct xdp_buff;
 struct bpf_dtab_netdev;
 
+static inline
+int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
+		    struct net_device *dev_rx)
+{
+	return 0;
+}
+
 static inline
 int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 		    struct net_device *dev_rx)
diff --git a/include/linux/filter.h b/include/linux/filter.h
index a366a0b64a57..f349e2c0884c 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -918,7 +918,7 @@ static inline int xdp_ok_fwd_dev(const struct net_device *fwd,
 	return 0;
 }
 
-/* The pair of xdp_do_redirect and xdp_do_flush_map MUST be called in the
+/* The pair of xdp_do_redirect and xdp_do_flush MUST be called in the
  * same cpu context. Further for best results no more than a single map
  * for the do_redirect/do_flush pair should be used. This limitation is
  * because we only track one map and force a flush when the map changes.
@@ -929,7 +929,13 @@ int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
 int xdp_do_redirect(struct net_device *dev,
 		    struct xdp_buff *xdp,
 		    struct bpf_prog *prog);
-void xdp_do_flush_map(void);
+void xdp_do_flush(void);
+
+/* The xdp_do_flush_map() helper has been renamed to drop the _map suffix, as
+ * it is no longer only flushing maps. Keep this define for compatibility
+ * until all drivers are updated - do not use xdp_do_flush_map() in new code!
+ */
+#define xdp_do_flush_map xdp_do_flush
 
 void bpf_warn_invalid_xdp_action(u32 act);
 
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index 72bad13d4a3c..b680973687b4 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -79,14 +79,26 @@ TRACE_EVENT(xdp_bulk_tx,
 		  __entry->sent, __entry->drops, __entry->err)
 );
 
+#ifndef __DEVMAP_OBJ_TYPE
+#define __DEVMAP_OBJ_TYPE
+struct _bpf_dtab_netdev {
+	struct net_device *dev;
+};
+#endif /* __DEVMAP_OBJ_TYPE */
+
+#define devmap_ifindex(tgt, map)				\
+	(((map->map_type == BPF_MAP_TYPE_DEVMAP ||	\
+		  map->map_type == BPF_MAP_TYPE_DEVMAP_HASH)) ? \
+	  ((struct _bpf_dtab_netdev *)tgt)->dev->ifindex : 0)
+
 DECLARE_EVENT_CLASS(xdp_redirect_template,
 
 	TP_PROTO(const struct net_device *dev,
 		 const struct bpf_prog *xdp,
-		 int to_ifindex, int err,
-		 const struct bpf_map *map, u32 map_index),
+		 const void *tgt, int err,
+		 const struct bpf_map *map, u32 index),
 
-	TP_ARGS(dev, xdp, to_ifindex, err, map, map_index),
+	TP_ARGS(dev, xdp, tgt, err, map, index),
 
 	TP_STRUCT__entry(
 		__field(int, prog_id)
@@ -103,90 +115,65 @@ DECLARE_EVENT_CLASS(xdp_redirect_template,
 		__entry->act		= XDP_REDIRECT;
 		__entry->ifindex	= dev->ifindex;
 		__entry->err		= err;
-		__entry->to_ifindex	= to_ifindex;
+		__entry->to_ifindex	= map ? devmap_ifindex(tgt, map) :
+						index;
 		__entry->map_id		= map ? map->id : 0;
-		__entry->map_index	= map_index;
+		__entry->map_index	= map ? index : 0;
 	),
 
-	TP_printk("prog_id=%d action=%s ifindex=%d to_ifindex=%d err=%d",
+	TP_printk("prog_id=%d action=%s ifindex=%d to_ifindex=%d err=%d"
+		  " map_id=%d map_index=%d",
 		  __entry->prog_id,
 		  __print_symbolic(__entry->act, __XDP_ACT_SYM_TAB),
 		  __entry->ifindex, __entry->to_ifindex,
-		  __entry->err)
+		  __entry->err, __entry->map_id, __entry->map_index)
 );
 
 DEFINE_EVENT(xdp_redirect_template, xdp_redirect,
 	TP_PROTO(const struct net_device *dev,
 		 const struct bpf_prog *xdp,
-		 int to_ifindex, int err,
-		 const struct bpf_map *map, u32 map_index),
-	TP_ARGS(dev, xdp, to_ifindex, err, map, map_index)
+		 const void *tgt, int err,
+		 const struct bpf_map *map, u32 index),
+	TP_ARGS(dev, xdp, tgt, err, map, index)
 );
 
 DEFINE_EVENT(xdp_redirect_template, xdp_redirect_err,
 	TP_PROTO(const struct net_device *dev,
 		 const struct bpf_prog *xdp,
-		 int to_ifindex, int err,
-		 const struct bpf_map *map, u32 map_index),
-	TP_ARGS(dev, xdp, to_ifindex, err, map, map_index)
+		 const void *tgt, int err,
+		 const struct bpf_map *map, u32 index),
+	TP_ARGS(dev, xdp, tgt, err, map, index)
 );
 
 #define _trace_xdp_redirect(dev, xdp, to)		\
-	 trace_xdp_redirect(dev, xdp, to, 0, NULL, 0);
+	 trace_xdp_redirect(dev, xdp, NULL, 0, NULL, to);
 
 #define _trace_xdp_redirect_err(dev, xdp, to, err)	\
-	 trace_xdp_redirect_err(dev, xdp, to, err, NULL, 0);
+	 trace_xdp_redirect_err(dev, xdp, NULL, err, NULL, to);
+
+#define _trace_xdp_redirect_map(dev, xdp, to, map, index)		\
+	 trace_xdp_redirect(dev, xdp, to, 0, map, index);
+
+#define _trace_xdp_redirect_map_err(dev, xdp, to, map, index, err)	\
+	 trace_xdp_redirect_err(dev, xdp, to, err, map, index);
 
-DEFINE_EVENT_PRINT(xdp_redirect_template, xdp_redirect_map,
+/* not used anymore, but kept around so as not to break old programs */
+DEFINE_EVENT(xdp_redirect_template, xdp_redirect_map,
 	TP_PROTO(const struct net_device *dev,
 		 const struct bpf_prog *xdp,
-		 int to_ifindex, int err,
-		 const struct bpf_map *map, u32 map_index),
-	TP_ARGS(dev, xdp, to_ifindex, err, map, map_index),
-	TP_printk("prog_id=%d action=%s ifindex=%d to_ifindex=%d err=%d"
-		  " map_id=%d map_index=%d",
-		  __entry->prog_id,
-		  __print_symbolic(__entry->act, __XDP_ACT_SYM_TAB),
-		  __entry->ifindex, __entry->to_ifindex,
-		  __entry->err,
-		  __entry->map_id, __entry->map_index)
+		 const void *tgt, int err,
+		 const struct bpf_map *map, u32 index),
+	TP_ARGS(dev, xdp, tgt, err, map, index)
 );
 
-DEFINE_EVENT_PRINT(xdp_redirect_template, xdp_redirect_map_err,
+DEFINE_EVENT(xdp_redirect_template, xdp_redirect_map_err,
 	TP_PROTO(const struct net_device *dev,
 		 const struct bpf_prog *xdp,
-		 int to_ifindex, int err,
-		 const struct bpf_map *map, u32 map_index),
-	TP_ARGS(dev, xdp, to_ifindex, err, map, map_index),
-	TP_printk("prog_id=%d action=%s ifindex=%d to_ifindex=%d err=%d"
-		  " map_id=%d map_index=%d",
-		  __entry->prog_id,
-		  __print_symbolic(__entry->act, __XDP_ACT_SYM_TAB),
-		  __entry->ifindex, __entry->to_ifindex,
-		  __entry->err,
-		  __entry->map_id, __entry->map_index)
+		 const void *tgt, int err,
+		 const struct bpf_map *map, u32 index),
+	TP_ARGS(dev, xdp, tgt, err, map, index)
 );
 
-#ifndef __DEVMAP_OBJ_TYPE
-#define __DEVMAP_OBJ_TYPE
-struct _bpf_dtab_netdev {
-	struct net_device *dev;
-};
-#endif /* __DEVMAP_OBJ_TYPE */
-
-#define devmap_ifindex(fwd, map)				\
-	((map->map_type == BPF_MAP_TYPE_DEVMAP ||		\
-	  map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) ?		\
-	  ((struct _bpf_dtab_netdev *)fwd)->dev->ifindex : 0)
-
-#define _trace_xdp_redirect_map(dev, xdp, fwd, map, idx)		\
-	 trace_xdp_redirect_map(dev, xdp, devmap_ifindex(fwd, map),	\
-				0, map, idx)
-
-#define _trace_xdp_redirect_map_err(dev, xdp, fwd, map, idx, err)	\
-	 trace_xdp_redirect_map_err(dev, xdp, devmap_ifindex(fwd, map),	\
-				    err, map, idx)
-
 TRACE_EVENT(xdp_cpumap_kthread,
 
 	TP_PROTO(int map_id, unsigned int processed,  unsigned int drops,
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 030d125c3839..d5311009953f 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -81,7 +81,7 @@ struct bpf_dtab {
 	u32 n_buckets;
 };
 
-static DEFINE_PER_CPU(struct list_head, dev_map_flush_list);
+static DEFINE_PER_CPU(struct list_head, dev_flush_list);
 static DEFINE_SPINLOCK(dev_map_lock);
 static LIST_HEAD(dev_map_list);
 
@@ -357,16 +357,16 @@ static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 	goto out;
 }
 
-/* __dev_map_flush is called from xdp_do_flush_map() which _must_ be signaled
+/* __dev_flush is called from xdp_do_flush() which _must_ be signaled
  * from the driver before returning from its napi->poll() routine. The poll()
  * routine is called either from busy_poll context or net_rx_action signaled
  * from NET_RX_SOFTIRQ. Either way the poll routine must complete before the
  * net device can be torn down. On devmap tear down we ensure the flush list
  * is empty before completing to ensure all flush operations have completed.
  */
-void __dev_map_flush(void)
+void __dev_flush(void)
 {
-	struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
+	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
 	struct xdp_dev_bulk_queue *bq, *tmp;
 
 	rcu_read_lock();
@@ -396,9 +396,8 @@ struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
  */
 static int bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 		      struct net_device *dev_rx)
-
 {
-	struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
+	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
 	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
 
 	if (unlikely(bq->count == DEV_MAP_BULK_SIZE))
@@ -419,10 +418,9 @@ static int bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 	return 0;
 }
 
-int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
-		    struct net_device *dev_rx)
+static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
+			       struct net_device *dev_rx)
 {
-	struct net_device *dev = dst->dev;
 	struct xdp_frame *xdpf;
 	int err;
 
@@ -440,6 +438,20 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 	return bq_enqueue(dev, xdpf, dev_rx);
 }
 
+int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
+		    struct net_device *dev_rx)
+{
+	return __xdp_enqueue(dev, xdp, dev_rx);
+}
+
+int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
+		    struct net_device *dev_rx)
+{
+	struct net_device *dev = dst->dev;
+
+	return __xdp_enqueue(dev, xdp, dev_rx);
+}
+
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog)
 {
@@ -762,7 +774,7 @@ static int __init dev_map_init(void)
 	register_netdevice_notifier(&dev_map_notifier);
 
 	for_each_possible_cpu(cpu)
-		INIT_LIST_HEAD(&per_cpu(dev_map_flush_list, cpu));
+		INIT_LIST_HEAD(&per_cpu(dev_flush_list, cpu));
 	return 0;
 }
 
diff --git a/net/core/filter.c b/net/core/filter.c
index d6f58dc4e1c4..17de6747d9e3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3458,58 +3458,6 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
-static int __bpf_tx_xdp(struct net_device *dev,
-			struct bpf_map *map,
-			struct xdp_buff *xdp,
-			u32 index)
-{
-	struct xdp_frame *xdpf;
-	int err, sent;
-
-	if (!dev->netdev_ops->ndo_xdp_xmit) {
-		return -EOPNOTSUPP;
-	}
-
-	err = xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
-	if (unlikely(err))
-		return err;
-
-	xdpf = convert_to_xdp_frame(xdp);
-	if (unlikely(!xdpf))
-		return -EOVERFLOW;
-
-	sent = dev->netdev_ops->ndo_xdp_xmit(dev, 1, &xdpf, XDP_XMIT_FLUSH);
-	if (sent <= 0)
-		return sent;
-	return 0;
-}
-
-static noinline int
-xdp_do_redirect_slow(struct net_device *dev, struct xdp_buff *xdp,
-		     struct bpf_prog *xdp_prog, struct bpf_redirect_info *ri)
-{
-	struct net_device *fwd;
-	u32 index = ri->tgt_index;
-	int err;
-
-	fwd = dev_get_by_index_rcu(dev_net(dev), index);
-	ri->tgt_index = 0;
-	if (unlikely(!fwd)) {
-		err = -EINVAL;
-		goto err;
-	}
-
-	err = __bpf_tx_xdp(fwd, NULL, xdp, 0);
-	if (unlikely(err))
-		goto err;
-
-	_trace_xdp_redirect(dev, xdp_prog, index);
-	return 0;
-err:
-	_trace_xdp_redirect_err(dev, xdp_prog, index, err);
-	return err;
-}
-
 static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
 			    struct bpf_map *map, struct xdp_buff *xdp)
 {
@@ -3527,13 +3475,13 @@ static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
 	return 0;
 }
 
-void xdp_do_flush_map(void)
+void xdp_do_flush(void)
 {
-	__dev_map_flush();
+	__dev_flush();
 	__cpu_map_flush();
 	__xsk_map_flush();
 }
-EXPORT_SYMBOL_GPL(xdp_do_flush_map);
+EXPORT_SYMBOL_GPL(xdp_do_flush);
 
 static inline void *__xdp_map_lookup_elem(struct bpf_map *map, u32 index)
 {
@@ -3568,10 +3516,11 @@ void bpf_clear_redirect_map(struct bpf_map *map)
 	}
 }
 
-static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
-			       struct bpf_prog *xdp_prog, struct bpf_map *map,
-			       struct bpf_redirect_info *ri)
+int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
+		    struct bpf_prog *xdp_prog)
 {
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	struct bpf_map *map = READ_ONCE(ri->map);
 	u32 index = ri->tgt_index;
 	void *fwd = ri->tgt_value;
 	int err;
@@ -3580,7 +3529,18 @@ static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
 	ri->tgt_value = NULL;
 	WRITE_ONCE(ri->map, NULL);
 
-	err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
+	if (unlikely(!map)) {
+		fwd = dev_get_by_index_rcu(dev_net(dev), index);
+		if (unlikely(!fwd)) {
+			err = -EINVAL;
+			goto err;
+		}
+
+		err = dev_xdp_enqueue(fwd, xdp, dev);
+	} else {
+		err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
+	}
+
 	if (unlikely(err))
 		goto err;
 
@@ -3590,18 +3550,6 @@ static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
 	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map, index, err);
 	return err;
 }
-
-int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
-		    struct bpf_prog *xdp_prog)
-{
-	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-	struct bpf_map *map = READ_ONCE(ri->map);
-
-	if (likely(map))
-		return xdp_do_redirect_map(dev, xdp, xdp_prog, map, ri);
-
-	return xdp_do_redirect_slow(dev, xdp, xdp_prog, ri);
-}
 EXPORT_SYMBOL_GPL(xdp_do_redirect);
 
 static int xdp_do_generic_redirect_map(struct net_device *dev,

