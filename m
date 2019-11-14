Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E38FC3F5
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfKNKUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:20:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52672 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726106AbfKNKUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:20:42 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEAKCW1092997
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:20:40 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w91npqdqs-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:20:25 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 14 Nov 2019 10:19:34 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 10:19:31 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEAJUud61931532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 10:19:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0804AA4051;
        Thu, 14 Nov 2019 10:19:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C14DAA405B;
        Thu, 14 Nov 2019 10:19:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 10:19:29 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 06/11] s390/qeth: fine-tune L3 mcast locking
Date:   Thu, 14 Nov 2019 11:19:19 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114101924.29558-1-jwi@linux.ibm.com>
References: <20191114101924.29558-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111410-0028-0000-0000-000003B6CD1B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111410-0029-0000-0000-00002479D96E
Message-Id: <20191114101924.29558-7-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=515 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Push the inet6_dev locking down into the helper that actually needs it
for walking the mc_list.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 3b901f3676c1..a8f18bf0c227 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1206,6 +1206,7 @@ static void qeth_l3_add_mc6_to_hash(struct qeth_card *card,
 	if (!tmp)
 		return;
 
+	read_lock_bh(&in6_dev->lock);
 	for (im6 = in6_dev->mc_list; im6 != NULL; im6 = im6->next) {
 		tmp->u.a6.addr = im6->mca_addr;
 		tmp->is_multicast = 1;
@@ -1228,6 +1229,8 @@ static void qeth_l3_add_mc6_to_hash(struct qeth_card *card,
 				&ipm->hnode, qeth_l3_ipaddr_hash(ipm));
 
 	}
+	read_unlock_bh(&in6_dev->lock);
+
 	kfree(tmp);
 }
 
@@ -1253,9 +1256,7 @@ static void qeth_l3_add_vlan_mc6(struct qeth_card *card)
 		in_dev = in6_dev_get(netdev);
 		if (!in_dev)
 			continue;
-		read_lock_bh(&in_dev->lock);
 		qeth_l3_add_mc6_to_hash(card, in_dev);
-		read_unlock_bh(&in_dev->lock);
 		in6_dev_put(in_dev);
 	}
 }
@@ -1273,10 +1274,8 @@ static void qeth_l3_add_multicast_ipv6(struct qeth_card *card)
 		return;
 
 	rcu_read_lock();
-	read_lock_bh(&in6_dev->lock);
 	qeth_l3_add_mc6_to_hash(card, in6_dev);
 	qeth_l3_add_vlan_mc6(card);
-	read_unlock_bh(&in6_dev->lock);
 	rcu_read_unlock();
 	in6_dev_put(in6_dev);
 }
-- 
2.17.1

