Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 294F715D349
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 08:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgBNH7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 02:59:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21764 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728422AbgBNH7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 02:59:14 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01E7rZC4071474
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 02:59:13 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4j87e6pu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 02:59:13 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Fri, 14 Feb 2020 07:59:10 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 14 Feb 2020 07:59:09 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01E7x70l54591678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 07:59:07 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B43611C054;
        Fri, 14 Feb 2020 07:59:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5853A11C04C;
        Fri, 14 Feb 2020 07:59:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 07:59:07 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 1/2] net/smc: transfer fasync_list in case of fallback
Date:   Fri, 14 Feb 2020 08:58:59 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200214075900.31624-1-kgraul@linux.ibm.com>
References: <20200214075900.31624-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20021407-0012-0000-0000-00000386B81B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021407-0013-0000-0000-000021C33E0F
Message-Id: <20200214075900.31624-2-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_02:2020-02-12,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140064
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

SMC does not work together with FASTOPEN. If sendmsg() is called with
flag MSG_FASTOPEN in SMC_INIT state, the SMC-socket switches to
fallback mode. To handle the previous ioctl FIOASYNC call correctly
in this case, it is necessary to transfer the socket wait queue
fasync_list to the internal TCP socket.

Reported-by: syzbot+4b1fe8105f8044a26162@syzkaller.appspotmail.com
Fixes: ee9dfbef02d18 ("net/smc: handle sockopts forcing fallback")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index cee5bf4a9bb9..90988a511cd5 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -470,6 +470,8 @@ static void smc_switch_to_fallback(struct smc_sock *smc)
 	if (smc->sk.sk_socket && smc->sk.sk_socket->file) {
 		smc->clcsock->file = smc->sk.sk_socket->file;
 		smc->clcsock->file->private_data = smc->clcsock;
+		smc->clcsock->wq.fasync_list =
+			smc->sk.sk_socket->wq.fasync_list;
 	}
 }
 
-- 
2.17.1

