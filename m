Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7C919DAEA
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 18:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404135AbgDCQKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 12:10:35 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35417 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404038AbgDCQKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 12:10:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585930233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HxGDx8xMWngtG+W7aIWS1cH1WkrfSib7IwRlpCopMt0=;
        b=Z7e1NsU6nw7FIGYfeznkl9r0ITcHEJGk/G460nxwlhjJbwrUs+/bJNEwny0FlLhkV5lQQA
        PtBUOqYW7TXSdAs0GmaHJcrn59Ay1qc4tioPuOjii19Ov/VVD6UupyTwO25fDdmJIypugX
        D/LXpmlxPdcykMTzoFuR4pKlJs207Bg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-hEDuYRpuNWO1q8d79O_eIQ-1; Fri, 03 Apr 2020 12:10:31 -0400
X-MC-Unique: hEDuYRpuNWO1q8d79O_eIQ-1
Received: by mail-wm1-f69.google.com with SMTP id s22so2238640wmh.8
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 09:10:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=HxGDx8xMWngtG+W7aIWS1cH1WkrfSib7IwRlpCopMt0=;
        b=h9eZbYSU5gvMAefVS52z40Siuf7L/g6rmE6Meq2oJealyCneU1asWW9BkbaKOd5gzx
         aYjL32tuKqOpdS+nuUSTF6FKobY019IEp2QUzm/RIezAR8kndR1xLqwB+/MbKjPhf/YP
         BDCwpQttB9v4uETL6ISuGY9or8/SuMfevGv3Fwe6/nt25hGDqg/vcVzXtIdLIH9qwRYp
         TDSgNPmj0f5dtb4bmG9e1/q5UBZ03sq+vDa4KhWRmD6V0wdoBqZvqC3BHzajG7j+BNbb
         ILcEDJlEMtvfGm0Byo9yaDTH/u//ZfpRZekb60F9X2KjIVfq0lG+6qrTFJeVRgdhpSNf
         k6ZA==
X-Gm-Message-State: AGi0PuYzAwjp+maOHSnzIJXkoXVWJLgx0px5aMnJQpeIU1aICz9B3G9L
        6sf8C4Url8rkrCXDiWY4Oxwv5ez29qVoF7nbaXDYwleBIqU88fgvNEBL3K7Co3S67TKaI54oZ5Q
        jriA3UeSUgSaSXoDN
X-Received: by 2002:adf:92a3:: with SMTP id 32mr1691698wrn.254.1585930230641;
        Fri, 03 Apr 2020 09:10:30 -0700 (PDT)
X-Google-Smtp-Source: APiQypLmrG+TV47aCCJhBBP60hCAWxJr4RwtTXo78EGqzfC86StxChKcxJSpL+guDENdVCsWHZ1/gQ==
X-Received: by 2002:adf:92a3:: with SMTP id 32mr1691673wrn.254.1585930230347;
        Fri, 03 Apr 2020 09:10:30 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id f141sm12222545wmf.3.2020.04.03.09.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 09:10:29 -0700 (PDT)
Date:   Fri, 3 Apr 2020 12:10:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 1/2] virtio/test: fix up after IOTLB changes
Message-ID: <20200403161011.13046-2-mst@redhat.com>
References: <20200403161011.13046-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200403161011.13046-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow building vringh without IOTLB (that's the case for userspace
builds, will be useful for CAIF/VOD down the road too).
Update for API tweaks.
Don't include vringh with userspace builds.

Cc: Jason Wang <jasowang@redhat.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/Kconfig             | 2 ++
 drivers/vhost/test.c              | 4 ++--
 drivers/vhost/vringh.c            | 5 +++++
 include/linux/vringh.h            | 6 ++++++
 tools/virtio/Makefile             | 5 +++--
 tools/virtio/generated/autoconf.h | 0
 6 files changed, 18 insertions(+), 4 deletions(-)
 create mode 100644 tools/virtio/generated/autoconf.h

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 362b832f5338..f0404ce255d1 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -3,6 +3,8 @@ config VHOST_IOTLB
 	tristate
 	help
 	  Generic IOTLB implementation for vhost and vringh.
+	  This option is selected by any driver which needs to support
+	  an IOMMU in software.
 
 config VHOST_RING
 	tristate
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
index ee0491f579ac..ba8e0d6cfd97 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -13,9 +13,11 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#if IS_REACHABLE(CONFIG_VHOST_IOTLB)
 #include <linux/bvec.h>
 #include <linux/highmem.h>
 #include <linux/vhost_iotlb.h>
+#endif
 #include <uapi/linux/virtio_config.h>
 
 static __printf(1,2) __cold void vringh_bad(const char *fmt, ...)
@@ -1059,6 +1061,8 @@ int vringh_need_notify_kern(struct vringh *vrh)
 }
 EXPORT_SYMBOL(vringh_need_notify_kern);
 
+#if IS_REACHABLE(CONFIG_VHOST_IOTLB)
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
index bd0503ca6f8f..9e2763d7c159 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -14,8 +14,10 @@
 #include <linux/virtio_byteorder.h>
 #include <linux/uio.h>
 #include <linux/slab.h>
+#if IS_REACHABLE(CONFIG_VHOST_IOTLB)
 #include <linux/dma-direction.h>
 #include <linux/vhost_iotlb.h>
+#endif
 #include <asm/barrier.h>
 
 /* virtio_ring with information needed for host access. */
@@ -254,6 +256,8 @@ static inline __virtio64 cpu_to_vringh64(const struct vringh *vrh, u64 val)
 	return __cpu_to_virtio64(vringh_is_little_endian(vrh), val);
 }
 
+#if IS_REACHABLE(CONFIG_VHOST_IOTLB)
+
 void vringh_set_iotlb(struct vringh *vrh, struct vhost_iotlb *iotlb);
 
 int vringh_init_iotlb(struct vringh *vrh, u64 features,
@@ -284,4 +288,6 @@ void vringh_notify_disable_iotlb(struct vringh *vrh);
 
 int vringh_need_notify_iotlb(struct vringh *vrh);
 
+#endif /* CONFIG_VHOST_IOTLB */
+
 #endif /* _LINUX_VRINGH_H */
diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
index f33f32f1d208..b587b9a7a124 100644
--- a/tools/virtio/Makefile
+++ b/tools/virtio/Makefile
@@ -4,7 +4,7 @@ test: virtio_test vringh_test
 virtio_test: virtio_ring.o virtio_test.o
 vringh_test: vringh_test.o vringh.o virtio_ring.o
 
-CFLAGS += -g -O2 -Werror -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE
+CFLAGS += -g -O2 -Werror -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h
 vpath %.c ../../drivers/virtio ../../drivers/vhost
 mod:
 	${MAKE} -C `pwd`/../.. M=`pwd`/vhost_test V=${V}
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
diff --git a/tools/virtio/generated/autoconf.h b/tools/virtio/generated/autoconf.h
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
MST

