Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 191B2CFED4
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 18:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfJHQVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 12:21:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13546 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728629AbfJHQVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 12:21:18 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x98GCgPj041492
        for <netdev@vger.kernel.org>; Tue, 8 Oct 2019 12:21:17 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vepu15k6f-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 12:21:17 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 8 Oct 2019 17:21:14 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 8 Oct 2019 17:21:11 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x98GLAU253608504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Oct 2019 16:21:10 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCDC242041;
        Tue,  8 Oct 2019 16:21:09 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AD1642042;
        Tue,  8 Oct 2019 16:21:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Oct 2019 16:21:09 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 1/2] s390/qeth: Fix error handling during VNICC initialization
Date:   Tue,  8 Oct 2019 18:21:06 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191008162107.95259-1-jwi@linux.ibm.com>
References: <20191008162107.95259-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19100816-0016-0000-0000-000002B6238E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100816-0017-0000-0000-0000331726AB
Message-Id: <20191008162107.95259-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910080138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

Smatch discovered the use of uninitialized variable sup_cmds
in error paths.

Fixes: caa1f0b10d18 ("s390/qeth: add VNICC enable/disable support")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index b8799cd3e7aa..de62a9ccc882 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2021,10 +2021,10 @@ static bool qeth_l2_vnicc_recover_char(struct qeth_card *card, u32 vnicc,
 static void qeth_l2_vnicc_init(struct qeth_card *card)
 {
 	u32 *timeout = &card->options.vnicc.learning_timeout;
+	bool enable, error = false;
 	unsigned int chars_len, i;
 	unsigned long chars_tmp;
 	u32 sup_cmds, vnicc;
-	bool enable, error;
 
 	QETH_CARD_TEXT(card, 2, "vniccini");
 	/* reset rx_bcast */
@@ -2045,7 +2045,10 @@ static void qeth_l2_vnicc_init(struct qeth_card *card)
 	chars_len = sizeof(card->options.vnicc.sup_chars) * BITS_PER_BYTE;
 	for_each_set_bit(i, &chars_tmp, chars_len) {
 		vnicc = BIT(i);
-		qeth_l2_vnicc_query_cmds(card, vnicc, &sup_cmds);
+		if (qeth_l2_vnicc_query_cmds(card, vnicc, &sup_cmds)) {
+			sup_cmds = 0;
+			error = true;
+		}
 		if (!(sup_cmds & IPA_VNICC_SET_TIMEOUT) ||
 		    !(sup_cmds & IPA_VNICC_GET_TIMEOUT))
 			card->options.vnicc.getset_timeout_sup &= ~vnicc;
@@ -2054,8 +2057,8 @@ static void qeth_l2_vnicc_init(struct qeth_card *card)
 			card->options.vnicc.set_char_sup &= ~vnicc;
 	}
 	/* enforce assumed default values and recover settings, if changed  */
-	error = qeth_l2_vnicc_recover_timeout(card, QETH_VNICC_LEARNING,
-					      timeout);
+	error |= qeth_l2_vnicc_recover_timeout(card, QETH_VNICC_LEARNING,
+					       timeout);
 	chars_tmp = card->options.vnicc.wanted_chars ^ QETH_VNICC_DEFAULT;
 	chars_tmp |= QETH_VNICC_BRIDGE_INVISIBLE;
 	chars_len = sizeof(card->options.vnicc.wanted_chars) * BITS_PER_BYTE;
-- 
2.17.1

