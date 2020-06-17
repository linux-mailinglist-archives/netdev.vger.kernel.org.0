Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECBB1FD018
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 16:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgFQOzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 10:55:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44002 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726355AbgFQOzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 10:55:04 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05HEcT6f041280;
        Wed, 17 Jun 2020 10:55:01 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31q6hbstt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 10:55:01 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05HEkIQv006964;
        Wed, 17 Jun 2020 14:54:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 31q6bs982g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 14:54:59 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05HEsuIQ34013410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jun 2020 14:54:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9143E42049;
        Wed, 17 Jun 2020 14:54:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30AF74203F;
        Wed, 17 Jun 2020 14:54:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jun 2020 14:54:56 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 2/2] s390/qeth: let isolation mode override HW offload restrictions
Date:   Wed, 17 Jun 2020 16:54:53 +0200
Message-Id: <20200617145453.61382-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200617145453.61382-1-jwi@linux.ibm.com>
References: <20200617145453.61382-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-17_04:2020-06-17,2020-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 cotscore=-2147483648
 clxscore=1015 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006170109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a device is configured with ISOLATION_MODE_FWD, traffic never goes
through the internal switch. Don't apply the offload restrictions in
this case.

Fixes: c619e9a6f52f ("s390/qeth: don't use restricted offloads for local traffic")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 9636415f810b..88e998de2d03 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6837,9 +6837,11 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 				      struct net_device *dev,
 				      netdev_features_t features)
 {
+	struct qeth_card *card = dev->ml_priv;
+
 	/* Traffic with local next-hop is not eligible for some offloads: */
-	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		struct qeth_card *card = dev->ml_priv;
+	if (skb->ip_summed == CHECKSUM_PARTIAL &&
+	    card->options.isolation != ISOLATION_MODE_FWD) {
 		netdev_features_t restricted = 0;
 
 		if (skb_is_gso(skb) && !netif_needs_gso(skb, features))
-- 
2.17.1

