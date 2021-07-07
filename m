Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67ECF3BE041
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 02:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhGGA35 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Jul 2021 20:29:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30718 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229834AbhGGA35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 20:29:57 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1670Jh4g026603
        for <netdev@vger.kernel.org>; Tue, 6 Jul 2021 17:27:18 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39mhtgww8v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 17:27:18 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 6 Jul 2021 17:27:17 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id C57D6D6B0390; Tue,  6 Jul 2021 17:27:12 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <davem@davemloft.net>, <richardcochran@gmail.com>,
        <olteanv@gmail.com>
CC:     <netdev@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] ptp: Relocate lookup cookie to correct block.
Date:   Tue, 6 Jul 2021 17:27:12 -0700
Message-ID: <20210707002712.1896336-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: -b7YwKzp3IkA2j2HfLVRoZXGAPdT-oPz
X-Proofpoint-GUID: -b7YwKzp3IkA2j2HfLVRoZXGAPdT-oPz
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_13:2021-07-06,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 clxscore=1034 spamscore=0 impostorscore=0 adultscore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=847 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An earlier commit set the pps_lookup cookie, but the line
was somehow added to the wrong code block.  Correct this.

Fixes: 8602e40fc813 ("ptp: Set lookup cookie when creating a PTP PPS source.")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index a23a37a4d5dc..7e01f7359081 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -218,7 +218,6 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 			pr_err("failed to create ptp aux_worker %d\n", err);
 			goto kworker_err;
 		}
-		ptp->pps_source->lookup_cookie = ptp;
 	}
 
 	err = ptp_populate_pin_groups(ptp);
@@ -238,6 +237,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 			pr_err("failed to register pps source\n");
 			goto no_pps;
 		}
+		ptp->pps_source->lookup_cookie = ptp;
 	}
 
 	/* Initialize a new device of our class in our clock structure. */
-- 
2.30.2

