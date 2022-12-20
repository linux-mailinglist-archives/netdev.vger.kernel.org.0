Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774976521EF
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 15:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbiLTODK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 09:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbiLTODJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 09:03:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5231B1CD
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 06:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671544940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=LiH/7F4Cx8tMkgKW5fUS61LWWStD6+IDSYW+AV8YpQI=;
        b=B6IH/QNwKfytB9fePirbAuOpcwhnp4Mcb8WiAqgwGFcWwdH/J8ACqEHRy9Zjx3dcP7W6ow
        YArDkjqaQge0oMZJUQQ+IzxBXraohv84wkEHKCjOHROzJOD/k8vG9+VeUrutcyf4wBTrK4
        HkkfgbCLsDfZ6BLpuM5I4xwYWu4YIxk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-3yrGsoUTPCyBUoQoZTSE_A-1; Tue, 20 Dec 2022 09:02:16 -0500
X-MC-Unique: 3yrGsoUTPCyBUoQoZTSE_A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DDB485C06A;
        Tue, 20 Dec 2022 14:02:16 +0000 (UTC)
Received: from server.redhat.com (ovpn-12-67.pek2.redhat.com [10.72.12.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FC5C175AD;
        Tue, 20 Dec 2022 14:02:12 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] vhost_vdpa: fix the compile issue in commit 881ac7d2314f
Date:   Tue, 20 Dec 2022 22:02:05 +0800
Message-Id: <20221220140205.795115-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The input of  vhost_vdpa_iotlb_unmap() was changed in 881ac7d2314f,
But some function was not changed while calling this function.
Add this change

Cc: stable@vger.kernel.org
Fixes: 881ac7d2314f ("vhost_vdpa: fix the crash in unmap a large memory")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vhost/vdpa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 46ce35bea705..ec32f785dfde 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -66,8 +66,8 @@ static DEFINE_IDA(vhost_vdpa_ida);
 static dev_t vhost_vdpa_major;
 
 static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
-				   struct vhost_iotlb *iotlb,
-				   u64 start, u64 last);
+				   struct vhost_iotlb *iotlb, u64 start,
+				   u64 last, u32 asid);
 
 static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb)
 {
@@ -139,7 +139,7 @@ static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
 		return -EINVAL;
 
 	hlist_del(&as->hash_link);
-	vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
+	vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1, asid);
 	kfree(as);
 
 	return 0;
-- 
2.34.3

