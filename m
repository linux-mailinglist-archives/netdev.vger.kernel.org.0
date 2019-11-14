Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3567DFC3F1
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfKNKUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:20:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29804 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726996AbfKNKUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:20:06 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEAJnTS107619
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:20:05 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w92bjnu1n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:20:01 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 14 Nov 2019 10:19:35 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 10:19:32 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEAJVvP47448204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 10:19:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5BBCA4055;
        Thu, 14 Nov 2019 10:19:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA363A4051;
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
Subject: [PATCH net-next 09/11] s390/qeth: remove VLAN tracking for L3 devices
Date:   Thu, 14 Nov 2019 11:19:22 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114101924.29558-1-jwi@linux.ibm.com>
References: <20191114101924.29558-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111410-4275-0000-0000-0000037DA61B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111410-4276-0000-0000-000038910B64
Message-Id: <20191114101924.29558-10-jwi@linux.ibm.com>
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

Use vlan_for_each() instead of tracking each registered VID internally.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h    |  1 -
 drivers/s390/net/qeth_l3_main.c | 42 +++++++++------------------------
 2 files changed, 11 insertions(+), 32 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 52fd3c4bb132..f81f1523d528 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -824,7 +824,6 @@ struct qeth_card {
 	struct workqueue_struct *event_wq;
 	struct workqueue_struct *cmd_wq;
 	wait_queue_head_t wait_q;
-	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
 	DECLARE_HASHTABLE(mac_htable, 4);
 	DECLARE_HASHTABLE(ip_htable, 4);
 	struct mutex ip_lock;
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 1e060331a8cc..f4c65971321a 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1113,10 +1113,10 @@ qeth_diags_trace(struct qeth_card *card, enum qeth_diags_trace_cmds diags_cmd)
 	return qeth_send_ipa_cmd(card, iob, qeth_diags_trace_cb, NULL);
 }
 
-static void qeth_l3_add_mcast_rcu(struct net_device *dev,
-				  struct qeth_card *card)
+static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
 {
 	struct qeth_ipaddr *tmp = NULL;
+	struct qeth_card *card = arg;
 	struct inet6_dev *in6_dev;
 	struct in_device *in4_dev;
 	struct qeth_ipaddr *ipm;
@@ -1132,12 +1132,12 @@ static void qeth_l3_add_mcast_rcu(struct net_device *dev,
 	if (!tmp)
 		goto out;
 
-	in4_dev = __in_dev_get_rcu(dev);
+	in4_dev = __in_dev_get_rtnl(dev);
 	if (!in4_dev)
 		goto walk_ipv6;
 
-	for (im4 = rcu_dereference(in4_dev->mc_list); im4 != NULL;
-	     im4 = rcu_dereference(im4->next_rcu)) {
+	for (im4 = rtnl_dereference(in4_dev->mc_list); im4 != NULL;
+	     im4 = rtnl_dereference(im4->next_rcu)) {
 		tmp->u.a4.addr = im4->multiaddr;
 		tmp->is_multicast = 1;
 
@@ -1195,25 +1195,7 @@ static void qeth_l3_add_mcast_rcu(struct net_device *dev,
 
 out:
 	kfree(tmp);
-}
-
-/* called with rcu_read_lock */
-static void qeth_l3_add_vlan_mc(struct qeth_card *card)
-{
-	u16 vid;
-
-	QETH_CARD_TEXT(card, 4, "admc6vl");
-
-	if (!qeth_is_supported(card, IPA_FULL_VLAN))
-		return;
-
-	for_each_set_bit(vid, card->active_vlans, VLAN_N_VID) {
-		struct net_device *netdev;
-
-		netdev = __vlan_find_dev_deep_rcu(card->dev, htons(ETH_P_8021Q),
-					      vid);
-		qeth_l3_add_mcast_rcu(netdev, card);
-	}
+	return 0;
 }
 
 static int qeth_l3_vlan_rx_add_vid(struct net_device *dev,
@@ -1221,7 +1203,7 @@ static int qeth_l3_vlan_rx_add_vid(struct net_device *dev,
 {
 	struct qeth_card *card = dev->ml_priv;
 
-	set_bit(vid, card->active_vlans);
+	QETH_CARD_TEXT_(card, 4, "aid:%d", vid);
 	return 0;
 }
 
@@ -1231,8 +1213,6 @@ static int qeth_l3_vlan_rx_kill_vid(struct net_device *dev,
 	struct qeth_card *card = dev->ml_priv;
 
 	QETH_CARD_TEXT_(card, 4, "kid:%d", vid);
-
-	clear_bit(vid, card->active_vlans);
 	return 0;
 }
 
@@ -1387,11 +1367,11 @@ static void qeth_l3_rx_mode_work(struct work_struct *work)
 	QETH_CARD_TEXT(card, 3, "setmulti");
 
 	if (!card->options.sniffer) {
-		rcu_read_lock();
-		qeth_l3_add_mcast_rcu(card->dev, card);
+		rtnl_lock();
+		qeth_l3_add_mcast_rtnl(card->dev, 0, card);
 		if (qeth_is_supported(card, IPA_FULL_VLAN))
-			qeth_l3_add_vlan_mc(card);
-		rcu_read_unlock();
+			vlan_for_each(card->dev, qeth_l3_add_mcast_rtnl, card);
+		rtnl_unlock();
 
 		hash_for_each_safe(card->ip_mc_htable, i, tmp, addr, hnode) {
 			switch (addr->disp_flag) {
-- 
2.17.1

