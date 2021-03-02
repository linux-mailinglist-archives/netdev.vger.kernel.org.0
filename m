Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0B032B376
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352619AbhCCD6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 22:58:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1446401AbhCBKxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 05:53:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614682329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=SzDKxvBAv6SXm+NUCcAJGjMwV47OKoU6w1l5j4zzOVo=;
        b=bFplR3L+WReDDuYfzMEkYBTxZ8sYubmlCXKDqQr5AudKtgRwwXZ+fo8j+ykFpWpsnC1xHk
        sFkCT4VquZ/JEidrinOtSNR2H0VFKqgFAGLjnfkpD3ABXUvv5xYyd2a8KrtK+FcvkupAnf
        evpNreVwGVJRotoJsXdc/5XlG+RytC8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-3gRwmn9WOriegQZm-MSt6g-1; Tue, 02 Mar 2021 05:52:08 -0500
X-MC-Unique: 3gRwmn9WOriegQZm-MSt6g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8C4B107ACF3;
        Tue,  2 Mar 2021 10:52:06 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C239E6F973;
        Tue,  2 Mar 2021 10:52:00 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2] vhost-vdpa: honor CAP_IPC_LOCK
Date:   Tue,  2 Mar 2021 05:51:58 -0500
Message-Id: <20210302105158.8240-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CAP_IPC_LOCK is set we should not check locked memory against
rlimit as what has been implemented in mlock() and documented in
Documentation/admin-guide/perf-security.rst:

"
RLIMIT_MEMLOCK and perf_event_mlock_kb resource constraints are ignored
for processes with the CAP_IPC_LOCK capability.
"

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
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

