Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F9433D0C5
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236241AbhCPJ1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:27:54 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56244 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233380AbhCPJ1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:27:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G9QJGt020134;
        Tue, 16 Mar 2021 02:27:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=swaaeNHc6FbkxIcGm1Io/1goC478n8T8+nI0yBFueyg=;
 b=ORZI6eUT6ViGY+H52Lb8N0hAQva2XuaeFlz7nqX/zohnEqZEr6f2MxYy9JACQ1yd5TtC
 Hd5xvbtj781E9DwkJWmR1hOkLpyytFnXuCPxqNxhDSnxZu+ChW48A+Kcozt2Dj7q0ui9
 WbnEaLvWQPWg/ubW6IYljgEArPZbtkl6V+iytgjXcgF0gOt/kzPnlvLxWY+wx5czp2vr
 lD2x9WLt94m6JAMYC0tfK/q96Mk5Hq0X/9iQvnIcldOwKcaWRRfTyic/t9UXROPjtfYQ
 kDQ72qfVXdW4B8r6Tv01XlaWAII71FBrS9I/n+QhLoaA7RrV5Rth6BTUjXfIKx4EuK3Y LQ== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0a-0016f401.pphosted.com with ESMTP id 378umtfrbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 02:27:40 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Mar 2021 05:27:38 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Mar 2021 05:27:38 -0400
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id 3840C3F703F;
        Tue, 16 Mar 2021 02:27:34 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 6/9] octeontx2-af: Fix irq free in rvu teardown
Date:   Tue, 16 Mar 2021 14:57:10 +0530
Message-ID: <1615886833-71688-7-git-send-email-hkelam@marvell.com>
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

Current devlink code try to free already freed irqs as the
irq_allocate flag is not cleared after free leading to kernel
crash while removing rvu driver. The patch fixes the irq free
sequence and clears the irq_allocate flag on free.

Fixes: 7304ac456("octeontx2-af: Add mailbox IRQ and msg handlers")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index d9a1a71..ab24a5e 100644
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
2.7.4

