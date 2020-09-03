Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DFD25C9C9
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgICTyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:54:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8682 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729167AbgICTxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 15:53:40 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 083JWwfx037639;
        Thu, 3 Sep 2020 15:53:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=T8LNU3c33w8RNMcl+XwbR2Wu9RquYmmk+hX+1ufpwp8=;
 b=tMJ6N9E8Lams5DKTvwAEwauCz20WRUoQ5Fs2usxqSefMCyQUD1FNSag50nljndPodfP3
 YuqXwcTJY10/AkVi3JpP8h+FF2H0BfJATCf7bbfyNJGMG9v77eQVUE0uuOVnZYhh2l8V
 Ui0/BqMrZv9ZqED85MNO0VyOE5oUuvIGsKSsqvd+15UxMnwDCdjyVKqfN6t2wPr3/J4/
 nwTO2MmPYrlga6uOiKlkkuYr7wkwy8uKuCtjd4sczQW/CdSLGALdSIYY1hbTywwoTc7c
 k2XTM1zzTHTz0l741DmeBxXOKxAsfWGL9ffHDuwcAERBxqPO3RADZjJOcDuXalqRUurY aQ== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33b4bkmq9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 15:53:37 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 083JqksQ001318;
        Thu, 3 Sep 2020 19:53:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 337en7ksj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 19:53:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 083JrWvx28705204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Sep 2020 19:53:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D537811C04A;
        Thu,  3 Sep 2020 19:53:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D47B11C052;
        Thu,  3 Sep 2020 19:53:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Sep 2020 19:53:32 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 4/4] net/smc: fix sock refcounting in case of termination
Date:   Thu,  3 Sep 2020 21:53:18 +0200
Message-Id: <20200903195318.39288-5-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200903195318.39288-1-kgraul@linux.ibm.com>
References: <20200903195318.39288-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_13:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=3
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030176
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

When an ISM device is removed, all its linkgroups are terminated,
i.e. all the corresponding connections are killed.
Connection killing invokes smc_close_active_abort(), which decreases
the sock refcount for certain states to simulate passive closing.
And it cancels the close worker and has to give up the sock lock for
this timeframe. This opens the door for a passive close worker or a
socket close to run in between. In this case smc_close_active_abort() and
passive close worker resp. smc_release() might do a sock_put for passive
closing. This causes:

[ 1323.315943] refcount_t: underflow; use-after-free.
[ 1323.316055] WARNING: CPU: 3 PID: 54469 at lib/refcount.c:28 refcount_warn_saturate+0xe8/0x130
[ 1323.316069] Kernel panic - not syncing: panic_on_warn set ...
[ 1323.316084] CPU: 3 PID: 54469 Comm: uperf Not tainted 5.9.0-20200826.rc2.git0.46328853ed20.300.fc32.s390x+debug #1
[ 1323.316096] Hardware name: IBM 2964 NC9 702 (z/VM 6.4.0)
[ 1323.316108] Call Trace:
[ 1323.316125]  [<00000000c0d4aae8>] show_stack+0x90/0xf8
[ 1323.316143]  [<00000000c15989b0>] dump_stack+0xa8/0xe8
[ 1323.316158]  [<00000000c0d8344e>] panic+0x11e/0x288
[ 1323.316173]  [<00000000c0d83144>] __warn+0xac/0x158
[ 1323.316187]  [<00000000c1597a7a>] report_bug+0xb2/0x130
[ 1323.316201]  [<00000000c0d36424>] monitor_event_exception+0x44/0xc0
[ 1323.316219]  [<00000000c195c716>] pgm_check_handler+0x1da/0x238
[ 1323.316234]  [<00000000c151844c>] refcount_warn_saturate+0xec/0x130
[ 1323.316280] ([<00000000c1518448>] refcount_warn_saturate+0xe8/0x130)
[ 1323.316310]  [<000003ff801f2e2a>] smc_release+0x192/0x1c8 [smc]
[ 1323.316323]  [<00000000c169f1fa>] __sock_release+0x5a/0xe0
[ 1323.316334]  [<00000000c169f2ac>] sock_close+0x2c/0x40
[ 1323.316350]  [<00000000c1086de0>] __fput+0xb8/0x278
[ 1323.316362]  [<00000000c0db1e0e>] task_work_run+0x76/0xb8
[ 1323.316393]  [<00000000c0d8ab84>] do_exit+0x26c/0x520
[ 1323.316408]  [<00000000c0d8af08>] do_group_exit+0x48/0xc0
[ 1323.316421]  [<00000000c0d8afa8>] __s390x_sys_exit_group+0x28/0x38
[ 1323.316433]  [<00000000c195c32c>] system_call+0xe0/0x2b4
[ 1323.316446] 1 lock held by uperf/54469:
[ 1323.316456]  #0: 0000000044125e60 (&sb->s_type->i_mutex_key#9){+.+.}-{3:3}, at: __sock_release+0x44/0xe0

The patch rechecks sock state in smc_close_active_abort() after
smc_close_cancel_work() to avoid duplicate decrease of sock
refcount for the same purpose.

Fixes: 611b63a12732 ("net/smc: cancel tx worker in case of socket aborts")
Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_close.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 290270c821ca..35e30d39510d 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -116,7 +116,6 @@ static void smc_close_cancel_work(struct smc_sock *smc)
 	cancel_work_sync(&smc->conn.close_work);
 	cancel_delayed_work_sync(&smc->conn.tx_work);
 	lock_sock(sk);
-	sk->sk_state = SMC_CLOSED;
 }
 
 /* terminate smc socket abnormally - active abort
@@ -134,22 +133,22 @@ void smc_close_active_abort(struct smc_sock *smc)
 	}
 	switch (sk->sk_state) {
 	case SMC_ACTIVE:
-		sk->sk_state = SMC_PEERABORTWAIT;
-		smc_close_cancel_work(smc);
-		sk->sk_state = SMC_CLOSED;
-		sock_put(sk); /* passive closing */
-		break;
 	case SMC_APPCLOSEWAIT1:
 	case SMC_APPCLOSEWAIT2:
+		sk->sk_state = SMC_PEERABORTWAIT;
 		smc_close_cancel_work(smc);
+		if (sk->sk_state != SMC_PEERABORTWAIT)
+			break;
 		sk->sk_state = SMC_CLOSED;
-		sock_put(sk); /* postponed passive closing */
+		sock_put(sk); /* (postponed) passive closing */
 		break;
 	case SMC_PEERCLOSEWAIT1:
 	case SMC_PEERCLOSEWAIT2:
 	case SMC_PEERFINCLOSEWAIT:
 		sk->sk_state = SMC_PEERABORTWAIT;
 		smc_close_cancel_work(smc);
+		if (sk->sk_state != SMC_PEERABORTWAIT)
+			break;
 		sk->sk_state = SMC_CLOSED;
 		smc_conn_free(&smc->conn);
 		release_clcsock = true;
@@ -159,6 +158,8 @@ void smc_close_active_abort(struct smc_sock *smc)
 	case SMC_APPFINCLOSEWAIT:
 		sk->sk_state = SMC_PEERABORTWAIT;
 		smc_close_cancel_work(smc);
+		if (sk->sk_state != SMC_PEERABORTWAIT)
+			break;
 		sk->sk_state = SMC_CLOSED;
 		smc_conn_free(&smc->conn);
 		release_clcsock = true;
-- 
2.17.1

