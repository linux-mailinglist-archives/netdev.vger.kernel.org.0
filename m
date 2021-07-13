Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED8B3C6C88
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 10:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbhGMIvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 04:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbhGMIvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 04:51:01 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6E7C0613B9
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 01:48:08 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id a2so21004814pgi.6
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 01:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tkBBc1IawD+Ffhgxr5n+Z15KbqmeeJxiazdLqHh1xrc=;
        b=yszZshd37Q1r8rl2w4Lwrj6YFf82n3z6RFM2/AVb64c2vPdKXY1wme59FfefIDnkgr
         ZeHW2AajsEfK2rxQLc6OuYZkgjbUBXJA+gcejIcjQVScRmmzU//ovNfFgpCztM6evjZb
         /n+WP+ydd3YlkZ8SQbNriexfCms41b+6n5JyrSnt1kqA40n300sAvayGKIsgDO660Dag
         xPMXs0Ybb8+DJM4LihYMuZRid7CateX2g6ffuDfJjjN9xcWY2pbOZU1RjT72UvyZtG7E
         Iu7G8pek5Vi+CTDYAPuzeMfjRbD3yyHp8cITHLj2FoMlmhTbDWiVkQDUq3fyefNyyPld
         e0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tkBBc1IawD+Ffhgxr5n+Z15KbqmeeJxiazdLqHh1xrc=;
        b=gWeXFohFG8TepYKQFetF0Yyo4zee1CcI+juFeuo9PTBJ6ixiW7OSyjZ7lnE2WrpKNp
         ZoU4fOiM7Z3V7wB0hhW40/VdnGRZRei66qxl9YbHk07MqYVFoAxO1U7fUp23/7iSLYzA
         aRTLpL7/CAPJMfzoFWO3nQKmticARxwiFLyGTkpJ+bUgN5Z1dth42ek9g5RqBtTMSFMy
         FnNL1W5Cykl2ynuls9Wi0mt75TldsjjZ6GlYlp/weLwGJTzOMiZptYiKCbjxOedk8daI
         /UjrrJp6CwTeiaDax3MSWG3CDL5cg5OyribmIx7zkTjSWOoqMIUJ9KUMz0JRUTV8EFC1
         dazw==
X-Gm-Message-State: AOAM531YmjFSmdvai6iVjy0dRFGaXkj64DIb8fSqsRubX4j3HDKMJzpG
        EPP00pqLu/YvmtWGUzFFN0Rv
X-Google-Smtp-Source: ABdhPJzZdDWqJmTNf93gwkTO/YfKFCx5ihMhJT+DOlHvR2RbC+0OzE+HpikVZnSzaRW2shba6Z0k9A==
X-Received: by 2002:aa7:8704:0:b029:328:c7ca:fe33 with SMTP id b4-20020aa787040000b0290328c7cafe33mr3425253pfo.12.1626166087820;
        Tue, 13 Jul 2021 01:48:07 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id bf18sm4475167pjb.46.2021.07.13.01.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 01:48:07 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 12/17] vdpa: Add an opaque pointer for vdpa_config_ops.dma_map()
Date:   Tue, 13 Jul 2021 16:46:51 +0800
Message-Id: <20210713084656.232-13-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210713084656.232-1-xieyongji@bytedance.com>
References: <20210713084656.232-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an opaque pointer for DMA mapping.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 6 +++---
 drivers/vhost/vdpa.c             | 2 +-
 include/linux/vdpa.h             | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 72167963421b..f456f4baf86d 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -542,14 +542,14 @@ static int vdpasim_set_map(struct vdpa_device *vdpa,
 }
 
 static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
-			   u64 pa, u32 perm)
+			   u64 pa, u32 perm, void *opaque)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	int ret;
 
 	spin_lock(&vdpasim->iommu_lock);
-	ret = vhost_iotlb_add_range(vdpasim->iommu, iova, iova + size - 1, pa,
-				    perm);
+	ret = vhost_iotlb_add_range_ctx(vdpasim->iommu, iova, iova + size - 1,
+					pa, perm, opaque);
 	spin_unlock(&vdpasim->iommu_lock);
 
 	return ret;
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 8615756306ec..f60a513dac7c 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -578,7 +578,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
 		return r;
 
 	if (ops->dma_map) {
-		r = ops->dma_map(vdpa, iova, size, pa, perm);
+		r = ops->dma_map(vdpa, iova, size, pa, perm, NULL);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
 			r = ops->set_map(vdpa, dev->iotlb);
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 198c30e84b5d..4903e67c690b 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -268,7 +268,7 @@ struct vdpa_config_ops {
 	/* DMA ops */
 	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
 	int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
-		       u64 pa, u32 perm);
+		       u64 pa, u32 perm, void *opaque);
 	int (*dma_unmap)(struct vdpa_device *vdev, u64 iova, u64 size);
 
 	/* Free device resources */
-- 
2.11.0

