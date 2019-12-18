Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E36124DDD
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfLRQfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:35:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35052 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727543AbfLRQfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:35:00 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIGYTRn052503
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:34:59 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wymc38jk5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:34:58 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Dec 2019 16:34:57 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Dec 2019 16:34:55 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBIGYrTM46530804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 16:34:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5C19A404D;
        Wed, 18 Dec 2019 16:34:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA3E8A4055;
        Wed, 18 Dec 2019 16:34:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Dec 2019 16:34:53 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 7/9] s390/qeth: stop yielding the ip_lock during IPv4 registration
Date:   Wed, 18 Dec 2019 17:34:48 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218163450.36731-1-jwi@linux.ibm.com>
References: <20191218163450.36731-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19121816-0020-0000-0000-00000399938D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121816-0021-0000-0000-000021F0B768
Message-Id: <20191218163450.36731-8-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_05:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912180136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As commit df2a2a5225cc ("s390/qeth: convert IP table spinlock to mutex")
converted the ip_lock to a mutex, we no longer have to yield it while
the subsequent IO sleep-waits for completion.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3.h      |  1 -
 drivers/s390/net/qeth_l3_main.c | 34 ++-------------------------------
 2 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/drivers/s390/net/qeth_l3.h b/drivers/s390/net/qeth_l3.h
index 89fb91dad12e..6ccfe2121095 100644
--- a/drivers/s390/net/qeth_l3.h
+++ b/drivers/s390/net/qeth_l3.h
@@ -23,7 +23,6 @@ struct qeth_ipaddr {
 	struct hlist_node hnode;
 	enum qeth_ip_types type;
 	u8 is_multicast:1;
-	u8 in_progress:1;
 	u8 disp_flag:2;
 	u8 ipato:1;			/* ucast only */
 
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 8bd3fc73a4fb..789d3b2ba0de 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -151,8 +151,6 @@ static int qeth_l3_delete_ip(struct qeth_card *card,
 	addr->ref_counter--;
 	if (addr->type == QETH_IP_TYPE_NORMAL && addr->ref_counter > 0)
 		return rc;
-	if (addr->in_progress)
-		return -EINPROGRESS;
 
 	if (qeth_card_hw_is_reachable(card))
 		rc = qeth_l3_deregister_addr_entry(card, addr);
@@ -213,29 +211,10 @@ static int qeth_l3_add_ip(struct qeth_card *card, struct qeth_ipaddr *tmp_addr)
 			return 0;
 		}
 
-		/* qeth_l3_register_addr_entry can go to sleep
-		 * if we add a IPV4 addr. It is caused by the reason
-		 * that SETIP ipa cmd starts ARP staff for IPV4 addr.
-		 * Thus we should unlock spinlock, and make a protection
-		 * using in_progress variable to indicate that there is
-		 * an hardware operation with this IPV4 address
-		 */
-		if (addr->proto == QETH_PROT_IPV4) {
-			addr->in_progress = 1;
-			mutex_unlock(&card->ip_lock);
-			rc = qeth_l3_register_addr_entry(card, addr);
-			mutex_lock(&card->ip_lock);
-			addr->in_progress = 0;
-		} else
-			rc = qeth_l3_register_addr_entry(card, addr);
+		rc = qeth_l3_register_addr_entry(card, addr);
 
 		if (!rc || rc == -EADDRINUSE || rc == -ENETDOWN) {
 			addr->disp_flag = QETH_DISP_ADDR_DO_NOTHING;
-			if (addr->ref_counter < 1) {
-				qeth_l3_deregister_addr_entry(card, addr);
-				hash_del(&addr->hnode);
-				kfree(addr);
-			}
 		} else {
 			hash_del(&addr->hnode);
 			kfree(addr);
@@ -303,19 +282,10 @@ static void qeth_l3_recover_ip(struct qeth_card *card)
 
 	hash_for_each_safe(card->ip_htable, i, tmp, addr, hnode) {
 		if (addr->disp_flag == QETH_DISP_ADDR_ADD) {
-			if (addr->proto == QETH_PROT_IPV4) {
-				addr->in_progress = 1;
-				mutex_unlock(&card->ip_lock);
-				rc = qeth_l3_register_addr_entry(card, addr);
-				mutex_lock(&card->ip_lock);
-				addr->in_progress = 0;
-			} else
-				rc = qeth_l3_register_addr_entry(card, addr);
+			rc = qeth_l3_register_addr_entry(card, addr);
 
 			if (!rc) {
 				addr->disp_flag = QETH_DISP_ADDR_DO_NOTHING;
-				if (addr->ref_counter < 1)
-					qeth_l3_delete_ip(card, addr);
 			} else {
 				hash_del(&addr->hnode);
 				kfree(addr);
-- 
2.17.1

