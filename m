Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FFC445AD9
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 20:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhKDUBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 16:01:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232198AbhKDUB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 16:01:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636055929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=z4lusGM7hW6yb6Tdfb4DRGhZ18YMdjS4zPghOdfTXPc=;
        b=RsDxAa88Nx/yzC6qhs12dvSvPbG4Suj2dXQMI/4KyMCA7IdqabdBTEtMIpzEXXswNxZ+Br
        DOjvHIcPXdzLjmJFWeoDRSsoBzh0ZN4gkWyN2oaOVpvSpCDoJVxC1v1vaUuyRQno/fFsOq
        fcYLdOmuVG593ft42r6IV2/Al6gpv2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-YH74HwnqOkK0sgQ_HEodwQ-1; Thu, 04 Nov 2021 15:58:45 -0400
X-MC-Unique: YH74HwnqOkK0sgQ_HEodwQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF5051054F93;
        Thu,  4 Nov 2021 19:58:44 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.194.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CCF71007625;
        Thu,  4 Nov 2021 19:58:37 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH] vdpa: Avoid duplicate call to vp_vdpa get_status
Date:   Thu,  4 Nov 2021 20:58:33 +0100
Message-Id: <20211104195833.2089796-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has no sense to call get_status twice, since we already have a
variable for that.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vhost/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 01c59ce7e250..10676ea0348b 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -167,13 +167,13 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 	status_old = ops->get_status(vdpa);
 
 	/*
 	 * Userspace shouldn't remove status bits unless reset the
 	 * status to 0.
 	 */
-	if (status != 0 && (ops->get_status(vdpa) & ~status) != 0)
+	if (status != 0 && (status_old & ~status) != 0)
 		return -EINVAL;
 
 	if ((status_old & VIRTIO_CONFIG_S_DRIVER_OK) && !(status & VIRTIO_CONFIG_S_DRIVER_OK))
 		for (i = 0; i < nvqs; i++)
 			vhost_vdpa_unsetup_vq_irq(v, i);
 
-- 
2.27.0

