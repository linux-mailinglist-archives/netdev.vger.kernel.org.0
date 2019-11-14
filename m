Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61825FC3E2
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfKNKTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:19:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39992 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726796AbfKNKTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:19:37 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEAILIs082423
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:19:36 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w94y20avb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:19:35 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 14 Nov 2019 10:19:33 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 10:19:31 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEAIr1M13173116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 10:18:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6994A4051;
        Thu, 14 Nov 2019 10:19:29 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B10BA4059;
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
Subject: [PATCH net-next 05/11] s390/qeth: clean up error path in qeth_core_probe_device()
Date:   Thu, 14 Nov 2019 11:19:18 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114101924.29558-1-jwi@linux.ibm.com>
References: <20191114101924.29558-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111410-0008-0000-0000-0000032EF024
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111410-0009-0000-0000-00004A4DFE00
Message-Id: <20191114101924.29558-6-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qeth_core_free_card() is meant to be the counterpart of
qeth_alloc_card() - but unfortunately was also picked as the place
to free the QDIO queues.

This gets messy when qeth_core_probe_device() fails during
qeth_add_dbf_entry(). At this point the card->qdio.state is not initialized
yet, so qeth_free_qdio_queues() ends up operating on uninitialized data.

Luckily for now, the whole qeth_card struct is zero-allocated and the value
of the QETH_QDIO_UNINITIALIZED enum is 0 as well. So there's no real impact
from this bug at the moment, it's just really fragile.

Clean this up by moving the qeth_free_qdio_queues() call up one level in
the hierarchy. This way it doesn't get called from the error path.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 08185f76a727..f1f56e354516 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4855,7 +4855,6 @@ static void qeth_core_free_card(struct qeth_card *card)
 	qeth_clean_channel(&card->data);
 	qeth_put_cmd(card->read_cmd);
 	destroy_workqueue(card->event_wq);
-	qeth_free_qdio_queues(card);
 	unregister_service_level(&card->qeth_service_level);
 	dev_set_drvdata(&card->gdev->dev, NULL);
 	kfree(card);
@@ -5768,6 +5767,8 @@ static void qeth_core_remove_device(struct ccwgroup_device *gdev)
 		qeth_core_free_discipline(card);
 	}
 
+	qeth_free_qdio_queues(card);
+
 	free_netdev(card->dev);
 	qeth_core_free_card(card);
 	put_device(&gdev->dev);
-- 
2.17.1

