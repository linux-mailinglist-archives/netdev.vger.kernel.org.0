Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B8319243F
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbgCYJfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 05:35:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63428 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727612AbgCYJfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 05:35:23 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02P9XaPu168479
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 05:35:22 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywdr74g03-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 05:35:20 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 25 Mar 2020 09:35:10 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 25 Mar 2020 09:35:08 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02P9ZABu57999384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 09:35:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D682FA404D;
        Wed, 25 Mar 2020 09:35:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1109A4055;
        Wed, 25 Mar 2020 09:35:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 Mar 2020 09:35:09 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH v2 net-next 05/11] s390/qeth: simplify L3 dev_id logic
Date:   Wed, 25 Mar 2020 10:35:01 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325093507.20831-1-jwi@linux.ibm.com>
References: <20200325093507.20831-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20032509-4275-0000-0000-000003B2A6FB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032509-4276-0000-0000-000038C7E471
Message-Id: <20200325093507.20831-6-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_01:2020-03-23,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 mlxlogscore=857 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The logic that deals with errors from qeth_l3_get_unique_id() is quite
complex: it sets card->unique_id to 0xfffe, additionally flags it as
UNIQUE_ID_NOT_BY_CARD and later takes this flag as cue to not propagate
card->unique_id to dev->dev_id. With dev->dev_id thus holding 0,
addrconf_ifid_eui48() applies its default behaviour.

Get rid of all the special bit masks, and just return the old uid in
case of an error. For the vast majority of cases this will be 0 (and so
we still get the desired default behaviour) - with the rare exception
where qeth_l3_get_unique_id() might have been called earlier but the
initialization then failed at a later point.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h    |  5 -----
 drivers/s390/net/qeth_l3_main.c | 30 +++++++++++++-----------------
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 9840d4fab010..257b7f3c5558 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -178,10 +178,6 @@ struct qeth_vnicc_info {
 #define QETH_RECLAIM_WORK_TIME	HZ
 #define QETH_MAX_PORTNO		15
 
-/*IPv6 address autoconfiguration stuff*/
-#define UNIQUE_ID_IF_CREATE_ADDR_FAILED 0xfffe
-#define UNIQUE_ID_NOT_BY_CARD		0x10000
-
 /*****************************************************************************/
 /* QDIO queue and buffer handling                                            */
 /*****************************************************************************/
@@ -687,7 +683,6 @@ struct qeth_card_info {
 	enum qeth_card_types type;
 	enum qeth_link_types link_type;
 	int broadcast_capable;
-	int unique_id;
 	bool layer_enforced;
 	struct qeth_card_blkt blkt;
 	__u32 diagass_support;
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 83ae75cf1389..b48cd0df3e31 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -949,39 +949,36 @@ static int qeth_l3_get_unique_id_cb(struct qeth_card *card,
 		struct qeth_reply *reply, unsigned long data)
 {
 	struct qeth_ipa_cmd *cmd = (struct qeth_ipa_cmd *) data;
+	u16 *uid = reply->param;
 
 	if (cmd->hdr.return_code == 0) {
-		card->info.unique_id = cmd->data.create_destroy_addr.uid;
+		*uid = cmd->data.create_destroy_addr.uid;
 		return 0;
 	}
 
-	card->info.unique_id = UNIQUE_ID_IF_CREATE_ADDR_FAILED |
-			       UNIQUE_ID_NOT_BY_CARD;
 	dev_warn(&card->gdev->dev, "The network adapter failed to generate a unique ID\n");
 	return -EIO;
 }
 
-static int qeth_l3_get_unique_id(struct qeth_card *card)
+static u16 qeth_l3_get_unique_id(struct qeth_card *card, u16 uid)
 {
-	int rc = 0;
 	struct qeth_cmd_buffer *iob;
 
 	QETH_CARD_TEXT(card, 2, "guniqeid");
 
-	if (!qeth_is_supported(card, IPA_IPV6)) {
-		card->info.unique_id =  UNIQUE_ID_IF_CREATE_ADDR_FAILED |
-					UNIQUE_ID_NOT_BY_CARD;
-		return 0;
-	}
+	if (!qeth_is_supported(card, IPA_IPV6))
+		goto out;
 
 	iob = qeth_ipa_alloc_cmd(card, IPA_CMD_CREATE_ADDR, QETH_PROT_IPV6,
 				 IPA_DATA_SIZEOF(create_destroy_addr));
 	if (!iob)
-		return -ENOMEM;
+		goto out;
 
-	__ipa_cmd(iob)->data.create_destroy_addr.uid = card->info.unique_id;
-	rc = qeth_send_ipa_cmd(card, iob, qeth_l3_get_unique_id_cb, NULL);
-	return rc;
+	__ipa_cmd(iob)->data.create_destroy_addr.uid = uid;
+	qeth_send_ipa_cmd(card, iob, qeth_l3_get_unique_id_cb, &uid);
+
+out:
+	return uid;
 }
 
 static int
@@ -1920,6 +1917,7 @@ static const struct net_device_ops qeth_l3_osa_netdev_ops = {
 
 static int qeth_l3_setup_netdev(struct qeth_card *card)
 {
+	struct net_device *dev = card->dev;
 	unsigned int headroom;
 	int rc;
 
@@ -1937,9 +1935,7 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 		card->dev->netdev_ops = &qeth_l3_osa_netdev_ops;
 
 		/*IPv6 address autoconfiguration stuff*/
-		qeth_l3_get_unique_id(card);
-		if (!(card->info.unique_id & UNIQUE_ID_NOT_BY_CARD))
-			card->dev->dev_id = card->info.unique_id & 0xffff;
+		dev->dev_id = qeth_l3_get_unique_id(card, dev->dev_id);
 
 		if (!IS_VM_NIC(card)) {
 			card->dev->features |= NETIF_F_SG;
-- 
2.17.1

