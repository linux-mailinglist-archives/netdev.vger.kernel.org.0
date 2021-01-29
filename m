Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A6E308256
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhA2AWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhA2AWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 19:22:19 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECE8C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 16:21:38 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id l15so4737090qtp.21
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 16:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=rwfY7bPOvN5VtqwHw8eO8OEmUHwsQ4q5jwYYudLIJqM=;
        b=P7e+hbT9/1WMoJhsJfl0PyrWICXSxIelSAhyC4v9sWZFkk/Ku6wueMj5zhyFogITZj
         ax+iKiqaa8ZrchP3xBHhD+2xv2vdcfirjdOOi1B5URKP6IbC2hKopl+g49NUrXt8LriX
         QDu91yoZ6OiK23tjZNNQmOpbNvmbXho82Ip6u90CqGzBMbD+mf5a6bZyDAph/MlnHk4c
         eZheVG9oqDCi21wTWxg1GJqBGjP75MoL4s5cji4T7bQnaN304o5RaEoWS23cwmdHE41A
         iYHo0zOr3NAYkyk9dmtEw8OJs1GVKzsxcuGWzXVjAx1p77MeuVSfI9Hm+k5nugF4GzXb
         HhNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=rwfY7bPOvN5VtqwHw8eO8OEmUHwsQ4q5jwYYudLIJqM=;
        b=RphQFiRouTt51aOA4xkbkMG44XIQGrOxT08fFeDbLEKbFkZAJggTH/2HAUCXgITcLC
         BVFbgFQROTcIiFbLf/UPx/LBez68/ZSE+lI8mVhtGELY5Md4ffHrnTWMTZfyNR6w2H9i
         w8PWgZilOrvfkYsnYSpJ06dKuUNZKY8zMyiagKCtnvEgK+eDtdfB41j9/no5eatawBQZ
         Bcig8LLMfWgyF5/Q+eIkx+FQNqvr+/vMp9llEJngS9nInaVaKew8kkZESrEwm9E7J1Vg
         LjAdkAIv9zdY0EOl1LWIyq4dmJOcplFMTIouPKi9m+hbStAufE3UTvJfTddgbLUGI8Iw
         Fk3w==
X-Gm-Message-State: AOAM533Xgu7B0XlDjdH5nbSR+zqqntiOtar2DtoHawEuI3tjrr1tjV/a
        hzY4mL8jf5FK51wygUSyTHqhRGYrmTc=
X-Google-Smtp-Source: ABdhPJxOdJxaw/gXSWVSJI4O+MIT/PpoCmX33m/NzUbdvLFFDagdQaujR/Q98OGZhsKv6R42UNb+NPui8io=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:ec1e:c427:9e7b:6abb])
 (user=weiwan job=sendgmr) by 2002:ad4:43e3:: with SMTP id f3mr2131572qvu.1.1611879697839;
 Thu, 28 Jan 2021 16:21:37 -0800 (PST)
Date:   Thu, 28 Jan 2021 16:21:36 -0800
Message-Id: <20210129002136.70865-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net] virtio-net: suppress bad irq warning for tx napi
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the implementation of napi-tx in virtio driver, we clean tx
descriptors from rx napi handler, for the purpose of reducing tx
complete interrupts. But this could introduce a race where tx complete
interrupt has been raised, but the handler found there is no work to do
because we have done the work in the previous rx interrupt handler.
This could lead to the following warning msg:
[ 3588.010778] irq 38: nobody cared (try booting with the
"irqpoll" option)
[ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
5.3.0-19-generic #20~18.04.2-Ubuntu
[ 3588.017940] Call Trace:
[ 3588.017942]  <IRQ>
[ 3588.017951]  dump_stack+0x63/0x85
[ 3588.017953]  __report_bad_irq+0x35/0xc0
[ 3588.017955]  note_interrupt+0x24b/0x2a0
[ 3588.017956]  handle_irq_event_percpu+0x54/0x80
[ 3588.017957]  handle_irq_event+0x3b/0x60
[ 3588.017958]  handle_edge_irq+0x83/0x1a0
[ 3588.017961]  handle_irq+0x20/0x30
[ 3588.017964]  do_IRQ+0x50/0xe0
[ 3588.017966]  common_interrupt+0xf/0xf
[ 3588.017966]  </IRQ>
[ 3588.017989] handlers:
[ 3588.020374] [<000000001b9f1da8>] vring_interrupt
[ 3588.025099] Disabling IRQ #38

This patch adds a new param to struct vring_virtqueue, and we set it for
tx virtqueues if napi-tx is enabled, to suppress the warning in such
case.

Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi")
Reported-by: Rick Jones <jonesrick@google.com>
Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/virtio_net.c     | 19 ++++++++++++++-----
 drivers/virtio/virtio_ring.c | 16 ++++++++++++++++
 include/linux/virtio.h       |  2 ++
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 508408fbe78f..e9a3f30864e8 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1303,13 +1303,22 @@ static void virtnet_napi_tx_enable(struct virtnet_info *vi,
 		return;
 	}
 
+	/* With napi_tx enabled, free_old_xmit_skbs() could be called from
+	 * rx napi handler. Set work_steal to suppress bad irq warning for
+	 * IRQ_NONE case from tx complete interrupt handler.
+	 */
+	virtqueue_set_work_steal(vq, true);
+
 	return virtnet_napi_enable(vq, napi);
 }
 
