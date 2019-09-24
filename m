Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F57BCB5C
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbfIXP2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:28:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51024 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbfIXP2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:28:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OF5EEs149450;
        Tue, 24 Sep 2019 15:28:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=g07tUej4r8tl/cVDB1Npb0nr1MJwUC80oQqMDT9Zc/I=;
 b=nbsrKw6NfjGj7jXz2BEcYnQKXBT/7vrhkN9AEnRc/xs4WciMoVau0IP3Znh3ZNVkdeOD
 RPzwH+l0oWzEClbIs3XUFxh0DDhwvEg/FrOYfKCs5ByYwJZK956uSokluWMwGQrhC9h/
 C9mS+oMZjnb00gfWzDrlR1KqHNYGHLcMoATquxL1KqGIlllq6ERlNDbaDPvfXWApLNnL
 KoxY+zIFiCUO4aK+E4yOCHlJ569uyMOpGaJMfMciLUCaeyH0GUtnKw5orM+3lzada1xp
 6ccNlBRppJMSblGt8cGxuV0dwpFemyJuv3oB77BzHq9aZsXaGrWlJYR5Bo5Iv8OZ/hP4 nQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v5cgqxurh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 15:28:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OF6mMa082299;
        Tue, 24 Sep 2019 15:28:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2v6yvkqnw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Sep 2019 15:28:02 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8OFS1mh150699;
        Tue, 24 Sep 2019 15:28:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2v6yvkqnut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 15:28:01 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8OFS0lT022208;
        Tue, 24 Sep 2019 15:28:00 GMT
Received: from ca-dev40.us.oracle.com (/10.129.135.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Sep 2019 08:28:00 -0700
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
To:     netdev@vger.kernel.org
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        rds-devel@oss.oracle.com
Subject: [PATCH net-next] net/rds: Check laddr_check before calling it
Date:   Tue, 24 Sep 2019 08:27:56 -0700
Message-Id: <1569338876-12857-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568734158-18021-1-git-send-email-ka-cheong.poon@oracle.com>
References: <1568734158-18021-1-git-send-email-ka-cheong.poon@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rds_bind(), laddr_check is called without checking if it is NULL or
not.  And rs_transport should be reset if rds_add_bound() fails.

Fixes: c5c1a030a7db ("net/rds: Check laddr_check before calling it")
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

