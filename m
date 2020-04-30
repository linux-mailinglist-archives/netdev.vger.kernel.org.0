Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF461BED12
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 02:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgD3ApL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 20:45:11 -0400
Received: from pbmsgap01.intersil.com ([192.157.179.201]:48772 "EHLO
        pbmsgap01.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgD3ApL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 20:45:11 -0400
Received: from pps.filterd (pbmsgap01.intersil.com [127.0.0.1])
        by pbmsgap01.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 03U0P6iC005024;
        Wed, 29 Apr 2020 20:28:50 -0400
Received: from pbmxdp02.intersil.corp (pbmxdp02.pb.intersil.com [132.158.200.223])
        by pbmsgap01.intersil.com with ESMTP id 30mgqytds6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 20:28:50 -0400
Received: from pbmxdp02.intersil.corp (132.158.200.223) by
 pbmxdp02.intersil.corp (132.158.200.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1531.3; Wed, 29 Apr 2020 20:28:48 -0400
Received: from localhost (132.158.202.109) by pbmxdp02.intersil.corp
 (132.158.200.223) with Microsoft SMTP Server id 15.1.1531.3 via Frontend
 Transport; Wed, 29 Apr 2020 20:28:48 -0400
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH net-next 1/3] ptp: Add adjphase function to support phase offset control.
Date:   Wed, 29 Apr 2020 20:28:23 -0400
Message-ID: <1588206505-21773-2-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588206505-21773-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1588206505-21773-1-git-send-email-vincent.cheng.xh@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_11:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002250000 definitions=main-2004300000
X-Proofpoint-Spam-Reason: mlx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

Adds adjust phase function to take advantage of a PHC
clock's hardware filtering capability that uses phase offset
control word instead of frequency offset control word.

Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
---
 drivers/ptp/ptp_clock.c          | 2 ++
 include/linux/ptp_clock_kernel.h | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index acabbe7..c46ff98 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -146,6 +146,8 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 		else
 			err = ops->adjfreq(ops, ppb);
 		ptp->dialed_frequency = tx->freq;
+	} else if (tx->modes & ADJ_OFFSET) {
+		err = ops->adjphase(ops, tx->offset);
 	} else if (tx->modes == 0) {
 		tx->freq = ptp->dialed_frequency;
 		err = 0;
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 121a7ed..31144d9 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -36,7 +36,7 @@ struct ptp_system_timestamp {
 };
 
 /**
- * struct ptp_clock_info - decribes a PTP hardware clock
+ * struct ptp_clock_info - describes a PTP hardware clock
  *
  * @owner:     The clock driver should set to THIS_MODULE.
  * @name:      A short "friendly name" to identify the clock and to
@@ -65,6 +65,9 @@ struct ptp_system_timestamp {
  *            parameter delta: Desired frequency offset from nominal frequency
  *            in parts per billion
  *
+ * @adjphase:  Adjusts the phase offset of the hardware clock.
+ *             parameter delta: Desired change in nanoseconds.
+ *
  * @adjtime:  Shifts the time of the hardware clock.
  *            parameter delta: Desired change in nanoseconds.
  *
@@ -128,6 +131,7 @@ struct ptp_clock_info {
 	struct ptp_pin_desc *pin_config;
 	int (*adjfine)(struct ptp_clock_info *ptp, long scaled_ppm);
 	int (*adjfreq)(struct ptp_clock_info *ptp, s32 delta);
+	int (*adjphase)(struct ptp_clock_info *ptp, s32 phase);
 	int (*adjtime)(struct ptp_clock_info *ptp, s64 delta);
 	int (*gettime64)(struct ptp_clock_info *ptp, struct timespec64 *ts);
 	int (*gettimex64)(struct ptp_clock_info *ptp, struct timespec64 *ts,
-- 
2.7.4

