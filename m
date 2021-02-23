Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1833C3229D5
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbhBWLzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 06:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbhBWLxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 06:53:37 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC53C0617AB
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:51:59 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id f8so9671038plg.5
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=giO5D64d7Kk8o8yeL+fv9W81NZBJ5G7R64+VKGm+1hc=;
        b=nfgKVWfjpimepezffp7YeVMqjPpQuQiv7NPgbRbM0xTw+5x13dYSJhK4EB+m9p7LkT
         1wVgY2Xvp+TIWCD7r2b+pnktIDSaSphelJWNHJyybvleOehuKMErJWW1o2lYW0Q6v8SE
         f4LUvA+Hl3TiCr6Qf8Jvnhx4TcppHcH3NURuPZmfLlkqX4/wLmps/jZoy5hK3j/CKvfJ
         8Tf+7dtjfis+bnsypb5QhmYmOUacW6SMnM3vN9EO+/OOsUKKFXG/c7/zwyFQbLwyJC5G
         Y5H1QfsKjTo5mq519pnBemW6LZv1ekTNBnMrrdps0XCNnTGL96exHdFyItOgf621jN67
         5g6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=giO5D64d7Kk8o8yeL+fv9W81NZBJ5G7R64+VKGm+1hc=;
        b=DKJ6yuG3+FFSpuen+qMKMnFNX9KKh5gwcWNqqlwnCp4x54CnIQKjBc6sM501/yOAZ8
         PUPr97igoRvo3YK96vSzTupMdXAA8a+1pkz1+V59M0UYfeUWweiS2IoqXoEHaYTPmuvS
         U7WtYzaORoI7/UV6ySFe/98NdSbY/1TxivN0Xkobexaf3XmS3JN4O6hsjN5j6WIvVNP1
         P1QPiH+LTz3+219IBaOcYegxhXyKbDrSuuYPO+jT9LdXXeY/NX8qmpHWpGer7K+YLBoV
         iSkzbfc1Pf/0BjygEmAaiyfi8Fie1ZupMQtoq2V+rQSgnGF/SFt/5pbDOtsFYqT+3qKV
         oZ4Q==
X-Gm-Message-State: AOAM531BlBg0BBQi4hA1mUhpNMZnAkQ+DRCI0h/a3iKFA+H4zxChOJsx
        JEQaJ7NoPKafzre5nq0OKZTZ
X-Google-Smtp-Source: ABdhPJyi7LkIVDRMXFCcBzP5s5ZBZ1gaIkDSkHERNZYMl41UlyV4GQjbz8zPtKSlM3a0M+Z0vCoXCg==
X-Received: by 2002:a17:902:d694:b029:e3:906a:61f8 with SMTP id v20-20020a170902d694b02900e3906a61f8mr27542582ply.36.1614081119392;
        Tue, 23 Feb 2021 03:51:59 -0800 (PST)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id y72sm10247421pfg.126.2021.02.23.03.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 03:51:59 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v4 04/11] vdpa: Add an opaque pointer for vdpa_config_ops.dma_map()
Date:   Tue, 23 Feb 2021 19:50:41 +0800
Message-Id: <20210223115048.435-5-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223115048.435-1-xieyongji@bytedance.com>
References: <20210223115048.435-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an opaque pointer for DMA mapping.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 6 +++---
 drivers/vhost/vdpa.c             | 2 +-
 include/linux/vdpa.h             | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index d5942842432d..5cfc262ce055 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -512,14 +512,14 @@ static int vdpasim_set_map(struct vdpa_device *vdpa,
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
index 5500e3bf05c1..70857fe3263c 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -544,7 +544,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
 		return r;
 
 	if (ops->dma_map) {
-		r = ops->dma_map(vdpa, iova, size, pa, perm);
+		r = ops->dma_map(vdpa, iova, size, pa, perm, NULL);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
 			r = ops->set_map(vdpa, dev->iotlb);
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 4ab5494503a8..93dca2c328ae 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -241,7 +241,7 @@ struct vdpa_config_ops {
 	/* DMA ops */
 	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
 	int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
-		       u64 pa, u32 perm);
+		       u64 pa, u32 perm, void *opaque);
 	int (*dma_unmap)(struct vdpa_device *vdev, u64 iova, u64 size);
 
 	/* Free device resources */
-- 
2.11.0

