Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF3E409E41
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 22:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244838AbhIMUin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 16:38:43 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:45884 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244538AbhIMUih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 16:38:37 -0400
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 18DK20PC021207;
        Mon, 13 Sep 2021 16:12:52 -0400
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap02.intersil.com with ESMTP id 3b0pmh0skk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 16:12:51 -0400
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2242.4; Mon, 13 Sep 2021 16:12:49 -0400
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.2242.4 via Frontend
 Transport; Mon, 13 Sep 2021 16:12:48 -0400
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net 1/3] ptp: ptp_clockmatrix: Remove idtcm_enable_tod_sync()
Date:   Mon, 13 Sep 2021 16:12:32 -0400
Message-ID: <1631563954-6700-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: m19rQYdHsL1hRJ1ySNAa3Zd_pp4hxV-l
X-Proofpoint-ORIG-GUID: m19rQYdHsL1hRJ1ySNAa3Zd_pp4hxV-l
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-13_09:2021-09-09,2021-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130120
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Not need since TCS firmware file will configure it properlly.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 229 +-----------------------------------------
 1 file changed, 2 insertions(+), 227 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index fa63695..9b1c6b2 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -353,8 +353,8 @@ static int wait_for_sys_apll_dpll_lock(struct idtcm *idtcm)
 		apll &= SYS_APLL_LOSS_LOCK_LIVE_MASK;
 		dpll &= DPLL_SYS_STATE_MASK;
 
