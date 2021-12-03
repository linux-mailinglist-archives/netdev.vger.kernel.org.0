Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DB746768F
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 12:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380554AbhLCLhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 06:37:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27610 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380587AbhLCLh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 06:37:27 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3BGTZo014986;
        Fri, 3 Dec 2021 11:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=QBha6az350dekEPmQVkx9Lj0VCIDI+RfePfNLlNCqTw=;
 b=H/T2qWV35uqlZdzAwlSqJtaZtMhggOIQIKNCNt4gzy/qCf+mSTvwJPYsV5VGt+fDmbG7
 OrNF0utLM4g5XAOK4r/0vPq0cKMjUnEA/N5tazHJq5ZSS+f60cF+GCNb/yJRV2aO80Og
 Dj1Wml1dIDH/gM2yYDatTT5FLSDRJcWpjLO4Rb5bCq8b53mazGVEHOUUVsDg9rZvKZet
 B3m4E6rXGx9EJGoskokgkHO6fQHqIJTjJfFIXMsR7rDcHsPKAwPDillEf/+8/df42nj1
 ykG/kJqYja1Xi+8es+RgCKymvgpTuwT9Zi6Oqn3YqP/DuHb2mTdhp3zQ6aZ8vIdk2dII XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqj7hr965-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 11:34:01 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B3BH2RU016253;
        Fri, 3 Dec 2021 11:34:01 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqj7hr95k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 11:34:01 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B3BX9cu005616;
        Fri, 3 Dec 2021 11:33:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ckcadd7xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 11:33:58 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B3BXuS231195520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Dec 2021 11:33:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15BCB52057;
        Fri,  3 Dec 2021 11:33:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C96AA5204F;
        Fri,  3 Dec 2021 11:33:55 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>
Subject: [PATCH net-next] net/smc: Clear memory when release and reuse buffer
Date:   Fri,  3 Dec 2021 12:33:31 +0100
Message-Id: <20211203113331.2818873-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TYTHsu3dV7_woQ2F9Pf7dse3KjZXQFXv
X-Proofpoint-ORIG-GUID: _McMgQmGEngWnh_GdA1kBoplHRagcUJb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_06,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 impostorscore=0 spamscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030072
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Lu <tonylu@linux.alibaba.com>

Currently, buffers are cleared when smc connections are created and
buffers are reused. This slows down the speed of establishing new
connections. In most cases, the applications want to establish
connections as quickly as possible.

This patch moves memset() from connection creation path to release and
buffer unuse path, this trades off between speed of establishing and
release.

Test environments:
- CPU Intel Xeon Platinum 8 core, mem 32 GiB, nic Mellanox CX4
- socket sndbuf / rcvbuf: 16384 / 131072 bytes
- w/o first round, 5 rounds, avg, 100 conns batch per round
- smc_buf_create() use bpftrace kprobe, introduces extra latency

Latency benchmarks for smc_buf_create():
  w/o patch : 19040.0 ns
  w/  patch :  1932.6 ns
  ratio :        10.2% (-89.8%)

Latency benchmarks for socket create and connect:
  w/o patch :   143.3 us
  w/  patch :   102.2 us
  ratio :        71.3% (-28.7%)

The latency of establishing connections is reduced by 28.7%.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 387d28b2f8dd..85be94cabb01 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1101,18 +1101,24 @@ static void smcr_buf_unuse(struct smc_buf_desc *rmb_desc,
 		smc_buf_free(lgr, true, rmb_desc);
 	} else {
 		rmb_desc->used = 0;
+		memset(rmb_desc->cpu_addr, 0, rmb_desc->len);
 	}
 }
 
 static void smc_buf_unuse(struct smc_connection *conn,
 			  struct smc_link_group *lgr)
 {
-	if (conn->sndbuf_desc)
+	if (conn->sndbuf_desc) {
 		conn->sndbuf_desc->used = 0;
-	if (conn->rmb_desc && lgr->is_smcd)
+		memset(conn->sndbuf_desc->cpu_addr, 0, conn->sndbuf_desc->len);
+	}
+	if (conn->rmb_desc && lgr->is_smcd) {
 		conn->rmb_desc->used = 0;
-	else if (conn->rmb_desc)
+		memset(conn->rmb_desc->cpu_addr, 0, conn->rmb_desc->len +
+		       sizeof(struct smcd_cdc_msg));
+	} else if (conn->rmb_desc) {
 		smcr_buf_unuse(conn->rmb_desc, lgr);
+	}
 }
 
 /* remove a finished connection from its link group */
@@ -2148,7 +2154,6 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 		if (buf_desc) {
 			SMC_STAT_RMB_SIZE(smc, is_smcd, is_rmb, bufsize);
 			SMC_STAT_BUF_REUSE(smc, is_smcd, is_rmb);
-			memset(buf_desc->cpu_addr, 0, bufsize);
 			break; /* found reusable slot */
 		}
 
-- 
2.32.0

