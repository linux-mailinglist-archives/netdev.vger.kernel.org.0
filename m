Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4DF7594E6D
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 04:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240191AbiHPCCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 22:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbiHPCBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 22:01:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 443B4107F36
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660600414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n9xDuhV9iHcXHcEoNmD/7wsehe62kvIxVjlpcT9npdI=;
        b=cz49QCc91hRjAjoIVqSygKE2UmBCHKBVprl3LnMC8b8zY/Cu+GYFLpKbLaz84rwzl1TaIL
        Fa1B4uaeIMUA+ihm6FZXmbnNcLYn4lZW95ayerwkqYKCXr1kLwYpxiv6abzf0oFm+JCZtn
        qyC7/zMSQqeHGkHkPOgg3pKeOt7G65I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-389-OVjEWJB2MwyWb3q0O2loog-1; Mon, 15 Aug 2022 17:53:30 -0400
X-MC-Unique: OVjEWJB2MwyWb3q0O2loog-1
Received: by mail-wm1-f72.google.com with SMTP id j36-20020a05600c1c2400b003a540d88677so4062123wms.1
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:53:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=n9xDuhV9iHcXHcEoNmD/7wsehe62kvIxVjlpcT9npdI=;
        b=NsgDyeNs+gaUb13jAT3JM4/F447Dw9hOWTNuDpIuXAbHTqFPj7285EB1TcPdjXj9An
         tFcufpeihNMXi67OMuEQDkzJOry1pVbWNLM95qTSrTN0muGLZzV2UhN1M2SnrWYRKkZs
         5xrqPpWMS+/PQqUpUTVfB29IPXYwpOpr2dZRgheMZq6WNqQBiBN9+Ykoq30fYRWDrSRB
         SuKmsnAs9HuDFhNiSo3JEDb3U7pNnVobEeMdpuSwE4Le4wmw9hfUEqPTAjhsaW75ZKKY
         qqZfabyKCn7jQqc5BHLp9OrRbHDCIROyqJg5pbS8ySgrJs04rBdevXGz09LIKd6r80ge
         LwTg==
X-Gm-Message-State: ACgBeo1i9RgOrc2szzSNW/tufpzpJzds26yEsHnmwt11EpAOeJHV0xxH
        QYMoMIJCImlMrWAkNsg3qWgkPeNwbHvsddLNQefRVgjX2hOPMOiudQ2T7AYevkE7bA502gR2yQr
        IusDUEEVr5ZNXD1Jc
X-Received: by 2002:a05:6000:a1b:b0:220:6d98:e97e with SMTP id co27-20020a0560000a1b00b002206d98e97emr10160829wrb.211.1660600409330;
        Mon, 15 Aug 2022 14:53:29 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5eGYjtb0ao+td67NPUSA+l/VN9/A+r9WJoEcUsIJYOX4UpWH4A8YuFS6y8s/3ZvOYQ5c9VkA==
X-Received: by 2002:a05:6000:a1b:b0:220:6d98:e97e with SMTP id co27-20020a0560000a1b00b002206d98e97emr10160811wrb.211.1660600409075;
        Mon, 15 Aug 2022 14:53:29 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id p15-20020adf9d8f000000b00223654e0eccsm10714216wre.9.2022.08.15.14.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 14:53:28 -0700 (PDT)
Date:   Mon, 15 Aug 2022 17:53:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andres Freund <andres@anarazel.de>
Subject: [PATCH v2 1/5] virtio_net: Revert "virtio_net: set the default max
 ring size by find_vqs()"
Message-ID: <20220815215251.154451-3-mst@redhat.com>
References: <20220815215251.154451-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815215251.154451-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 762faee5a2678559d3dc09d95f8f2c54cd0466a7.

This has been reported to trip up guests on GCP (Google Cloud).
The reason is that virtio_find_vqs_ctx_size is broken on legacy
devices. We can in theory fix virtio_find_vqs_ctx_size but
in fact the patch itself has several other issues:

- It treats unknown speed as < 10G
- It leaves userspace no way to find out the ring size set by hypervisor
- It tests speed when link is down
- It ignores the virtio spec advice:
        Both \field{speed} and \field{duplex} can change, thus the driver
        is expected to re-read these values after receiving a
        configuration change notification.
