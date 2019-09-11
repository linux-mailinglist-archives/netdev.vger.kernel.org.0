Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5587BAF9AD
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 11:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfIKJ7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 05:59:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49574 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbfIKJ7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 05:59:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8B9rdXm152061;
        Wed, 11 Sep 2019 09:58:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=2pgYRnqPxu+27mGHijN589q6KpcM1n8gWFev5euUyiU=;
 b=pSyjKNKubdHAzoyu/biUztCawrTn9wjTM2mIS3d1UXPx2TlBNVAQ1HmulR8bvPpuHrvi
 H9TOaR2huFnVwKWo2HcnWxw80pzetmG6VDlTM4lRcDBrM2dxiSxqv0T36J/DMhutLjAy
 w2PtIVjY3bCv4x3VaF0R3aGaFhsn2iM+Hi44P/NMFVj2iT7IAB3/DjWxq990sRUPnSav
 uxjq6bpbeNuoe83BNp3KHTedvznR14OSnQG4HXnS52B8fqnppk3EjnmoqmmDTnHyaQBb
 VRJA4n1nSQI8pQzpweW52tOC9ZbQqhyCBLeifWcmzb66bhIdwJ7Scv62GLm5k6DR/NK0 iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2uw1m90vjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 09:58:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8B9rYRa131127;
        Wed, 11 Sep 2019 09:58:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2uxd6dwycc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Sep 2019 09:58:52 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8B9wqtK143450;
        Wed, 11 Sep 2019 09:58:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2uxd6dwybr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 09:58:52 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8B9wpmg023907;
        Wed, 11 Sep 2019 09:58:51 GMT
Received: from ca-dev40.us.oracle.com (/10.129.135.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Sep 2019 02:58:50 -0700
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
To:     netdev@vger.kernel.org
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        rds-devel@oss.oracle.com
Subject: [PATCH net] net/rds: An rds_sock is added too early to the hash table
Date:   Wed, 11 Sep 2019 02:58:05 -0700
Message-Id: <1568195885-6285-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=919 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909110093
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rds_bind(), an rds_sock is added to the RDS bind hash table before
rs_transport is set.  This means that the socket can be found by the
receive code path when rs_transport is NULL.  And the receive code
path de-references rs_transport for congestion update check.  This can
cause a panic.  An rds_sock should not be added to the bind hash table
before all the needed fields are set.

Reported-by: syzbot+4b4f8163c2e246df3c4c@syzkaller.appspotmail.com
Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
---
 net/rds/bind.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/net/rds/bind.c b/net/rds/bind.c
index 6dbb763..20c156a 100644
--- a/net/rds/bind.c
+++ b/net/rds/bind.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006, 2018 Oracle and/or its affiliates. All rights reserved.
+ * Copyright (c) 2006, 2019 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -239,34 +239,30 @@ int rds_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		goto out;
 	}
 
-	sock_set_flag(sk, SOCK_RCU_FREE);
-	ret = rds_add_bound(rs, binding_addr, &port, scope_id);
-	if (ret)
-		goto out;
-
-	if (rs->rs_transport) { /* previously bound */
+	/* The transport can be set using SO_RDS_TRANSPORT option before the
+	 * socket is bound.
+	 */
+	if (rs->rs_transport) {
 		trans = rs->rs_transport;
 		if (trans->laddr_check(sock_net(sock->sk),
 				       binding_addr, scope_id) != 0) {
 			ret = -ENOPROTOOPT;
-			rds_remove_bound(rs);
-		} else {
-			ret = 0;
+			goto out;
 		}
-		goto out;
-	}
-	trans = rds_trans_get_preferred(sock_net(sock->sk), binding_addr,
-					scope_id);
-	if (!trans) {
-		ret = -EADDRNOTAVAIL;
-		rds_remove_bound(rs);
-		pr_info_ratelimited("RDS: %s could not find a transport for %pI6c, load rds_tcp or rds_rdma?\n",
-				    __func__, binding_addr);
-		goto out;
+	} else {
+		trans = rds_trans_get_preferred(sock_net(sock->sk),
+						binding_addr, scope_id);
+		if (!trans) {
+			ret = -EADDRNOTAVAIL;
+			pr_info_ratelimited("RDS: %s could not find a transport for %pI6c, load rds_tcp or rds_rdma?\n",
+					    __func__, binding_addr);
+			goto out;
+		}
+		rs->rs_transport = trans;
 	}
 
-	rs->rs_transport = trans;
-	ret = 0;
+	sock_set_flag(sk, SOCK_RCU_FREE);
+	ret = rds_add_bound(rs, binding_addr, &port, scope_id);
 
 out:
 	release_sock(sk);
-- 
1.8.3.1

