Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A068687869
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbjBBJKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjBBJKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:10:02 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4017E6FA
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:09:59 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id mi9so1294931pjb.4
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 01:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gcO0uxyztK7wrPRESDhnWawV9bJajYCn05I6EVJHO1Q=;
        b=GH6KARO7thcAXAecHFCRqv2AThKvwRpSynFUPRyr/OZKPlK2yL0fvDQhRTEuxWPbag
         soLM3KjFH60hrsUUukVibYDKMQm0sViyKG5mYZqPbfML2bae+Go5bIdqdw9B901M7ibu
         wNT7zORKjzFmfIR2oCiVQM3HJyrFKC2BPqVxmkD7X27/Tbuv0DsrL5dChFH+9/NwvzIQ
         EUYkhc2ftdhCYgF8ACeakDBIlsNguRxNJ82koXMxpahyWP6KNfGH647dLQIQkSf08b9Y
         Kg9/9k7MncrjLlOlQrFvpRobgAOYtK7H68cuL5RxgyxNu+F+hxjmjIGD1BbGwHe4fB3M
         210w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gcO0uxyztK7wrPRESDhnWawV9bJajYCn05I6EVJHO1Q=;
        b=7/SbTydeTIvqQ1Ckx9NowEAoglsQfrw++Oo0vDy+Vw4zUSvQXs4Cz8hKEN2biS4j6x
         QNfdlv9MfVYakvFTQpo/RMC08ul2NGPXtv3EuqlcaGD+ZC+zHrJWnFYlxyd+G5YA3IE8
         4FOScdHHBjgIUi0LrHZ7/CCJyAMznqHDXEr4AsUlusBBKiVHcXJs3r5jW3hbIB/YtU7N
         8bpIkvywGO4oFtzVZ+oc1EeKt6hITG7o5fKV+/tUbTn266MzuO0+grA+EYmOGGIvbkNe
         pwFmfPl5ITdx0I8o4Ldzf7krzzMkl4k24+NxPE3255dEwyKyKlpcmjKPiXSjTL5JHq5y
         4AOw==
X-Gm-Message-State: AO0yUKVW6IaJQ1jUsysw5+roGr8h3jRwOSyUxZJ6jV/DCPQluS6DeZ0o
        zO2O6tGDpEFXAezqCMdTuHky59PQz+Bn3oim
X-Google-Smtp-Source: AK7set/fXvDEmBQhH8c6B3dTk3eGn1u6YNr6DVl3bDrXS4EUzT2lgnlUWdYhoNLU3kNmqiqzSmYyqg==
X-Received: by 2002:a17:903:2303:b0:195:f06f:84fc with SMTP id d3-20020a170903230300b00195f06f84fcmr7368514plh.40.1675328998631;
        Thu, 02 Feb 2023 01:09:58 -0800 (PST)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id ik12-20020a170902ab0c00b001929827731esm13145968plb.201.2023.02.02.01.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 01:09:58 -0800 (PST)
From:   Shunsuke Mie <mie@igel.co.jp>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shunsuke Mie <mie@igel.co.jp>
Subject: [RFC PATCH v2 7/7] vringh: IOMEM support
Date:   Thu,  2 Feb 2023 18:09:34 +0900
Message-Id: <20230202090934.549556-8-mie@igel.co.jp>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202090934.549556-1-mie@igel.co.jp>
References: <20230202090934.549556-1-mie@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the new memory accessor for vringh. It is able to
use vringh to virtio rings located on iomemory region.

Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
---
 drivers/vhost/Kconfig  |  6 ++++
 drivers/vhost/vringh.c | 76 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/vringh.h |  8 +++++
 3 files changed, 90 insertions(+)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 587fbae06182..a79a4efbc817 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -6,6 +6,12 @@ config VHOST_IOTLB
 	  This option is selected by any driver which needs to support
 	  an IOMMU in software.
 
