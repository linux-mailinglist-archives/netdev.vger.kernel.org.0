Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73C363C0A7
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbiK2NKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbiK2NKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:10:02 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2871761506;
        Tue, 29 Nov 2022 05:10:01 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATBxjX3029859;
        Tue, 29 Nov 2022 05:09:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=+cXlLxmV1H8HUaAl4N1/GqA5b1HOv85DnD4OjH+gw1g=;
 b=Z5jb0ThTm57WYoIGa5TcBdnL6ojY1TTJWDWRhCR0WwpsevOoQAR9OWk3RY9uPFEDAVGr
 Bi/hJdrV99XfwfqbTH+/xZ4OZuojZcxE5AVuwJYx2Mk4afB5FpWckGZVTexGUSsOOOtF
 7GSw2rR0AoZK8yYBXgTDNeRyaA4m/vJE5+QzSnuDbi4FpMlsjnIWTPpkbqHRvzHLEBnv
 hoRJlUB5sYMExDkOLoMm3foSJFMQgR3v8nIRBbGvTR/CIC7KW4vb8iYkoqAec9F/X6AZ
 ojMdViV8ggryecZkIh5v598lwmfo4bQX9NxtwGFCoC/7UA3MKfjeXccC1lkLN5DjX4/l mg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m5a509ysx-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 05:09:52 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Nov
 2022 05:09:45 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Nov 2022 05:09:45 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 36C753F7084;
        Tue, 29 Nov 2022 05:09:45 -0800 (PST)
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
Subject: [PATCH net-next v2 7/9] octeon_ep: add SRIOV VF creation
Date:   Tue, 29 Nov 2022 05:09:30 -0800
Message-ID: <20221129130933.25231-8-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221129130933.25231-1-vburru@marvell.com>
References: <20221129130933.25231-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: vFt53_GzrBgDTHRpF9yMtStT-niUG7h_
X-Proofpoint-GUID: vFt53_GzrBgDTHRpF9yMtStT-niUG7h_
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

Add support to create SRIOV VFs.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Sathesh Edara <sedara@marvell.com>
---
v1 -> v2:
 * no change

 .../ethernet/marvell/octeon_ep/octep_main.c   | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 069c4d18cf37..d43161d1e38a 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1177,11 +1177,61 @@ static void octep_remove(struct pci_dev *pdev)
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

