Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C71E4CCA
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 15:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632729AbfJYNzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 09:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505131AbfJYNzj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:55:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D39A222BD;
        Fri, 25 Oct 2019 13:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011738;
        bh=/5vZq0Extn35PLfohoeq1RAcB06TKXE2V7hZ+LfTC5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSUS7naFH4Y/CPocVhj7wZ6T48Xo690eu+rAMcbZvURrqgGGFPRH2IxEb6buyFBhJ
         6WaiGdOYsmZF+OpqOA3DoS4pMwYqKgXXI81tJLdQJMNRTai4cqH8MLCE1yepJ5RbAi
         cOA7AzbNXNp7CfdRy0c87absZt6+gBVu1yDCHGSQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dag Moxnes <dag.moxnes@oracle.com>, Jenny <jenny.x.xu@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 19/33] net/rds: Whitelist rdma_cookie and rx_tstamp for usercopy
Date:   Fri, 25 Oct 2019 09:54:51 -0400
Message-Id: <20191025135505.24762-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135505.24762-1-sashal@kernel.org>
References: <20191025135505.24762-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dag Moxnes <dag.moxnes@oracle.com>

[ Upstream commit bf1867db9b850fff2dd54a1a117a684a10b8cd90 ]

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
Tested-by: Jenny <jenny.x.xu@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/ib_recv.c | 11 ++++++++---
 net/rds/rds.h     |  9 +++++++--
 net/rds/recv.c    | 22 ++++++++++++----------
 3 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 3cae88cbdaa02..fecd0abdc7e8e 100644
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
index f0066d1684993..e792a67dd5788 100644
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
index a42ba7fa06d5d..c8404971d5ab3 100644
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

