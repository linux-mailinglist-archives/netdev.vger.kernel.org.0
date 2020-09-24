Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712E52766DF
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgIXDWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:22:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33063 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726643AbgIXDWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:22:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yL5gnmJjXM50BmL15PZqm3Qryv26tfuJ/8EBJBgWRs8=;
        b=ZoaSq8Nh60hWkXdR9MnzuXQX1s3ck+W+0tl6lsRV6oxU8xA1IZdVPfzqqs0s22BvCzd1WV
        qxi9BZvgjQKgUFoMt4ZA4Nj5RHC20XQAJDGRamgaQPEpC2SBTpkxn2LkR/uivilyYKHxfG
        GwL5ieXO7LxytZD8eccO0oJNTI5oHn0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-3to2PfkSM_eUuEe1qWyNBA-1; Wed, 23 Sep 2020 23:22:09 -0400
X-MC-Unique: 3to2PfkSM_eUuEe1qWyNBA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2008F1074652;
        Thu, 24 Sep 2020 03:22:06 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA91355768;
        Thu, 24 Sep 2020 03:21:50 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 02/24] vhost-vdpa: fix vqs leak in vhost_vdpa_open()
Date:   Thu, 24 Sep 2020 11:21:03 +0800
Message-Id: <20200924032125.18619-3-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to free vqs during the err path after it has been allocated
since vhost won't do that for us.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 796fe979f997..9c641274b9f3 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -764,6 +764,12 @@ static void vhost_vdpa_free_domain(struct vhost_vdpa *v)
 	v->domain = NULL;
 }
 
+static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
+{
+	vhost_dev_cleanup(&v->vdev);
+	kfree(v->vdev.vqs);
+}
+
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 {
 	struct vhost_vdpa *v;
@@ -809,7 +815,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	return 0;
 
 err_init_iotlb:
-	vhost_dev_cleanup(&v->vdev);
+	vhost_vdpa_cleanup(v);
 err:
 	atomic_dec(&v->opened);
 	return r;
@@ -840,8 +846,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_vdpa_free_domain(v);
 	vhost_vdpa_config_put(v);
 	vhost_vdpa_clean_irq(v);
-	vhost_dev_cleanup(&v->vdev);
-	kfree(v->vdev.vqs);
+	vhost_vdpa_cleanup(v);
 	mutex_unlock(&d->mutex);
 
 	atomic_dec(&v->opened);
-- 
2.20.1

