Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB5A2F27F3
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 06:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732578AbhALFiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 00:38:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43688 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732528AbhALFiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 00:38:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610429802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VH1DnjM7C34WcJYdUsZY2fXbHo1byMf7LCcAsLj7Uv8=;
        b=RhoS5SaRHW3Od+Zxb/4HowZ0x6SqFBLTWmoieWF7DpvhpLqrSdAWrH2KGtD/XzALPV+JIn
        s6lCG2punM8Y525jaUR+Ti9Noqh9L/Z+oOT21fxxv4Nx0LzStW3NOhtOmFHRMc8wfNgtg5
        nreYGGz0VGmgT5Cvl9mCR3z7Bt+G6/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-l5RWiJr-MDS2JphWcs2S1g-1; Tue, 12 Jan 2021 00:36:40 -0500
X-MC-Unique: l5RWiJr-MDS2JphWcs2S1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B67C802B40;
        Tue, 12 Jan 2021 05:36:39 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97A9B60BE2;
        Tue, 12 Jan 2021 05:36:32 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        lingshan.zhu@intel.com
Cc:     stable@vger.kernel.org
Subject: [PATCH v3] vhost_vdpa: fix the problem in vhost_vdpa_set_config_call
Date:   Tue, 12 Jan 2021 13:36:29 +0800
Message-Id: <20210112053629.9853-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vhost_vdpa_set_config_call, the cb.private should be vhost_vdpa.
this cb.private will finally use in vhost_vdpa_config_cb as
vhost_vdpa. Fix this issue.

Fixes: 776f395004d82 ("vhost_vdpa: Support config interrupt in vdpa")
Acked-by: Jason Wang <jasowang@redhat.com>
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

