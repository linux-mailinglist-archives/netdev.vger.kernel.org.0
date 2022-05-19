Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCB652D6B2
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240230AbiESPBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240305AbiESPAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:00:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E159EBA92
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 07:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652972367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vLDeLvmK1CDBbyiav0ZvmXrDMQAvb2K5oFXxMwO8ya4=;
        b=QzI3Yy62MBpnKqlvrrWiF9eQUa47thUydE5x5t0JkjnBdF8+cRxvcEL1nNEuWbZC02QFvK
        OoHBxJtRJ7upl7kLB8pmfQaDnds5vy4kXbTqZOLxPm3HGCkNpaAPBkGuAA+8Q869weqYDD
        Kh7A5ZE4PX6wBrJCRV5Q5RXq0vVbN/Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-Q7coxSBeOFSsVPOL9aBFtQ-1; Thu, 19 May 2022 10:59:24 -0400
X-MC-Unique: Q7coxSBeOFSsVPOL9aBFtQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F881294EDE4;
        Thu, 19 May 2022 14:59:23 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F566400E89E;
        Thu, 19 May 2022 14:59:21 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lvivier@redhat.com, netdev@vger.kernel.org, lulu@redhat.com,
        eli@mellanox.com, sgarzare@redhat.com, parav@nvidia.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        lingshan.zhu@intel.com, linux-kernel@vger.kernel.org,
        gdawar@xilinx.com
Subject: [PATCH v2] vdpasim: allow to enable a vq repeatedly
Date:   Thu, 19 May 2022 16:59:19 +0200
Message-Id: <20220519145919.772896-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Code must be resilient to enable a queue many times.

At the moment the queue is resetting so it's definitely not the expected
behavior.

v2: set vq->ready = 0 at disable.

Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
Cc: stable@vger.kernel.org
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index ddbe142af09a..881f9864c437 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -353,11 +353,14 @@ static void vdpasim_set_vq_ready(struct vdpa_device *vdpa, u16 idx, bool ready)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
+	bool old_ready;
 
 	spin_lock(&vdpasim->lock);
+	old_ready = vq->ready;
 	vq->ready = ready;
-	if (vq->ready)
+	if (vq->ready && !old_ready) {
 		vdpasim_queue_ready(vdpasim, idx);
+	}
 	spin_unlock(&vdpasim->lock);
 }
 
-- 
2.27.0

