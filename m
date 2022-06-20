Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750A6550F98
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 07:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbiFTFLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 01:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238102AbiFTFLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 01:11:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 51B24DF0D
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 22:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655701894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wa2ot5Fo7RbbW6lw0Fk3KHdmtmg1p/Fg4yj+TyeGC2I=;
        b=D125gJ4Fvpg4EzDgao2W3WD9IpbYBDpvTNjBb462+D78n1DWjuIxW2p9vEnqp/SOmiA/c6
        bVVp+QpAbX8W8NnOs+VaeCiaZnnsVMRcNZqLgxQJeQhXSSacwFigUHMj/xUohEcFi6rq5v
        sXnoUHQHG4sI2izmfs3Vd+FITcvZxrY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-Z_GeqLXmO7en-0xzCJTh-w-1; Mon, 20 Jun 2022 01:11:32 -0400
X-MC-Unique: Z_GeqLXmO7en-0xzCJTh-w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE3E429ABA27;
        Mon, 20 Jun 2022 05:11:31 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-16.pek2.redhat.com [10.72.12.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5128C28112;
        Mon, 20 Jun 2022 05:11:28 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org, erwan.yvin@stericsson.com
Subject: [PATCH 3/3] caif_virtio: fix the race between reset and netdev unregister
Date:   Mon, 20 Jun 2022 13:11:15 +0800
Message-Id: <20220620051115.3142-4-jasowang@redhat.com>
In-Reply-To: <20220620051115.3142-1-jasowang@redhat.com>
References: <20220620051115.3142-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We use to do the following steps during .remove():

static void cfv_remove(struct virtio_device *vdev)
{
	struct cfv_info *cfv = vdev->priv;

	rtnl_lock();
	dev_close(cfv->ndev);
	rtnl_unlock();

	tasklet_kill(&cfv->tx_release_tasklet);
	debugfs_remove_recursive(cfv->debugfs);

	vringh_kiov_cleanup(&cfv->ctx.riov);
	virtio_reset_device(vdev);
	vdev->vringh_config->del_vrhs(cfv->vdev);
	cfv->vr_rx = NULL;
	vdev->config->del_vqs(cfv->vdev);
	unregister_netdev(cfv->ndev);
}

This is racy since device could be re-opened after dev_close() but
before unregister_netdevice():

1) RX vringh is cleaned before resetting the device, rx callbacks that
   is called after the vringh_kiov_cleanup() will result a UAF
2) Network stack can still try to use TX virtqueue even if it has been
   deleted after dev_vqs()

Fixing this by unregistering the network device first to make sure not
device access from both TX and RX side.

Fixes: 0d2e1a2926b18 ("caif_virtio: Introduce caif over virtio")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/caif/caif_virtio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index 66375bea2fcd..a29f9b2df5b1 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -752,9 +752,8 @@ static void cfv_remove(struct virtio_device *vdev)
 {
 	struct cfv_info *cfv = vdev->priv;
 
-	rtnl_lock();
-	dev_close(cfv->ndev);
-	rtnl_unlock();
+	/* Make sure NAPI/TX won't try to access the device */
+	unregister_netdev(cfv->ndev);
 
 	tasklet_kill(&cfv->tx_release_tasklet);
 	debugfs_remove_recursive(cfv->debugfs);
@@ -764,7 +763,6 @@ static void cfv_remove(struct virtio_device *vdev)
 	vdev->vringh_config->del_vrhs(cfv->vdev);
 	cfv->vr_rx = NULL;
 	vdev->config->del_vqs(cfv->vdev);
-	unregister_netdev(cfv->ndev);
 }
 
 static struct virtio_device_id id_table[] = {
-- 
2.25.1

