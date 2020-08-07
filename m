Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BB023F06F
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 18:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgHGQEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 12:04:53 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:54166 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGQEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 12:04:50 -0400
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 077FrjIF003016;
        Fri, 7 Aug 2020 11:56:21 -0400
Received: from pbmxdp03.intersil.corp (pbmxdp03.pb.intersil.com [132.158.200.224])
        by pbmsgap02.intersil.com with ESMTP id 32n2jctr6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 07 Aug 2020 11:56:21 -0400
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp03.intersil.corp (132.158.200.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Fri, 7 Aug 2020 11:56:20 -0400
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 7 Aug 2020 11:56:19 -0400
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net 1/4] ptp: ptp_idt82p33: update to support adjphase
Date:   Fri, 7 Aug 2020 11:55:55 -0400
Message-ID: <1596815755-10994-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_12:2020-08-06,2020-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2006250000 definitions=main-2008070110
X-Proofpoint-Spam-Reason: mlx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Add adjphase support for idt82p33xxx synchronization management unit.
Also fix n_per_out to the actual number of outputs.

Changes since v1:
- Break into small changes

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_idt82p33.c | 48 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index 179f6c4..bd1fbcd 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -674,6 +674,51 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
 	return err;
 }
 
+static int idt82p33_adjwritephase(struct ptp_clock_info *ptp, s32 offsetNs)
+{
+	struct idt82p33_channel *channel =
+		container_of(ptp, struct idt82p33_channel, caps);
+	struct idt82p33 *idt82p33 = channel->idt82p33;
+	s64 offsetInFs;
+	s64 offsetRegVal;
+	u8 val[4] = {0};
+	int err;
+
+	offsetInFs = (s64)(-offsetNs) * 1000000;
+
+	if (offsetInFs > WRITE_PHASE_OFFSET_LIMIT)
+		offsetInFs = WRITE_PHASE_OFFSET_LIMIT;
+	else if (offsetInFs < -WRITE_PHASE_OFFSET_LIMIT)
+		offsetInFs = -WRITE_PHASE_OFFSET_LIMIT;
+
+	/* Convert from phaseOffsetInFs to register value */
+	offsetRegVal = ((offsetInFs * 1000) / IDT_T0DPLL_PHASE_RESOL);
+
+	val[0] = offsetRegVal & 0xFF;
+	val[1] = (offsetRegVal >> 8) & 0xFF;
+	val[2] = (offsetRegVal >> 16) & 0xFF;
+	val[3] = (offsetRegVal >> 24) & 0x1F;
+	val[3] |= PH_OFFSET_EN;
+
+	mutex_lock(&idt82p33->reg_lock);
+
+	err = idt82p33_dpll_set_mode(channel, PLL_MODE_WPH);
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
+		goto out;
+	}
+
+	err = idt82p33_write(idt82p33, channel->dpll_phase_cnfg, val,
+			     sizeof(val));
+
+out:
+	mutex_unlock(&idt82p33->reg_lock);
+	return err;
+}
+
 static int idt82p33_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct idt82p33_channel *channel =
@@ -784,6 +829,8 @@ static void idt82p33_caps_init(struct ptp_clock_info *caps)
 {
 	caps->owner = THIS_MODULE;
 	caps->max_adj = 92000;
+	caps->n_per_out = 11;
+	caps->adjphase = idt82p33_adjwritephase;
 	caps->adjfine = idt82p33_adjfine;
 	caps->adjtime = idt82p33_adjtime;
 	caps->gettime64 = idt82p33_gettime;
@@ -810,7 +857,6 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 	idt82p33_caps_init(&channel->caps);
 	snprintf(channel->caps.name, sizeof(channel->caps.name),
 		 "IDT 82P33 PLL%u", index);
-	channel->caps.n_per_out = hweight8(channel->output_mask);
 
 	err = idt82p33_dpll_set_mode(channel, PLL_MODE_DCO);
 	if (err)
-- 
2.7.4

