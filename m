Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38BC1F66DE
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 13:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgFKLef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 07:34:35 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41146 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728053AbgFKLea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 07:34:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591875268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VWXM+ipVrzQXYONFpt3zkOQmQtQZ231iT3DOSd7IMMo=;
        b=ejvJHoQBBgPte9V+sc+ZAl+9B/K1RZblTed+YkHcBIdNTBV8FiTPuKzcz8TXSRgMi565qi
        /5KNd8Gu3N5QLl89Zyqh7kavjpCFTF+gHHpR0XMlpGncGmb2//5SDDEiHSMms+3DlSXfOy
        ab/z54ZsCitCg2flGAHuHkk4k/mPrDw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-u2MKIl0OPrS-UBVsddEA1g-1; Thu, 11 Jun 2020 07:34:25 -0400
X-MC-Unique: u2MKIl0OPrS-UBVsddEA1g-1
Received: by mail-wr1-f70.google.com with SMTP id w4so2454267wrl.13
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 04:34:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VWXM+ipVrzQXYONFpt3zkOQmQtQZ231iT3DOSd7IMMo=;
        b=rmF8FWoSFjFcTNGzJFeDVpJ+Gu6LTpT+29VZDFn/BZ5h4a4tPuBYVCOYn3bQRAiTkl
         hQ36nRMKDgA28Rd5mzLqFzvBd7eNmraMXueArzgVtGloLtkiBm32oBPbdlPuJySKjJBz
         lt8tyY2tiW5/W8S/r7k+xsZ1lRikU3SGhb5oxwz+QtNQcg2MSTSstcL5PP5fvHyoyGCU
         kM5WfUMvN2XEzKlUIZiSd1cPqXQ6qVIY5DIuuj5QvTLzdRuvLyrGql04TrYRJcos+FJg
         OEbqHb8eraG/MDRIvJTK68rQ3M8cO3ifBbY6rOUto9kTjpDnh3EhsuKvWgWw59ZnmcEv
         1evw==
X-Gm-Message-State: AOAM532icSxyAAYo74qxmSRyNGE1HZBOl1zD+BJCInCu9ZRvdQT1UNJd
        TQCtA+YqgipD0BHfTKb02pwaFgYFM2Yz2LwzaVrqPIowXT+KPgRhymLtMykHzerQaIzKqV8cUml
        6KEjsJRnBxMpwc+1q
X-Received: by 2002:adf:e588:: with SMTP id l8mr9647060wrm.255.1591875264177;
        Thu, 11 Jun 2020 04:34:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzp9renAKj8PmTNv1Sajxcl0ecOrev7nVeaEQM7VXOPARpXWTORRf8SSFeo90xhKgf6tYSZBQ==
X-Received: by 2002:adf:e588:: with SMTP id l8mr9647034wrm.255.1591875263907;
        Thu, 11 Jun 2020 04:34:23 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id e12sm4620751wro.52.2020.06.11.04.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 04:34:23 -0700 (PDT)
Date:   Thu, 11 Jun 2020 07:34:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v8 03/11] vhost/net: pass net specific struct pointer
Message-ID: <20200611113404.17810-4-mst@redhat.com>
References: <20200611113404.17810-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611113404.17810-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
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

