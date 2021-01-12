Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C652F27EB
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 06:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733218AbhALFeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 00:34:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41677 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732716AbhALFeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 00:34:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610429572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3tdKW3SLUhCLxVY2DOdCzA12uRd5TyP8aBW/+yPnNmQ=;
        b=JC3b0Qu6xa2OvgxlH/WzDq8muGMQmyxzpnYX1FiN6CsLanNxAwlvvUkoemuvqnPucNGdXM
        F/fkAfC/SuTZmJa05/6ZRVCF7n0NuHpyYvq3Wxwg50W1mph3O3E4KYT1qcMkTEYyObbeC8
        X56lEbF76LgMxR1yHomaVb/Oq2rHS+w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-qI6e3ArVMbCdtWuQePZw8Q-1; Tue, 12 Jan 2021 00:32:50 -0500
X-MC-Unique: qI6e3ArVMbCdtWuQePZw8Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D80291842140;
        Tue, 12 Jan 2021 05:32:48 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E0B510016F6;
        Tue, 12 Jan 2021 05:32:42 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        lingshan.zhu@intel.com
Cc:     stable@vger.kernel.org
Subject: [PATCH v2] vhost_vdpa: fix the problem in vhost_vdpa_set_config_call
Date:   Tue, 12 Jan 2021 13:32:27 +0800
Message-Id: <20210112053227.8574-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vhost_vdpa_set_config_call, the cb.private should be vhost_vdpa.
this cb.private will finally use in vhost_vdpa_config_cb as
vhost_vdpa. Fix this issue.

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vhost/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ef688c8c0e0e..3fbb9c1f49da 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -319,7 +319,7 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
 	struct eventfd_ctx *ctx;
 
 	cb.callback = vhost_vdpa_config_cb;
-	cb.private = v->vdpa;
+	cb.private = v;
 	if (copy_from_user(&fd, argp, sizeof(fd)))
 		return  -EFAULT;
 
-- 
2.21.3

