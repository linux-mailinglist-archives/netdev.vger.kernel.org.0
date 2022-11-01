Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B349614EE8
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 17:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiKAQPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 12:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiKAQPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 12:15:09 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32401C90A;
        Tue,  1 Nov 2022 09:15:07 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A19HWwl004813;
        Tue, 1 Nov 2022 09:14:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=0Gt6OScKkAJ4U/OL6iMfKKs8CKXzCTIvCB0t+56mLSM=;
 b=AkYW4f78CTm8SDh3JOH8dlcv6QUXw3cdl6BGJGycifiJabXa1W4xRt6K9CGbi7WG3PUE
 6uvu1nKKwSWBPqkPkNZObgA3OrZmCH9YVdqaXYrewbxAM7UXMt/n+Y6aBKn3JfQhpCRu
 CFf++khc9CSC1EO87NfCaNT3iUbkG23eGxy+tQByIvmlngDItsRnVT05lkIGaUX3i7n1
 bbuzW+2VdXgL7q63xlqmKLbABt8fyXpBN04pQzZKVQ5XyTYjY+UP4tQSHtIZ/DRCR+p5
 gBsnuKUjBkDN550oEqLGeJPBGulSPTfdOmwQkdm/xHRMm4tQ3HEDz7THFppjzaSkmvbm Vg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3kk0pfsdfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 01 Nov 2022 09:14:50 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Nov
 2022 09:14:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 1 Nov 2022 09:14:48 -0700
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 0FBCA3F7053;
        Tue,  1 Nov 2022 09:14:48 -0700 (PDT)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [net-next PATCH v2] octeon_ep: support Octeon device CNF95N
Date:   Tue, 1 Nov 2022 09:14:36 -0700
Message-ID: <20221101161445.5915-1-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: JzA_Zqi2HWpctrMeYO7dDPRF7QAZIFMC
X-Proofpoint-ORIG-GUID: JzA_Zqi2HWpctrMeYO7dDPRF7QAZIFMC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-01_07,2022-11-01_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Octeon device CNF95N.
CNF95N is a Octeon Fusion family product with same PCI NIC
characteristics as CN93 which is currently supported by the driver.

update supported device list in Documentation.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
---
V1 -> V2:
  - update supported device list in Documentation.

 .../ethernet/marvell/octeon_ep.rst            |  1 +
 .../ethernet/marvell/octeon_ep/octep_main.c   | 19 ++++++++++++++++---
 .../ethernet/marvell/octeon_ep/octep_main.h   |  2 ++
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst b/Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst
index bc562c49011b..cad96c8d1f97 100644
--- a/Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst
+++ b/Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst
@@ -23,6 +23,7 @@ Supported Devices
 =================
 Currently, this driver support following devices:
  * Network controller: Cavium, Inc. Device b200
+ * Network controller: Cavium, Inc. Device b400
 
 Interface Control
 =================
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 9089adcb75f9..e956c1059fc8 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -23,6 +23,7 @@ struct workqueue_struct *octep_wq;
 /* Supported Devices */
 static const struct pci_device_id octep_pci_id_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, OCTEP_PCI_DEVICE_ID_CN93_PF)},
+	{PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, OCTEP_PCI_DEVICE_ID_CNF95N_PF)},
 	{0, },
 };
 MODULE_DEVICE_TABLE(pci, octep_pci_id_tbl);
@@ -907,6 +908,18 @@ static void octep_ctrl_mbox_task(struct work_struct *work)
 	}
 }
 
+static const char *octep_devid_to_str(struct octep_device *oct)
+{
+	switch (oct->chip_id) {
+	case OCTEP_PCI_DEVICE_ID_CN93_PF:
+		return "CN93XX";
+	case OCTEP_PCI_DEVICE_ID_CNF95N_PF:
+		return "CNF95N";
+	default:
+		return "Unsupported";
+	}
+}
+
 /**
  * octep_device_setup() - Setup Octeon Device.
  *
@@ -939,9 +952,9 @@ int octep_device_setup(struct octep_device *oct)
 
 	switch (oct->chip_id) {
 	case OCTEP_PCI_DEVICE_ID_CN93_PF:
-		dev_info(&pdev->dev,
-			 "Setting up OCTEON CN93XX PF PASS%d.%d\n",
-			 OCTEP_MAJOR_REV(oct), OCTEP_MINOR_REV(oct));
+	case OCTEP_PCI_DEVICE_ID_CNF95N_PF:
+		dev_info(&pdev->dev, "Setting up OCTEON %s PF PASS%d.%d\n",
+			 octep_devid_to_str(oct), OCTEP_MAJOR_REV(oct), OCTEP_MINOR_REV(oct));
 		octep_device_setup_cn93_pf(oct);
 		break;
 	default:
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
index 025626a61383..123ffc13754d 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
@@ -21,6 +21,8 @@
 #define  OCTEP_PCI_DEVICE_ID_CN93_PF 0xB200
 #define  OCTEP_PCI_DEVICE_ID_CN93_VF 0xB203
 
+#define  OCTEP_PCI_DEVICE_ID_CNF95N_PF 0xB400    //95N PF
+
 #define  OCTEP_MAX_QUEUES   63
 #define  OCTEP_MAX_IQ       OCTEP_MAX_QUEUES
 #define  OCTEP_MAX_OQ       OCTEP_MAX_QUEUES

base-commit: 6f1a298b2e24c703bfcc643e41bc7c0604fe4830
-- 
2.36.0

