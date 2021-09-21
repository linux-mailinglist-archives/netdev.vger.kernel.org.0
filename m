Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86734135A4
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 16:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbhIUOx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 10:53:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35044 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233784AbhIUOx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 10:53:57 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LE9cJd011320;
        Tue, 21 Sep 2021 10:52:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=km1rTew9P7HfOTnAh0PTyHk+Mzy0LmoYrZdRyM0Mpn4=;
 b=mRzgpk2xL7V+NEdeJpBz/m7oZKE/VeA4T4teDnHMQ0xUH0eKh3Og9HzS5qWNKG+gCO7p
 H9+Bpnw0DS6Jj3xQWGPqEGYvPtTU2Kax0VJMHZ7TpZfzlPm2BQrmqTkDrBWJB8yEZ9FB
 CKk/4bDPzYv17uukBO9yuDFC95SsVNxcoMYPts4368nAPbydEjKdX9tmK2QBH/zsHwdK
 8DupZWkWKBZ0Nw2w8gV+dfZyH7vOk440mSZhxnH4plqf2c2jkcZaokkEehM2Rbo8JLzh
 RnAjs8zG3Kz+bt2lbngNRHmu9fRXTBkbscIZh2ygvI3ZTlEGlf5vaMA5yAqATbPUPYC1 eQ== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7e4rxkvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 10:52:25 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18LEnEjD003777;
        Tue, 21 Sep 2021 14:52:23 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3b57cjnex4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 14:52:23 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18LElYIE59441650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 14:47:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29BA952067;
        Tue, 21 Sep 2021 14:52:19 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C4C385204E;
        Tue, 21 Sep 2021 14:52:18 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>
Subject: [PATCH net 1/3] s390/qeth: fix NULL deref in qeth_clear_working_pool_list()
Date:   Tue, 21 Sep 2021 16:52:15 +0200
Message-Id: <20210921145217.1584654-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210921145217.1584654-1-jwi@linux.ibm.com>
References: <20210921145217.1584654-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: J7uUZVdeAlj9wIWBGhZdytcOnE61Pwhh
X-Proofpoint-ORIG-GUID: J7uUZVdeAlj9wIWBGhZdytcOnE61Pwhh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-21_04,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109210089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When qeth_set_online() calls qeth_clear_working_pool_list() to roll
back after an error exit from qeth_hardsetup_card(), we are at risk of
accessing card->qdio.in_q before it was allocated by
qeth_alloc_qdio_queues() via qeth_mpc_initialize().

qeth_clear_working_pool_list() then dereferences NULL, and by writing to
queue->bufs[i].pool_entry scribbles all over the CPU's lowcore.
Resulting in a crash when those lowcore areas are used next (eg. on
the next machine-check interrupt).

Such a scenario would typically happen when the device is first set
online and its queues aren't allocated yet. An early IO error or certain
misconfigs (eg. mismatched transport mode, bad portno) then cause us to
error out from qeth_hardsetup_card() with card->qdio.in_q still being
NULL.

Fix it by checking the pointer for NULL before accessing it.

Note that we also have (rare) paths inside qeth_mpc_initialize() where
a configuration change can cause us to free the existing queues,
expecting that subsequent code will allocate them again. If we then
error out before that re-allocation happens, the same bug occurs.

Fixes: eff73e16ee11 ("s390/qeth: tolerate pre-filled RX buffer")
Reported-by: Stefan Raspl <raspl@linux.ibm.com>
Root-caused-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 41ca6273b750..3fba440a0731 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -202,6 +202,9 @@ static void qeth_clear_working_pool_list(struct qeth_card *card)
 				 &card->qdio.in_buf_pool.entry_list, list)
 		list_del(&pool_entry->list);
 
+	if (!queue)
+		return;
+
 	for (i = 0; i < ARRAY_SIZE(queue->bufs); i++)
 		queue->bufs[i].pool_entry = NULL;
 }
-- 
2.25.1

