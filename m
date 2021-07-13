Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A323C6C5F
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 10:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbhGMIug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 04:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbhGMIub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 04:50:31 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A05AC0613F0
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 01:47:42 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id v18-20020a17090ac912b0290173b9578f1cso1502924pjt.0
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 01:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FdoZ+4EM7JCQgZ86bDT9RbGlh7q+AWgllGjoIYPWL9Q=;
        b=gA1/QgaUqMMGrBGGpEVYK8fMzHiF70tOx013tB9CxkOMsIAz6K9CyWbLukiYsceeeK
         WT3omC6T/UV02GbqJntqFcUEJy/CsH+2v38lltH8hTUVi5bDMirNFM2m8jsgCd53U/1v
         Lc/Oygn7Gsw282JeKIqoiMuvIbDZt/am73WeLkzOY2/CkX4nQAuUu3ul4s5GPTxJkyx3
         dWRyzileES+3pFwFh509M/IKBfUS06G83m9tPJd2yiq3RvUawNvAiQ6SGLm5AoV3JD3Q
         Yf50mdZiBV6HqGDPHp59XIyHUg9RniZUw56YWfFOmyWOXjXu+QsXkJ6TpitVDuk7cFO9
         CT5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FdoZ+4EM7JCQgZ86bDT9RbGlh7q+AWgllGjoIYPWL9Q=;
        b=NzZ+H+ih7H0bwtksKVy8hE6OU4z5+fH6cx607OLFgoF+50QyYADM/txDJLeCn46vas
         bjjPPV+eiLVHg1/jLsi+gf/BcsySeUXFVYeX+qYIFQeScP1PzZFOsFl+gSxGE4xFXNPU
         29hE6V50sGVhbLwade1mp31i9hvznoCfYUsNtANdIuAWdC6G/kYgaz8oK+Pz4NVNduG0
         BwVVLc5iKqqYgNFL5ShqQ1qIt+cRfOznYdFUCVvUgsPaedz1euqhaI6tZ1Z9RtEx2uMT
         hlu8fvBJtf0lmbtIIwD5284febmwEYa4Laxz3nDD5+bD07dKY4H1c3gZyzSAMxFyFf3N
         HMqw==
X-Gm-Message-State: AOAM532j/n5hsHFKAKB59TyKWm5KgZF1a01J5+uqJa8+98RzUx5B1elH
        RvrY2vFIYc749EFwVB3Mlv6f
X-Google-Smtp-Source: ABdhPJy/YXaKCppxOExioeRxTLQv1sj8lcUHDptTXIY/sm3klehqPKR0QkOZNRfSckm4SM+jax8f+w==
X-Received: by 2002:a17:90b:1b4d:: with SMTP id nv13mr1935868pjb.216.1626166061630;
        Tue, 13 Jul 2021 01:47:41 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id w2sm15858457pjq.5.2021.07.13.01.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 01:47:41 -0700 (PDT)
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
Subject: [PATCH v9 05/17] vhost-vdpa: Fail the vhost_vdpa_set_status() on reset failure
Date:   Tue, 13 Jul 2021 16:46:44 +0800
Message-Id: <20210713084656.232-6-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210713084656.232-1-xieyongji@bytedance.com>
References: <20210713084656.232-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re-read the device status to ensure it's set to zero during
resetting. Otherwise, fail the vhost_vdpa_set_status() after timeout.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vhost/vdpa.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index bb374a801bda..62b6d911c57d 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -157,7 +157,7 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 	u8 status, status_old;
-	int nvqs = v->nvqs;
+	int timeout = 0, nvqs = v->nvqs;
 	u16 i;
 
 	if (copy_from_user(&status, statusp, sizeof(status)))
@@ -173,6 +173,15 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 		return -EINVAL;
 
 	ops->set_status(vdpa, status);
+	if (status == 0) {
+		while (ops->get_status(vdpa)) {
+			timeout += 20;
+			if (timeout > VDPA_RESET_TIMEOUT_MS)
+				return -EIO;
+
+			msleep(20);
+		}
+	}
 
 	if ((status & VIRTIO_CONFIG_S_DRIVER_OK) && !(status_old & VIRTIO_CONFIG_S_DRIVER_OK))
 		for (i = 0; i < nvqs; i++)
-- 
2.11.0

