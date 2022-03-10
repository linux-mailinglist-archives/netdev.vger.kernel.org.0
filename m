Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9B04D420A
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 08:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240159AbiCJHxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 02:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbiCJHxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 02:53:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27454132943
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 23:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646898741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=d/kJbw1ceOFiXhO5YIO+i0r0c+TxsMqa/iGcWfOLU3I=;
        b=Minv1FdXstaXqnb44YLPJjpzR+M2/UVBfT6TbxAUKmpZFEXQJEXFc4QubEAzjiHE2YMboI
        FO6vMgjpemZ7fGQ6ph+nxVInZfosH5QFkPjvxIs0Ld+JVy5C+vvN2dGpZs/tO43TvTrZnE
        4apT4AySu5o77wE3zx4+6zdflZLe52c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-5l8F3TN-PgeNTt8YBimUDQ-1; Thu, 10 Mar 2022 02:52:17 -0500
X-MC-Unique: 5l8F3TN-PgeNTt8YBimUDQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A65FD51DC;
        Thu, 10 Mar 2022 07:52:16 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-194.pek2.redhat.com [10.72.13.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D69437A220;
        Thu, 10 Mar 2022 07:52:13 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>
Subject: [PATCH] vhost: allow batching hint without size
Date:   Thu, 10 Mar 2022 15:52:11 +0800
Message-Id: <20220310075211.4801-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb
entries") tries to reject the IOTLB message whose size is zero. But
the size is not necessarily meaningful, one example is the batching
hint, so the commit breaks that.

Fixing this be reject zero size message only if the message is used to
update/invalidate the IOTLB.

Fixes: e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb entries")
Reported-by: Eli Cohen <elic@nvidia.com>
Cc: Anirudh Rayabharam <mail@anirudhrb.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 082380c03a3e..1768362115c6 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1170,7 +1170,9 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		goto done;
 	}
 
-	if (msg.size == 0) {
+	if ((msg.type == VHOST_IOTLB_UPDATE ||
+	     msg.type == VHOST_IOTLB_INVALIDATE) &&
+	     msg.size == 0) {
 		ret = -EINVAL;
 		goto done;
 	}
-- 
2.18.1

