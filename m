Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B9D31AA29
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 06:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhBMF3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 00:29:44 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:50584 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhBMF3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 00:29:43 -0500
X-Greylist: delayed 1353 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Feb 2021 00:29:42 EST
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 11D52i4p025400;
        Sat, 13 Feb 2021 00:06:22 -0500
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap02.intersil.com with ESMTP id 36ntxd0ath-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 13 Feb 2021 00:06:22 -0500
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Sat, 13 Feb 2021 00:06:18 -0500
Received: from localhost (132.158.202.108) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Sat, 13 Feb 2021 00:06:17 -0500
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v2 net-next 2/3] ptp: ptp_clockmatrix: Add alignment of 1 PPS to idtcm_perout_enable.
Date:   Sat, 13 Feb 2021 00:06:05 -0500
Message-ID: <1613192766-14010-3-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1613192766-14010-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1613192766-14010-1-git-send-email-vincent.cheng.xh@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-13_01:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 mlxlogscore=912 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102130041
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

When enabling output using PTP_CLK_REQ_PEROUT, need to align the output
clock to the internal 1 PPS clock.

Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_clockmatrix.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 3de8411..a83ba4b 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -1401,13 +1401,23 @@ static int idtcm_perout_enable(struct idtcm_channel *channel,
 			       bool enable,
 			       struct ptp_perout_request *perout)
 {
+	struct idtcm *idtcm = channel->idtcm;
 	unsigned int flags = perout->flags;
+	struct timespec64 ts = {0, 0};
+	int err;
 
 	if (flags == PEROUT_ENABLE_OUTPUT_MASK)
-		return idtcm_output_mask_enable(channel, enable);
+		err = idtcm_output_mask_enable(channel, enable);
+	else
+		err = idtcm_output_enable(channel, enable, perout->index);
+
+	if (err) {
+		dev_err(&idtcm->client->dev, "Unable to set output enable");
+		return err;
+	}
 
-	/* Enable/disable individual output instead */
-	return idtcm_output_enable(channel, enable, perout->index);
+	/* Align output to internal 1 PPS */
+	return _idtcm_settime(channel, &ts, SCSR_TOD_WR_TYPE_SEL_DELTA_PLUS);
 }
 
 static int idtcm_get_pll_mode(struct idtcm_channel *channel,
-- 
2.7.4

