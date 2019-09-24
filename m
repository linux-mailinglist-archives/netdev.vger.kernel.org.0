Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C09EFBCBD5
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390589AbfIXPvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:51:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33758 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389921AbfIXPvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:51:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OFmnvd145269;
        Tue, 24 Sep 2019 15:51:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=t+M7KEkPkb84YztbYiUntLymoQvGaGujAhcuT0Q/ZzA=;
 b=asG2sscsi4up6gR1gs/yDURHb3z8JlxMCPJ0RyZ+dU/TKpCLlRdaXwXRGy0rrjdIV5+O
 txxNSxy/SmD/2/X5QO5nSUg3q1XI4362fZ/hUFDxKak6eVwabW+AS3vblsJyFSv3qR3j
 24hGZ2n2tpFAt2lnOQEB+QfyFBD/g+gU9S+O6CwMluMR7BnrT7T9PdZ1QOSxgHlbnZjX
 Dv3KRTchV0mzDj/3ozuo2Z5+Wg5uBbYDkckGQObECddQhFs1fNCcA0SCxtMgIs60wYgv
 XXz3wx31Dt2bFiJu/cscJue5jHcAiT4y8RViR8xkReUFm7k6JV0xGmIh0hZfyU8gk7Bt XQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v5btpy38c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 15:51:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OFmIiR191604;
        Tue, 24 Sep 2019 15:51:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2v6yvry6t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Sep 2019 15:51:20 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8OForEA004373;
        Tue, 24 Sep 2019 15:51:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v6yvry6sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 15:51:20 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8OFpJMF006859;
        Tue, 24 Sep 2019 15:51:19 GMT
Received: from ca-dev40.us.oracle.com (/10.129.135.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Sep 2019 08:51:19 -0700
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
To:     netdev@vger.kernel.org
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        rds-devel@oss.oracle.com
Subject: [PATCH net] net/rds: Check laddr_check before calling it
Date:   Tue, 24 Sep 2019 08:51:16 -0700
Message-Id: <1569340276-13366-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568734158-18021-1-git-send-email-ka-cheong.poon@oracle.com>
References: <1568734158-18021-1-git-send-email-ka-cheong.poon@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rds_bind(), laddr_check is called without checking if it is NULL or
not.  And rs_transport should be reset if rds_add_bound() fails.

Fixes: c5c1a030a7db ("net/rds: An rds_sock is added too early to the hash table")
Reported-by: syzbot+fae39afd2101a17ec624@syzkaller.appspotmail.com
Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
---
 net/rds/bind.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/rds/bind.c b/net/rds/bind.c
index 20c156a..5b5fb4c 100644
--- a/net/rds/bind.c
+++ b/net/rds/bind.c
@@ -244,7 +244,8 @@ int rds_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	 */
 	if (rs->rs_transport) {
 		trans = rs->rs_transport;
-		if (trans->laddr_check(sock_net(sock->sk),
+		if (!trans->laddr_check ||
+		    trans->laddr_check(sock_net(sock->sk),
 				       binding_addr, scope_id) != 0) {
 			ret = -ENOPROTOOPT;
 			goto out;
@@ -263,6 +264,8 @@ int rds_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 
 	sock_set_flag(sk, SOCK_RCU_FREE);
 	ret = rds_add_bound(rs, binding_addr, &port, scope_id);
+	if (ret)
+		rs->rs_transport = NULL;
 
 out:
 	release_sock(sk);
-- 
1.8.3.1

