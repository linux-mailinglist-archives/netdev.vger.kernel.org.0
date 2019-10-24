Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D182E2937
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 05:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406729AbfJXD5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 23:57:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29530 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406689AbfJXD5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 23:57:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571889450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IZ65iw36f6SbPMgVjFDkBT75rtV4HHm0X8KMpBrB9ZU=;
        b=cqA8xzS5j82Xuykb5++Sqwr81Bm3Ioe1cXR479wTiSci9BGmZxxoQ+pVssmzN0TLZFGyMT
        zfTeefeKkoz8GZQ5v8zaSwISu2b8Ksz6mAf0XIvR/2n9AfdmzowqNxXrL4bdhlhrUaGGbS
        6ax4iRdnGIeqs7eCD+fT73OkH17vPVA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-v8dqu3FQOUWtVHUfozJ8CQ-1; Wed, 23 Oct 2019 23:57:27 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B29F80183D;
        Thu, 24 Oct 2019 03:57:26 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-199.pek2.redhat.com [10.72.12.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA82B60BF1;
        Thu, 24 Oct 2019 03:57:20 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] vringh: fix copy direction of vringh_iov_push_kern()
Date:   Thu, 24 Oct 2019 11:57:18 +0800
Message-Id: <20191024035718.7690-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: v8dqu3FQOUWtVHUfozJ8CQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to copy from iov to buf, so the direction was wrong.

Note: no real user for the helper, but it will be used by future
features.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vringh.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 08ad0d1f0476..a0a2d74967ef 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -852,6 +852,12 @@ static inline int xfer_kern(void *src, void *dst, size=
_t len)
 =09return 0;
 }
=20
+static inline int kern_xfer(void *dst, void *src, size_t len)
+{
+=09memcpy(dst, src, len);
+=09return 0;
+}
+
 /**
  * vringh_init_kern - initialize a vringh for a kernelspace vring.
  * @vrh: the vringh to initialize.
@@ -958,7 +964,7 @@ EXPORT_SYMBOL(vringh_iov_pull_kern);
 ssize_t vringh_iov_push_kern(struct vringh_kiov *wiov,
 =09=09=09     const void *src, size_t len)
 {
-=09return vringh_iov_xfer(wiov, (void *)src, len, xfer_kern);
+=09return vringh_iov_xfer(wiov, (void *)src, len, kern_xfer);
 }
 EXPORT_SYMBOL(vringh_iov_push_kern);
=20
--=20
2.19.1

