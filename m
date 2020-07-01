Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39497211375
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 21:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgGATXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 15:23:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36008 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgGATXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 15:23:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061JMEK3103547;
        Wed, 1 Jul 2020 19:23:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=siJdK4QK5aSRhtorv9v4f8AGZi4rxo+SzwUUzhRWE/8=;
 b=f5LPid/xW/fa9QLd0wU+oJW11LIUHCD7uvOg0nkmMhc2nIRgOc+aqaCam7FDFcGFcwlx
 mUKIFy6iFUR2cYKDVti7c6+LJjgMgicFy/O0cXnJiY3vQQak6M9y0KaNC3LK9lOhvbbY
 i6xR+VV08A4YiQXcsCulOPYRWLMiX02ALiNjQG3mHeBhbilcj/9ytqwrv5Zkndtrhnyr
 117mLJHUySOWKQlqC0Z4XvydBBJNcIAQNA1EOFKfhLtEQrZ9yawKfIJDrPMdO9/bK0hy
 r3xge/EENgqX6Yj6L1YmwAQnZerTmik80NSMWwTU5BXIKszdnJ0RKezGFT0L6p/h9/I/ gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrncewa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 19:23:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061JMcTU023930;
        Wed, 1 Jul 2020 19:23:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31xfvudkd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 19:23:47 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 061JNkpe020046;
        Wed, 1 Jul 2020 19:23:46 GMT
Received: from oracle.com (/10.159.143.226)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 19:23:45 +0000
From:   rao.shoaib@oracle.com
To:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc:     rao.shoaib@oracle.com, ka-cheong.poon@oracle.com,
        david.edmondson@oracle.com
Subject: [PATCH v1] rds: If one path needs re-connection, check all and re-connect
Date:   Wed,  1 Jul 2020 12:23:38 -0700
Message-Id: <20200701192338.11695-1-rao.shoaib@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

In testing with mprds enabled, Oracle Cluster nodes after reboot were
not able to communicate with others nodes and so failed to rejoin
the cluster. Peers with lower IP address initiated connection but the
node could not respond as it choose a different path and could not
initiate a connection as it had a higher IP address.

With this patch, when a node sends out a packet and the selected path
is down, all other paths are also checked and any down paths are
re-connected.

Reviewed-by: Ka-cheong Poon <ka-cheong.poon@oracle.com>
Reviewed-by: David Edmondson <david.edmondson@oracle.com>
Signed-off-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
---
 net/rds/connection.c | 11 +++++++++++
 net/rds/rds.h        |  7 +++++++
 net/rds/send.c       |  3 ++-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index ed7f2133acc2..f2fcab182095 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -905,6 +905,17 @@ void rds_conn_path_connect_if_down(struct rds_conn_path *cp)
 }
 EXPORT_SYMBOL_GPL(rds_conn_path_connect_if_down);
 
+/* Check connectivity of all paths
+ */
+void rds_check_all_paths(struct rds_connection *conn)
+{
+	int i = 0;
+
+	do {
+		rds_conn_path_connect_if_down(&conn->c_path[i]);
+	} while (++i < conn->c_npaths);
+}
+
 void rds_conn_connect_if_down(struct rds_connection *conn)
 {
 	WARN_ON(conn->c_trans->t_mp_capable);
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 6019b0c004a9..106e862996b9 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -778,6 +778,7 @@ void rds_conn_drop(struct rds_connection *conn);
 void rds_conn_path_drop(struct rds_conn_path *cpath, bool destroy);
 void rds_conn_connect_if_down(struct rds_connection *conn);
 void rds_conn_path_connect_if_down(struct rds_conn_path *cp);
+void rds_check_all_paths(struct rds_connection *conn);
 void rds_for_each_conn_info(struct socket *sock, unsigned int len,
 			  struct rds_info_iterator *iter,
 			  struct rds_info_lengths *lens,
@@ -822,6 +823,12 @@ rds_conn_path_up(struct rds_conn_path *cp)
 	return atomic_read(&cp->cp_state) == RDS_CONN_UP;
 }
 
+static inline int
+rds_conn_path_down(struct rds_conn_path *cp)
+{
+	return atomic_read(&cp->cp_state) == RDS_CONN_DOWN;
+}
+
 static inline int
 rds_conn_up(struct rds_connection *conn)
 {
diff --git a/net/rds/send.c b/net/rds/send.c
index 68e2bdb08fd0..9a529a01cdc6 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1340,7 +1340,8 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		goto out;
 	}
 
-	rds_conn_path_connect_if_down(cpath);
+	if (rds_conn_path_down(cpath))
+		rds_check_all_paths(conn);
 
 	ret = rds_cong_wait(conn->c_fcong, dport, nonblock, rs);
 	if (ret) {
-- 
2.16.6

