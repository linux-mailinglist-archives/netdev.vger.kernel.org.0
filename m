Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2FFE1D08
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 15:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405979AbfJWNo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 09:44:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405933AbfJWNoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 09:44:25 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9NDiAGb002024
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 09:44:21 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vtqvygb5h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 09:44:20 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Wed, 23 Oct 2019 14:44:17 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 23 Oct 2019 14:44:16 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9NDiEhK51576950
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 13:44:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95FA1AE045;
        Wed, 23 Oct 2019 13:44:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5455BAE053;
        Wed, 23 Oct 2019 13:44:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Oct 2019 13:44:14 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 1/2] net/smc: fix closing of fallback SMC sockets
Date:   Wed, 23 Oct 2019 15:44:05 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191023134406.66319-1-kgraul@linux.ibm.com>
References: <20191023134406.66319-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19102313-4275-0000-0000-000003762F30
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102313-4276-0000-0000-00003889569F
Message-Id: <20191023134406.66319-2-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-23_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910230140
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

For SMC sockets forced to fallback to TCP, the file is propagated
from the outer SMC to the internal TCP socket. When closing the SMC
socket, the internal TCP socket file pointer must be restored to the
original NULL value, otherwise memory leaks may show up (found with
CONFIG_DEBUG_KMEMLEAK).

The internal TCP socket is released in smc_clcsock_release(), which
calls __sock_release() function in net/socket.c. This calls the
needed iput(SOCK_INODE(sock)) only, if the file pointer has been reset
to the original NULL-value.

Fixes: 07603b230895 ("net/smc: propagate file from SMC to TCP socket")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 5b932583e407..d9566e84f2f9 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -123,6 +123,12 @@ struct proto smc_proto6 = {
 };
 EXPORT_SYMBOL_GPL(smc_proto6);
 
+static void smc_restore_fallback_changes(struct smc_sock *smc)
+{
+	smc->clcsock->file->private_data = smc->sk.sk_socket;
+	smc->clcsock->file = NULL;
+}
+
 static int __smc_release(struct smc_sock *smc)
 {
 	struct sock *sk = &smc->sk;
@@ -141,6 +147,7 @@ static int __smc_release(struct smc_sock *smc)
 		}
 		sk->sk_state = SMC_CLOSED;
 		sk->sk_state_change(sk);
+		smc_restore_fallback_changes(smc);
 	}
 
 	sk->sk_prot->unhash(sk);
-- 
2.17.1

