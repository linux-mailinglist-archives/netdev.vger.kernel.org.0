Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4932932A39F
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382304AbhCBJY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 04:24:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1837952AbhCBJQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 04:16:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614676473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=WYVZDzb7gHIYm3imGALkt41Cwtj1qA0Mv6difRe4t9U=;
        b=XhLeTgA7vUhVdWKHRbs0IY5gswglJJ9S12a80c+L1YASfHS3xKcs++1c2dvUxg85JTxXlJ
        LgDLoVlC+wC7LVehcRh70cRkS0TVmTIzMMl/2Px7n7WXZRNgqrN5WT7rDVATU/lKT7wlWn
        9ltO9UqBzuJYhYnB8C1PG9dRx6W/hVM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-mQrM1frOMlG3b2oYMD35iA-1; Tue, 02 Mar 2021 04:14:31 -0500
X-MC-Unique: mQrM1frOMlG3b2oYMD35iA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EB3D1005501;
        Tue,  2 Mar 2021 09:14:30 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2383D10016FA;
        Tue,  2 Mar 2021 09:14:20 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vhost-vdpa: honor CAP_IPC_LOCK
Date:   Tue,  2 Mar 2021 04:14:18 -0500
Message-Id: <20210302091418.7226-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CAP_IPC_LOCK is set we should not check locked memory against
rlimit as what has been implemented in mlock().

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ef688c8c0e0e..e93572e2e344 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -638,7 +638,8 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 	mmap_read_lock(dev->mm);
 
 	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-	if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
+	if (!capable(CAP_IPC_LOCK) &&
+	    (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit)) {
 		ret = -ENOMEM;
 		goto unlock;
 	}
-- 
2.18.1

