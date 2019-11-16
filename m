Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE6EFF407
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfKPQrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:47:47 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13818 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727647AbfKPQrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 11:47:46 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAGGl4uq011865
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 11:47:44 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2waawxnuwx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 11:47:44 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Sat, 16 Nov 2019 16:47:43 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 16 Nov 2019 16:47:41 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAGGleRk58917046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Nov 2019 16:47:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6238EA4040;
        Sat, 16 Nov 2019 16:47:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23C50A4055;
        Sat, 16 Nov 2019 16:47:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 16 Nov 2019 16:47:40 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 3/4] net/smc: use rcu_barrier() on module unload
Date:   Sat, 16 Nov 2019 17:47:31 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191116164732.47059-1-kgraul@linux.ibm.com>
References: <20191116164732.47059-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111616-4275-0000-0000-0000037EEB08
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111616-4276-0000-0000-00003892570E
Message-Id: <20191116164732.47059-4-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-16_05:2019-11-15,2019-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=698 adultscore=0
 spamscore=0 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 priorityscore=1501 suspectscore=1
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911160156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

Add rcu_barrier() to make sure no RCU readers or callbacks are
pending when the module is unloaded.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 42b7fb8ab22b..cde4dc0ed173 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -25,6 +25,7 @@
 #include <linux/in.h>
 #include <linux/sched/signal.h>
 #include <linux/if_vlan.h>
+#include <linux/rcupdate_wait.h>
 
 #include <net/sock.h>
 #include <net/tcp.h>
@@ -2111,6 +2112,7 @@ static void __exit smc_exit(void)
 	proto_unregister(&smc_proto);
 	smc_pnet_exit();
 	unregister_pernet_subsys(&smc_net_ops);
+	rcu_barrier();
 }
 
 module_init(smc_init);
-- 
2.17.1

