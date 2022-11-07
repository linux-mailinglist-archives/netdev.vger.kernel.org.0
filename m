Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832C461EBF5
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiKGH1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiKGH0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:26:47 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8988013D2C;
        Sun,  6 Nov 2022 23:26:46 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A76X0xH004392;
        Sun, 6 Nov 2022 23:26:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=DwYV4VEmhO+xAsqREfk+3L5xcekniqBBnYaDek77Qtc=;
 b=eS2vakutUW4DP76KWRwbCo5J5ewMwEFW7tCT4hUl8GrohRU5M+3qHIND+b1Nt3vjfyBS
 kKHdo3+HHb3xtp21bRzHZruaVyRmttb5zqsicz4lSd/Sxw8h81u6WjqDPY/ydsrTv/eo
 B9fQkhj0ePgEgiyuJLene3PMmSRclHEamb0OvWNXrKZ66Q/RV9h27P5ii1NljuUdubml
 uLviM4m8YJ0d79wzWcYyvcZghnGtRWevkgjDRq8mJ645Z2Y2vbm9aM6Z5UWa/3aTVQRZ
 8HRDYPiwxKA2HURfRswB4oFBn+WBWZt5O3vbeKy6UAgpLfcF00/3FY+oO7P6OjxgE4tj uQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3kpvuk85b9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 06 Nov 2022 23:26:40 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 6 Nov
 2022 23:26:39 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 6 Nov 2022 23:26:39 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id E6B043F7050;
        Sun,  6 Nov 2022 23:26:38 -0800 (PST)
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
Subject: [PATCH net-next 7/9] octeon_ep: add SRIOV VF creation
Date:   Sun, 6 Nov 2022 23:25:21 -0800
Message-ID: <20221107072524.9485-8-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221107072524.9485-1-vburru@marvell.com>
References: <20221107072524.9485-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: bQ2zehtKMs9a2YedPkX_A9PgphLKlYsW
X-Proofpoint-ORIG-GUID: bQ2zehtKMs9a2YedPkX_A9PgphLKlYsW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-06_16,2022-11-03_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to create SRIOV VFs.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Sathesh Edara <sedara@marvell.com>
---
 .../ethernet/marvell/octeon_ep/octep_main.c   | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index ad5553854467..fa0f3d597eb1 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1236,11 +1236,61 @@ static void octep_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+static int octep_sriov_disable(struct octep_device *oct)
+{
+	struct pci_dev *pdev = oct->pdev;
+
+	if (pci_vfs_assigned(oct->pdev)) {
+		dev_warn(&pdev->dev, "Can't disable SRIOV while VFs are assigned\n");
+		return -EPERM;
+	}
+
+	pci_disable_sriov(pdev);
+	CFG_GET_ACTIVE_VFS(oct->conf) = 0;
+
+	return 0;
+}
+
+static int octep_sriov_enable(struct octep_device *oct, int num_vfs)
+{
+	struct pci_dev *pdev = oct->pdev;
+	int err;
+
+	err = pci_enable_sriov(pdev, num_vfs);
+	if (err) {
+		dev_warn(&pdev->dev, "Failed to enable SRIOV err=%d\n", err);
+		return err;
+	}
+	CFG_GET_ACTIVE_VFS(oct->conf) = num_vfs;
+
+	return num_vfs;
+}
+
+static int octep_sriov_configure(struct pci_dev *pdev, int num_vfs)
+{
+	struct octep_device *oct = pci_get_drvdata(pdev);
+	int max_nvfs;
+
+	if (num_vfs == 0)
+		return octep_sriov_disable(oct);
+
+	max_nvfs = CFG_GET_MAX_VFS(oct->conf);
+
+	if (num_vfs > max_nvfs) {
+		dev_err(&pdev->dev, "Invalid VF count Max supported VFs = %d\n",
+			max_nvfs);
+		return -EINVAL;
+	}
+
+	return octep_sriov_enable(oct, num_vfs);
+}
+
 static struct pci_driver octep_driver = {
 	.name = OCTEP_DRV_NAME,
 	.id_table = octep_pci_id_tbl,
 	.probe = octep_probe,
 	.remove = octep_remove,
+	.sriov_configure = octep_sriov_configure,
 };
 
 /**
-- 
2.36.0

