Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883261CB347
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgEHPhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728304AbgEHPhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:37:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24ABEC061A0C;
        Fri,  8 May 2020 08:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=nmjnltB29xld+C3Z+3PwCdDAVaharMq9Nb/YJIWz0Mw=; b=XC7dRbkcv1Z+9Aj3oRe1TSTHyA
        92hwRGkNvqNC1eKJPiFAchuwONZiLGsaR09OC9v+N2an8W+SAyjulwp7XCmGWsm1fNWqkmFfGnGQe
        d+lsRHk/Bu2X6EcnRHqZEP/tmf+cfJDroBH3O+RBLMcto3g5Hpz5EsuYPzyIRDUd6Tx0MGnxaD+o4
        8NZidjToalkxI1guS+RsMSwlFeAWxK4ZTLFqmVkASNbu0eweGVJrRiijmA8PNH65Z8vpwwddiqMrD
        /VgNAyZqKh5bCLc5iRU9un0MeHL8up6W0xpMpgOOCMrlYGGig+ysKu6//vM1JaYlCnY64yS1RWO6e
        E1IikOWA==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX53b-0004Kk-JZ; Fri, 08 May 2020 15:37:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 08/12] vfio: use __anon_inode_getfd
Date:   Fri,  8 May 2020 17:36:30 +0200
Message-Id: <20200508153634.249933-9-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508153634.249933-1-hch@lst.de>
References: <20200508153634.249933-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use __anon_inode_getfd instead of opencoding the logic using
get_unused_fd_flags + anon_inode_getfile.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/vfio.c | 37 ++++++++-----------------------------
 1 file changed, 8 insertions(+), 29 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 765e0e5d83ed9..33a88103f857f 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1451,42 +1451,21 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 		return ret;
 	}
 
-	/*
-	 * We can't use anon_inode_getfd() because we need to modify
-	 * the f_mode flags directly to allow more than just ioctls
-	 */
-	ret = get_unused_fd_flags(O_CLOEXEC);
-	if (ret < 0) {
-		device->ops->release(device->device_data);
-		vfio_device_put(device);
-		return ret;
-	}
-
-	filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
-				   device, O_RDWR);
-	if (IS_ERR(filep)) {
-		put_unused_fd(ret);
-		ret = PTR_ERR(filep);
-		device->ops->release(device->device_data);
-		vfio_device_put(device);
-		return ret;
-	}
-
-	/*
-	 * TODO: add an anon_inode interface to do this.
-	 * Appears to be missing by lack of need rather than
-	 * explicitly prevented.  Now there's need.
-	 */
+	ret = __anon_inode_getfd("[vfio-device]", &vfio_device_fops,
+				   device, O_CLOEXEC | O_RDWR, &filep);
+	if (ret < 0)
+		goto release;
 	filep->f_mode |= (FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE);
-
 	atomic_inc(&group->container_users);
-
 	fd_install(ret, filep);
 
 	if (group->noiommu)
 		dev_warn(device->dev, "vfio-noiommu device opened by user "
 			 "(%s:%d)\n", current->comm, task_pid_nr(current));
-
+	return ret;
+release:
+	device->ops->release(device->device_data);
+	vfio_device_put(device);
 	return ret;
 }
 
-- 
2.26.2

