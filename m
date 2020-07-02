Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C013211E37
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgGBIXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:23:02 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:53902 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbgGBIW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:22:59 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628Mld5086485;
        Thu, 2 Jul 2020 03:22:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678167;
        bh=Am7wFkFFAaUQImlGyftO9CDeQuGJEcsN8HZMuWnBRcM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=jsOM0ruAXjlbAIoaWqeHn0vYI7vPtnQO8ZZCByx9EXiaxrRsrj8HzV2HMQUjKnmmV
         9H/U5Z+caJrgOy2eZ+FUlCVoqCEAq6vW1qJoV7Qp4AIv9DJK4fPfBU2D4kVCtrbpRf
         TH1Sk9aAPIkJNMMRQfOI0SHfv7DweInWkfkeUi2s=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0628MlJN031070
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jul 2020 03:22:47 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:22:47 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:22:47 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYM006145;
        Thu, 2 Jul 2020 03:22:41 -0500
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
Subject: [RFC PATCH 10/22] rpmsg: virtio_rpmsg_bus: Add Address Service Notification support
Date:   Thu, 2 Jul 2020 13:51:31 +0530
Message-ID: <20200702082143.25259-11-kishon@ti.com>
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

Add support to send address service notification message to the backend
rpmsg device. This informs the backend rpmsg device about the address
allocated to the channel that is created in response to the name service
announce message from backend rpmsg device. This is in preparation to
add backend rpmsg device using VHOST framework in Linux.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 92 +++++++++++++++++++++++++++++---
 1 file changed, 85 insertions(+), 7 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 2d0d42084ac0..19d930c9fc2c 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -71,6 +71,7 @@ struct virtproc_info {
 
 /* The feature bitmap for virtio rpmsg */
 #define VIRTIO_RPMSG_F_NS	0 /* RP supports name service notifications */
+#define VIRTIO_RPMSG_F_AS	1 /* RP supports address service notifications */
 
 /**
  * struct rpmsg_hdr - common header for all rpmsg messages
@@ -110,6 +111,26 @@ struct rpmsg_ns_msg {
 	u32 flags;
 } __packed;
 
+/**
+ * struct rpmsg_as_msg - dynamic address service announcement message
+ * @name: name of the created channel
+ * @dst: destination address to be used by the backend rpdev
+ * @src: source address of the backend rpdev (the one that sent name service
+ * announcement message)
+ * @flags: indicates whether service is created or destroyed
+ *
+ * This message is sent (by virtio_rpmsg_bus) when a new channel is created
+ * in response to name service announcement message by backend rpdev to create
+ * a new channel. This sends the allocated source address for the channel
+ * (destination address for the backend rpdev) to the backend rpdev.
+ */
+struct rpmsg_as_msg {
+	char name[RPMSG_NAME_SIZE];
+	u32 dst;
+	u32 src;
+	u32 flags;
+} __packed;
+
 /**
  * enum rpmsg_ns_flags - dynamic name service announcement flags
  *
@@ -119,6 +140,19 @@ struct rpmsg_ns_msg {
 enum rpmsg_ns_flags {
 	RPMSG_NS_CREATE		= 0,
 	RPMSG_NS_DESTROY	= 1,
+	RPMSG_AS_ANNOUNCE	= 2,
+};
+
+/**
+ * enum rpmsg_as_flags - dynamic address service announcement flags
+ *
+ * @RPMSG_AS_ASSIGN: address has been assigned to the newly created channel
+ * @RPMSG_AS_FREE: assigned address is freed from the channel and no longer can
+ * be used
+ */
+enum rpmsg_as_flags {
+	RPMSG_AS_ASSIGN		= 1,
+	RPMSG_AS_FREE		= 2,
 };
 
 /**
@@ -164,6 +198,9 @@ struct virtio_rpmsg_channel {
 /* Address 53 is reserved for advertising remote services */
 #define RPMSG_NS_ADDR			(53)
 
+/* Address 54 is reserved for advertising address services */
+#define RPMSG_AS_ADDR			(54)
+
 static void virtio_rpmsg_destroy_ept(struct rpmsg_endpoint *ept);
 static int virtio_rpmsg_send(struct rpmsg_endpoint *ept, void *data, int len);
 static int virtio_rpmsg_sendto(struct rpmsg_endpoint *ept, void *data, int len,
@@ -329,9 +366,11 @@ static int virtio_rpmsg_announce_create(struct rpmsg_device *rpdev)
 	struct device *dev = &rpdev->dev;
 	int err = 0;
 
+	if (!rpdev->ept || !rpdev->announce)
+		return err;
+
 	/* need to tell remote processor's name service about this channel ? */
-	if (rpdev->announce && rpdev->ept &&
-	    virtio_has_feature(vrp->vdev, VIRTIO_RPMSG_F_NS)) {
+	if (virtio_has_feature(vrp->vdev, VIRTIO_RPMSG_F_NS)) {
 		struct rpmsg_ns_msg nsm;
 
 		strncpy(nsm.name, rpdev->id.name, RPMSG_NAME_SIZE);
@@ -343,6 +382,23 @@ static int virtio_rpmsg_announce_create(struct rpmsg_device *rpdev)
 			dev_err(dev, "failed to announce service %d\n", err);
 	}
 
+	/*
+	 * need to tell remote processor's address service about the address allocated
+	 * to this channel
+	 */
+	if (virtio_has_feature(vrp->vdev, VIRTIO_RPMSG_F_AS)) {
+		struct rpmsg_as_msg asmsg;
+
+		strncpy(asmsg.name, rpdev->id.name, RPMSG_NAME_SIZE);
+		asmsg.dst = rpdev->src;
+		asmsg.src = rpdev->dst;
+		asmsg.flags = RPMSG_AS_ASSIGN;
+
+		err = rpmsg_sendto(rpdev->ept, &asmsg, sizeof(asmsg), RPMSG_AS_ADDR);
+		if (err)
+			dev_err(dev, "failed to announce service %d\n", err);
+	}
+
 	return err;
 }
 
@@ -353,9 +409,28 @@ static int virtio_rpmsg_announce_destroy(struct rpmsg_device *rpdev)
 	struct device *dev = &rpdev->dev;
 	int err = 0;
 
+	if (!rpdev->ept || !rpdev->announce)
+		return err;
+
+	/*
+	 * need to tell remote processor's address service that we're freeing
+	 * the address allocated to this channel
+	 */
+	if (virtio_has_feature(vrp->vdev, VIRTIO_RPMSG_F_AS)) {
+		struct rpmsg_as_msg asmsg;
+
+		strncpy(asmsg.name, rpdev->id.name, RPMSG_NAME_SIZE);
+		asmsg.dst = rpdev->src;
+		asmsg.src = rpdev->dst;
+		asmsg.flags = RPMSG_AS_FREE;
+
+		err = rpmsg_sendto(rpdev->ept, &asmsg, sizeof(asmsg), RPMSG_AS_ADDR);
+		if (err)
+			dev_err(dev, "failed to announce service %d\n", err);
+	}
+
 	/* tell remote processor's name service we're removing this channel */
-	if (rpdev->announce && rpdev->ept &&
-	    virtio_has_feature(vrp->vdev, VIRTIO_RPMSG_F_NS)) {
+	if (virtio_has_feature(vrp->vdev, VIRTIO_RPMSG_F_NS)) {
 		struct rpmsg_ns_msg nsm;
 
 		strncpy(nsm.name, rpdev->id.name, RPMSG_NAME_SIZE);
@@ -390,7 +465,8 @@ static void virtio_rpmsg_release_device(struct device *dev)
  * channels.
  */
 static struct rpmsg_device *rpmsg_create_channel(struct virtproc_info *vrp,
-						 struct rpmsg_channel_info *chinfo)
+						 struct rpmsg_channel_info *chinfo,
+						 bool announce)
 {
 	struct virtio_rpmsg_channel *vch;
 	struct rpmsg_device *rpdev;
@@ -424,7 +500,8 @@ static struct rpmsg_device *rpmsg_create_channel(struct virtproc_info *vrp,
 	 * rpmsg server channels has predefined local address (for now),
 	 * and their existence needs to be announced remotely
 	 */
-	rpdev->announce = rpdev->src != RPMSG_ADDR_ANY;
+	if (rpdev->src != RPMSG_ADDR_ANY || announce)
+		rpdev->announce = true;
 
 	strncpy(rpdev->id.name, chinfo->name, RPMSG_NAME_SIZE);
 
@@ -873,7 +950,7 @@ static int rpmsg_ns_cb(struct rpmsg_device *rpdev, void *data, int len,
 		if (ret)
 			dev_err(dev, "rpmsg_destroy_channel failed: %d\n", ret);
 	} else {
-		newch = rpmsg_create_channel(vrp, &chinfo);
+		newch = rpmsg_create_channel(vrp, &chinfo, msg->flags & RPMSG_AS_ANNOUNCE);
 		if (!newch)
 			dev_err(dev, "rpmsg_create_channel failed\n");
 	}
@@ -1042,6 +1119,7 @@ static struct virtio_device_id id_table[] = {
 
 static unsigned int features[] = {
 	VIRTIO_RPMSG_F_NS,
+	VIRTIO_RPMSG_F_AS,
 };
 
 static struct virtio_driver virtio_ipc_driver = {
-- 
2.17.1

