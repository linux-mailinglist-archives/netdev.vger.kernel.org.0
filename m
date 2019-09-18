Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC898B5EF5
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 10:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbfIRIUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 04:20:37 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39002 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726131AbfIRIUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 04:20:37 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B7BC91C5257CB8FD5C30;
        Wed, 18 Sep 2019 16:20:34 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Wed, 18 Sep 2019 16:20:27 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <chien.yen@oracle.com>, <davem@davemloft.net>,
        <stable@vger.kernel.org>
CC:     <rds-devel@oss.oracle.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH stable 4.4 net] net: rds: Fix NULL ptr use in rds_tcp_kill_sock
Date:   Wed, 18 Sep 2019 16:37:33 +0800
Message-ID: <20190918083733.50266-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the commit c4e97b06cfdc ("net: rds: force to destroy
connection if t_sock is NULL in rds_tcp_kill_sock()."),
it introduced null-ptr-deref in rds_tcp_kill_sock as below:

BUG: KASAN: null-ptr-deref on address 0000000000000020
Read of size 8 by task kworker/u16:10/910
CPU: 3 PID: 910 Comm: kworker/u16:10 Not tainted 4.4.178+ #3
Hardware name: linux,dummy-virt (DT)
Workqueue: netns cleanup_net
Call trace:
[<ffffff90080abb50>] dump_backtrace+0x0/0x618
[<ffffff90080ac1a0>] show_stack+0x38/0x60
[<ffffff9008c42b78>] dump_stack+0x1a8/0x230
[<ffffff90085d469c>] kasan_report_error+0xc8c/0xfc0
[<ffffff90085d54a4>] kasan_report+0x94/0xd8
[<ffffff90085d1b28>] __asan_load8+0x88/0x150
[<ffffff9009c9cc2c>] rds_tcp_dev_event+0x734/0xb48
[<ffffff90081eacb0>] raw_notifier_call_chain+0x150/0x1e8
[<ffffff900973fec0>] call_netdevice_notifiers_info+0x90/0x110
[<ffffff9009764874>] netdev_run_todo+0x2f4/0xb08
[<ffffff9009796d34>] rtnl_unlock+0x2c/0x48
[<ffffff9009756484>] default_device_exit_batch+0x444/0x528
[<ffffff9009720498>] ops_exit_list+0x1c0/0x240
[<ffffff9009724a80>] cleanup_net+0x738/0xbf8
[<ffffff90081ca6cc>] process_one_work+0x96c/0x13e0
[<ffffff90081cf370>] worker_thread+0x7e0/0x1910
[<ffffff90081e7174>] kthread+0x304/0x390
[<ffffff9008094280>] ret_from_fork+0x10/0x50

If the first loop add the tc->t_sock = NULL to the tmp_list,
1). list_for_each_entry_safe(tc, _tc, &rds_tcp_conn_list, t_tcp_node)

then the second loop is to find connections to destroy, tc->t_sock
might equal NULL, and tc->t_sock->sk happens null-ptr-deref.
2). list_for_each_entry_safe(tc, _tc, &tmp_list, t_tcp_node)

Fixes: c4e97b06cfdc ("net: rds: force to destroy connection if t_sock is NULL in rds_tcp_kill_sock().")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 net/rds/tcp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 554d4b461983..c10622a9321c 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -352,9 +352,11 @@ static void rds_tcp_kill_sock(struct net *net)
 	}
 	spin_unlock_irq(&rds_tcp_conn_lock);
 	list_for_each_entry_safe(tc, _tc, &tmp_list, t_tcp_node) {
-		sk = tc->t_sock->sk;
-		sk->sk_prot->disconnect(sk, 0);
-		tcp_done(sk);
+		if (tc->t_sock) {
+			sk = tc->t_sock->sk;
+			sk->sk_prot->disconnect(sk, 0);
+			tcp_done(sk);
+		}
 		if (tc->conn->c_passive)
 			rds_conn_destroy(tc->conn->c_passive);
 		rds_conn_destroy(tc->conn);
-- 
2.20.1

