Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D462DBBAC
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgLPGwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:52:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726066AbgLPGwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 01:52:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608101437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lmW+qzjyrpcUCHGIYNKW9v3AEZF05ND8tfGAyuKFkSg=;
        b=hqAw9T/R334/+fbQuhUA0wZvTn4fXiYuhcSw8JwL5OPoJS1IjoKdhgfS4TQx3s1hUCiM1n
        /I4oiDUL3McHwkA9LFWBpEbTYFyV1D7/5tZsL086UgIV7Sx/0I7GeLP28NuZwIUVRb+NMZ
        Fe3fxMLHVH3gNighQ84DntgLScGIkQE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-QVkA_k6ENL6l0EbXi22l1w-1; Wed, 16 Dec 2020 01:50:35 -0500
X-MC-Unique: QVkA_k6ENL6l0EbXi22l1w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13DE459;
        Wed, 16 Dec 2020 06:50:34 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-210.pek2.redhat.com [10.72.12.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87A6610016FF;
        Wed, 16 Dec 2020 06:50:23 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
Subject: [PATCH 17/21] vdpa_sim: split vdpasim_virtqueue's iov field in out_iov and in_iov
Date:   Wed, 16 Dec 2020 14:48:14 +0800
Message-Id: <20201216064818.48239-18-jasowang@redhat.com>
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

vringh_getdesc_iotlb() manages 2 iovs for writable and readable
descriptors. This is very useful for the block device, where for
each request we have both types of descriptor.

Let's split the vdpasim_virtqueue's iov field in out_iov and
in_iov to use them with vringh_getdesc_iotlb().

We are using VIRTIO terminology for "out" (readable by the device)
and "in" (writable by the device) descriptors.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 140de45ffff2..fe4888dfb70f 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -44,7 +44,8 @@ MODULE_PARM_DESC(macaddr, "Ethernet MAC address");
 
 struct vdpasim_virtqueue {
 	struct vringh vring;
-	struct vringh_kiov iov;
+	struct vringh_kiov in_iov;
+	struct vringh_kiov out_iov;
 	unsigned short head;
 	bool ready;
 	u64 desc_addr;
@@ -178,12 +179,12 @@ static void vdpasim_work(struct work_struct *work)
 
 	while (true) {
 		total_write = 0;
-		err = vringh_getdesc_iotlb(&txq->vring, &txq->iov, NULL,
+		err = vringh_getdesc_iotlb(&txq->vring, &txq->out_iov, NULL,
 					   &txq->head, GFP_ATOMIC);
 		if (err <= 0)
 			break;
 
-		err = vringh_getdesc_iotlb(&rxq->vring, NULL, &rxq->iov,
+		err = vringh_getdesc_iotlb(&rxq->vring, NULL, &rxq->in_iov,
 					   &rxq->head, GFP_ATOMIC);
 		if (err <= 0) {
 			vringh_complete_iotlb(&txq->vring, txq->head, 0);
@@ -191,13 +192,13 @@ static void vdpasim_work(struct work_struct *work)
 		}
 
 		while (true) {
-			read = vringh_iov_pull_iotlb(&txq->vring, &txq->iov,
+			read = vringh_iov_pull_iotlb(&txq->vring, &txq->out_iov,
 						     vdpasim->buffer,
 						     PAGE_SIZE);
 			if (read <= 0)
 				break;
 
-			write = vringh_iov_push_iotlb(&rxq->vring, &rxq->iov,
+			write = vringh_iov_push_iotlb(&rxq->vring, &rxq->in_iov,
 						      vdpasim->buffer, read);
 			if (write <= 0)
 				break;
-- 
2.25.1

