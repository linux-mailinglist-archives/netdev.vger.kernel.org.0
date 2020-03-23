Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAA618EDB4
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 02:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgCWBpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 21:45:09 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12174 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726954AbgCWBpJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 21:45:09 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E2157334D816B813E5A9;
        Mon, 23 Mar 2020 09:45:03 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Mon, 23 Mar 2020
 09:44:57 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>, <timo.teras@iki.fi>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2] xfrm: policy: Fix doulbe free in xfrm_policy_timer
Date:   Mon, 23 Mar 2020 09:41:55 +0800
Message-ID: <20200323014155.56376-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20200318034839.57996-1-yuehaibing@huawei.com>
References: <20200318034839.57996-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After xfrm_add_policy add a policy, its ref is 2, then

                             xfrm_policy_timer
                               read_lock
                               xp->walk.dead is 0
                               ....
                               mod_timer()
xfrm_policy_kill
  policy->walk.dead = 1
  ....
  del_timer(&policy->timer)
    xfrm_pol_put //ref is 1
  xfrm_pol_put  //ref is 0
    xfrm_policy_destroy
      call_rcu
                                 xfrm_pol_hold //ref is 1
                               read_unlock
                               xfrm_pol_put //ref is 0
                                 xfrm_policy_destroy
                                  call_rcu

xfrm_policy_destroy is called twice, which may leads to
double free.

Call Trace:
RIP: 0010:refcount_warn_saturate+0x161/0x210
...
 xfrm_policy_timer+0x522/0x600
 call_timer_fn+0x1b3/0x5e0
 ? __xfrm_decode_session+0x2990/0x2990
 ? msleep+0xb0/0xb0
 ? _raw_spin_unlock_irq+0x24/0x40
 ? __xfrm_decode_session+0x2990/0x2990
 ? __xfrm_decode_session+0x2990/0x2990
 run_timer_softirq+0x5c5/0x10e0

Fix this by use write_lock_bh in xfrm_policy_kill.

Fixes: ea2dea9dacc2 ("xfrm: remove policy lock when accessing policy->walk.dead")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2:  Fix typo 'write_lock_bh'--> 'write_unlock_bh' while unlocking
---
 net/xfrm/xfrm_policy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index dbda08ec566e..ae0689174bbf 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -434,6 +434,7 @@ EXPORT_SYMBOL(xfrm_policy_destroy);
 
 static void xfrm_policy_kill(struct xfrm_policy *policy)
 {
+	write_lock_bh(&policy->lock);
 	policy->walk.dead = 1;
 
 	atomic_inc(&policy->genid);
@@ -445,6 +446,7 @@ static void xfrm_policy_kill(struct xfrm_policy *policy)
 	if (del_timer(&policy->timer))
 		xfrm_pol_put(policy);
 
+	write_unlock_bh(&policy->lock);
 	xfrm_pol_put(policy);
 }
 
-- 
2.17.1


