Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389F33EE5C8
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237609AbhHQEp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:45:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50562 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234202AbhHQEpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:45:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2lb4I006738;
        Mon, 16 Aug 2021 21:45:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=fNJs4JDlUA+8NjIruZkwnyA+tZ9fs2MhscOYpD2uMUM=;
 b=jUrwsTS1eHu6uWVCPIy5Wie7pRvlqGHnZEQhH+KWHGOIfcnqAUVp+jthA6bzFM+dlGbA
 t6+LN96MZ3Si9RaDKZ7F0l7KZfZ8uLctJ+k5fFebB5m34WaxmvVDlpajEu/9iRGa0cFF
 K4tH7PB8OA9NvaWqTT2C7NFLiFObUhJrL3EfWN/ottfaXwRmT96NPqMQV0e4tkG69oqP
 0L07NuYcXNWTV+pkIUZzMaw8xgnvrXBMHiCL6/rJiswm1DAa9Kq2/YyyvklFagB5bRnR
 a6I+I0D9S9dJbp8Dhu95StKro9BTckciugRxiu9bK4aiSwfT13v6r9QAkH65n34xvDUl qQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0ra50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 21:45:17 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 21:45:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 21:45:16 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 085313F70B7;
        Mon, 16 Aug 2021 21:45:13 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 06/11] octeontx2-pf: Sort the allocated MCAM entry indices
Date:   Tue, 17 Aug 2021 10:14:48 +0530
Message-ID: <1629175493-4895-7-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
References: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: OnIKRHejGP8EZfR2R8BjJFXwsYRRMsek
X-Proofpoint-ORIG-GUID: OnIKRHejGP8EZfR2R8BjJFXwsYRRMsek
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Per single mailbox request a maximum of 256 MCAM entries
can be allocated. If more than 256 are being allocated, then
the mcam indices in the final list could get jumbled. Hence
sort the indices.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index a0c4b73..96e1158 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -5,6 +5,7 @@
  */
 
 #include <net/ipv6.h>
+#include <linux/sort.h>
 
 #include "otx2_common.h"
 
@@ -61,6 +62,11 @@ static int otx2_free_ntuple_mcam_entries(struct otx2_nic *pfvf)
 	return 0;
 }
 
+static int mcam_entry_cmp(const void *a, const void *b)
+{
+	return *(u16 *)a - *(u16 *)b;
+}
+
 static int otx2_alloc_ntuple_mcam_entries(struct otx2_nic *pfvf, u16 count)
 {
 	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
@@ -120,6 +126,15 @@ static int otx2_alloc_ntuple_mcam_entries(struct otx2_nic *pfvf, u16 count)
 			break;
 	}
 
+	/* Multiple MCAM entry alloc requests could result in non-sequential
+	 * MCAM entries in the flow_ent[] array. Sort them in an ascending order,
+	 * otherwise user installed ntuple filter index and MCAM entry index will
+	 * not be in sync.
+	 */
+	if (allocated)
+		sort(&flow_cfg->flow_ent[0], allocated,
+		     sizeof(flow_cfg->flow_ent[0]), mcam_entry_cmp, NULL);
+
 exit:
 	mutex_unlock(&pfvf->mbox.lock);
 
-- 
2.7.4

