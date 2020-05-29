Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2141E77B8
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 10:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgE2ID4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 04:03:56 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21955 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726849AbgE2IDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 04:03:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590739430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8h+GPNLosU896j4lmpcz+nuuQdF3yl/18U4jyRqflms=;
        b=fr3xErG7Tzmq4P/f3wk2R+evGI4iC4KsDmDYD6wNstXcv4w/I6NZqR+6x8owItfE1oANsh
        gFQddZpqOIXEcMd5y3vMqcRWD009ssQquo78ejrUdpDs5aERqL0MrIbNTrKDWXc7DB2uqK
        t7ufXo10tWTzVn7KuAT9BRYjPc/9v5s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-t9xoE6D0NPuqiutyuhmQCg-1; Fri, 29 May 2020 04:03:49 -0400
X-MC-Unique: t9xoE6D0NPuqiutyuhmQCg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0A0780183C;
        Fri, 29 May 2020 08:03:46 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-231.pek2.redhat.com [10.72.13.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D8DBA1038;
        Fri, 29 May 2020 08:03:40 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
Subject: [PATCH 4/6] vhost_vdpa: support doorbell mapping via mmap
Date:   Fri, 29 May 2020 16:03:01 +0800
Message-Id: <20200529080303.15449-5-jasowang@redhat.com>
In-Reply-To: <20200529080303.15449-1-jasowang@redhat.com>
References: <20200529080303.15449-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the doorbell is relayed via eventfd which may have
significant overhead because of the cost of vmexits or syscall. This
patch introduces mmap() based doorbell mapping which can eliminate the
overhead caused by vmexit or syscall.

To ease the userspace modeling of the doorbell layout (usually
virtio-pci), this patch starts from a doorbell per page
model. Vhost-vdpa only support the hardware doorbell that sit at the
boundary of a page and does not share the page with other registers.

Doorbell of each virtqueue must be mapped separately, pgoff is the
index of the virtqueue. This allows userspace to map a subset of the
doorbell which may be useful for the implementation of software
assisted virtqueue (control vq) in the future.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 59 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 6ff72289f488..bbe23cea139a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/cdev.h>
 #include <linux/device.h>
+#include <linux/mm.h>
 #include <linux/iommu.h>
 #include <linux/uuid.h>
 #include <linux/vdpa.h>
@@ -741,12 +742,70 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	return 0;
 }
 
+static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
+{
+	struct vhost_vdpa *v = vmf->vma->vm_file->private_data;
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+	struct vdpa_notification_area notify;
+	struct vm_area_struct *vma = vmf->vma;
+	u16 index = vma->vm_pgoff;
+
+	notify = ops->get_vq_notification(vdpa, index);
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	if (remap_pfn_range(vma, vmf->address & PAGE_MASK,
+			    notify.addr >> PAGE_SHIFT, PAGE_SIZE,
+			    vma->vm_page_prot))
+		return VM_FAULT_SIGBUS;
+
+	return VM_FAULT_NOPAGE;
+}
+
+static const struct vm_operations_struct vhost_vdpa_vm_ops = {
+	.fault = vhost_vdpa_fault,
+};
+
+static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct vhost_vdpa *v = vma->vm_file->private_data;
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+	struct vdpa_notification_area notify;
+	int index = vma->vm_pgoff;
+
+	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
+		return -EINVAL;
+	if ((vma->vm_flags & VM_SHARED) == 0)
+		return -EINVAL;
+	if (vma->vm_flags & VM_READ)
+		return -EINVAL;
+	if (index > 65535)
+		return -EINVAL;
+	if (!ops->get_vq_notification)
+		return -ENOTSUPP;
+
+	/* To be safe and easily modelled by userspace, We only
+	 * support the doorbell which sits on the page boundary and
+	 * does not share the page with other registers.
+	 */
+	notify = ops->get_vq_notification(vdpa, index);
+	if (notify.addr & (PAGE_SIZE - 1))
+		return -EINVAL;
+	if (vma->vm_end - vma->vm_start != notify.size)
+		return -ENOTSUPP;
+
+	vma->vm_ops = &vhost_vdpa_vm_ops;
+	return 0;
+}
+
 static const struct file_operations vhost_vdpa_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vhost_vdpa_open,
 	.release	= vhost_vdpa_release,
 	.write_iter	= vhost_vdpa_chr_write_iter,
 	.unlocked_ioctl	= vhost_vdpa_unlocked_ioctl,
+	.mmap		= vhost_vdpa_mmap,
 	.compat_ioctl	= compat_ptr_ioctl,
 };
 
-- 
2.20.1

