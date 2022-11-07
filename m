Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDC961EBEB
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiKGH1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbiKGH0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:26:44 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E20A38B4;
        Sun,  6 Nov 2022 23:26:43 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A76Wlo3004208;
        Sun, 6 Nov 2022 23:26:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=nGnegt7wdNnoeuYJ355iGK9qwYbRQjZ2NIpFq6aE0MI=;
 b=SMyUDvzRovAU/WN02ME5/1sJNPZQofx2x0WceVpd4FbUqVCRN1og0SIXkUs4hQj8fB62
 kEqtRlq4ZtvY0q//8kYIWYlV0UEOtvA+B3duru6WgnIEfn4zno3WpOms29q6O8ZBwgJO
 p3X4DbC96e0gDPxpx2KqBTtq1YZ8YsYYx2adYy6i6VJ5DEDoTlrE35DdqsUqd/guW+wR
 6SvhKWSKoRc7Hz8NBa4i66+QB9L7ZWS03gqBtlmS0hglANia63JqQHQpzUjiWKjtV56+
 CXlEUkJPO4t2aLlE6Xvmj6vWTKhES4uO+gbVL3yV3EZNtpzXcz3FjtLE10l56WCoxYI5 3A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3kpvuk85b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 06 Nov 2022 23:26:37 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 6 Nov
 2022 23:26:35 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 6 Nov 2022 23:26:35 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 064313F7050;
        Sun,  6 Nov 2022 23:26:35 -0800 (PST)
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
Subject: [PATCH net-next 3/9] octeon_ep: control mailbox for multiple PFs
Date:   Sun, 6 Nov 2022 23:25:17 -0800
Message-ID: <20221107072524.9485-4-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221107072524.9485-1-vburru@marvell.com>
References: <20221107072524.9485-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 5TosVkoQ_J1F-cZI_i76DLd9NbpHD8Mg
X-Proofpoint-ORIG-GUID: 5TosVkoQ_J1F-cZI_i76DLd9NbpHD8Mg
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

Add control mailbox support for multiple PFs.
Update control mbox base address calculation based on PF function link.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
---
 .../ethernet/marvell/octeon_ep/octep_cn9k_pf.c   | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
index ace2dfd1e918..e307bae62673 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
@@ -13,6 +13,9 @@
 #include "octep_main.h"
 #include "octep_regs_cn9k_pf.h"
 
+#define CTRL_MBOX_MAX_PF	128
+#define CTRL_MBOX_SZ		((size_t)(0x400000 / CTRL_MBOX_MAX_PF))
+
 /* Names of Hardware non-queue generic interrupts */
 static char *cn93_non_ioq_msix_names[] = {
 	"epf_ire_rint",
@@ -199,6 +202,8 @@ static void octep_init_config_cn93_pf(struct octep_device *oct)
 	struct octep_config *conf = oct->conf;
 	struct pci_dev *pdev = oct->pdev;
 	u64 val;
+	int pos;
+	u8 link = 0;
 
 	/* Read ring configuration:
 	 * PF ring count, number of VFs and rings per VF supported
@@ -234,7 +239,16 @@ static void octep_init_config_cn93_pf(struct octep_device *oct)
 	conf->msix_cfg.ioq_msix = conf->pf_ring_cfg.active_io_rings;
 	conf->msix_cfg.non_ioq_msix_names = cn93_non_ioq_msix_names;
 
-	conf->ctrl_mbox_cfg.barmem_addr = (void __iomem *)oct->mmio[2].hw_addr + (0x400000ull * 7);
+	pos = pci_find_ext_capability(oct->pdev, PCI_EXT_CAP_ID_SRIOV);
+	if (pos) {
+		pci_read_config_byte(oct->pdev,
+				     pos + PCI_SRIOV_FUNC_LINK,
+				     &link);
+		link = PCI_DEVFN(PCI_SLOT(oct->pdev->devfn), link);
+	}
+	conf->ctrl_mbox_cfg.barmem_addr = (void __iomem *)oct->mmio[2].hw_addr +
+					   (0x400000ull * 8) +
+					   (link * CTRL_MBOX_SZ);
 }
 
 /* Setup registers for a hardware Tx Queue  */
-- 
2.36.0

