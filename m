Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFF4254080
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 10:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgH0IRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 04:17:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47218 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727969AbgH0IRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 04:17:18 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R8DKjF145434;
        Thu, 27 Aug 2020 04:17:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=2I3B86jUB1HJQmlkIKn38GGej0poeJFjS/nNlDtvk4k=;
 b=FATVyoAfotguFfdNykwrUdsVejO8iC3vyIjlwV8QpXytU7y67DqnwX9g+RfQR5tLDHZF
 rqJ4WasF7dJsJgxabVO05ZqKQeTWGQswhOP9ZBSuPOqOd5PptfADbLKNhkDmW+82vZA2
 V0bLtfoDQER87ZLK1cxERHli/g6uwWT5s5XxmGoM1J84dBd2gdRoiAop7CwAJiZSLv5h
 CTDyCwKrvk9MEKCeLbES/hMiCMvEqDMeXi/EMmFNrcvKBwKe06nd0GmUnZk7oOsMNYxH
 v8VXBq1MypYXWDKaJity3KuCIMTyeRKbmBMQHRJr0JzNrWn2fJa1Xi0R08D1jEp5PBw/ 3A== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33694e03bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 04:17:14 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07R8CaKI024013;
        Thu, 27 Aug 2020 08:17:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 335a2t907b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 08:17:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07R8H9aL22217054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 08:17:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 943814C04E;
        Thu, 27 Aug 2020 08:17:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B3CC4C04A;
        Thu, 27 Aug 2020 08:17:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Aug 2020 08:17:09 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 5/8] s390/qeth: don't let HW override the configured port role
Date:   Thu, 27 Aug 2020 10:17:02 +0200
Message-Id: <20200827081705.21922-6-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827081705.21922-1-jwi@linux.ibm.com>
References: <20200827081705.21922-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_02:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270057
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only time that our Bridgeport role should change is when we change
the configuration ourselves. In which case we also adjust our internal
state tracking, no need to do it again when we receive the corresponding
event.

Removing the locked section helps a subsequent patch that needs to flush
the workqueue while under sbp_lock.

It would be nice to raise a warning here in case HW does weird things
after all, but this could end up generating false-positives when we
change the configuration ourselves.

Suggested-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index ea966713ce7e..5a023fc499eb 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1107,12 +1107,6 @@ static void qeth_bridge_state_change_worker(struct work_struct *work)
 		NULL
 	};
 
-	/* Role should not change by itself, but if it did, */
-	/* information from the hardware is authoritative.  */
-	mutex_lock(&data->card->sbp_lock);
-	data->card->options.sbp.role = entry->role;
-	mutex_unlock(&data->card->sbp_lock);
-
 	snprintf(env_locrem, sizeof(env_locrem), "BRIDGEPORT=statechange");
 	snprintf(env_role, sizeof(env_role), "ROLE=%s",
 		(entry->role == QETH_SBP_ROLE_NONE) ? "none" :
-- 
2.17.1

