Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AF61E1AB9
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 07:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgEZFf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 01:35:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:20009 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgEZFf4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 01:35:56 -0400
IronPort-SDR: 75n97el5uGZTIObyAj1H5ptVwaYdYcv8hOXWx2zz6NKYERpz+GSPgwrYW63A4YoJut68MC1SQg
 SMwqrYADHwTA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2020 22:35:56 -0700
IronPort-SDR: 8GuUvj2YEZwOCH+zeBzQGzidx1tkcc1NTDlrvncBzRNXwbmzFfOQ4wMAbrOH0d3XjFBsPvnH75
 aWpwPrG8sZfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,436,1583222400"; 
   d="scan'208";a="256368416"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.54])
  by fmsmga008.fm.intel.com with ESMTP; 25 May 2020 22:35:53 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH] vdpa: bypass waking up vhost_woker for vdpa vq kick
Date:   Tue, 26 May 2020 13:32:25 +0800
Message-Id: <1590471145-4436-1-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Standard vhost devices rely on waking up a vhost_worker to kick
a virtquque. However vdpa devices have hardware backends, so it
does not need this waking up routin. In this commit, vdpa device
will kick a virtqueue directly, reduce the performance overhead
caused by waking up a vhost_woker.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 0968361..d3a2aca 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -287,6 +287,66 @@ static long vhost_vdpa_get_vring_num(struct vhost_vdpa *v, u16 __user *argp)
 
 	return 0;
 }
+void vhost_vdpa_poll_stop(struct vhost_virtqueue *vq)
+{
+	vhost_poll_stop(&vq->poll);
+}
+
+int vhost_vdpa_poll_start(struct vhost_virtqueue *vq)
+{
+	struct vhost_poll *poll = &vq->poll;
+	struct file *file = vq->kick;
+	__poll_t mask;
+
+
+	if (poll->wqh)
+		return 0;
+
+	mask = vfs_poll(file, &poll->table);
+	if (mask)
+		vq->handle_kick(&vq->poll.work);
+	if (mask & EPOLLERR) {
+		vhost_poll_stop(poll);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static long vhost_vdpa_set_vring_kick(struct vhost_virtqueue *vq,
+				      void __user *argp)
+{
+	bool pollstart = false, pollstop = false;
+	struct file *eventfp, *filep = NULL;
+	struct vhost_vring_file f;
+	long r;
+
+	if (copy_from_user(&f, argp, sizeof(f)))
+		return -EFAULT;
+
+	eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
+	if (IS_ERR(eventfp)) {
+		r = PTR_ERR(eventfp);
+		return r;
+	}
+
+	if (eventfp != vq->kick) {
+		pollstop = (filep = vq->kick) != NULL;
+		pollstart = (vq->kick = eventfp) != NULL;
+	} else
+		filep = eventfp;
+
+	if (pollstop && vq->handle_kick)
+		vhost_vdpa_poll_stop(vq);
+
+	if (filep)
+		fput(filep);
+
+	if (pollstart && vq->handle_kick)
+		r = vhost_vdpa_poll_start(vq);
+
+	return r;
+}
 
 static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 				   void __user *argp)
@@ -316,6 +376,11 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		return 0;
 	}
 
+	if (cmd == VHOST_SET_VRING_KICK) {
+		r = vhost_vdpa_set_vring_kick(vq, argp);
+		return r;
+	}
+
 	if (cmd == VHOST_GET_VRING_BASE)
 		vq->last_avail_idx = ops->get_vq_state(v->vdpa, idx);
 
@@ -667,6 +732,39 @@ static void vhost_vdpa_free_domain(struct vhost_vdpa *v)
 	v->domain = NULL;
 }
 
+static int vhost_vdpa_poll_worker(wait_queue_entry_t *wait, unsigned int mode,
+				  int sync, void *key)
+{
+	struct vhost_poll *poll = container_of(wait, struct vhost_poll, wait);
+	struct vhost_virtqueue *vq = container_of(poll, struct vhost_virtqueue,
+						  poll);
+
+	if (!(key_to_poll(key) & poll->mask))
+		return 0;
+
+	vq->handle_kick(&vq->poll.work);
+
+	return 0;
+}
+
+void vhost_vdpa_poll_init(struct vhost_dev *dev)
+{
+	struct vhost_virtqueue *vq;
+	struct vhost_poll *poll;
+	int i;
+
+	for (i = 0; i < dev->nvqs; i++) {
+		vq = dev->vqs[i];
+		poll = &vq->poll;
+		if (vq->handle_kick) {
+			init_waitqueue_func_entry(&poll->wait,
+						  vhost_vdpa_poll_worker);
+			poll->work.fn = vq->handle_kick;
+		}
+
+	}
+}
+
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 {
 	struct vhost_vdpa *v;
@@ -697,6 +795,8 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0,
 		       vhost_vdpa_process_iotlb_msg);
 
+	vhost_vdpa_poll_init(dev);
+
 	dev->iotlb = vhost_iotlb_alloc(0, 0);
 	if (!dev->iotlb) {
 		r = -ENOMEM;
-- 
1.8.3.1

