Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D76276727
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgIXDZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:25:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726581AbgIXDZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9psWaDxNL/UvQAVMZCeYFOLQp2sEajeDUsbC1DgyKkE=;
        b=VIUYDTACei9KU2TWOFGL0OLXKBBozJgtZKb1RpmmzlhVu6yY9vB+/l9QRGoKTqS/qUbexk
        uOulg3sEt5cwywbz6TTCVECrgSyoz+HRmzfXXiW/HBgal0WMUAHl0HZBT7ZRVrPlwOYMcu
        MebMvl3dnnMJ7TJowQPaPd+nZfoUvLo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-oI5ymqXIOkOLEDooY4epbA-1; Wed, 23 Sep 2020 23:25:25 -0400
X-MC-Unique: oI5ymqXIOkOLEDooY4epbA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D26581008548;
        Thu, 24 Sep 2020 03:25:23 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3F663782;
        Thu, 24 Sep 2020 03:25:11 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 19/24] vdpa_sim: use separated iov for reading and writing
Date:   Thu, 24 Sep 2020 11:21:20 +0800
Message-Id: <20200924032125.18619-20-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support control virtqueue whose commands have both in and
out descriptors, we need to use separated iov for reading and writing
in vdpa_sim.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 5dc04ec271bb..d1764a64578d 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -40,7 +40,8 @@ MODULE_PARM_DESC(batch_mapping, "Batched mapping 1 -Enable; 0 - Disable");
 
 struct vdpasim_virtqueue {
 	struct vringh vring;
-	struct vringh_kiov iov;
+	struct vringh_kiov riov;
+	struct vringh_kiov wiov;
 	unsigned short head;
 	bool ready;
 	u64 desc_addr;
@@ -173,12 +174,12 @@ static void vdpasim_work(struct work_struct *work)
 
 	while (true) {
 		total_write = 0;
-		err = vringh_getdesc_iotlb(&txq->vring, &txq->iov, NULL,
+		err = vringh_getdesc_iotlb(&txq->vring, &txq->riov, NULL,
 					   &txq->head, GFP_ATOMIC);
 		if (err <= 0)
 			break;
 
-		err = vringh_getdesc_iotlb(&rxq->vring, NULL, &rxq->iov,
+		err = vringh_getdesc_iotlb(&rxq->vring, NULL, &rxq->wiov,
 					   &rxq->head, GFP_ATOMIC);
 		if (err <= 0) {
 			vringh_complete_iotlb(&txq->vring, txq->head, 0);
@@ -186,13 +187,13 @@ static void vdpasim_work(struct work_struct *work)
 		}
 
 		while (true) {
-			read = vringh_iov_pull_iotlb(&txq->vring, &txq->iov,
+			read = vringh_iov_pull_iotlb(&txq->vring, &txq->riov,
 						     vdpasim->buffer,
 						     PAGE_SIZE);
 			if (read <= 0)
 				break;
 
-			write = vringh_iov_push_iotlb(&rxq->vring, &rxq->iov,
+			write = vringh_iov_push_iotlb(&rxq->vring, &rxq->wiov,
 						      vdpasim->buffer, read);
 			if (write <= 0)
 				break;
-- 
2.20.1

