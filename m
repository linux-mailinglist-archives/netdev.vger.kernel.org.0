Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F2E6EE01D
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 12:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbjDYKXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 06:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbjDYKW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 06:22:59 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F905524B
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 03:22:57 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1a6715ee82fso60554905ad.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 03:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20221208.gappssmtp.com; s=20221208; t=1682418176; x=1685010176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=65grNDAGbRwlyUHQpd0EqrZwm0CjizZXzog/WSwNZzg=;
        b=fBjkFbUrX9C7gMis+wxz4/gdT/CBktqndDpokeR5ZWpldmL4HqcRpC7O0Is+VZQND/
         pU1WWp8yy8sQeV9myQou3vjh53hQCxCc66mK7pszFWjiGd08G6WkXpx6bNIx46hGCCv8
         l1KiMaSYPcV3IGs3BJ2A8v4cmi1458b1U8IMoeLel0RWmTEdim39WKr/xuq129YjgZLM
         VxKKEu3DTmJGSgJDHpE1aH+UDqsyckv+m+KKxUFtbPE9wj4KpEz1rqOFQEfajLuxZb80
         0eh2fTBsPUDXG25Lfpu8NDNcNMMNojJ+Jtn0m/KdqxMi8tuwUvh8CAcOh3snU4qZbGZD
         cS0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682418176; x=1685010176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=65grNDAGbRwlyUHQpd0EqrZwm0CjizZXzog/WSwNZzg=;
        b=dMsEzKexXBcLoXVyj1gMSlhQQWkVnryHu4iD1Ka5LXMRzZKBjXu+JWyOZJnBWpCDs1
         RfHYmyKGnSjce1LELoXhKAHwnBgqCD07tm0M7I9boNoFJltUOPOTvIKYEWaaH7qb73b2
         JjdQsscgF7GrTWaDuSajY/WtFShQ3ao5y5iWnh6juy+Bjez9nDvHh6j62O7LBS1E++sm
         21VOlLbsAuuqspoR5uCq+rdV6FCIY8BC0ZMGp1kN8LvCZjRsH/ru9mpm/SX+eyAAoosC
         2ie5UV/lPxYMi2AIAsO0eRIu8r+db44s86V6ZNrkqWxonOn9OBDRn3+E/fZuGwSpzcsO
         blGw==
X-Gm-Message-State: AAQBX9e7Xk4By5Z+GCbXwIy6R65l3wJmtiQmKs+YZkfDx9fbjhqvv1LX
        Maay7c1kg36pD3cSIpc6RmOBRg==
X-Google-Smtp-Source: AKy350Zc37ESnPYxkBRq9Lwmk1WaZWPXmmPjx7nitckKNJn9o3DAxtxKsaNdu3oXR+SMGIt8Ro2aVw==
X-Received: by 2002:a17:902:fa46:b0:1a1:bff4:49e9 with SMTP id lb6-20020a170902fa4600b001a1bff449e9mr16284161plb.23.1682418176463;
        Tue, 25 Apr 2023 03:22:56 -0700 (PDT)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id iz17-20020a170902ef9100b001a6b42fd5fbsm7945953plb.183.2023.04.25.03.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 03:22:55 -0700 (PDT)
From:   Shunsuke Mie <mie@igel.co.jp>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shunsuke Mie <mie@igel.co.jp>
Subject: [PATCH v3] vringh: IOMEM support
Date:   Tue, 25 Apr 2023 19:22:50 +0900
Message-Id: <20230425102250.3847395-1-mie@igel.co.jp>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new memory accessor for vringh. It is able to use vringh to
virtio rings located on io-memory region.

Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
---

Changes from v2: https://lore.kernel.org/virtualization/20230202090934.549556-1-mie@igel.co.jp/
- Focus on an adding io memory APIs
Remove vringh API unification and some fixes.
- Rebase on next-20230414

 drivers/vhost/Kconfig  |   6 ++
 drivers/vhost/vringh.c | 129 +++++++++++++++++++++++++++++++++++++++++
 include/linux/vringh.h |  33 +++++++++++
 3 files changed, 168 insertions(+)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index b455d9ab6f3d..4b0dbb4a8ab3 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -6,6 +6,12 @@ config VHOST_IOTLB
 	  This option is selected by any driver which needs to support
 	  an IOMMU in software.
 
+config VHOST_RING_IOMEM
+	tristate
+	select VHOST_IOMEM
+	help
+	  This option enables vringh APIs to supports io memory space.
+
 config VHOST_RING
 	tristate
 	select VHOST_IOTLB
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 955d938eb663..ce5a88eecc05 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1604,4 +1604,133 @@ EXPORT_SYMBOL(vringh_need_notify_iotlb);
 
 #endif
 
