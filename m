Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40B95134F9
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347145AbiD1N0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 09:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347121AbiD1N0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 09:26:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E94DBAC92D
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 06:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651152177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W6dlhZBY+AtMsp+AcyPDmHg9swfew9GIgRtcUZ3Lw40=;
        b=T4G5KmPI4WnvPInu0t+P4AlhI8uZGAy/f3mb/fZ2T3Agp/L5QW6nTQeWrSkypZP9Je7YBU
        0vgnZBZ4qNWZ7jdh5w6uoWhqKJnnWCCCkXCb7uMMqAeCVVo6LcANw1Q5FiKsp08yBl8nvz
        s/fF2Pv8J/e4L3fkVN6RegbNdRJAjLc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-lyxHZGQeMfW-iDvb5frGKA-1; Thu, 28 Apr 2022 09:22:48 -0400
X-MC-Unique: lyxHZGQeMfW-iDvb5frGKA-1
Received: by mail-wm1-f70.google.com with SMTP id d13-20020a05600c3acd00b0038ff865c043so4376932wms.3
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 06:22:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W6dlhZBY+AtMsp+AcyPDmHg9swfew9GIgRtcUZ3Lw40=;
        b=L0kUJlzhBQrT4dhG7F/2ZIfO6LFbw4ABi3KUOJlZH1qspKGymtZXvOdU+i7F6bugy2
         ZqJvc5+zb5a95lClQg2ssFdGOV0+L+pwoT6ov0Dp6sPzTqHcU5zutfkUD6xil4BN3M2Z
         n5+vA8SxpIqyaPuXzT6V3kxRyY3Fd1VzbQnN9NIAK3PCOIMbA3SglalB3VJjnb4xWnyX
         yrvjuvx6fruT4yywAcrG2ipLeqAPJegbSjf2y00XNEnsyXfYvltmkyOoaFTPfMard15T
         w0TaJXz6+CZaNXvhSyWFEYzU+zXaQ9CcvTwZOsVagElqzINHDPmYEleTNoXBK9kfqNho
         04dA==
X-Gm-Message-State: AOAM530+fbFZ/AmU0u5ER5R2+TALxRQYNP2i8XemNZvQU5elkXfd7kxz
        JnZ+/RolGRMZYGtF3j24qtTHB1IkssQNB4V64JZuGugvPAlsX1ro8Q8YJxGbx/T3WyCtjbW3lst
        3oC70KmMuzkUTirTx1T6RRu7d9sNVQYQCK2FVMV9jJiKFXmA7cSsPesb5XriliXC68Muu
X-Received: by 2002:a05:6000:510:b0:203:e469:f0a3 with SMTP id a16-20020a056000051000b00203e469f0a3mr26951316wrf.710.1651152166635;
        Thu, 28 Apr 2022 06:22:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYAkm50ZItGhHTzdsIHOIHFbRvU2OlAJNnEs3e9LhZU6vcKw9GOx6UJGzwm9gFfHP9K8b2vw==
X-Received: by 2002:a05:6000:510:b0:203:e469:f0a3 with SMTP id a16-20020a056000051000b00203e469f0a3mr26951279wrf.710.1651152166162;
        Thu, 28 Apr 2022 06:22:46 -0700 (PDT)
Received: from step1.redhat.com (host-87-11-6-234.retail.telecomitalia.it. [87.11.6.234])
        by smtp.gmail.com with ESMTPSA id f7-20020a05600c4e8700b00393f1393abfsm4680978wmq.41.2022.04.28.06.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:22:45 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vilas R K <vilas.r.k@intel.com>,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH net-next 1/2] vsock/virtio: factor our the code to initialize and delete VQs
Date:   Thu, 28 Apr 2022 15:22:40 +0200
Message-Id: <20220428132241.152679-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220428132241.152679-1-sgarzare@redhat.com>
References: <20220428132241.152679-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add virtio_vsock_vqs_init() and virtio_vsock_vqs_del() with the code
that was in virtio_vsock_probe() and virtio_vsock_remove to initialize
and delete VQs.

These new functions will be used in the next commit to support device
suspend/resume

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 150 +++++++++++++++++--------------
 1 file changed, 84 insertions(+), 66 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index ba1c8cc0c467..31f4f6f40614 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -566,67 +566,28 @@ static void virtio_transport_rx_work(struct work_struct *work)
 	mutex_unlock(&vsock->rx_lock);
 }
 
