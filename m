Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5193F550F9A
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 07:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbiFTFLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 01:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238102AbiFTFLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 01:11:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E10F1DF17
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 22:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655701892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vRVhHNu1jFH96XfUUtPDbpNe4wane69cNx7I4Zb9yYc=;
        b=Kg8KcO8mFSUZBH9Eq/JwWJKMvFrQZmB4SqCvKa0ThYVFhr2AxW+o6hdMpevDUJ1O2uswly
        qiXAvNd4A0XyqaFRoNUhpHk3cuZs7n4XuPD7qpd33un0EGuSwMLERdYCVycu6i6+TMjN4M
        AXAvA/cQDOWN2z/A0S7sFwHDw0wbN5U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-xl3k3ciZP72VZ9PXGnP3tQ-1; Mon, 20 Jun 2022 01:11:28 -0400
X-MC-Unique: xl3k3ciZP72VZ9PXGnP3tQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B0081C05AB5;
        Mon, 20 Jun 2022 05:11:28 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-16.pek2.redhat.com [10.72.12.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49A91C28112;
        Mon, 20 Jun 2022 05:11:24 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org, erwan.yvin@stericsson.com
Subject: [PATCH 2/3] caif_virtio: fix the race between virtio_device_ready() and ndo_open()
Date:   Mon, 20 Jun 2022 13:11:14 +0800
Message-Id: <20220620051115.3142-3-jasowang@redhat.com>
In-Reply-To: <20220620051115.3142-1-jasowang@redhat.com>
References: <20220620051115.3142-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We used to depend on the virtio_device_ready() that is called after
probe() by virtio_dev_probe() after netdev registration. This
cause a race between ndo_open() and virtio_device_ready(): if
ndo_open() is called before virtio_device_ready(), the driver may
start to use the device (e.g TX) before DRIVER_OK which violates the
spec.

Fixing this by switching to use register_netdevice() and protect the
virtio_device_ready() with rtnl_lock() to make sure ndo_open() can
only be called after virtio_device_ready().

Fixes: 0d2e1a2926b18 ("caif_virtio: Introduce caif over virtio")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/caif/caif_virtio.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index c677ded81133..66375bea2fcd 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -719,13 +719,21 @@ static int cfv_probe(struct virtio_device *vdev)
 	/* Carrier is off until netdevice is opened */
 	netif_carrier_off(netdev);
 
+	/* serialize netdev register + virtio_device_ready() with ndo_open() */
+	rtnl_lock();
+
 	/* register Netdev */
-	err = register_netdev(netdev);
+	err = register_netdevice(netdev);
 	if (err) {
+		rtnl_unlock();
 		dev_err(&vdev->dev, "Unable to register netdev (%d)\n", err);
 		goto err;
 	}
 
+	virtio_device_ready(vdev);
+
+	rtnl_unlock();
+
 	debugfs_init(cfv);
 
 	return 0;
-- 
2.25.1

