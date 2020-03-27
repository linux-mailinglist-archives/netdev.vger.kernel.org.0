Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4563B19529F
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgC0IKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:10:21 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:54992 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgC0IKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 04:10:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 77C2020501;
        Fri, 27 Mar 2020 09:10:18 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Waw8fO_v1M-W; Fri, 27 Mar 2020 09:10:16 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8C0C720536;
        Fri, 27 Mar 2020 09:10:14 +0100 (CET)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 MAIL-ESSEN-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 27 Mar 2020 09:10:14 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 27 Mar
 2020 09:10:13 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 33B2F318037B;
 Fri, 27 Mar 2020 09:10:13 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 8/8] xfrm: policy: Fix doulbe free in xfrm_policy_timer
Date:   Fri, 27 Mar 2020 09:10:07 +0100
Message-ID: <20200327081007.1185-9-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327081007.1185-1-steffen.klassert@secunet.com>
References: <20200327081007.1185-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

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
Acked-by: Timo Teräs <timo.teras@iki.fi>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_policy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 297d1eb79e5c..96a8c452b63e 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -434,7 +434,9 @@ EXPORT_SYMBOL(xfrm_policy_destroy);
 
 static void xfrm_policy_kill(struct xfrm_policy *policy)
 {
+	write_lock_bh(&policy->lock);
 	policy->walk.dead = 1;
+	write_unlock_bh(&policy->lock);
 
 	atomic_inc(&policy->genid);
 
-- 
2.17.1

