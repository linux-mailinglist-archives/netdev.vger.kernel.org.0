Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BAA23F06D
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 18:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgHGQEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 12:04:41 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:54088 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGQEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 12:04:39 -0400
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 077FvuCV005868;
        Fri, 7 Aug 2020 11:59:01 -0400
Received: from pbmxdp02.intersil.corp (pbmxdp02.pb.intersil.com [132.158.200.223])
        by pbmsgap02.intersil.com with ESMTP id 32n2jctr7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 07 Aug 2020 11:59:01 -0400
Received: from pbmxdp01.intersil.corp (132.158.200.222) by
 pbmxdp02.intersil.corp (132.158.200.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Fri, 7 Aug 2020 11:58:59 -0400
Received: from localhost (132.158.202.109) by pbmxdp01.intersil.corp
 (132.158.200.222) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 7 Aug 2020 11:58:59 -0400
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net 4/4] ptp: ptp_idt82p33: support individually configure output by index
Date:   Fri, 7 Aug 2020 11:58:23 -0400
Message-ID: <1596815903-11144-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_12:2020-08-06,2020-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=835
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2006250000 definitions=main-2008070110
X-Proofpoint-Spam-Reason: mlx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Enable/disable individual output by index instead of by output_mask

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_idt82p33.c | 62 ++++++++++++++++++++++++++++++++++------------
 drivers/ptp/ptp_idt82p33.h |  2 ++
 2 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index 2d62aed..b3c82d7 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -578,33 +578,46 @@ static long idt82p33_sync_tod_work_handler(struct ptp_clock_info *ptp)
 	return ret;
 }
 
-static int idt82p33_pps_enable(struct idt82p33_channel *channel, bool enable)
+static int idt82p33_output_enable(struct idt82p33_channel *channel,
+				  bool enable, unsigned int outn)
 {
 	struct idt82p33 *idt82p33 = channel->idt82p33;
-	u8 mask, outn, val;
 	int err;
+	u8 val;
+
+	err = idt82p33_read(idt82p33, OUT_MUX_CNFG(outn), &val, sizeof(val));
+
+	if (err)
+		return err;
+
+	if (enable)
+		val &= ~SQUELCH_ENABLE;
+	else
+		val |= SQUELCH_ENABLE;
+
+	return idt82p33_write(idt82p33, OUT_MUX_CNFG(outn), &val, sizeof(val));
+}
+
+static int idt82p33_output_mask_enable(struct idt82p33_channel *channel,
+				       bool enable)
+{
+	u16 mask;
+	int err;
+	u8 outn;
 
 	mask = channel->output_mask;
 	outn = 0;
 
 	while (mask) {
-		if (mask & 0x1) {
-			err = idt82p33_read(idt82p33, OUT_MUX_CNFG(outn),
-					    &val, sizeof(val));
-			if (err)
-				return err;
 
-			if (enable)
-				val &= ~SQUELCH_ENABLE;
-			else
-				val |= SQUELCH_ENABLE;
+		if (mask & 0x1) {
 
-			err = idt82p33_write(idt82p33, OUT_MUX_CNFG(outn),
-					     &val, sizeof(val));
+			err = idt82p33_output_enable(channel, enable, outn);
 
 			if (err)
 				return err;
 		}
+
 		mask >>= 0x1;
 		outn++;
 	}
@@ -612,6 +625,20 @@ static int idt82p33_pps_enable(struct idt82p33_channel *channel, bool enable)
 	return 0;
 }
 
+static int idt82p33_perout_enable(struct idt82p33_channel *channel,
+				  bool enable,
+				  struct ptp_perout_request *perout)
+{
+	unsigned int flags = perout->flags;
+
+	/* Enable/disable output based on output_mask */
+	if (flags == PEROUT_ENABLE_OUTPUT_MASK)
+		return idt82p33_output_mask_enable(channel, enable);
+
+	/* Enable/disable individual output instead */
+	return idt82p33_output_enable(channel, enable, perout->index);
+}
+
 static int idt82p33_enable_tod(struct idt82p33_channel *channel)
 {
 	struct idt82p33 *idt82p33 = channel->idt82p33;
@@ -625,7 +652,8 @@ static int idt82p33_enable_tod(struct idt82p33_channel *channel)
 	if (err)
 		return err;
 
-	err = idt82p33_pps_enable(channel, false);
+	if (0)
+		err = idt82p33_output_mask_enable(channel, false);
 
 	if (err) {
 		dev_err(&idt82p33->client->dev,
@@ -681,14 +709,16 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
 
 	if (rq->type == PTP_CLK_REQ_PEROUT) {
 		if (!on)
-			err = idt82p33_pps_enable(channel, false);
+			err = idt82p33_perout_enable(channel, false,
+						     &rq->perout);
 
 		/* Only accept a 1-PPS aligned to the second. */
 		else if (rq->perout.start.nsec || rq->perout.period.sec != 1 ||
 		    rq->perout.period.nsec) {
 			err = -ERANGE;
 		} else
-			err = idt82p33_pps_enable(channel, true);
+			err = idt82p33_perout_enable(channel, true,
+						     &rq->perout);
 	}
 
 	mutex_unlock(&idt82p33->reg_lock);
diff --git a/drivers/ptp/ptp_idt82p33.h b/drivers/ptp/ptp_idt82p33.h
index 1dcd2c0..5008998 100644
--- a/drivers/ptp/ptp_idt82p33.h
+++ b/drivers/ptp/ptp_idt82p33.h
@@ -56,6 +56,8 @@
 #define PLL_MODE_SHIFT                    (0)
 #define PLL_MODE_MASK                     (0x1F)
 
+#define PEROUT_ENABLE_OUTPUT_MASK         (0xdeadbeef)
+
 enum pll_mode {
 	PLL_MODE_MIN = 0,
 	PLL_MODE_AUTOMATIC = PLL_MODE_MIN,
-- 
2.7.4

