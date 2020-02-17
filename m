Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89339161614
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgBQPZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:25:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728791AbgBQPZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:25:09 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HFKRrG073968
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 10:25:08 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y7uafne3q-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 10:25:07 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <ubraun@linux.ibm.com>;
        Mon, 17 Feb 2020 15:25:05 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 15:25:03 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01HFOxPW60424246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 15:25:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2608A4053;
        Mon, 17 Feb 2020 15:24:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F751A4057;
        Mon, 17 Feb 2020 15:24:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Feb 2020 15:24:59 +0000 (GMT)
From:   Ursula Braun <ubraun@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com
Subject: [PATCH net-next 6/6] net/smc: reduce port_event scheduling
Date:   Mon, 17 Feb 2020 16:24:55 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200217152455.15341-1-ubraun@linux.ibm.com>
References: <20200217152455.15341-1-ubraun@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20021715-0012-0000-0000-00000387A8C7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021715-0013-0000-0000-000021C43652
Message-Id: <20200217152455.15341-7-ubraun@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_10:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=1
 adultscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002170126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IB event handlers schedule the port event worker for further
processing of port state changes. This patch reduces the number of
schedules to avoid duplicate processing of the same port change.

Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_ib.c | 44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 548632621f4b..6756bd5a3fe4 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -257,6 +257,7 @@ static void smc_ib_global_event_handler(struct ib_event_handler *handler,
 					struct ib_event *ibevent)
 {
 	struct smc_ib_device *smcibdev;
+	bool schedule = false;
 	u8 port_idx;
 
 	smcibdev = container_of(handler, struct smc_ib_device, event_handler);
@@ -266,22 +267,35 @@ static void smc_ib_global_event_handler(struct ib_event_handler *handler,
 		/* terminate all ports on device */
 		for (port_idx = 0; port_idx < SMC_MAX_PORTS; port_idx++) {
 			set_bit(port_idx, &smcibdev->port_event_mask);
-			set_bit(port_idx, smcibdev->ports_going_away);
+			if (!test_and_set_bit(port_idx,
+					      smcibdev->ports_going_away))
+				schedule = true;
 		}
-		schedule_work(&smcibdev->port_event_work);
+		if (schedule)
+			schedule_work(&smcibdev->port_event_work);
 		break;
-	case IB_EVENT_PORT_ERR:
 	case IB_EVENT_PORT_ACTIVE:
-	case IB_EVENT_GID_CHANGE:
 		port_idx = ibevent->element.port_num - 1;
-		if (port_idx < SMC_MAX_PORTS) {
-			set_bit(port_idx, &smcibdev->port_event_mask);
-			if (ibevent->event == IB_EVENT_PORT_ERR)
-				set_bit(port_idx, smcibdev->ports_going_away);
-			else if (ibevent->event == IB_EVENT_PORT_ACTIVE)
-				clear_bit(port_idx, smcibdev->ports_going_away);
+		if (port_idx >= SMC_MAX_PORTS)
+			break;
+		set_bit(port_idx, &smcibdev->port_event_mask);
+		if (test_and_clear_bit(port_idx, smcibdev->ports_going_away))
+			schedule_work(&smcibdev->port_event_work);
+		break;
+	case IB_EVENT_PORT_ERR:
+		port_idx = ibevent->element.port_num - 1;
+		if (port_idx >= SMC_MAX_PORTS)
+			break;
+		set_bit(port_idx, &smcibdev->port_event_mask);
+		if (!test_and_set_bit(port_idx, smcibdev->ports_going_away))
 			schedule_work(&smcibdev->port_event_work);
-		}
+		break;
+	case IB_EVENT_GID_CHANGE:
+		port_idx = ibevent->element.port_num - 1;
+		if (port_idx >= SMC_MAX_PORTS)
+			break;
+		set_bit(port_idx, &smcibdev->port_event_mask);
+		schedule_work(&smcibdev->port_event_work);
 		break;
 	default:
 		break;
@@ -316,11 +330,11 @@ static void smc_ib_qp_event_handler(struct ib_event *ibevent, void *priv)
 	case IB_EVENT_QP_FATAL:
 	case IB_EVENT_QP_ACCESS_ERR:
 		port_idx = ibevent->element.qp->port - 1;
-		if (port_idx < SMC_MAX_PORTS) {
-			set_bit(port_idx, &smcibdev->port_event_mask);
-			set_bit(port_idx, smcibdev->ports_going_away);
+		if (port_idx >= SMC_MAX_PORTS)
+			break;
+		set_bit(port_idx, &smcibdev->port_event_mask);
+		if (!test_and_set_bit(port_idx, smcibdev->ports_going_away))
 			schedule_work(&smcibdev->port_event_work);
-		}
 		break;
 	default:
 		break;
-- 
2.17.1

