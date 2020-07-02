Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD38211E96
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgGBIZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:25:03 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59580 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728529AbgGBIX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:23:27 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628NGhc082008;
        Thu, 2 Jul 2020 03:23:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678196;
        bh=z96ye//Mg15JHZ1ndtZxlE33lV8uirQIl1DtUAPpCNk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=hKh4Ycc0nsKdDPMU7zvoAF1INSmeh72IPvQS5QOFMq4Kc9z2De6UHyUGJQsMmlqry
         DYgZNo1XEM+w2AaJimrzgI0NKEC9A5VRpDP9utmTyIV6VPFwKtQ/btpKPHG9wxz8/X
         /BiKQoNwEaAmwJLbq3/wJAlgDVSeBWOF5IKKiAxk=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0628NFj5066600
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jul 2020 03:23:15 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:23:15 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:23:15 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYR006145;
        Thu, 2 Jul 2020 03:23:10 -0500
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
Subject: [RFC PATCH 15/22] samples/rpmsg: Setup delayed work to send message
Date:   Thu, 2 Jul 2020 13:51:36 +0530
Message-ID: <20200702082143.25259-16-kishon@ti.com>
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

Let us not send any message to the remote processor before
announce_create() callback has been invoked. Since announce_create() is
only invoked after ->probe() is completed, setup delayed work to start
sending message to the remote processor.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 samples/rpmsg/rpmsg_client_sample.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/samples/rpmsg/rpmsg_client_sample.c b/samples/rpmsg/rpmsg_client_sample.c
index ae5081662283..514a51945d69 100644
--- a/samples/rpmsg/rpmsg_client_sample.c
+++ b/samples/rpmsg/rpmsg_client_sample.c
@@ -20,6 +20,8 @@ module_param(count, int, 0644);
 
 struct instance_data {
 	int rx_count;
+	struct delayed_work send_msg_work;
+	struct rpmsg_device *rpdev;
 };
 
 static int rpmsg_sample_cb(struct rpmsg_device *rpdev, void *data, int len,
@@ -48,9 +50,21 @@ static int rpmsg_sample_cb(struct rpmsg_device *rpdev, void *data, int len,
 	return 0;
 }
 
-static int rpmsg_sample_probe(struct rpmsg_device *rpdev)
+static void rpmsg_sample_send_msg_work(struct work_struct *work)
 {
+	struct instance_data *idata = container_of(work, struct instance_data,
+						   send_msg_work.work);
+	struct rpmsg_device *rpdev = idata->rpdev;
 	int ret;
+
+	/* send a message to our remote processor */
+	ret = rpmsg_send(rpdev->ept, MSG, strlen(MSG));
+	if (ret)
+		dev_err(&rpdev->dev, "rpmsg_send failed: %d\n", ret);
+}
+
+static int rpmsg_sample_probe(struct rpmsg_device *rpdev)
+{
 	struct instance_data *idata;
 
 	dev_info(&rpdev->dev, "new channel: 0x%x -> 0x%x!\n",
@@ -62,18 +76,18 @@ static int rpmsg_sample_probe(struct rpmsg_device *rpdev)
 
 	dev_set_drvdata(&rpdev->dev, idata);
 
-	/* send a message to our remote processor */
-	ret = rpmsg_send(rpdev->ept, MSG, strlen(MSG));
-	if (ret) {
-		dev_err(&rpdev->dev, "rpmsg_send failed: %d\n", ret);
-		return ret;
-	}
+	idata->rpdev = rpdev;
+	INIT_DELAYED_WORK(&idata->send_msg_work, rpmsg_sample_send_msg_work);
+	schedule_delayed_work(&idata->send_msg_work, msecs_to_jiffies(500));
 
 	return 0;
 }
 
 static void rpmsg_sample_remove(struct rpmsg_device *rpdev)
 {
+	struct instance_data *idata = dev_get_drvdata(&rpdev->dev);
+
+	cancel_delayed_work_sync(&idata->send_msg_work);
 	dev_info(&rpdev->dev, "rpmsg sample client driver is removed\n");
 }
 
-- 
2.17.1

