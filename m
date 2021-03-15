Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F9033C218
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbhCOQfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:35:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45360 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233058AbhCOQfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615826143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yS6yhrkWA8GbBenFIxogYtiFYE6uOSKcO/K046TS5vQ=;
        b=hZD0Raid7MnbkzoHdKTUIKrUdn8KLH3AtolxUEoZIM8kkLPKGMN73VydZQO5ze/fQHX+tc
        VO6YsN6vLFHUkMvRdwSHH1EfeBsG4mrtipmuuB2tXmeldXWIGA1C/lIIA6gdhPnQP9go1q
        eiy7Pdjo8yiKpf0Uy9k81H2CHwpQBJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-3PfeEznlOUi2AgTM_nG-EA-1; Mon, 15 Mar 2021 12:35:39 -0400
X-MC-Unique: 3PfeEznlOUi2AgTM_nG-EA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0B5C800C78;
        Mon, 15 Mar 2021 16:35:37 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-1.ams2.redhat.com [10.36.114.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 376F72C169;
        Mon, 15 Mar 2021 16:35:29 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v4 04/14] vringh: explain more about cleaning riov and wiov
Date:   Mon, 15 Mar 2021 17:34:40 +0100
Message-Id: <20210315163450.254396-5-sgarzare@redhat.com>
In-Reply-To: <20210315163450.254396-1-sgarzare@redhat.com>
References: <20210315163450.254396-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

riov and wiov can be reused with subsequent calls of vringh_getdesc_*().

Let's add a paragraph in the documentation of these functions to better
explain when riov and wiov need to be cleaned up.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vringh.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index bee63d68201a..2a88e087afd8 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -662,7 +662,10 @@ EXPORT_SYMBOL(vringh_init_user);
  * *head will be vrh->vring.num.  You may be able to ignore an invalid
  * descriptor, but there's not much you can do with an invalid ring.
  *
- * Note that you may need to clean up riov and wiov, even on error!
+ * Note that you can reuse riov and wiov with subsequent calls. Content is
+ * overwritten and memory reallocated if more space is needed.
+ * When you don't have to use riov and wiov anymore, you should clean up them
+ * calling vringh_iov_cleanup() to release the memory, even on error!
  */
 int vringh_getdesc_user(struct vringh *vrh,
 			struct vringh_iov *riov,
@@ -932,7 +935,10 @@ EXPORT_SYMBOL(vringh_init_kern);
  * *head will be vrh->vring.num.  You may be able to ignore an invalid
  * descriptor, but there's not much you can do with an invalid ring.
  *
- * Note that you may need to clean up riov and wiov, even on error!
+ * Note that you can reuse riov and wiov with subsequent calls. Content is
+ * overwritten and memory reallocated if more space is needed.
+ * When you don't have to use riov and wiov anymore, you should clean up them
+ * calling vringh_kiov_cleanup() to release the memory, even on error!
  */
 int vringh_getdesc_kern(struct vringh *vrh,
 			struct vringh_kiov *riov,
@@ -1292,7 +1298,10 @@ EXPORT_SYMBOL(vringh_set_iotlb);
  * *head will be vrh->vring.num.  You may be able to ignore an invalid
  * descriptor, but there's not much you can do with an invalid ring.
  *
- * Note that you may need to clean up riov and wiov, even on error!
+ * Note that you can reuse riov and wiov with subsequent calls. Content is
+ * overwritten and memory reallocated if more space is needed.
+ * When you don't have to use riov and wiov anymore, you should clean up them
+ * calling vringh_kiov_cleanup() to release the memory, even on error!
  */
 int vringh_getdesc_iotlb(struct vringh *vrh,
 			 struct vringh_kiov *riov,
-- 
2.30.2

