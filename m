Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24A0331DB0
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 04:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhCIDs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 22:48:27 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13486 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhCIDsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 22:48:00 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Dvh2T46pszrSmy;
        Tue,  9 Mar 2021 11:46:09 +0800 (CST)
Received: from DESKTOP-9883QJJ.china.huawei.com (10.136.114.155) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Mar 2021 11:47:45 +0800
From:   zhudi <zhudi21@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <zhudi21@huawei.com>, <rose.chen@huawei.com>
Subject: [PATCH] net/sched: act_pedit: fix a NULL pointer deref in tcf_pedit_init
Date:   Tue, 9 Mar 2021 11:47:36 +0800
Message-ID: <20210309034736.8656-1-zhudi21@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.136.114.155]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Di Zhu <zhudi21@huawei.com>

when we use syzkaller to fuzz-test our kernel, one NULL pointer dereference
BUG happened:

Write of size 96 at addr 0000000000000010 by task syz-executor.0/22376
==================================================================
BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
PGD 80000001dc1a9067 P4D 80000001dc1a9067 PUD 1a32b5067 PMD 0
[...]
Call Trace
memcpy  include/linux/string.h:345 [inline]
tcf_pedit_init+0x7b4/0xa10 net/sched/act_pedit.c:232
tcf_action_init_1+0x59b/0x730  net/sched/act_api.c:920
tcf_action_init+0x1ef/0x320  net/sched/act_api.c:975
tcf_action_add+0xd2/0x270  net/sched/act_api.c:1360
tc_ctl_action+0x267/0x290  net/sched/act_api.c:1412
[...]

The root cause is that we use kmalloc() to allocate mem space for
keys without checking if the ksize is 0. if ksize == 0 then kmalloc()
will return ZERO_SIZE_PTR currently defined as 16, not the NULL pointer.
eventually ZERO_SIZE_PTR is assigned to p->tcfp_keys. The next time you
update the action with ksize not equal to 0, the bug will appear. This is
because  p->tcfp_nkeys == 0, so it will not call kmalloc() to realloc mem
using new ksize and eventually, memcpy() use ZERO_SIZE_PTR as destination
address.

So we can allow memory reallocation even if current p->tcfp_nkeys == 0 and
kfree() supports ZERO_SIZE_PTR as input parameter

Signed-off-by: Di Zhu <zhudi21@huawei.com>
---
 net/sched/act_pedit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index b45304446e13..86514bd49ab6 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -216,7 +216,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	spin_lock_bh(&p->tcf_lock);
 
 	if (ret == ACT_P_CREATED ||
-	    (p->tcfp_nkeys && p->tcfp_nkeys != parm->nkeys)) {
+	    (p->tcfp_nkeys != parm->nkeys)) {
 		keys = kmalloc(ksize, GFP_ATOMIC);
 		if (!keys) {
 			spin_unlock_bh(&p->tcf_lock);
-- 
2.23.0