+config VHOST_IOMEM
+	tristate
+	select VHOST_RING
+	help
+	  Generic IOMEM implementation for vhost and vringh.
+
 config VHOST_RING
 	tristate
 	select VHOST_IOTLB
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 46fb315483ed..e3d9c7281ad0 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -18,6 +18,9 @@
 #include <linux/highmem.h>
 #include <linux/vhost_iotlb.h>
 #endif
+#if IS_REACHABLE(CONFIG_VHOST_IOMEM)
+#include <linux/io.h>
+#endif
 #include <uapi/linux/virtio_config.h>
 
 static __printf(1,2) __cold void vringh_bad(const char *fmt, ...)
@@ -1165,4 +1168,77 @@ EXPORT_SYMBOL(vringh_set_iotlb);
 
 #endif
 
+#if IS_REACHABLE(CONFIG_VHOST_IOMEM)
+
+/* io-memory space access helpers. */
+static int getu16_iomem(const struct vringh *vrh, u16 *val, const __virtio16 *p)
+{
+	*val = vringh16_to_cpu(vrh, ioread16(p));
+	return 0;
+}
+
+static int putu16_iomem(const struct vringh *vrh, __virtio16 *p, u16 val)
+{
+	iowrite16(cpu_to_vringh16(vrh, val), p);
+	return 0;
+}
+
+static int copydesc_iomem(const struct vringh *vrh, void *dst, const void *src,
+			  size_t len)
+{
+	memcpy_fromio(dst, src, len);
+	return 0;
+}
+
+static int putused_iomem(const struct vringh *vrh, struct vring_used_elem *dst,
+			 const struct vring_used_elem *src, unsigned int num)
+{
+	memcpy_toio(dst, src, num * sizeof(*dst));
+	return 0;
+}
+
+static int xfer_from_iomem(const struct vringh *vrh, void *src, void *dst,
+			   size_t len)
+{
+	memcpy_fromio(dst, src, len);
+	return 0;
+}
+
+static int xfer_to_iomem(const struct vringh *vrh, void *dst, void *src,
+			 size_t len)
+{
+	memcpy_toio(dst, src, len);
+	return 0;
+}
+
+static struct vringh_ops iomem_vringh_ops = {
+	.getu16 = getu16_iomem,
+	.putu16 = putu16_iomem,
+	.xfer_from = xfer_from_iomem,
+	.xfer_to = xfer_to_iomem,
+	.putused = putused_iomem,
+	.copydesc = copydesc_iomem,
+	.range_check = no_range_check,
+	.getrange = NULL,
+};
+
+int vringh_init_iomem(struct vringh *vrh, u64 features, unsigned int num,
+		      bool weak_barriers, gfp_t gfp, struct vring_desc *desc,
+		      struct vring_avail *avail, struct vring_used *used)
+{
+	int err;
+
+	err = __vringh_init(vrh, features, num, weak_barriers, gfp, desc, avail,
+			    used);
+	if (err)
+		return err;
+
+	memcpy(&vrh->ops, &iomem_vringh_ops, sizeof(iomem_vringh_ops));
+
+	return 0;
+}
+EXPORT_SYMBOL(vringh_init_iomem);
+
+#endif
+
 MODULE_LICENSE("GPL");
diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 89c73605c85f..420c2d0ed398 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -265,4 +265,12 @@ int vringh_init_iotlb(struct vringh *vrh, u64 features,
 
 #endif /* CONFIG_VHOST_IOTLB */
 
+#if IS_REACHABLE(CONFIG_VHOST_IOMEM)
+
+int vringh_init_iomem(struct vringh *vrh, u64 features, unsigned int num,
+		      bool weak_barriers, gfp_t gfp, struct vring_desc *desc,
+		      struct vring_avail *avail, struct vring_used *used);
+
+#endif /* CONFIG_VHOST_IOMEM */
+
 #endif /* _LINUX_VRINGH_H */
-- 
2.25.1

