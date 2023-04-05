Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616AA6D8AA2
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 00:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbjDEWcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 18:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbjDEWcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 18:32:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CA52736
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 15:32:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11B7263D8C
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 22:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01752C4339B;
        Wed,  5 Apr 2023 22:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680733924;
        bh=UGj43EN+SMVWBBz3lBCg9JAQEoll3Wppr1QV4v0KntU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGuiwDj0s2F0GUd6Cq00hhhUPyz+yQNXKGIQKIGOlZJrc2kgxFVv7/m5VusKotrgV
         6oYvDGpB4Ybm1M+ENwiVpueIAO72Yd1bzwLOiabC21XJGsv/9qf/lD4t7l+5HiTpUj
         DTCJm1UoTLtJHb3My9yNjP6hNHklRdyonOATr9MBvyZaiERMW2G+Rkm9sXjlWDwgup
         ZXer+yx0DezpC5mP5qSjBKEUTaL7wVmSJNohgOsmuIiGdkjmjFEoxBcJVjR7IcuzvJ
         eJ/TJsaypW4V7SBB1bfkSjob6TeSGsQbJM4XUUWTywbmWIpC0A8d7V3z7o4PmNkcoq
         Y6hHhO4JTdJZQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        herbert@gondor.apana.org.au, alexander.duyck@gmail.com,
        hkallweit1@gmail.com, andrew@lunn.ch, willemb@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 4/7] net: provide macros for commonly copied lockless queue stop/wake code
Date:   Wed,  5 Apr 2023 15:31:31 -0700
Message-Id: <20230405223134.94665-5-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405223134.94665-1-kuba@kernel.org>
References: <20230405223134.94665-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A lot of drivers follow the same scheme to stop / start queues
without introducing locks between xmit and NAPI tx completions.
I'm guessing they all copy'n'paste each other's code.
The original code dates back all the way to e1000 and Linux 2.6.19.

Smaller drivers shy away from the scheme and introduce a lock
which may cause deadlocks in netpoll.

Provide macros which encapsulate the necessary logic.

The macros do not prevent false wake ups, the extra barrier
required to close that race is not worth it. See discussion in:
https://lore.kernel.org/all/c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com/

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v3:
 - use smp_mb__after_atomic()
 - improve the comments on barriers
 - document the possibility of false wakes
 - rename netif_tx_queue_* -> netif_txq_*
v2: https://lore.kernel.org/all/20230401051221.3160913-2-kuba@kernel.org/
 - really flip the unlikely into a likely in __netif_tx_queue_maybe_wake()
 - convert if / else into pre-init of _ret
v1: https://lore.kernel.org/all/20230322233028.269410-1-kuba@kernel.org/
 - perdicate -> predicate
 - on race use start instead of wake and make a note of that
   in the doc / comment at the start
rfc: https://lore.kernel.org/all/20230311050130.115138-1-kuba@kernel.org/
---
 Documentation/networking/driver.rst |   6 ++
 include/linux/netdevice.h           |   1 +
 include/net/netdev_queues.h         | 144 ++++++++++++++++++++++++++++
 3 files changed, 151 insertions(+)
 create mode 100644 include/net/netdev_queues.h

diff --git a/Documentation/networking/driver.rst b/Documentation/networking/driver.rst
index 19c363291d04..4071f2c00f8b 100644
--- a/Documentation/networking/driver.rst
+++ b/Documentation/networking/driver.rst
@@ -104,6 +104,12 @@ Instead it must maintain the queue properly.  For example,
 	    TX_BUFFS_AVAIL(dp) > 0)
 		netif_wake_queue(dp->dev);
 
+Lockless queue stop / wake helper macros
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+.. kernel-doc:: include/net/netdev_queues.h
+   :doc: Lockless queue stopping / waking helpers.
+
 No exclusive ownership
 ----------------------
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a740be3bb911..18770d325499 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3341,6 +3341,7 @@ static inline void netif_tx_wake_all_queues(struct net_device *dev)
 
 static __always_inline void netif_tx_stop_queue(struct netdev_queue *dev_queue)
 {
+	/* Must be an atomic op see netif_txq_try_stop() */
 	set_bit(__QUEUE_STATE_DRV_XOFF, &dev_queue->state);
 }
 
diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
new file mode 100644
index 000000000000..60a9ac5439b3
--- /dev/null
+++ b/include/net/netdev_queues.h
@@ -0,0 +1,144 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_NET_QUEUES_H
+#define _LINUX_NET_QUEUES_H
+
+#include <linux/netdevice.h>
+
+/**
+ * DOC: Lockless queue stopping / waking helpers.
+ *
+ * The netif_txq_maybe_stop() and __netif_txq_completed_wake()
+ * macros are designed to safely implement stopping
+ * and waking netdev queues without full lock protection.
+ *
+ * We assume that there can be no concurrent stop attempts and no concurrent
+ * wake attempts. The try-stop should happen from the xmit handler,
+ * while wake up should be triggered from NAPI poll context.
+ * The two may run concurrently (single producer, single consumer).
+ *
+ * The try-stop side is expected to run from the xmit handler and therefore
+ * it does not reschedule Tx (netif_tx_start_queue() instead of
+ * netif_tx_wake_queue()). Uses of the ``stop`` macros outside of the xmit
+ * handler may lead to xmit queue being enabled but not run.
+ * The waking side does not have similar context restrictions.
+ *
+ * The macros guarantee that rings will not remain stopped if there's
+ * space available, but they do *not* prevent false wake ups when
+ * the ring is full! Drivers should check for ring full at the start
+ * for the xmit handler.
+ *
+ * All descriptor ring indexes (and other relevant shared state) must
+ * be updated before invoking the macros.
+ */
+
+#define netif_txq_try_stop(txq, get_desc, start_thrs)			\
+	({								\
+		int _res;						\
+									\
+		netif_tx_stop_queue(txq);				\
+		/* Producer index and stop bit must be visible		\
+		 * to consumer before we recheck.			\
+		 * Pairs with a barrier in __netif_txq_maybe_wake().	\
+		 */							\
+		smp_mb__after_atomic();					\
+									\
+		/* We need to check again in a case another		\
+		 * CPU has just made room available.			\
+		 */							\
+		_res = 0;						\
+		if (unlikely(get_desc >= start_thrs)) {			\
+			netif_tx_start_queue(txq);			\
+			_res = -1;					\
+		}							\
+		_res;							\
+	})								\
+
+/**
+ * netif_txq_maybe_stop() - locklessly stop a Tx queue, if needed
+ * @txq:	struct netdev_queue to stop/start
+ * @get_desc:	get current number of free descriptors (see requirements below!)
+ * @stop_thrs:	minimal number of available descriptors for queue to be left
+ *		enabled
+ * @start_thrs:	minimal number of descriptors to re-enable the queue, can be
+ *		equal to @stop_thrs or higher to avoid frequent waking
+ *
+ * All arguments may be evaluated multiple times, beware of side effects.
+ * @get_desc must be a formula or a function call, it must always
+ * return up-to-date information when evaluated!
+ * Expected to be used from ndo_start_xmit, see the comment on top of the file.
+ *
+ * Returns:
+ *	 0 if the queue was stopped
+ *	 1 if the queue was left enabled
+ *	-1 if the queue was re-enabled (raced with waking)
+ */
+#define netif_txq_maybe_stop(txq, get_desc, stop_thrs, start_thrs)	\
+	({								\
+		int _res;						\
+									\
+		_res = 1;						\
+		if (unlikely(get_desc < stop_thrs))			\
+			_res = netif_txq_try_stop(txq, get_desc, start_thrs); \
+		_res;							\
+	})								\
+
+
+/**
+ * __netif_txq_maybe_wake() - locklessly wake a Tx queue, if needed
+ * @txq:	struct netdev_queue to stop/start
+ * @get_desc:	get current number of free descriptors (see requirements below!)
+ * @start_thrs:	minimal number of descriptors to re-enable the queue
+ * @down_cond:	down condition, predicate indicating that the queue should
+ *		not be woken up even if descriptors are available
+ *
+ * All arguments may be evaluated multiple times.
+ * @get_desc must be a formula or a function call, it must always
+ * return up-to-date information when evaluated!
+ *
+ * Returns:
+ *	 0 if the queue was woken up
+ *	 1 if the queue was already enabled (or disabled but @down_cond is true)
+ *	-1 if the queue was left stopped
+ */
+#define __netif_txq_maybe_wake(txq, get_desc, start_thrs, down_cond)	\
+	({								\
+		int _res;						\
+									\
+		_res = -1;						\
+		if (likely(get_desc > start_thrs)) {			\
+			/* Make sure that anybody stopping the queue after \
+			 * this sees the new next_to_clean.		\
+			 */						\
+			smp_mb();					\
+			_res = 1;					\
+			if (unlikely(netif_tx_queue_stopped(txq)) &&	\
+			    !(down_cond)) {				\
+				netif_tx_wake_queue(txq);		\
+				_res = 0;				\
+			}						\
+		}							\
+		_res;							\
+	})
+
+#define netif_txq_maybe_wake(txq, get_desc, start_thrs)		\
+	__netif_txq_maybe_wake(txq, get_desc, start_thrs, false)
+
+/* subqueue variants follow */
+
+#define netif_subqueue_try_stop(dev, idx, get_desc, start_thrs)		\
+	({								\
+		struct netdev_queue *txq;				\
+									\
+		txq = netdev_get_tx_queue(dev, idx);			\
+		netif_txq_try_stop(txq, get_desc, start_thrs);		\
+	})
+
+#define netif_subqueue_maybe_stop(dev, idx, get_desc, stop_thrs, start_thrs) \
+	({								\
+		struct netdev_queue *txq;				\
+									\
+		txq = netdev_get_tx_queue(dev, idx);			\
+		netif_txq_maybe_stop(txq, get_desc, stop_thrs, start_thrs); \
+	})
+
+#endif
-- 
2.39.2

