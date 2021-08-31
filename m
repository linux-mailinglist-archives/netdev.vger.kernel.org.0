Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3773D3FC61C
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241106AbhHaKkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 06:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241099AbhHaKib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 06:38:31 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917C6C0612AF
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 03:37:29 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so1631524pjc.3
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 03:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CGl/RjOOzzXlpDeA69Ku950YCkBGnktZEIYihkRI6vQ=;
        b=gwUN43qqsZ0EsCgXoYnM4vF6YZmTGFwNDUigCEPQSiHqFlc+pUMJVBca+24n1B5/W/
         VMYli3FcPYK5iBSJy/bxGxlS/TIQ5HYsl4Mj4E5aqwlOFgzgRCagRblJ2hXVh8cE42KD
         6IY3YuLv9nQEj5UxKPBzsnhJ/ZO3affOd7xDoz93JLMbrG0CLkfKzcVKAcwWg+mbaitm
         wKKLSXOE2D0caQwrOKHMeTi9AWaCoduPcZosCAh5kotRvEVZAQjOuySlJh+btT09oMob
         u1GX8qrF5BDPY3qNwRV1SIuhtMtP3AJroVUBjARZbojwBK1GEFOvq9lxvUEPs7yO/p/r
         4sNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CGl/RjOOzzXlpDeA69Ku950YCkBGnktZEIYihkRI6vQ=;
        b=tlf4d18hQ5/kWt0PvowBQ556pwCOSkf5qZtG3XB+LbxUFWtzDIJlwY466Ip8978+6/
         hi5fZsZWiSfVCPsOJGm60fnp57w8cGr03ADWgoEOp4F+w8krouSjCTXUvS2C3oJMY+gg
         xbV+swwcfAw2u7bwP/cRPyFSLw1Mx9Us/c/7evZjZ67q7sh2OCGMqxbhCxAQXtlaunmM
         DcZBIgGmx4Qx7gcfTjYAEUeCOKLL08Hioi7ZZea2iyKK0iGNUnDBxWNwnCfJpc5cXhKP
         ppqFVSUbQoM9QasaXQeCKfQbPQ8JikmwrpzQrQeeLHOfBWJOkHRNv9CNTZegWlneK8Ow
         GDJQ==
X-Gm-Message-State: AOAM531LwqDtqqDQU+0dWJhUm0KnxQA079Zw2sBESXOYOgp57yizjyko
        0+fSsKHcYf4ZVU0DCsdLBf4+
X-Google-Smtp-Source: ABdhPJxZBaAKaCg5B5hOWetv2uR1h9HRTFdgLxl28e3BxBCqpUf5O0m6BuOIlSPTfEI2D1tYSt5mRQ==
X-Received: by 2002:a17:90a:d590:: with SMTP id v16mr4584978pju.205.1630406249180;
        Tue, 31 Aug 2021 03:37:29 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id 17sm1823241pfm.172.2021.08.31.03.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 03:37:28 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        will@kernel.org, john.garry@huawei.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v13 07/13] vhost-iotlb: Add an opaque pointer for vhost IOTLB
Date:   Tue, 31 Aug 2021 18:36:28 +0800
Message-Id: <20210831103634.33-8-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210831103634.33-1-xieyongji@bytedance.com>
References: <20210831103634.33-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an opaque pointer for vhost IOTLB. And introduce
vhost_iotlb_add_range_ctx() to accept it.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/iotlb.c       | 20 ++++++++++++++++----
 include/linux/vhost_iotlb.h |  3 +++
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 0582079e4bcc..670d56c879e5 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -36,19 +36,21 @@ void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
 EXPORT_SYMBOL_GPL(vhost_iotlb_map_free);
 
 /**
- * vhost_iotlb_add_range - add a new range to vhost IOTLB
+ * vhost_iotlb_add_range_ctx - add a new range to vhost IOTLB
  * @iotlb: the IOTLB
  * @start: start of the IOVA range
  * @last: last of IOVA range
  * @addr: the address that is mapped to @start
  * @perm: access permission of this range
+ * @opaque: the opaque pointer for the new mapping
  *
  * Returns an error last is smaller than start or memory allocation
  * fails
  */
-int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
-			  u64 start, u64 last,
-			  u64 addr, unsigned int perm)
+int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
+			      u64 start, u64 last,
+			      u64 addr, unsigned int perm,
+			      void *opaque)
 {
 	struct vhost_iotlb_map *map;
 
@@ -71,6 +73,7 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
 	map->last = last;
 	map->addr = addr;
 	map->perm = perm;
+	map->opaque = opaque;
 
 	iotlb->nmaps++;
 	vhost_iotlb_itree_insert(map, &iotlb->root);
@@ -80,6 +83,15 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vhost_iotlb_add_range_ctx);
+
+int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
+			  u64 start, u64 last,
+			  u64 addr, unsigned int perm)
+{
+	return vhost_iotlb_add_range_ctx(iotlb, start, last,
+					 addr, perm, NULL);
+}
 EXPORT_SYMBOL_GPL(vhost_iotlb_add_range);
 
 /**
diff --git a/include/linux/vhost_iotlb.h b/include/linux/vhost_iotlb.h
index 6b09b786a762..2d0e2f52f938 100644
--- a/include/linux/vhost_iotlb.h
+++ b/include/linux/vhost_iotlb.h
@@ -17,6 +17,7 @@ struct vhost_iotlb_map {
 	u32 perm;
 	u32 flags_padding;
 	u64 __subtree_last;
+	void *opaque;
 };
 
 #define VHOST_IOTLB_FLAG_RETIRE 0x1
@@ -29,6 +30,8 @@ struct vhost_iotlb {
 	unsigned int flags;
 };
 
+int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb, u64 start, u64 last,
+			      u64 addr, unsigned int perm, void *opaque);
 int vhost_iotlb_add_range(struct vhost_iotlb *iotlb, u64 start, u64 last,
 			  u64 addr, unsigned int perm);
 void vhost_iotlb_del_range(struct vhost_iotlb *iotlb, u64 start, u64 last);
-- 
2.11.0

