Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA68573525
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbiGMLPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiGMLPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:15:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2376C1014AD
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657710890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rXFurxawVFtuft5lsS/J8gtr6dC7kcFoAk62FiTlSIM=;
        b=ZLxSOXV1GzESEj6XogzVWNY3PzRU/z6w/EnQ1xa4BVK/Dg0VRWSIm0Qu2jT6a65KtumVo2
        uZtfp/dKH19s/Is9wqJgGQ9o0yDRLBNIXdwa8Ljn+TWAUKITBfLmay73F6tSrGGCM3PmGG
        Tj5iZmA+VvU5navx+2vC0kv5A/Jb4eQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-ym9-BGmDNISUvtmoshiASQ-1; Wed, 13 Jul 2022 07:14:49 -0400
X-MC-Unique: ym9-BGmDNISUvtmoshiASQ-1
Received: by mail-ed1-f70.google.com with SMTP id m10-20020a056402510a00b0043a93d807ffso8134991edd.12
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rXFurxawVFtuft5lsS/J8gtr6dC7kcFoAk62FiTlSIM=;
        b=0o0o7WDrMsqKSY/GsN+X3eklNpbKtWNTn/iEEuSy2qxzlV8bfkYhvT30qMWAoVksQ6
         wutxvbGV7i1E79Z5Ja75W11lsAzb86qnqSyTycE+VKixaBzfxKCN2TLjjlx3RwTuDGUq
         abC8pimwQZ1d6Uzpe8HupQVWLKVziONEoCazkfYf0g1Yx5UDoCFnCOxQlqKypNPAJj/T
         T449K7bSJ1b/FW80ahmse+imcC8dMk6LDrdup/AfDCYFJYQWkkx8Rud0s7s5knptd+5B
         m+wAiDHBlQjF37pREyUe3JRi047wOtCMhvIJ9Aoz1KEfsTclRe2NnQ82CzWeJ46q2GCH
         tIiA==
X-Gm-Message-State: AJIora/XwVpRht7T9YWr6/5vGWFbEpQbMvWNlQ9O9FToLd8kOjLbqihH
        2c4qKCPFuo6M9ycq2iulOMrWw24MUpz+zc4Ah7twm7U7Ooo5+Vvku0cSFh7Skev+cCOf0SzbY6c
        O5tp9FH9jGvwe3do7
X-Received: by 2002:a05:6402:5186:b0:43a:b43a:40bc with SMTP id q6-20020a056402518600b0043ab43a40bcmr4119183edd.388.1657710887103;
        Wed, 13 Jul 2022 04:14:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vB/c1K7yaxap/ZUVfOVeBbQ2B1yduKwzNKz+NkrC/B2K0VzhPyb14RkH+qwdDnq/e4IDFFSw==
X-Received: by 2002:a05:6402:5186:b0:43a:b43a:40bc with SMTP id q6-20020a056402518600b0043ab43a40bcmr4119000edd.388.1657710885403;
        Wed, 13 Jul 2022 04:14:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f19-20020a170906139300b00722e52d043dsm4844725ejc.114.2022.07.13.04.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:14:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B32554D9911; Wed, 13 Jul 2022 13:14:38 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [RFC PATCH 11/17] dev: Add XDP dequeue hook
Date:   Wed, 13 Jul 2022 13:14:19 +0200
Message-Id: <20220713111430.134810-12-toke@redhat.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
References: <20220713111430.134810-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a second per-interface XDP hook for dequeueing packets. This hook
allows attaching programs of the dequeue type, which will be executed by
the stack in the TX softirq. Packets returned by the dequeue hook are
subsequently transmitted on the interface using the ndo_xdp_xmit() driver
function. The code to do this is added to devmap.c to be able to reuse the
existing bulking mechanism from there.

