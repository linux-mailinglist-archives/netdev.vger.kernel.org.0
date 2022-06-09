Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59742544267
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 06:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbiFIETS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 00:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236029AbiFIETP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 00:19:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 40DA62FA608
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 21:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654748353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2EUgTmBmBQS8TADvNh3w+eG84Zb6i5oxbEJ7TRa74m8=;
        b=Et2s9jOUUDBSP5hzOYrIXb+hMnmFQr7LrcFVLbpEVpNN+0AgfJQs8lLa4y8w4hxg1ParMs
        vqceXCnYa4JsHlF3eOnvmZmztB77EYHrrlOYJMLHBD/sD6nJDZiMWB3eJl5/7KF6Ue1XS2
        ZIoFVml3XpPNCFlGcR+OYXqVPqn63fI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-z2rJ_Z0XPfueqmTPLXd04A-1; Thu, 09 Jun 2022 00:19:07 -0400
X-MC-Unique: z2rJ_Z0XPfueqmTPLXd04A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F6C3811E75;
        Thu,  9 Jun 2022 04:19:07 +0000 (UTC)
Received: from localhost.localdomain (ovpn-14-4.pek2.redhat.com [10.72.14.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7733A1730C;
        Thu,  9 Jun 2022 04:19:04 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gautam Dawar <gautam.dawar@xilinx.com>
Subject: [PATCH] vdpa: make get_vq_group and set_group_asid optional
Date:   Thu,  9 Jun 2022 12:19:01 +0800
Message-Id: <20220609041901.2029-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes get_vq_group and set_group_asid optional. This is
needed to unbreak the vDPA parent that doesn't support multiple
address spaces.

Cc: Gautam Dawar <gautam.dawar@xilinx.com>
Fixes: aaca8373c4b1 ("vhost-vdpa: support ASID based IOTLB API")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 2 ++
 include/linux/vdpa.h | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 935a1d0ddb97..5ad2596c6e8a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -499,6 +499,8 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		ops->set_vq_ready(vdpa, idx, s.num);
 		return 0;
 	case VHOST_VDPA_GET_VRING_GROUP:
+		if (!ops->get_vq_group)
+			return -EOPNOTSUPP;
 		s.index = idx;
 		s.num = ops->get_vq_group(vdpa, idx);
 		if (s.num >= vdpa->ngroups)
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 15af802d41c4..6113a978fbcd 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -176,7 +176,8 @@ struct vdpa_map_file {
  *				for the device
  *				@vdev: vdpa device
  *				Returns virtqueue algin requirement
- * @get_vq_group:		Get the group id for a specific virtqueue
+ * @get_vq_group:		Get the group id for a specific
+ *				virtqueue (optional)
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				Returns u32: group id for this virtqueue
@@ -241,7 +242,7 @@ struct vdpa_map_file {
  *				Returns the iova range supported by
  *				the device.
  * @set_group_asid:		Set address space identifier for a
- *				virtqueue group
+ *				virtqueue group (optional)
  *				@vdev: vdpa device
  *				@group: virtqueue group
  *				@asid: address space id for this group
-- 
2.25.1

