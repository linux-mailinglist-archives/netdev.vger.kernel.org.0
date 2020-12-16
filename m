Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7B62DBBB4
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgLPGwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:52:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21519 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726188AbgLPGwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 01:52:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608101449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5FjubrHlP/6mleRaFOH0oCUrngCxQxLxf5JK/Qo5XpE=;
        b=fNwvB8eD/re4nsyjC9A1IHwgh8LayobdUPEQv3l3rKx14tP/tby+mi9oDvoJO/IMKiIa4M
        WYlAokfbTZRYA9ZbEGP1HTVU2ptcEKXsWuk6S92tykyu7xjS/Ol6UzZN7/NiUnxRQ/vfNJ
        T1Mo4E2BnlC0ANOzxxnHCidLGsaHyaA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-Cti1jdVrPPWnBXuG_DC3Ww-1; Wed, 16 Dec 2020 01:50:44 -0500
X-MC-Unique: Cti1jdVrPPWnBXuG_DC3Ww-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46343800D53;
        Wed, 16 Dec 2020 06:50:43 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-210.pek2.redhat.com [10.72.12.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B58210013C1;
        Wed, 16 Dec 2020 06:50:38 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
Subject: [PATCH 19/21] vdpa_sim: factor out buffer completion logic
Date:   Wed, 16 Dec 2020 14:48:16 +0800
Message-Id: <20201216064818.48239-20-jasowang@redhat.com>
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 33 +++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 8d051cf25f0a..e901177c6dfe 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -159,6 +159,22 @@ static void vdpasim_reset(struct vdpasim *vdpasim)
 	++vdpasim->generation;
 }
 
+static void vdpasim_complete(struct vdpasim_virtqueue *vq, size_t len)
+{
+	/* Make sure data is wrote before advancing index */
+	smp_wmb();
+
+	vringh_complete_iotlb(&vq->vring, vq->head, len);
+
+	/* Make sure used is visible before rasing the interrupt. */
+	smp_wmb();
+
+	local_bh_disable();
+	if (vq->cb)
+		vq->cb(vq->private);
+	local_bh_enable();
+}
+
 static void vdpasim_work(struct work_struct *work)
 {
 	struct vdpasim *vdpasim = container_of(work, struct
@@ -207,21 +223,8 @@ static void vdpasim_work(struct work_struct *work)
 			total_write += write;
 		}
 
-		/* Make sure data is wrote before advancing index */
-		smp_wmb();
-
-		vringh_complete_iotlb(&txq->vring, txq->head, 0);
-		vringh_complete_iotlb(&rxq->vring, rxq->head, total_write);
-
-		/* Make sure used is visible before rasing the interrupt. */
-		smp_wmb();
-
-		local_bh_disable();
-		if (txq->cb)
-			txq->cb(txq->private);
-		if (rxq->cb)
-			rxq->cb(rxq->private);
-		local_bh_enable();
+		vdpasim_complete(txq, 0);
+		vdpasim_complete(rxq, total_write);
 
 		if (++pkts > 4) {
 			schedule_work(&vdpasim->work);
-- 
2.25.1

