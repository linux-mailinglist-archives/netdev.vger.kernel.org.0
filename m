Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293E61C22A7
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 06:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgEBEG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 00:06:56 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:36472 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbgEBEG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 00:06:56 -0400
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 0423WTur012090;
        Fri, 1 May 2020 23:36:15 -0400
Received: from pbmxdp03.intersil.corp (pbmxdp03.pb.intersil.com [132.158.200.224])
        by pbmsgap02.intersil.com with ESMTP id 30mfccke9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 23:36:15 -0400
Received: from pbmxdp02.intersil.corp (132.158.200.223) by
 pbmxdp03.intersil.corp (132.158.200.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1531.3; Fri, 1 May 2020 23:36:14 -0400
Received: from localhost (132.158.202.109) by pbmxdp02.intersil.corp
 (132.158.200.223) with Microsoft SMTP Server id 15.1.1531.3 via Frontend
 Transport; Fri, 1 May 2020 23:36:13 -0400
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v2 net-next 1/3] ptp: Add adjphase function to support phase offset control.
Date:   Fri, 1 May 2020 23:35:36 -0400
Message-ID: <1588390538-24589-2-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588390538-24589-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1588390538-24589-1-git-send-email-vincent.cheng.xh@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_18:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002250000 definitions=main-2005020027
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
 drivers/ptp/ptp_clock.c          | 3 +++
 include/linux/ptp_clock_kernel.h | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index acabbe7..fc984a8 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -146,6 +146,9 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 		else
 			err = ops->adjfreq(ops, ppb);
 		ptp->dialed_frequency = tx->freq;
+	} else if (tx->modes & ADJ_OFFSET) {
+		if (ops->adjphase)
+			err = ops->adjphase(ops, tx->offset);
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

