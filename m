Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434536B584B
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 06:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjCKFBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 00:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCKFBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 00:01:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558AF13C372
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 21:01:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D364860A72
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 05:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6960C4339B;
        Sat, 11 Mar 2023 05:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678510897;
        bh=VWKlQbGeGRIrczEPlOlBgEY+BytwmLm7uq03653L1+s=;
        h=From:To:Cc:Subject:Date:From;
        b=H7Tyidazw5F1bqxIds6mEZm7znU2I2lLBwRkJfh9+9YjPhn+smUellZ9xyRQO+lBP
         t8Z1wJTCu+AHoNBZqwQ9oeJOnjF+o+47u+LmurrLVoL7r35TK1uCvQeG+YG4UGfgRn
         37oZPHGLYmjPV1TJo1VtjQU00wInnkRdrPdiPoyqrbgIQfFRUoCRIYmowzqjayKKT6
         aWDGQlBMOuwGUhSopRPqH6vibDoVSVkP6oAhYdnXtjN3q5Yafh9NFXBabxzy19vYV+
         BWstQx/S4rKxhl+mK0e+V/FZHjh3dogCFxNaZWVnEnw53qvRE0TKE6IFBs0iFLCAka
         q/62uIUjc3A5Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Cc:     alexanderduyck@fb.com, roman.gushchin@linux.dev,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 1/3] net: provide macros for commonly copied lockless queue stop/wake code
Date:   Fri, 10 Mar 2023 21:01:28 -0800
Message-Id: <20230311050130.115138-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A lot of drivers follow the same scheme to stop / start queues
without introducing locks between xmit and NAPI tx completions.
I'm guessing they all copy'n'paste each other's code.

Smaller drivers shy away from the scheme and introduce a lock
which may cause deadlocks in netpoll.

