Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A71B275359
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgIWIhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:37:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726308AbgIWIhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:37:16 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08N8W82Q189161;
        Wed, 23 Sep 2020 04:37:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=mX/dt7NmiWP/OBaHmAp17yIbN35M5yM+BylvKXZPgJg=;
 b=U2tCovgP0lKkZYt5i/I+HCA/6wzCGl3+VQ1go7ImJ6h0FpHbbmNNqDp8oJ6R2sugKW/S
 GGUTNtftzTrLZ7Ii18pwenzJy+weh/u4XsH9cPIKXnbcgFps/tm6Wo1TidHbFCk4cJxt
 gSMynmwunWoikJ2CqsYXt4nW920axbOAGBhrjqJ9zvd3CCaYa+46Ckn22n/4Qxsf4MSW
 Z7AgtiaFPEH26uUbtshFbA6Ggb/clsZ1PGhdA4e+tHnNSXhHZNoEA6JSSMmY48vOwumj
 /0eDz3R6e4FXAcyBM2mYbpdN1q/g4d2LCVHXsjoTnFEClE/QOk4tTHdlsS8ShAe/ljtc Ng== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33qymkd3bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 04:37:12 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08N8W1sm004319;
        Wed, 23 Sep 2020 08:37:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 33n98guyfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 08:37:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08N8b4rc25952588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 08:37:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 848AF11C050;
        Wed, 23 Sep 2020 08:37:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 342AA11C058;
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
Subject: [PATCH net-next 4/9] s390/qeth: replace deprecated simple_stroul()
Date:   Wed, 23 Sep 2020 10:36:55 +0200
Message-Id: <20200923083700.44624-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923083700.44624-1-jwi@linux.ibm.com>
References: <20200923083700.44624-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_03:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 impostorscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230064
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the remaining occurences in sysfs code to kstrtouint().

