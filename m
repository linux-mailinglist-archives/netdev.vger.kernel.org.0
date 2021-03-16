Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E7333D0CE
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbhCPJ2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:28:25 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54272 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236269AbhCPJ2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:28:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G9QNKP020140;
        Tue, 16 Mar 2021 02:27:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=HkybvMXidPDP4oDSJ4buYtRu/cKcXpLJtCo/0+bVD4s=;
 b=XWFF9zg5RX6itOr7KXnN5P+gZOueO02wlIbE0Cnw2gwQIbSZ+UQNWrk7DLsi98ZNC8SX
 QIhzkOTU+nvL3wOESx2uHTDWpenFankKS7oTw6fP3gOfkSnPcjqISMKP1w28XsnZt2OH
 X/eP88IohpjkkQpu5zkt0+/DvC6vRnLi4OOKL7zoXwbAIsKMLMdKNYlHRuzivdrOTf0f
 ZkWChVuvOgj2riABGvLiRAfLRfZGhxfYY/684CDzNYnBQ4wkTXuncTF8LWKXG0ktcxdn
 sk/9LJMoBpmKfHIMy4TYEq2kYz4dEvpGbDcW8MV+SIIDgCKpz9c703vBokbxUmhQUDkw Nw== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0a-0016f401.pphosted.com with ESMTP id 378umtfrcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 02:27:47 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Mar 2021 05:27:45 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Mar 2021 05:27:45 -0400
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id F2BE33F7045;
        Tue, 16 Mar 2021 02:27:41 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 8/9] octeontx2-af: fix infinite loop in unmapping counter
Date:   Tue, 16 Mar 2021 14:57:12 +0530
Message-ID: <1615886833-71688-9-git-send-email-hkelam@marvell.com>
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

Current code does not break from loop due to entry value
miscalculation. Hence correct the same.

Fixes: a958dd59("octeontx2-af: Map or unmap NPC MCAM entry and counter")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 04bb080..0bd49c7 100644
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
2.7.4

