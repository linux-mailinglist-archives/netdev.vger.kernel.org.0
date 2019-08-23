Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4551A9B18A
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 16:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392170AbfHWOEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 10:04:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54228 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbfHWOEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 10:04:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NE4EWt067263;
        Fri, 23 Aug 2019 14:04:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=IDxcKcBV6zGKVEQdfou/OVhAl7PAzAEZMKbLS7MrvG0=;
 b=Tde+ZdWXnNeVakcmrK+++e/KK/perHHv93N1TRY4ooLzHhb0PJy5+24BiBhn9tT9JU/C
 ExiPyOb58vxpB8NNVKOEvJodIcTUL5aIIHnXHUMlq7LoFPXh1k+ot+88/IhmEFcDujyN
 LDBqaLsb5eFO4rzgZEnMtvPs8kd91R+Xr7JxrypSotAO1HQGSmesMuyx9C14bQpQsBm/
 dEwxKsw0qQhopbpOkPHaJcEGi5gKGrlomWgQPR5Ax9vqs5d8Ph/rZ4oB3OwyKT+rLIRF
 ldrFTgMOXTIgUf1p0zCns9Kd8Xuv+mFKtS49FiE8i3z64dyvrxSq9Mj3b6bbmO21Utlf Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ue90u52p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 14:04:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NDw8th027288;
        Fri, 23 Aug 2019 14:04:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ujca84w6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 23 Aug 2019 14:04:13 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7NE4DqK048844;
        Fri, 23 Aug 2019 14:04:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ujca84w6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 14:04:13 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7NE4CPS027028;
        Fri, 23 Aug 2019 14:04:12 GMT
