Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B59303745
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 08:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389407AbhAZHTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 02:19:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389384AbhAZHRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 02:17:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611645381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yIlOP1z9vmdG98LkyGhO2vFGnoyUBAuXU0XkS/MGEis=;
        b=QDp52P5a+t1uN7HuXkj/VYkIKd20ruNmtukvGGQxlHPvym2g2DrUJ0+GQDU/gEsEKQl937
        3nY6UhJNxqkNmiqCAGLPmW1auySdJBt1o9UpicMsTmL1+ShnJo58XsLUV333bE+KdvjoCA
        oKRKqm2D2G6zRSFNkdeUYGqOVdq1UTQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-aLjSun_bOb2qfWCJd3owGA-1; Tue, 26 Jan 2021 02:16:17 -0500
X-MC-Unique: aLjSun_bOb2qfWCJd3owGA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C17F190B2A1;
        Tue, 26 Jan 2021 07:16:16 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-12-115.pek2.redhat.com [10.72.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B044E5D74E;
        Tue, 26 Jan 2021 07:16:10 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v3] vhost_vdpa: fix the problem in vhost_vdpa_set_config_call
Date:   Tue, 26 Jan 2021 15:16:07 +0800
Message-Id: <20210126071607.31487-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vhost_vdpa_set_config_call, the cb.private should be vhost_vdpa.
this cb.private will finally use in vhost_vdpa_config_cb as
vhost_vdpa. Fix this issue.

Cc: stable@vger.kernel.org
Fixes: 776f395004d82 ("vhost_vdpa: Support config interrupt in vdpa")
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

