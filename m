Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42EB5118DC5
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 17:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfLJQjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 11:39:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45806 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727597AbfLJQjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 11:39:51 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBAGdYkq001342
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 08:39:50 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wt9vc9eyq-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 08:39:50 -0800
Received: from intmgw001.05.ash5.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 10 Dec 2019 08:39:48 -0800
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 8379F76437D0; Tue, 10 Dec 2019 08:39:46 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <michael.chan@broadcom.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH net] bnxt: apply computed clamp value for coalece parameter
Date:   Tue, 10 Dec 2019 08:39:46 -0800
Message-ID: <20191210163946.2887753-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_05:2019-12-10,2019-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 adultscore=0 spamscore=0 clxscore=1034 mlxlogscore=771
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912100142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After executing "ethtool -C eth0 rx-usecs-irq 0", the box becomes
unresponsive, likely due to interrupt livelock.  It appears that
a minimum clamp value for the irq timer is computed, but is never
applied.

Fix by applying the corrected clamp value.

Fixes: 74706afa712d ("bnxt_en: Update interrupt coalescing logic.")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 85983f0e3134..38bf38342af9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6186,7 +6186,7 @@ static void bnxt_hwrm_set_coal_params(struct bnxt *bp,
 		tmr = bnxt_usec_to_coal_tmr(bp, hw_coal->coal_ticks_irq);
 		val = clamp_t(u16, tmr, 1,
 			      coal_cap->cmpl_aggr_dma_tmr_during_int_max);
-		req->cmpl_aggr_dma_tmr_during_int = cpu_to_le16(tmr);
+		req->cmpl_aggr_dma_tmr_during_int = cpu_to_le16(val);
 		req->enables |=
 			cpu_to_le16(BNXT_COAL_CMPL_AGGR_TMR_DURING_INT_ENABLE);
 	}
-- 
2.17.1

