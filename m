Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B99CA124DDE
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfLRQfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:35:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31452 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727535AbfLRQfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:35:00 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIGYUSV004971
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:34:58 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wyncxec1v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:34:58 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Dec 2019 16:34:56 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Dec 2019 16:34:54 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBIGYqaS15532250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 16:34:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2374A4040;
        Wed, 18 Dec 2019 16:34:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F628A4055;
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
Subject: [PATCH net-next 3/9] s390/qeth: overhaul L3 IP address dump code
Date:   Wed, 18 Dec 2019 17:34:44 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218163450.36731-1-jwi@linux.ibm.com>
References: <20191218163450.36731-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19121816-0028-0000-0000-000003C9F646
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121816-0029-0000-0000-0000248D43BD
Message-Id: <20191218163450.36731-4-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_05:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxlogscore=973 spamscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 adultscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code that dumps the RXIP/VIPA/IPATO addresses via sysfs
first checks whether the buffer still provides sufficient space to hold
another formatted address.
But the maximum length of an formatted IPv4 address is 15 characters,
not 12. So we underestimate the max required length and if the buffer
was previously filled to _just_ the right level, a formatted address can
end up being truncated.

Revamp these code paths to use the _actually_ required length of the
formatted IP address, and while at it suppress a gratuitous newline.

Also use scnprintf() to format the output. In case of a truncation, this
would allow us to return the number of characters that were actually
written.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3.h      |  3 +-
 drivers/s390/net/qeth_l3_main.c | 20 +++-------
 drivers/s390/net/qeth_l3_sys.c  | 66 ++++++++++++++++++---------------
 3 files changed, 44 insertions(+), 45 deletions(-)

