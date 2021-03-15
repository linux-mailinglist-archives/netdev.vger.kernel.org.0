Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A3D33C241
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbhCOQh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:37:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234500AbhCOQhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:37:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615826229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U8vUFAmjRmjmnzMs61Tq8yFKJeXqpEIeLAUIhyE/5+k=;
        b=IJ5EC6yEzuHdKm88ezEi72Dkve2vPmRpLGvthifaVxNq3RqWI3dby1CxiJz9gdH2Wv/kZN
        Jf1cBmL42KMFcboxpkMM4q/mgpP5sfEwlM9Z4dqQ1Z5dbykGt/g7Nige8YJA8bIBfrRvpG
        rTxkFhg0rkX7OdhPBW6wJutnUthyYTg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-rnp7GeiANpG-K6VdCCLdvg-1; Mon, 15 Mar 2021 12:37:05 -0400
X-MC-Unique: rnp7GeiANpG-K6VdCCLdvg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22B4C8015BD;
        Mon, 15 Mar 2021 16:37:03 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-1.ams2.redhat.com [10.36.114.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8AC55D705;
        Mon, 15 Mar 2021 16:37:00 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v4 14/14] vdpa_sim_blk: add support for vdpa management tool
Date:   Mon, 15 Mar 2021 17:34:50 +0100
Message-Id: <20210315163450.254396-15-sgarzare@redhat.com>
In-Reply-To: <20210315163450.254396-1-sgarzare@redhat.com>
References: <20210315163450.254396-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the user to create vDPA block simulator devices using the
vdpa management tool:

    # Show vDPA supported devices
    $ vdpa mgmtdev show
    vdpasim_blk:
      supported_classes block

    # Create a vDPA block device named as 'blk0' from the management
    # device vdpasim:
    $ vdpa dev add mgmtdev vdpasim_blk name blk0

    # Show the info of the 'blk0' device just created
    $ vdpa dev show blk0 -jp
    {
        "dev": {
            "blk0": {
                "type": "block",
                "mgmtdev": "vdpasim_blk",
                "vendor_id": 0,
                "max_vqs": 1,
                "max_vq_size": 256
            }
        }
    }

    # Delete the vDPA device after its use
    $ vdpa dev del blk0

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 76 +++++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 13 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index 643ae3bc62c0..5bfe1c281645 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -37,7 +37,6 @@
 #define VDPASIM_BLK_SEG_MAX	32
 #define VDPASIM_BLK_VQ_NUM	1
 
-static struct vdpasim *vdpasim_blk_dev;
 static char vdpasim_blk_id[VIRTIO_BLK_ID_BYTES] = "vdpa_blk_sim";
 
 static bool vdpasim_blk_check_range(u64 start_sector, size_t range_size)
@@ -241,11 +240,23 @@ static void vdpasim_blk_get_config(struct vdpasim *vdpasim, void *config)
 	blk_config->blk_size = cpu_to_vdpasim32(vdpasim, SECTOR_SIZE);
 }
 
-static int __init vdpasim_blk_init(void)
+static void vdpasim_blk_mgmtdev_release(struct device *dev)
+{
+}
+
+static struct device vdpasim_blk_mgmtdev = {
+	.init_name = "vdpasim_blk",
+	.release = vdpasim_blk_mgmtdev_release,
+};
+
+static int vdpasim_blk_dev_add(struct vdpa_mgmt_dev *mdev, const char *name)
 {
 	struct vdpasim_dev_attr dev_attr = {};
+	struct vdpasim *simdev;
 	int ret;
 
+	dev_attr.mgmt_dev = mdev;
+	dev_attr.name = name;
 	dev_attr.id = VIRTIO_ID_BLOCK;
 	dev_attr.supported_features = VDPASIM_BLK_FEATURES;
 	dev_attr.nvqs = VDPASIM_BLK_VQ_NUM;
@@ -254,29 +265,68 @@ static int __init vdpasim_blk_init(void)
 	dev_attr.work_fn = vdpasim_blk_work;
 	dev_attr.buffer_size = VDPASIM_BLK_CAPACITY << SECTOR_SHIFT;
 
-	vdpasim_blk_dev = vdpasim_create(&dev_attr);
-	if (IS_ERR(vdpasim_blk_dev)) {
-		ret = PTR_ERR(vdpasim_blk_dev);
-		goto out;
-	}
+	simdev = vdpasim_create(&dev_attr);
+	if (IS_ERR(simdev))
+		return PTR_ERR(simdev);
 
-	ret = vdpa_register_device(&vdpasim_blk_dev->vdpa, VDPASIM_BLK_VQ_NUM);
+	ret = _vdpa_register_device(&simdev->vdpa, VDPASIM_BLK_VQ_NUM);
 	if (ret)
 		goto put_dev;
 
 	return 0;
 
 put_dev:
-	put_device(&vdpasim_blk_dev->vdpa.dev);
-out:
+	put_device(&simdev->vdpa.dev);
 	return ret;
 }
 
-static void __exit vdpasim_blk_exit(void)
+static void vdpasim_blk_dev_del(struct vdpa_mgmt_dev *mdev,
+				struct vdpa_device *dev)
 {
-	struct vdpa_device *vdpa = &vdpasim_blk_dev->vdpa;
+	struct vdpasim *simdev = container_of(dev, struct vdpasim, vdpa);
+
+	_vdpa_unregister_device(&simdev->vdpa);
+}
+
+static const struct vdpa_mgmtdev_ops vdpasim_blk_mgmtdev_ops = {
+	.dev_add = vdpasim_blk_dev_add,
+	.dev_del = vdpasim_blk_dev_del
+};
 
-	vdpa_unregister_device(vdpa);
+static struct virtio_device_id id_table[] = {
+	{ VIRTIO_ID_BLOCK, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static struct vdpa_mgmt_dev mgmt_dev = {
+	.device = &vdpasim_blk_mgmtdev,
+	.id_table = id_table,
+	.ops = &vdpasim_blk_mgmtdev_ops,
+};
+
+static int __init vdpasim_blk_init(void)
+{
+	int ret;
+
+	ret = device_register(&vdpasim_blk_mgmtdev);
+	if (ret)
+		return ret;
+
+	ret = vdpa_mgmtdev_register(&mgmt_dev);
+	if (ret)
+		goto parent_err;
+
+	return 0;
+
+parent_err:
+	device_unregister(&vdpasim_blk_mgmtdev);
+	return ret;
+}
+
+static void __exit vdpasim_blk_exit(void)
+{
+	vdpa_mgmtdev_unregister(&mgmt_dev);
+	device_unregister(&vdpasim_blk_mgmtdev);
 }
 
 module_init(vdpasim_blk_init)
-- 
2.30.2

