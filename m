Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE2B7EE9F
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404012AbfHBIRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:17:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404004AbfHBIRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 04:17:01 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x728GZ0p015704
        for <netdev@vger.kernel.org>; Fri, 2 Aug 2019 04:17:00 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2u4gfmaqu5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 04:16:59 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Fri, 2 Aug 2019 09:16:57 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 2 Aug 2019 09:16:54 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x728GaQj38207954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Aug 2019 08:16:36 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E575552051;
        Fri,  2 Aug 2019 08:16:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B1C6C52063;
        Fri,  2 Aug 2019 08:16:52 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net] net/smc: do not schedule tx_work in SMC_CLOSED state
Date:   Fri,  2 Aug 2019 10:16:38 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19080208-0008-0000-0000-00000303A53F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19080208-0009-0000-0000-00002272AB24
Message-Id: <20190802081638.56207-1-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-02_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908020083
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

The setsockopts options TCP_NODELAY and TCP_CORK may schedule the
tx worker. Make sure the socket is not yet moved into SMC_CLOSED
state (for instance by a shutdown SHUT_RDWR call).

Reported-by: syzbot+92209502e7aab127c75f@syzkaller.appspotmail.com
Reported-by: syzbot+b972214bb803a343f4fe@syzkaller.appspotmail.com
Fixes: 01d2f7e2cdd31 ("net/smc: sockopts TCP_NODELAY and TCP_CORK")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 302e355f2ebc..f5ea09258ab0 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1732,14 +1732,18 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		}
 		break;
 	case TCP_NODELAY:
-		if (sk->sk_state != SMC_INIT && sk->sk_state != SMC_LISTEN) {
+		if (sk->sk_state != SMC_INIT &&
+		    sk->sk_state != SMC_LISTEN &&
+		    sk->sk_state != SMC_CLOSED) {
 			if (val && !smc->use_fallback)
 				mod_delayed_work(system_wq, &smc->conn.tx_work,
 						 0);
 		}
 		break;
 	case TCP_CORK:
-		if (sk->sk_state != SMC_INIT && sk->sk_state != SMC_LISTEN) {
+		if (sk->sk_state != SMC_INIT &&
+		    sk->sk_state != SMC_LISTEN &&
+		    sk->sk_state != SMC_CLOSED) {
 			if (!val && !smc->use_fallback)
 				mod_delayed_work(system_wq, &smc->conn.tx_work,
 						 0);
-- 
2.21.0

