Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7558B428942
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 10:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbhJKJAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 05:00:12 -0400
Received: from out0.migadu.com ([94.23.1.103]:63928 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235301AbhJKJAM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 05:00:12 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1633942689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NLXZ7qe2WI7jiN6OL9JMvA8o04nmr0kltNqfWaB2bOM=;
        b=QbGMZ8sF2pnEozrhe6cnvISmp2a9lssITo8OIczbEKFpTFn8D9Og8UYNxrzXA0hBORq8t2
        guTeDVdHA/Wt6+XcjcozyHnjZV8Z8dxVlXvImXXl9YJ+BZpwnrrLdasPXulajPDFAclglP
        YPhFzsma2ot5bGp7TZptZ5ZYrtMf8w0=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] netpoll: Fix carrier_timeout for msleep()
Date:   Mon, 11 Oct 2021 16:57:53 +0800
Message-Id: <20211011085753.20706-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should be sleep carrier_timeout seconds rather than 4 seconds if
carrier_timeout has been modified.
Add start variable, hence atleast and atmost use the same jiffies, and
use msecs_to_jiffies() and MSEC_PER_SEC match with jiffies.
At the same time, msleep() is not for 1ms - 20ms, use usleep_range()
instead, see Documentation/timers/timers-howto.rst.

Fixes: bff38771e106 ("netpoll: Introduce netpoll_carrier_timeout kernel option")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/netpoll.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index edfc0f8011f8..88e4ff3b9e95 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -682,7 +682,7 @@ int netpoll_setup(struct netpoll *np)
 	}
 
 	if (!netif_running(ndev)) {
-		unsigned long atmost, atleast;
+		unsigned long atmost, atleast, start;
 
 		np_info(np, "device %s not up yet, forcing it\n", np->dev_name);
 
@@ -694,14 +694,15 @@ int netpoll_setup(struct netpoll *np)
 		}
 
 		rtnl_unlock();
-		atleast = jiffies + HZ/10;
-		atmost = jiffies + carrier_timeout * HZ;
+		start = jiffies;
+		atleast = start + msecs_to_jiffies(MSEC_PER_SEC / 10);
+		atmost = start + msecs_to_jiffies(carrier_timeout * MSEC_PER_SEC);
 		while (!netif_carrier_ok(ndev)) {
 			if (time_after(jiffies, atmost)) {
 				np_notice(np, "timeout waiting for carrier\n");
 				break;
 			}
-			msleep(1);
+			usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
 		}
 
 		/* If carrier appears to come up instantly, we don't
@@ -710,8 +711,9 @@ int netpoll_setup(struct netpoll *np)
 		 */
 
 		if (time_before(jiffies, atleast)) {
-			np_notice(np, "carrier detect appears untrustworthy, waiting 4 seconds\n");
-			msleep(4000);
+			np_notice(np, "carrier detect appears untrustworthy, waiting %d seconds\n",
+				  carrier_timeout);
+			msleep(carrier_timeout * MSEC_PER_SEC);
 		}
 		rtnl_lock();
 	}
-- 
2.32.0

