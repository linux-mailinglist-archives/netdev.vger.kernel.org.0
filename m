Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A642B66E1E2
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbjAQPRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbjAQPRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:17:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9097539B8B
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673968575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=asTM0g0Ag1HWYFfqMWuusWwOifr4sTs9wZ4Ph94PRks=;
        b=D6iOFiZIemfKDsq6AJYkrrrLQmaT9IMBVNxqsfgSG7lGjvujv/RqabdcYPOgQeADv5LP6x
        LeqIWC91UygpKOrC4WK1b7JZORDORf/eQPoLMmqr+Yf0JNeyftatH3CRrYXBnkcRerYvlX
        yK51fPk+lMCSD2wzCVfWuZiv0cfhDnA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-3VwgVySaOGu7fIeoVyop0w-1; Tue, 17 Jan 2023 10:16:09 -0500
X-MC-Unique: 3VwgVySaOGu7fIeoVyop0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE44D3C5C966;
        Tue, 17 Jan 2023 15:15:22 +0000 (UTC)
Received: from qualcomm-amberwing-rep-06.khw4.lab.eng.bos.redhat.com (qualcomm-amberwing-rep-06.khw4.lab.eng.bos.redhat.com [10.19.240.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8383540C6EC4;
        Tue, 17 Jan 2023 15:15:22 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     peterx@redhat.com, lvivier@redhat.com
Subject: [PATCH 2/2] vhost/net: Clear the pending messages when the backend is removed
Date:   Tue, 17 Jan 2023 10:15:18 -0500
Message-Id: <20230117151518.44725-3-eric.auger@redhat.com>
In-Reply-To: <20230117151518.44725-1-eric.auger@redhat.com>
References: <20230117151518.44725-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the vhost iotlb is used along with a guest virtual iommu
and the guest gets rebooted, some MISS messages may have been
recorded just before the reboot and spuriously executed by
the virtual iommu after the reboot.

As vhost does not have any explicit reset user API,
VHOST_NET_SET_BACKEND looks a reasonable point where to clear
the pending messages, in case the backend is removed.

Export vhost_clear_msg() and call it in vhost_net_set_backend()
when fd == -1.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
Fixes: 6b1e6cc7855b0 ("vhost: new device IOTLB API")

---

Without this patch, with QEMU virtio-iommu, on reboot, we get
spurious messages such as

qemu-kvm: virtio_iommu_translate no mapping for 0xff732800 for sid=1536
---
 drivers/vhost/net.c   | 3 +++
 drivers/vhost/vhost.c | 3 ++-
 drivers/vhost/vhost.h | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 135e23254a26..383f8f2ae131 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1511,6 +1511,9 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	nvq = &n->vqs[index];
 	mutex_lock(&vq->mutex);
 
+	if (fd == -1)
+		vhost_clear_msg(&n->dev);
+
 	/* Verify that ring has been setup correctly. */
 	if (!vhost_vq_access_ok(vq)) {
 		r = -EFAULT;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 34458e203716..f11bdbe4c2c5 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -661,7 +661,7 @@ void vhost_dev_stop(struct vhost_dev *dev)
 }
 EXPORT_SYMBOL_GPL(vhost_dev_stop);
 
-static void vhost_clear_msg(struct vhost_dev *dev)
+void vhost_clear_msg(struct vhost_dev *dev)
 {
 	struct vhost_msg_node *node, *n;
 
@@ -679,6 +679,7 @@ static void vhost_clear_msg(struct vhost_dev *dev)
 
 	spin_unlock(&dev->iotlb_lock);
 }
+EXPORT_SYMBOL_GPL(vhost_clear_msg);
 
 void vhost_dev_cleanup(struct vhost_dev *dev)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 4bfa10e52297..1647b750169c 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -181,6 +181,7 @@ long vhost_dev_ioctl(struct vhost_dev *, unsigned int ioctl, void __user *argp);
 long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp);
 bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
 bool vhost_log_access_ok(struct vhost_dev *);
+void vhost_clear_msg(struct vhost_dev *dev);
 
 int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct iovec iov[], unsigned int iov_count,
-- 
2.31.1

