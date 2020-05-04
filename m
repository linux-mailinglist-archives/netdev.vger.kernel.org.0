Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06011C430F
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgEDRjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:39:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63650 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729962AbgEDRjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:39:54 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 044HY6oU003760;
        Mon, 4 May 2020 13:39:52 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s1svyx87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 13:39:50 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 044HUJ6m021811;
        Mon, 4 May 2020 17:39:49 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 30s0g5j4dn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 17:39:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 044Hdk9D58654784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 May 2020 17:39:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12316AE045;
        Mon,  4 May 2020 17:39:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC738AE04D;
        Mon,  4 May 2020 17:39:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 May 2020 17:39:45 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net] s390/qeth: fix cancelling of TX timer on dev_close()
Date:   Mon,  4 May 2020 19:39:42 +0200
Message-Id: <20200504173942.69298-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_11:2020-05-04,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0
 impostorscore=0 mlxlogscore=919 bulkscore=0 clxscore=1015 suspectscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of TX coalescing, .ndo_start_xmit now potentially
starts the TX completion timer. So only kill the timer _after_ TX has
been disabled.

Fixes: ee1e52d1e4bb ("s390/qeth: add TX IRQ coalescing support for IQD devices")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index f7689461c242..569966bdc513 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6717,17 +6717,17 @@ int qeth_stop(struct net_device *dev)
 		unsigned int i;
 
 		/* Quiesce the NAPI instances: */
-		qeth_for_each_output_queue(card, queue, i) {
+		qeth_for_each_output_queue(card, queue, i)
 			napi_disable(&queue->napi);
-			del_timer_sync(&queue->timer);
-		}
 
 		/* Stop .ndo_start_xmit, might still access queue->napi. */
 		netif_tx_disable(dev);
 
-		/* Queues may get re-allocated, so remove the NAPIs here. */
-		qeth_for_each_output_queue(card, queue, i)
+		qeth_for_each_output_queue(card, queue, i) {
+			del_timer_sync(&queue->timer);
+			/* Queues may get re-allocated, so remove the NAPIs. */
 			netif_napi_del(&queue->napi);
+		}
 	} else {
 		netif_tx_disable(dev);
 	}
-- 
2.17.1

