Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9812DBB93
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgLPGvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:51:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55153 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726051AbgLPGvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 01:51:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608101375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJzPHH5JPi1UiRGkNHp91R5FaQjKQU30q1zC8IFdmyE=;
        b=ZotAs/6O5Cux5FOJSdhYtUq6pHYaQ6fktT7k6dX9cuP2PCXJdhqGKmM8DiDbYyoAwwIHtm
        XAPFEiGKqFFtxHD8hWJFNXpuVwByMTnKogK1FikkBF7Joakb4QRSF8jzwrTOGJhhqzFsI1
        4OrhHm27AffbZErZhkdmWu2s/r/XIq8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248--8dEB7jeNNyX4sPdLcYrxQ-1; Wed, 16 Dec 2020 01:49:32 -0500
X-MC-Unique: -8dEB7jeNNyX4sPdLcYrxQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05E9C180A096;
        Wed, 16 Dec 2020 06:49:31 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-210.pek2.redhat.com [10.72.12.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4C8710013C1;
        Wed, 16 Dec 2020 06:49:20 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
Subject: [PATCH 09/21] vhost_iotlb: split out IOTLB initialization
Date:   Wed, 16 Dec 2020 14:48:06 +0800
Message-Id: <20201216064818.48239-10-jasowang@redhat.com>
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch splits out IOTLB initialization to make sure it could be
reused by external modules.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/iotlb.c       | 23 ++++++++++++++++++-----
 include/linux/vhost_iotlb.h |  2 ++
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 0fd3f87e913c..e842d76c179e 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -98,6 +98,23 @@ void vhost_iotlb_del_range(struct vhost_iotlb *iotlb, u64 start, u64 last)
 }
 EXPORT_SYMBOL_GPL(vhost_iotlb_del_range);
 
+/**
+ * vhost_iotlb_init - initialize a vhost IOTLB
+ * @iotlb: the IOTLB that needs to be initialized
+ * @limit: maximum number of IOTLB entries
+ * @flags: VHOST_IOTLB_FLAG_XXX
+ */
+void vhost_iotlb_init(struct vhost_iotlb *iotlb, unsigned int limit,
+		      unsigned int flags)
+{
+	iotlb->root = RB_ROOT_CACHED;
+	iotlb->limit = limit;
+	iotlb->nmaps = 0;
+	iotlb->flags = flags;
+	INIT_LIST_HEAD(&iotlb->list);
+}
+EXPORT_SYMBOL_GPL(vhost_iotlb_init);
+
 /**
  * vhost_iotlb_alloc - add a new vhost IOTLB
  * @limit: maximum number of IOTLB entries
@@ -112,11 +129,7 @@ struct vhost_iotlb *vhost_iotlb_alloc(unsigned int limit, unsigned int flags)
 	if (!iotlb)
 		return NULL;
 
-	iotlb->root = RB_ROOT_CACHED;
-	iotlb->limit = limit;
-	iotlb->nmaps = 0;
-	iotlb->flags = flags;
-	INIT_LIST_HEAD(&iotlb->list);
+	vhost_iotlb_init(iotlb, limit, flags);
 
 	return iotlb;
 }
diff --git a/include/linux/vhost_iotlb.h b/include/linux/vhost_iotlb.h
index 6b09b786a762..c0df193ec3e1 100644
--- a/include/linux/vhost_iotlb.h
+++ b/include/linux/vhost_iotlb.h
@@ -33,6 +33,8 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb, u64 start, u64 last,
 			  u64 addr, unsigned int perm);
 void vhost_iotlb_del_range(struct vhost_iotlb *iotlb, u64 start, u64 last);
 
+void vhost_iotlb_init(struct vhost_iotlb *iotlb, unsigned int limit,
+		      unsigned int flags);
 struct vhost_iotlb *vhost_iotlb_alloc(unsigned int limit, unsigned int flags);
 void vhost_iotlb_free(struct vhost_iotlb *iotlb);
 void vhost_iotlb_reset(struct vhost_iotlb *iotlb);
-- 
2.25.1

