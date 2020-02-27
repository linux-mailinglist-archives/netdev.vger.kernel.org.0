Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D26651724A3
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730016AbgB0RId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:08:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729888AbgB0RIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 12:08:31 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01RH6ewA027752
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 12:08:30 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydqfw7xs8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 12:08:29 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Feb 2020 17:08:28 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Feb 2020 17:08:25 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01RH8Oex50987182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 17:08:24 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24214A4060;
        Thu, 27 Feb 2020 17:08:24 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5E68A405F;
        Thu, 27 Feb 2020 17:08:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Feb 2020 17:08:23 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 6/8] s390/qeth: don't re-start read cmd when IDX has terminated
Date:   Thu, 27 Feb 2020 18:08:14 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200227170816.101286-1-jwi@linux.ibm.com>
References: <20200227170816.101286-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20022717-0016-0000-0000-000002EAE303
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022717-0017-0000-0000-0000334E18A1
Message-Id: <20200227170816.101286-7-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_05:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 priorityscore=1501 phishscore=0 adultscore=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=995 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once the IDX connection is down, there's no point in trying to issue
more IOs.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index ba1e50ed50ec..626da9698177 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -742,7 +742,7 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 		/* fall through */
 	default:
 		qeth_clear_ipacmd_list(card);
-		goto out;
+		goto err_idx;
 	}
 
 	cmd = __ipa_reply(iob);
@@ -795,8 +795,9 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 	memcpy(&card->seqno.pdu_hdr_ack,
 		QETH_PDU_HEADER_SEQ_NO(iob->data),
 		QETH_SEQ_NO_LENGTH);
-	qeth_put_cmd(iob);
 	__qeth_issue_next_read(card);
+err_idx:
+	qeth_put_cmd(iob);
 }
 
 static int qeth_set_thread_start_bit(struct qeth_card *card,
-- 
2.17.1

