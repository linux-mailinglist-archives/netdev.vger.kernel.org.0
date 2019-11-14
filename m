Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74471FC3E1
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfKNKTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:19:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63470 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725977AbfKNKTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:19:37 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEAIJZM018403
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:19:36 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w94yk05ge-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:19:35 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 14 Nov 2019 10:19:33 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 10:19:32 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEAJUN560686408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 10:19:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9ED52A4040;
        Thu, 14 Nov 2019 10:19:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63C99A404D;
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
Subject: [PATCH net-next 08/11] s390/qeth: consolidate L3 mcast registration code
Date:   Thu, 14 Nov 2019 11:19:21 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114101924.29558-1-jwi@linux.ibm.com>
References: <20191114101924.29558-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111410-0016-0000-0000-000002C38FF7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111410-0017-0000-0000-0000332530B6
Message-Id: <20191114101924.29558-9-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=896 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code processes each (VLAN) device twice - once to inspect the
IPv4 mcast addresses, and then a second time to walk the IPv6 mcast
addresses. Unify all this into a single helper, thus removing some
checks and a duplicated VLAN lookup.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3_main.c | 120 ++++++++------------------------
 1 file changed, 30 insertions(+), 90 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 0497ee46660b..1e060331a8cc 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1113,17 +1113,28 @@ qeth_diags_trace(struct qeth_card *card, enum qeth_diags_trace_cmds diags_cmd)
 	return qeth_send_ipa_cmd(card, iob, qeth_diags_trace_cb, NULL);
 }
 
-static void
-qeth_l3_add_mc_to_hash(struct qeth_card *card, struct in_device *in4_dev)
+static void qeth_l3_add_mcast_rcu(struct net_device *dev,
+				  struct qeth_card *card)
 {
+	struct qeth_ipaddr *tmp = NULL;
+	struct inet6_dev *in6_dev;
+	struct in_device *in4_dev;
+	struct qeth_ipaddr *ipm;
 	struct ip_mc_list *im4;
-	struct qeth_ipaddr *tmp, *ipm;
+	struct ifmcaddr6 *im6;
 
 	QETH_CARD_TEXT(card, 4, "addmc");
 
+	if (!dev || !(dev->flags & IFF_UP))
+		goto out;
+
 	tmp = qeth_l3_get_addr_buffer(QETH_PROT_IPV4);
 	if (!tmp)
-		return;
+		goto out;
+
+	in4_dev = __in_dev_get_rcu(dev);
+	if (!in4_dev)
+		goto walk_ipv6;
 
 	for (im4 = rcu_dereference(in4_dev->mc_list); im4 != NULL;
 	     im4 = rcu_dereference(im4->next_rcu)) {
@@ -1147,63 +1158,15 @@ qeth_l3_add_mc_to_hash(struct qeth_card *card, struct in_device *in4_dev)
 		}
 	}
 
