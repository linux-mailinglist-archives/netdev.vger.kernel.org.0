Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39831BED06
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 02:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgD3Ajx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 20:39:53 -0400
Received: from pbmsgap01.intersil.com ([192.157.179.201]:48536 "EHLO
        pbmsgap01.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgD3Ajx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 20:39:53 -0400
Received: from pps.filterd (pbmsgap01.intersil.com [127.0.0.1])
        by pbmsgap01.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 03U0Sq6j007279;
        Wed, 29 Apr 2020 20:28:52 -0400
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap01.intersil.com with ESMTP id 30mgqytds7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 20:28:52 -0400
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1531.3; Wed, 29 Apr 2020 20:28:50 -0400
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1531.3 via Frontend
 Transport; Wed, 29 Apr 2020 20:28:50 -0400
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH net-next 2/3] ptp: Add adjust_phase to ptp_clock_caps capability.
Date:   Wed, 29 Apr 2020 20:28:24 -0400
Message-ID: <1588206505-21773-3-git-send-email-vincent.cheng.xh@renesas.com>
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

Add adjust_phase to ptp_clock_caps capability to allow
user to query if a PHC driver supports adjust phase with
ioctl PTP_CLOCK_GETCAPS command.

Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
---
 drivers/ptp/ptp_chardev.c             | 1 +
 include/uapi/linux/ptp_clock.h        | 4 +++-
 tools/testing/selftests/ptp/testptp.c | 6 ++++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 93d574f..375cd6e 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -136,6 +136,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		caps.pps = ptp->info->pps;
 		caps.n_pins = ptp->info->n_pins;
 		caps.cross_timestamping = ptp->info->getcrosststamp != NULL;
+		caps.adjust_phase = ptp->info->adjphase != NULL;
 		if (copy_to_user((void __user *)arg, &caps, sizeof(caps)))
 			err = -EFAULT;
 		break;
diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 9dc9d00..ff070aa 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -89,7 +89,9 @@ struct ptp_clock_caps {
 	int n_pins;    /* Number of input/output pins. */
 	/* Whether the clock supports precise system-device cross timestamps */
 	int cross_timestamping;
-	int rsv[13];   /* Reserved for future use. */
+	/* Whether the clock supports adjust phase */
+	int adjust_phase;
+	int rsv[12];   /* Reserved for future use. */
 };
 
 struct ptp_extts_request {
diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index c0dd102..da7a9dd 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -269,14 +269,16 @@ int main(int argc, char *argv[])
 			       "  %d programmable periodic signals\n"
 			       "  %d pulse per second\n"
 			       "  %d programmable pins\n"
-			       "  %d cross timestamping\n",
+			       "  %d cross timestamping\n"
+			       "  %d adjust_phase\n",
 			       caps.max_adj,
 			       caps.n_alarm,
 			       caps.n_ext_ts,
 			       caps.n_per_out,
 			       caps.pps,
 			       caps.n_pins,
-			       caps.cross_timestamping);
+			       caps.cross_timestamping,
+			       caps.adjust_phase);
 		}
 	}
 
-- 
2.7.4