-static int virtio_vsock_probe(struct virtio_device *vdev)
+static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 {
-	vq_callback_t *callbacks[] = {
-		virtio_vsock_rx_done,
-		virtio_vsock_tx_done,
-		virtio_vsock_event_done,
-	};
+	struct virtio_device *vdev = vsock->vdev;
 	static const char * const names[] = {
 		"rx",
 		"tx",
 		"event",
 	};
-	struct virtio_vsock *vsock = NULL;
+	vq_callback_t *callbacks[] = {
+		virtio_vsock_rx_done,
+		virtio_vsock_tx_done,
+		virtio_vsock_event_done,
+	};
 	int ret;
 
-	ret = mutex_lock_interruptible(&the_virtio_vsock_mutex);
-	if (ret)
-		return ret;
-
-	/* Only one virtio-vsock device per guest is supported */
-	if (rcu_dereference_protected(the_virtio_vsock,
-				lockdep_is_held(&the_virtio_vsock_mutex))) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	vsock = kzalloc(sizeof(*vsock), GFP_KERNEL);
-	if (!vsock) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	vsock->vdev = vdev;
-
-	ret = virtio_find_vqs(vsock->vdev, VSOCK_VQ_MAX,
-			      vsock->vqs, callbacks, names,
+	ret = virtio_find_vqs(vdev, VSOCK_VQ_MAX, vsock->vqs, callbacks, names,
 			      NULL);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	virtio_vsock_update_guest_cid(vsock);
 
-	vsock->rx_buf_nr = 0;
-	vsock->rx_buf_max_nr = 0;
-	atomic_set(&vsock->queued_replies, 0);
-
-	mutex_init(&vsock->tx_lock);
-	mutex_init(&vsock->rx_lock);
-	mutex_init(&vsock->event_lock);
-	spin_lock_init(&vsock->send_pkt_list_lock);
-	INIT_LIST_HEAD(&vsock->send_pkt_list);
-	INIT_WORK(&vsock->rx_work, virtio_transport_rx_work);
-	INIT_WORK(&vsock->tx_work, virtio_transport_tx_work);
-	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
-	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
-
-	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
-		vsock->seqpacket_allow = true;
-
-	vdev->priv = vsock;
-
 	virtio_device_ready(vdev);
 
 	mutex_lock(&vsock->tx_lock);
@@ -643,30 +604,15 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	vsock->event_run = true;
 	mutex_unlock(&vsock->event_lock);
 
-	rcu_assign_pointer(the_virtio_vsock, vsock);
-
-	mutex_unlock(&the_virtio_vsock_mutex);
-
 	return 0;
-
-out:
-	kfree(vsock);
-	mutex_unlock(&the_virtio_vsock_mutex);
-	return ret;
 }
 
-static void virtio_vsock_remove(struct virtio_device *vdev)
+static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
 {
-	struct virtio_vsock *vsock = vdev->priv;
+	struct virtio_device *vdev = vsock->vdev;
 	struct virtio_vsock_pkt *pkt;
 
-	mutex_lock(&the_virtio_vsock_mutex);
-
-	vdev->priv = NULL;
-	rcu_assign_pointer(the_virtio_vsock, NULL);
-	synchronize_rcu();
-
-	/* Reset all connected sockets when the device disappear */
+	/* Reset all connected sockets when the VQs disappear */
 	vsock_for_each_connected_socket(&virtio_transport.transport,
 					virtio_vsock_reset_sock);
 
@@ -711,6 +657,78 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 
 	/* Delete virtqueues and flush outstanding callbacks if any */
 	vdev->config->del_vqs(vdev);
+}
+
+static int virtio_vsock_probe(struct virtio_device *vdev)
+{
+	struct virtio_vsock *vsock = NULL;
+	int ret;
+
+	ret = mutex_lock_interruptible(&the_virtio_vsock_mutex);
+	if (ret)
+		return ret;
+
+	/* Only one virtio-vsock device per guest is supported */
+	if (rcu_dereference_protected(the_virtio_vsock,
+				lockdep_is_held(&the_virtio_vsock_mutex))) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	vsock = kzalloc(sizeof(*vsock), GFP_KERNEL);
+	if (!vsock) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	vsock->vdev = vdev;
+
+	vsock->rx_buf_nr = 0;
+	vsock->rx_buf_max_nr = 0;
+	atomic_set(&vsock->queued_replies, 0);
+
+	mutex_init(&vsock->tx_lock);
+	mutex_init(&vsock->rx_lock);
+	mutex_init(&vsock->event_lock);
+	spin_lock_init(&vsock->send_pkt_list_lock);
+	INIT_LIST_HEAD(&vsock->send_pkt_list);
+	INIT_WORK(&vsock->rx_work, virtio_transport_rx_work);
+	INIT_WORK(&vsock->tx_work, virtio_transport_tx_work);
+	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
+	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
+
+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
+		vsock->seqpacket_allow = true;
+
+	vdev->priv = vsock;
+
+	ret = virtio_vsock_vqs_init(vsock);
+	if (ret < 0)
+		goto out;
+
+	rcu_assign_pointer(the_virtio_vsock, vsock);
+
+	mutex_unlock(&the_virtio_vsock_mutex);
+
+	return 0;
+
+out:
+	kfree(vsock);
+	mutex_unlock(&the_virtio_vsock_mutex);
+	return ret;
+}
+
+static void virtio_vsock_remove(struct virtio_device *vdev)
+{
+	struct virtio_vsock *vsock = vdev->priv;
+
+	mutex_lock(&the_virtio_vsock_mutex);
+
+	vdev->priv = NULL;
+	rcu_assign_pointer(the_virtio_vsock, NULL);
+	synchronize_rcu();
+
+	virtio_vsock_vqs_del(vsock);
 
 	/* Other works can be queued before 'config->del_vqs()', so we flush
 	 * all works before to free the vsock object to avoid use after free.
-- 
2.35.1