+#if IS_REACHABLE(CONFIG_VHOST_RING_IOMEM)
+
+static inline int getu16_iomem(const struct vringh *vrh, u16 *val,
+			       const __virtio16 *p)
+{
+	*val = vringh16_to_cpu(vrh, ioread16(p));
+	return 0;
+}
+
+static inline int putu16_iomem(const struct vringh *vrh, __virtio16 *p, u16 val)
+{
+	iowrite16(cpu_to_vringh16(vrh, val), p);
+	return 0;
+}
+
+static inline int copydesc_iomem(const struct vringh *vrh, void *dst,
+				 const void *src, size_t len)
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
+static inline int xfer_from_iomem(const struct vringh *vrh, void *src,
+				  void *dst, size_t len)
+{
+	memcpy_fromio(dst, src, len);
+	return 0;
+}
+
+static inline int xfer_to_iomem(const struct vringh *vrh, void *dst, void *src,
+				size_t len)
+{
+	memcpy_toio(dst, src, len);
+	return 0;
+}
+
+int vringh_init_iomem(struct vringh *vrh, u64 features, unsigned int num,
+		      bool weak_barriers, struct vring_desc *desc,
+		      struct vring_avail *avail, struct vring_used *used)
+{
+	return vringh_init_kern(vrh, features, num, weak_barriers, desc, avail,
+				used);
+}
+EXPORT_SYMBOL(vringh_init_iomem);
+
+int vringh_getdesc_iomem(struct vringh *vrh, struct vringh_kiov *riov,
+			 struct vringh_kiov *wiov, u16 *head, gfp_t gfp)
+{
+	int err;
+
+	err = __vringh_get_head(vrh, getu16_iomem, &vrh->last_avail_idx);
+	if (err < 0)
+		return err;
+
+	/* Empty... */
+	if (err == vrh->vring.num)
+		return 0;
+
+	*head = err;
+	err = __vringh_iov(vrh, *head, riov, wiov, no_range_check, NULL, gfp,
+			   copydesc_iomem);
+	if (err)
+		return err;
+
+	return 1;
+}
+EXPORT_SYMBOL(vringh_getdesc_iomem);
+
+ssize_t vringh_iov_pull_iomem(struct vringh *vrh, struct vringh_kiov *riov,
+			      void *dst, size_t len)
+{
+	return vringh_iov_xfer(vrh, riov, dst, len, xfer_from_iomem);
+}
+EXPORT_SYMBOL(vringh_iov_pull_iomem);
+
+ssize_t vringh_iov_push_iomem(struct vringh *vrh, struct vringh_kiov *wiov,
+			      const void *src, size_t len)
+{
+	return vringh_iov_xfer(vrh, wiov, (void *)src, len, xfer_to_iomem);
+}
+EXPORT_SYMBOL(vringh_iov_push_iomem);
+
+void vringh_abandon_iomem(struct vringh *vrh, unsigned int num)
+{
+	/* We only update vring_avail_event(vr) when we want to be notified,
+	 * so we haven't changed that yet.
+	 */
+	vrh->last_avail_idx -= num;
+}
+EXPORT_SYMBOL(vringh_abandon_iomem);
+
+int vringh_complete_iomem(struct vringh *vrh, u16 head, u32 len)
+{
+	struct vring_used_elem used;
+
+	used.id = cpu_to_vringh32(vrh, head);
+	used.len = cpu_to_vringh32(vrh, len);
+
+	return __vringh_complete(vrh, &used, 1, putu16_iomem, putused_iomem);
+}
+EXPORT_SYMBOL(vringh_complete_iomem);
+
+bool vringh_notify_enable_iomem(struct vringh *vrh)
+{
+	return __vringh_notify_enable(vrh, getu16_iomem, putu16_iomem);
+}
+EXPORT_SYMBOL(vringh_notify_enable_iomem);
+
+void vringh_notify_disable_iomem(struct vringh *vrh)
+{
+	__vringh_notify_disable(vrh, putu16_iomem);
+}
+EXPORT_SYMBOL(vringh_notify_disable_iomem);
+
+int vringh_need_notify_iomem(struct vringh *vrh)
+{
+	return __vringh_need_notify(vrh, getu16_iomem);
+}
+EXPORT_SYMBOL(vringh_need_notify_iomem);
+
+#endif /* CONFIG_VHOST_RING_IOMEM */
+
 MODULE_LICENSE("GPL");
diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index c3a8117dabe8..c03d045f7f3f 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -330,4 +330,37 @@ int vringh_need_notify_iotlb(struct vringh *vrh);
 
 #endif /* CONFIG_VHOST_IOTLB */
 