- It is not clear the performance impact has been tested properly

Revert the patch for now.

Reported-by: Andres Freund <andres@anarazel.de>
Link: https://lore.kernel.org/r/20220814212610.GA3690074%40roeck-us.net
Link: https://lore.kernel.org/r/20220815070203.plwjx7b3cyugpdt7%40awork3.anarazel.de
Link: https://lore.kernel.org/r/3df6bb82-1951-455d-a768-e9e1513eb667%40www.fastmail.com
Link: https://lore.kernel.org/r/FCDC5DDE-3CDD-4B8A-916F-CA7D87B547CE%40anarazel.de
Fixes: 762faee5a267 ("virtio_net: set the default max ring size by find_vqs()")
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Andres Freund <andres@anarazel.de>
Tested-by: From: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/virtio_net.c | 42 ++++------------------------------------
 1 file changed, 4 insertions(+), 38 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d934774e9733..ece00b84e3a7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3432,29 +3432,6 @@ static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqu
 		   (unsigned int)GOOD_PACKET_LEN);
 }
 
-static void virtnet_config_sizes(struct virtnet_info *vi, u32 *sizes)
-{
-	u32 i, rx_size, tx_size;
-
-	if (vi->speed == SPEED_UNKNOWN || vi->speed < SPEED_10000) {
-		rx_size = 1024;
-		tx_size = 1024;
-
-	} else if (vi->speed < SPEED_40000) {
-		rx_size = 1024 * 4;
-		tx_size = 1024 * 4;
-
-	} else {
-		rx_size = 1024 * 8;
-		tx_size = 1024 * 8;
-	}
-
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		sizes[rxq2vq(i)] = rx_size;
-		sizes[txq2vq(i)] = tx_size;
-	}
-}
-
 static int virtnet_find_vqs(struct virtnet_info *vi)
 {
 	vq_callback_t **callbacks;
@@ -3462,7 +3439,6 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 	int ret = -ENOMEM;
 	int i, total_vqs;
 	const char **names;
-	u32 *sizes;
 	bool *ctx;
 
 	/* We expect 1 RX virtqueue followed by 1 TX virtqueue, followed by
@@ -3490,15 +3466,10 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 		ctx = NULL;
 	}
 
-	sizes = kmalloc_array(total_vqs, sizeof(*sizes), GFP_KERNEL);
-	if (!sizes)
-		goto err_sizes;
-
 	/* Parameters for control virtqueue, if any */
 	if (vi->has_cvq) {
 		callbacks[total_vqs - 1] = NULL;
 		names[total_vqs - 1] = "control";
-		sizes[total_vqs - 1] = 64;
 	}
 
 	/* Allocate/initialize parameters for send/receive virtqueues */
@@ -3513,10 +3484,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 			ctx[rxq2vq(i)] = true;
 	}
 
-	virtnet_config_sizes(vi, sizes);
-
-	ret = virtio_find_vqs_ctx_size(vi->vdev, total_vqs, vqs, callbacks,
-				       names, sizes, ctx, NULL);
+	ret = virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, callbacks,
+				  names, ctx, NULL);
 	if (ret)
 		goto err_find;
 
@@ -3536,8 +3505,6 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 
 
 err_find:
-	kfree(sizes);
-err_sizes:
 	kfree(ctx);
 err_ctx:
 	kfree(names);
@@ -3897,9 +3864,6 @@ static int virtnet_probe(struct virtio_device *vdev)
 		vi->curr_queue_pairs = num_online_cpus();
 	vi->max_queue_pairs = max_queue_pairs;
 
-	virtnet_init_settings(dev);
-	virtnet_update_settings(vi);
-
 	/* Allocate/initialize the rx/tx queues, and invoke find_vqs */
 	err = init_vqs(vi);
 	if (err)
@@ -3912,6 +3876,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 	netif_set_real_num_tx_queues(dev, vi->curr_queue_pairs);
 	netif_set_real_num_rx_queues(dev, vi->curr_queue_pairs);
 
+	virtnet_init_settings(dev);
+
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_STANDBY)) {
 		vi->failover = net_failover_create(vi->dev);
 		if (IS_ERR(vi->failover)) {
-- 
MST

