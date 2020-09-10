Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371E5264A4F
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgIJQvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:51:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10298 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727026AbgIJQtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:49:21 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AGY4jo182971;
        Thu, 10 Sep 2020 12:49:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=b/zUQa9QNm8vKSK5YJEfsvFL+vteryKLpqPFE0bbruM=;
 b=Cd9AuDzewiRRse2jdtiSGT8a/jKRz8z9r+jXGbYgTBqzJieAHCmOnlQHUgOPfxpQgExE
 2/vwlZ89VwrDBZFaW1B9yDcVVTX5DrWxCFf7nb1+bnxT7Q4qtlCtIfLTGZXjRy/hTMGM
 MJfkTa64tzN2U4z2s/PiIq5nLpBALCmHvs9jOCCPTT2tP5ivRavgrq7oKEsnqklv5G4S
 kbwJX9f+T6RBMFLrM+BpOKnpq5Wf4GLDFAEQUQw8TKprY0sHxnoom98GSRh6PsLMTkgq
 6XvMkeOvkcf9maSq532xASSPQClVyb8tqOl98ZRUaZXYioW4M0jebvlGA2qbKYYQzuyJ pg== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fq1paamd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 12:49:07 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AGlKuN022037;
        Thu, 10 Sep 2020 16:49:04 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 33c2a8bkjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 16:49:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AGn1IT61866258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 16:49:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9939D4C040;
        Thu, 10 Sep 2020 16:49:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6350F4C046;
        Thu, 10 Sep 2020 16:49:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 16:49:01 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 09/10] net/smc: use the retry mechanism for netlink messages
Date:   Thu, 10 Sep 2020 18:48:28 +0200
Message-Id: <20200910164829.65426-10-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910164829.65426-1-kgraul@linux.ibm.com>
References: <20200910164829.65426-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_05:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 suspectscore=1 bulkscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=908 lowpriorityscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

When the netlink messages to be sent to the userspace
are too big for a single netlink message, send them in
chunks using the netlink_dump infrastructure. Modify the
smc diag dump code so that it can signal to the netlink_dump
infrastructure that it needs to send more data.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_diag.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index da9ba6d1679b..f15fca59b4b2 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -22,6 +22,15 @@
 #include "smc.h"
 #include "smc_core.h"
 
+struct smc_diag_dump_ctx {
+	int pos[2];
+};
+
+static struct smc_diag_dump_ctx *smc_dump_context(struct netlink_callback *cb)
+{
+	return (struct smc_diag_dump_ctx *)cb->ctx;
+}
+
 static void smc_gid_be16_convert(__u8 *buf, u8 *gid_raw)
 {
 	sprintf(buf, "%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x",
@@ -193,13 +202,15 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
 }
 
 static int smc_diag_dump_proto(struct proto *prot, struct sk_buff *skb,
-			       struct netlink_callback *cb)
+			       struct netlink_callback *cb, int p_type)
 {
+	struct smc_diag_dump_ctx *cb_ctx = smc_dump_context(cb);
 	struct net *net = sock_net(skb->sk);
+	int snum = cb_ctx->pos[p_type];
 	struct nlattr *bc = NULL;
 	struct hlist_head *head;
+	int rc = 0, num = 0;
 	struct sock *sk;
-	int rc = 0;
 
 	read_lock(&prot->h.smc_hash->lock);
 	head = &prot->h.smc_hash->ht;
@@ -209,13 +220,18 @@ static int smc_diag_dump_proto(struct proto *prot, struct sk_buff *skb,
 	sk_for_each(sk, head) {
 		if (!net_eq(sock_net(sk), net))
 			continue;
+		if (num < snum)
+			goto next;
 		rc = __smc_diag_dump(sk, skb, cb, nlmsg_data(cb->nlh), bc);
-		if (rc)
-			break;
+		if (rc < 0)
+			goto out;
+next:
+		num++;
 	}
 
 out:
 	read_unlock(&prot->h.smc_hash->lock);
+	cb_ctx->pos[p_type] = num;
 	return rc;
 }
 
@@ -223,10 +239,10 @@ static int smc_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	int rc = 0;
 
-	rc = smc_diag_dump_proto(&smc_proto, skb, cb);
+	rc = smc_diag_dump_proto(&smc_proto, skb, cb, SMCPROTO_SMC);
 	if (!rc)
-		rc = smc_diag_dump_proto(&smc_proto6, skb, cb);
-	return rc;
+		smc_diag_dump_proto(&smc_proto6, skb, cb, SMCPROTO_SMC6);
+	return skb->len;
 }
 
 static int smc_diag_handler_dump(struct sk_buff *skb, struct nlmsghdr *h)
-- 
2.17.1

