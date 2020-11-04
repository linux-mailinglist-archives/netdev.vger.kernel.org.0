Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE772A7106
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 00:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731876AbgKDXOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 18:14:18 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:33598 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgKDXOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 18:14:18 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 0A4N8kbC024740;
        Wed, 4 Nov 2020 18:14:16 -0500
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap02.intersil.com with ESMTP id 34h23fa5c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 18:14:16 -0500
Received: from pbmxdp01.intersil.corp (132.158.200.222) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Wed, 4 Nov 2020 18:14:14 -0500
Received: from localhost (132.158.202.109) by pbmxdp01.intersil.corp
 (132.158.200.222) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 4 Nov 2020 18:14:14 -0500
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH v2 net-next 3/3] ptp: idt82p33: optimize _idt82p33_adjfine
Date:   Wed, 4 Nov 2020 18:13:46 -0500
Message-ID: <1604531626-17644-3-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604531626-17644-1-git-send-email-min.li.xe@renesas.com>
References: <1604531626-17644-1-git-send-email-min.li.xe@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-04_15:2020-11-04,2020-11-04 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=800 phishscore=0
 suspectscore=4 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011040164
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Use div_s64 so that the neg_adj is not needed.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_idt82p33.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index b1528a0..e970379d 100644
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

