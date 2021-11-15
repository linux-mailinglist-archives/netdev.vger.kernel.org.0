Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99328450886
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 16:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236526AbhKOPfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 10:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236666AbhKOPfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 10:35:01 -0500
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D3AC061746;
        Mon, 15 Nov 2021 07:31:59 -0800 (PST)
Received: from iva8-d2cd82b7433e.qloud-c.yandex.net (iva8-d2cd82b7433e.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:a88e:0:640:d2cd:82b7])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 9A26A2E049A;
        Mon, 15 Nov 2021 18:30:13 +0300 (MSK)
Received: from iva4-f06c35e68a0a.qloud-c.yandex.net (iva4-f06c35e68a0a.qloud-c.yandex.net [2a02:6b8:c0c:152e:0:640:f06c:35e6])
        by iva8-d2cd82b7433e.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id bKCL3mVXxu-UCsOeJ4e;
        Mon, 15 Nov 2021 18:30:13 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1636990213; bh=y85LOcf7Sy3LW0QLv/nBOK4FyN00usUrXuSvdKRDQVI=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=SY/dDjDIO6MLc+NLeSQhQhGlZplBdfaVWkCuxvFHxdEB0JoCQv0HhOf/HW905fXM/
         SoqBp4z6ofIBueIeDAm5/OLx14Zl2izVpTPrZs5al2+e8fcSnA+c9Tds/SZtiMpeUd
         XnAH1kRoCCgUJQzr0jgeQ0iElkWTd+wkNCHJpGGw=
Authentication-Results: iva8-d2cd82b7433e.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dellarbn.yandex.net (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by iva4-f06c35e68a0a.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id wuqDqjnGag-UCxadnS3;
        Mon, 15 Nov 2021 18:30:12 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Andrey Ryabinin <arbn@yandex-team.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Andrey Ryabinin <arbn@yandex-team.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] vhost_test: remove vhost_test_flush_vq()
Date:   Mon, 15 Nov 2021 18:30:00 +0300
Message-Id: <20211115153003.9140-3-arbn@yandex-team.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211115153003.9140-1-arbn@yandex-team.com>
References: <20211115153003.9140-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vhost_test_flush_vq() just a simple wrapper around vhost_work_dev_flush()
which seems have no value. It's just easier to call vhost_work_dev_flush()
directly. Besides there is no point in obtaining vhost_dev pointer
via 'n->vqs[index].poll.dev' while we can just use &n->dev.
It's the same pointers, see vhost_test_open()/vhost_dev_init().

Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 drivers/vhost/test.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 1a8ab1d8cb1c..d4f63068d762 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -144,14 +144,9 @@ static void vhost_test_stop(struct vhost_test *n, void **privatep)
 	*privatep = vhost_test_stop_vq(n, n->vqs + VHOST_TEST_VQ);
 }
 
-static void vhost_test_flush_vq(struct vhost_test *n, int index)
-{
-	vhost_work_dev_flush(n->vqs[index].poll.dev);
-}
-
 static void vhost_test_flush(struct vhost_test *n)
 {
-	vhost_test_flush_vq(n, VHOST_TEST_VQ);
+	vhost_work_dev_flush(&n->dev);
 }
 
 static int vhost_test_release(struct inode *inode, struct file *f)
@@ -209,7 +204,7 @@ static long vhost_test_run(struct vhost_test *n, int test)
 			goto err;
 
 		if (oldpriv) {
-			vhost_test_flush_vq(n, index);
+			vhost_test_flush(n, index);
 		}
 	}
 
@@ -302,7 +297,7 @@ static long vhost_test_set_backend(struct vhost_test *n, unsigned index, int fd)
 	mutex_unlock(&vq->mutex);
 
 	if (enable) {
-		vhost_test_flush_vq(n, index);
+		vhost_test_flush(n);
 	}
 
 	mutex_unlock(&n->dev.mutex);
-- 
2.32.0

