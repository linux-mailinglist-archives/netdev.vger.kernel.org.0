Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A3D2DBBB6
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgLPGwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:52:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39219 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726212AbgLPGwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 01:52:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608101458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xl32/mo6T6OKk23f/V3h6Z3M7yIv1Tk47fxKQgFDkUg=;
        b=FFrgchgOv5rD0/UNyLwyVMoI0k/GG7SoGneIvg8Qed2kEcPIPD2hZJWrVL4Kch4O4Sn+tq
        Lx+CiLJGyOi+aMbBi5LHV02DGV6V+Xd6e78X9qtPcAA4tGAavZ7tJnzPpjdC+CFtahrgSU
        kQ+XONaANEFbj5VhyAW5AQbT9htlxYg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-PBlHIUTAMLezxYnT6GRv-A-1; Wed, 16 Dec 2020 01:50:55 -0500
X-MC-Unique: PBlHIUTAMLezxYnT6GRv-A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F16CE800D62;
        Wed, 16 Dec 2020 06:50:53 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-210.pek2.redhat.com [10.72.12.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C82BD10013C1;
        Wed, 16 Dec 2020 06:50:43 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
Subject: [PATCH 20/21] vdpa_sim: filter destination mac address
Date:   Wed, 16 Dec 2020 14:48:17 +0800
Message-Id: <20201216064818.48239-21-jasowang@redhat.com>
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements a simple unicast filter for vDPA simulator.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 49 ++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index e901177c6dfe..fe90a783bde4 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -175,6 +175,22 @@ static void vdpasim_complete(struct vdpasim_virtqueue *vq, size_t len)
 	local_bh_enable();
 }
 
+static bool receive_filter(struct vdpasim *vdpasim, size_t len)
+{
+	bool modern = vdpasim->features & (1ULL << VIRTIO_F_VERSION_1);
+	size_t hdr_len = modern ? sizeof(struct virtio_net_hdr_v1) :
+				  sizeof(struct virtio_net_hdr);
+
+	if (len < ETH_ALEN + hdr_len)
+		return false;
+
+	if (!strncmp(vdpasim->buffer + hdr_len,
+		     vdpasim->config.mac, ETH_ALEN))
+		return true;
+
+	return false;
+}
+
 static void vdpasim_work(struct work_struct *work)
 {
 	struct vdpasim *vdpasim = container_of(work, struct
@@ -182,7 +198,6 @@ static void vdpasim_work(struct work_struct *work)
 	struct vdpasim_virtqueue *txq = &vdpasim->vqs[1];
 	struct vdpasim_virtqueue *rxq = &vdpasim->vqs[0];
 	ssize_t read, write;
-	size_t total_write;
 	int pkts = 0;
 	int err;
 
@@ -195,36 +210,34 @@ static void vdpasim_work(struct work_struct *work)
 		goto out;
 
 	while (true) {
-		total_write = 0;
 		err = vringh_getdesc_iotlb(&txq->vring, &txq->out_iov, NULL,
 					   &txq->head, GFP_ATOMIC);
 		if (err <= 0)
 			break;
 
+		read = vringh_iov_pull_iotlb(&txq->vring, &txq->out_iov,
+					     vdpasim->buffer,
+					     PAGE_SIZE);
+
+		if (!receive_filter(vdpasim, read)) {
+			vdpasim_complete(txq, 0);
+			continue;
+		}
+
 		err = vringh_getdesc_iotlb(&rxq->vring, NULL, &rxq->in_iov,
 					   &rxq->head, GFP_ATOMIC);
 		if (err <= 0) {
-			vringh_complete_iotlb(&txq->vring, txq->head, 0);
+			vdpasim_complete(txq, 0);
 			break;
 		}
 
-		while (true) {
-			read = vringh_iov_pull_iotlb(&txq->vring, &txq->out_iov,
-						     vdpasim->buffer,
-						     PAGE_SIZE);
-			if (read <= 0)
-				break;
-
-			write = vringh_iov_push_iotlb(&rxq->vring, &rxq->in_iov,
-						      vdpasim->buffer, read);
-			if (write <= 0)
-				break;
-
-			total_write += write;
-		}
+		write = vringh_iov_push_iotlb(&rxq->vring, &rxq->in_iov,
+					      vdpasim->buffer, read);
+		if (write <= 0)
+			break;
 
 		vdpasim_complete(txq, 0);
-		vdpasim_complete(rxq, total_write);
+		vdpasim_complete(rxq, write);
 
 		if (++pkts > 4) {
 			schedule_work(&vdpasim->work);
-- 
2.25.1

