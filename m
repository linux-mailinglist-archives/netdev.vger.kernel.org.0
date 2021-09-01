Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA593FD306
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 07:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242053AbhIAFkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 01:40:04 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47944 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231289AbhIAFkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 01:40:03 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18159odg026643;
        Tue, 31 Aug 2021 22:39:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=S5QQLEeGf2BDzZ6+jshRAeCj366WQcLyPRhuwBPPNVw=;
 b=EtwgSfSlOLms6XAjJtigeTruqNo+7PIAEPPBmuFja5TNeLRVlt93lQLZIXKcrBSs8Yi1
 HOK2tJm6j9PW1bN+FAWyof39Qa/S3ArRKNffnP9qLqTCkQW59et/s+YRgioEUWKTYTuh
 jgWZfptBVZIWo3zXmeeh9ZOfzQzA5gIAeSaNCEJh0LdV4WxCny3IIo54wxvMS9KT1lkq
 lHNitvfs3Yy0OFGChZWyaJ/GZvdj5GlhbzKuRO9UwDWeFSqNkeQU3D/5JoNfDMd0TLbB
 RxuCnqzc9yTSKq8zhM2haOxPieZbS9bjQ78TQuQjBNHTUGcdYM0vxI45Dr+QHHyVUm5U 0g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3at34pr2us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 22:39:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 31 Aug
 2021 22:39:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 31 Aug 2021 22:39:03 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 030A13F708F;
        Tue, 31 Aug 2021 22:39:01 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Smadar Fuks <smadarf@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [net-next PATCH] octeontx2-af: Add additional register check to rvu_poll_reg()
Date:   Wed, 1 Sep 2021 11:08:59 +0530
Message-ID: <1630474739-25470-1-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 1g7dVs152_5e0L4-uVWR6OF-f4y43u8d
X-Proofpoint-GUID: 1g7dVs152_5e0L4-uVWR6OF-f4y43u8d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-01_01,2021-08-31_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Smadar Fuks <smadarf@marvell.com>

Check one more time before exiting the API with an error.
Fix API to poll at least twice, in case there are other high priority
tasks and this API doesn't get CPU cycles for multiple jiffies update.

In addition, increase timeout from usecs_to_jiffies(10000) to
usecs_to_jiffies(20000), to prevent the case that for CONFIG_100HZ
timeout will be a single jiffies.
A single jiffies results actual timeout that can be any time between
1usec and 10msec. To solve this, a value of usecs_to_jiffies(20000)
ensures that timeout is 2 jiffies.

Signed-off-by: Smadar Fuks <smadarf@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index ce647e0..72de4ec 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -92,7 +92,8 @@ static void rvu_setup_hw_capabilities(struct rvu *rvu)
  */
 int rvu_poll_reg(struct rvu *rvu, u64 block, u64 offset, u64 mask, bool zero)
 {
-	unsigned long timeout = jiffies + usecs_to_jiffies(10000);
+	unsigned long timeout = jiffies + usecs_to_jiffies(20000);
+	bool twice = false;
 	void __iomem *reg;
 	u64 reg_val;
 
@@ -107,6 +108,15 @@ int rvu_poll_reg(struct rvu *rvu, u64 block, u64 offset, u64 mask, bool zero)
 		usleep_range(1, 5);
 		goto again;
 	}
+	/* In scenarios where CPU is scheduled out before checking
+	 * 'time_before' (above) and gets scheduled in such that
+	 * jiffies are beyond timeout value, then check again if HW is
+	 * done with the operation in the meantime.
+	 */
+	if (!twice) {
+		twice = true;
+		goto again;
+	}
 	return -EBUSY;
 }
 
-- 
2.7.4

