Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74BD3B6873
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 20:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhF1S2G convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 28 Jun 2021 14:28:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51522 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230166AbhF1S2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 14:28:05 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 15SIKjUt011696
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 11:25:38 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 39emg5g2yh-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 11:25:38 -0700
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 11:25:36 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 1D9BFCE608B2; Mon, 28 Jun 2021 11:25:33 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <richardcochran@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH] ptp: Set lookup cookie when creating a PTP PPS source.
Date:   Mon, 28 Jun 2021 11:25:33 -0700
Message-ID: <20210628182533.2930715-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7HGATgW-DbQDzw5zDaeK_z4Drws9p0Lk
X-Proofpoint-GUID: 7HGATgW-DbQDzw5zDaeK_z4Drws9p0Lk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-28_14:2021-06-25,2021-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=919
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 clxscore=1034 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106280120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating a PTP device, the configuration block allows
creation of an associated PPS device.  However, there isn't
any way to associate the two devices after creation.

Set the PPS cookie, so pps_lookup_dev(ptp) performs correctly.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_clock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index c176fa82df85..45429853d60f 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -240,6 +240,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 			pr_err("failed to create ptp aux_worker %d\n", err);
 			goto kworker_err;
 		}
+		ptp->pps_source->lookup_cookie = ptp;
 	}
 
 	err = ptp_populate_pin_groups(ptp);
-- 
2.30.2

