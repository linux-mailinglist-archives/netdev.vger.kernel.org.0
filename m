Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9C33407A8
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhCROQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:45 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42844 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231557AbhCROQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IEF2mE027217;
        Thu, 18 Mar 2021 07:16:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=sTJ3IMOmXARTvoeOGPslic0XzPbePSuKWqgHl1327WQ=;
 b=VbxURsykYiqA5lBqeeqm8aBwXEFQoCmq5XND3E5p8BfjjhYjtVjbc0iWco+kWXosPuWL
 GswYsFvPv1/9hDS2wFSYTIRfNiNwv7o9L7wsFIWyLSLxl3O2I95C7BXXNKNPK8kndIut
 a1k2uZ5NG9WYxvwy6k0Ye9rBiZycBpE7fLFH6TSA0XzWMyGbGeiilPAYhubBAVfwqjKg
 6BQjG9Xm0nBkV8UN9AZ+GbUlz4NWHemG3PMmkaj2TWuRRgM9GZT6luV80NTyLjKejR7L
 8g/KYCgGd5tvYvDB+duUI8ui9tFFwil5xEQOs4BfMwBnOidYVlgYo9N2+D3yGxim6LfW 3Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37b5vdpkdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 07:16:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Mar
 2021 07:16:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Mar 2021 07:16:13 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 80DE23F703F;
        Thu, 18 Mar 2021 07:16:09 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [net PATCH v2 5/8] octeontx2-af: Fix irq free in rvu teardown
Date:   Thu, 18 Mar 2021 19:45:46 +0530
Message-ID: <20210318141549.2622-6-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210318141549.2622-1-hkelam@marvell.com>
References: <20210318141549.2622-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

Current devlink code try to free already freed irqs as the
irq_allocate flag is not cleared after free leading to kernel
crash while removing rvu driver. The patch fixes the irq free
sequence and clears the irq_allocate flag on free.

Fixes: 7304ac4567bc ("octeontx2-af: Add mailbox IRQ and msg handlers")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index d9a1a71c7cc..ab24a5e8ee8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2462,8 +2462,10 @@ static void rvu_unregister_interrupts(struct rvu *rvu)
 		    INTR_MASK(rvu->hw->total_pfs) & ~1ULL);
 
 	for (irq = 0; irq < rvu->num_vec; irq++) {
-		if (rvu->irq_allocated[irq])
+		if (rvu->irq_allocated[irq]) {
 			free_irq(pci_irq_vector(rvu->pdev, irq), rvu);
+			rvu->irq_allocated[irq] = false;
+		}
 	}
 
 	pci_free_irq_vectors(rvu->pdev);
@@ -2975,8 +2977,8 @@ static void rvu_remove(struct pci_dev *pdev)
 	struct rvu *rvu = pci_get_drvdata(pdev);
 
 	rvu_dbg_exit(rvu);
-	rvu_unregister_interrupts(rvu);
 	rvu_unregister_dl(rvu);
+	rvu_unregister_interrupts(rvu);
 	rvu_flr_wq_destroy(rvu);
 	rvu_cgx_exit(rvu);
 	rvu_fwdata_exit(rvu);
-- 
2.17.1

