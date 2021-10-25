Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5088943931F
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 11:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhJYJ7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 05:59:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54694 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232672AbhJYJ7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 05:59:33 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P9RaeY001623;
        Mon, 25 Oct 2021 09:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5CSVQLsQkUAoVno4aaD3PS37x0ervtBr50sEuSbjHjU=;
 b=oTK3kVzDv7huWJd3bmdogl8bjlUwDavVxZAdCrLPs1/VuLrlTIsLPQ+mEQJ+iskss0Sw
 0GI1O2JOQLmWv4O95Ta5sMeh5g0fN3HLUboEc0xLxZWZTcyvQI2xXAiSG6uTRjh9j0nN
 iArk3KHN6SuNzBF0bXPiMUvOJyWajlxR8DHnIiIDLrGB3IOBa4W71KQhlIh+WDK9Hrd4
 pWN+LFmwTbA845Zq/VxzjPEewSiTLcNFwBH3FWctdk4D9gl9CapdSWIe26CKrHDzUr1+
 xGuwO0Oy877a+sb7oNMJtY/rvgcrjs9KByYYL071qCf4ABgUM/RXONOxgOUQ6n4O1iML lA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bwsycgmkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:10 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P9hbFe014559;
        Mon, 25 Oct 2021 09:57:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3bv9njjvpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P9v54N53412180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 09:57:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF1EF11C054;
        Mon, 25 Oct 2021 09:57:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D17B11C058;
        Mon, 25 Oct 2021 09:57:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 09:57:04 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/9] s390/qeth: remove .do_ioctl() callback from driver discipline
Date:   Mon, 25 Oct 2021 11:56:51 +0200
Message-Id: <20211025095658.3527635-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025095658.3527635-1-jwi@linux.ibm.com>
References: <20211025095658.3527635-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vutQoLNmjgY4hpiFDOXBd3fU-rcs54je
X-Proofpoint-ORIG-GUID: vutQoLNmjgY4hpiFDOXBd3fU-rcs54je
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_03,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit 18787eeebd71 ("qeth: use ndo_siocdevprivate") this callback
is now actually used to handle transport mode-specific _private_ ioctls.

We only have such ioctls for L3 devices. So wire up a L3-specific
.ndo_siocdevprivate() callback that handles those ioctls, and defers to
the core qeth_siocdevprivate() for all other private ioctls.

This takes the discipline one step closer to its original purpose of
providing an internal extension for the qeth_core_ccwgroup_driver.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  2 --
 drivers/s390/net/qeth_core_main.c |  5 +----
 drivers/s390/net/qeth_l2_main.c   |  1 -
 drivers/s390/net/qeth_l3_main.c   | 10 +++++-----
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index a5aa0bdc61d6..0dc62b288480 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -771,8 +771,6 @@ struct qeth_discipline {
 	void (*remove) (struct ccwgroup_device *);
 	int (*set_online)(struct qeth_card *card, bool carrier_ok);
 	void (*set_offline)(struct qeth_card *card);
-	int (*do_ioctl)(struct net_device *dev, struct ifreq *rq,
-			void __user *data, int cmd);
 	int (*control_event_handler)(struct qeth_card *card,
 					struct qeth_ipa_cmd *cmd);
 };
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 15999a816054..4149ea253fa0 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6600,10 +6600,7 @@ int qeth_siocdevprivate(struct net_device *dev, struct ifreq *rq, void __user *d
 		rc = qeth_query_oat_command(card, data);
 		break;
 	default:
-		if (card->discipline->do_ioctl)
-			rc = card->discipline->do_ioctl(dev, rq, data, cmd);
-		else
-			rc = -EOPNOTSUPP;
+		rc = -EOPNOTSUPP;
 	}
 	if (rc)
 		QETH_CARD_TEXT_(card, 2, "ioce%x", rc);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 07104fe63df4..adba52da9cab 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2430,7 +2430,6 @@ const struct qeth_discipline qeth_l2_discipline = {
 	.remove = qeth_l2_remove_device,
 	.set_online = qeth_l2_set_online,
 	.set_offline = qeth_l2_set_offline,
-	.do_ioctl = NULL,
 	.control_event_handler = qeth_l2_control_event,
 };
 EXPORT_SYMBOL_GPL(qeth_l2_discipline);
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index e6e921310211..b68942e86666 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1511,7 +1511,8 @@ static int qeth_l3_arp_flush_cache(struct qeth_card *card)
 	return rc;
 }
 
-static int qeth_l3_do_ioctl(struct net_device *dev, struct ifreq *rq, void __user *data, int cmd)
+static int qeth_l3_ndo_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+				      void __user *data, int cmd)
 {
 	struct qeth_card *card = dev->ml_priv;
 	struct qeth_arp_cache_entry arp_entry;
@@ -1552,7 +1553,7 @@ static int qeth_l3_do_ioctl(struct net_device *dev, struct ifreq *rq, void __use
 		rc = qeth_l3_arp_flush_cache(card);
 		break;
 	default:
-		rc = -EOPNOTSUPP;
+		rc = qeth_siocdevprivate(dev, rq, data, cmd);
 	}
 	return rc;
 }
@@ -1841,7 +1842,7 @@ static const struct net_device_ops qeth_l3_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= qeth_l3_set_rx_mode,
 	.ndo_eth_ioctl		= qeth_do_ioctl,
-	.ndo_siocdevprivate	= qeth_siocdevprivate,
+	.ndo_siocdevprivate	= qeth_l3_ndo_siocdevprivate,
 	.ndo_fix_features	= qeth_fix_features,
 	.ndo_set_features	= qeth_set_features,
 	.ndo_tx_timeout		= qeth_tx_timeout,
@@ -1857,7 +1858,7 @@ static const struct net_device_ops qeth_l3_osa_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= qeth_l3_set_rx_mode,
 	.ndo_eth_ioctl		= qeth_do_ioctl,
-	.ndo_siocdevprivate	= qeth_siocdevprivate,
+	.ndo_siocdevprivate	= qeth_l3_ndo_siocdevprivate,
 	.ndo_fix_features	= qeth_fix_features,
 	.ndo_set_features	= qeth_set_features,
 	.ndo_tx_timeout		= qeth_tx_timeout,
@@ -2071,7 +2072,6 @@ const struct qeth_discipline qeth_l3_discipline = {
 	.remove = qeth_l3_remove_device,
 	.set_online = qeth_l3_set_online,
 	.set_offline = qeth_l3_set_offline,
-	.do_ioctl = qeth_l3_do_ioctl,
 	.control_event_handler = qeth_l3_control_event,
 };
 EXPORT_SYMBOL_GPL(qeth_l3_discipline);
-- 
2.25.1

