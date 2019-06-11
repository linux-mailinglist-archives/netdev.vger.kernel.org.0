Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8670B3D267
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405631AbfFKQiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:38:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57030 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404499AbfFKQiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:38:13 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5BGRJc0021950
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:12 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t2enacfvb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:11 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 11 Jun 2019 17:38:10 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 11 Jun 2019 17:38:07 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5BGc6M431785050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 16:38:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E2B04C046;
        Tue, 11 Jun 2019 16:38:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0017A4C040;
        Tue, 11 Jun 2019 16:38:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jun 2019 16:38:05 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 05/13] s390/qeth: clean up setting of BLKT defaults
Date:   Tue, 11 Jun 2019 18:37:52 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611163800.64730-1-jwi@linux.ibm.com>
References: <20190611163800.64730-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061116-0028-0000-0000-0000037965F0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061116-0029-0000-0000-0000243955D8
Message-Id: <20190611163800.64730-6-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When called from qeth_core_probe_device(), qeth_determine_capabilities()
initializes the device's BLKT defaults. From all other callers, the
ccw_device has already been set online and the BLKT setting is skipped.

Clean this up by extracting the BLKT setting into a separate helper that
gets called from the right place.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  1 +
 drivers/s390/net/qeth_core_main.c | 11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 784a2e76a1b0..5fab7b3396aa 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -665,6 +665,7 @@ struct qeth_card_info {
 	__u16 func_level;
 	char mcl_level[QETH_MCL_LENGTH + 1];
 	u8 open_when_online:1;
+	u8 use_v1_blkt:1;
 	u8 is_vm_nic:1;
 	int mac_bits;
 	enum qeth_card_types type;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index fade84112e80..0403a1405872 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1633,6 +1633,8 @@ static void qeth_configure_unitaddr(struct qeth_card *card, char *prcd)
 	card->info.cula = prcd[63];
 	card->info.is_vm_nic = ((prcd[0x10] == _ascebc['V']) &&
 				(prcd[0x11] == _ascebc['M']));
+	card->info.use_v1_blkt = prcd[74] == 0xF0 && prcd[75] == 0xF0 &&
+				 prcd[76] >= 0xF1 && prcd[76] <= 0xF4;
 }
 
 static enum qeth_discipline_id qeth_vm_detect_layer(struct qeth_card *card)
@@ -1716,12 +1718,11 @@ static enum qeth_discipline_id qeth_enforce_discipline(struct qeth_card *card)
 	return disc;
 }
 
-static void qeth_configure_blkt_default(struct qeth_card *card, char *prcd)
+static void qeth_set_blkt_defaults(struct qeth_card *card)
 {
 	QETH_DBF_TEXT(SETUP, 2, "cfgblkt");
 
-	if (prcd[74] == 0xF0 && prcd[75] == 0xF0 &&
-	    prcd[76] >= 0xF1 && prcd[76] <= 0xF4) {
+	if (card->info.use_v1_blkt) {
 		card->info.blkt.time_total = 0;
 		card->info.blkt.inter_packet = 0;
 		card->info.blkt.inter_packet_jumbo = 0;
@@ -4761,8 +4762,6 @@ static void qeth_determine_capabilities(struct qeth_card *card)
 		goto out_offline;
 	}
 	qeth_configure_unitaddr(card, prcd);
-	if (ddev_offline)
-		qeth_configure_blkt_default(card, prcd);
 	kfree(prcd);
 
 	rc = qdio_get_ssqd_desc(ddev, &card->ssqd);
@@ -5660,6 +5659,8 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 	if (rc)
 		goto err_chp_desc;
 	qeth_determine_capabilities(card);
+	qeth_set_blkt_defaults(card);
+
 	enforced_disc = qeth_enforce_discipline(card);
 	switch (enforced_disc) {
 	case QETH_DISCIPLINE_UNDETERMINED:
-- 
2.17.1

