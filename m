Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB12D32FE0
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 14:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfFCMlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 08:41:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53422 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfFCMlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 08:41:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53CYU0D043745;
        Mon, 3 Jun 2019 12:41:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=cNEEqICyDMHCYPWsAb0dfIFFWQNep6mKPjn4EncGscY=;
 b=oQgzz2scw65R7Djf37AidxdEKRN+1uKF60wDu5afa9pnUoSyCt+AQoEBFlMar1vXq+1P
 xW9PfB7ZVgj7Aw5wbAT/DUItLMWnY5/e7Cs6uqiIm8RCCIwMR707XbjjtO7tJbhEQK9E
 9gXeicji/kj3ljxs9AJK0mLQc7+FwuYrdFppnq91xXomVbCxVkBO5aFgwwOIMjk7e+Bs
 yeGY+Mb5qPGgtAcbJOS7Jt/Yanvepp9gKUyqA7wkQ7Lu3Etz7nuiNh900E2xfBQzUucE
 B/Zm2Ov6xRz7Y9gR0IPSEVVAucf90NXUOP0yDo3jGNTMM0e9MHHGHeWjtTxyb0M7he5t Aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2sugst6nnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jun 2019 12:41:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53Ce5YX092896;
        Mon, 3 Jun 2019 12:41:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2supp73d5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 03 Jun 2019 12:41:14 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x53CfE6C095786;
        Mon, 3 Jun 2019 12:41:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2supp73d5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jun 2019 12:41:14 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x53CfCGt010255;
        Mon, 3 Jun 2019 12:41:13 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Jun 2019 05:41:12 -0700
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: [PATCH 1/1] net: rds: fix memory leak when unload rds_rdma
Date:   Mon,  3 Jun 2019 08:48:19 -0400
Message-Id: <1559566099-30289-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9276 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906030091
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When KASAN is enabled, after several rds connections are
created, then "rmmod rds_rdma" is run. The following will
appear.

"
BUG rds_ib_incoming (Not tainted): Objects remaining
in rds_ib_incoming on __kmem_cache_shutdown()

Call Trace:
 dump_stack+0x71/0xab
 slab_err+0xad/0xd0
 __kmem_cache_shutdown+0x17d/0x370
 shutdown_cache+0x17/0x130
 kmem_cache_destroy+0x1df/0x210
 rds_ib_recv_exit+0x11/0x20 [rds_rdma]
 rds_ib_exit+0x7a/0x90 [rds_rdma]
 __x64_sys_delete_module+0x224/0x2c0
 ? __ia32_sys_delete_module+0x2c0/0x2c0
 do_syscall_64+0x73/0x190
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
"
This is rds connection memory leak. The root cause is:
When "rmmod rds_rdma" is run, rds_ib_remove_one will call
rds_ib_dev_shutdown to drop the rds connections.
rds_ib_dev_shutdown will call rds_conn_drop to drop rds
connections as below.
"
rds_conn_path_drop(&conn->c_path[0], false);
"
In the above, destroy is set to false.
void rds_conn_path_drop(struct rds_conn_path *cp, bool destroy)
{
        atomic_set(&cp->cp_state, RDS_CONN_ERROR);

        rcu_read_lock();
        if (!destroy && rds_destroy_pending(cp->cp_conn)) {
                rcu_read_unlock();
                return;
        }
        queue_work(rds_wq, &cp->cp_down_w);
        rcu_read_unlock();
}
In the above function, destroy is set to false. rds_destroy_pending
is called. This does not move rds connections to ib_nodev_conns.
So destroy is set to true to move rds connections to ib_nodev_conns.
In rds_ib_unregister_client, flush_workqueue is called to make rds_wq
finsh shutdown rds connections. The function rds_ib_destroy_nodev_conns
is called to shutdown rds connections finally.
Then rds_ib_recv_exit is called to destroy slab.

void rds_ib_recv_exit(void)
{
        kmem_cache_destroy(rds_ib_incoming_slab);
        kmem_cache_destroy(rds_ib_frag_slab);
}
The above slab memory leak will not occur again.

From tests,
256 rds connections
[root@ca-dev14 ~]# time rmmod rds_rdma

real    0m16.522s
user    0m0.000s
sys     0m8.152s
512 rds connections
[root@ca-dev14 ~]# time rmmod rds_rdma

real    0m32.054s
user    0m0.000s
sys     0m15.568s

To rmmod rds_rdma with 256 rds connections, about 16 seconds are needed.
And with 512 rds connections, about 32 seconds are needed.
From ftrace, when one rds connection is destroyed,

"
 19)               |  rds_conn_destroy [rds]() {
 19)   7.782 us    |    rds_conn_path_drop [rds]();
 15)               |  rds_shutdown_worker [rds]() {
 15)               |    rds_conn_shutdown [rds]() {
 15)   1.651 us    |      rds_send_path_reset [rds]();
 15)   7.195 us    |    }
 15) + 11.434 us   |  }
 19)   2.285 us    |    rds_cong_remove_conn [rds]();
 19) * 24062.76 us |  }
"
So if many rds connections will be destroyed, this function
rds_ib_destroy_nodev_conns uses most of time.

Suggested-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
 net/rds/ib.c      | 2 +-
 net/rds/ib_recv.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index f9baf2d..ec05d91 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -87,7 +87,7 @@ static void rds_ib_dev_shutdown(struct rds_ib_device *rds_ibdev)
 
 	spin_lock_irqsave(&rds_ibdev->spinlock, flags);
 	list_for_each_entry(ic, &rds_ibdev->conn_list, ib_node)
-		rds_conn_drop(ic->conn);
+		rds_conn_path_drop(&ic->conn->c_path[0], true);
 	spin_unlock_irqrestore(&rds_ibdev->spinlock, flags);
 }
 
diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 8946c89..3cae88c 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -168,6 +168,7 @@ void rds_ib_recv_free_caches(struct rds_ib_connection *ic)
 		list_del(&inc->ii_cache_entry);
 		WARN_ON(!list_empty(&inc->ii_frags));
 		kmem_cache_free(rds_ib_incoming_slab, inc);
+		atomic_dec(&rds_ib_allocation);
 	}
 
 	rds_ib_cache_xfer_to_ready(&ic->i_cache_frags);
@@ -1057,6 +1058,8 @@ int rds_ib_recv_init(void)
 
 void rds_ib_recv_exit(void)
 {
+	WARN_ON(atomic_read(&rds_ib_allocation));
+
 	kmem_cache_destroy(rds_ib_incoming_slab);
 	kmem_cache_destroy(rds_ib_frag_slab);
 }
-- 
2.7.4

