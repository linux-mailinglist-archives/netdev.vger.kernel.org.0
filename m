Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9EA948DA38
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 15:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbiAMO5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 09:57:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39093 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232444AbiAMO5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 09:57:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642085864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XPQLNQPANIIPTQKapMJiZGqrO9RpNgEkn+C1aN7vbUw=;
        b=STT/RHJbafvwDwPih53K0gMLMTSpQInl1HxL8Blojv1WeJ2LGnJs1/DT0jVCT+4U+0zCnn
        2HMqLo4d0x4pu56sGdJfhNZgCFbH1AUXX6YAxMZRoxqzhp9szM2zm5PDpnhp1Djpnay/TP
        qvQSe9m1qAlOyCW1DwOh0B2fJUXVnIs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-naW7issGM7GEdZAvkdEntQ-1; Thu, 13 Jan 2022 09:57:41 -0500
X-MC-Unique: naW7issGM7GEdZAvkdEntQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A022100D842;
        Thu, 13 Jan 2022 14:57:40 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.64.242.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FD665E498;
        Thu, 13 Jan 2022 14:57:04 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, stefanha@redhat.com,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: [RFC PATCH] vhost: cache avail index in vhost_enable_notify()
Date:   Thu, 13 Jan 2022 15:56:42 +0100
Message-Id: <20220113145642.205388-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vhost_enable_notify() we enable the notifications and we read
the avail index to check if new buffers have become available in
the meantime. In this case, the device would go to re-read avail
index to access the descriptor.

As we already do in other place, we can cache the value in `avail_idx`
and compare it with `last_avail_idx` to check if there are new
buffers available.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vhost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 59edb5a1ffe2..07363dff559e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2543,8 +2543,9 @@ bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 		       &vq->avail->idx, r);
 		return false;
 	}
+	vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
 
-	return vhost16_to_cpu(vq, avail_idx) != vq->avail_idx;
+	return vq->avail_idx != vq->last_avail_idx;
 }
 EXPORT_SYMBOL_GPL(vhost_enable_notify);
 
-- 
2.31.1

