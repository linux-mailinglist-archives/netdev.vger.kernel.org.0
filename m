Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558ED226206
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 16:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgGTO0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 10:26:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35442 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725934AbgGTO0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 10:26:17 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KE1Eux121324;
        Mon, 20 Jul 2020 10:26:14 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32d5h4pvxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 10:26:14 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06KEQ8CP000870;
        Mon, 20 Jul 2020 14:26:12 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 32brq7ttpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 14:26:12 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06KEOtuH31654230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 14:24:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2ED1BAE055;
        Mon, 20 Jul 2020 14:24:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC004AE045;
        Mon, 20 Jul 2020 14:24:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jul 2020 14:24:54 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 1/2] net/smc: put slot when connection is killed
Date:   Mon, 20 Jul 2020 16:24:28 +0200
Message-Id: <20200720142429.17916-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200720142429.17916-1-kgraul@linux.ibm.com>
References: <20200720142429.17916-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3
 mlxlogscore=887 clxscore=1015 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007200095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To get a send slot smc_wr_tx_get_free_slot() is called, which might
wait for a free slot. When smc_wr_tx_get_free_slot() returns there is a
check if the connection was killed in the meantime. In that case don't
only return an error, but also put back the free slot.

Fixes: b290098092e4 ("net/smc: cancel send and receive for terminated socket")
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_cdc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index a47e8855e045..ce468ff62a19 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -66,9 +66,13 @@ int smc_cdc_get_free_slot(struct smc_connection *conn,
 	rc = smc_wr_tx_get_free_slot(link, smc_cdc_tx_handler, wr_buf,
 				     wr_rdma_buf,
 				     (struct smc_wr_tx_pend_priv **)pend);
-	if (conn->killed)
+	if (conn->killed) {
 		/* abnormal termination */
+		if (!rc)
+			smc_wr_tx_put_slot(link,
+					   (struct smc_wr_tx_pend_priv *)pend);
 		rc = -EPIPE;
+	}
 	return rc;
 }
 
-- 
2.17.1

