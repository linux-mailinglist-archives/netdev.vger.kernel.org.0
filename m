Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A6C1FD012
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 16:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgFQOzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 10:55:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19748 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726494AbgFQOzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 10:55:04 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05HEcAeF040606;
        Wed, 17 Jun 2020 10:55:00 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31q6hbstst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 10:55:00 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05HEkKVB006974;
        Wed, 17 Jun 2020 14:54:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 31q6bs982f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 14:54:58 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05HEsu0D8585354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jun 2020 14:54:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26A4B42042;
        Wed, 17 Jun 2020 14:54:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C537642047;
        Wed, 17 Jun 2020 14:54:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jun 2020 14:54:55 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 1/2] s390/qeth: fix error handling for isolation mode cmds
Date:   Wed, 17 Jun 2020 16:54:52 +0200
Message-Id: <20200617145453.61382-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200617145453.61382-1-jwi@linux.ibm.com>
References: <20200617145453.61382-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-17_04:2020-06-17,2020-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 cotscore=-2147483648
 clxscore=1015 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006170109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current(?) OSA devices also store their cmd-specific return codes for
SET_ACCESS_CONTROL cmds into the top-level cmd->hdr.return_code.
So once we added stricter checking for the top-level field a while ago,
none of the error logic that rolls back the user's configuration to its
old state is applied any longer.

For this specific cmd, go back to the old model where we peek into the
cmd structure even though the top-level field indicated an error.

Fixes: 686c97ee29c8 ("s390/qeth: fix error handling in adapter command callbacks")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 18a0fb75a710..9636415f810b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4544,9 +4544,6 @@ static int qeth_setadpparms_set_access_ctrl_cb(struct qeth_card *card,
 	int fallback = *(int *)reply->param;
 
 	QETH_CARD_TEXT(card, 4, "setaccb");
-	if (cmd->hdr.return_code)
-		return -EIO;
-	qeth_setadpparms_inspect_rc(cmd);
 
 	access_ctrl_req = &cmd->data.setadapterparms.data.set_access_ctrl;
 	QETH_CARD_TEXT_(card, 2, "rc=%d",
@@ -4556,7 +4553,7 @@ static int qeth_setadpparms_set_access_ctrl_cb(struct qeth_card *card,
 		QETH_DBF_MESSAGE(3, "ERR:SET_ACCESS_CTRL(%#x) on device %x: %#x\n",
 				 access_ctrl_req->subcmd_code, CARD_DEVID(card),
 				 cmd->data.setadapterparms.hdr.return_code);
-	switch (cmd->data.setadapterparms.hdr.return_code) {
+	switch (qeth_setadpparms_inspect_rc(cmd)) {
 	case SET_ACCESS_CTRL_RC_SUCCESS:
 		if (card->options.isolation == ISOLATION_MODE_NONE) {
 			dev_info(&card->gdev->dev,
-- 
2.17.1

