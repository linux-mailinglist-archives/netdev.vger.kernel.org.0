Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1C7211E49
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbgGBIXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:23:22 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:34564 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbgGBIXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:23:15 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628N4OM017422;
        Thu, 2 Jul 2020 03:23:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678184;
        bh=33BgNyAskD4tPtltq/G/c+6YM0cxUZYr1ZA8AxsWt2I=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=vw7QPSUTKuZgj+GGqy+fujjjqAOcGN41ewsIzNJue29GXuL9A+DLJjyd3tqBdh5BH
         O9/Rfrx1a9YJNcgGMO2Eh2drcJN2jYNr9Sx9EIE9PySCFwDqgs8l0elpxZ+a7oBiSf
         gqpT9osCNxXgKtOLe7vjZSZii8dZ43XKpUewjFVg=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0628N4t0031613
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jul 2020 03:23:04 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:23:04 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:23:03 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYP006145;
        Thu, 2 Jul 2020 03:22:58 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <linux-ntb@googlegroups.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH 13/22] rpmsg: virtio_rpmsg_bus: Use virtio_alloc_buffer() and virtio_free_buffer()
Date:   Thu, 2 Jul 2020 13:51:34 +0530
Message-ID: <20200702082143.25259-14-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702082143.25259-1-kishon@ti.com>
References: <20200702082143.25259-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use virtio_alloc_buffer() and virtio_free_buffer() to allocate and free
memory buffer respectively. Only if buffer allocation using
virtio_alloc_buffer() try using dma_alloc_coherent(). This is required
for devices like NTB to use rpmsg for communicating with other host.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index f91143b25af7..2b25a8ae1539 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -882,13 +882,16 @@ static int rpmsg_probe(struct virtio_device *vdev)
 
 	total_buf_space = vrp->num_bufs * vrp->buf_size;
 
-	/* allocate coherent memory for the buffers */
-	bufs_va = dma_alloc_coherent(vdev->dev.parent,
-				     total_buf_space, &vrp->bufs_dma,
-				     GFP_KERNEL);
+	bufs_va = virtio_alloc_buffer(vdev, total_buf_space);
 	if (!bufs_va) {
-		err = -ENOMEM;
-		goto vqs_del;
+		/* allocate coherent memory for the buffers */
+		bufs_va = dma_alloc_coherent(vdev->dev.parent,
+					     total_buf_space, &vrp->bufs_dma,
+					     GFP_KERNEL);
+		if (!bufs_va) {
+			err = -ENOMEM;
+			goto vqs_del;
+		}
 	}
 
 	dev_dbg(&vdev->dev, "buffers: va %pK, dma %pad\n",
@@ -951,8 +954,13 @@ static int rpmsg_probe(struct virtio_device *vdev)
 	return 0;
 
 free_coherent:
-	dma_free_coherent(vdev->dev.parent, total_buf_space,
-			  bufs_va, vrp->bufs_dma);
+	if (!vrp->bufs_dma) {
+		virtio_free_buffer(vdev, bufs_va, total_buf_space);
+	} else {
+		dma_free_coherent(vdev->dev.parent, total_buf_space,
+				  bufs_va, vrp->bufs_dma);
+	}
+
 vqs_del:
 	vdev->config->del_vqs(vrp->vdev);
 free_vrp:
@@ -986,8 +994,12 @@ static void rpmsg_remove(struct virtio_device *vdev)
 
 	vdev->config->del_vqs(vrp->vdev);
 
-	dma_free_coherent(vdev->dev.parent, total_buf_space,
-			  vrp->rbufs, vrp->bufs_dma);
+	if (!vrp->bufs_dma) {
+		virtio_free_buffer(vdev, vrp->rbufs, total_buf_space);
+	} else {
+		dma_free_coherent(vdev->dev.parent, total_buf_space,
+				  vrp->rbufs, vrp->bufs_dma);
+	}
 
 	kfree(vrp);
 }
-- 
2.17.1

