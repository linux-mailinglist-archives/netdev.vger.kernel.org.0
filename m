Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A922930C6
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgJSVti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:49:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32798 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729466AbgJSVth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 17:49:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JLiEDf008628;
        Mon, 19 Oct 2020 21:49:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=zRnQI8EQayPaK96pH8XspXA3BUSbgetS3UNxcz7mClU=;
 b=f4JRZxxKvGXmW8T+YYxMFfL15OiUxVI5+pdKUflSp52hdOyqBdjMjaaA0LZ8JINECsD+
 baAfQmZb4zdf0Z71vDJC/9nnQnwSVrFlbkNPKoCOLwER+iJmCe2rkR6HFZouMPFTudS2
 LTPjNlSNTQaJKshUkv9GTpIVe2W5cdNd/yFDdxM+xbwmDMeBMTfibJdCuUAJByo0rXk3
 wU4DOR22Tp7CkPo/qiA5KGEXmYUvVUjcIpCVvtCksDCS8K8YiSxVRM3FbjS1gU2olGqm
 nPZ0r5pWN/0wh+WDHr7Nqwr7ezX2428AOPEt4+VLPuaSmJsC6EVrdeHrenXK+Ja77IR0 gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 347s8mqucd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 21:49:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JLnZYb021511;
        Mon, 19 Oct 2020 21:49:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 348agwn4y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 21:49:35 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09JLnTgd018606;
        Mon, 19 Oct 2020 21:49:30 GMT
