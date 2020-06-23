Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFD42053E7
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 15:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732828AbgFWNxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 09:53:43 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47740 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732804AbgFWNxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 09:53:37 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NDjF1P024287;
        Tue, 23 Jun 2020 06:53:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=gb/TyPGEnqbvGV19VgDXCxsF0a7P5o5Sw2mSfPvPjQI=;
 b=GAr43DNiP7ZDrffdYhQNHOeHrtmx5BbqvIdoqobG12sA26ga/HL/+8YJ0Wzg4cwDMgHb
 NVzJflj5DSwKRAXXqhyP2hd+4zTNZCtVmvNJgG6lQ9KAhDw4rHdNkf0/Z5KNz29YZOHu
 BHlJFJozhD4TDk6n0oqi+UKn/aifQxH5z6IIl53bJ3TAjaqZn1tfNu2OSV6NhSN/mjWC
 13HFydh7RnoPdjJjQmXqGhQP/OKb838cLSRPfxjyrMe6PyWaXRz5t5YGnDxHZ0zwOI2b
 4AjE975pLZmBC3zomKiibPqJk6gHvdJUIDSReulIV6KvQmirwDaz7fJIYr3BMQ6/ihtJ 7g== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 31ujw9r0xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 06:53:36 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 06:53:35 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 06:53:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Jun 2020 06:53:34 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id 1932D3F703F;
        Tue, 23 Jun 2020 06:53:30 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "Denis Bolotin" <denis.bolotin@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net 5/9] net: qed: fix excessive QM ILT lines consumption
Date:   Tue, 23 Jun 2020 16:51:33 +0300
Message-ID: <20200623135136.3185-6-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623135136.3185-1-alobakin@marvell.com>
References: <20200623135136.3185-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_06:2020-06-23,2020-06-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is likely a copy'n'paste mistake. The amount of ILT lines to
reserve for a single VF was being multiplied by the total VFs count.
This led to a huge redundancy in reservation and potential lines
drainouts.

Fixes: 1408cc1fa48c ("qed: Introduce VFs")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 7b76667acaba..c0a769b5358c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -271,7 +271,7 @@ static void qed_cxt_qm_iids(struct qed_hwfn *p_hwfn,
 		vf_tids += segs[NUM_TASK_PF_SEGMENTS].count;
 	}
 
-	iids->vf_cids += vf_cids * p_mngr->vf_count;
+	iids->vf_cids = vf_cids;
 	iids->tids += vf_tids * p_mngr->vf_count;
 
 	DP_VERBOSE(p_hwfn, QED_MSG_ILT,
-- 
2.25.1

