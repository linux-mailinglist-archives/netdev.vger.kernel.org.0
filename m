Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DFC282378
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 12:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgJCKCW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 3 Oct 2020 06:02:22 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:27717 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725857AbgJCKCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 06:02:21 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-tgmJOLFBPUuJiiTYcs74xg-1; Sat, 03 Oct 2020 06:02:18 -0400
X-MC-Unique: tgmJOLFBPUuJiiTYcs74xg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5F43185A0C1;
        Sat,  3 Oct 2020 10:02:16 +0000 (UTC)
Received: from bahia.lan (ovpn-112-192.ams2.redhat.com [10.36.112.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C57B110013C4;
        Sat,  3 Oct 2020 10:02:14 +0000 (UTC)
Subject: [PATCH v3 3/3] vhost: Don't call log_access_ok() when using IOTLB
From:   Greg Kurz <groug@kaod.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
Date:   Sat, 03 Oct 2020 12:02:13 +0200
Message-ID: <160171933385.284610.10189082586063280867.stgit@bahia.lan>
In-Reply-To: <160171888144.284610.4628526949393013039.stgit@bahia.lan>
References: <160171888144.284610.4628526949393013039.stgit@bahia.lan>
User-Agent: StGit/0.21
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
 drivers/vhost/vhost.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9d2c225fb518..9ad45e1d27f0 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1370,6 +1370,20 @@ bool vhost_log_access_ok(struct vhost_dev *dev)
 }
 EXPORT_SYMBOL_GPL(vhost_log_access_ok);
 
+static bool vq_log_used_access_ok(struct vhost_virtqueue *vq,
+				  void __user *log_base,
+				  bool log_used,
+				  u64 log_addr)
+{
+	/* If an IOTLB device is present, log_addr is a GIOVA that
+	 * will never be logged by log_used(). */
+	if (vq->iotlb)
+		return true;
+
+	return !log_used || log_access_ok(log_base, log_addr,
+					  vhost_get_used_size(vq, vq->num));
+}
+
 /* Verify access for write logging. */
 /* Caller should have vq mutex and device mutex */
 static bool vq_log_access_ok(struct vhost_virtqueue *vq,
@@ -1377,8 +1391,7 @@ static bool vq_log_access_ok(struct vhost_virtqueue *vq,
 {
 	return vq_memory_access_ok(log_base, vq->umem,
 				   vhost_has_feature(vq, VHOST_F_LOG_ALL)) &&
-		(!vq->log_used || log_access_ok(log_base, vq->log_addr,
-				  vhost_get_used_size(vq, vq->num)));
+		vq_log_used_access_ok(vq, log_base, vq->log_used, vq->log_addr);
 }
 
 /* Can we start vq? */
@@ -1517,9 +1530,9 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
 			return -EINVAL;
 
 		/* Also validate log access for used ring if enabled. */
-		if ((a.flags & (0x1 << VHOST_VRING_F_LOG)) &&
-			!log_access_ok(vq->log_base, a.log_guest_addr,
-				       vhost_get_used_size(vq, vq->num)))
+		if (!vq_log_used_access_ok(vq, vq->log_base,
+				a.flags & (0x1 << VHOST_VRING_F_LOG),
+				a.log_guest_addr))
 			return -EINVAL;
 	}
 


