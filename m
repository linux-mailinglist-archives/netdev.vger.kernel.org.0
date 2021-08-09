Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255743E420B
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhHIJG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:06:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40742 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234150AbhHIJG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:06:27 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17994Nm5022301;
        Mon, 9 Aug 2021 05:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UKcEiWTqbdOmBDR1x3yFZ+64e9nU+Ve9o//VKZalSFs=;
 b=WC5ri0sm/1VvJmnna2nz2fh4t8CLSiN2xX4YwFJu5Y3HA6hTJHPK7saASLz2AG15KgxQ
 R/VgXJbYa06mD2A8CA6vnEnoHuR3WGfHSFyW+TB9Rcn7/bQxh6k3ijVVFW0sfmr1UgJP
 AMSzwMl10TUmIo9h1PUvrzqCdnlHRJI61ke3X7BSgEroCu2iMWg3ndGjx/cxPnJIwELC
 BGuohs/93PikCw5BY35bQJSDAdPdZFyhkBeK0olktRReemq69SlVSdjcrbdhRJIzuNMl
 mnlcpqG3OngI8dm3OFLPWC6YRYGnbr5EmaVTJ0lAQXSYZ6enU7w5HhXPZwOrKs8P9A4v 0A== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aaa1qqe8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 05:06:03 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17994G38022955;
        Mon, 9 Aug 2021 09:06:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3a9ht8up07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 09:06:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17992nRt58065364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 09:02:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9BF54C040;
        Mon,  9 Aug 2021 09:05:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F2B74C046;
        Mon,  9 Aug 2021 09:05:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 09:05:58 +0000 (GMT)
From:   Guvenc Gulce <guvenc@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: [PATCH net 2/2] net/smc: Correct smc link connection counter in case of smc client
Date:   Mon,  9 Aug 2021 11:05:57 +0200
Message-Id: <20210809090557.3121288-3-guvenc@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809090557.3121288-1-guvenc@linux.ibm.com>
References: <20210809090557.3121288-1-guvenc@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Uc6qMgD90ffEpCF9dnHfgdaqyjfJd4zF
X-Proofpoint-ORIG-GUID: Uc6qMgD90ffEpCF9dnHfgdaqyjfJd4zF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_01:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090073
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SMC clients may be assigned to a different link after the initial
connection between two peers was established. In such a case,
the connection counter was not correctly set.

Update the connection counter correctly when a smc client connection
is assigned to a different smc link.

Fixes: 07d51580ff65 ("net/smc: Add connection counters for links")
Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Tested-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   | 2 +-
 net/smc/smc_core.c | 4 ++--
 net/smc/smc_core.h | 2 ++
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 898389611ae8..c038efc23ce3 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -795,7 +795,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
 			reason_code = SMC_CLC_DECL_NOSRVLINK;
 			goto connect_abort;
 		}
-		smc->conn.lnk = link;
+		smc_switch_link_and_count(&smc->conn, link);
 	}
 
 	/* create send buffer and rmb */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index cd0d7c908b2a..c160ff50c053 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -917,8 +917,8 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
 	return rc;
 }
 
-static void smc_switch_link_and_count(struct smc_connection *conn,
-				      struct smc_link *to_lnk)
+void smc_switch_link_and_count(struct smc_connection *conn,
+			       struct smc_link *to_lnk)
 {
 	atomic_dec(&conn->lnk->conn_cnt);
 	conn->lnk = to_lnk;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 64d86298e4df..c043ecdca5c4 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -446,6 +446,8 @@ void smc_core_exit(void);
 int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 		   u8 link_idx, struct smc_init_info *ini);
 void smcr_link_clear(struct smc_link *lnk, bool log);
+void smc_switch_link_and_count(struct smc_connection *conn,
+			       struct smc_link *to_lnk);
 int smcr_buf_map_lgr(struct smc_link *lnk);
 int smcr_buf_reg_lgr(struct smc_link *lnk);
 void smcr_lgr_set_type(struct smc_link_group *lgr, enum smc_lgr_type new_type);
-- 
2.25.1

