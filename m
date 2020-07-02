Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A819211E9B
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgGBIZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:25:28 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59466 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbgGBIWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:22:51 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628Mawm081816;
        Thu, 2 Jul 2020 03:22:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678156;
        bh=xFcqYzNmQgKuE1+hIXHcn1dlvHlbBiHv2NFJRAR7N1Q=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=tsLOiQk2xuDiTEuvWhyS7fcI0xjQfuNmWsXd0mOnCnouBoFsnFY3s17NgErsbNi/4
         PFs2foICGoxb8mg8C12Te8IiISySv2tLVXECFDTbp1UJaw4ofcOKOg0FX5Q7lhU4ir
         lTvouUvV44mf/mPovGOaHW3TTMRHUq7Eli+vuyjE=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0628MaYH065363
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jul 2020 03:22:36 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:22:35 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:22:35 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYK006145;
        Thu, 2 Jul 2020 03:22:30 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <linux-ntb@googlegroups.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH 08/22] rpmsg: virtio_rpmsg_bus: Disable receive virtqueue callback when reading messages
Date:   Thu, 2 Jul 2020 13:51:29 +0530
Message-ID: <20200702082143.25259-9-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702082143.25259-1-kishon@ti.com>
References: <20200702082143.25259-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since rpmsg_recv_done() reads messages in a while loop, disable
callbacks until the while loop exits. This helps to get rid of the
annoying "uhm, incoming signal, but no used buffer ?" message.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 376ebbf880d6..2d0d42084ac0 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -777,6 +777,7 @@ static void rpmsg_recv_done(struct virtqueue *rvq)
 		return;
 	}
 
+	virtqueue_disable_cb(rvq);
 	while (msg) {
 		err = rpmsg_recv_single(vrp, dev, msg, len);
 		if (err)
@@ -786,6 +787,19 @@ static void rpmsg_recv_done(struct virtqueue *rvq)
 
 		msg = virtqueue_get_buf(rvq, &len);
 	}
+	virtqueue_enable_cb(rvq);
+
+	/*
+	 * Try to read message one more time in case a new message is submitted
+	 * after virtqueue_get_buf() inside the while loop but before enabling
+	 * callbacks
+	 */
+	msg = virtqueue_get_buf(rvq, &len);
+	if (msg) {
+		err = rpmsg_recv_single(vrp, dev, msg, len);
+		if (!err)
+			msgs_received++;
+	}
 
 	dev_dbg(dev, "Received %u messages\n", msgs_received);
 
-- 
2.17.1