Received: from mbpatil.us.oracle.com (/10.211.44.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 14:49:29 -0700
From:   Manjunath Patil <manjunath.b.patil@oracle.com>
To:     santosh.shilimkar@oracle.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rama.nichanamatlu@oracle.com, manjunath.b.patil@oracle.com
Subject: [PATCH 2/2] rds: add functionality to print MR related information
Date:   Mon, 19 Oct 2020 14:48:08 -0700
Message-Id: <1603144088-8769-3-git-send-email-manjunath.b.patil@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1603144088-8769-1-git-send-email-manjunath.b.patil@oracle.com>
References: <1603144088-8769-1-git-send-email-manjunath.b.patil@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=1 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=1
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190146
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RDS keeps its own pool of limited MRs[Memory Regions taken from ib
device for rdma operation] which are shared by RDS applications. Now, we
can print the applications along with their usage of MRs from userspace
using 'rds-info -m' command. This would help in tracking the limited
MRs.

MR related information is stored in rds_sock. This patch exposes the
information to userspace using rds-info command. The usage is limited to
CAP_NET_ADMIN privilege.

sample output:
 # rds-info -m

RDS MRs:
Program          PID    MR-gets    MR-puts    MR-inuse   <IP,port,ToS>
rds-stress       17743  28468      28464      4          <192.168.18..
rds-stress       17744  19385      19381      4          <192.168.18..

Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
Reviewed-by: Ka-cheong Poon <ka-cheong.poon@oracle.com>
---
 include/uapi/linux/rds.h | 13 ++++++++++++-
 net/rds/af_rds.c         | 38 ++++++++++++++++++++++++++++++++++++++
 net/rds/ib.c             |  1 +
 net/rds/rds.h            |  4 +++-
 4 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
index cba368e55863..a6e8e28d95fb 100644
--- a/include/uapi/linux/rds.h
+++ b/include/uapi/linux/rds.h
@@ -134,8 +134,9 @@ typedef __u8	rds_tos_t;
 #define RDS6_INFO_SOCKETS		10015
 #define RDS6_INFO_TCP_SOCKETS		10016
 #define RDS6_INFO_IB_CONNECTIONS	10017
+#define RDS_INFO_MRS			10018
 
-#define RDS_INFO_LAST			10017
+#define RDS_INFO_LAST			10018
 
 struct rds_info_counter {
 	__u8	name[32];
@@ -270,6 +271,16 @@ struct rds6_info_rdma_connection {
 	__u32		cache_allocs;
 };
 
+struct rds_info_mr {
+	__u32		pid;
+	__u8		comm[TASK_COMM_LEN];
+	__u64		gets;
+	__u64		puts;
+	struct in6_addr	laddr;
+	__be16		lport;
+	__u8		tos;
+} __attribute__((packed));
+
 /* RDS message Receive Path Latency points */
 enum rds_message_rxpath_latency {
 	RDS_MSG_RX_HDR_TO_DGRAM_START = 0,
diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index e291095e5224..c81acf1a9457 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -486,6 +486,7 @@ static int rds_getsockopt(struct socket *sock, int level, int optname,
 			  char __user *optval, int __user *optlen)
 {
 	struct rds_sock *rs = rds_sk_to_rs(sock->sk);
+	struct net *net = sock_net(sock->sk);
 	int ret = -ENOPROTOOPT, len;
 	int trans;
 
@@ -499,6 +500,11 @@ static int rds_getsockopt(struct socket *sock, int level, int optname,
 
 	switch (optname) {
 	case RDS_INFO_FIRST ... RDS_INFO_LAST:
+		if (optname == RDS_INFO_MRS &&
+		    !ns_capable(net->user_ns, CAP_NET_ADMIN)) {
+			ret = -EACCES;
+			break;
+		}
 		ret = rds_info_getsockopt(sock, optname, optval,
 					  optlen);
 		break;
@@ -878,6 +884,38 @@ static void rds6_sock_info(struct socket *sock, unsigned int len,
 }
 #endif
 
+void rds_info_mrs(struct socket *sock, unsigned int len,
+		  struct rds_info_iterator *iter,
+		  struct rds_info_lengths *lens)
+{
+	struct rds_sock *rs;
+	struct rds_info_mr mr_info;
+	unsigned int total = 0;
+
+	len /= sizeof(mr_info);
+
+	spin_lock_bh(&rds_sock_lock);
+	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		total++;
+		if (total <= len) {
+			memset(&mr_info, 0, sizeof(mr_info));
+			mr_info.pid = rs->rs_pid;
+			strncpy(mr_info.comm, rs->rs_comm, TASK_COMM_LEN);
+			mr_info.gets = atomic64_read(&rs->rs_mr_gets);
+			mr_info.puts = atomic64_read(&rs->rs_mr_puts);
+			mr_info.laddr = rs->rs_bound_addr;
+			mr_info.lport = rs->rs_bound_port;
+			mr_info.tos = rs->rs_tos;
+			rds_info_copy(iter, &mr_info, sizeof(mr_info));
+		}
+	}
+	spin_unlock_bh(&rds_sock_lock);
+
+	lens->nr = total;
+	lens->each = sizeof(mr_info);
+}
+EXPORT_SYMBOL_GPL(rds_info_mrs);
+
 static void rds_exit(void)
 {
 	sock_unregister(rds_family_ops.family);
diff --git a/net/rds/ib.c b/net/rds/ib.c
index a792d8a3872a..48476ae95da9 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -599,6 +599,7 @@ int rds_ib_init(void)
 	rds_trans_register(&rds_ib_transport);
 
 	rds_info_register_func(RDS_INFO_IB_CONNECTIONS, rds_ib_ic_info);
+	rds_info_register_func(RDS_INFO_MRS, rds_info_mrs);
 #if IS_ENABLED(CONFIG_IPV6)
 	rds_info_register_func(RDS6_INFO_IB_CONNECTIONS, rds6_ib_ic_info);
 #endif
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 5e61868e1799..dd42bc95bbeb 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -746,7 +746,9 @@ static inline void __rds_wake_sk_sleep(struct sock *sk)
 		wake_up(waitq);
 }
 extern wait_queue_head_t rds_poll_waitq;
-
+void rds_info_mrs(struct socket *sock, unsigned int len,
+		  struct rds_info_iterator *iter,
+		  struct rds_info_lengths *lens);
 
 /* bind.c */
 int rds_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
-- 
2.27.0.112.g101b320

