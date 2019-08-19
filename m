Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDB494D2B
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 20:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfHSSkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 14:40:12 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:28222 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727965AbfHSSkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 14:40:12 -0400
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x7JIRGqE028602;
        Mon, 19 Aug 2019 19:40:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=UVjME/leFfu4Vh6IxBmhGApY4QQhSuymRGT67kFS70I=;
 b=bsjR/mjZLSv9L6nEmP/sjnFKLz+ZxGRLXOwN4lZb0lCxehpxwxvd+MqrlaRuADcQsFaB
 e2+e6MHrWQHTw5g0fXlujfpG2Szc+DzcC/vodbDtbJN0tvzVOklh13WWL06kP46CShYG
 sfdLMQ8yF5THb81hxnc1DvNfatzUgjFZOMqp4g8HVdIWhrMHhB5tQbJLXJXmxot0L/zc
 f3/WGfcO8yzzblo4ik+u43RQZMiK8hwJEtqs5+V7KrccxeqE4X39/Cdknbn6kTPDaVr+
 t/Z7sZavtu6bkcmwpJgw3i09Y0n2cqDMFJOj+90E7DI7Eu99MUD8ui6Q3oR7TgVWoZmT FQ== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050095.ppops.net-00190b01. with ESMTP id 2ue943ak4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Aug 2019 19:40:06 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x7JIVsAg013227;
        Mon, 19 Aug 2019 14:40:05 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2uecwva7as-1;
        Mon, 19 Aug 2019 14:40:04 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 0640F1FCDC;
        Mon, 19 Aug 2019 18:40:04 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: [net PATCH] net/smc: make sure EPOLLOUT is raised
Date:   Mon, 19 Aug 2019 14:36:01 -0400
Message-Id: <1566239761-30252-1-git-send-email-jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-19_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=858
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908190192
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-19_04:2019-08-19,2019-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 lowpriorityscore=0 suspectscore=1 mlxscore=0 mlxlogscore=858
 malwarescore=0 spamscore=0 adultscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908190192
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we are only explicitly setting SOCK_NOSPACE on a write timeout
for non-blocking sockets. Epoll() edge-trigger mode relies on SOCK_NOSPACE
being set when -EAGAIN is returned to ensure that EPOLLOUT is raised.
Expand the setting of SOCK_NOSPACE to non-blocking sockets as well that can
use SO_SNDTIMEO to adjust their write timeout. This mirrors the behavior
that Eric Dumazet introduced for tcp sockets.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ursula Braun <ubraun@linux.ibm.com>
Cc: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_tx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index f0de323..6c8f09c 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -76,13 +76,11 @@ static int smc_tx_wait(struct smc_sock *smc, int flags)
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct smc_connection *conn = &smc->conn;
 	struct sock *sk = &smc->sk;
-	bool noblock;
 	long timeo;
 	int rc = 0;
 
 	/* similar to sk_stream_wait_memory */
 	timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
-	noblock = timeo ? false : true;
 	add_wait_queue(sk_sleep(sk), &wait);
 	while (1) {
 		sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
@@ -97,8 +95,8 @@ static int smc_tx_wait(struct smc_sock *smc, int flags)
 			break;
 		}
 		if (!timeo) {
-			if (noblock)
-				set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
+			/* ensure EPOLLOUT is subsequently generated */
+			set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 			rc = -EAGAIN;
 			break;
 		}
-- 
2.7.4

