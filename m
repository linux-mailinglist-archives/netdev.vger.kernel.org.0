Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66FE834176
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 10:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbfFDIPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 04:15:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52524 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727201AbfFDIP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 04:15:26 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x548CCnR130773
        for <netdev@vger.kernel.org>; Tue, 4 Jun 2019 04:15:24 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2swmk115yh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 04:15:24 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 4 Jun 2019 09:15:22 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 4 Jun 2019 09:15:20 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x548FIcj59048092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Jun 2019 08:15:18 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8605142041;
        Tue,  4 Jun 2019 08:15:18 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3859F4203F;
        Tue,  4 Jun 2019 08:15:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Jun 2019 08:15:18 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH v2 net 4/4] s390/qeth: handle error when updating TX queue count
Date:   Tue,  4 Jun 2019 10:15:09 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604081509.56160-1-jwi@linux.ibm.com>
References: <20190604081509.56160-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19060408-0008-0000-0000-000002EDE951
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060408-0009-0000-0000-0000225ACC08
Message-Id: <20190604081509.56160-5-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040056
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netif_set_real_num_tx_queues() can return an error, deal with it.

Fixes: 73dc2daf110f ("s390/qeth: add TX multiqueue support for OSA devices")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 009f2c0ec504..b1823d75dd35 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1274,16 +1274,20 @@ static int qeth_setup_channel(struct qeth_channel *channel, bool alloc_buffers)
 	return 0;
 }
 
-static void qeth_osa_set_output_queues(struct qeth_card *card, bool single)
+static int qeth_osa_set_output_queues(struct qeth_card *card, bool single)
 {
 	unsigned int count = single ? 1 : card->dev->num_tx_queues;
+	int rc;
 
 	rtnl_lock();
-	netif_set_real_num_tx_queues(card->dev, count);
+	rc = netif_set_real_num_tx_queues(card->dev, count);
 	rtnl_unlock();
 
+	if (rc)
+		return rc;
+
 	if (card->qdio.no_out_queues == count)
-		return;
+		return 0;
 
 	if (atomic_read(&card->qdio.state) != QETH_QDIO_UNINITIALIZED)
 		qeth_free_qdio_queues(card);
@@ -1293,12 +1297,14 @@ static void qeth_osa_set_output_queues(struct qeth_card *card, bool single)
 
 	card->qdio.default_out_queue = single ? 0 : QETH_DEFAULT_QUEUE;
 	card->qdio.no_out_queues = count;
+	return 0;
 }
 
 static int qeth_update_from_chp_desc(struct qeth_card *card)
 {
 	struct ccw_device *ccwdev;
 	struct channel_path_desc_fmt0 *chp_dsc;
+	int rc = 0;
 
 	QETH_DBF_TEXT(SETUP, 2, "chp_desc");
 
@@ -1311,12 +1317,12 @@ static int qeth_update_from_chp_desc(struct qeth_card *card)
 
 	if (IS_OSD(card) || IS_OSX(card))
 		/* CHPP field bit 6 == 1 -> single queue */
-		qeth_osa_set_output_queues(card, chp_dsc->chpp & 0x02);
+		rc = qeth_osa_set_output_queues(card, chp_dsc->chpp & 0x02);
 
 	kfree(chp_dsc);
 	QETH_DBF_TEXT_(SETUP, 2, "nr:%x", card->qdio.no_out_queues);
 	QETH_DBF_TEXT_(SETUP, 2, "lvl:%02x", card->info.func_level);
-	return 0;
+	return rc;
 }
 
 static void qeth_init_qdio_info(struct qeth_card *card)
@@ -5597,8 +5603,12 @@ static struct net_device *qeth_alloc_netdev(struct qeth_card *card)
 		dev->hw_features |= NETIF_F_SG;
 		dev->vlan_features |= NETIF_F_SG;
 		if (IS_IQD(card)) {
-			netif_set_real_num_tx_queues(dev, QETH_IQD_MIN_TXQ);
 			dev->features |= NETIF_F_SG;
+			if (netif_set_real_num_tx_queues(dev,
+							 QETH_IQD_MIN_TXQ)) {
+				free_netdev(dev);
+				return NULL;
+			}
 		}
 	}
 
-- 
2.17.1

