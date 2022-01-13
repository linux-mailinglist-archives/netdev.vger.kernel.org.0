Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DF048D989
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 15:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235611AbiAMOMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 09:12:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20317 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235603AbiAMOMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 09:12:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642083119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xCYpNTbO554QGVwnOrW/uIVMk9yK3DSR4H4rxcM8uH8=;
        b=XP0INRmItVZ7qBKFN+s9F/72jKiAQt3Md567XnT1bSVQinAdDiW57foDbAzPJjLeaWQVXb
        8nF64704fkNfFzbAYSBdydfJ04qcG967664R0VVUKGU1lysrGgRThGVc98HaWL6EqhHIww
        gp2rPeLFCSNNCPWdKB7F+U/IyAE40Rg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-fm-pjm88NTydB7XZ6ad7Jw-1; Thu, 13 Jan 2022 09:11:56 -0500
X-MC-Unique: fm-pjm88NTydB7XZ6ad7Jw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 504A581EE64;
        Thu, 13 Jan 2022 14:11:55 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.64.242.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA7F92B5A5;
        Thu, 13 Jan 2022 14:11:37 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH] vhost: remove avail_event arg from vhost_update_avail_event()
Date:   Thu, 13 Jan 2022 15:11:34 +0100
Message-Id: <20220113141134.186773-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vhost_update_avail_event() we never used the `avail_event` argument,
since its introduction in commit 2723feaa8ec6 ("vhost: set log when
updating used flags or avail event").

Let's remove it to clean up the code.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vhost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 59edb5a1ffe2..ee171e663a18 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1981,7 +1981,7 @@ static int vhost_update_used_flags(struct vhost_virtqueue *vq)
 	return 0;
 }
 
-static int vhost_update_avail_event(struct vhost_virtqueue *vq, u16 avail_event)
+static int vhost_update_avail_event(struct vhost_virtqueue *vq)
 {
 	if (vhost_put_avail_event(vq))
 		return -EFAULT;
@@ -2527,7 +2527,7 @@ bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 			return false;
 		}
 	} else {
-		r = vhost_update_avail_event(vq, vq->avail_idx);
+		r = vhost_update_avail_event(vq);
 		if (r) {
 			vq_err(vq, "Failed to update avail event index at %p: %d\n",
 			       vhost_avail_event(vq), r);
-- 
2.31.1

