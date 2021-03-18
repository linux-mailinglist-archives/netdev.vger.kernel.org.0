Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA3B340796
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhCROQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:34 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22398 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231408AbhCROQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IEEfTA027103;
        Thu, 18 Mar 2021 07:15:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=LuHHGQ13NcInR3ji9pCbn7m1TIkGyooLS/NXFKC1UKo=;
 b=TGAGGcYoZv+v6Oas6LEdCEFbkRBhwAzUIIOqR9i/nRV1N8TnrxCiV2fsbtaf6BKbPMIK
 WJQLiuNPBIg8HbMDT4PIQGU2IhD/N5qQsnohWO2FcaHQQUn1fXUMXC3yf68UwerybT9r
 oLQNyvSkXjR06FhH2w4PkNE/YJwdaDWiN8wHVzMr2XYeK91S/a/dpmSMxmHvyXqDtUee
 c9VAFJxdcgFqe/Sy1m9LcJ68TLmyQHGprr2I9JatRgi1bUnO0NbdWFYQ/quDpB0rnnTy
 XfiCIyeephDEcNfTRxWlAc+pvKPQAtJLTamCwC3TiQ02lgQlWuNdEqa0+F/kppptVuFK HA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37b5vdpkaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 07:15:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Mar
 2021 07:15:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Mar 2021 07:15:57 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 0CD463F7041;
        Thu, 18 Mar 2021 07:15:53 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [net PATCH v2 1/8] octeontx2-pf: Do not modify number of rules
Date:   Thu, 18 Mar 2021 19:45:42 +0530
Message-ID: <20210318141549.2622-2-hkelam@marvell.com>
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

From: Subbaraya Sundeep <sbhatta@marvell.com>

In the ETHTOOL_GRXCLSRLALL ioctl ethtool uses
below structure to read number of rules from the driver.

    struct ethtool_rxnfc {
            __u32                           cmd;
            __u32                           flow_type;
            __u64                           data;
            struct ethtool_rx_flow_spec     fs;
            union {
                    __u32                   rule_cnt;
                    __u32                   rss_context;
            };
            __u32                           rule_locs[0];
    };

Driver must not modify rule_cnt member. But currently driver
modifies it by modifying rss_context. Hence fix it by using a
local variable.

Fixes: 81a4362016e7 ("octeontx2-pf: Add RSS multi group support")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 0dbbf38e059..dc177842097 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -257,17 +257,19 @@ int otx2_get_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc,
 int otx2_get_all_flows(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc,
 		       u32 *rule_locs)
 {
+	u32 rule_cnt = nfc->rule_cnt;
 	u32 location = 0;
 	int idx = 0;
 	int err = 0;
 
 	nfc->data = pfvf->flow_cfg->ntuple_max_flows;
-	while ((!err || err == -ENOENT) && idx < nfc->rule_cnt) {
+	while ((!err || err == -ENOENT) && idx < rule_cnt) {
 		err = otx2_get_flow(pfvf, nfc, location);
 		if (!err)
 			rule_locs[idx++] = location;
 		location++;
 	}
+	nfc->rule_cnt = rule_cnt;
 
 	return err;
 }
-- 
2.17.1

