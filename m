Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509DA1940C8
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgCZOC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:02:56 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:60437 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727695AbgCZOCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:02:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585231372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qv2sf5ZLe8MVzng446R1oQxVfhG/+fRJUSulJ/I8CAY=;
        b=LA+JEdnZmyY+0TxZTGtHbXun8OIRyMSH2HRpsZO7NIhOfePIv7g9dTTrIFQr3ZIhbJm76W
        ErqJkAV2niLi0FM/VfpnrP5JEJ8kQ9MoYZrR8yluYBKJHbaf5N7BILWsI5Ux2uqDsAnlol
        QDM9Pm6tx3Wk/1QnQXYlep3u3Xvmrdg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73--arHbIcBN72L2BWl7WU7HA-1; Thu, 26 Mar 2020 10:02:51 -0400
X-MC-Unique: -arHbIcBN72L2BWl7WU7HA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E842B107ACC7;
        Thu, 26 Mar 2020 14:02:47 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-19.pek2.redhat.com [10.72.12.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 766D460BF3;
        Thu, 26 Mar 2020 14:02:28 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com, gdawar@xilinx.com, saugatm@xilinx.com,
        vmireyno@marvell.com, zhangweining@ruijie.com.cn,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH V9 2/9] vhost: allow per device message handler
Date:   Thu, 26 Mar 2020 22:01:18 +0800
Message-Id: <20200326140125.19794-3-jasowang@redhat.com>
In-Reply-To: <20200326140125.19794-1-jasowang@redhat.com>
References: <20200326140125.19794-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allow device to register its own message handler during
vhost_dev_init(). vDPA device will use it to implement its own DMA
mapping logic.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c   |  3 ++-
 drivers/vhost/scsi.c  |  2 +-
 drivers/vhost/vhost.c | 12 ++++++++++--
 drivers/vhost/vhost.h |  6 +++++-
 drivers/vhost/vsock.c |  2 +-
 5 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index e158159671fa..c8ab8d83b530 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1324,7 +1324,8 @@ static int vhost_net_open(struct inode *inode, stru=
ct file *f)
 	}
 	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
 		       UIO_MAXIOV + VHOST_NET_BATCH,
-		       VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT);
+		       VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT,
+		       NULL);
=20
 	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev=
);
 	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev)=
;
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 0b949a14bce3..7653667a8cdc 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1628,7 +1628,7 @@ static int vhost_scsi_open(struct inode *inode, str=
uct file *f)
 		vs->vqs[i].vq.handle_kick =3D vhost_scsi_handle_kick;
 	}
 	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
-		       VHOST_SCSI_WEIGHT, 0);
+		       VHOST_SCSI_WEIGHT, 0, NULL);
=20
 	vhost_scsi_init_inflight(vs, NULL);
=20
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index f44340b41494..8e9e2341e40a 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -457,7 +457,9 @@ static size_t vhost_get_desc_size(struct vhost_virtqu=
eue *vq,
=20
 void vhost_dev_init(struct vhost_dev *dev,
 		    struct vhost_virtqueue **vqs, int nvqs,
-		    int iov_limit, int weight, int byte_weight)
+		    int iov_limit, int weight, int byte_weight,
+		    int (*msg_handler)(struct vhost_dev *dev,
+				       struct vhost_iotlb_msg *msg))
 {
 	struct vhost_virtqueue *vq;
 	int i;
@@ -473,6 +475,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->iov_limit =3D iov_limit;
 	dev->weight =3D weight;
 	dev->byte_weight =3D byte_weight;
+	dev->msg_handler =3D msg_handler;
 	init_llist_head(&dev->work_list);
 	init_waitqueue_head(&dev->wait);
 	INIT_LIST_HEAD(&dev->read_list);
@@ -1178,7 +1181,12 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev=
,
 		ret =3D -EINVAL;
 		goto done;
 	}
-	if (vhost_process_iotlb_msg(dev, &msg)) {
+
+	if (dev->msg_handler)
+		ret =3D dev->msg_handler(dev, &msg);
+	else
+		ret =3D vhost_process_iotlb_msg(dev, &msg);
+	if (ret) {
 		ret =3D -EFAULT;
 		goto done;
 	}
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index a123fd70847e..f9d1a03dd153 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -174,11 +174,15 @@ struct vhost_dev {
 	int weight;
 	int byte_weight;
 	u64 kcov_handle;
+	int (*msg_handler)(struct vhost_dev *dev,
+			   struct vhost_iotlb_msg *msg);
 };
=20
 bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int tota=
l_len);
 void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
-		    int nvqs, int iov_limit, int weight, int byte_weight);
+		    int nvqs, int iov_limit, int weight, int byte_weight,
+		    int (*msg_handler)(struct vhost_dev *dev,
+				       struct vhost_iotlb_msg *msg));
 long vhost_dev_set_owner(struct vhost_dev *dev);
 bool vhost_dev_has_owner(struct vhost_dev *dev);
 long vhost_dev_check_owner(struct vhost_dev *);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index c2d7d57e98cf..97669484a3f6 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -621,7 +621,7 @@ static int vhost_vsock_dev_open(struct inode *inode, =
struct file *file)
=20
 	vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
 		       UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
-		       VHOST_VSOCK_WEIGHT);
+		       VHOST_VSOCK_WEIGHT, NULL);
=20
 	file->private_data =3D vsock;
 	spin_lock_init(&vsock->send_pkt_list_lock);
--=20
2.20.1

