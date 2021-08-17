Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BBD3EE5CD
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237710AbhHQEqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:46:15 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2616 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237458AbhHQEqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:46:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17GMLHvl012281;
        Mon, 16 Aug 2021 21:45:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=mngNlh3DfSwWj3l65u74WT1wJ+Dbtcg1z6eLALjG3WU=;
 b=Cf33Niba3R2fWwFsFY5sOhccWAOE/ko9Qtka262xXGUN8QTaoq2nk9d/yQCoq3q1Sa3Z
 eEm1Pttb1AytJz3DF7SCXMkmvG2ciBQc/istwq66eAu0kvM2TzlkEeBUQ1srq3mSOqBA
 SsTnszmyOfI+m5jsfawahtGSspsYhVtnWPXHrru5PscJ30tXT91UbtiFh+80MWyMbEdF
 O0Ha0CeqdpSxjlRoks4CRWTc2sWJGrtIo2LEFfStNJYmvMy90yYKi5Ke6IgVeJmubo4j
 q8rp14QPzlaObLGQiPSLcPS3f2pCs9IRbDWfrXKJ1+5U1bJiRUbQml0pQbk2OjAx/IhB Mg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ag0qxgxrq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 21:45:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 21:45:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 21:45:24 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id DC6C63F70AB;
        Mon, 16 Aug 2021 21:45:21 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 09/11] octeontx2-af: Allocate low priority entries for PF
Date:   Tue, 17 Aug 2021 10:14:51 +0530
Message-ID: <1629175493-4895-10-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
References: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: cDPPVg6uqp5sBHm9Jsx_H4XmEB7fpMrT
X-Proofpoint-GUID: cDPPVg6uqp5sBHm9Jsx_H4XmEB7fpMrT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the mcam entry allocation request is from PF
and NOT a priority allocation request then allocate
low priority entries so that PF entries always have
lower priority than its VFs. This is required so
that entries with (base) MCAM match criteria have lower
priority compared to entries with (base + additional)
match criteria. This patch considers only best case
scenario where PF entries are allocated from low
priority zone if low priority zone has free space.
There are worst case scenarios like:
1. VFs allocating hundreds of MCAM entries leading to VFs
using all mid priority zone and low priority zone entries
hence no entries free from low priority zone for PF.
2. All the PFs and VFs in the system allocating and freeing
entries causing fragmentation in MCAM space and all the
entries requested by PF could not fit in low priority
zone for allocation.
This patch do not handle worst case scenarios.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 52b2554..20a562c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2414,6 +2414,17 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
 		goto alloc;
 	}
 
+	/* For a VF base MCAM match rule is set by its PF. And all the
+	 * further MCAM rules installed by VF on its own are
+	 * concatenated with the base rule set by its PF. Hence PF entries
+	 * should be at lower priority compared to VF entries. Otherwise
+	 * base rule is hit always and rules installed by VF will be of
+	 * no use. Hence if the request is from PF and NOT a priority
+	 * allocation request then allocate low priority entries.
+	 */
+	if (!(pcifunc & RVU_PFVF_FUNC_MASK))
+		goto lprio_alloc;
+
 	/* Find out the search range for non-priority allocation request
 	 *
 	 * Get MCAM free entry count in middle zone.
@@ -2439,6 +2450,7 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
 		/* Not enough free entries, search all entries in reverse,
 		 * so that low priority ones will get used up.
 		 */
+lprio_alloc:
 		reverse = true;
 		start = 0;
 		end = mcam->bmap_entries;
-- 
2.7.4

