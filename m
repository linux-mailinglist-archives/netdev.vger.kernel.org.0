Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1D127D3AF
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 18:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbgI2Qa6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 29 Sep 2020 12:30:58 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:59582 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728392AbgI2Qa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 12:30:58 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-I2UtjzlUPB67qVbSA7NVdQ-1; Tue, 29 Sep 2020 12:30:51 -0400
X-MC-Unique: I2UtjzlUPB67qVbSA7NVdQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 446DD188C127;
        Tue, 29 Sep 2020 16:30:50 +0000 (UTC)
Received: from bahia.lan (ovpn-113-41.ams2.redhat.com [10.36.113.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D4125D9CA;
        Tue, 29 Sep 2020 16:30:45 +0000 (UTC)
Subject: [PATCH v2 2/2] vhost: Don't call log_access_ok() when using IOTLB
From:   Greg Kurz <groug@kaod.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, qemu-devel@nongnu.org,
        Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
Date:   Tue, 29 Sep 2020 18:30:44 +0200
Message-ID: <160139704424.162128.7839027287942194310.stgit@bahia.lan>
In-Reply-To: <160139701999.162128.2399875915342200263.stgit@bahia.lan>
References: <160139701999.162128.2399875915342200263.stgit@bahia.lan>
User-Agent: StGit/0.21
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=groug@kaod.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the IOTLB device is enabled, the log_guest_addr that is passed by
userspace to the VHOST_SET_VRING_ADDR ioctl, and which is then written
to vq->log_addr, is a GIOVA. All writes to this address are translated
by log_user() to writes to an HVA, and then ultimately logged through
the corresponding GPAs in log_write_hva(). No logging will ever occur
with vq->log_addr in this case. It is thus wrong to pass vq->log_addr
and log_guest_addr to log_access_vq() which assumes they are actual
GPAs.

Introduce a new vq_log_used_access_ok() helper that only checks accesses
to the log for the used structure when there isn't an IOTLB device around.

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 drivers/vhost/vhost.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c3b49975dc28..5996e32fa818 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1370,6 +1370,20 @@ bool vhost_log_access_ok(struct vhost_dev *dev)
 }
 EXPORT_SYMBOL_GPL(vhost_log_access_ok);
 
+static bool vq_log_used_access_ok(struct vhost_virtqueue *vq,
+				  void __user *log_base,
+				  bool log_used,
+				  u64 log_addr,
+				  size_t log_size)
+{
+	/* If an IOTLB device is present, log_addr is a GIOVA that
+	 * will never be logged by log_used(). */
+	if (vq->iotlb)
+		return true;
+
+	return !log_used || log_access_ok(log_base, log_addr, log_size);
+}
+
 /* Verify access for write logging. */
 /* Caller should have vq mutex and device mutex */
 static bool vq_log_access_ok(struct vhost_virtqueue *vq,
@@ -1377,8 +1391,8 @@ static bool vq_log_access_ok(struct vhost_virtqueue *vq,
 {
 	return vq_memory_access_ok(log_base, vq->umem,
 				   vhost_has_feature(vq, VHOST_F_LOG_ALL)) &&
-		(!vq->log_used || log_access_ok(log_base, vq->log_addr,
-				  vhost_get_used_size(vq, vq->num)));
+		vq_log_used_access_ok(vq, log_base, vq->log_used, vq->log_addr,
+				      vhost_get_used_size(vq, vq->num));
 }
 
 /* Can we start vq? */
@@ -1517,8 +1531,9 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
 			return -EINVAL;
 
 		/* Also validate log access for used ring if enabled. */
-		if ((a.flags & (0x1 << VHOST_VRING_F_LOG)) &&
-			!log_access_ok(vq->log_base, a.log_guest_addr,
+		if (!vq_log_used_access_ok(vq, vq->log_base,
+				a.flags & (0x1 << VHOST_VRING_F_LOG),
+				a.log_guest_addr,
 				sizeof *vq->used +
 				vq->num * sizeof *vq->used->ring))
 			return -EINVAL;


