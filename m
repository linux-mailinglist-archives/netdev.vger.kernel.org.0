Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE7BB5186
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 17:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbfIQP3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 11:29:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40734 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbfIQP3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 11:29:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8HFOq7e154224;
        Tue, 17 Sep 2019 15:29:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=zmMf/UIkbkxKoKuaysAd1ZvnJ+OdGT/i9KDty0IVtHg=;
 b=A6lE0BcEtuD5Nn3UfREaoMPV9JkPwtc5nh0cm7rW3w+z33mPefHFHF1KK2x2wsTnYYkw
 YPolCNYZX3esVYw7HbYRiKrLxNaqedcShWChcqPdB780WQtiPWVZA6KDzvlKIikwhoZd
 R7xaozI7Aq48PON3ZqcZbPvSxbHQPu2jU5A0AqlNPkDWdYQWLSH4oPqgKe15ZUrCJOM4
 4RXNVfjuKQlQYZkDcuo4rOVWvqxosDUBUztmrwTWbMvZxvp/kAZJUJSGEOdubh+kmZgF
 SzjXNslsaOyFWHNwqdjy23ojYqpKqQF/vqkNqrMUTLsmRXY2VM31PTje1T5TJsBAIc+r JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v0ruqq8j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 15:29:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8HFO8DT130852;
        Tue, 17 Sep 2019 15:29:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2v2jjtdm4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Sep 2019 15:29:25 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8HFTPcL146187;
        Tue, 17 Sep 2019 15:29:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v2jjtdm2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 15:29:25 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8HFTMe9032474;
        Tue, 17 Sep 2019 15:29:22 GMT
Received: from ca-dev40.us.oracle.com (/10.129.135.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Sep 2019 08:29:21 -0700
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
To:     netdev@vger.kernel.org
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        rds-devel@oss.oracle.com
Subject: [PATCH net] net/rds: Check laddr_check before calling it
Date:   Tue, 17 Sep 2019 08:29:18 -0700
Message-Id: <1568734158-18021-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9383 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909170149
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rds_bind(), laddr_check is called without checking if it is NULL or
not.  And rs_transport should be reset if rds_add_bound() fails.

Reported-by: syzbot+fae39afd2101a17ec624@syzkaller.appspotmail.com
Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
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

