Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E72161610
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgBQPZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:25:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728363AbgBQPZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:25:08 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HFJJbh133048
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 10:25:07 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6adqxsvf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 10:25:06 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <ubraun@linux.ibm.com>;
        Mon, 17 Feb 2020 15:25:04 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 15:25:02 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01HFOw0f38141964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 15:24:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC1E1A4040;
        Mon, 17 Feb 2020 15:24:58 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90939A4053;
        Mon, 17 Feb 2020 15:24:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Feb 2020 15:24:58 +0000 (GMT)
From:   Ursula Braun <ubraun@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com
Subject: [PATCH net-next 3/6] net/smc: do not delete lgr from list twice
Date:   Mon, 17 Feb 2020 16:24:52 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200217152455.15341-1-ubraun@linux.ibm.com>
References: <20200217152455.15341-1-ubraun@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20021715-4275-0000-0000-000003A2D44D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021715-4276-0000-0000-000038B6D912
Message-Id: <20200217152455.15341-4-ubraun@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_10:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=1 priorityscore=1501 adultscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002170126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

When 2 callers call smc_lgr_terminate() at the same time
for the same lgr, one gets the lgr_lock and deletes the lgr from the
list and releases the lock. Then the second caller gets the lock and
tries to delete it again.
In smc_lgr_terminate() add a check if the link group lgr is already
deleted from the link group list and prevent to try to delete it a
second time.
And add a check if the lgr is marked as freeing, which means that a
termination is already pending.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 8f3c1fced334..9b92b52952dd 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -629,7 +629,7 @@ void smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 
 	smc_lgr_list_head(lgr, &lgr_lock);
 	spin_lock_bh(lgr_lock);
-	if (lgr->terminating) {
+	if (list_empty(&lgr->list) || lgr->terminating || lgr->freeing) {
 		spin_unlock_bh(lgr_lock);
 		return;	/* lgr already terminating */
 	}
-- 
2.17.1