While at it move some input parsing out of locked sections, replace an
open-coded clamp() and remove some unnecessary run-time checks for
ipatoe->mask_bits that are already enforced when creating the object.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h     |  4 +-
 drivers/s390/net/qeth_core_sys.c | 65 +++++++++++++++++---------------
 drivers/s390/net/qeth_l3.h       |  4 +-
 drivers/s390/net/qeth_l3_main.c  |  8 ++--
 drivers/s390/net/qeth_l3_sys.c   | 21 +++++------
 5 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 1b3fe384dcc9..f931b764d6a4 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -195,8 +195,8 @@ struct qeth_vnicc_info {
 #define QETH_IN_BUF_SIZE_DEFAULT 65536
 #define QETH_IN_BUF_COUNT_DEFAULT 64
 #define QETH_IN_BUF_COUNT_HSDEFAULT 128
-#define QETH_IN_BUF_COUNT_MIN 8
-#define QETH_IN_BUF_COUNT_MAX 128
+#define QETH_IN_BUF_COUNT_MIN	8U
+#define QETH_IN_BUF_COUNT_MAX	128U
 #define QETH_MAX_BUFFER_ELEMENTS(card) ((card)->qdio.in_buf_size >> 12)
 #define QETH_IN_BUF_REQUEUE_THRESHOLD(card) \
 		 ((card)->qdio.in_buf_pool.buf_count / 2)
diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index 8def82336f53..74c70364edc1 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -103,21 +103,21 @@ static ssize_t qeth_dev_portno_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
-	char *tmp;
 	unsigned int portno, limit;
 	int rc = 0;
 
+	rc = kstrtouint(buf, 16, &portno);
+	if (rc)
+		return rc;
+	if (portno > QETH_MAX_PORTNO)
+		return -EINVAL;
+
 	mutex_lock(&card->conf_mutex);
 	if (card->state != CARD_STATE_DOWN) {
 		rc = -EPERM;
 		goto out;
 	}
 
-	portno = simple_strtoul(buf, &tmp, 16);
-	if (portno > QETH_MAX_PORTNO) {
-		rc = -EINVAL;
-		goto out;
-	}
 	limit = (card->ssqd.pcnt ? card->ssqd.pcnt - 1 : card->ssqd.pcnt);
 	if (portno > limit) {
 		rc = -EINVAL;
@@ -248,19 +248,19 @@ static ssize_t qeth_dev_bufcnt_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 	unsigned int cnt;
-	char *tmp;
 	int rc = 0;
 
+	rc = kstrtouint(buf, 10, &cnt);
+	if (rc)
+		return rc;
+
 	mutex_lock(&card->conf_mutex);
 	if (card->state != CARD_STATE_DOWN) {
 		rc = -EPERM;
 		goto out;
 	}
 
-	cnt = simple_strtoul(buf, &tmp, 10);
-	cnt = (cnt < QETH_IN_BUF_COUNT_MIN) ? QETH_IN_BUF_COUNT_MIN :
-		((cnt > QETH_IN_BUF_COUNT_MAX) ? QETH_IN_BUF_COUNT_MAX : cnt);
-
+	cnt = clamp(cnt, QETH_IN_BUF_COUNT_MIN, QETH_IN_BUF_COUNT_MAX);
 	rc = qeth_resize_buffer_pool(card, cnt);
 
 out:
@@ -341,18 +341,15 @@ static ssize_t qeth_dev_layer2_store(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 	struct net_device *ndev;
-	char *tmp;
-	int i, rc = 0;
 	enum qeth_discipline_id newdis;
+	unsigned int input;
+	int rc;
 
-	mutex_lock(&card->discipline_mutex);
-	if (card->state != CARD_STATE_DOWN) {
-		rc = -EPERM;
-		goto out;
-	}
+	rc = kstrtouint(buf, 16, &input);
+	if (rc)
+		return rc;
 
-	i = simple_strtoul(buf, &tmp, 16);
-	switch (i) {
+	switch (input) {
 	case 0:
 		newdis = QETH_DISCIPLINE_LAYER3;
 		break;
@@ -360,7 +357,12 @@ static ssize_t qeth_dev_layer2_store(struct device *dev,
 		newdis = QETH_DISCIPLINE_LAYER2;
 		break;
 	default:
-		rc = -EINVAL;
+		return -EINVAL;
+	}
+
+	mutex_lock(&card->discipline_mutex);
+	if (card->state != CARD_STATE_DOWN) {
+		rc = -EPERM;
 		goto out;
 	}
 
@@ -551,20 +553,21 @@ static DEVICE_ATTR(hw_trap, 0644, qeth_hw_trap_show,
 static ssize_t qeth_dev_blkt_store(struct qeth_card *card,
 		const char *buf, size_t count, int *value, int max_value)
 {
-	char *tmp;
-	int i, rc = 0;
+	unsigned int input;
+	int rc;
+
+	rc = kstrtouint(buf, 10, &input);
+	if (rc)
+		return rc;
+
+	if (input > max_value)
+		return -EINVAL;
 
 	mutex_lock(&card->conf_mutex);
-	if (card->state != CARD_STATE_DOWN) {
+	if (card->state != CARD_STATE_DOWN)
 		rc = -EPERM;
-		goto out;
-	}
-	i = simple_strtoul(buf, &tmp, 10);
-	if (i <= max_value)
-		*value = i;
 	else
-		rc = -EINVAL;
-out:
+		*value = input;
 	mutex_unlock(&card->conf_mutex);
 	return rc ? rc : count;
 }
diff --git a/drivers/s390/net/qeth_l3.h b/drivers/s390/net/qeth_l3.h
index 6ccfe2121095..acd130cfbab3 100644
--- a/drivers/s390/net/qeth_l3.h
+++ b/drivers/s390/net/qeth_l3.h
@@ -96,7 +96,7 @@ struct qeth_ipato_entry {
 	struct list_head entry;
 	enum qeth_prot_versions proto;
 	char addr[16];
-	int mask_bits;
+	unsigned int mask_bits;
 };
 
 extern const struct attribute_group *qeth_l3_attr_groups[];
@@ -110,7 +110,7 @@ int qeth_l3_setrouting_v6(struct qeth_card *);
 int qeth_l3_add_ipato_entry(struct qeth_card *, struct qeth_ipato_entry *);
 int qeth_l3_del_ipato_entry(struct qeth_card *card,
 			    enum qeth_prot_versions proto, u8 *addr,
-			    int mask_bits);
+			    unsigned int mask_bits);
 void qeth_l3_update_ipato(struct qeth_card *card);
 int qeth_l3_modify_hsuid(struct qeth_card *card, bool add);
 int qeth_l3_modify_rxip_vipa(struct qeth_card *card, bool add, const u8 *ip,
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 810d65fd48b4..876a21d451f5 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -105,11 +105,9 @@ static bool qeth_l3_is_addr_covered_by_ipato(struct qeth_card *card,
 					  (ipatoe->proto == QETH_PROT_IPV4) ?
 					  4 : 16);
 		if (addr->proto == QETH_PROT_IPV4)
-			rc = !memcmp(addr_bits, ipatoe_bits,
-				     min(32, ipatoe->mask_bits));
+			rc = !memcmp(addr_bits, ipatoe_bits, ipatoe->mask_bits);
 		else
-			rc = !memcmp(addr_bits, ipatoe_bits,
-				     min(128, ipatoe->mask_bits));
+			rc = !memcmp(addr_bits, ipatoe_bits, ipatoe->mask_bits);
 		if (rc)
 			break;
 	}
@@ -561,7 +559,7 @@ int qeth_l3_add_ipato_entry(struct qeth_card *card,
 
 int qeth_l3_del_ipato_entry(struct qeth_card *card,
 			    enum qeth_prot_versions proto, u8 *addr,
-			    int mask_bits)
+			    unsigned int mask_bits)
 {
 	struct qeth_ipato_entry *ipatoe, *tmp;
 	int rc = -ENOENT;
diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index 05fa986e30fc..351763ae9b9c 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -407,10 +407,9 @@ static ssize_t qeth_l3_dev_ipato_add4_show(struct device *dev,
 }
 
 static int qeth_l3_parse_ipatoe(const char *buf, enum qeth_prot_versions proto,
-		  u8 *addr, int *mask_bits)
+				u8 *addr, unsigned int *mask_bits)
 {
-	const char *start;
-	char *sep, *tmp;
+	char *sep;
 	int rc;
 
 	/* Expected input pattern: %addr/%mask */
@@ -424,13 +423,13 @@ static int qeth_l3_parse_ipatoe(const char *buf, enum qeth_prot_versions proto,
 	if (rc)
 		return rc;
 
-	start = sep + 1;
-	*mask_bits = simple_strtoul(start, &tmp, 10);
-	if (!strlen(start) ||
-	    (tmp == start) ||
-	    (*mask_bits > ((proto == QETH_PROT_IPV4) ? 32 : 128))) {
+	rc = kstrtouint(sep + 1, 10, mask_bits);
+	if (rc)
+		return rc;
+
+	if (*mask_bits > ((proto == QETH_PROT_IPV4) ? 32 : 128))
 		return -EINVAL;
-	}
+
 	return 0;
 }
 
@@ -438,8 +437,8 @@ static ssize_t qeth_l3_dev_ipato_add_store(const char *buf, size_t count,
 			 struct qeth_card *card, enum qeth_prot_versions proto)
 {
 	struct qeth_ipato_entry *ipatoe;
+	unsigned int mask_bits;
 	u8 addr[16];
-	int mask_bits;
 	int rc = 0;
 
 	rc = qeth_l3_parse_ipatoe(buf, proto, addr, &mask_bits);
@@ -476,8 +475,8 @@ static QETH_DEVICE_ATTR(ipato_add4, add4, 0644,
 static ssize_t qeth_l3_dev_ipato_del_store(const char *buf, size_t count,
 			 struct qeth_card *card, enum qeth_prot_versions proto)
 {
+	unsigned int mask_bits;
 	u8 addr[16];
-	int mask_bits;
 	int rc = 0;
 
 	rc = qeth_l3_parse_ipatoe(buf, proto, addr, &mask_bits);
-- 
2.17.1

