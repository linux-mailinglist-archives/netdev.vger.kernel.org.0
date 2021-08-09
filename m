Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BE43E4164
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 10:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbhHIIKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 04:10:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29118 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233588AbhHIIKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 04:10:45 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17984Mu5192191;
        Mon, 9 Aug 2021 04:10:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=z/1V6zpO3b2HNkotnhSRQQdekA6mDtijQKwjLTOyvno=;
 b=ECi1gHP/94PVzLQcRRM5I9rr09kuXRckHnWM/YiSfimrte/+D6VpsJTFxbxA3Q6delps
 uIpsMEz2v0kWsADVJbHnGJnNzLnnpaE7Wro+6TTQi8BWvX6S/IHVH17hZOf7Qdf0dtJc
 gmDyPrbaHaZ/msWIt+vJJMsxXCarXCYkzgOn9eaHi2AmQBisJPZfXxcQwzHcuZPgYKyW
 BEfpsHzZuby+frc/f3Lv7I5layWmUYxVffDAgbCJzq4LJoA/al5iU+QD3/itJ8JjfCkR
 LZLGWbuMh2p7sBfUAARqSJPL47l7DuNY3BbAmftpguMAmQc4v6I7/uQ4hRa7nWfBjDzJ og== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aaa1qp3vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:10:21 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17982Gtn029942;
        Mon, 9 Aug 2021 08:10:20 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3a9ht8k84v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 08:10:20 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1798AFBw57737684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 08:10:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDE2AA4065;
        Mon,  9 Aug 2021 08:10:15 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3738DA4054;
        Mon,  9 Aug 2021 08:10:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 08:10:15 +0000 (GMT)
From:   Guvenc Gulce <guvenc@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: [PATCH net-next] net/smc: Allow SMC-D 1MB DMB allocations
Date:   Mon,  9 Aug 2021 10:10:14 +0200
Message-Id: <20210809081014.2300149-1-guvenc@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Tn_C2SNlL4p4mz5L2GsUJ6-U6zk8kRoU
X-Proofpoint-ORIG-GUID: Tn_C2SNlL4p4mz5L2GsUJ6-U6zk8kRoU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_01:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1011 spamscore=0 priorityscore=1501
 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

Commit a3fe3d01bd0d7 ("net/smc: introduce sg-logic for RMBs") introduced
a restriction for RMB allocations as used by SMC-R. However, SMC-D does
not use scatter-gather lists to back its DMBs, yet it was limited by
this restriction, still.
This patch exempts SMC, but limits allocations to the maximum RMB/DMB
size respectively.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
---
 net/smc/smc_core.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index cd0d7c908b2a..edc8962364f3 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1752,21 +1752,30 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 	return rc;
 }
 
-/* convert the RMB size into the compressed notation - minimum 16K.
+#define SMCD_DMBE_SIZES		6 /* 0 -> 16KB, 1 -> 32KB, .. 6 -> 1MB */
+#define SMCR_RMBE_SIZES		5 /* 0 -> 16KB, 1 -> 32KB, .. 5 -> 512KB */
+
+/* convert the RMB size into the compressed notation (minimum 16K, see
+ * SMCD/R_DMBE_SIZES.
  * In contrast to plain ilog2, this rounds towards the next power of 2,
  * so the socket application gets at least its desired sndbuf / rcvbuf size.
  */
-static u8 smc_compress_bufsize(int size)
+static u8 smc_compress_bufsize(int size, bool is_smcd, bool is_rmb)
 {
+	const unsigned int max_scat = SG_MAX_SINGLE_ALLOC * PAGE_SIZE;
 	u8 compressed;
 
 	if (size <= SMC_BUF_MIN_SIZE)
 		return 0;
 
-	size = (size - 1) >> 14;
-	compressed = ilog2(size) + 1;
-	if (compressed >= SMC_RMBE_SIZES)
-		compressed = SMC_RMBE_SIZES - 1;
+	size = (size - 1) >> 14;  /* convert to 16K multiple */
+	compressed = min_t(u8, ilog2(size) + 1,
+			   is_smcd ? SMCD_DMBE_SIZES : SMCR_RMBE_SIZES);
+
+	if (!is_smcd && is_rmb)
+		/* RMBs are backed by & limited to max size of scatterlists */
+		compressed = min_t(u8, compressed, ilog2(max_scat >> 14));
+
 	return compressed;
 }
 
@@ -1982,17 +1991,12 @@ static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 	return rc;
 }
 
-#define SMCD_DMBE_SIZES		6 /* 0 -> 16KB, 1 -> 32KB, .. 6 -> 1MB */
-
 static struct smc_buf_desc *smcd_new_buf_create(struct smc_link_group *lgr,
 						bool is_dmb, int bufsize)
 {
 	struct smc_buf_desc *buf_desc;
 	int rc;
 
-	if (smc_compress_bufsize(bufsize) > SMCD_DMBE_SIZES)
-		return ERR_PTR(-EAGAIN);
-
 	/* try to alloc a new DMB */
 	buf_desc = kzalloc(sizeof(*buf_desc), GFP_KERNEL);
 	if (!buf_desc)
@@ -2041,9 +2045,8 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 		/* use socket send buffer size (w/o overhead) as start value */
 		sk_buf_size = smc->sk.sk_sndbuf / 2;
 
-	for (bufsize_short = smc_compress_bufsize(sk_buf_size);
+	for (bufsize_short = smc_compress_bufsize(sk_buf_size, is_smcd, is_rmb);
 	     bufsize_short >= 0; bufsize_short--) {
-
 		if (is_rmb) {
 			lock = &lgr->rmbs_lock;
 			buf_list = &lgr->rmbs[bufsize_short];
@@ -2052,8 +2055,6 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 			buf_list = &lgr->sndbufs[bufsize_short];
 		}
 		bufsize = smc_uncompress_bufsize(bufsize_short);
-		if ((1 << get_order(bufsize)) > SG_MAX_SINGLE_ALLOC)
-			continue;
 
 		/* check for reusable slot in the link group */
 		buf_desc = smc_buf_get_slot(bufsize_short, lock, buf_list);
-- 
2.25.1

