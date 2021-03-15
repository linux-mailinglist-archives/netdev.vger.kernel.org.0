Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701CE33C219
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbhCOQfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:35:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231206AbhCOQfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:35:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615826143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rAqe4QGyCpp3qkhZfpBh66Chsnfm4h8juLPuFY2EjWo=;
        b=OJm9OFMytm6+gkEiWax+4RJuznyv6M12eHd1f17sm2xlcrgydG5A49UkRFEksnlZIN2vFC
        sK94EjjDCRhKRzDvv29nBx1BhtVdJPlczBhC8QkVGan72SWTzBBmb+kkCVCeifR5LKZCHD
        W6bJshc9bUgufJxQ629eZYBXJGC7GFM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-4-uIdZmYPZaQEFISoNoU9g-1; Mon, 15 Mar 2021 12:35:41 -0400
X-MC-Unique: 4-uIdZmYPZaQEFISoNoU9g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D5EF801817;
        Mon, 15 Mar 2021 16:35:40 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-1.ams2.redhat.com [10.36.114.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F00CA2C169;
        Mon, 15 Mar 2021 16:35:37 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v4 05/14] vringh: implement vringh_kiov_advance()
Date:   Mon, 15 Mar 2021 17:34:41 +0100
Message-Id: <20210315163450.254396-6-sgarzare@redhat.com>
In-Reply-To: <20210315163450.254396-1-sgarzare@redhat.com>
References: <20210315163450.254396-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases, it may be useful to provide a way to skip a number
of bytes in a vringh_kiov.

Let's implement vringh_kiov_advance() for this purpose, reusing the
code from vringh_iov_xfer().
We replace that code calling the new vringh_kiov_advance().

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/linux/vringh.h |  2 ++
 drivers/vhost/vringh.c | 41 +++++++++++++++++++++++++++++------------
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 9c077863c8f6..755211ebd195 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -199,6 +199,8 @@ static inline void vringh_kiov_cleanup(struct vringh_kiov *kiov)
 	kiov->iov = NULL;
 }
 
+void vringh_kiov_advance(struct vringh_kiov *kiov, size_t len);
+
 int vringh_getdesc_kern(struct vringh *vrh,
 			struct vringh_kiov *riov,
 			struct vringh_kiov *wiov,
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 2a88e087afd8..4af8fa259d65 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -75,6 +75,34 @@ static inline int __vringh_get_head(const struct vringh *vrh,
 	return head;
 }
 
+/**
+ * vringh_kiov_advance - skip bytes from vring_kiov
+ * @iov: an iov passed to vringh_getdesc_*() (updated as we consume)
+ * @len: the maximum length to advance
+ */
+void vringh_kiov_advance(struct vringh_kiov *iov, size_t len)
+{
+	while (len && iov->i < iov->used) {
+		size_t partlen = min(iov->iov[iov->i].iov_len, len);
+
+		iov->consumed += partlen;
+		iov->iov[iov->i].iov_len -= partlen;
+		iov->iov[iov->i].iov_base += partlen;
+
+		if (!iov->iov[iov->i].iov_len) {
+			/* Fix up old iov element then increment. */
+			iov->iov[iov->i].iov_len = iov->consumed;
+			iov->iov[iov->i].iov_base -= iov->consumed;
+
+			iov->consumed = 0;
+			iov->i++;
+		}
+
+		len -= partlen;
+	}
+}
+EXPORT_SYMBOL(vringh_kiov_advance);
+
 /* Copy some bytes to/from the iovec.  Returns num copied. */
 static inline ssize_t vringh_iov_xfer(struct vringh *vrh,
 				      struct vringh_kiov *iov,
@@ -95,19 +123,8 @@ static inline ssize_t vringh_iov_xfer(struct vringh *vrh,
 		done += partlen;
 		len -= partlen;
 		ptr += partlen;
-		iov->consumed += partlen;
-		iov->iov[iov->i].iov_len -= partlen;
-		iov->iov[iov->i].iov_base += partlen;
 
-		if (!iov->iov[iov->i].iov_len) {
-			/* Fix up old iov element then increment. */
-			iov->iov[iov->i].iov_len = iov->consumed;
-			iov->iov[iov->i].iov_base -= iov->consumed;
-
-			
-			iov->consumed = 0;
-			iov->i++;
-		}
+		vringh_kiov_advance(iov, partlen);
 	}
 	return done;
 }
-- 
2.30.2

