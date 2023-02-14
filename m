Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16511695844
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 06:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbjBNFOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 00:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbjBNFOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 00:14:38 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810B71BFB;
        Mon, 13 Feb 2023 21:14:35 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31E53wwa028877;
        Mon, 13 Feb 2023 21:14:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=fx2mM3JW5+8ZWCp86uQYb+wyUmHlUNNXtiWxCE3vn1Y=;
 b=chfW/JTKGn+4YMvq/kbjc6q9EXfvI0VdsW8EfMNCvMDIuxtrG7hyS2uiwYTQdwL6NBMz
 MLCTfSV1PpkkiWtSZdrb2dPSrZD7/6Bo3EsnGHrTfgDPs9fa1JIBSX9XmcM9+QS9D3r7
 BtzeUYjIlNP6+B3ZUWPDuz3wgk7tTy5wrvdEV1Yd3hh3uqy64DcHnH31HeYsbrv9Efib
 vzyN4xKebB/3xrdlhYk87YnyOwnxZKAKm/wW+WCZPvzP46O5avlD+EYgLEPWuTbuBXbN
 CS7X0zg7fQj55LaP41xWjwf7kB01Y8r6dRnIPClxFiHF+kJIserA9TwOEQY74rU3G4Yt Mw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3np98upmp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 21:14:29 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 13 Feb
 2023 21:14:28 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 13 Feb 2023 21:14:28 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id AEF843F707A;
        Mon, 13 Feb 2023 21:14:27 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v3 1/7] octeon_ep: defer probe if firmware not ready
Date:   Mon, 13 Feb 2023 21:14:16 -0800
Message-ID: <20230214051422.13705-2-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20230214051422.13705-1-vburru@marvell.com>
References: <20230214051422.13705-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 5VMnYjhsfyhSvjynL4kywVCXGy0p81rb
X-Proofpoint-ORIG-GUID: 5VMnYjhsfyhSvjynL4kywVCXGy0p81rb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_03,2023-02-13_01,2023-02-09_01
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
v2 -> v3:
 * fix review comments
   https://lore.kernel.org/all/Y4chWyR6qTlptkTE@unreal/
   - change get_fw_ready_status() to return bool
   - fix the success oriented flow while looking for
     PCI extended capability
 
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
index 5a898fb88e37..5620df4c6d55 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1017,6 +1017,26 @@ static void octep_device_cleanup(struct octep_device *oct)
 	oct->conf = NULL;
 }
 
+static bool get_fw_ready_status(struct pci_dev *pdev)
+{
+	u32 pos = 0;
+	u16 vsec_id;
+	u8 status;
+
+	while ((pos = pci_find_next_ext_capability(pdev, pos,
+						   PCI_EXT_CAP_ID_VNDR))) {
+		pci_read_config_word(pdev, pos + 4, &vsec_id);
+#define FW_STATUS_VSEC_ID  0xA3
+		if (vsec_id != FW_STATUS_VSEC_ID)
+			continue;
+
+		pci_read_config_byte(pdev, (pos + 8), &status);
+		dev_info(&pdev->dev, "Firmware ready status = %u\n", status);
+		return status ? true : false;
+	}
+	return false;
+}
+
 /**
  * octep_probe() - Octeon PCI device probe handler.
  *
@@ -1053,6 +1073,12 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_enable_pcie_error_reporting(pdev);
 	pci_set_master(pdev);
 
+	if (!get_fw_ready_status(pdev)) {
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

