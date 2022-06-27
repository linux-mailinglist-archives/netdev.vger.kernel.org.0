Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2E755D0AD
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbiF0GhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 02:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiF0GhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 02:37:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0A832722
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 23:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656311828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Fl5g9NFjvXIN0xGJA157NHcsEoJ12uvuRlfGLrOUGTg=;
        b=BDGUtCVk2rBc9b5ArJzQo5875ZcFZhMyPTWuOsqsHt7RTrnTTb6X7q9MwFyeJ+mHRrWYJE
        rD0G1+wdXvHToMoN9tVejbMU6dsSH0pM2Au3uH1tl+Ajwz5sIkIhLw7O6hBcRKAYWkK0dZ
        vYUROCjQcwP6NhRdY5nFMXIxn6nEfig=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-Uvr-jxNPM8KUU4ivKBKgAA-1; Mon, 27 Jun 2022 02:37:02 -0400
X-MC-Unique: Uvr-jxNPM8KUU4ivKBKgAA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C45661C08964;
        Mon, 27 Jun 2022 06:37:01 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-66.pek2.redhat.com [10.72.12.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C08D61415108;
        Mon, 27 Jun 2022 06:36:58 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] virtio-net: fix race between ndo_open() and virtio_device_ready()
Date:   Mon, 27 Jun 2022 14:36:56 +0800
Message-Id: <20220627063656.52397-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We used to call virtio_device_ready() after netdev registration. This
cause a race between ndo_open() and virtio_device_ready(): if
ndo_open() is called before virtio_device_ready(), the driver may
start to use the device before DRIVER_OK which violates the spec.

Fixing this by switching to use register_netdevice() and protect the
virtio_device_ready() with rtnl_lock() to make sure ndo_open() can
only be called after virtio_device_ready().

Fixes: 4baf1e33d0842 ("virtio_net: enable VQs early")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index db05b5e930be..8a5810bcb839 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3655,14 +3655,20 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (vi->has_rss || vi->has_rss_hash_report)
 		virtnet_init_default_rss(vi);
 
-	err = register_netdev(dev);
+	/* serialize netdev register + virtio_device_ready() with ndo_open() */
+	rtnl_lock();
+
+	err = register_netdevice(dev);
 	if (err) {
 		pr_debug("virtio_net: registering device failed\n");
+		rtnl_unlock();
 		goto free_failover;
 	}
 
 	virtio_device_ready(vdev);
 
+	rtnl_unlock();
+
 	err = virtnet_cpu_notif_add(vi);
 	if (err) {
 		pr_debug("virtio_net: registering cpu notifier failed\n");
-- 
2.25.1