-	kfree(tmp);
-}
-
-/* called with rcu_read_lock */
-static void qeth_l3_add_vlan_mc(struct qeth_card *card)
-{
-	struct in_device *in_dev;
-	u16 vid;
-
-	QETH_CARD_TEXT(card, 4, "addmcvl");
-
-	if (!qeth_is_supported(card, IPA_FULL_VLAN))
-		return;
-
-	for_each_set_bit(vid, card->active_vlans, VLAN_N_VID) {
-		struct net_device *netdev;
-
-		netdev = __vlan_find_dev_deep_rcu(card->dev, htons(ETH_P_8021Q),
-					      vid);
-		if (netdev == NULL ||
-		    !(netdev->flags & IFF_UP))
-			continue;
-		in_dev = __in_dev_get_rcu(netdev);
-		if (!in_dev)
-			continue;
-		qeth_l3_add_mc_to_hash(card, in_dev);
-	}
-}
-
-static void qeth_l3_add_multicast_ipv4(struct qeth_card *card)
-{
-	struct in_device *in4_dev;
-
-	QETH_CARD_TEXT(card, 4, "chkmcv4");
-
-	rcu_read_lock();
-	in4_dev = __in_dev_get_rcu(card->dev);
-	if (in4_dev == NULL)
-		goto unlock;
-	qeth_l3_add_mc_to_hash(card, in4_dev);
-	qeth_l3_add_vlan_mc(card);
-unlock:
-	rcu_read_unlock();
-}
-
-static void qeth_l3_add_mc6_to_hash(struct qeth_card *card,
-				    struct inet6_dev *in6_dev)
-{
-	struct qeth_ipaddr *ipm;
-	struct ifmcaddr6 *im6;
-	struct qeth_ipaddr *tmp;
+walk_ipv6:
+	if (!qeth_is_supported(card, IPA_IPV6))
+		goto out;
 
-	QETH_CARD_TEXT(card, 4, "addmc6");
+	in6_dev = __in6_dev_get(dev);
+	if (!in6_dev)
+		goto out;
 
-	tmp = qeth_l3_get_addr_buffer(QETH_PROT_IPV6);
-	if (!tmp)
-		return;
+	qeth_l3_init_ipaddr(tmp, QETH_IP_TYPE_NORMAL, QETH_PROT_IPV6);
 
 	read_lock_bh(&in6_dev->lock);
 	for (im6 = in6_dev->mc_list; im6 != NULL; im6 = im6->next) {
@@ -1230,13 +1193,13 @@ static void qeth_l3_add_mc6_to_hash(struct qeth_card *card,
 	}
 	read_unlock_bh(&in6_dev->lock);
 
+out:
 	kfree(tmp);
 }
 
 /* called with rcu_read_lock */
-static void qeth_l3_add_vlan_mc6(struct qeth_card *card)
+static void qeth_l3_add_vlan_mc(struct qeth_card *card)
 {
-	struct inet6_dev *in_dev;
 	u16 vid;
 
 	QETH_CARD_TEXT(card, 4, "admc6vl");
@@ -1249,36 +1212,10 @@ static void qeth_l3_add_vlan_mc6(struct qeth_card *card)
 
 		netdev = __vlan_find_dev_deep_rcu(card->dev, htons(ETH_P_8021Q),
 					      vid);
-		if (netdev == NULL ||
-		    !(netdev->flags & IFF_UP))
-			continue;
-		in_dev = in6_dev_get(netdev);
-		if (!in_dev)
-			continue;
-		qeth_l3_add_mc6_to_hash(card, in_dev);
-		in6_dev_put(in_dev);
+		qeth_l3_add_mcast_rcu(netdev, card);
 	}
 }
 
-static void qeth_l3_add_multicast_ipv6(struct qeth_card *card)
-{
-	struct inet6_dev *in6_dev;
-
-	QETH_CARD_TEXT(card, 4, "chkmcv6");
-
-	if (!qeth_is_supported(card, IPA_IPV6))
-		return ;
-	in6_dev = in6_dev_get(card->dev);
-	if (!in6_dev)
-		return;
-
-	rcu_read_lock();
-	qeth_l3_add_mc6_to_hash(card, in6_dev);
-	qeth_l3_add_vlan_mc6(card);
-	rcu_read_unlock();
-	in6_dev_put(in6_dev);
-}
-
 static int qeth_l3_vlan_rx_add_vid(struct net_device *dev,
 				   __be16 proto, u16 vid)
 {
@@ -1450,8 +1387,11 @@ static void qeth_l3_rx_mode_work(struct work_struct *work)
 	QETH_CARD_TEXT(card, 3, "setmulti");
 
 	if (!card->options.sniffer) {
-		qeth_l3_add_multicast_ipv4(card);
-		qeth_l3_add_multicast_ipv6(card);
+		rcu_read_lock();
+		qeth_l3_add_mcast_rcu(card->dev, card);
+		if (qeth_is_supported(card, IPA_FULL_VLAN))
+			qeth_l3_add_vlan_mc(card);
+		rcu_read_unlock();
 
 		hash_for_each_safe(card->ip_mc_htable, i, tmp, addr, hnode) {
 			switch (addr->disp_flag) {
-- 
2.17.1

