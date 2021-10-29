Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5867944053E
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 00:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhJ2WFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 18:05:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19550 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231173AbhJ2WFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 18:05:53 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TLMqeT024988
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:03:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VdHMLlEDdRZPQ+W7xtmeX7Wv4h4W5Tlq68lrOb4Xb4Q=;
 b=pgfRh7+AW4VRCXxWvQMBVCnvi8uSl94Oz9f0Hb8YmENBOKoRhdMz4j9WkV8w46Xt8s7/
 5OXSlybc06sEOKdJOK5hi59MggG03vAw4jgt3CTZahN8KpoI1pHlehDMmymymQMR3tk0
 uP9vDFGg+ozcBzuugE99BL1aO031R28S7+gu+v0Y3Xpjg0iPCg4+CzHzd9lvoSSPLZcT
 RPpPDB2f4ThTSSGvrNqLjKhpZzrmYd9f97WWOcbuiNi+t+cZgWBIjRoXqH9koTPxdS/F
 0bZsfZ4XlX2eXI0SKMRLnFc3fFHtyFsX/xhDJ9XJauJaaO4VYAhpsnzhiRgfO1RXE1Gl nQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c0rtsgm2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:03:24 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19TLviIC030178
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:03:23 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 3bx4f9ps1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:03:23 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19TM3Kqc26542458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Oct 2021 22:03:20 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75C9EB2065;
        Fri, 29 Oct 2021 22:03:20 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71072B2064;
        Fri, 29 Oct 2021 22:03:19 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.240.170])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 29 Oct 2021 22:03:19 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        abdhalee@in.ibm.com, vaish123@in.ibm.com
Subject: [PATCH net 2/3] ibmvnic: Process crqs after enabling interrupts
Date:   Fri, 29 Oct 2021 15:03:15 -0700
Message-Id: <20211029220316.2003519-2-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029220316.2003519-1-sukadev@linux.ibm.com>
References: <20211029220316.2003519-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oMWQidJdDnNxoZPm9jCErnrz_KaO6bHQ
X-Proofpoint-GUID: oMWQidJdDnNxoZPm9jCErnrz_KaO6bHQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_06,2021-10-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=862 phishscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 spamscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110290123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Soon after registering a CRQ it is possible that we get a fail over or
maybe a CRQ_INIT from the VIOS while interrupts were disabled.

Look for any such CRQs after enabling interrupts.

Otherwise we can intermittently fail to bring up ibmvnic adapters during
boot, specially in kexec/kdump kernels.

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Reported-by: Vaishnavi Bhat <vaish123@in.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index a1533979c670..50956f622b11 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5611,6 +5611,9 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter)
 	crq->cur = 0;
 	spin_lock_init(&crq->lock);
 
+	/* process any CRQs that were queued before we enabled interrupts */
+	tasklet_schedule(&adapter->tasklet);
+
 	return retrc;
 
 req_irq_failed:
-- 
2.26.2

