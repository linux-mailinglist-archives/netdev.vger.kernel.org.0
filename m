Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2AE695842
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 06:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjBNFOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 00:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjBNFOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 00:14:38 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B3530E7;
        Mon, 13 Feb 2023 21:14:36 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31E53wwc028877;
        Mon, 13 Feb 2023 21:14:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=9xMDpoZfipRQSFzP2NcND2Y7ZhWYtEcMQ6JEa9nmLtw=;
 b=kXVe0cx8j3Hsx9My86bv8Ha8foeKfDuClBW1N44uFn9fJ0ViB8dUkQWhV6Hzr3ZrrORc
 AFf3HAaR1yyErSq43Ag80OnH8uuJsAOFchM7teOVsboNzKX8LejjTobe1Ri4c9acipE2
 596Bi43oF+A/yJos9bCSCUsmDpv3h0sM1ZBju6dmVKlaxPpLTeM0cv6UOobm1LwZu3EK
 MnO15Z7BI82HQ8djUkWinjkTs9VFIT9uU0g4l7eqo9vbfVq31Mq/ipQRlOb2ttjBHQuL
 doGUoY2peJhNRk5Mz/3lLEqmXvxSJGa5wbYYiJmrufBUYrVkYmK4H+FwobVImqaoLgec zA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3np98upmpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 21:14:31 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 13 Feb
 2023 21:14:29 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 13 Feb 2023 21:14:29 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 779D83F707A;
        Mon, 13 Feb 2023 21:14:29 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v3 3/7] octeon_ep: control mailbox for multiple PFs
Date:   Mon, 13 Feb 2023 21:14:18 -0800
Message-ID: <20230214051422.13705-4-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20230214051422.13705-1-vburru@marvell.com>
References: <20230214051422.13705-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: k8xdLBEO6BulBQNNFHAEJjZthSIBvJ2Q
X-Proofpoint-ORIG-GUID: k8xdLBEO6BulBQNNFHAEJjZthSIBvJ2Q
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

Add control mailbox support for multiple PFs.
Update control mbox base address calculation based on PF function link.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
---
v2 -> v3:
 * no change

v1 -> v2:
 * no change

 .../ethernet/marvell/octeon_ep/octep_cn9k_pf.c   | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
index f40ebac15a79..c82a1347eed8 100644
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

