Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858FE2AB1F9
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 08:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729715AbgKIH5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 02:57:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4364 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728038AbgKIH5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 02:57:22 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A97nnqe081962;
        Mon, 9 Nov 2020 02:57:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=fAALyoBfLe7BrbTCbWXOF0Qc5ZWIgzrnr0c3e2y0vhA=;
 b=lSPWJqRr8IclQolLx7NOkmurAANnE0k4SWClTdwGohrtmXd2kR1L4WpyP+Tx3a++S2Rg
 fRGp9JYcoY7+c4P7oWZtEEkMxUB9IdxbnhZ+I3mMBHWLpre/zzWCJontL4SoWnHYcW28
 ZqKqVl7sv0b91szntlL9d87FjVh0e1hB8Uq1o19q1bylRXUpEEztUTEP6qla4ZGyx9Ew
 40Hv2J1JHC+x2nRPQyFrHd1Bh97OHtzOLY30QrsYal7NdqHhRh0MHynATdLuZamntswn
 fHkZocZABq0J3cHNlMm/QcwuUFLKBaazfHLh/3X1QkYydNq95lg6C8szpxFmlISOrbqL RQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34pa0x8sta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 02:57:18 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A97q7YQ030971;
        Mon, 9 Nov 2020 07:57:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 34nk78ht2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 07:57:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A97vEbd9568858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Nov 2020 07:57:14 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5F23A405E;
        Mon,  9 Nov 2020 07:57:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7BFEA4059;
        Mon,  9 Nov 2020 07:57:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Nov 2020 07:57:13 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>
Subject: [PATCH net v2 1/2] net/af_iucv: fix null pointer dereference on shutdown
Date:   Mon,  9 Nov 2020 08:57:05 +0100
Message-Id: <20201109075706.56573-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201109075706.56573-1-jwi@linux.ibm.com>
References: <20201109075706.56573-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_02:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090046
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

syzbot reported the following KASAN finding:

BUG: KASAN: nullptr-dereference in iucv_send_ctrl+0x390/0x3f0 net/iucv/af_iucv.c:385
Read of size 2 at addr 000000000000021e by task syz-executor907/519

CPU: 0 PID: 519 Comm: syz-executor907 Not tainted 5.9.0-syzkaller-07043-gbcf9877ad213 #0
Hardware name: IBM 3906 M04 701 (KVM/Linux)
Call Trace:
 [<00000000c576af60>] unwind_start arch/s390/include/asm/unwind.h:65 [inline]
 [<00000000c576af60>] show_stack+0x180/0x228 arch/s390/kernel/dumpstack.c:135
 [<00000000c9dcd1f8>] __dump_stack lib/dump_stack.c:77 [inline]
 [<00000000c9dcd1f8>] dump_stack+0x268/0x2f0 lib/dump_stack.c:118
 [<00000000c5fed016>] print_address_description.constprop.0+0x5e/0x218 mm/kasan/report.c:383
 [<00000000c5fec82a>] __kasan_report mm/kasan/report.c:517 [inline]
 [<00000000c5fec82a>] kasan_report+0x11a/0x168 mm/kasan/report.c:534
 [<00000000c98b5b60>] iucv_send_ctrl+0x390/0x3f0 net/iucv/af_iucv.c:385
 [<00000000c98b6262>] iucv_sock_shutdown+0x44a/0x4c0 net/iucv/af_iucv.c:1457
 [<00000000c89d3a54>] __sys_shutdown+0x12c/0x1c8 net/socket.c:2204
 [<00000000c89d3b70>] __do_sys_shutdown net/socket.c:2212 [inline]
 [<00000000c89d3b70>] __s390x_sys_shutdown+0x38/0x48 net/socket.c:2210
 [<00000000c9e36eac>] system_call+0xe0/0x28c arch/s390/kernel/entry.S:415

There is nothing to shutdown if a connection has never been established.
Besides that iucv->hs_dev is not yet initialized if a socket is in
IUCV_OPEN state and iucv->path is not yet initialized if socket is in
IUCV_BOUND state.
So, just skip the shutdown calls for a socket in these states.

Fixes: eac3731bd04c ("[S390]: Add AF_IUCV socket support")
Fixes: 82492a355fac ("af_iucv: add shutdown for HS transport")
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
[jwi: correct one Fixes tag]
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 net/iucv/af_iucv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index d80572074667..047238f01ba6 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1434,7 +1434,8 @@ static int iucv_sock_shutdown(struct socket *sock, int how)
 		break;
 	}
 
-	if (how == SEND_SHUTDOWN || how == SHUTDOWN_MASK) {
+	if ((how == SEND_SHUTDOWN || how == SHUTDOWN_MASK) &&
+	    sk->sk_state == IUCV_CONNECTED) {
 		if (iucv->transport == AF_IUCV_TRANS_IUCV) {
 			txmsg.class = 0;
 			txmsg.tag = 0;
-- 
2.17.1

