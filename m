Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3F66560EE
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 08:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiLZHuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 02:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbiLZHuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 02:50:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E26A6145
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 23:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672040967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=35zLZwgpZzPWsmc0E40bJzgqya6RhlIevYxkApG1GCU=;
        b=B7fK9jc5v/mmM070W7LrBNGThJ3nIbhC5z9v072PsTvOExWyX89r0K3f2d70J9QnMGZXLM
        cO9rnMzulqpVO941QB6O1M7Ak4oud4dymSrmbuxY+dact+c+8RENL309z/Xo+t3+4PDgdy
        hCPdHe27i4X+x8NR2UDmSG7qEGPrPtE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-Sn-ZY8cfO-CI_5uqf-CTGg-1; Mon, 26 Dec 2022 02:49:26 -0500
X-MC-Unique: Sn-ZY8cfO-CI_5uqf-CTGg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5DCC380406F;
        Mon, 26 Dec 2022 07:49:25 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-100.pek2.redhat.com [10.72.13.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E0B9492B00;
        Mon, 26 Dec 2022 07:49:20 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: [PATCH 2/4] virtio_ring: switch to use BAD_RING()
Date:   Mon, 26 Dec 2022 15:49:06 +0800
Message-Id: <20221226074908.8154-3-jasowang@redhat.com>
In-Reply-To: <20221226074908.8154-1-jasowang@redhat.com>
References: <20221226074908.8154-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to reuse BAD_RING() to allow common logic to be implemented in
BAD_RING().

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes since V1:
- switch to use BAD_RING in virtio_break_device()
---
 drivers/virtio/virtio_ring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 2e7689bb933b..5cfb2fa8abee 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -58,7 +58,8 @@
 	do {							\
 		dev_err(&_vq->vq.vdev->dev,			\
 			"%s:"fmt, (_vq)->vq.name, ##args);	\
-		(_vq)->broken = true;				\
+		/* Pairs with READ_ONCE() in virtqueue_is_broken(). */ \
+		WRITE_ONCE((_vq)->broken, true);		       \
 	} while (0)
 #define START_USE(vq)
 #define END_USE(vq)
@@ -2237,7 +2238,7 @@ bool virtqueue_notify(struct virtqueue *_vq)
 
 	/* Prod other side to tell it about changes. */
 	if (!vq->notify(_vq)) {
-		vq->broken = true;
+		BAD_RING(vq, "vq %d is broken\n", vq->vq.index);
 		return false;
 	}
 	return true;
@@ -2786,8 +2787,7 @@ void virtio_break_device(struct virtio_device *dev)
 	list_for_each_entry(_vq, &dev->vqs, list) {
 		struct vring_virtqueue *vq = to_vvq(_vq);
 
-		/* Pairs with READ_ONCE() in virtqueue_is_broken(). */
-		WRITE_ONCE(vq->broken, true);
+		BAD_RING(vq, "Device break vq %d", _vq->index);
 	}
 	spin_unlock(&dev->vqs_list_lock);
 }
-- 
2.25.1