Received: from dm-oel.no.oracle.com (/10.172.157.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 07:04:12 -0700
From:   Dag Moxnes <dag.moxnes@oracle.com>
To:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     davem@davemloft.net, dag.moxnes@oracle.com
Subject: [PATCH net-next] net/rds: Whitelist rdma_cookie and rx_tstamp for usercopy
Date:   Fri, 23 Aug 2019 16:03:18 +0200
Message-Id: <1566568998-26222-1-git-send-email-dag.moxnes@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the RDMA cookie and RX timestamp to the usercopy whitelist.

After the introduction of hardened usercopy whitelisting
(https://lwn.net/Articles/727322/), a warning is displayed when the
RDMA cookie or RX timestamp is copied to userspace:

kernel: WARNING: CPU: 3 PID: 5750 at
mm/usercopy.c:81 usercopy_warn+0x8e/0xa6
[...]
kernel: Call Trace:
kernel: __check_heap_object+0xb8/0x11b
kernel: __check_object_size+0xe3/0x1bc
kernel: put_cmsg+0x95/0x115
kernel: rds_recvmsg+0x43d/0x620 [rds]
kernel: sock_recvmsg+0x43/0x4a
kernel: ___sys_recvmsg+0xda/0x1e6
kernel: ? __handle_mm_fault+0xcae/0xf79
kernel: __sys_recvmsg+0x51/0x8a
kernel: SyS_recvmsg+0x12/0x1c
kernel: do_syscall_64+0x79/0x1ae

When the whitelisting feature was introduced, the memory for the RDMA
cookie and RX timestamp in RDS was not added to the whitelist, causing
the warning above.

Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>
Tested-by: jenny.x.xu@oracle.com
---
 net/rds/ib_recv.c | 11 ++++++++---
 net/rds/rds.h     |  9 +++++++--
 net/rds/recv.c    | 22 ++++++++++++----------
 3 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 3cae88cbda..fecd0abdc7 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -1038,9 +1038,14 @@ int rds_ib_recv_init(void)
 	si_meminfo(&si);
 	rds_ib_sysctl_max_recv_allocation = si.totalram / 3 * PAGE_SIZE / RDS_FRAG_SIZE;
 
-	rds_ib_incoming_slab = kmem_cache_create("rds_ib_incoming",
-					sizeof(struct rds_ib_incoming),
-					0, SLAB_HWCACHE_ALIGN, NULL);
+	rds_ib_incoming_slab =
+		kmem_cache_create_usercopy("rds_ib_incoming",
+					   sizeof(struct rds_ib_incoming),
+					   0, SLAB_HWCACHE_ALIGN,
+					   offsetof(struct rds_ib_incoming,
+						    ii_inc.i_usercopy),
+					   sizeof(struct rds_inc_usercopy),
+					   NULL);
 	if (!rds_ib_incoming_slab)
 		goto out;
 
diff --git a/net/rds/rds.h b/net/rds/rds.h
index f0066d1684..e792a67dd5 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -271,6 +271,12 @@ struct rds_ext_header_rdma_dest {
 #define	RDS_MSG_RX_END		2
 #define	RDS_MSG_RX_CMSG		3
 
+/* The following values are whitelisted for usercopy */
+struct rds_inc_usercopy {
+	rds_rdma_cookie_t	rdma_cookie;
+	ktime_t			rx_tstamp;
+};
+
 struct rds_incoming {
 	refcount_t		i_refcount;
 	struct list_head	i_item;
@@ -280,8 +286,7 @@ struct rds_incoming {
 	unsigned long		i_rx_jiffies;
 	struct in6_addr		i_saddr;
 
-	rds_rdma_cookie_t	i_rdma_cookie;
-	ktime_t			i_rx_tstamp;
+	struct rds_inc_usercopy i_usercopy;
 	u64			i_rx_lat_trace[RDS_RX_MAX_TRACES];
 };
 
diff --git a/net/rds/recv.c b/net/rds/recv.c
index 853de48760..7e451c8259 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -47,8 +47,8 @@ void rds_inc_init(struct rds_incoming *inc, struct rds_connection *conn,
 	INIT_LIST_HEAD(&inc->i_item);
 	inc->i_conn = conn;
 	inc->i_saddr = *saddr;
-	inc->i_rdma_cookie = 0;
-	inc->i_rx_tstamp = ktime_set(0, 0);
+	inc->i_usercopy.rdma_cookie = 0;
+	inc->i_usercopy.rx_tstamp = ktime_set(0, 0);
 
 	memset(inc->i_rx_lat_trace, 0, sizeof(inc->i_rx_lat_trace));
 }
@@ -62,8 +62,8 @@ void rds_inc_path_init(struct rds_incoming *inc, struct rds_conn_path *cp,
 	inc->i_conn = cp->cp_conn;
 	inc->i_conn_path = cp;
 	inc->i_saddr = *saddr;
-	inc->i_rdma_cookie = 0;
-	inc->i_rx_tstamp = ktime_set(0, 0);
+	inc->i_usercopy.rdma_cookie = 0;
+	inc->i_usercopy.rx_tstamp = ktime_set(0, 0);
 }
 EXPORT_SYMBOL_GPL(rds_inc_path_init);
 
@@ -186,7 +186,7 @@ static void rds_recv_incoming_exthdrs(struct rds_incoming *inc, struct rds_sock
 		case RDS_EXTHDR_RDMA_DEST:
 			/* We ignore the size for now. We could stash it
 			 * somewhere and use it for error checking. */
-			inc->i_rdma_cookie = rds_rdma_make_cookie(
+			inc->i_usercopy.rdma_cookie = rds_rdma_make_cookie(
 					be32_to_cpu(buffer.rdma_dest.h_rdma_rkey),
 					be32_to_cpu(buffer.rdma_dest.h_rdma_offset));
 
@@ -380,7 +380,7 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
 				      be32_to_cpu(inc->i_hdr.h_len),
 				      inc->i_hdr.h_dport);
 		if (sock_flag(sk, SOCK_RCVTSTAMP))
-			inc->i_rx_tstamp = ktime_get_real();
+			inc->i_usercopy.rx_tstamp = ktime_get_real();
 		rds_inc_addref(inc);
 		inc->i_rx_lat_trace[RDS_MSG_RX_END] = local_clock();
 		list_add_tail(&inc->i_item, &rs->rs_recv_queue);
@@ -540,16 +540,18 @@ static int rds_cmsg_recv(struct rds_incoming *inc, struct msghdr *msg,
 {
 	int ret = 0;
 
-	if (inc->i_rdma_cookie) {
+	if (inc->i_usercopy.rdma_cookie) {
 		ret = put_cmsg(msg, SOL_RDS, RDS_CMSG_RDMA_DEST,
-				sizeof(inc->i_rdma_cookie), &inc->i_rdma_cookie);
+				sizeof(inc->i_usercopy.rdma_cookie),
+				&inc->i_usercopy.rdma_cookie);
 		if (ret)
 			goto out;
 	}
 
-	if ((inc->i_rx_tstamp != 0) &&
+	if ((inc->i_usercopy.rx_tstamp != 0) &&
 	    sock_flag(rds_rs_to_sk(rs), SOCK_RCVTSTAMP)) {
-		struct __kernel_old_timeval tv = ns_to_kernel_old_timeval(inc->i_rx_tstamp);
+		struct __kernel_old_timeval tv =
+			ns_to_kernel_old_timeval(inc->i_usercopy.rx_tstamp);
 
 		if (!sock_flag(rds_rs_to_sk(rs), SOCK_TSTAMP_NEW)) {
 			ret = put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_OLD,
-- 
2.20.1

