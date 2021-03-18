Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEF33407AD
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhCROQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:49 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25890 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231280AbhCROQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IEEX2P027702;
        Thu, 18 Mar 2021 07:16:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=V0/5q+jjJd3iQQHrY+xo3Weaa1LvMmDw1cynZHTj+Eo=;
 b=eQJTKkH9wG+jyBkspL9IR2vYJTDXDpb8Rcy2Xktp5+TlfQcKt/oqf8LoZldH42jIsEq/
 821ObSQXiIHBpsJzOLGZRAv2Wu95VDkeQL8PtHhvGyTPgB8faMlJMB3BNSXCvdPYfr3C
 l8e2OXM5FpJ25ZcKBb/jR3b4hSCtaAK9cT3J8duWGPmHaDNA15mVVT3b8duaonA5OUIt
 pRVnBzGxzYKAhV92VJtb14Fx8acXrTzYEuR0szKOGvex85gdNVYtOy2iS2iq0k+Gl0+O
 69FOsjD7Mgm6WTcR/G2pdxr4+VZivRttFcp4MDBbjIfeBNl1e5ulaZPYogVrxgoniywt Vg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 37c5bf0q83-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 07:16:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Mar
 2021 07:16:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Mar 2021 07:16:20 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 3CDB43F7044;
        Thu, 18 Mar 2021 07:16:17 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [net PATCH v2 7/8] octeontx2-af: fix infinite loop in unmapping NPC counter
Date:   Thu, 18 Mar 2021 19:45:48 +0530
Message-ID: <20210318141549.2622-8-hkelam@marvell.com>
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

unmapping npc counter works in a way by traversing all mcam
entries to find which mcam rule is associated with counter.
But loop cursor variable 'entry' is not incremented before
checking next mcam entry which resulting in infinite loop.

This in turn hogs the kworker thread forever and no other
mbox message is processed by AF driver after that.
Fix this by updating entry value before checking next
mcam entry.

Fixes: a958dd59f9ce ("octeontx2-af: Map or unmap NPC MCAM entry and counter")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 04bb0803a5c..0bd49c7080a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2490,10 +2490,10 @@ int rvu_mbox_handler_npc_mcam_free_counter(struct rvu *rvu,
 		index = find_next_bit(mcam->bmap, mcam->bmap_entries, entry);
 		if (index >= mcam->bmap_entries)
 			break;
+		entry = index + 1;
 		if (mcam->entry2cntr_map[index] != req->cntr)
 			continue;
 
-		entry = index + 1;
 		npc_unmap_mcam_entry_and_cntr(rvu, mcam, blkaddr,
 					      index, req->cntr);
 	}
-- 
2.17.1

