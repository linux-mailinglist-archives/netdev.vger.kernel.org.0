Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE55C1724A7
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730069AbgB0RIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:08:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27144 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729906AbgB0RIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 12:08:31 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01RH67d0086821
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 12:08:30 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydkfarp56-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 12:08:30 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Feb 2020 17:08:28 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Feb 2020 17:08:25 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01RH8Naa51511422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 17:08:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9FCFA405C;
        Thu, 27 Feb 2020 17:08:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 875A1A4064;
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
Subject: [PATCH net-next 5/8] s390/qeth: reset seqnos on connection startup
Date:   Thu, 27 Feb 2020 18:08:13 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200227170816.101286-1-jwi@linux.ibm.com>
References: <20200227170816.101286-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20022717-4275-0000-0000-000003A6144D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022717-4276-0000-0000-000038BA67A2
Message-Id: <20200227170816.101286-6-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_05:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 bulkscore=0 adultscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This let's us start every new IDX connection with clean seqnos.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 5efcaa43615b..ba1e50ed50ec 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1624,17 +1624,16 @@ static void qeth_set_blkt_defaults(struct qeth_card *card)
 	}
 }
 
-static void qeth_init_tokens(struct qeth_card *card)
+static void qeth_idx_init(struct qeth_card *card)
 {
+	memset(&card->seqno, 0, sizeof(card->seqno));
+
 	card->token.issuer_rm_w = 0x00010103UL;
 	card->token.cm_filter_w = 0x00010108UL;
 	card->token.cm_connection_w = 0x0001010aUL;
 	card->token.ulp_filter_w = 0x0001010bUL;
 	card->token.ulp_connection_w = 0x0001010dUL;
-}
 
-static void qeth_init_func_level(struct qeth_card *card)
-{
 	switch (card->info.type) {
 	case QETH_CARD_TYPE_IQD:
 		card->info.func_level =	QETH_IDX_FUNC_LEVEL_IQD;
@@ -4952,9 +4951,9 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 		else
 			goto retry;
 	}
+
 	qeth_determine_capabilities(card);
-	qeth_init_tokens(card);
-	qeth_init_func_level(card);
+	qeth_idx_init(card);
 
 	rc = qeth_idx_activate_read_channel(card);
 	if (rc == -EINTR) {
-- 
2.17.1

