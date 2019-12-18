Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C176124DD0
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfLRQfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:35:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22116 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727484AbfLRQfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:35:00 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIGYVr6049884
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:35:00 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wye06q91w-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:34:59 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Dec 2019 16:34:57 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Dec 2019 16:34:54 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBIGYr6o47054926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 16:34:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02DB4A404D;
        Wed, 18 Dec 2019 16:34:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B73CDA4053;
        Wed, 18 Dec 2019 16:34:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Dec 2019 16:34:52 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 4/9] s390/qeth: clean up L3 sysfs code
Date:   Wed, 18 Dec 2019 17:34:45 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218163450.36731-1-jwi@linux.ibm.com>
References: <20191218163450.36731-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19121816-0012-0000-0000-000003764000
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121816-0013-0000-0000-000021B22F96
Message-Id: <20191218163450.36731-5-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_05:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912180136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consolidate some duplicated code for adding RXIP/VIPA addresses, and
move the locking to where it's actually needed.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3_main.c |  12 +++-
 drivers/s390/net/qeth_l3_sys.c  | 106 +++++++-------------------------
 2 files changed, 33 insertions(+), 85 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 3710761831cc..8db548340632 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -571,6 +571,7 @@ int qeth_l3_add_ipato_entry(struct qeth_card *card,
 
 	QETH_CARD_TEXT(card, 2, "addipato");
 
+	mutex_lock(&card->conf_mutex);
 	mutex_lock(&card->ip_lock);
 
 	list_for_each_entry(ipatoe, &card->ipato.entries, entry) {
@@ -590,6 +591,7 @@ int qeth_l3_add_ipato_entry(struct qeth_card *card,
 	}
 
 	mutex_unlock(&card->ip_lock);
+	mutex_unlock(&card->conf_mutex);
 
 	return rc;
 }
@@ -603,6 +605,7 @@ int qeth_l3_del_ipato_entry(struct qeth_card *card,
 
 	QETH_CARD_TEXT(card, 2, "delipato");
 
+	mutex_lock(&card->conf_mutex);
 	mutex_lock(&card->ip_lock);
 
 	list_for_each_entry_safe(ipatoe, tmp, &card->ipato.entries, entry) {
@@ -619,6 +622,8 @@ int qeth_l3_del_ipato_entry(struct qeth_card *card,
 	}
 
 	mutex_unlock(&card->ip_lock);
+	mutex_unlock(&card->conf_mutex);
+
 	return rc;
 }
 
@@ -627,6 +632,7 @@ int qeth_l3_modify_rxip_vipa(struct qeth_card *card, bool add, const u8 *ip,
 			     enum qeth_prot_versions proto)
 {
 	struct qeth_ipaddr addr;
+	int rc;
 
 	qeth_l3_init_ipaddr(&addr, type, proto);
 	if (proto == QETH_PROT_IPV4)
@@ -634,7 +640,11 @@ int qeth_l3_modify_rxip_vipa(struct qeth_card *card, bool add, const u8 *ip,
 	else
 		memcpy(&addr.u.a6.addr, ip, 16);
 
-	return qeth_l3_modify_ip(card, &addr, add);
+	mutex_lock(&card->conf_mutex);
+	rc = qeth_l3_modify_ip(card, &addr, add);
+	mutex_unlock(&card->conf_mutex);
+
+	return rc;
 }
 
 int qeth_l3_modify_hsuid(struct qeth_card *card, bool add)
diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index aa9f3fc45447..96c73965eb68 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -460,16 +460,14 @@ static ssize_t qeth_l3_dev_ipato_add_store(const char *buf, size_t count,
 	int mask_bits;
 	int rc = 0;
 
-	mutex_lock(&card->conf_mutex);
 	rc = qeth_l3_parse_ipatoe(buf, proto, addr, &mask_bits);
 	if (rc)
-		goto out;
+		return rc;
 
 	ipatoe = kzalloc(sizeof(struct qeth_ipato_entry), GFP_KERNEL);
-	if (!ipatoe) {
-		rc = -ENOMEM;
-		goto out;
-	}
+	if (!ipatoe)
+		return -ENOMEM;
+
 	ipatoe->proto = proto;
 	memcpy(ipatoe->addr, addr, (proto == QETH_PROT_IPV4)? 4:16);
 	ipatoe->mask_bits = mask_bits;
@@ -477,8 +475,7 @@ static ssize_t qeth_l3_dev_ipato_add_store(const char *buf, size_t count,
 	rc = qeth_l3_add_ipato_entry(card, ipatoe);
 	if (rc)
 		kfree(ipatoe);
-out:
-	mutex_unlock(&card->conf_mutex);
+
 	return rc ? rc : count;
 }
 
@@ -501,11 +498,9 @@ static ssize_t qeth_l3_dev_ipato_del_store(const char *buf, size_t count,
 	int mask_bits;
 	int rc = 0;
 
-	mutex_lock(&card->conf_mutex);
 	rc = qeth_l3_parse_ipatoe(buf, proto, addr, &mask_bits);
 	if (!rc)
 		rc = qeth_l3_del_ipato_entry(card, proto, addr, mask_bits);
-	mutex_unlock(&card->conf_mutex);
 	return rc ? rc : count;
 }
 
@@ -650,63 +645,34 @@ static ssize_t qeth_l3_dev_vipa_add4_show(struct device *dev,
 				       QETH_IP_TYPE_VIPA);
 }
 
-static int qeth_l3_parse_vipae(const char *buf, enum qeth_prot_versions proto,
-		 u8 *addr)
-{
-	if (qeth_l3_string_to_ipaddr(buf, proto, addr)) {
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static ssize_t qeth_l3_dev_vipa_add_store(const char *buf, size_t count,
-			struct qeth_card *card, enum qeth_prot_versions proto)
+static ssize_t qeth_l3_vipa_store(struct device *dev, const char *buf, bool add,
+				  size_t count, enum qeth_prot_versions proto)
 {
+	struct qeth_card *card = dev_get_drvdata(dev);
 	u8 addr[16] = {0, };
 	int rc;
 
-	mutex_lock(&card->conf_mutex);
-	rc = qeth_l3_parse_vipae(buf, proto, addr);
+	rc = qeth_l3_string_to_ipaddr(buf, proto, addr);
 	if (!rc)
-		rc = qeth_l3_modify_rxip_vipa(card, true, addr,
+		rc = qeth_l3_modify_rxip_vipa(card, add, addr,
 					      QETH_IP_TYPE_VIPA, proto);
-	mutex_unlock(&card->conf_mutex);
 	return rc ? rc : count;
 }
 
 static ssize_t qeth_l3_dev_vipa_add4_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct qeth_card *card = dev_get_drvdata(dev);
-
-	return qeth_l3_dev_vipa_add_store(buf, count, card, QETH_PROT_IPV4);
+	return qeth_l3_vipa_store(dev, buf, true, count, QETH_PROT_IPV4);
 }
 
 static QETH_DEVICE_ATTR(vipa_add4, add4, 0644,
 			qeth_l3_dev_vipa_add4_show,
 			qeth_l3_dev_vipa_add4_store);
 
-static ssize_t qeth_l3_dev_vipa_del_store(const char *buf, size_t count,
-			 struct qeth_card *card, enum qeth_prot_versions proto)
-{
-	u8 addr[16];
-	int rc;
-
-	mutex_lock(&card->conf_mutex);
-	rc = qeth_l3_parse_vipae(buf, proto, addr);
-	if (!rc)
-		rc = qeth_l3_modify_rxip_vipa(card, false, addr,
-					      QETH_IP_TYPE_VIPA, proto);
-	mutex_unlock(&card->conf_mutex);
-	return rc ? rc : count;
-}
-
 static ssize_t qeth_l3_dev_vipa_del4_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct qeth_card *card = dev_get_drvdata(dev);
-
-	return qeth_l3_dev_vipa_del_store(buf, count, card, QETH_PROT_IPV4);
+	return qeth_l3_vipa_store(dev, buf, true, count, QETH_PROT_IPV4);
 }
 
 static QETH_DEVICE_ATTR(vipa_del4, del4, 0200, NULL,
@@ -723,9 +689,7 @@ static ssize_t qeth_l3_dev_vipa_add6_show(struct device *dev,
 static ssize_t qeth_l3_dev_vipa_add6_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct qeth_card *card = dev_get_drvdata(dev);
-
-	return qeth_l3_dev_vipa_add_store(buf, count, card, QETH_PROT_IPV6);
+	return qeth_l3_vipa_store(dev, buf, true, count, QETH_PROT_IPV6);
 }
 
 static QETH_DEVICE_ATTR(vipa_add6, add6, 0644,
@@ -735,9 +699,7 @@ static QETH_DEVICE_ATTR(vipa_add6, add6, 0644,
 static ssize_t qeth_l3_dev_vipa_del6_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct qeth_card *card = dev_get_drvdata(dev);
-
-	return qeth_l3_dev_vipa_del_store(buf, count, card, QETH_PROT_IPV6);
+	return qeth_l3_vipa_store(dev, buf, false, count, QETH_PROT_IPV6);
 }
 
 static QETH_DEVICE_ATTR(vipa_del6, del6, 0200, NULL,
@@ -790,54 +752,34 @@ static int qeth_l3_parse_rxipe(const char *buf, enum qeth_prot_versions proto,
 	return 0;
 }
 
-static ssize_t qeth_l3_dev_rxip_add_store(const char *buf, size_t count,
-			struct qeth_card *card, enum qeth_prot_versions proto)
+static ssize_t qeth_l3_rxip_store(struct device *dev, const char *buf, bool add,
+				  size_t count, enum qeth_prot_versions proto)
 {
+	struct qeth_card *card = dev_get_drvdata(dev);
 	u8 addr[16] = {0, };
 	int rc;
 
-	mutex_lock(&card->conf_mutex);
 	rc = qeth_l3_parse_rxipe(buf, proto, addr);
 	if (!rc)
-		rc = qeth_l3_modify_rxip_vipa(card, true, addr,
+		rc = qeth_l3_modify_rxip_vipa(card, add, addr,
 					      QETH_IP_TYPE_RXIP, proto);
-	mutex_unlock(&card->conf_mutex);
 	return rc ? rc : count;
 }
 
 static ssize_t qeth_l3_dev_rxip_add4_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct qeth_card *card = dev_get_drvdata(dev);
-
-	return qeth_l3_dev_rxip_add_store(buf, count, card, QETH_PROT_IPV4);
+	return qeth_l3_rxip_store(dev, buf, true, count, QETH_PROT_IPV4);
 }
 
 static QETH_DEVICE_ATTR(rxip_add4, add4, 0644,
 			qeth_l3_dev_rxip_add4_show,
 			qeth_l3_dev_rxip_add4_store);
 
-static ssize_t qeth_l3_dev_rxip_del_store(const char *buf, size_t count,
-			struct qeth_card *card, enum qeth_prot_versions proto)
-{
-	u8 addr[16];
-	int rc;
-
-	mutex_lock(&card->conf_mutex);
-	rc = qeth_l3_parse_rxipe(buf, proto, addr);
-	if (!rc)
-		rc = qeth_l3_modify_rxip_vipa(card, false, addr,
-					      QETH_IP_TYPE_RXIP, proto);
-	mutex_unlock(&card->conf_mutex);
-	return rc ? rc : count;
-}
-
 static ssize_t qeth_l3_dev_rxip_del4_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct qeth_card *card = dev_get_drvdata(dev);
-
-	return qeth_l3_dev_rxip_del_store(buf, count, card, QETH_PROT_IPV4);
+	return qeth_l3_rxip_store(dev, buf, false, count, QETH_PROT_IPV4);
 }
 
 static QETH_DEVICE_ATTR(rxip_del4, del4, 0200, NULL,
@@ -854,9 +796,7 @@ static ssize_t qeth_l3_dev_rxip_add6_show(struct device *dev,
 static ssize_t qeth_l3_dev_rxip_add6_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct qeth_card *card = dev_get_drvdata(dev);
-
-	return qeth_l3_dev_rxip_add_store(buf, count, card, QETH_PROT_IPV6);
+	return qeth_l3_rxip_store(dev, buf, true, count, QETH_PROT_IPV6);
 }
 
 static QETH_DEVICE_ATTR(rxip_add6, add6, 0644,
@@ -866,9 +806,7 @@ static QETH_DEVICE_ATTR(rxip_add6, add6, 0644,
 static ssize_t qeth_l3_dev_rxip_del6_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct qeth_card *card = dev_get_drvdata(dev);
-
-	return qeth_l3_dev_rxip_del_store(buf, count, card, QETH_PROT_IPV6);
+	return qeth_l3_rxip_store(dev, buf, false, count, QETH_PROT_IPV6);
 }
 
 static QETH_DEVICE_ATTR(rxip_del6, del6, 0200, NULL,
-- 
2.17.1

