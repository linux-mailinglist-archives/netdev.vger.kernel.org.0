Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8A52A8DE8
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 04:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgKFD7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 22:59:53 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:47722 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgKFD7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 22:59:52 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 0A63pf7D009766;
        Thu, 5 Nov 2020 22:52:43 -0500
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap02.intersil.com with ESMTP id 34mk3mgb3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 22:52:42 -0500
Received: from pbmxdp02.intersil.corp (132.158.200.223) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Thu, 5 Nov 2020 22:52:41 -0500
Received: from localhost (132.158.202.109) by pbmxdp02.intersil.corp
 (132.158.200.223) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 5 Nov 2020 22:52:41 -0500
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH v4 net-next 3/3] ptp: idt82p33: optimize _idt82p33_adjfine
Date:   Thu, 5 Nov 2020 22:52:09 -0500
Message-ID: <1604634729-24960-3-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604634729-24960-1-git-send-email-min.li.xe@renesas.com>
References: <1604634729-24960-1-git-send-email-min.li.xe@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_01:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 mlxlogscore=741 phishscore=0
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=4 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060023
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Use div_s64 so that the neg_adj is not needed.

Signed-off-by: Min Li <min.li.xe@renesas.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_idt82p33.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index 223bc11..c1c959f 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -320,7 +320,6 @@ static int _idt82p33_adjfine(struct idt82p33_channel *channel, long scaled_ppm)
 {
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	unsigned char buf[5] = {0};
-	int neg_adj = 0;
 	int err, i;
 	s64 fcw;
 
@@ -340,16 +339,9 @@ static int _idt82p33_adjfine(struct idt82p33_channel *channel, long scaled_ppm)
 	 * FCW = -------------
 	 *         168 * 2^4
 	 */
-	if (scaled_ppm < 0) {
-		neg_adj = 1;
-		scaled_ppm = -scaled_ppm;
-	}
 
 	fcw = scaled_ppm * 244140625ULL;
-	fcw = div_u64(fcw, 2688);
-
-	if (neg_adj)
-		fcw = -fcw;
+	fcw = div_s64(fcw, 2688);
 
 	for (i = 0; i < 5; i++) {
 		buf[i] = fcw & 0xff;
-- 
2.7.4