To actually schedule a device for transmission, a BPF program needs to call
a helper that is added in the next commit.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/filter.h             |  17 +++++
 include/linux/netdevice.h          |   6 ++
 include/net/xdp.h                  |   7 ++
 include/uapi/linux/if_link.h       |   4 +-
 kernel/bpf/devmap.c                |  88 ++++++++++++++++++++---
 net/core/dev.c                     | 109 +++++++++++++++++++++++++++++
 net/core/dev.h                     |   2 +
 net/core/filter.c                  |   7 ++
 net/core/rtnetlink.c               |  30 ++++++--
 tools/include/uapi/linux/if_link.h |   4 +-
 10 files changed, 256 insertions(+), 18 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index b0ddb647d5f2..0f1570daaa52 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -778,6 +778,23 @@ static __always_inline u64 bpf_prog_run_xdp(const struct bpf_prog *prog,
 
 void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *prog);
 
+DECLARE_BPF_DISPATCHER(xdp_dequeue)
+
+static __always_inline struct xdp_frame *bpf_prog_run_xdp_dequeue(const struct bpf_prog *prog,
+								  struct dequeue_data *ctx)
+{
+	struct xdp_frame *frm = NULL;
+	u64 ret;
+
+	ret = __bpf_prog_run(prog, ctx, BPF_DISPATCHER_FUNC(xdp_dequeue));
+	if (ret)
+		frm = (struct xdp_frame *)(unsigned long)ret;
+
+	return frm;
+}
+
+void bpf_prog_change_xdp_dequeue(struct bpf_prog *prev_prog, struct bpf_prog *prog);
+
 static inline u32 bpf_prog_insn_size(const struct bpf_prog *prog)
 {
 	return prog->len * sizeof(struct bpf_insn);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fe9aeca2fce9..4096caac5a2a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -74,6 +74,7 @@ struct udp_tunnel_nic_info;
 struct udp_tunnel_nic;
 struct bpf_prog;
 struct xdp_buff;
+struct xdp_dequeue;
 
 void synchronize_net(void);
 void netdev_set_default_ethtool_ops(struct net_device *dev,
@@ -2326,6 +2327,7 @@ struct net_device {
 
 	/* protected by rtnl_lock */
 	struct bpf_xdp_entity	xdp_state[__MAX_XDP_MODE];
+	struct bpf_prog __rcu	*xdp_dequeue_prog;
 
 	u8 dev_addr_shadow[MAX_ADDR_LEN];
 	netdevice_tracker	linkwatch_dev_tracker;
@@ -3109,6 +3111,7 @@ struct softnet_data {
 	struct Qdisc		*output_queue;
 	struct Qdisc		**output_queue_tailp;
 	struct sk_buff		*completion_queue;
+	struct xdp_dequeue	*xdp_dequeue;
 #ifdef CONFIG_XFRM_OFFLOAD
 	struct sk_buff_head	xfrm_backlog;
 #endif
@@ -3143,6 +3146,7 @@ struct softnet_data {
 	int			defer_ipi_scheduled;
 	struct sk_buff		*defer_list;
 	call_single_data_t	defer_csd;
+
 };
 
 static inline void input_queue_head_incr(struct softnet_data *sd)
@@ -3222,6 +3226,7 @@ static inline void netif_tx_start_all_queues(struct net_device *dev)
 }
 
 void netif_tx_wake_queue(struct netdev_queue *dev_queue);
+void netif_tx_schedule_xdp(struct xdp_dequeue *deq);
 
 /**
  *	netif_wake_queue - restart transmit
@@ -3851,6 +3856,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
 u8 dev_xdp_prog_count(struct net_device *dev);
 u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode);
+u32 dev_xdp_dequeue_prog_id(struct net_device *dev);
 
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
 int dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 728ce943d352..e06b340132dd 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -89,6 +89,13 @@ struct dequeue_data {
 	struct xdp_txq_info *txq;
 };
 
+struct xdp_dequeue {
+	struct xdp_dequeue *next;
+};
+
+void dev_run_xdp_dequeue(struct xdp_dequeue *deq);
+void dev_schedule_xdp_dequeue(struct net_device *dev);
+
 static __always_inline bool xdp_buff_has_frags(struct xdp_buff *xdp)
 {
 	return !!(xdp->flags & XDP_FLAGS_HAS_FRAGS);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e36d9d2c65a7..fb8ab1796cd2 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1283,9 +1283,10 @@ enum {
 #define XDP_FLAGS_DRV_MODE		(1U << 2)
 #define XDP_FLAGS_HW_MODE		(1U << 3)
 #define XDP_FLAGS_REPLACE		(1U << 4)
+#define XDP_FLAGS_DEQUEUE_MODE		(1U << 5)
 #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
 					 XDP_FLAGS_DRV_MODE | \
-					 XDP_FLAGS_HW_MODE)
+					 XDP_FLAGS_HW_MODE | XDP_FLAGS_DEQUEUE_MODE)
 #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
 					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE)
 
@@ -1308,6 +1309,7 @@ enum {
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
 	IFLA_XDP_EXPECTED_FD,
+	IFLA_XDP_DEQUEUE_PROG_ID,
 	__IFLA_XDP_MAX,
 };
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 980f8928e977..949a60f06d24 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -59,6 +59,7 @@ struct xdp_dev_bulk_queue {
 	struct net_device *dev;
 	struct net_device *dev_rx;
 	struct bpf_prog *xdp_prog;
+	struct xdp_dequeue deq;
 	unsigned int count;
 };
 
@@ -362,16 +363,17 @@ static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
 	return nframes; /* sent frames count */
 }
 
-static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
+static bool bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags, bool keep)
 {
 	struct net_device *dev = bq->dev;
 	unsigned int cnt = bq->count;
 	int sent = 0, err = 0;
 	int to_send = cnt;
-	int i;
+	bool ret = true;
+	int i, kept = 0;
 
 	if (unlikely(!cnt))
-		return;
+		return true;
 
 	for (i = 0; i < cnt; i++) {
 		struct xdp_frame *xdpf = bq->q[i];
@@ -394,15 +396,29 @@ static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 		sent = 0;
 	}
 
-	/* If not all frames have been transmitted, it is our
-	 * responsibility to free them
+	/* If not all frames have been transmitted, it is our responsibility to
+	 * free them, unless the caller asked for them to be kept, in which case
+	 * we'll move them to the head of the queue
 	 */
-	for (i = sent; unlikely(i < to_send); i++)
-		xdp_return_frame_rx_napi(bq->q[i]);
+	if (unlikely(sent < to_send)) {
+		ret = false;
+		if (keep) {
+			if (!sent) {
+				kept = to_send;
+				goto out;
+			}
+			for (i = sent; i < to_send; i++)
+				bq->q[kept++] = bq->q[i];
+		} else {
+			for (i = sent; i < to_send; i++)
+				xdp_return_frame_rx_napi(bq->q[i]);
+		}
+	}
 
 out:
-	bq->count = 0;
-	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, cnt - sent, err);
+	bq->count = kept;
+	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, cnt - sent - kept, err);
+	return ret;
 }
 
 /* __dev_flush is called from xdp_do_flush() which _must_ be signalled from the
@@ -415,13 +431,63 @@ void __dev_flush(void)
 	struct xdp_dev_bulk_queue *bq, *tmp;
 
 	list_for_each_entry_safe(bq, tmp, flush_list, flush_node) {
-		bq_xmit_all(bq, XDP_XMIT_FLUSH);
+		bq_xmit_all(bq, XDP_XMIT_FLUSH, false);
 		bq->dev_rx = NULL;
 		bq->xdp_prog = NULL;
 		__list_del_clearprev(&bq->flush_node);
 	}
 }
 
+void dev_schedule_xdp_dequeue(struct net_device *dev)
+{
+	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
+
+	netif_tx_schedule_xdp(&bq->deq);
+}
+
+void dev_run_xdp_dequeue(struct xdp_dequeue *deq)
+{
+	while (deq) {
+		struct xdp_dev_bulk_queue *bq = container_of(deq, struct xdp_dev_bulk_queue, deq);
+		struct xdp_txq_info txqi = { .dev = bq->dev };
+		struct dequeue_data ctx = { .txq = &txqi };
+		struct xdp_dequeue *nxt = deq->next;
+		int quota = dev_tx_weight;
+		struct xdp_frame *xdpf;
+		struct bpf_prog *prog;
+		bool ret = true;
+
+		local_bh_disable();
+
+		prog = rcu_dereference(bq->dev->xdp_dequeue_prog);
+		if (likely(prog)) {
+			do {
+				if (unlikely(bq->count == DEV_MAP_BULK_SIZE)) {
+					ret = bq_xmit_all(bq, 0, true);
+					if (!ret)
+						break;
+				}
+				xdpf = bpf_prog_run_xdp_dequeue(prog, &ctx);
+				if (xdpf)
+					bq->q[bq->count++] = xdpf;
+
+			} while (xdpf && --quota);
+
+			if (ret)
+				ret = bq_xmit_all(bq, XDP_XMIT_FLUSH, true);
+
+			if (!ret || !quota)
+				/* out of space, reschedule */
+				netif_tx_schedule_xdp(deq);
+		}
+
+		deq->next = NULL;
+		deq = nxt;
+
+		local_bh_enable();
+	}
+}
+
 /* Elements are kept alive by RCU; either by rcu_read_lock() (from syscall) or
  * by local_bh_disable() (from XDP calls inside NAPI). The
  * rcu_read_lock_bh_held() below makes lockdep accept both.
@@ -450,7 +516,7 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
 
 	if (unlikely(bq->count == DEV_MAP_BULK_SIZE))
-		bq_xmit_all(bq, 0);
+		bq_xmit_all(bq, 0, false);
 
 	/* Ingress dev_rx will be the same for all xdp_frame's in
 	 * bulk_queue, because bq stored per-CPU and must be flushed
diff --git a/net/core/dev.c b/net/core/dev.c
index 978ed0622d8f..07505c88117a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3120,6 +3120,22 @@ void netif_tx_wake_queue(struct netdev_queue *dev_queue)
 }
 EXPORT_SYMBOL(netif_tx_wake_queue);
 
+void netif_tx_schedule_xdp(struct xdp_dequeue *deq)
+{
+	bool need_bh_off = !(hardirq_count() | softirq_count());
+
+	WARN_ON_ONCE(need_bh_off);
+
+	if (!deq->next) {
+		struct softnet_data *sd = this_cpu_ptr(&softnet_data);
+
+		deq->next = sd->xdp_dequeue;
+		sd->xdp_dequeue = deq;
+		raise_softirq_irqoff(NET_TX_SOFTIRQ);
+	}
+}
+EXPORT_SYMBOL(netif_tx_schedule_xdp);
+
 void __dev_kfree_skb_irq(struct sk_buff *skb, enum skb_free_reason reason)
 {
 	unsigned long flags;
@@ -5011,6 +5027,17 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
 
+	if (sd->xdp_dequeue) {
+		struct xdp_dequeue *deq;
+
+		local_irq_disable();
+		deq = sd->xdp_dequeue;
+		sd->xdp_dequeue = NULL;
+		local_irq_enable();
+
+		dev_run_xdp_dequeue(deq);
+	}
+
 	if (sd->completion_queue) {
 		struct sk_buff *clist;
 
@@ -9522,6 +9549,88 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	return err;
 }
 
+u32 dev_xdp_dequeue_prog_id(struct net_device *dev)
+{
+	struct bpf_prog *prog = rtnl_dereference(dev->xdp_dequeue_prog);
+
+	return prog ? prog->aux->id : 0;
+}
+
+static int dev_xdp_dequeue_attach(struct net_device *dev, struct netlink_ext_ack *extack,
+				  struct bpf_prog *new_prog, struct bpf_prog *old_prog, u32 flags)
+{
+	struct bpf_prog *cur_prog;
+
+	ASSERT_RTNL();
+
+	if (!(flags & XDP_FLAGS_REPLACE) || (flags & XDP_FLAGS_UPDATE_IF_NOEXIST)) {
+		NL_SET_ERR_MSG(extack, "Dequeue prog must use XDP_FLAGS_REPLACE");
+		return -EINVAL;
+	}
+
+	cur_prog = rcu_dereference(dev->xdp_dequeue_prog);
+
+	if (cur_prog != old_prog) {
+		NL_SET_ERR_MSG(extack, "Active program does not match expected");
+		return -EEXIST;
+	}
+
+	if (cur_prog != new_prog) {
+		rcu_assign_pointer(dev->xdp_dequeue_prog, new_prog);
+		bpf_prog_change_xdp_dequeue(cur_prog, new_prog);
+	}
+
+	if (cur_prog)
+		bpf_prog_put(cur_prog);
+
+	return 0;
+}
+
+/**
+ *	dev_change_xdp_dequeue_fd - set or clear a bpf program for a XDP dequeue
+ *	@dev: device
+ *	@extack: netlink extended ack
+ *	@fd: new program fd or negative value to clear
+ *	@expected_fd: old program fd that userspace expects to replace or clear
+ *	@flags: xdp dequeue-related flags
+ *
+ *	Set or clear an XDP dequeue program for a device
+ */
+int dev_change_xdp_dequeue_fd(struct net_device *dev, struct netlink_ext_ack *extack,
+			      int fd, int expected_fd, u32 flags)
+{
+	struct bpf_prog *new_prog = NULL, *old_prog = NULL;
+	int err;
+
+	ASSERT_RTNL();
+
+	if (fd >= 0) {
+		new_prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_DEQUEUE, false);
+		if (IS_ERR(new_prog))
+			return PTR_ERR(new_prog);
+	}
+
+	if (expected_fd >= 0) {
+		old_prog = bpf_prog_get_type_dev(expected_fd,
+						 BPF_PROG_TYPE_DEQUEUE,
+						 false);
+		if (IS_ERR(old_prog)) {
+			err = PTR_ERR(old_prog);
+			old_prog = NULL;
+			goto err_out;
+		}
+	}
+
+	err = dev_xdp_dequeue_attach(dev, extack, new_prog, old_prog, flags);
+
+err_out:
+	if (err && new_prog)
+		bpf_prog_put(new_prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+	return err;
+}
+
 /**
  *	dev_new_index	-	allocate an ifindex
  *	@net: the applicable net namespace
diff --git a/net/core/dev.h b/net/core/dev.h
index cbb8a925175a..fe598287f786 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -81,6 +81,8 @@ void dev_change_proto_down_reason(struct net_device *dev, unsigned long mask,
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		      int fd, int expected_fd, u32 flags);
+int dev_change_xdp_dequeue_fd(struct net_device *dev, struct netlink_ext_ack *extack,
+			      int fd, int expected_fd, u32 flags);
 
 int dev_change_tx_queue_len(struct net_device *dev, unsigned long new_len);
 void dev_set_group(struct net_device *dev, int new_group);
diff --git a/net/core/filter.c b/net/core/filter.c
index 6a4881739e9b..7c89eaa01c29 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -11584,6 +11584,13 @@ void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *prog)
 	bpf_dispatcher_change_prog(BPF_DISPATCHER_PTR(xdp), prev_prog, prog);
 }
 
+DEFINE_BPF_DISPATCHER(xdp_dequeue)
+
+void bpf_prog_change_xdp_dequeue(struct bpf_prog *prev_prog, struct bpf_prog *prog)
+{
+	bpf_dispatcher_change_prog(BPF_DISPATCHER_PTR(xdp_dequeue), prev_prog, prog);
+}
+
 BTF_ID_LIST_GLOBAL(btf_sock_ids, MAX_BTF_SOCK_TYPE)
 #define BTF_SOCK_TYPE(name, type) BTF_ID(struct, type)
 BTF_SOCK_TYPE_xxx
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index ac45328607f7..495acb5a6616 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1012,7 +1012,8 @@ static size_t rtnl_xdp_size(void)
 	size_t xdp_size = nla_total_size(0) +	/* nest IFLA_XDP */
 			  nla_total_size(1) +	/* XDP_ATTACHED */
 			  nla_total_size(4) +	/* XDP_PROG_ID (or 1st mode) */
