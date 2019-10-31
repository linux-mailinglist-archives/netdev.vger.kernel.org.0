Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2BE4EB07F
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 13:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfJaMmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 08:42:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4256 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727159AbfJaMmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 08:42:36 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9VCcl4O116074
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 08:42:34 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vywt84k35-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 08:42:34 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 31 Oct 2019 12:42:31 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 31 Oct 2019 12:42:27 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9VCgQFG48496746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Oct 2019 12:42:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1D8211C050;
        Thu, 31 Oct 2019 12:42:25 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B20E611C05C;
        Thu, 31 Oct 2019 12:42:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Oct 2019 12:42:25 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 7/8] s390/qeth: use helpers for IP address hashing
Date:   Thu, 31 Oct 2019 13:42:20 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191031124221.34028-1-jwi@linux.ibm.com>
References: <20191031124221.34028-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19103112-4275-0000-0000-000003798B89
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19103112-4276-0000-0000-0000388CC9F4
Message-Id: <20191031124221.34028-8-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-31_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910310131
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace our custom implementations with the stack's version of IP address
hashing.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3.h      | 21 ++++++---------------
 drivers/s390/net/qeth_l3_main.c |  8 ++++----
 2 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/s390/net/qeth_l3.h b/drivers/s390/net/qeth_l3.h
index 87659cfc9066..b7ba404a81f9 100644
--- a/drivers/s390/net/qeth_l3.h
+++ b/drivers/s390/net/qeth_l3.h
@@ -37,7 +37,7 @@ struct qeth_ipaddr {
 	enum qeth_prot_versions proto;
 	union {
 		struct {
-			unsigned int addr;
+			__be32 addr;
 			unsigned int mask;
 		} a4;
 		struct {
@@ -89,21 +89,12 @@ static inline bool qeth_l3_addr_match_all(struct qeth_ipaddr *a1,
 	return a1->u.a4.mask == a2->u.a4.mask;
 }
 
-static inline  u64 qeth_l3_ipaddr_hash(struct qeth_ipaddr *addr)
+static inline u32 qeth_l3_ipaddr_hash(struct qeth_ipaddr *addr)
 {
-	u64  ret = 0;
-	u8 *point;
-
-	if (addr->proto == QETH_PROT_IPV6) {
-		point = (u8 *) &addr->u.a6.addr;
-		ret = get_unaligned((u64 *)point) ^
-			get_unaligned((u64 *) (point + 8));
-	}
-	if (addr->proto == QETH_PROT_IPV4) {
-		point = (u8 *) &addr->u.a4.addr;
-		ret = get_unaligned((u32 *) point);
-	}
-	return ret;
+	if (addr->proto == QETH_PROT_IPV6)
+		return ipv6_addr_hash(&addr->u.a6.addr);
+	else
+		return ipv4_addr_hash(addr->u.a4.addr);
 }
 
 struct qeth_ipato_entry {
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index acae44a699ad..8f92407bf580 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -76,7 +76,7 @@ static struct qeth_ipaddr *qeth_l3_get_addr_buffer(enum qeth_prot_versions prot)
 static struct qeth_ipaddr *qeth_l3_find_addr_by_ip(struct qeth_card *card,
 						   struct qeth_ipaddr *query)
 {
-	u64 key = qeth_l3_ipaddr_hash(query);
+	u32 key = qeth_l3_ipaddr_hash(query);
 	struct qeth_ipaddr *addr;
 
 	if (query->is_multicast) {
@@ -1128,7 +1128,7 @@ qeth_l3_add_mc_to_hash(struct qeth_card *card, struct in_device *in4_dev)
 	for (im4 = rcu_dereference(in4_dev->mc_list); im4 != NULL;
 	     im4 = rcu_dereference(im4->next_rcu)) {
 		ip_eth_mc_map(im4->multiaddr, tmp->mac);
-		tmp->u.a4.addr = be32_to_cpu(im4->multiaddr);
+		tmp->u.a4.addr = im4->multiaddr;
 		tmp->is_multicast = 1;
 
 		ipm = qeth_l3_find_addr_by_ip(card, tmp);
@@ -1140,7 +1140,7 @@ qeth_l3_add_mc_to_hash(struct qeth_card *card, struct in_device *in4_dev)
 			if (!ipm)
 				continue;
 			ether_addr_copy(ipm->mac, tmp->mac);
-			ipm->u.a4.addr = be32_to_cpu(im4->multiaddr);
+			ipm->u.a4.addr = im4->multiaddr;
 			ipm->is_multicast = 1;
 			ipm->disp_flag = QETH_DISP_ADDR_ADD;
 			hash_add(card->ip_mc_htable,
@@ -2548,7 +2548,7 @@ static int qeth_l3_ip_event(struct notifier_block *this,
 	QETH_CARD_TEXT(card, 3, "ipevent");
 
 	qeth_l3_init_ipaddr(&addr, QETH_IP_TYPE_NORMAL, QETH_PROT_IPV4);
-	addr.u.a4.addr = be32_to_cpu(ifa->ifa_address);
+	addr.u.a4.addr = ifa->ifa_address;
 	addr.u.a4.mask = be32_to_cpu(ifa->ifa_mask);
 
 	return qeth_l3_handle_ip_event(card, &addr, event);
-- 
2.17.1

