Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327FB3C18DB
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 20:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhGHSG6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Jul 2021 14:06:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44064 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230106AbhGHSG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 14:06:57 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 168I17CC019708
        for <netdev@vger.kernel.org>; Thu, 8 Jul 2021 11:04:15 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39p39g1ff6-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 11:04:15 -0700
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 8 Jul 2021 11:04:09 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id BE92DD7EA112; Thu,  8 Jul 2021 11:04:08 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <davem@davemloft.net>, <dariobin@libero.it>,
        <richardcochran@gmail.com>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Subject: [PATCH net] ptp: Relocate lookup cookie to correct block.
Date:   Thu, 8 Jul 2021 11:04:08 -0700
Message-ID: <20210708180408.3930614-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wuZCGBeQhpjjW_q2y8_wHojISgUwghlY
X-Proofpoint-GUID: wuZCGBeQhpjjW_q2y8_wHojISgUwghlY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-08_10:2021-07-08,2021-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 priorityscore=1501 mlxlogscore=830 impostorscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2107080094
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An earlier commit set the pps_lookup cookie, but the line
was somehow added to the wrong code block.  Correct this.

Fixes: 8602e40fc813 ("ptp: Set lookup cookie when creating a PTP PPS source.")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Dario Binacchi <dariobin@libero.it>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index ce6d9fc85607..4dfc52e06704 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -232,7 +232,6 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 			pr_err("failed to create ptp aux_worker %d\n", err);
 			goto kworker_err;
 		}
-		ptp->pps_source->lookup_cookie = ptp;
 	}
 
 	/* PTP virtual clock is being registered under physical clock */
@@ -268,6 +267,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 			pr_err("failed to register pps source\n");
 			goto no_pps;
 		}
+		ptp->pps_source->lookup_cookie = ptp;
 	}
 
 	/* Initialize a new device of our class in our clock structure. */
-- 
2.30.2

