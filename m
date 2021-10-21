Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D803E4361DB
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhJUMkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:40:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231232AbhJUMk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 08:40:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634819891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FxSLK+HAlyV2x9DBqilIGmaJn0wdCYP5yKFxkCOkl5Q=;
        b=N73q2BV7TEWAq43O/GhOHDRwWpGwd6BVDWHUhMV4nFXVzkczI4hhFQpl1e579t7q+qOpQx
        rKHZjFaUfp9cMUFB/KpIcD9SgsVBZD2nAp3rnKREchjkPd0EjDBxjBIlf55ETpIaNCwcKQ
        H8LSA0997/JVrNN7lQN0jdR8Ao/uSLk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-PNWplLLrOx2LDJXN3Fa1kg-1; Thu, 21 Oct 2021 08:38:08 -0400
X-MC-Unique: PNWplLLrOx2LDJXN3Fa1kg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FC848066EF;
        Thu, 21 Oct 2021 12:38:07 +0000 (UTC)
Received: from localhost (unknown [10.39.208.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2081B5B826;
        Thu, 21 Oct 2021 12:38:05 +0000 (UTC)
From:   =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH 08/10] vhost/vsock: save owner pid & creds
Date:   Thu, 21 Oct 2021 16:37:12 +0400
Message-Id: <20211021123714.1125384-9-marcandre.lureau@redhat.com>
In-Reply-To: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
References: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After VHOST_SET_OWNER success, save the owner process credentials.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 drivers/vhost/vsock.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 938aefbc75ec..3067436cddfc 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -58,6 +58,8 @@ struct vhost_vsock {
 
 	u32 guest_cid;
 	bool seqpacket_allow;
+	struct pid *owner_pid;
+	const struct cred *owner_cred;
 };
 
 static u32 vhost_transport_get_local_cid(void)
@@ -774,6 +776,10 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
 
 	vhost_dev_cleanup(&vsock->dev);
 	kfree(vsock->dev.vqs);
+
+	put_pid(vsock->owner_pid);
+	put_cred(vsock->owner_cred);
+
 	vhost_vsock_free(vsock);
 	return 0;
 }
@@ -851,6 +857,22 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
 	return -EFAULT;
 }
 
+static long vhost_vsock_set_owner(struct vhost_vsock *vsock)
+{
+	long r;
+
+	mutex_lock(&vsock->dev.mutex);
+	r = vhost_dev_set_owner(&vsock->dev);
+	if (r)
+		goto out;
+	vsock->owner_pid = get_pid(task_tgid(current));
+	vsock->owner_cred = get_current_cred();
+	vhost_vsock_flush(vsock);
+out:
+	mutex_unlock(&vsock->dev.mutex);
+	return r;
+}
+
 static long vhost_vsock_dev_ioctl(struct file *f, unsigned int ioctl,
 				  unsigned long arg)
 {
@@ -894,6 +916,8 @@ static long vhost_vsock_dev_ioctl(struct file *f, unsigned int ioctl,
 			return -EOPNOTSUPP;
 		vhost_set_backend_features(&vsock->dev, features);
 		return 0;
+	case VHOST_SET_OWNER:
+		return vhost_vsock_set_owner(vsock);
 	default:
 		mutex_lock(&vsock->dev.mutex);
 		r = vhost_dev_ioctl(&vsock->dev, ioctl, argp);
-- 
2.33.0.721.g106298f7f9

