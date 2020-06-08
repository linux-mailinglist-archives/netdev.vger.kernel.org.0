Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542CE1F1967
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 14:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgFHMzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 08:55:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48273 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728245AbgFHMxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 08:53:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VWXM+ipVrzQXYONFpt3zkOQmQtQZ231iT3DOSd7IMMo=;
        b=b+fQhlHVZ2bFQu0tklHRuW3gvD4oewBsgbvsqapaSL0vsl8D4EV1BBHfvX64IM437Ypl4Y
        toTMlben37QAfKcseR9EUwfYnJDxhdSP9ovrdW9wl1/GRvbqbXYhzEiou7ZdW3irxJ30UH
        y2W/Qzfz/xgDjB/hsyF/3cS0dT5IZhc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-fU1ZakBQPjGqSGwWbmCprg-1; Mon, 08 Jun 2020 08:53:01 -0400
X-MC-Unique: fU1ZakBQPjGqSGwWbmCprg-1
Received: by mail-wm1-f69.google.com with SMTP id q7so3891843wmj.9
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 05:53:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VWXM+ipVrzQXYONFpt3zkOQmQtQZ231iT3DOSd7IMMo=;
        b=g+cMSGBJ/EXTADk6c9u1Uhh/PZzzjjiaVSqZw9UWb5CQfyy/uI2XiMevlWd2pTAEim
         YopJJKx2DM+vEGcZ58WZA5CGDGHnZgJBfQgEYvViHAt8SFT0YWumxbYxpkPPoXjftk9y
         bOLGfU/07ctzolmKybmWtBcRlTWQNkxoE7JTs/j5k2zbDqpfIjYTICVuML0wQfG52nNl
         jXqtIMBlItIRGTdX8c664aIxVBPAl7gmKcoYHzRdLfOP6eJF3aW3NXkDCaZzWJaIMBVy
         vex2T3n4K4D9DwNVgpfBI0vtgECDMJGMca+O7eyJV7DiB17Ra1oTVGGQjrhobNaHPlkd
         GVpg==
X-Gm-Message-State: AOAM530mrvOVc+VJE2ourIXIP5o9/KGEgS4kPjkmK+THEK6gfzOuf5hX
        VbHGbnLIQta3b1psXH5/YKEz0rcncRjUmDftfuAi3J9AP5SRx+C04xwyJLLXtwzPchIsCDIGNvO
        adPeFTKYM+o4q6Y37
X-Received: by 2002:a1c:2002:: with SMTP id g2mr15880269wmg.132.1591620780151;
        Mon, 08 Jun 2020 05:53:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5q+0SXDT6Wdos2frrb3vvZ3yL2SrO2xQj04+9m7aTyGYJfEoe809o7V4AZJBXuQ14Gp89bw==
X-Received: by 2002:a1c:2002:: with SMTP id g2mr15880253wmg.132.1591620779909;
        Mon, 08 Jun 2020 05:52:59 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id q11sm23292226wrv.67.2020.06.08.05.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 05:52:59 -0700 (PDT)
Date:   Mon, 8 Jun 2020 08:52:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v6 03/11] vhost/net: pass net specific struct pointer
Message-ID: <20200608125238.728563-4-mst@redhat.com>
References: <20200608125238.728563-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608125238.728563-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for further cleanup, pass net specific pointer
to ubuf callbacks so we can move net specific fields
out to net structures.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index bf5e1d81ae25..ff594eec8ae3 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -94,7 +94,7 @@ struct vhost_net_ubuf_ref {
 	 */
 	atomic_t refcount;
 	wait_queue_head_t wait;
-	struct vhost_virtqueue *vq;
+	struct vhost_net_virtqueue *nvq;
 };
 
 #define VHOST_NET_BATCH 64
@@ -231,7 +231,7 @@ static void vhost_net_enable_zcopy(int vq)
 }
 
 static struct vhost_net_ubuf_ref *
-vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
+vhost_net_ubuf_alloc(struct vhost_net_virtqueue *nvq, bool zcopy)
 {
 	struct vhost_net_ubuf_ref *ubufs;
 	/* No zero copy backend? Nothing to count. */
@@ -242,7 +242,7 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
 		return ERR_PTR(-ENOMEM);
 	atomic_set(&ubufs->refcount, 1);
 	init_waitqueue_head(&ubufs->wait);
-	ubufs->vq = vq;
+	ubufs->nvq = nvq;
 	return ubufs;
 }
 
@@ -384,13 +384,13 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
 static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
 {
 	struct vhost_net_ubuf_ref *ubufs = ubuf->ctx;
-	struct vhost_virtqueue *vq = ubufs->vq;
+	struct vhost_net_virtqueue *nvq = ubufs->nvq;
 	int cnt;
 
 	rcu_read_lock_bh();
 
 	/* set len to mark this desc buffers done DMA */
-	vq->heads[ubuf->desc].len = success ?
+	nvq->vq.heads[ubuf->desc].in_len = success ?
 		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
 	cnt = vhost_net_ubuf_put(ubufs);
 
@@ -402,7 +402,7 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
 	 * less than 10% of times).
 	 */
 	if (cnt <= 1 || !(cnt % 16))
-		vhost_poll_queue(&vq->poll);
+		vhost_poll_queue(&nvq->vq.poll);
 
 	rcu_read_unlock_bh();
 }
@@ -1525,7 +1525,7 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	/* start polling new socket */
 	oldsock = vhost_vq_get_backend(vq);
 	if (sock != oldsock) {
-		ubufs = vhost_net_ubuf_alloc(vq,
+		ubufs = vhost_net_ubuf_alloc(nvq,
 					     sock && vhost_sock_zcopy(sock));
 		if (IS_ERR(ubufs)) {
 			r = PTR_ERR(ubufs);
-- 
MST

