Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745D66560F5
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 08:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbiLZHvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 02:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbiLZHu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 02:50:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF476160
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 23:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672040980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cQQAF2roIs1AkbrATZH+Dx5zgxJxII5XuDrBnrFmmR0=;
        b=fvQ9pBghg2PDnyPDrafgNgpe4X28DvyXSyDUJJ/QJL+B+X0xXbl8rRCky7fV+EWAi7Ix2h
        XykaH+cPqPYEUJ4uOO6sL1gkAR2QkwQHmYxhxeWbpOWMjU+SfU8QBw+DM0EbYbeK/y2PsK
        +ViIZOYEq/OVRnsh7bK/InxEnWrdt8E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-fpqLXZzLMJGNQN3y84BlPg-1; Mon, 26 Dec 2022 02:49:37 -0500
X-MC-Unique: fpqLXZzLMJGNQN3y84BlPg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4982101A52E;
        Mon, 26 Dec 2022 07:49:36 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-100.pek2.redhat.com [10.72.13.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE333492B00;
        Mon, 26 Dec 2022 07:49:31 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: [PATCH 4/4] virtio-net: sleep instead of busy waiting for cvq command
Date:   Mon, 26 Dec 2022 15:49:08 +0800
Message-Id: <20221226074908.8154-5-jasowang@redhat.com>
In-Reply-To: <20221226074908.8154-1-jasowang@redhat.com>
References: <20221226074908.8154-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We used to busy waiting on the cvq command this tends to be
problematic since:

1) CPU could wait for ever on a buggy/malicous device
2) There's no wait to terminate the process that triggers the cvq
   command

So this patch switch to use virtqueue_wait_for_used() to sleep with a
timeout (1s) instead of busy polling for the cvq command forever. This
gives the scheduler a breath and can let the process can respond to
asignal. If the device doesn't respond in the timeout, break the
device.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes since V1:
- break the device when timeout
- get buffer manually since the virtio core check more_used() instead
---
 drivers/net/virtio_net.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index efd9dd55828b..6a2ea64cfcb5 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -405,6 +405,7 @@ static void disable_rx_mode_work(struct virtnet_info *vi)
 	vi->rx_mode_work_enabled = false;
 	spin_unlock_bh(&vi->rx_mode_lock);
 
+	virtqueue_wake_up(vi->cvq);
 	flush_work(&vi->rx_mode_work);
 }
 
@@ -1497,6 +1498,11 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
 	return !oom;
 }
 
+static void virtnet_cvq_done(struct virtqueue *cvq)
+{
+	virtqueue_wake_up(cvq);
+}
+
 static void skb_recv_done(struct virtqueue *rvq)
 {
 	struct virtnet_info *vi = rvq->vdev->priv;
@@ -1984,6 +1990,8 @@ static int virtnet_tx_resize(struct virtnet_info *vi,
 	return err;
 }
 
+static int virtnet_close(struct net_device *dev);
+
 /*
  * Send command via the control virtqueue and check status.  Commands
  * supported by the hypervisor, as indicated by feature bits, should
@@ -2026,14 +2034,14 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
 	if (unlikely(!virtqueue_kick(vi->cvq)))
 		return vi->ctrl->status == VIRTIO_NET_OK;
 
-	/* Spin for a response, the kick causes an ioport write, trapping
-	 * into the hypervisor, so the request should be handled immediately.
-	 */
-	while (!virtqueue_get_buf(vi->cvq, &tmp) &&
-	       !virtqueue_is_broken(vi->cvq))
-		cpu_relax();
+	if (virtqueue_wait_for_used(vi->cvq)) {
+		virtqueue_get_buf(vi->cvq, &tmp);
+		return vi->ctrl->status == VIRTIO_NET_OK;
+	}
 
-	return vi->ctrl->status == VIRTIO_NET_OK;
+	netdev_err(vi->dev, "CVQ command timeout, break the virtio device.");
+	virtio_break_device(vi->vdev);
+	return VIRTIO_NET_ERR;
 }
 
 static int virtnet_set_mac_address(struct net_device *dev, void *p)
@@ -3526,7 +3534,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 
 	/* Parameters for control virtqueue, if any */
 	if (vi->has_cvq) {
-		callbacks[total_vqs - 1] = NULL;
+		callbacks[total_vqs - 1] = virtnet_cvq_done;
 		names[total_vqs - 1] = "control";
 	}
 
-- 
2.25.1

