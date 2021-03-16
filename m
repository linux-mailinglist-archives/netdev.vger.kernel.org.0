Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D5133D0CA
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236276AbhCPJ2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:28:19 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41472 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236064AbhCPJ1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:27:46 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G9QR2s020151;
        Tue, 16 Mar 2021 02:27:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=S1PYI5MPS1aNRBXE1di+mnmLXN6wtxMtTIz2wK/wu/U=;
 b=DRGEfVmVde6wq4NwxVJvBQgfHe/7z76KOhlYUTredoz+7ROFTzUkJTCIUsNDiY8thNkM
 xo4s3AanFMIB9zGhXOL/7iZ2B3hfKhVOWxfnZBAP/zAV9T/7Sa7WsusIjW9TKxp5vvo1
 uFDZP4kVH3rIx9U1D61y18Hni/uhuC4HPWAgPUvoAITJRxDxAm0meuOFdngNyAEadgVK
 HTT8zeVFKWRzvxLg284k3RtKHS7OMZEue9VfVpWZfplaxeMfHDueFjNd/Jau0EsBs5z5
 UIJcE+HiT1BgWXjXFte4YS+Hax/ZhGzmamtKZznnwbfOoGSdTPcgyPwm6IYKHjQmsvyX EA== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0a-0016f401.pphosted.com with ESMTP id 378umtfrc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 02:27:45 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Mar 2021 05:27:41 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Mar 2021 05:27:41 -0400
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id 959A93F7040;
        Tue, 16 Mar 2021 02:27:38 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 7/9] octeontx2-pf: Clear RSS enable flag on interace down
Date:   Tue, 16 Mar 2021 14:57:11 +0530
Message-ID: <1615886833-71688-8-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
References: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-15,2021-03-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

RSS configuration can not be get/set when interface is in down state
as they required mbox communication. RSS enable flag status
is used for set/get configuration. Current code do not clear the
RSS enable flag on interface down which lead to mbox error while
trying to set/get RSS configuration.

Fixes: 85069e95e("octeontx2-pf: Receive side scaling support")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 53ab181..2fd3d23 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1672,6 +1672,7 @@ int otx2_stop(struct net_device *netdev)
 	struct otx2_nic *pf = netdev_priv(netdev);
 	struct otx2_cq_poll *cq_poll = NULL;
 	struct otx2_qset *qset = &pf->qset;
+	struct otx2_rss_info *rss;
 	int qidx, vec, wrk;
 
 	netif_carrier_off(netdev);
@@ -1684,6 +1685,10 @@ int otx2_stop(struct net_device *netdev)
 	/* First stop packet Rx/Tx */
 	otx2_rxtx_enable(pf, false);
 
+	/* Clear RSS enable flag */
+	rss = &pf->hw.rss_info;
+	rss->enable = false;
+
 	/* Cleanup Queue IRQ */
 	vec = pci_irq_vector(pf->pdev,
 			     pf->hw.nix_msixoff + NIX_LF_QINT_VEC_START);
-- 
2.7.4

