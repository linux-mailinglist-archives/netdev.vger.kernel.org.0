Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14B5660C73
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 05:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236674AbjAGEmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 23:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjAGEl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 23:41:56 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA7684635;
        Fri,  6 Jan 2023 20:41:56 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3072vWtZ003726;
        Fri, 6 Jan 2023 20:41:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=BVxoW8PmXFMv3h+4qTBfZny95ISCtWzgZuWh5HvWCfM=;
 b=Xbs5d+9ytUe6Agj6Tue9c4UDHCAhdNc30SYEDcwbQIDNTJLXXdew1XNx69H4Oj+hKIIz
 anZXwCOtNshZ3ES/GP1B8D3jTR7t1G/jaidDf5UcFloAPl8shj0FGTx7aZ3ruIdIIYa2
 la1AggW241uAtz7tEvQDb0WgrfFsnhfKMays3CKq/ffZ924lJFWHPMo24axLgoSzRpkH
 q+4kAdpYIgx9EtJOp/vW/cUfav+I9uGmHixDVq7s9jzcxoEi4iE3uaBncDFSNJCwShsk
 0LYArjDdEFY+aQu18GUaPD+ONCFozcUN2LaJXVBqjrQai/U2sOlBbdFbYSuBHYVsaYw3 6Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mx4hhbf6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 06 Jan 2023 20:41:45 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 6 Jan
 2023 20:41:43 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Fri, 6 Jan 2023 20:41:43 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 4084B5B72F4;
        Fri,  6 Jan 2023 20:41:40 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <gakula@marvell.com>, <sgoutham@marvell.com>
Subject: [net PATCH] octeontx2-pf: Use GFP_ATOMIC in atomic context
Date:   Sat, 7 Jan 2023 10:11:39 +0530
Message-ID: <20230107044139.25787-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: O1jxXlW2LUljYUlLuwIwi4j2VulCaoBy
X-Proofpoint-ORIG-GUID: O1jxXlW2LUljYUlLuwIwi4j2VulCaoBy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-06_14,2023-01-06_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use GFP_ATOMIC flag instead of GFP_KERNEL while allocating memory
in atomic context.

Fixes: 4af1b64f80fb ("octeontx2-pf: Fix lmtst ID used in aura free")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 88f8772a61cd..12e4365d53df 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -886,7 +886,7 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	}
 
 	sq->sqe_base = sq->sqe->base;
-	sq->sg = kcalloc(qset->sqe_cnt, sizeof(struct sg_list), GFP_KERNEL);
+	sq->sg = kcalloc(qset->sqe_cnt, sizeof(struct sg_list), GFP_ATOMIC);
 	if (!sq->sg)
 		return -ENOMEM;
 
@@ -1378,7 +1378,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 
 		sq = &qset->sq[qidx];
 		sq->sqb_count = 0;
-		sq->sqb_ptrs = kcalloc(num_sqbs, sizeof(*sq->sqb_ptrs), GFP_KERNEL);
+		sq->sqb_ptrs = kcalloc(num_sqbs, sizeof(*sq->sqb_ptrs), GFP_ATOMIC);
 		if (!sq->sqb_ptrs) {
 			err = -ENOMEM;
 			goto err_mem;
-- 
2.25.1

