Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D23FC3EB
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKNKTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:19:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64806 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726996AbfKNKTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:19:49 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEAIfWg112668
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:19:48 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w91m7ejvr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:19:45 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 14 Nov 2019 10:19:35 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 10:19:32 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEAJVWq50135290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 10:19:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 377B1A405E;
        Thu, 14 Nov 2019 10:19:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0B78A4057;
        Thu, 14 Nov 2019 10:19:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 10:19:30 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 10/11] s390/qeth: replace qeth_l3_get_addr_buffer()
Date:   Thu, 14 Nov 2019 11:19:23 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114101924.29558-1-jwi@linux.ibm.com>
References: <20191114101924.29558-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111410-0028-0000-0000-000003B6CD1D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111410-0029-0000-0000-00002479D970
Message-Id: <20191114101924.29558-11-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The remaining usage effectively is a kmemdup() of the query object.
By not wrapping it, some of the callers can now use GFP_KERNEL for the
allocation.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3.h      |  1 +
 drivers/s390/net/qeth_l3_main.c | 62 ++++++++++++---------------------
 2 files changed, 23 insertions(+), 40 deletions(-)

diff --git a/drivers/s390/net/qeth_l3.h b/drivers/s390/net/qeth_l3.h
index ba913d1ab88d..2421f29021c1 100644
--- a/drivers/s390/net/qeth_l3.h
+++ b/drivers/s390/net/qeth_l3.h
@@ -54,6 +54,7 @@ static inline void qeth_l3_init_ipaddr(struct qeth_ipaddr *addr,
 	addr->type = type;
 	addr->proto = proto;
 	addr->disp_flag = QETH_DISP_ADDR_DO_NOTHING;
+	addr->ref_counter = 1;
 }
 
 static inline bool qeth_l3_addr_match_ip(struct qeth_ipaddr *a1,
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index f4c65971321a..e7ce73b9f016 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -63,15 +63,6 @@ void qeth_l3_ipaddr_to_string(enum qeth_prot_versions proto, const __u8 *addr,
 		qeth_l3_ipaddr6_to_string(addr, buf);
 }
 
-static struct qeth_ipaddr *qeth_l3_get_addr_buffer(enum qeth_prot_versions prot)
-{
-	struct qeth_ipaddr *addr = kmalloc(sizeof(*addr), GFP_ATOMIC);
-
-	if (addr)
-		qeth_l3_init_ipaddr(addr, QETH_IP_TYPE_NORMAL, prot);
-	return addr;
-}
-
 static struct qeth_ipaddr *qeth_l3_find_addr_by_ip(struct qeth_card *card,
 						   struct qeth_ipaddr *query)
 {
@@ -216,13 +207,10 @@ static int qeth_l3_add_ip(struct qeth_card *card, struct qeth_ipaddr *tmp_addr)
 			 "Registering IP address %s failed\n", buf);
 		return -EADDRINUSE;
 	} else {
-		addr = qeth_l3_get_addr_buffer(tmp_addr->proto);
+		addr = kmemdup(tmp_addr, sizeof(*tmp_addr), GFP_KERNEL);
 		if (!addr)
 			return -ENOMEM;
 
-		memcpy(addr, tmp_addr, sizeof(struct qeth_ipaddr));
-		addr->ref_counter = 1;
-
 		if (qeth_l3_is_addr_covered_by_ipato(card, addr)) {
 			QETH_CARD_TEXT(card, 2, "tkovaddr");
 			addr->ipato = 1;
@@ -1115,11 +1103,11 @@ qeth_diags_trace(struct qeth_card *card, enum qeth_diags_trace_cmds diags_cmd)
 
 static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
 {
-	struct qeth_ipaddr *tmp = NULL;
 	struct qeth_card *card = arg;
 	struct inet6_dev *in6_dev;
 	struct in_device *in4_dev;
 	struct qeth_ipaddr *ipm;
+	struct qeth_ipaddr tmp;
 	struct ip_mc_list *im4;
 	struct ifmcaddr6 *im6;
 
@@ -1128,34 +1116,31 @@ static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
 	if (!dev || !(dev->flags & IFF_UP))
 		goto out;
 
-	tmp = qeth_l3_get_addr_buffer(QETH_PROT_IPV4);
-	if (!tmp)
-		goto out;
-
 	in4_dev = __in_dev_get_rtnl(dev);
 	if (!in4_dev)
 		goto walk_ipv6;
 
+	qeth_l3_init_ipaddr(&tmp, QETH_IP_TYPE_NORMAL, QETH_PROT_IPV4);
+	tmp.disp_flag = QETH_DISP_ADDR_ADD;
+	tmp.is_multicast = 1;
+
 	for (im4 = rtnl_dereference(in4_dev->mc_list); im4 != NULL;
 	     im4 = rtnl_dereference(im4->next_rcu)) {
-		tmp->u.a4.addr = im4->multiaddr;
-		tmp->is_multicast = 1;
+		tmp.u.a4.addr = im4->multiaddr;
 
-		ipm = qeth_l3_find_addr_by_ip(card, tmp);
+		ipm = qeth_l3_find_addr_by_ip(card, &tmp);
 		if (ipm) {
 			/* for mcast, by-IP match means full match */
 			ipm->disp_flag = QETH_DISP_ADDR_DO_NOTHING;
-		} else {
-			ipm = qeth_l3_get_addr_buffer(QETH_PROT_IPV4);
-			if (!ipm)
-				continue;
-
-			ipm->u.a4.addr = im4->multiaddr;
-			ipm->is_multicast = 1;
-			ipm->disp_flag = QETH_DISP_ADDR_ADD;
-			hash_add(card->ip_mc_htable,
-					&ipm->hnode, qeth_l3_ipaddr_hash(ipm));
+			continue;
 		}
+
+		ipm = kmemdup(&tmp, sizeof(tmp), GFP_KERNEL);
+		if (!ipm)
+			continue;
+
+		hash_add(card->ip_mc_htable, &ipm->hnode,
+			 qeth_l3_ipaddr_hash(ipm));
 	}
 
 walk_ipv6:
@@ -1166,27 +1151,25 @@ static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
 	if (!in6_dev)
 		goto out;
 
-	qeth_l3_init_ipaddr(tmp, QETH_IP_TYPE_NORMAL, QETH_PROT_IPV6);
+	qeth_l3_init_ipaddr(&tmp, QETH_IP_TYPE_NORMAL, QETH_PROT_IPV6);
+	tmp.disp_flag = QETH_DISP_ADDR_ADD;
+	tmp.is_multicast = 1;
 
 	read_lock_bh(&in6_dev->lock);
 	for (im6 = in6_dev->mc_list; im6 != NULL; im6 = im6->next) {
-		tmp->u.a6.addr = im6->mca_addr;
-		tmp->is_multicast = 1;
+		tmp.u.a6.addr = im6->mca_addr;
 
-		ipm = qeth_l3_find_addr_by_ip(card, tmp);
+		ipm = qeth_l3_find_addr_by_ip(card, &tmp);
 		if (ipm) {
 			/* for mcast, by-IP match means full match */
 			ipm->disp_flag = QETH_DISP_ADDR_DO_NOTHING;
 			continue;
 		}
 
-		ipm = qeth_l3_get_addr_buffer(QETH_PROT_IPV6);
+		ipm = kmemdup(&tmp, sizeof(tmp), GFP_ATOMIC);
 		if (!ipm)
 			continue;
 
-		ipm->u.a6.addr = im6->mca_addr;
-		ipm->is_multicast = 1;
-		ipm->disp_flag = QETH_DISP_ADDR_ADD;
 		hash_add(card->ip_mc_htable,
 				&ipm->hnode, qeth_l3_ipaddr_hash(ipm));
 
@@ -1194,7 +1177,6 @@ static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
 	read_unlock_bh(&in6_dev->lock);
 
 out:
-	kfree(tmp);
 	return 0;
 }
 
-- 
2.17.1

