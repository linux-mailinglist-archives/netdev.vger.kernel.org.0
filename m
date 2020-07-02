Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB4D211E56
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgGBIXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:23:35 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59596 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbgGBIXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:23:30 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628NL3E082026;
        Thu, 2 Jul 2020 03:23:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678201;
        bh=ogem8OEd0B1KK4dvO1xOb9/ggBhFiU5Os5ncLUubhLU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=HEU/4DXsWuzYfdUEEOO77ST1979/soZJPDuJUCzGAvxmewNGEmE4zfLzI7ww5YTzZ
         m7doXWRZWlJkxYO0tciaPf451IzSjvAlvkTO+hMhshLQfX4smwzZ29wHGD0WEInyd/
         7/CTp/uz2fcR0iBA4D5Z1RVCP0l6gvjPWMmC/1+4=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0628NLlT067307
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jul 2020 03:23:21 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:23:20 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:23:21 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYS006145;
        Thu, 2 Jul 2020 03:23:15 -0500
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
Subject: [RFC PATCH 16/22] samples/rpmsg: Wait for address to be bound to rpdev for sending message
Date:   Thu, 2 Jul 2020 13:51:37 +0530
Message-ID: <20200702082143.25259-17-kishon@ti.com>
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

rpmsg_client_sample can use either virtio_rpmsg_bus or vhost_rpmsg_bus
to send messages. In the case of vhost_rpmsg_bus, the destination
address of rpdev will be assigned only after receiving address service
notification from the remote virtio_rpmsg_bus. Wait for address to be
bound to rpdev (rpmsg_client_sample running in vhost system) before
sending messages to the remote virtio_rpmsg_bus.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 samples/rpmsg/rpmsg_client_sample.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/samples/rpmsg/rpmsg_client_sample.c b/samples/rpmsg/rpmsg_client_sample.c
index 514a51945d69..07149d7fbd0c 100644
--- a/samples/rpmsg/rpmsg_client_sample.c
+++ b/samples/rpmsg/rpmsg_client_sample.c
@@ -57,10 +57,14 @@ static void rpmsg_sample_send_msg_work(struct work_struct *work)
 	struct rpmsg_device *rpdev = idata->rpdev;
 	int ret;
 
-	/* send a message to our remote processor */
-	ret = rpmsg_send(rpdev->ept, MSG, strlen(MSG));
-	if (ret)
-		dev_err(&rpdev->dev, "rpmsg_send failed: %d\n", ret);
+	if (rpdev->dst != RPMSG_ADDR_ANY) {
+		/* send a message to our remote processor */
+		ret = rpmsg_send(rpdev->ept, MSG, strlen(MSG));
+		if (ret)
+			dev_err(&rpdev->dev, "rpmsg_send failed: %d\n", ret);
+	} else {
+		schedule_delayed_work(&idata->send_msg_work, msecs_to_jiffies(50));
+	}
 }
 
 static int rpmsg_sample_probe(struct rpmsg_device *rpdev)
-- 
2.17.1

