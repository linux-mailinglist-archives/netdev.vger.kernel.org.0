Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC8C6124BC5
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 16:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfLRPci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 10:32:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53588 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727217AbfLRPci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 10:32:38 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIFSKGL008614
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 10:32:36 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wym9qwymp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 10:32:36 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Dec 2019 15:32:35 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Dec 2019 15:32:32 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBIFWUEB40370574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 15:32:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B356F5204F;
        Wed, 18 Dec 2019 15:32:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 72AF352054;
        Wed, 18 Dec 2019 15:32:30 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 2/3] s390/qeth: fix promiscuous mode after reset
Date:   Wed, 18 Dec 2019 16:32:27 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218153228.29908-1-jwi@linux.ibm.com>
References: <20191218153228.29908-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19121815-0008-0000-0000-000003423BB1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121815-0009-0000-0000-00004A625159
Message-Id: <20191218153228.29908-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_04:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=672
 suspectscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180127
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When managing the promiscuous mode during an RX modeset, qeth caches the
current HW state to avoid repeated programming of the same state on each
modeset.

But while tearing down a device, we forget to clear the cached state. So
when the device is later set online again, the initial RX modeset
doesn't program the promiscuous mode since we believe it is already
enabled.
Fix this by clearing the cached state in the tear-down path.

Note that for the SBP variant of promiscuous mode, this accidentally
works right now because we unconditionally restore the SBP role while
re-initializing.

Fixes: 4a71df50047f ("qeth: new qeth device driver")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 1 +
 drivers/s390/net/qeth_l2_sys.c  | 3 ++-
 drivers/s390/net/qeth_l3_main.c | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 9086bc04fa6b..8c95e6019bac 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -295,6 +295,7 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 
 	flush_workqueue(card->event_wq);
 	card->info.mac_bits &= ~QETH_LAYER2_MAC_REGISTERED;
+	card->info.promisc_mode = 0;
 }
 
 static int qeth_l2_process_inbound_buffer(struct qeth_card *card,
diff --git a/drivers/s390/net/qeth_l2_sys.c b/drivers/s390/net/qeth_l2_sys.c
index f70c7aac2dcc..7fa325cf6f8d 100644
--- a/drivers/s390/net/qeth_l2_sys.c
+++ b/drivers/s390/net/qeth_l2_sys.c
@@ -262,7 +262,8 @@ void qeth_l2_setup_bridgeport_attrs(struct qeth_card *card)
 		return;
 
 	mutex_lock(&card->sbp_lock);
-	if (card->options.sbp.role != QETH_SBP_ROLE_NONE) {
+	if (!card->options.sbp.reflect_promisc &&
+	    card->options.sbp.role != QETH_SBP_ROLE_NONE) {
 		/* Conditional to avoid spurious error messages */
 		qeth_bridgeport_setrole(card, card->options.sbp.role);
 		/* Let the callback function refresh the stored role value. */
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 27126330a4b0..04e301de376f 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1314,6 +1314,7 @@ static void qeth_l3_stop_card(struct qeth_card *card)
 	}
 
 	flush_workqueue(card->event_wq);
+	card->info.promisc_mode = 0;
 }
 
 static void qeth_l3_set_promisc_mode(struct qeth_card *card)
-- 
2.17.1