-static void virtnet_napi_tx_disable(struct napi_struct *napi)
+static void virtnet_napi_tx_disable(struct virtqueue *vq,
+				    struct napi_struct *napi)
 {
-	if (napi->weight)
+	if (napi->weight) {
 		napi_disable(napi);
+		virtqueue_set_work_steal(vq, false);
+	}
 }
 
 static void refill_work(struct work_struct *work)
@@ -1835,7 +1844,7 @@ static int virtnet_close(struct net_device *dev)
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
 		napi_disable(&vi->rq[i].napi);
-		virtnet_napi_tx_disable(&vi->sq[i].napi);
+		virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
 	}
 
 	return 0;
@@ -2315,7 +2324,7 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
 	if (netif_running(vi->dev)) {
 		for (i = 0; i < vi->max_queue_pairs; i++) {
 			napi_disable(&vi->rq[i].napi);
-			virtnet_napi_tx_disable(&vi->sq[i].napi);
+			virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
 		}
 	}
 }
@@ -2440,7 +2449,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	if (netif_running(dev)) {
 		for (i = 0; i < vi->max_queue_pairs; i++) {
 			napi_disable(&vi->rq[i].napi);
-			virtnet_napi_tx_disable(&vi->sq[i].napi);
+			virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
 		}
 	}
 
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 71e16b53e9c1..f7c5d697c302 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -105,6 +105,9 @@ struct vring_virtqueue {
 	/* Host publishes avail event idx */
 	bool event;
 
+	/* Tx side napi work could be done from rx side. */
+	bool work_steal;
+
 	/* Head of free buffer list. */
 	unsigned int free_head;
 	/* Number we've added since last sync. */
@@ -1604,6 +1607,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->notify = notify;
 	vq->weak_barriers = weak_barriers;
 	vq->broken = false;
+	vq->work_steal = false;
 	vq->last_used_idx = 0;
 	vq->num_added = 0;
 	vq->packed_ring = true;
@@ -2038,6 +2042,9 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
 
 	if (!more_used(vq)) {
 		pr_debug("virtqueue interrupt with no work for %p\n", vq);
+		if (vq->work_steal)
+			return IRQ_HANDLED;
+
 		return IRQ_NONE;
 	}
 
@@ -2082,6 +2089,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->notify = notify;
 	vq->weak_barriers = weak_barriers;
 	vq->broken = false;
+	vq->work_steal = false;
 	vq->last_used_idx = 0;
 	vq->num_added = 0;
 	vq->use_dma_api = vring_use_dma_api(vdev);
@@ -2266,6 +2274,14 @@ bool virtqueue_is_broken(struct virtqueue *_vq)
 }
 EXPORT_SYMBOL_GPL(virtqueue_is_broken);
 
+void virtqueue_set_work_steal(struct virtqueue *_vq, bool val)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	vq->work_steal = val;
+}
+EXPORT_SYMBOL_GPL(virtqueue_set_work_steal);
+
 /*
  * This should prevent the device from being used, allowing drivers to
  * recover.  You may need to grab appropriate locks to flush.
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 55ea329fe72a..091c30f21ff9 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -84,6 +84,8 @@ unsigned int virtqueue_get_vring_size(struct virtqueue *vq);
 
 bool virtqueue_is_broken(struct virtqueue *vq);
 
+void virtqueue_set_work_steal(struct virtqueue *vq, bool val);
+
 const struct vring *virtqueue_get_vring(struct virtqueue *vq);
 dma_addr_t virtqueue_get_desc_addr(struct virtqueue *vq);
 dma_addr_t virtqueue_get_avail_addr(struct virtqueue *vq);
-- 
2.30.0.365.g02bc693789-goog