-			  nla_total_size(4);	/* XDP_<mode>_PROG_ID */
+			  nla_total_size(4) +	/* XDP_<mode>_PROG_ID */
+			  nla_total_size(4);	/* XDP_DEQUEUE_PROG_ID */
 
 	return xdp_size;
 }
@@ -1467,6 +1468,11 @@ static u32 rtnl_xdp_prog_hw(struct net_device *dev)
 	return dev_xdp_prog_id(dev, XDP_MODE_HW);
 }
 
+static u32 rtnl_xdp_dequeue_prog(struct net_device *dev)
+{
+	return dev_xdp_dequeue_prog_id(dev);
+}
+
 static int rtnl_xdp_report_one(struct sk_buff *skb, struct net_device *dev,
 			       u32 *prog_id, u8 *mode, u8 tgt_mode, u32 attr,
 			       u32 (*get_prog_id)(struct net_device *dev))
@@ -1527,6 +1533,13 @@ static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
 			goto err_cancel;
 	}
 
+	prog_id = rtnl_xdp_dequeue_prog(dev);
+	if (prog_id) {
+		err = nla_put_u32(skb, IFLA_XDP_DEQUEUE_PROG_ID, prog_id);
+		if (err)
+			goto err_cancel;
+	}
+
 	nla_nest_end(skb, xdp);
 	return 0;
 
