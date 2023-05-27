Return-Path: <netdev+bounces-5870-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47DC57133AE
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 11:29:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD94B281880
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 09:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB8CB53A5;
	Sat, 27 May 2023 09:29:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13353D67
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 09:29:55 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF6312A
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 02:29:53 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QSxGP4LBdzqTP3;
	Sat, 27 May 2023 17:25:17 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sat, 27 May
 2023 17:29:51 +0800
From: Zhengchao Shao <shaozhengchao@huawei.com>
To: <netdev@vger.kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
	<jiri@resnulli.us>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
	<shaozhengchao@huawei.com>, <wanghai38@huawei.com>
Subject: [PATCH net] net: sched: fix NULL pointer dereference in mq_attach
Date: Sat, 27 May 2023 17:37:47 +0800
Message-ID: <20230527093747.3583502-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When use the following command to test:
1)ip link add bond0 type bond
2)ip link set bond0 up
3)tc qdisc add dev bond0 root handle ffff: mq
4)tc qdisc replace dev bond0 parent ffff:fff1 handle ffff: mq

The kernel reports NULL pointer dereference issue. The stack information
is as follows:
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
Internal error: Oops: 0000000096000006 [#1] SMP
Modules linked in:
pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : mq_attach+0x44/0xa0
lr : qdisc_graft+0x20c/0x5cc
sp : ffff80000e2236a0
x29: ffff80000e2236a0 x28: ffff0000c0e59d80 x27: ffff0000c0be19c0
x26: ffff0000cae3e800 x25: 0000000000000010 x24: 00000000fffffff1
x23: 0000000000000000 x22: ffff0000cae3e800 x21: ffff0000c9df4000
x20: ffff0000c9df4000 x19: 0000000000000000 x18: ffff80000a934000
x17: ffff8000f5b56000 x16: ffff80000bb08000 x15: 0000000000000000
x14: 0000000000000000 x13: 6b6b6b6b6b6b6b6b x12: 6b6b6b6b00000001
x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
x8 : ffff0000c0be0730 x7 : bbbbbbbbbbbbbbbb x6 : 0000000000000008
x5 : ffff0000cae3e864 x4 : 0000000000000000 x3 : 0000000000000001
x2 : 0000000000000001 x1 : ffff8000090bc23c x0 : 0000000000000000
Call trace:
mq_attach+0x44/0xa0
qdisc_graft+0x20c/0x5cc
tc_modify_qdisc+0x1c4/0x664
rtnetlink_rcv_msg+0x354/0x440
netlink_rcv_skb+0x64/0x144
rtnetlink_rcv+0x28/0x34
netlink_unicast+0x1e8/0x2a4
netlink_sendmsg+0x308/0x4a0
sock_sendmsg+0x64/0xac
____sys_sendmsg+0x29c/0x358
___sys_sendmsg+0x90/0xd0
__sys_sendmsg+0x7c/0xd0
__arm64_sys_sendmsg+0x2c/0x38
invoke_syscall+0x54/0x114
el0_svc_common.constprop.1+0x90/0x174
do_el0_svc+0x3c/0xb0
el0_svc+0x24/0xec
el0t_64_sync_handler+0x90/0xb4
el0t_64_sync+0x174/0x178

This is because when mq is added for the first time, qdiscs in mq is set
to NULL in mq_attach(). Therefore, when replacing mq after adding mq, we
need to initialize qdiscs in the mq before continuing to graft. Otherwise,
it will couse NULL pointer dereference issue in mq_attach(). And the same
issue will occur in the attach functions of mqprio, taprio and htb.
ffff:fff1 means that the repalce qdisc is ingress. Ingress does not allow
any qdisc to be attached. Therefore, ffff:fff1 is incorrectly used, and
the command should be dropped.

Fixes: 6ec1c69a8f64 ("net_sched: add classful multiqueue dummy scheduler")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_api.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index fdb8f429333d..dbc9cf5eea89 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1596,6 +1596,10 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 					NL_SET_ERR_MSG(extack, "Qdisc parent/child loop detected");
 					return -ELOOP;
 				}
+				if (clid == TC_H_INGRESS) {
+					NL_SET_ERR_MSG(extack, "Ingress cannot graft directly");
+					return -EINVAL;
+				}
 				qdisc_refcount_inc(q);
 				goto graft;
 			} else {
-- 
2.34.1


