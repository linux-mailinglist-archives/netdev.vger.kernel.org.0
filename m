Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9B028E5A1
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 19:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgJNRn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 13:43:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12504 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726105AbgJNRnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 13:43:55 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09EHgMmB139914;
        Wed, 14 Oct 2020 13:43:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=LyNR4XHlOtdbyiF1zD9cxrvXGu2NMnRAVPspUS1Wr3Y=;
 b=YlHiznfMHFjWVxbk1pXhF+BD2B8mjCL4n14uBSQty8dTazOOzpzRroDdtRWKy0nwhtyO
 EmL/4lZ4Bmn94Wbw9ib0x9niKgi9wZ6wrYXmKGB/+t4gCiv1/6Z5A1nXjRUl/jZPOqBW
 fTPBkVgXgIe30MbyRP5fN3rV2e4HMYcJYZuC1ad3uWUfXYnJRWNa7eaK2KCVZ9+7uHtV
 sCopEMqdGtGwL8ZBFi9UBlosQwromON249r1o+v33lBWIaW0sAXdC5YbtoQGAn/qMkPA
 vOijt76/qgReX48pWGxujXA8M22LIsw/vSRs2/K24p14BD7MQMLLGLdJH/gE/kB2oquY YQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3465y7r1hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Oct 2020 13:43:52 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09EHg4KC032485;
        Wed, 14 Oct 2020 17:43:49 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3434k7vcvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Oct 2020 17:43:49 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09EHhlth27591022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Oct 2020 17:43:47 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDF8552050;
        Wed, 14 Oct 2020 17:43:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9EFFB52052;
        Wed, 14 Oct 2020 17:43:46 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 1/3] net/smc: fix use-after-free of delayed events
Date:   Wed, 14 Oct 2020 19:43:27 +0200
Message-Id: <20201014174329.35791-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201014174329.35791-1-kgraul@linux.ibm.com>
References: <20201014174329.35791-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-14_09:2020-10-14,2020-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=831
 impostorscore=0 suspectscore=3 malwarescore=0 bulkscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010140122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a delayed event is enqueued then the event worker will send this
event the next time it is running and no other flow is currently
active. The event handler is called for the delayed event, and the
pointer to the event keeps set in lgr->delayed_event. This pointer is
cleared later in the processing by smc_llc_flow_start().
This can lead to a use-after-free condition when the processing does not
reach smc_llc_flow_start(), but frees the event because of an error
situation. Then the delayed_event pointer is still set but the event is
freed.
Fix this by always clearing the delayed event pointer when the event is
provided to the event handler for processing, and remove the code to
clear it in smc_llc_flow_start().

Fixes: 555da9af827d ("net/smc: add event-based llc_flow framework")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_llc.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 2db967f2fb50..39039a82f24f 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -233,8 +233,6 @@ static bool smc_llc_flow_start(struct smc_llc_flow *flow,
 	default:
 		flow->type = SMC_LLC_FLOW_NONE;
 	}
-	if (qentry == lgr->delayed_event)
-		lgr->delayed_event = NULL;
 	smc_llc_flow_qentry_set(flow, qentry);
 	spin_unlock_bh(&lgr->llc_flow_lock);
 	return true;
@@ -1603,13 +1601,12 @@ static void smc_llc_event_work(struct work_struct *work)
 	struct smc_llc_qentry *qentry;
 
 	if (!lgr->llc_flow_lcl.type && lgr->delayed_event) {
-		if (smc_link_usable(lgr->delayed_event->link)) {
-			smc_llc_event_handler(lgr->delayed_event);
-		} else {
-			qentry = lgr->delayed_event;
-			lgr->delayed_event = NULL;
+		qentry = lgr->delayed_event;
+		lgr->delayed_event = NULL;
+		if (smc_link_usable(qentry->link))
+			smc_llc_event_handler(qentry);
+		else
 			kfree(qentry);
-		}
 	}
 
 again:
-- 
2.17.1

