Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03BF1B29F5
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 16:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbgDUOda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 10:33:30 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33942 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729174AbgDUOd2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 10:33:28 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 36298267342B093BC7CE;
        Tue, 21 Apr 2020 22:33:21 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Tue, 21 Apr 2020
 22:33:11 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lucien.xin@gmail.com>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] xfrm: policy: Only use mark as policy lookup key
Date:   Tue, 21 Apr 2020 22:31:49 +0800
Message-ID: <20200421143149.45108-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While update xfrm policy as follow:

ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
 priority 1 mark 0 mask 0x10
ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
 priority 2 mark 0 mask 0x00
ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
 priority 2 mark 0 mask 0x10

We get this warning:

WARNING: CPU: 0 PID: 4808 at net/xfrm/xfrm_policy.c:1548
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 4808 Comm: ip Not tainted 5.7.0-rc1+ #151
Call Trace:
RIP: 0010:xfrm_policy_insert_list+0x153/0x1e0
 xfrm_policy_inexact_insert+0x70/0x330
 xfrm_policy_insert+0x1df/0x250
 xfrm_add_policy+0xcc/0x190 [xfrm_user]
 xfrm_user_rcv_msg+0x1d1/0x1f0 [xfrm_user]
 netlink_rcv_skb+0x4c/0x120
 xfrm_netlink_rcv+0x32/0x40 [xfrm_user]
 netlink_unicast+0x1b3/0x270
 netlink_sendmsg+0x350/0x470
 sock_sendmsg+0x4f/0x60

Policy C and policy A has the same mark.v and mark.m, so policy A is
matched in first round lookup while updating C. However policy C and
policy B has same mark and priority, which also leads to matched. So
the WARN_ON is triggered.

xfrm policy lookup should only be matched when the found policy has the
same lookup keys (mark.v & mark.m) no matter priority.

Fixes: 7cb8a93968e3 ("xfrm: Allow inserting policies with matching mark and different priorities")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/xfrm/xfrm_policy.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 297b2fd..67d0469 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1436,13 +1436,7 @@ static void xfrm_policy_requeue(struct xfrm_policy *old,
 static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
 				   struct xfrm_policy *pol)
 {
-	u32 mark = policy->mark.v & policy->mark.m;
-
-	if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
-		return true;
-
-	if ((mark & pol->mark.m) == pol->mark.v &&
-	    policy->priority == pol->priority)
+	if ((policy->mark.v & policy->mark.m) == (pol->mark.v & pol->mark.m))
 		return true;
 
 	return false;
@@ -1628,7 +1622,7 @@ int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
 	hlist_for_each_entry(pol, chain, bydst) {
 		if (pol->type == type &&
 		    pol->if_id == if_id &&
-		    (mark & pol->mark.m) == pol->mark.v &&
+		    mark == (pol->mark.m & pol->mark.v) &&
 		    !selector_cmp(sel, &pol->selector) &&
 		    xfrm_sec_ctx_match(ctx, pol->security))
 			return pol;
@@ -1726,7 +1720,7 @@ struct xfrm_policy *xfrm_policy_byid(struct net *net, u32 mark, u32 if_id,
 	hlist_for_each_entry(pol, chain, byidx) {
 		if (pol->type == type && pol->index == id &&
 		    pol->if_id == if_id &&
-		    (mark & pol->mark.m) == pol->mark.v) {
+		    mark == (pol->mark.m & pol->mark.v)) {
 			xfrm_pol_hold(pol);
 			if (delete) {
 				*err = security_xfrm_policy_delete(
@@ -1898,7 +1892,7 @@ static int xfrm_policy_match(const struct xfrm_policy *pol,
 
 	if (pol->family != family ||
 	    pol->if_id != if_id ||
-	    (fl->flowi_mark & pol->mark.m) != pol->mark.v ||
+	    fl->flowi_mark != (pol->mark.m & pol->mark.v) ||
 	    pol->type != type)
 		return ret;
 
@@ -2177,7 +2171,7 @@ static struct xfrm_policy *xfrm_sk_policy_lookup(const struct sock *sk, int dir,
 
 		match = xfrm_selector_match(&pol->selector, fl, family);
 		if (match) {
-			if ((sk->sk_mark & pol->mark.m) != pol->mark.v ||
+			if (sk->sk_mark != (pol->mark.m & pol->mark.v) ||
 			    pol->if_id != if_id) {
 				pol = NULL;
 				goto out;
-- 
1.8.3.1


