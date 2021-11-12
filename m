Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D8444EEB3
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 22:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235769AbhKLVkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 16:40:01 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:42370 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231877AbhKLVkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 16:40:00 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACLRwPi012062;
        Fri, 12 Nov 2021 21:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=d1lGqHJfp9iDyZ8E0/zjp0VCoYYJbbfieFElyNwKPjo=;
 b=rRq/AohDaW5BF9uc3M4hGAa5NsLOpYce04jpsitFTa7PQcbDrcKK9Im724rc7nkEJUmz
 cpnIEc8/o4UkPL/NAdEokXmFE6nTOlnmc8JydgG32rHihluOk0H+5PltR9sJK9TtsUtn
 SlliYgMretoz+us9In9wLQcohu1qrPAH5GpKIc+UftiywmiHcwcwZTkNdDuMpR9lSzze
 yoK6M3uBcSQ1iCMl7yfSJcyT3nUruQVW1MKBrbT2mJhUPzk3oz8E5lZjbjON7CAasjlQ
 DpivgX8pEjLoCNV9Iq8kCvi9eSC7Hgsmvnw+2GPrb8Z43tPkGKEbX3/CNtHE9gJQVLpT 7w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c9qx3u41s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Nov 2021 21:36:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ACLPx4a063230;
        Fri, 12 Nov 2021 21:36:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3c842fsnnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Nov 2021 21:36:53 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1ACLaqCA101242;
        Fri, 12 Nov 2021 21:36:53 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by userp3030.oracle.com with ESMTP id 3c842fsnn1-1;
        Fri, 12 Nov 2021 21:36:52 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     harshit.m.mogalapalli@oracle.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: sched: sch_netem: Refactor code in 4-state loss generator
Date:   Fri, 12 Nov 2021 13:36:47 -0800
Message-Id: <20211112213647.18062-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: bzSd5YDqMe56sGWhhXzuedA4NNDH2dZp
X-Proofpoint-GUID: bzSd5YDqMe56sGWhhXzuedA4NNDH2dZp
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed comments to match description with variable names and
refactored code to match the convention as per [1].

To match the convention mapping is done as follows:
State 3 - LOST_IN_BURST_PERIOD
State 4 - LOST_IN_GAP_PERIOD

[1] S. Salsano, F. Ludovici, A. Ordine, "Definition of a general
and intuitive loss model for packet networks and its implementation
in the Netem module in the Linux kernel"

Fixes: a6e2fe17eba4 ("sch_netem: replace magic numbers with enumerate")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
 net/sched/sch_netem.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index ecbb10db1111..ed4ccef5d6a8 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -208,17 +208,17 @@ static bool loss_4state(struct netem_sched_data *q)
 	 * next state and if the next packet has to be transmitted or lost.
 	 * The four states correspond to:
 	 *   TX_IN_GAP_PERIOD => successfully transmitted packets within a gap period
-	 *   LOST_IN_BURST_PERIOD => isolated losses within a gap period
-	 *   LOST_IN_GAP_PERIOD => lost packets within a burst period
-	 *   TX_IN_GAP_PERIOD => successfully transmitted packets within a burst period
+	 *   LOST_IN_GAP_PERIOD => isolated losses within a gap period
+	 *   LOST_IN_BURST_PERIOD => lost packets within a burst period
+	 *   TX_IN_BURST_PERIOD => successfully transmitted packets within a burst period
 	 */
 	switch (clg->state) {
 	case TX_IN_GAP_PERIOD:
 		if (rnd < clg->a4) {
-			clg->state = LOST_IN_BURST_PERIOD;
+			clg->state = LOST_IN_GAP_PERIOD;
 			return true;
 		} else if (clg->a4 < rnd && rnd < clg->a1 + clg->a4) {
-			clg->state = LOST_IN_GAP_PERIOD;
+			clg->state = LOST_IN_BURST_PERIOD;
 			return true;
 		} else if (clg->a1 + clg->a4 < rnd) {
 			clg->state = TX_IN_GAP_PERIOD;
@@ -227,24 +227,24 @@ static bool loss_4state(struct netem_sched_data *q)
 		break;
 	case TX_IN_BURST_PERIOD:
 		if (rnd < clg->a5) {
-			clg->state = LOST_IN_GAP_PERIOD;
+			clg->state = LOST_IN_BURST_PERIOD;
 			return true;
 		} else {
 			clg->state = TX_IN_BURST_PERIOD;
 		}
 
 		break;
-	case LOST_IN_GAP_PERIOD:
+	case LOST_IN_BURST_PERIOD:
 		if (rnd < clg->a3)
 			clg->state = TX_IN_BURST_PERIOD;
 		else if (clg->a3 < rnd && rnd < clg->a2 + clg->a3) {
 			clg->state = TX_IN_GAP_PERIOD;
 		} else if (clg->a2 + clg->a3 < rnd) {
-			clg->state = LOST_IN_GAP_PERIOD;
+			clg->state = LOST_IN_BURST_PERIOD;
 			return true;
 		}
 		break;
-	case LOST_IN_BURST_PERIOD:
+	case LOST_IN_GAP_PERIOD:
 		clg->state = TX_IN_GAP_PERIOD;
 		break;
 	}
-- 
2.27.0

