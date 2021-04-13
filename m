Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974E435DAE5
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245583AbhDMJQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:16:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58525 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245536AbhDMJQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:16:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618305371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Nsxd662d4i8x3VCivCNK0fCVgM6UOW8+ULBoukCe2ZU=;
        b=bX57uKGsoIbTAUnt9uK/QnqGG/th/kKlJIi+n3aaKC9nI/QPUUmcE/RiMpBJaaMvQ1AIj4
        w1pBcL+FMBSd+g0rYrJi8r1SlwEMSd6wu7zXLlGrTUpf9ySeYovOCh78BtkVqBCnP1FxL0
        xL0+/mh9Ea68aHcIs+SVxu/9jdJ2vcw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-x88dCRRUMHWcrN8rL8uRAw-1; Tue, 13 Apr 2021 05:16:07 -0400
X-MC-Unique: x88dCRRUMHWcrN8rL8uRAw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD9BD107ACCA;
        Tue, 13 Apr 2021 09:16:05 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-128.pek2.redhat.com [10.72.13.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55CC360C04;
        Tue, 13 Apr 2021 09:15:59 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] vhost-vdpa: fix vm_flags for virtqueue doorbell mapping
Date:   Tue, 13 Apr 2021 17:15:57 +0800
Message-Id: <20210413091557.29008-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The virtqueue doorbell is usually implemented via registeres but we
don't provide the necessary vma->flags like VM_PFNMAP. This may cause
several issues e.g when userspace tries to map the doorbell via vhost
IOTLB, kernel may panic due to the page is not backed by page
structure. This patch fixes this by setting the necessary
vm_flags. With this patch, try to map doorbell via IOTLB will fail
with bad address.

Cc: stable@vger.kernel.org
Fixes: ddd89d0a059d ("vhost_vdpa: support doorbell mapping via mmap")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index e0a27e336293..865eab69cb71 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -989,6 +989,7 @@ static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
 	if (vma->vm_end - vma->vm_start != notify.size)
 		return -ENOTSUPP;
 
+	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &vhost_vdpa_vm_ops;
 	return 0;
 }
-- 
2.25.1

