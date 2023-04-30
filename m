Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245C06F29C2
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 19:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjD3RHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 13:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjD3RHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 13:07:14 -0400
Received: from synguard (unknown [212.29.212.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B982706;
        Sun, 30 Apr 2023 10:07:10 -0700 (PDT)
Received: from T14.siklu.local (T14.siklu.local [192.168.42.187])
        by synguard (Postfix) with ESMTP id BEFAA4E4CE;
        Sun, 30 Apr 2023 20:07:06 +0300 (IDT)
From:   Shmuel Hazan <shmuel.h@siklu.com>
To:     Russell King <linux@armlinux.org.uk>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Shmuel Hazan <shmuel.h@siklu.com>
Subject: [PATCH v4 1/3] net: mvpp2: tai: add refcount for ptp worker
Date:   Sun, 30 Apr 2023 20:06:54 +0300
Message-Id: <20230430170656.137549-2-shmuel.h@siklu.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230430170656.137549-1-shmuel.h@siklu.com>
References: <20230430170656.137549-1-shmuel.h@siklu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
        HELO_NO_DOMAIN,RDNS_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some configurations, a single TAI can be responsible for multiple
mvpp2 interfaces. However, the mvpp2 driver will call mvpp22_tai_stop
and mvpp22_tai_start per interface RX timestamp disable/enable.

As a result, disabling timestamping for one interface would stop the
worker and corrupt the other interface's RX timestamps.

This commit solves the issue by introducing a simpler ref count for each
TAI instance.

Due to the ref count, we need now to lock tai->refcount_lock before
doing anything. As a result, we can't call mvpp22_tai_do_aux_work as it
will cause a deadlock. Therefore, we will just schedule the worker to
start immediately.

Fixes: ce3497e2072e ("net: mvpp2: ptp: add support for receive timestamping")
Signed-off-by: Shmuel Hazan <shmuel.h@siklu.com>
---
v1 -> v2: lock tai->lock before touching poll_worker_refcount.
v2 -> v3: no change
v3 -> v4: added additional lock for poll_worker_refcount due to
	  a possible deadlock.
---
 .../net/ethernet/marvell/mvpp2/mvpp2_tai.c    | 28 +++++++++++++++++--
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
index 95862aff49f1..d8ce8bdae046 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
@@ -32,6 +32,7 @@
  *
  * Consequently, we support none of these.
  */
+#include "linux/spinlock.h"
 #include <linux/io.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/slab.h>
@@ -61,6 +62,8 @@ struct mvpp2_tai {
 	u64 period;		// nanosecond period in 32.32 fixed point
 	/* This timestamp is updated every two seconds */
 	struct timespec64 stamp;
+	spinlock_t refcount_lock; /* Protects the poll_worker_refcount variable */
+	u16 poll_worker_refcount;
 };
 
 static void mvpp2_tai_modify(void __iomem *reg, u32 mask, u32 set)
@@ -370,16 +373,34 @@ void mvpp22_tai_tstamp(struct mvpp2_tai *tai, u32 tstamp,
 
 void mvpp22_tai_start(struct mvpp2_tai *tai)
 {
-	long delay;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tai->refcount_lock, flags);
 
-	delay = mvpp22_tai_aux_work(&tai->caps);
+	tai->poll_worker_refcount++;
+	if (tai->poll_worker_refcount > 1)
+		goto out_unlock;
 
-	ptp_schedule_worker(tai->ptp_clock, delay);
+	ptp_schedule_worker(tai->ptp_clock, 0);
+
+out_unlock:
+	spin_unlock_irqrestore(&tai->refcount_lock, flags);
 }
 
 void mvpp22_tai_stop(struct mvpp2_tai *tai)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&tai->refcount_lock, flags);
+
+	tai->poll_worker_refcount--;
+	if (tai->poll_worker_refcount)
+		goto unlock_out;
+
 	ptp_cancel_worker_sync(tai->ptp_clock);
+
+unlock_out:
+	spin_unlock_irqrestore(&tai->refcount_lock, flags);
 }
 
 static void mvpp22_tai_remove(void *priv)
@@ -400,6 +421,7 @@ int mvpp22_tai_probe(struct device *dev, struct mvpp2 *priv)
 		return -ENOMEM;
 
 	spin_lock_init(&tai->lock);
+	spin_lock_init(&tai->refcount_lock);
 
 	tai->base = priv->iface_base;
 
-- 
2.40.1

