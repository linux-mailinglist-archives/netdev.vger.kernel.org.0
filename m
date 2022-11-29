Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06BA63C0A0
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbiK2NKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbiK2NJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:09:59 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37AE59170;
        Tue, 29 Nov 2022 05:09:58 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATBxjWv029859;
        Tue, 29 Nov 2022 05:09:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=HvX7af/N5/lzH6fxa5KjfS8FuhXQiZKgKoM6CluI66k=;
 b=OSRPYwzSbAtday5Gz04mKhUxFXCa3DZOUcaNRI2riTwoQwfwBXeqesRxDeQn/u6kisx8
 Dtbrwq3iClySmA6IdcRco5uXDWS2CZG+bQ0mPiK0vG47pZEvPPes63Qbj605OFjLFpX1
 J6dW2OLgZI1N78wC1oALItMgGjKDevQNW4skKmhhcxTbpc1QTdisK/cAAQSDdsLYUhj1
 YWrDaCm2QgsAC11Y2gyf2+h4FJNvEHDNrDMuRrvteeoC8EZD1cL7ByV3aCW8NADQ3zrL
 hV0XbXyktqM7nnvHdh6NDTxltHCHFPN7R/sQgnKmTG5Iswn0rKFfaIbo1M/v/FLo7k/2 Qw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m5a509ysx-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 05:09:49 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Nov
 2022 05:09:40 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Nov 2022 05:09:40 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 2135F3F7088;
        Tue, 29 Nov 2022 05:09:40 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v2 1/9] octeon_ep: defer probe if firmware not ready
Date:   Tue, 29 Nov 2022 05:09:24 -0800
Message-ID: <20221129130933.25231-2-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221129130933.25231-1-vburru@marvell.com>
References: <20221129130933.25231-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: RzQePv3nI0UFPPUqDJLlzl1ydkXCAPiR
X-Proofpoint-GUID: RzQePv3nI0UFPPUqDJLlzl1ydkXCAPiR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_08,2022-11-29_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Defer probe if firmware is not ready for device usage.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
Signed-off-by: Satananda Burla <sburla@marvell.com>
---
v1 -> v2:
 * was scheduling workqueue task to wait for firmware ready,
   to probe/initialize the device.
 * now, removed the workqueue task; the probe returns EPROBE_DEFER,
   if firmware is not ready.
 * removed device status oct->status, as it is not required with the
   modified implementation.

 .../ethernet/marvell/octeon_ep/octep_main.c   | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 5a898fb88e37..aa7d0ced9807 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1017,6 +1017,25 @@ static void octep_device_cleanup(struct octep_device *oct)
 	oct->conf = NULL;
 }
 
+static u8 get_fw_ready_status(struct pci_dev *pdev)
+{
+	u32 pos = 0;
+	u16 vsec_id;
+	u8 status;
+
+	while ((pos = pci_find_next_ext_capability(pdev, pos,
+						   PCI_EXT_CAP_ID_VNDR))) {
+		pci_read_config_word(pdev, pos + 4, &vsec_id);
+#define FW_STATUS_VSEC_ID  0xA3
+		if (vsec_id == FW_STATUS_VSEC_ID) {
+			pci_read_config_byte(pdev, (pos + 8), &status);
+			dev_info(&pdev->dev, "Firmware ready %u\n", status);
+			return status;
+		}
+	}
+	return 0;
+}
+
 /**
  * octep_probe() - Octeon PCI device probe handler.
  *
@@ -1053,6 +1072,13 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_enable_pcie_error_reporting(pdev);
 	pci_set_master(pdev);
 
+#define FW_STATUS_READY    1
+	if (get_fw_ready_status(pdev) != FW_STATUS_READY) {
+		dev_notice(&pdev->dev, "Firmware not ready; defer probe.\n");
+		err = -EPROBE_DEFER;
+		goto err_alloc_netdev;
+	}
+
 	netdev = alloc_etherdev_mq(sizeof(struct octep_device),
 				   OCTEP_MAX_QUEUES);
 	if (!netdev) {
-- 
2.36.0

