Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089E43FBB5B
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 20:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbhH3SB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 14:01:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3646 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238200AbhH3SB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 14:01:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17UAuU2t011588;
        Mon, 30 Aug 2021 11:00:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=eWHxeYgfIAnj/Pm61rItHN99k6/8C7UP3xEk/AZ2veU=;
 b=WDZb0zqkeUIsqnNiGttxx6VcNK/RRiq/5uwQgphLzAmKUmlxC/50GIKlIbQmmuEgaCKF
 8O08eC6J/iJgChS9bc8HCcvwXJktLUi7naVRFHYI53LTDZD2cHniCDdR+/SkZmToZzst
 irbflmzMOxTa7Jcdq7+MtV0it86sytD9l0sRUC1eYQuyt2eb1+ROHy4hxyzJP+OnQN8B
 1bsSKIQeRbvyyVukJDxZ1aH4BHDonOPgr8YlVpSicBArpDzHIIPa4OybBHjFNkuPAQct
 1kDc++R+3gdJ27addaPOKCRT4lxPipWhPqUS7QEqg4gUl+BD7I+Dlbe2EAJkGcTo0BHN CQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3arj9m3cqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Aug 2021 11:00:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 30 Aug
 2021 11:00:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 30 Aug 2021 11:00:57 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 804CC3F7080;
        Mon, 30 Aug 2021 11:00:54 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 1/4] octeontx2-af: Fix loop in free and unmap counter
Date:   Mon, 30 Aug 2021 23:30:43 +0530
Message-ID: <1630346446-21609-2-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1630346446-21609-1-git-send-email-sbhatta@marvell.com>
References: <1630346446-21609-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: XQ9RezvUHRnQaQZCEtzaQ5RTYz3Gs2rg
X-Proofpoint-ORIG-GUID: XQ9RezvUHRnQaQZCEtzaQ5RTYz3Gs2rg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-30_06,2021-08-30_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the given counter does not belong to the entry
then code ends up in infinite loop because the loop
cursor, entry is not getting updated further. This
patch fixes that by updating entry for every iteration.

Fixes: a958dd59f9ce ("octeontx2-af: Map or unmap NPC MCAM entry and counter")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index b954858..6389ee7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2979,10 +2979,11 @@ int rvu_mbox_handler_npc_mcam_unmap_counter(struct rvu *rvu,
 		index = find_next_bit(mcam->bmap, mcam->bmap_entries, entry);
 		if (index >= mcam->bmap_entries)
 			break;
+		entry = index + 1;
+
 		if (mcam->entry2cntr_map[index] != req->cntr)
 			continue;
 
-		entry = index + 1;
 		npc_unmap_mcam_entry_and_cntr(rvu, mcam, blkaddr,
 					      index, req->cntr);
 	}
-- 
2.7.4

