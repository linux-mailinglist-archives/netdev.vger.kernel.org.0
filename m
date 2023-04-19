Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923BC6E7E27
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbjDSPYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbjDSPYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:24:08 -0400
Received: from synguard (unknown [212.29.212.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0BC901D;
        Wed, 19 Apr 2023 08:23:31 -0700 (PDT)
Received: from dali.siklu.local (dali.siklu.local [192.168.42.30])
        by synguard (Postfix) with ESMTP id 571014DFC6;
        Wed, 19 Apr 2023 18:14:59 +0300 (IDT)
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
Subject: [PATCH v3 1/3] net: mvpp2: tai: add refcount for ptp worker
Date:   Wed, 19 Apr 2023 18:14:55 +0300
Message-Id: <20230419151457.22411-2-shmuel.h@siklu.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230419151457.22411-1-shmuel.h@siklu.com>
References: <20230419151457.22411-1-shmuel.h@siklu.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
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

Due to the ref count, we need now to lock tai->lock before doing
anything, as a result, we can't update the current ts using
mvpp22_tai_gettimex64 as it will cause a deadlock. Therefore, we will
just schedule the worker to start immediately.

Fixes: ce3497e2072e ("net: mvpp2: ptp: add support for receive timestamping")
Signed-off-by: Shmuel Hazan <shmuel.h@siklu.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_tai.c    | 30 ++++++++++++++++---
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
index 95862aff49f1..2e3d43b1bac1 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
@@ -61,6 +61,7 @@ struct mvpp2_tai {
 	u64 period;		// nanosecond period in 32.32 fixed point
 	/* This timestamp is updated every two seconds */
 	struct timespec64 stamp;
+	u16 poll_worker_refcount;
 };
 
 static void mvpp2_tai_modify(void __iomem *reg, u32 mask, u32 set)
@@ -368,18 +369,39 @@ void mvpp22_tai_tstamp(struct mvpp2_tai *tai, u32 tstamp,
 	hwtstamp->hwtstamp = timespec64_to_ktime(ts);
 }
 
+static void mvpp22_tai_start_unlocked(struct mvpp2_tai *tai)
+{
+	tai->poll_worker_refcount++;
+	if (tai->poll_worker_refcount > 1)
+		return;
+
+	ptp_schedule_worker(tai->ptp_clock, 0);
+}
+
 void mvpp22_tai_start(struct mvpp2_tai *tai)
 {
-	long delay;
+	unsigned long flags;
 
-	delay = mvpp22_tai_aux_work(&tai->caps);
+	spin_lock_irqsave(&tai->lock, flags);
+	mvpp22_tai_start_unlocked(tai);
+	spin_unlock_irqrestore(&tai->lock, flags);
+}
 
-	ptp_schedule_worker(tai->ptp_clock, delay);
+static void mvpp22_tai_stop_unlocked(struct mvpp2_tai *tai)
+{
+	tai->poll_worker_refcount--;
+	if (tai->poll_worker_refcount)
+		return;
+	ptp_cancel_worker_sync(tai->ptp_clock);
 }
 
 void mvpp22_tai_stop(struct mvpp2_tai *tai)
 {
-	ptp_cancel_worker_sync(tai->ptp_clock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&tai->lock, flags);
+	mvpp22_tai_stop_unlocked(tai);
+	spin_unlock_irqrestore(&tai->lock, flags);
 }
 
 static void mvpp22_tai_remove(void *priv)
-- 
2.40.0

