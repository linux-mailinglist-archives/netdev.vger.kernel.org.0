Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0DF653C06
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 07:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbiLVGGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 01:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235084AbiLVGGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 01:06:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67F21CB1F
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 22:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671689106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iq4cHvbMQpVcmBqe5fyUmrngiKVykMmjcTZb1s9VM+M=;
        b=XisQSdIjVpfRAH0vj57/2guOh0iUndxVGfbCROpTSCm3ZGmGCql2UWF6NUsnEuPBFkb31f
        1ktkaJgZRwEUyguCfmB4Y4zYFAiwz0dHK5+h/tklkkfOfZpaQUs1vG9veV7kY7LQa0ICdm
        WWWKt+B3uIszyhtd99gT5NH+nwbHVlI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-A0Z1sWhoPamSGCtY6shq7w-1; Thu, 22 Dec 2022 01:05:02 -0500
X-MC-Unique: A0Z1sWhoPamSGCtY6shq7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C82F38149BC;
        Thu, 22 Dec 2022 06:05:02 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-179.pek2.redhat.com [10.72.13.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC707112132C;
        Thu, 22 Dec 2022 06:04:55 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: [RFC PATCH 4/4] virtio-net: sleep instead of busy waiting for cvq command
Date:   Thu, 22 Dec 2022 14:04:27 +0800
Message-Id: <20221222060427.21626-5-jasowang@redhat.com>
In-Reply-To: <20221222060427.21626-1-jasowang@redhat.com>
References: <20221222060427.21626-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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

So this patch switch to use sleep with a timeout (1s) instead of busy
polling for the cvq command forever. This gives the scheduler a breath
and can let the process can respond to a signal.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8225496ccb1e..69173049371f 100644
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
@@ -2024,12 +2030,7 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
 	if (unlikely(!virtqueue_kick(vi->cvq)))
 		return vi->ctrl->status == VIRTIO_NET_OK;
 
-	/* Spin for a response, the kick causes an ioport write, trapping
-	 * into the hypervisor, so the request should be handled immediately.
-	 */
-	while (!virtqueue_get_buf(vi->cvq, &tmp) &&
-	       !virtqueue_is_broken(vi->cvq))
-		cpu_relax();
+	virtqueue_wait_for_used(vi->cvq, &tmp);
 
 	return vi->ctrl->status == VIRTIO_NET_OK;
 }
@@ -3524,7 +3525,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 
 	/* Parameters for control virtqueue, if any */
 	if (vi->has_cvq) {
-		callbacks[total_vqs - 1] = NULL;
+		callbacks[total_vqs - 1] = virtnet_cvq_done;
 		names[total_vqs - 1] = "control";
 	}
 
-- 
2.25.1

