Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCFB3374B7
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 14:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhCKNxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 08:53:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233807AbhCKNxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 08:53:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615470788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fU0jQeEMLvNYK1r/S5O2kpHjVv1Rt/n95eYPSXJ6zNc=;
        b=Nbuf0tVK8E2IZkWLkoJ+ep8e5Wu+gc7294bPGqd4yii9k2QrBRpvaxtQXNogF2APHf/BH/
        EgxF1ZHtajvPuTTHxm11MLjb+7KtP/7mgiPceceABZRdfGuM0bxwqgK0oKOU1DO0d7/Y91
        gaZp8/24MdamOXkZ1vrLpDE4u52xS/s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-VpN4r4CWMkiQ9mULivpb2w-1; Thu, 11 Mar 2021 08:53:07 -0500
X-MC-Unique: VpN4r4CWMkiQ9mULivpb2w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1A3B83DBE2;
        Thu, 11 Mar 2021 13:53:05 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-146.ams2.redhat.com [10.36.113.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 213AF196E3;
        Thu, 11 Mar 2021 13:53:03 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 1/2] vhost-vdpa: fix use-after-free of v->config_ctx
Date:   Thu, 11 Mar 2021 14:52:56 +0100
Message-Id: <20210311135257.109460-2-sgarzare@redhat.com>
In-Reply-To: <20210311135257.109460-1-sgarzare@redhat.com>
References: <20210311135257.109460-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the 'v->config_ctx' eventfd_ctx reference is released we didn't
set it to NULL. So if the same character device (e.g. /dev/vhost-vdpa-0)
is re-opened, the 'v->config_ctx' is invalid and calling again
vhost_vdpa_config_put() causes use-after-free issues like the
following refcount_t underflow:

    refcount_t: underflow; use-after-free.
    WARNING: CPU: 2 PID: 872 at lib/refcount.c:28 refcount_warn_saturate+0xae/0xf0
    RIP: 0010:refcount_warn_saturate+0xae/0xf0
    Call Trace:
     eventfd_ctx_put+0x5b/0x70
     vhost_vdpa_release+0xcd/0x150 [vhost_vdpa]
     __fput+0x8e/0x240
     ____fput+0xe/0x10
     task_work_run+0x66/0xa0
     exit_to_user_mode_prepare+0x118/0x120
     syscall_exit_to_user_mode+0x21/0x50
     ? __x64_sys_close+0x12/0x40
     do_syscall_64+0x45/0x50
     entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 776f395004d8 ("vhost_vdpa: Support config interrupt in vdpa")
Cc: lingshan.zhu@intel.com
Cc: stable@vger.kernel.org
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ef688c8c0e0e..00796e4ecfdf 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -308,8 +308,10 @@ static long vhost_vdpa_get_vring_num(struct vhost_vdpa *v, u16 __user *argp)
 
 static void vhost_vdpa_config_put(struct vhost_vdpa *v)
 {
-	if (v->config_ctx)
+	if (v->config_ctx) {
 		eventfd_ctx_put(v->config_ctx);
+		v->config_ctx = NULL;
+	}
 }
 
 static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
-- 
2.29.2

