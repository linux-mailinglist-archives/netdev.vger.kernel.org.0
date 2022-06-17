Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A8854F1FE
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 09:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380257AbiFQHaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 03:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348356AbiFQHaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 03:30:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9D0FB7C3
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 00:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655451001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Fl5g9NFjvXIN0xGJA157NHcsEoJ12uvuRlfGLrOUGTg=;
        b=IA63psFjlIxTZdYLFCUOQR3yTvKgmhBhKCu4g44Kmrb+dHIeSPnOfROXaFLuIuAhrEYkWz
        O2MZk7HXox/uuuILBr4+DcRAPkG7nAF1a9hOFMQgXMf2VC4zVZEpF8i0JjfB9NSXUzBt1l
        29d00y3NeHEWC/e5KbvH5gFk4zV8Ows=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-ndiwV_2hPRySbG87GwEyPg-1; Fri, 17 Jun 2022 03:29:55 -0400
X-MC-Unique: ndiwV_2hPRySbG87GwEyPg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CD8D802C17;
        Fri, 17 Jun 2022 07:29:55 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-87.pek2.redhat.com [10.72.13.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68F4740C141F;
        Fri, 17 Jun 2022 07:29:52 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] virtio-net: fix race between ndo_open() and virtio_device_ready()
Date:   Fri, 17 Jun 2022 15:29:49 +0800
Message-Id: <20220617072949.30734-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

