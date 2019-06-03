Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 669AD33314
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 17:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbfFCPGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 11:06:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53654 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729081AbfFCPGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 11:06:08 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53F37n6058489
        for <netdev@vger.kernel.org>; Mon, 3 Jun 2019 11:06:06 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sw4yhk9br-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 11:06:06 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Mon, 3 Jun 2019 16:05:39 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Jun 2019 16:05:35 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x53F5XJx54919388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 15:05:33 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC1624C04E;
        Mon,  3 Jun 2019 15:05:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75B174C046;
        Mon,  3 Jun 2019 15:05:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jun 2019 15:05:33 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 4/4] s390/qeth: handle error when updating TX queue count
Date:   Mon,  3 Jun 2019 17:04:46 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190603150446.23351-1-jwi@linux.ibm.com>
References: <20190603150446.23351-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19060315-0008-0000-0000-000002ED6871
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060315-0009-0000-0000-0000225A488F
Message-Id: <20190603150446.23351-5-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030105
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

