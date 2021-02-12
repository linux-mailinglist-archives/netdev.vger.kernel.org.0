Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDDF319970
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 06:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhBLFJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 00:09:55 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:45328 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhBLFJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 00:09:48 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 11C4dHAT021700;
        Thu, 11 Feb 2021 23:39:17 -0500
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap02.intersil.com with ESMTP id 36hp5k2bh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 23:39:17 -0500
Received: from pbmxdp01.intersil.corp (132.158.200.222) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Thu, 11 Feb 2021 23:39:15 -0500
Received: from localhost (132.158.202.108) by pbmxdp01.intersil.corp
 (132.158.200.222) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 11 Feb 2021 23:39:15 -0500
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH net-next 2/2] ptp: ptp_clockmatrix: Add alignment of 1 PPS to idtcm_perout_enable.
Date:   Thu, 11 Feb 2021 23:38:45 -0500
Message-ID: <1613104725-22056-3-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1613104725-22056-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1613104725-22056-1-git-send-email-vincent.cheng.xh@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=966 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120032
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

When enabling output using PTP_CLK_REQ_PEROUT, need to align the output
clock to the internal 1 PPS clock.

Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 1918de5..ebe540e 100644
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

