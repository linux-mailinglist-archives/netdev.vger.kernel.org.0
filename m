Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C10D25C9BB
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgICTxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:53:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19812 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728975AbgICTxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 15:53:38 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 083JWomm060971;
        Thu, 3 Sep 2020 15:53:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=UyOGvVCLMpxFQCPeUC0ryCk2kAnqSgleAPIcpSQ3QJU=;
 b=l8yFZwOVEacXrsKH8qFYgiCr8rBi33+xCTAZ7g63bZ9d9rynTvmOEtSK48GV/amtktuE
 UbWbUEb2wLrYie5saK0n11No1dx3X10PjgbfcW4HrgaNnksFBt6JVAO1kVUPVONlmQnp
 jN1k+72s4CagIpqYS+AEb1gii9Gn/kN5KCkNCCaiVuqzSZ5GJ7VertOt7OGBmF5gnMSS
 KmPGHcwejDdulL/yAmqRXmkVa7tK7wnmFNQUG3X3Y/OoCYKe8rD5Y5l2WUHJypquI3d1
 tADjYTkIGkU+Tm0j3n9BBhVoeh+o1D93tlrz6Zr4nYhG5SW6azVb7CRiU8+vK+Bhv3Wx VQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33b60yhk7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 15:53:37 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 083JqIOh014216;
        Thu, 3 Sep 2020 19:53:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 337en865w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 19:53:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 083JrW8Z20513070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Sep 2020 19:53:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E70A11C04A;
        Thu,  3 Sep 2020 19:53:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BF2C11C058;
        Thu,  3 Sep 2020 19:53:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Sep 2020 19:53:31 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 2/4] net/smc: set rx_off for SMCR explicitly
Date:   Thu,  3 Sep 2020 21:53:16 +0200
Message-Id: <20200903195318.39288-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200903195318.39288-1-kgraul@linux.ibm.com>
References: <20200903195318.39288-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_13:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 spamscore=0 suspectscore=1 mlxlogscore=790 phishscore=0 clxscore=1015
 adultscore=0 malwarescore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030176
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

SMC tries to make use of SMCD first. If a problem shows up,
it tries to switch to SMCR. If the SMCD initializing problem shows
up after the SMCD connection has already been initialized, field
rx_off keeps the wrong SMCD value for SMCR, which results in corrupted
data at the receiver.
This patch adds an explicit (re-)setting of field rx_off to zero if the
connection uses SMCR.

Fixes: be244f28d22f ("net/smc: add SMC-D support in data transfer")
Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index b42fa3b00d00..a6ac0eb20c99 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1356,6 +1356,8 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 	if (ini->is_smcd) {
 		conn->rx_off = sizeof(struct smcd_cdc_msg);
 		smcd_cdc_rx_init(conn); /* init tasklet for this conn */
+	} else {
+		conn->rx_off = 0;
 	}
 #ifndef KERNEL_HAS_ATOMIC64
 	spin_lock_init(&conn->acurs_lock);
-- 
2.17.1

