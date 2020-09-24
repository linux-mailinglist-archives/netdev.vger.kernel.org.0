Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274BE276706
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgIXDX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:23:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32961 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726944AbgIXDX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:23:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0cDeXJFCobELz2j5HibTagugHFNh4YZzVjAfv6U08no=;
        b=T4HLBMDSNtZ/yrVtWVWQPnKIoDimDbQJKSxaEOurvTtE7NPmShZ7fPDNt38rVP6f4OFXpU
        0VushoDLTaPWKtu8Zyt9MHv7o9Wbifm9GMnXL8AEQKI9Y6aJNmK7aT/K1LCU1Oy08vJ4G5
        MP9oA9BrFUXpwuFsUU7aB4Yg2yV0tNI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-YByKUmJjNr-a1ioSYciYsw-1; Wed, 23 Sep 2020 23:23:51 -0400
X-MC-Unique: YByKUmJjNr-a1ioSYciYsw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA64D1084CB0;
        Thu, 24 Sep 2020 03:23:49 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA5243782;
        Thu, 24 Sep 2020 03:23:40 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 11/24] vhost_iotlb: split out IOTLB initialization
Date:   Thu, 24 Sep 2020 11:21:12 +0800
Message-Id: <20200924032125.18619-12-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch split out IOTLB initialization logic into a new
helper. This allows vhost to implement device specific IOTLB
allocation logic.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/iotlb.c       | 23 ++++++++++++++++++-----
 include/linux/vhost_iotlb.h |  2 ++
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 1f0ca6e44410..36d785efd038 100644
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
2.20.1

