Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8304C2A968B
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 13:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgKFM6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 07:58:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58422 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726939AbgKFM6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 07:58:00 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6CXuB4006737;
        Fri, 6 Nov 2020 07:57:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=jNFHbA7zBsVCMYkJTfI+Rf1P+mExsu1+GQrjv6uVQaU=;
 b=D42/IZUOWu1mCqAgF75x8SE3NbLnzVubUvnH5/Yg4QQq5hF4zh1zcrqogoD0P0pXwdNU
 j9hY3Nx+lJJ+X9JZqAdlJ4Nf9Nrgv/JqjFZyB+En2mTSUhAXXaEX5Hsi15CiRPJ8PisC
 pGRzKE/wrJDIX4eKTU3II2La1bcTULGNsClTIAu0nXp6hh2w6YdXKWfnWj50foJ57uZw
 4oVDEMTSkODOKy1wPBf9wqJtqYb/iIzHKU066Uk9wH3NMOFQWBluKz0BmqiSzBkPPSBo
 AE0jrk1KNldYQyK/U+bvBfc96wU4KPXoTLyiVDjJH62igDC4TVy2Rjm3O94Q9h40PXRt uA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ms00f7ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 07:57:57 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A6CVvfa018498;
        Fri, 6 Nov 2020 12:50:13 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 34hm6hdrnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 12:50:13 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A6CoBd08782348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Nov 2020 12:50:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C199A4054;
        Fri,  6 Nov 2020 12:50:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7215A405F;
        Fri,  6 Nov 2020 12:50:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Nov 2020 12:50:10 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>
Subject: [PATCH net 1/2] net/af_iucv: fix null pointer dereference on shutdown
Date:   Fri,  6 Nov 2020 13:50:07 +0100
Message-Id: <20201106125008.36478-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106125008.36478-1-jwi@linux.ibm.com>
References: <20201106125008.36478-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_04:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060088
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

Fixes: eac3731bd04c ("s390: Add AF_IUCV socket support")
Fixes: 82492a355fac ("af_iucv: add shutdown for HS transport")
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
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

