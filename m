Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4E0019D99
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 14:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfEJM7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 08:59:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbfEJM7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 08:59:37 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AA505309264F;
        Fri, 10 May 2019 12:59:36 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-202.ams2.redhat.com [10.36.117.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F96A5D70D;
        Fri, 10 May 2019 12:59:33 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH v2 8/8] vsock/virtio: make the RX buffer size tunable
Date:   Fri, 10 May 2019 14:58:43 +0200
Message-Id: <20190510125843.95587-9-sgarzare@redhat.com>
In-Reply-To: <20190510125843.95587-1-sgarzare@redhat.com>
References: <20190510125843.95587-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 10 May 2019 12:59:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RX buffer size determines the memory consumption of the
vsock/virtio guest driver, so we make it tunable through
a module parameter.

The size allowed are between 4 KB and 64 KB in order to be
compatible with old host drivers.

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/linux/virtio_vsock.h     |  1 +
 net/vmw_vsock/virtio_transport.c | 27 ++++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 5a9d25be72df..b9f8c3d91f80 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -13,6 +13,7 @@
 #define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 64)
 #define VIRTIO_VSOCK_MAX_BUF_SIZE		0xFFFFFFFFUL
 #define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		(1024 * 64)
+#define VIRTIO_VSOCK_MIN_PKT_BUF_SIZE		(1024 * 4)
 
 enum {
 	VSOCK_VQ_RX     = 0, /* for host to guest data */
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index af1d2ce12f54..732398b4e28f 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -66,6 +66,31 @@ struct virtio_vsock {
 	u32 guest_cid;
 };
 
+static unsigned int rx_buf_size = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
+
+static int param_set_rx_buf_size(const char *val, const struct kernel_param *kp)
+{
+	unsigned int size;
+	int ret;
+
+	ret = kstrtouint(val, 0, &size);
+	if (ret)
+		return ret;
+
+	if (size < VIRTIO_VSOCK_MIN_PKT_BUF_SIZE ||
+	    size > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
+		return -EINVAL;
+
+	return param_set_uint(val, kp);
+};
+
+static const struct kernel_param_ops param_ops_rx_buf_size = {
+	.set = param_set_rx_buf_size,
+	.get = param_get_uint,
+};
+
+module_param_cb(rx_buf_size, &param_ops_rx_buf_size, &rx_buf_size, 0644);
+
 static struct virtio_vsock *virtio_vsock_get(void)
 {
 	return the_virtio_vsock;
@@ -261,7 +286,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 
 static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
 {
-	int buf_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
+	int buf_len = rx_buf_size;
 	struct virtio_vsock_pkt *pkt;
 	struct scatterlist hdr, buf, *sgs[2];
 	struct virtqueue *vq;
-- 
2.20.1

