Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812B54904E5
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 10:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235782AbiAQJ3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 04:29:38 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:16716 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235753AbiAQJ3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 04:29:34 -0500
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JcmjT5dH7zZfBC;
        Mon, 17 Jan 2022 17:25:49 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 17 Jan 2022 17:29:32 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 17 Jan 2022 17:29:31 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>, <sgarzare@redhat.com>,
        <stefanha@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <arei.gonglei@huawei.com>, <yechuan@huawei.com>,
        <huangzhichao@huawei.com>, Longpeng <longpeng2@huawei.com>
Subject: [RFC 3/3] vdpasim_net: control virtqueue support
Date:   Mon, 17 Jan 2022 17:29:21 +0800
Message-ID: <20220117092921.1573-4-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
In-Reply-To: <20220117092921.1573-1-longpeng2@huawei.com>
References: <20220117092921.1573-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

Introduces the control virtqueue support for vdpasim_net, based on
Jason's RFC [1].

[1] https://patchwork.kernel.org/project/kvm/patch/20200924032125.18619-25-jasowang@redhat.com/

Signed-off-by: Longpeng <longpeng2@huawei.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 83 +++++++++++++++++++++++++++-
 1 file changed, 81 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index 76dd24abc791..e9e388fd3cff 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -26,9 +26,85 @@
 #define DRV_LICENSE  "GPL v2"
 
 #define VDPASIM_NET_FEATURES	(VDPASIM_FEATURES | \
-				 (1ULL << VIRTIO_NET_F_MAC))
+				 (1ULL << VIRTIO_NET_F_MAC) | \
+				 (1ULL << VIRTIO_NET_F_CTRL_VQ) | \
+				 (1ULL << VIRTIO_NET_F_CTRL_MAC_ADDR))
 
-#define VDPASIM_NET_VQ_NUM	2
+#define VDPASIM_NET_VQ_NUM	3
+
+virtio_net_ctrl_ack vdpasim_net_handle_ctrl_mac(struct vdpasim *vdpasim,
+						u8 cmd)
+{
+	struct vdpasim_virtqueue *cvq = &vdpasim->vqs[2];
+	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
+	struct virtio_net_config *config = vdpasim->config;
+	size_t read;
+
+	switch (cmd) {
+	case VIRTIO_NET_CTRL_MAC_ADDR_SET:
+		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->out_iov,
+					     (void *)config->mac, ETH_ALEN);
+		if (read == ETH_ALEN)
+			status = VIRTIO_NET_OK;
+		break;
+	default:
+		break;
+	}
+
+	return status;
+}
+
+static void vdpasim_net_handle_cvq(struct vdpasim *vdpasim)
+{
+	struct vdpasim_virtqueue *cvq = &vdpasim->vqs[2];
+	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
+	struct virtio_net_ctrl_hdr ctrl;
+	size_t read, write;
+	int err;
+
+	if (!(vdpasim->features & (1ULL << VIRTIO_NET_F_CTRL_VQ)))
+		return;
+
+	if (!cvq->ready)
+		return;
+
+	while (true) {
+		err = vringh_getdesc_iotlb(&cvq->vring, &cvq->out_iov, &cvq->in_iov,
+					   &cvq->head, GFP_ATOMIC);
+		if (err <= 0)
+			break;
+
+		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->in_iov, &ctrl,
+					     sizeof(ctrl));
+		if (read != sizeof(ctrl))
+			break;
+
+		switch (ctrl.class) {
+		case VIRTIO_NET_CTRL_MAC:
+			status = vdpasim_net_handle_ctrl_mac(vdpasim, ctrl.cmd);
+			break;
+		default:
+			break;
+		}
+
+		/* Make sure data is wrote before advancing index */
+		smp_wmb();
+
+		write = vringh_iov_push_iotlb(&cvq->vring, &cvq->out_iov,
+					      &status, sizeof (status));
+		vringh_complete_iotlb(&cvq->vring, cvq->head, write);
+		vringh_kiov_cleanup(&cvq->in_iov);
+		vringh_kiov_cleanup(&cvq->out_iov);
+
+		/* Make sure used is visible before rasing the interrupt. */
+		smp_wmb();
+
+		local_bh_disable();
+		if (vringh_need_notify_iotlb(&cvq->vring) > 0)
+			vringh_notify(&cvq->vring);
+		local_bh_enable();
+	}
+}
 
 static void vdpasim_net_work(struct work_struct *work)
 {
@@ -42,6 +118,9 @@ static void vdpasim_net_work(struct work_struct *work)
 
 	spin_lock(&vdpasim->lock);
 
+	/* process ctrl vq first */
+	vdpasim_net_handle_cvq(vdpasim);
+
 	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
 		goto out;
 
-- 
2.23.0

