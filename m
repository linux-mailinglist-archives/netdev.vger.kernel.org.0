Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42ED66C461A
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 10:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjCVJUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 05:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbjCVJUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 05:20:14 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8699D20577;
        Wed, 22 Mar 2023 02:20:13 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32M3vqnJ020844;
        Wed, 22 Mar 2023 02:20:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=cX6me6B5PS24IY2WuthFDKeL6bjQw2tmrVCMxV5H5VM=;
 b=FYquJahb1RSFHItzOTf6qMJJhX61X9kpveKvnn1NNwIwo8+HZzX32+5HLcS7TRpLJqRg
 PIuO33d/7yaWZ4zQnptZhHgryYqFix9tKzIDbvbXd58BdaeUMmuyyYRAJi7QqBmTbwRx
 1TVUN5Tfs+xn26pWfRRcf9oFjGyQI3Z6QaFXC0SaN0yBPRh2WDjQ0Vgr8y6QF8uC1W7r
 ukNq31t5ylznB1QHLDO7nhv6Goiri2TmAN6kJVk2wW17EijbJmGu/5fLxxf+3FXtI7Iw
 CfYv0qKfbjZuzPUSGZYLGTKQz/0ORpRc5Bgkf5WHSTdefSvLhX36bRcGGq7MjmLDvDnl fA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pft7uh1rx-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 02:20:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 22 Mar
 2023 02:20:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 22 Mar 2023 02:20:06 -0700
Received: from sburla-PowerEdge-T630.sclab.marvell.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 886AE5C68EC;
        Wed, 22 Mar 2023 02:20:06 -0700 (PDT)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v4 3/8] octeon_ep: control mailbox for multiple PFs
Date:   Wed, 22 Mar 2023 02:19:52 -0700
Message-ID: <20230322091958.13103-4-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20230322091958.13103-1-vburru@marvell.com>
References: <20230322091958.13103-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: fLSidUEhU_giF5hNghxFmgZqz4KCC2I7
X-Proofpoint-ORIG-GUID: fLSidUEhU_giF5hNghxFmgZqz4KCC2I7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_06,2023-03-21_01,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
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
v3 -> v4:
 * resovled review comments
   https://lore.kernel.org/all/Y+vJkPO1UZPDSFT2@boxer/
   - fixed rct violation.

v2 -> v3:
 * no change

v1 -> v2:
 * no change

 .../ethernet/marvell/octeon_ep/octep_cn9k_pf.c   | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
index adc2279bc66d..e2503c9bc8a1 100644
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
@@ -198,7 +201,9 @@ static void octep_init_config_cn93_pf(struct octep_device *oct)
 {
 	struct octep_config *conf = oct->conf;
 	struct pci_dev *pdev = oct->pdev;
+	u8 link = 0;
 	u64 val;
+	int pos;
 
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
+					   (0x400000ull * 7) +
+					   (link * CTRL_MBOX_SZ);
 }
 
 /* Setup registers for a hardware Tx Queue  */
-- 
2.36.0

