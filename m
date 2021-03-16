Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD9433D0BA
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhCPJ1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:27:47 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54544 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232787AbhCPJ1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:27:24 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G9QNKM020140;
        Tue, 16 Mar 2021 02:27:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=aBKshvZZroJOJEqPn8DNQ+OxB+2otzs6b0zWYi9jYNU=;
 b=W+zo528R6VVODVQxIhFhk55Sgoa056kiYssn1G4dRmZK3a9U7z4QeuAJvf6XNXdwWz79
 A8nirKUtioka+GHBXMeaVS+ZTXpwuNsPOzRi1LAjs2tFdX3NXFoekrecUvub+geLC/fv
 Uu6Ef1v8mCKJWOoFm2FzakFeIA92UV6yNj6LJtjZ0syOdcN9f9GLdFewNiXuFUydvLUV
 OgsyZx/yyRb/jzrbHSLfigDG5KRuayQ7FXJl3m+eKP32kbpl5zeitA+EaWYFwVLFrLxA
 LA/a45hR7lbSYJfDF10L1HP9WhDpw0p/JYUJUxb7dJR6sbeSssSGnLEzmAzdKcXidP/e ww== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0a-0016f401.pphosted.com with ESMTP id 378umtfrb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 02:27:23 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Mar 2021 05:27:21 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Mar 2021 05:27:21 -0400
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id 42A5A3F7041;
        Tue, 16 Mar 2021 02:27:18 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 1/9] octeontx2-pf: Do not modify number of rules
Date:   Tue, 16 Mar 2021 14:57:05 +0530
Message-ID: <1615886833-71688-2-git-send-email-hkelam@marvell.com>
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

Fixes: 81a43620("octeontx2-pf: Add RSS multi group support")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 0dbbf38..dc17784 100644
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
2.7.4

