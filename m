Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728FE31D548
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 07:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhBQGLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 01:11:07 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:54382 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhBQGLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 01:11:02 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 11H5gn0t032622;
        Wed, 17 Feb 2021 00:42:49 -0500
Received: from pbmxdp03.intersil.corp (pbmxdp03.pb.intersil.com [132.158.200.224])
        by pbmsgap02.intersil.com with ESMTP id 36p9tmscng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 00:42:49 -0500
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp03.intersil.corp (132.158.200.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Wed, 17 Feb 2021 00:42:48 -0500
Received: from localhost (132.158.202.108) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 17 Feb 2021 00:42:47 -0500
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v3 net-next 2/7] ptp: ptp_clockmatrix: Add alignment of 1 PPS to idtcm_perout_enable.
Date:   Wed, 17 Feb 2021 00:42:13 -0500
Message-ID: <1613540538-23792-3-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1613540538-23792-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1613540538-23792-1-git-send-email-vincent.cheng.xh@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_02:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 malwarescore=0 mlxlogscore=914
 spamscore=0 phishscore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170042
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
index 9bfd32b..f597e4f 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -1389,13 +1389,23 @@ static int idtcm_perout_enable(struct idtcm_channel *channel,
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

