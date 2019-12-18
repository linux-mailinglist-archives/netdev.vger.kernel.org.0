Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C71C7124BC3
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 16:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbfLRPch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 10:32:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727180AbfLRPcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 10:32:36 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIFSTEM141136
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 10:32:36 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wypmsgh67-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 10:32:35 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Dec 2019 15:32:33 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Dec 2019 15:32:32 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBIFWUZ934865466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 15:32:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70E6052052;
        Wed, 18 Dec 2019 15:32:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 30BB852051;
        Wed, 18 Dec 2019 15:32:30 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 1/3] s390/qeth: handle error due to unsupported transport mode
Date:   Wed, 18 Dec 2019 16:32:26 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218153228.29908-1-jwi@linux.ibm.com>
References: <20191218153228.29908-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19121815-0008-0000-0000-000003423BB3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121815-0009-0000-0000-00004A625158
Message-Id: <20191218153228.29908-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_04:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 clxscore=1015 mlxlogscore=999 impostorscore=0
 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180127
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Along with z/VM NICs, there's additional device types that only support
a specific transport mode (eg. external-bridged IQD).
Identify the corresponding error code, and raise a fitting error message
so that the user knows to adjust their device configuration.

On top of that also fix the subsequent error path, so that the rejected
cmd doesn't need to wait for a timeout but gets cancelled straight away.

Fixes: 4a71df50047f ("qeth: new qeth device driver")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 14 +++++++-------
 drivers/s390/net/qeth_core_mpc.h  |  5 +++++
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index b9a2349e4b90..bb406eacef82 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -655,17 +655,17 @@ static int qeth_check_idx_response(struct qeth_card *card,
 	unsigned char *buffer)
 {
 	QETH_DBF_HEX(CTRL, 2, buffer, QETH_DBF_CTRL_LEN);
-	if ((buffer[2] & 0xc0) == 0xc0) {
+	if ((buffer[2] & QETH_IDX_TERMINATE_MASK) == QETH_IDX_TERMINATE) {
 		QETH_DBF_MESSAGE(2, "received an IDX TERMINATE with cause code %#04x\n",
 				 buffer[4]);
 		QETH_CARD_TEXT(card, 2, "ckidxres");
 		QETH_CARD_TEXT(card, 2, " idxterm");
-		QETH_CARD_TEXT_(card, 2, "  rc%d", -EIO);
-		if (buffer[4] == 0xf6) {
+		QETH_CARD_TEXT_(card, 2, "rc%x", buffer[4]);
+		if (buffer[4] == QETH_IDX_TERM_BAD_TRANSPORT ||
+		    buffer[4] == QETH_IDX_TERM_BAD_TRANSPORT_VM) {
 			dev_err(&card->gdev->dev,
-			"The qeth device is not configured "
-			"for the OSI layer required by z/VM\n");
-			return -EPERM;
+				"The device does not support the configured transport mode\n");
+			return -EPROTONOSUPPORT;
 		}
 		return -EIO;
 	}
@@ -742,10 +742,10 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 	case 0:
 		break;
 	case -EIO:
-		qeth_clear_ipacmd_list(card);
 		qeth_schedule_recovery(card);
 		/* fall through */
 	default:
+		qeth_clear_ipacmd_list(card);
 		goto out;
 	}
 
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index 88f4dc140751..6f5290fabd2c 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -899,6 +899,11 @@ extern unsigned char IDX_ACTIVATE_WRITE[];
 #define QETH_IDX_ACT_ERR_AUTH		0x1E
 #define QETH_IDX_ACT_ERR_AUTH_USER	0x20
 
+#define QETH_IDX_TERMINATE		0xc0
+#define QETH_IDX_TERMINATE_MASK		0xc0
+#define QETH_IDX_TERM_BAD_TRANSPORT	0x41
+#define QETH_IDX_TERM_BAD_TRANSPORT_VM	0xf6
+
 #define PDU_ENCAPSULATION(buffer) \
 	(buffer + *(buffer + (*(buffer + 0x0b)) + \
 	 *(buffer + *(buffer + 0x0b) + 0x11) + 0x07))
-- 
2.17.1

