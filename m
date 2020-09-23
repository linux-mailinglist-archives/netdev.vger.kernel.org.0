Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A35275355
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgIWIhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:37:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48942 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726445AbgIWIhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:37:13 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08N8VnaI025029;
        Wed, 23 Sep 2020 04:37:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=n0DIzbMtzdS4hAxkhY3CR2QNm48muRYGBwKEnWnXKKg=;
 b=qG/EP3BokjlAivr4Tz5arDe8HBZ/G/3EHEmSTaN4WeLiRRQx8k0ognk0JgwBXPEs5PFS
 UTbpVwYOKExXxpDeEZrM4/1s4GDHEtUQI0YStnFb57aZRR9r+bRVkFBQQf3XWOQz4Z3H
 UvmPqY6YHYS16y3OyN4y7bRc0F6HCAYrr/sMDXc7Ybahj1HeHJwOxOLrmyhqziFujYRN
 I9+PuMiGGRckXuDZvbgYWZZD5IU6dWgUD+v5JdEuZQ/X/pIEirf+f/ayWyVNCTtg2+WC
 YZ1y9yZ2jnQl+tIKRgJ+NJSDAVYz77zyYmMktgZsQwvZhVKjNQYZluZrlTck1mc8Pzst 4w== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33r2n1gpfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 04:37:09 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08N8amba027654;
        Wed, 23 Sep 2020 08:37:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 33n9m8bxfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 08:37:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08N8b4pl25821642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 08:37:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D60D911C052;
        Wed, 23 Sep 2020 08:37:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9098311C054;
        Wed, 23 Sep 2020 08:37:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 08:37:04 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 5/9] s390/qeth: tighten ucast IP locking
Date:   Wed, 23 Sep 2020 10:36:56 +0200
Message-Id: <20200923083700.44624-6-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923083700.44624-1-jwi@linux.ibm.com>
References: <20200923083700.44624-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_03:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 suspectscore=0 clxscore=1015 spamscore=0 adultscore=0 priorityscore=1501
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230064
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The programming of ucast IPs via qeth_l3_modify_ip() is driven
independently from any of our typical locking mechanisms (eg. detaching
the netdevice, or holding the conf_mutex).
So when we inspect the card state to check whether the required cmd IO
should be deferred, there is no protection against concurrent state
changes.

But by slightly re-ordering the teardown sequence, we can rely on the
ip_lock to sufficiently serialize things:

1. when running concurrently to qeth_l3_set_online(), any instance of
   qeth_l3_modify_ip() that aquires the ip_lock _after_
   qeth_l3_recover_ip() will observe the state as CARD_STATE_SOFTSETUP
   and not defer the IO.
2. when running concurrently to qeth_l3_set_offline(), any instance of
   qeth_l3_modify_ip() that aquires the ip_lock _after_
   qeth_l3_clear_ip_htable() will observe the state as CARD_STATE_DOWN
   and defer the IO.

These guarantees in mind, we can now drop the conf_mutex from the
qeth_l3_modify_rxip_vipa() wrapper.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3_main.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 876a21d451f5..0815b64c9797 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -591,7 +591,6 @@ int qeth_l3_modify_rxip_vipa(struct qeth_card *card, bool add, const u8 *ip,
 			     enum qeth_prot_versions proto)
 {
 	struct qeth_ipaddr addr;
-	int rc;
 
 	qeth_l3_init_ipaddr(&addr, type, proto);
 	if (proto == QETH_PROT_IPV4)
@@ -599,11 +598,7 @@ int qeth_l3_modify_rxip_vipa(struct qeth_card *card, bool add, const u8 *ip,
 	else
 		memcpy(&addr.u.a6.addr, ip, 16);
 
-	mutex_lock(&card->conf_mutex);
-	rc = qeth_l3_modify_ip(card, &addr, add);
-	mutex_unlock(&card->conf_mutex);
-
-	return rc;
+	return qeth_l3_modify_ip(card, &addr, add);
 }
 
 int qeth_l3_modify_hsuid(struct qeth_card *card, bool add)
@@ -1161,9 +1156,9 @@ static void qeth_l3_stop_card(struct qeth_card *card)
 		qeth_diags_trace(card, QETH_DIAGS_CMD_TRACE_DISABLE);
 
 	if (card->state == CARD_STATE_SOFTSETUP) {
+		card->state = CARD_STATE_DOWN;
 		qeth_l3_clear_ip_htable(card, 1);
 		qeth_clear_ipacmd_list(card);
-		card->state = CARD_STATE_DOWN;
 	}
 
 	qeth_qdio_clear_card(card, 0);
-- 
2.17.1

