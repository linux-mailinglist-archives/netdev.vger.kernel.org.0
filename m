Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7272FB2AA
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 08:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389955AbhASF0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 00:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388935AbhASFKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 00:10:23 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A970DC061786
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 21:08:28 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id u4so11361703pjn.4
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 21:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t3cY7CxP1IBzVsJGjcj8blqMZcQjokVEop4ReGoC7JE=;
        b=TEg+IOYZST+7tYQUg1/prfYMdgJIbYGfE5jH4E7BZIml0/hSPCz3KbwjSxXpiQsRZl
         Q8l81z+hVG6Xt72wYh15Fo9jMa24fzcmQCqN0jO7hAIdtR0TT33wJSAbVOWl9nN8CbeH
         wthbRRKu8tL9b6om9Gse2Y+8qcuWq6CPO464iUnoiGhSclGpRl6VRQRui7JsBJKTiryh
         nT2XiZjYh14ExYSPwYhUXBdjgi2iXgBRnrc8XAJ6hUI7UtJJEdnVGAiHrblWDqwaLew/
         +hAHfdNaVBy4QKfKFunM1DoBJJsowjZWgC/OW7bwcXDqwZCi3+nYNwcXHJCSeBVyWGXo
         T6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t3cY7CxP1IBzVsJGjcj8blqMZcQjokVEop4ReGoC7JE=;
        b=ZhEYP6qBxcfI9LRRGKmfxLE/+9YMxmxWlhPep3XOzXwBjTriAGJ0q50/IwnmwAZdiC
         dB8lnnLHgjU/OU9ePKeI90pxBlmrSoCiUptLBeRsWFMPI4LonvhWBoruYW1e1gJd9dBf
         WuMgZZmHXkozea5wNdglLCPokURiwt42tJ4PMAjAa8ll3t5VrZC2JJ2PlnY5VZmobivg
         8ucJhEtEnq2fpFtU/HfkAjHx29K21tlPt6QXYzIagA4qKPZqDbo0bnUT9M35wpFwZ2WZ
         zNI4LMIVXBelk0OPmdw+MO2Mr+/Tr9mauBPEJcaUSXMMvF4Vt0L8Q/eYFFimJ+AbbgtK
         QzfA==
X-Gm-Message-State: AOAM5326ug8NKatnURUsM7OMyMdHzNIpD7Vxly/lBvTA10qiDLvwGP2O
        +eOeq14A9HKmyXSzTLWWUbv2
X-Google-Smtp-Source: ABdhPJzuUPBsbXsliQWe6YeR9pV9Pcl1Qlp+OOESCFCSFdZxLsSlgkaLNNMDIGMzQUlolElY5qtofw==
X-Received: by 2002:a17:903:230b:b029:dd:7cf1:8c33 with SMTP id d11-20020a170903230bb02900dd7cf18c33mr2894021plh.31.1611032908304;
        Mon, 18 Jan 2021 21:08:28 -0800 (PST)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id i2sm1125169pjd.21.2021.01.18.21.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 21:08:27 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v3 10/11] vduse: grab the module's references until there is no vduse device
Date:   Tue, 19 Jan 2021 13:07:55 +0800
Message-Id: <20210119050756.600-4-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119050756.600-1-xieyongji@bytedance.com>
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119050756.600-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The module should not be unloaded if any vduse device exists.
So increase the module's reference count when creating vduse
device. And the reference count is kept until the device is
destroyed.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 4d21203da5b6..003aeb281bce 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -978,6 +978,7 @@ static int vduse_destroy_dev(u32 id)
 	kfree(dev->vqs);
 	vduse_domain_destroy(dev->domain);
 	vduse_dev_destroy(dev);
+	module_put(THIS_MODULE);
 
 	return 0;
 }
@@ -1022,6 +1023,7 @@ static int vduse_create_dev(struct vduse_dev_config *config)
 
 	dev->connected = true;
 	list_add(&dev->list, &vduse_devs);
+	__module_get(THIS_MODULE);
 
 	return fd;
 err_fd:
-- 
2.11.0