+#if IS_REACHABLE(CONFIG_VHOST_RING_IOMEM)
+
+int vringh_init_iomem(struct vringh *vrh, u64 features,
+		      unsigned int num, bool weak_barriers,
+		      struct vring_desc *desc,
+		      struct vring_avail *avail,
+		      struct vring_used *used);
+
+
+int vringh_getdesc_iomem(struct vringh *vrh,
+			 struct vringh_kiov *riov,
+			 struct vringh_kiov *wiov,
+			 u16 *head,
+			 gfp_t gfp);
+
+ssize_t vringh_iov_pull_iomem(struct vringh *vrh,
+			      struct vringh_kiov *riov,
+			      void *dst, size_t len);
+ssize_t vringh_iov_push_iomem(struct vringh *vrh,
+			      struct vringh_kiov *wiov,
+			      const void *src, size_t len);
+
+void vringh_abandon_iomem(struct vringh *vrh, unsigned int num);
+
+int vringh_complete_iomem(struct vringh *vrh, u16 head, u32 len);
+
+bool vringh_notify_enable_iomem(struct vringh *vrh);
+void vringh_notify_disable_iomem(struct vringh *vrh);
+
+int vringh_need_notify_iomem(struct vringh *vrh);
+
+#endif /* CONFIG_VHOST_RING_IOMEM */
+
 #endif /* _LINUX_VRINGH_H */

base-commit: d3f2cd24819158bb70701c3549e586f9df9cee67
prerequisite-patch-id: 760abbe8c981c52ccc421b8139e8999ab71619aa
prerequisite-patch-id: 99d8679ab4569545c8af401e84142c66312e953e
prerequisite-patch-id: aca81516aba75b58c8422d37c2dc7db2f61ffe92
prerequisite-patch-id: 3d76136200c4e55ba2c41681325f242859dd6dbd
prerequisite-patch-id: 47a994feb68d95412d81b0fd1fa27bc7ba05ae18
prerequisite-patch-id: a2f7fc3f35358f70b6dad4c919ce293b10295c4f
prerequisite-patch-id: 70e2ee32b945be96a0388f0ff564651ac9335220
prerequisite-patch-id: 2023690f9c47017b56d7f036332a5ca3ece6bde8
prerequisite-patch-id: 211e113fec6c450d13fbdb437ecfad67dec0a157
prerequisite-patch-id: f2bcd3168933886e4cd4c39e47446d1bd7cb2691
prerequisite-patch-id: 37b131560808733a0b8878e85a3d2a46d6ab02ca
prerequisite-patch-id: 79b0219a715cb5ace227d55666d62fdb2dcc6ffe
prerequisite-patch-id: 30f1740cd48a19aa1c3c93e625c740cae2845478
prerequisite-patch-id: 31989e4a521f2fc6f68c4ccdb6960035e87666a7
prerequisite-patch-id: 3948bb3e0c045e2ffff06a714d17bab16c94775d
prerequisite-patch-id: cf28e0115b9111bcb77aa9c710d98b2be93c7e89
prerequisite-patch-id: ebf2349c0ae1296663854eee2da0b43fe8972f9b
prerequisite-patch-id: fc570921d885a2a6000800b4022321e63f1650a5
prerequisite-patch-id: 1fd5219fef17c2bf2d76000207b25aae58c368f3
prerequisite-patch-id: 34e5f078202762fe69df471e97b51b1341cbdfa9
prerequisite-patch-id: 7fa5151b9e0488b48c2b9d1219152cfb047d6586
prerequisite-patch-id: 33cca272767af04ae9abe7af2f6cbb9972cc0b77
prerequisite-patch-id: bb1a6befc899dd97bcd946c2d76ce73675a1fa45
prerequisite-patch-id: 10be04dd92fa451d13676e91d9094b63cd7fbcf8
prerequisite-patch-id: 87b86eb4ce9501bba9c04ec81094ac9202392431
prerequisite-patch-id: a5ced28762bf6bd6419dae0e4413d02ccafd72c2
prerequisite-patch-id: 2db4c9603e00d69bb0184dabcc319e7f74f30305
prerequisite-patch-id: 41933f9d53e5e9e02efd6157b68ee7d92b10cfa2
prerequisite-patch-id: df3295b4cdde3a45eaf4c40047179698a4224d05
prerequisite-patch-id: 9e2fca9ab0ba2b935daa96f1745ff4c909792231
prerequisite-patch-id: 8948378099ba4d61e10a87e617d69ed2fc4104ae
prerequisite-patch-id: 5e7466f3f0d74880d1a574a1bd91b12091dcf3f5
prerequisite-patch-id: 902899e1cd53b7fcc7971f630aed103830fc3e3d
prerequisite-patch-id: 42126b180500f9ff123db78748972c6ece18ac57
prerequisite-patch-id: 5236a03ef574074f3c1009a52612051862b31eff
prerequisite-patch-id: adae1aa80df65bd02a9e3f4db490cf801c1c6119
prerequisite-patch-id: 22806fcabb973ee5f04ee6212db6161aab5bcbfc
prerequisite-patch-id: 6eb14cfdc2cf31e90556f6afe7361427a332e8dc
-- 
2.25.1

