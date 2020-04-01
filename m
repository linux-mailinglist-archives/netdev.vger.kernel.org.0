Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B0519B36B
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 18:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732460AbgDAQvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 12:51:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21618 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389034AbgDAQvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 12:51:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585759877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gdTaOIE7tD6LkJdCn+pe1n6Y0DWtGxJuzhgJo7to01o=;
        b=WY+xMh9S7UBK8/cAl4504vMs65r7EnokalaOmrDKG6mDABwJ+KouQB7nKD7TVbS94fVlPM
        8O4ZtUgtfZFqdQgdN1D/JsZtGtuWUvpuQTcT/5W+jI9KZwasWY+fymTg4U2iFRVx2Qpmqg
        edUP1LT1zTrvLQeuKh+q04hmtKVx0GE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-wVq-S3BEPliNPBnGzzqlPw-1; Wed, 01 Apr 2020 12:51:15 -0400
X-MC-Unique: wVq-S3BEPliNPBnGzzqlPw-1
Received: by mail-wm1-f69.google.com with SMTP id z24so201015wml.9
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 09:51:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=gdTaOIE7tD6LkJdCn+pe1n6Y0DWtGxJuzhgJo7to01o=;
        b=hZsR+xZFMhI9xExE5nARzxaz6KugEMjJ8KKR8XHvVRZH0uuTavEiK13iAM00QyWrFu
         q67bzUDX6QQ1xDEWZalgFCrrUxDO3czayGRfCnOD7fxfZJX0/thl+TnrMjlZPYCkIGeH
         Nt7j6si7xNwJyAJ6lEhwOxuz97u9zPSnOy2ymEQJyNM46XpQGoK/ymBVftiHRk9EA+rj
         xOBs2jbN52xDmFAIHWNe2BetfFujFO9Z1Tamu/9QE+HDPemfnLOT0YXsNLtj7scXVz5W
         YxgNmci3jBUmf1CC3rwKlW8SGRyIh2xBQUvi8v9Ikst857Q+oYxWoANBtGEYFQZ6rH8N
         pqyw==
X-Gm-Message-State: ANhLgQ2X8DgULuIXhtgjp7dpS3pCMoCqoslucmHN32YT38zRjtFqdNOn
        xIF6va0yd+csgtborfd9sRuYgzzPhez/pkeKnYhSDV/PYUC+Kfg79Iy7yGRz96Ofine0i9ttoII
        kt/5JSx5MXAHkogaJ
X-Received: by 2002:a5d:400d:: with SMTP id n13mr26967273wrp.396.1585759873778;
        Wed, 01 Apr 2020 09:51:13 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvJ0pgx1SXPbI4O/8Day6ptgGE9mSEX0BpL2/jsBTqjtCm3uyzZttDISrsxNqevsV0Dl4mtNQ==
X-Received: by 2002:a5d:400d:: with SMTP id n13mr26967250wrp.396.1585759873521;
        Wed, 01 Apr 2020 09:51:13 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id z12sm3729253wrt.27.2020.04.01.09.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 09:51:12 -0700 (PDT)
Date:   Wed, 1 Apr 2020 12:51:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: [PATCH] virtio/test: fix up after IOTLB changes
Message-ID: <20200401165100.276039-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow building vringh without IOTLB (that's the case for userspace
builds, will be useful for CAIF/VOD down the road too).
Update for API tweaks.
Don't include vringh with kernel builds.

Cc: Jason Wang <jasowang@redhat.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c   | 4 ++--
 drivers/vhost/vringh.c | 5 +++++
 include/linux/vringh.h | 2 ++
 tools/virtio/Makefile  | 3 ++-
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 394e2e5c772d..9a3a09005e03 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -120,7 +120,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
 	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
 	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
-		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT);
+		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, NULL);
 
 	f->private_data = n;
 
@@ -225,7 +225,7 @@ static long vhost_test_reset_owner(struct vhost_test *n)
 {
 	void *priv = NULL;
 	long err;
-	struct vhost_umem *umem;
+	struct vhost_iotlb *umem;
 
 	mutex_lock(&n->dev.mutex);
 	err = vhost_dev_check_owner(&n->dev);
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index ee0491f579ac..878e565dfffe 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -13,9 +13,11 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#ifdef VHOST_IOTLB
 #include <linux/bvec.h>
 #include <linux/highmem.h>
 #include <linux/vhost_iotlb.h>
+#endif
 #include <uapi/linux/virtio_config.h>
 
 static __printf(1,2) __cold void vringh_bad(const char *fmt, ...)
@@ -1059,6 +1061,8 @@ int vringh_need_notify_kern(struct vringh *vrh)
 }
 EXPORT_SYMBOL(vringh_need_notify_kern);
 
+#ifdef VHOST_IOTLB
+
 static int iotlb_translate(const struct vringh *vrh,
 			   u64 addr, u64 len, struct bio_vec iov[],
 			   int iov_size, u32 perm)
@@ -1416,5 +1420,6 @@ int vringh_need_notify_iotlb(struct vringh *vrh)
 }
 EXPORT_SYMBOL(vringh_need_notify_iotlb);
 
+#endif
 
 MODULE_LICENSE("GPL");
diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index bd0503ca6f8f..ebff121c0b02 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -14,8 +14,10 @@
 #include <linux/virtio_byteorder.h>
 #include <linux/uio.h>
 #include <linux/slab.h>
+#ifdef VHOST_IOTLB
 #include <linux/dma-direction.h>
 #include <linux/vhost_iotlb.h>
+#endif
 #include <asm/barrier.h>
 
 /* virtio_ring with information needed for host access. */
diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
index f33f32f1d208..d3f152f4660b 100644
--- a/tools/virtio/Makefile
+++ b/tools/virtio/Makefile
@@ -22,7 +22,8 @@ OOT_CONFIGS=\
 	CONFIG_VHOST=m \
 	CONFIG_VHOST_NET=n \
 	CONFIG_VHOST_SCSI=n \
-	CONFIG_VHOST_VSOCK=n
+	CONFIG_VHOST_VSOCK=n \
+	CONFIG_VHOST_RING=n
 OOT_BUILD=KCFLAGS="-I "${OOT_VHOST} ${MAKE} -C ${OOT_KSRC} V=${V}
 oot-build:
 	echo "UNSUPPORTED! Don't use the resulting modules in production!"
-- 
MST

