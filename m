Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7B452D61D
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239791AbiESOb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239788AbiESObz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:31:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97BA0719C0
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 07:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652970713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4592P8caqsLbBXSwqCd7azgHUUtDxpfkl8BDz2lklMc=;
        b=Ky86F/CF9/E+GSU6MkzUqYxGTIjaUCT1OzIXiavjrKeTtk0Dota1K4VZYoSRXBtCmE3IT0
        TNtCP8P6zZvcnVDvX1DXYYjcJ4hUygftET8StmR+bF55cgRpyPvLKZZ3IVUFmmvjP3Kq1G
        KIpvflid2jbEF8oONEcE5cz+cdwXUZ4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-kWuMFNf6PRaLvIr2OjGyig-1; Thu, 19 May 2022 10:31:50 -0400
X-MC-Unique: kWuMFNf6PRaLvIr2OjGyig-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 101D080088A;
        Thu, 19 May 2022 14:31:50 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D855040CF8ED;
        Thu, 19 May 2022 14:31:47 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        gdawar@xilinx.com, lingshan.zhu@intel.com, kvm@vger.kernel.org,
        lulu@redhat.com, netdev@vger.kernel.org, lvivier@redhat.com,
        eli@mellanox.com, virtualization@lists.linux-foundation.org,
        parav@nvidia.com
Subject: [PATCH] vdpasim: allow to enable a vq repeatedly
Date:   Thu, 19 May 2022 16:31:45 +0200
Message-Id: <20220519143145.767845-1-eperezma@redhat.com>
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

Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
Cc: stable@vger.kernel.org
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index ddbe142af09a..b53cd00ad161 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -355,9 +355,10 @@ static void vdpasim_set_vq_ready(struct vdpa_device *vdpa, u16 idx, bool ready)
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
 
 	spin_lock(&vdpasim->lock);
-	vq->ready = ready;
-	if (vq->ready)
+	if (!vq->ready) {
+		vq->ready = ready;
 		vdpasim_queue_ready(vdpasim, idx);
+	}
 	spin_unlock(&vdpasim->lock);
 }
 
-- 
2.27.0

