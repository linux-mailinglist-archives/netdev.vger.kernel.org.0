Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D5C41C154
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244979AbhI2JLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:11:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50172 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239961AbhI2JLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 05:11:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632906591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RcOVP83sWDrBqrCNf2sVDncAktEVO2ePzZXObxtehhI=;
        b=dnyGG0+s7+X5hL26YyXKVDaC74Lh2WJSWAzd+qW7xF7jOIIs/ORhGpCsmfojBhAKWRfN20
        oKHZc7pz1Eu6s4eqNUSZrB7lhJJ3P8MJ/2QDy7QVc4mBnFPT5TTWqFIXGAJmzb1ot4yrDq
        rzwXQ5bJcTdfsCeFWJOsg/ITfWyh8YQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-0oOI8YVTOLiPmhnXhMqRlA-1; Wed, 29 Sep 2021 05:09:50 -0400
X-MC-Unique: 0oOI8YVTOLiPmhnXhMqRlA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01023802947;
        Wed, 29 Sep 2021 09:09:49 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-13-131.pek2.redhat.com [10.72.13.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D41F960C9F;
        Wed, 29 Sep 2021 09:09:36 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, mst@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] vhost-vdpa: Fix the wrong input in config_cb
Date:   Wed, 29 Sep 2021 17:09:33 +0800
Message-Id: <20210929090933.20465-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the wrong input in for config_cb. In function vhost_vdpa_config_cb,
the input cb.private was used as struct vhost_vdpa, so the input was
wrong here, fix this issue

Fixes: 776f395004d8 ("vhost_vdpa: Support config interrupt in vdpa")
Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vhost/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 942666425a45..e532cbe3d2f7 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -322,7 +322,7 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
 	struct eventfd_ctx *ctx;
 
 	cb.callback = vhost_vdpa_config_cb;
-	cb.private = v->vdpa;
+	cb.private = v;
 	if (copy_from_user(&fd, argp, sizeof(fd)))
 		return  -EFAULT;
 
-- 
2.21.3