Provide macros which encapsulate the necessary logic.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/netdev_queues.h | 166 ++++++++++++++++++++++++++++++++++++
 1 file changed, 166 insertions(+)
 create mode 100644 include/net/netdev_queues.h

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
new file mode 100644
index 000000000000..2a857faf28d8
--- /dev/null
+++ b/include/net/netdev_queues.h
@@ -0,0 +1,166 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_NET_QUEUES_H
+#define _LINUX_NET_QUEUES_H
+
+#include <linux/netdevice.h>
+
+/* Lockless queue stopping / waking helpers.
+ *
+ * These macroes are designed to safely implement stopping and waking
+ * netdev queues without any lock protection. We assume that there can
+ * be no concurrent stop attempts and no concurrent wake attempts.
+ * This is usually true as stop attempts happen from the xmit handler,
+ * while wake up is triggered from NAPI poll context. The two may run
+ * concurrently but are each protected by a lock (SPSC of sorts).
+ *
+ * All descriptor ring indexes (and other relevant shared state) must
+ * be updated before invoking the macros.
+ */
+
+#define netif_tx_queue_try_stop(txq, get_desc, start_thrs)		\
+	({								\
+		int _res;						\
+									\
+		netif_tx_stop_queue(txq);				\
+									\
+		smp_mb();						\
+									\
+		/* We need to check again in a case another		\
+		 * CPU has just made room available.			\
+		 */							\
+		if (likely(get_desc < start_thrs)) {			\
+			_res = 0;					\
+		} else {						\
+			netif_tx_wake_queue(txq);			\
+			_res = -1;					\
+		}							\
+		_res;							\
+	})								\
+
+/**
+ * netif_tx_queue_maybe_stop() - locklessly stop a Tx queue, if needed
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
+ *
+ * Returns:
+ *	 0 if the queue was stopped
+ *	 1 if the queue was left enabled
+ *	-1 if the queue was re-enabled (raced with waking)
+ */
+#define netif_tx_queue_maybe_stop(txq, get_desc, stop_thrs, start_thrs)	\
+	({								\
+		int _res;						\
+									\
+		if (likely(get_desc > stop_thrs))			\
+			_res = 1;					\
+		else							\
+			_res = netif_tx_queue_try_stop(txq, get_desc,	\
+						       start_thrs);	\
+		_res;							\
+	})								\
+
+#define __netif_tx_queue_try_wake(txq, get_desc, start_thrs, down_cond) \
+	({								\
+		int _res;						\
+									\
+		/* Make sure that anybody stopping the queue after	\
+		 * this sees the new next_to_clean.			\
+		 */							\
+		smp_mb();						\
+		if (netif_tx_queue_stopped(txq) && !(down_cond)) {	\
+			netif_tx_wake_queue(txq);			\
+			_res = 0;					\
+		} else {						\
+			_res = 1;					\
+		}							\
+		_res;							\
+	})
+
+#define netif_tx_queue_try_wake(txq, get_desc, start_thrs)		\
+	__netif_tx_queue_try_wake(txq, get_desc, start_thrs, false)
+
+/**
+ * __netif_tx_queue_maybe_wake() - locklessly wake a Tx queue, if needed
+ * @txq:	struct netdev_queue to stop/start
+ * @get_desc:	get current number of free descriptors (see requirements below!)
+ * @start_thrs:	minimal number of descriptors to re-enable the queue
+ * @down_cond:	down condition, perdicate indicating that the queue should
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
+#define __netif_tx_queue_maybe_wake(txq, get_desc, start_thrs, down_cond) \
+	({								\
+		int _res;						\
+									\
+		if (likely(get_desc < start_thrs))			\
+			_res = -1;					\
+		else							\
+			_res = __netif_tx_queue_try_wake(txq, get_desc,	\
+							 start_thrs,	\
+							 down_cond);	\
+		_res;							\
+	})
+
+#define netif_tx_queue_maybe_wake(txq, get_desc, start_thrs)		\
+	__netif_tx_queue_maybe_wake(txq, get_desc, start_thrs, false)
+
+/* subqueue variants follow */
+
+#define netif_subqueue_try_stop(dev, idx, get_desc, start_thrs)		\
+	({								\
+		struct netdev_queue *txq;				\
+									\
+		txq = netdev_get_tx_queue(dev, idx);			\
+		netif_tx_queue_try_stop(txq, get_desc, start_thrs);	\
+	})
+
+#define netif_subqueue_maybe_stop(dev, idx, get_desc, stop_thrs, start_thrs) \
+	({								\
+		struct netdev_queue *txq;				\
+									\
+		txq = netdev_get_tx_queue(dev, idx);			\
+		netif_tx_queue_maybe_stop(txq, get_desc,		\
+					  stop_thrs, start_thrs);	\
+	})
+
+#define __netif_subqueue_try_wake(dev, idx, get_desc, start_thrs, down_cond) \
+	({								\
+		struct netdev_queue *txq;				\
+									\
+		txq = netdev_get_tx_queue(dev, idx);			\
+		__netif_tx_queue_try_wake(txq, get_desc,		\
+					  start_thrs, down_cond);	\
+	})
+
+#define netif_subqueue_try_wake(dev, idx, get_desc, start_thrs)		\
+	__netif_subqueue_try_wake(dev, idx, get_desc, start_thrs, false)
+
+#define __netif_subqueue_maybe_wake(dev, idx, get_desc, start_thrs, down_cond) \
+	({								\
+		struct netdev_queue *txq;				\
+									\
+		txq = netdev_get_tx_queue(dev, idx);			\
+		__netif_tx_queue_maybe_wake(txq, get_desc,		\
+					    start_thrs, down_cond);	\
+	})
+
+#define netif_subqueue_maybe_wake(dev, idx, get_desc, start_thrs)	\
+	__netif_subqueue_maybe_wake(dev, idx, get_desc, start_thrs, false)
+
+#endif
-- 
2.39.2