-		if (apll == SYS_APLL_LOSS_LOCK_LIVE_LOCKED &&
-		    dpll == DPLL_STATE_LOCKED) {
+		if (apll == SYS_APLL_LOSS_LOCK_LIVE_LOCKED
+		    && dpll == DPLL_STATE_LOCKED) {
 			return 0;
 		} else if (dpll == DPLL_STATE_FREERUN ||
 			   dpll == DPLL_STATE_HOLDOVER ||
@@ -1675,222 +1675,6 @@ static int idtcm_enable(struct ptp_clock_info *ptp,
 	return -EOPNOTSUPP;
 }
 
-static int _enable_pll_tod_sync(struct idtcm *idtcm,
-				u8 pll,
-				u8 sync_src,
-				u8 qn,
-				u8 qn_plus_1)
-{
-	int err;
-	u8 val;
-	u16 dpll;
-	u16 out0 = 0, out1 = 0;
-
-	if (qn == 0 && qn_plus_1 == 0)
-		return 0;
-
-	switch (pll) {
-	case 0:
-		dpll = DPLL_0;
-		if (qn)
-			out0 = OUTPUT_0;
-		if (qn_plus_1)
-			out1 = OUTPUT_1;
-		break;
-	case 1:
-		dpll = DPLL_1;
-		if (qn)
-			out0 = OUTPUT_2;
-		if (qn_plus_1)
-			out1 = OUTPUT_3;
-		break;
-	case 2:
-		dpll = DPLL_2;
-		if (qn)
-			out0 = OUTPUT_4;
-		if (qn_plus_1)
-			out1 = OUTPUT_5;
-		break;
-	case 3:
-		dpll = DPLL_3;
-		if (qn)
-			out0 = OUTPUT_6;
-		if (qn_plus_1)
-			out1 = OUTPUT_7;
-		break;
-	case 4:
-		dpll = DPLL_4;
-		if (qn)
-			out0 = OUTPUT_8;
-		break;
-	case 5:
-		dpll = DPLL_5;
-		if (qn)
-			out0 = OUTPUT_9;
-		if (qn_plus_1)
-			out1 = OUTPUT_8;
-		break;
-	case 6:
-		dpll = DPLL_6;
-		if (qn)
-			out0 = OUTPUT_10;
-		if (qn_plus_1)
-			out1 = OUTPUT_11;
-		break;
-	case 7:
-		dpll = DPLL_7;
-		if (qn)
-			out0 = OUTPUT_11;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	/*
-	 * Enable OUTPUT OUT_SYNC.
-	 */
-	if (out0) {
-		err = idtcm_read(idtcm, out0, OUT_CTRL_1, &val, sizeof(val));
-		if (err)
-			return err;
-
-		val &= ~OUT_SYNC_DISABLE;
-
-		err = idtcm_write(idtcm, out0, OUT_CTRL_1, &val, sizeof(val));
-		if (err)
-			return err;
-	}
-
-	if (out1) {
-		err = idtcm_read(idtcm, out1, OUT_CTRL_1, &val, sizeof(val));
-		if (err)
-			return err;
-
-		val &= ~OUT_SYNC_DISABLE;
-
-		err = idtcm_write(idtcm, out1, OUT_CTRL_1, &val, sizeof(val));
-		if (err)
-			return err;
-	}
-
-	/* enable dpll sync tod pps, must be set before dpll_mode */
-	err = idtcm_read(idtcm, dpll, DPLL_TOD_SYNC_CFG, &val, sizeof(val));
-	if (err)
-		return err;
-
-	val &= ~(TOD_SYNC_SOURCE_MASK << TOD_SYNC_SOURCE_SHIFT);
-	val |= (sync_src << TOD_SYNC_SOURCE_SHIFT);
-	val |= TOD_SYNC_EN;
-
-	return idtcm_write(idtcm, dpll, DPLL_TOD_SYNC_CFG, &val, sizeof(val));
-}
-
-static int idtcm_enable_tod_sync(struct idtcm_channel *channel)
-{
-	struct idtcm *idtcm = channel->idtcm;
-	u8 pll;
-	u8 sync_src;
-	u8 qn;
-	u8 qn_plus_1;
-	u8 cfg;
-	int err = 0;
-	u16 output_mask = channel->output_mask;
-	u8 out8_mux = 0;
-	u8 out11_mux = 0;
-	u8 temp;
-
-	/*
-	 * set tod_out_sync_enable to 0.
-	 */
-	err = idtcm_read(idtcm, channel->tod_n, TOD_CFG, &cfg, sizeof(cfg));
-	if (err)
-		return err;
-
-	cfg &= ~TOD_OUT_SYNC_ENABLE;
-
-	err = idtcm_write(idtcm, channel->tod_n, TOD_CFG, &cfg, sizeof(cfg));
-	if (err)
-		return err;
-
-	switch (channel->tod_n) {
-	case TOD_0:
-		sync_src = 0;
-		break;
-	case TOD_1:
-		sync_src = 1;
-		break;
-	case TOD_2:
-		sync_src = 2;
-		break;
-	case TOD_3:
-		sync_src = 3;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	err = idtcm_read(idtcm, 0, HW_Q8_CTRL_SPARE, &temp, sizeof(temp));
-	if (err)
-		return err;
-
-	if ((temp & Q9_TO_Q8_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK) ==
-	    Q9_TO_Q8_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK)
-		out8_mux = 1;
-
-	err = idtcm_read(idtcm, 0, HW_Q11_CTRL_SPARE, &temp, sizeof(temp));
-	if (err)
-		return err;
-
-	if ((temp & Q10_TO_Q11_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK) ==
-	    Q10_TO_Q11_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK)
-		out11_mux = 1;
-
-	for (pll = 0; pll < 8; pll++) {
-		qn = 0;
-		qn_plus_1 = 0;
-
-		if (pll < 4) {
-			/* First 4 pll has 2 outputs */
-			qn = output_mask & 0x1;
-			output_mask = output_mask >> 1;
-			qn_plus_1 = output_mask & 0x1;
-			output_mask = output_mask >> 1;
-		} else if (pll == 4) {
-			if (out8_mux == 0) {
-				qn = output_mask & 0x1;
-				output_mask = output_mask >> 1;
-			}
-		} else if (pll == 5) {
-			if (out8_mux) {
-				qn_plus_1 = output_mask & 0x1;
-				output_mask = output_mask >> 1;
-			}
-			qn = output_mask & 0x1;
-			output_mask = output_mask >> 1;
-		} else if (pll == 6) {
-			qn = output_mask & 0x1;
-			output_mask = output_mask >> 1;
-			if (out11_mux) {
-				qn_plus_1 = output_mask & 0x1;
-				output_mask = output_mask >> 1;
-			}
-		} else if (pll == 7) {
-			if (out11_mux == 0) {
-				qn = output_mask & 0x1;
-				output_mask = output_mask >> 1;
-			}
-		}
-
-		if (qn != 0 || qn_plus_1 != 0)
-			err = _enable_pll_tod_sync(idtcm, pll, sync_src, qn,
-					       qn_plus_1);
-		if (err)
-			return err;
-	}
-
-	return err;
-}
-
 static int idtcm_enable_tod(struct idtcm_channel *channel)
 {
 	struct idtcm *idtcm = channel->idtcm;
@@ -2101,15 +1885,6 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 	snprintf(channel->caps.name, sizeof(channel->caps.name),
 		 "IDT CM TOD%u", index);
 
-	if (!idtcm->deprecated) {
-		err = idtcm_enable_tod_sync(channel);
-		if (err) {
-			dev_err(&idtcm->client->dev,
-				"Failed at line %d in %s!", __LINE__, __func__);
-			return err;
-		}
-	}
-
 	/* Sync pll mode with hardware */
 	err = idtcm_get_pll_mode(channel, &channel->pll_mode);
 	if (err) {
-- 
2.7.4

