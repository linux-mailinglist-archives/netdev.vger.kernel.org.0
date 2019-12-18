Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E7C124DDB
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfLRQfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:35:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29138 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727484AbfLRQfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:35:04 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIGYM4A085382
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:35:03 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wypm0af35-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:35:03 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Dec 2019 16:34:58 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Dec 2019 16:34:55 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBIGYrM454657168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 16:34:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9551FA404D;
        Wed, 18 Dec 2019 16:34:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59742A4057;
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
Subject: [PATCH net-next 6/9] s390/qeth: don't raise NETDEV_REBOOT event from L3 offline path
Date:   Wed, 18 Dec 2019 17:34:47 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218163450.36731-1-jwi@linux.ibm.com>
References: <20191218163450.36731-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19121816-0012-0000-0000-000003764001
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121816-0013-0000-0000-000021B22F98
Message-Id: <20191218163450.36731-7-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_05:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=987 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a leftover from back when a recovery action didn't go through
dev_close(), and was meant to shoot down all remaining af_iucv sockets
on the interface.

Now that the offline path always calls dev_close(), the
NETDEV_GOING_DOWN event from __dev_close_many() is sufficient and this
hack can be removed.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index bd2273f9ca35..8bd3fc73a4fb 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -2288,12 +2288,6 @@ static int __qeth_l3_set_offline(struct ccwgroup_device *cgdev,
 	rtnl_unlock();
 
 	qeth_l3_stop_card(card);
-	if (card->options.cq == QETH_CQ_ENABLED) {
-		rtnl_lock();
-		call_netdevice_notifiers(NETDEV_REBOOT, card->dev);
-		rtnl_unlock();
-	}
-
 	rc  = qeth_stop_channel(&card->data);
 	rc2 = qeth_stop_channel(&card->write);
 	rc3 = qeth_stop_channel(&card->read);
-- 
2.17.1