@@ -1979,6 +1992,7 @@ static const struct nla_policy ifla_xdp_policy[IFLA_XDP_MAX + 1] = {
 	[IFLA_XDP_ATTACHED]	= { .type = NLA_U8 },
 	[IFLA_XDP_FLAGS]	= { .type = NLA_U32 },
 	[IFLA_XDP_PROG_ID]	= { .type = NLA_U32 },
+	[IFLA_XDP_DEQUEUE_PROG_ID]	= { .type = NLA_U32 },
 };
 
 static const struct rtnl_link_ops *linkinfo_to_kind_ops(const struct nlattr *nla)
@@ -2998,10 +3012,16 @@ static int do_setlink(const struct sk_buff *skb,
 					nla_get_s32(xdp[IFLA_XDP_EXPECTED_FD]);
 			}
 
-			err = dev_change_xdp_fd(dev, extack,
-						nla_get_s32(xdp[IFLA_XDP_FD]),
-						expected_fd,
-						xdp_flags);
+			if (xdp_flags & XDP_FLAGS_DEQUEUE_MODE)
+				err = dev_change_xdp_dequeue_fd(dev, extack,
+								nla_get_s32(xdp[IFLA_XDP_FD]),
+								expected_fd,
+								xdp_flags);
+			else
+				err = dev_change_xdp_fd(dev, extack,
+							nla_get_s32(xdp[IFLA_XDP_FD]),
+							expected_fd,
+							xdp_flags);
 			if (err)
 				goto errout;
 			status |= DO_SETLINK_NOTIFY;
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 0242f31e339c..f40ad0db46b7 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -1188,9 +1188,10 @@ enum {
 #define XDP_FLAGS_DRV_MODE		(1U << 2)
 #define XDP_FLAGS_HW_MODE		(1U << 3)
 #define XDP_FLAGS_REPLACE		(1U << 4)
+#define XDP_FLAGS_DEQUEUE_MODE		(1U << 5)
 #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
 					 XDP_FLAGS_DRV_MODE | \
-					 XDP_FLAGS_HW_MODE)
+					 XDP_FLAGS_HW_MODE | XDP_FLAGS_DEQUEUE_MODE)
 #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
 					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE)
 
@@ -1213,6 +1214,7 @@ enum {
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
 	IFLA_XDP_EXPECTED_FD,
+	IFLA_XDP_DEQUEUE_PROG_ID,
 	__IFLA_XDP_MAX,
 };
 
-- 
2.37.0