diff --git a/drivers/s390/net/qeth_l3.h b/drivers/s390/net/qeth_l3.h
index 5db04fe472c0..2383ffad0a4a 100644
--- a/drivers/s390/net/qeth_l3.h
+++ b/drivers/s390/net/qeth_l3.h
@@ -102,7 +102,8 @@ struct qeth_ipato_entry {
 
 extern const struct attribute_group *qeth_l3_attr_groups[];
 
-void qeth_l3_ipaddr_to_string(enum qeth_prot_versions, const __u8 *, char *);
+int qeth_l3_ipaddr_to_string(enum qeth_prot_versions proto, const u8 *addr,
+			     char *buf);
 int qeth_l3_create_device_attributes(struct device *);
 void qeth_l3_remove_device_attributes(struct device *);
 int qeth_l3_setrouting_v4(struct qeth_card *);
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 27126330a4b0..3710761831cc 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -44,23 +44,13 @@ static int qeth_l3_register_addr_entry(struct qeth_card *,
 static int qeth_l3_deregister_addr_entry(struct qeth_card *,
 		struct qeth_ipaddr *);
 
-static void qeth_l3_ipaddr4_to_string(const __u8 *addr, char *buf)
-{
-	sprintf(buf, "%pI4", addr);
-}
-
-static void qeth_l3_ipaddr6_to_string(const __u8 *addr, char *buf)
-{
-	sprintf(buf, "%pI6", addr);
-}
-
-void qeth_l3_ipaddr_to_string(enum qeth_prot_versions proto, const __u8 *addr,
-				char *buf)
+int qeth_l3_ipaddr_to_string(enum qeth_prot_versions proto, const u8 *addr,
+			     char *buf)
 {
 	if (proto == QETH_PROT_IPV4)
-		qeth_l3_ipaddr4_to_string(addr, buf);
-	else if (proto == QETH_PROT_IPV6)
-		qeth_l3_ipaddr6_to_string(addr, buf);
+		return sprintf(buf, "%pI4", addr);
+	else
+		return sprintf(buf, "%pI6", addr);
 }
 
 static struct qeth_ipaddr *qeth_l3_find_addr_by_ip(struct qeth_card *card,
diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index f9067ed6c7d3..aa9f3fc45447 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -386,30 +386,35 @@ static ssize_t qeth_l3_dev_ipato_add_show(char *buf, struct qeth_card *card,
 			enum qeth_prot_versions proto)
 {
 	struct qeth_ipato_entry *ipatoe;
-	char addr_str[40];
-	int entry_len; /* length of 1 entry string, differs between v4 and v6 */
-	int i = 0;
+	int str_len = 0;
 
-	entry_len = (proto == QETH_PROT_IPV4)? 12 : 40;
-	/* add strlen for "/<mask>\n" */
-	entry_len += (proto == QETH_PROT_IPV4)? 5 : 6;
 	mutex_lock(&card->ip_lock);
 	list_for_each_entry(ipatoe, &card->ipato.entries, entry) {
+		char addr_str[40];
+		int entry_len;
+
 		if (ipatoe->proto != proto)
 			continue;
-		/* String must not be longer than PAGE_SIZE. So we check if
-		 * string length gets near PAGE_SIZE. Then we can savely display
-		 * the next IPv6 address (worst case, compared to IPv4) */
-		if ((PAGE_SIZE - i) <= entry_len)
+
+		entry_len = qeth_l3_ipaddr_to_string(proto, ipatoe->addr,
+						     addr_str);
+		if (entry_len < 0)
+			continue;
+
+		/* Append /%mask to the entry: */
+		entry_len += 1 + ((proto == QETH_PROT_IPV4) ? 2 : 3);
+		/* Enough room to format %entry\n into null terminated page? */
+		if (entry_len + 1 > PAGE_SIZE - str_len - 1)
 			break;
-		qeth_l3_ipaddr_to_string(proto, ipatoe->addr, addr_str);
-		i += snprintf(buf + i, PAGE_SIZE - i,
-			      "%s/%i\n", addr_str, ipatoe->mask_bits);
+
+		entry_len = scnprintf(buf, PAGE_SIZE - str_len,
+				      "%s/%i\n", addr_str, ipatoe->mask_bits);
+		str_len += entry_len;
+		buf += entry_len;
 	}
 	mutex_unlock(&card->ip_lock);
-	i += snprintf(buf + i, PAGE_SIZE - i, "\n");
 
-	return i;
+	return str_len ? str_len : scnprintf(buf, PAGE_SIZE, "\n");
 }
 
 static ssize_t qeth_l3_dev_ipato_add4_show(struct device *dev,
@@ -607,31 +612,34 @@ static ssize_t qeth_l3_dev_ip_add_show(struct device *dev, char *buf,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 	struct qeth_ipaddr *ipaddr;
-	char addr_str[40];
 	int str_len = 0;
-	int entry_len; /* length of 1 entry string, differs between v4 and v6 */
 	int i;
 
-	entry_len = (proto == QETH_PROT_IPV4)? 12 : 40;
-	entry_len += 2; /* \n + terminator */
 	mutex_lock(&card->ip_lock);
 	hash_for_each(card->ip_htable, i, ipaddr, hnode) {
+		char addr_str[40];
+		int entry_len;
+
 		if (ipaddr->proto != proto || ipaddr->type != type)
 			continue;
-		/* String must not be longer than PAGE_SIZE. So we check if
-		 * string length gets near PAGE_SIZE. Then we can savely display
-		 * the next IPv6 address (worst case, compared to IPv4) */
-		if ((PAGE_SIZE - str_len) <= entry_len)
+
+		entry_len = qeth_l3_ipaddr_to_string(proto, (u8 *)&ipaddr->u,
+						     addr_str);
+		if (entry_len < 0)
+			continue;
+
+		/* Enough room to format %addr\n into null terminated page? */
+		if (entry_len + 1 > PAGE_SIZE - str_len - 1)
 			break;
-		qeth_l3_ipaddr_to_string(proto, (const u8 *)&ipaddr->u,
-			addr_str);
-		str_len += snprintf(buf + str_len, PAGE_SIZE - str_len, "%s\n",
-				    addr_str);
+
+		entry_len = scnprintf(buf, PAGE_SIZE - str_len, "%s\n",
+				      addr_str);
+		str_len += entry_len;
+		buf += entry_len;
 	}
 	mutex_unlock(&card->ip_lock);
-	str_len += snprintf(buf + str_len, PAGE_SIZE - str_len, "\n");
 
-	return str_len;
+	return str_len ? str_len : scnprintf(buf, PAGE_SIZE, "\n");
 }
 
 static ssize_t qeth_l3_dev_vipa_add4_show(struct device *dev,
-- 
2.17.1

