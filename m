Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376F82ED514
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbhAGRG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:06:58 -0500
Received: from mga14.intel.com ([192.55.52.115]:53942 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728842AbhAGRG5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 12:06:57 -0500
IronPort-SDR: DnvhWi+X02reVUSzM3wOZLhcsvFxU0UQvmn906HwO41LRJWFXezCCaIW9sP3RexuTeyd77cDt7
 5rzMMvE9uMdA==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="176680942"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="176680942"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 09:06:16 -0800
IronPort-SDR: RRC1HiPMLzjBEL+F5YAeeyvNo7d36dV3zWfN76XQ4MwUyp4cVX4e0QU9Ali0Qhsr7X4NY9dQvR
 3YKDfnwpx30w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="422643882"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga001.jf.intel.com with ESMTP; 07 Jan 2021 09:06:14 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [PATCH 09/18] net: iosm: bottom half
Date:   Thu,  7 Jan 2021 22:35:14 +0530
Message-Id: <20210107170523.26531-10-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210107170523.26531-1-m.chetan.kumar@intel.com>
References: <20210107170523.26531-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Bottom half(tasklet) for IRQ and task processing.
2) Tasks are processed asynchronous and synchronously.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_task_queue.c | 247 ++++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_task_queue.h |  46 ++++++
 2 files changed, 293 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_task_queue.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_task_queue.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_task_queue.c b/drivers/net/wwan/iosm/iosm_ipc_task_queue.c
new file mode 100644
index 000000000000..0820f7fdbd1f
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_task_queue.c
@@ -0,0 +1,247 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#include <linux/slab.h>
+
+#include "iosm_ipc_task_queue.h"
+
+/* Number of available element for the input message queue of the IPC
+ * ipc_task.
+ */
+#define IPC_THREAD_QUEUE_SIZE 256
+
+/**
+ * struct ipc_task_queue_args - Struct for Task queue elements
+ * @instance:	Instance pointer for function to be called in tasklet context
+ * @msg:	Message argument for tasklet function. (optional, can be NULL)
+ * @completion:	OS object used to wait for the tasklet function to finish for
+ *		synchronous calls
+ * @func:	Function to be called in tasklet (tl) context
+ * @arg:	Generic integer argument for tasklet function (optional)
+ * @size:	Message size argument for tasklet function (optional)
+ * @response:	Return code of tasklet function for synchronous calls
+ * @is_copy:	Is true if msg contains a pointer to a copy of the original msg
+ *		for async. calls that needs to be freed once the tasklet returns
+ */
+struct ipc_task_queue_args {
+	void *instance;
+	void *msg;
+	struct completion *completion;
+	int (*func)(struct iosm_imem *ipc_imem, int arg, void *msg,
+		    size_t size);
+	int arg;
+	size_t size;
+	int response;
+	u8 is_copy : 1;
+};
+
+/**
+ * struct ipc_task_queue - Struct for Task queue
+ * @dev:	pointer to device structure
+ * @q_lock:	Protect the message queue of the ipc ipc_task
+ * @args:	Message queue of the IPC ipc_task
+ * @q_rpos:	First queue element to process.
+ * @q_wpos:	First free element of the input queue.
+ */
+struct ipc_task_queue {
+	struct device *dev;
+	spinlock_t q_lock; /* for atomic operation on queue */
+	struct ipc_task_queue_args args[IPC_THREAD_QUEUE_SIZE];
+	unsigned int q_rpos;
+	unsigned int q_wpos;
+};
+
+/* Actual tasklet function, will be called whenever tasklet is scheduled.
+ * Calls event handler involves callback for each element in the message queue
+ */
+static void ipc_task_queue_handler(unsigned long data)
+{
+	struct ipc_task_queue *ipc_task = (struct ipc_task_queue *)data;
+	unsigned int q_rpos = ipc_task->q_rpos;
+
+	/* Loop over the input queue contents. */
+	while (q_rpos != ipc_task->q_wpos) {
+		/* Get the current first queue element. */
+		struct ipc_task_queue_args *args = &ipc_task->args[q_rpos];
+
+		/* Process the input message. */
+		if (args->func)
+			args->response = args->func(args->instance, args->arg,
+						    args->msg, args->size);
+
+		/* Signal completion for synchronous calls */
+		if (args->completion)
+			complete(args->completion);
+
+		/* Free message if copy was allocated. */
+		if (args->is_copy)
+			kfree(args->msg);
+
+		/* Set invalid queue element. Technically
+		 * spin_lock_irqsave is not required here as
+		 * the array element has been processed already
+		 * so we can assume that immediately after processing
+		 * ipc_task element, queue will not rotate again to
+		 * ipc_task same element within such short time.
+		 */
+		args->completion = NULL;
+		args->func = NULL;
+		args->msg = NULL;
+		args->size = 0;
+		args->is_copy = false;
+
+		/* calculate the new read ptr and update the volatile read
+		 * ptr
+		 */
+		q_rpos = (q_rpos + 1) % IPC_THREAD_QUEUE_SIZE;
+		ipc_task->q_rpos = q_rpos;
+	}
+}
+
+/* Free memory alloc and trigger completions left in the queue during dealloc */
+static void ipc_task_queue_cleanup(struct ipc_task_queue *ipc_task)
+{
+	unsigned int q_rpos = ipc_task->q_rpos;
+
+	while (q_rpos != ipc_task->q_wpos) {
+		struct ipc_task_queue_args *args = &ipc_task->args[q_rpos];
+
+		if (args->completion)
+			complete(args->completion);
+
+		if (args->is_copy)
+			kfree(args->msg);
+
+		q_rpos = (q_rpos + 1) % IPC_THREAD_QUEUE_SIZE;
+		ipc_task->q_rpos = q_rpos;
+	}
+}
+
+/* Add a message to the queue and trigger the ipc_task. */
+static int
+ipc_task_queue_add_task(struct tasklet_struct *ipc_tasklet,
+			struct ipc_task_queue *ipc_task,
+			int arg, void *argmnt,
+			int (*func)(struct iosm_imem *ipc_imem, int arg,
+				    void *msg, size_t size),
+			void *instance, size_t size, bool is_copy, bool wait)
+{
+	struct completion completion;
+	unsigned int pos, nextpos;
+	unsigned long flags;
+	int result = -1;
+
+	init_completion(&completion);
+
+	/* tasklet send may be called from both interrupt or thread
+	 * context, therefore protect queue operation by spinlock
+	 */
+	spin_lock_irqsave(&ipc_task->q_lock, flags);
+
+	pos = ipc_task->q_wpos;
+	nextpos = (pos + 1) % IPC_THREAD_QUEUE_SIZE;
+
+	/* Get next queue position. */
+	if (nextpos != ipc_task->q_rpos) {
+		/* Get the reference to the queue element and save the passed
+		 * values.
+		 */
+		ipc_task->args[pos].arg = arg;
+		ipc_task->args[pos].msg = argmnt;
+		ipc_task->args[pos].func = func;
+		ipc_task->args[pos].instance = instance;
+		ipc_task->args[pos].size = size;
+		ipc_task->args[pos].is_copy = is_copy;
+		ipc_task->args[pos].completion = wait ? &completion : NULL;
+		ipc_task->args[pos].response = -1;
+
+		/* apply write barrier so that ipc_task->q_rpos elements
+		 * are updated before ipc_task->q_wpos is being updated.
+		 */
+		smp_wmb();
+
+		/* Update the status of the free queue space. */
+		ipc_task->q_wpos = nextpos;
+		result = 0;
+	}
+
+	spin_unlock_irqrestore(&ipc_task->q_lock, flags);
+
+	if (result == 0) {
+		tasklet_schedule(ipc_tasklet);
+
+		if (wait) {
+			wait_for_completion(&completion);
+			result = ipc_task->args[pos].response;
+		}
+	} else {
+		dev_err(ipc_task->dev, "queue is full");
+	}
+
+	return result;
+}
+
+int ipc_task_queue_send_task(struct iosm_imem *imem,
+			     int (*func)(struct iosm_imem *ipc_imem, int arg,
+					 void *msg, size_t size),
+			     int arg, void *msg, size_t size, bool wait)
+{
+	struct tasklet_struct *ipc_tasklet = imem->ipc_tasklet;
+	struct ipc_task_queue *ipc_task = imem->ipc_task;
+	bool is_copy = false;
+	void *copy = msg;
+
+	if (size > 0) {
+		copy = kmemdup(msg, size, GFP_ATOMIC);
+		if (!copy)
+			return -ENOMEM;
+
+		is_copy = true;
+	}
+
+	if (ipc_task_queue_add_task(ipc_tasklet, ipc_task, arg, copy, func,
+				    imem, size, is_copy, wait) < 0) {
+		dev_err(ipc_task->dev,
+			"add task failed for %ps %d, %p, %zu, %d", func, arg,
+			copy, size, is_copy);
+		if (is_copy)
+			kfree(copy);
+		return -1;
+	}
+
+	return 0;
+}
+
+struct ipc_task_queue *ipc_task_queue_init(struct tasklet_struct *ipc_tasklet,
+					   struct device *dev)
+{
+	struct ipc_task_queue *ipc_task = kzalloc(sizeof(*ipc_task),
+						  GFP_KERNEL);
+
+	if (!ipc_task)
+		return NULL;
+
+	ipc_task->dev = dev;
+
+	/* Initialize the spinlock needed to protect the message queue of the
+	 * ipc_task
+	 */
+	spin_lock_init(&ipc_task->q_lock);
+
+	tasklet_init(ipc_tasklet, ipc_task_queue_handler,
+		     (unsigned long)ipc_task);
+
+	return ipc_task;
+}
+
+void ipc_task_queue_deinit(struct ipc_task_queue *ipc_task)
+{
+	/* This will free/complete any outstanding messages,
+	 * without calling the actual handler
+	 */
+	ipc_task_queue_cleanup(ipc_task);
+
+	kfree(ipc_task);
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_task_queue.h b/drivers/net/wwan/iosm/iosm_ipc_task_queue.h
new file mode 100644
index 000000000000..5591213bcb6d
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_task_queue.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_TASK_QUEUE_H
+#define IOSM_IPC_TASK_QUEUE_H
+
+#include <linux/interrupt.h>
+
+#include "iosm_ipc_imem.h"
+
+/**
+ * ipc_task_queue_init - Allocate a tasklet
+ * @ipc_tasklet:	Pointer to tasklet_struct
+ * @dev:		Pointer to device structure
+ *
+ * Returns: Pointer to allocated ipc_task data-struct or NULL on failure.
+ */
+struct ipc_task_queue *ipc_task_queue_init(struct tasklet_struct *ipc_tasklet,
+					   struct device *dev);
+
+/**
+ * ipc_task_queue_deinit - Free a tasklet, invalidating its pointer.
+ * @ipc_task:	Pointer to ipc_task instance
+ */
+void ipc_task_queue_deinit(struct ipc_task_queue *ipc_task);
+
+/**
+ * ipc_task_queue_send_task - Synchronously/Asynchronously call a function in
+ *			      tasklet context.
+ * @imem:		Pointer to iosm_imem struct
+ * @func:		Function to be called in tasklet context
+ * @arg:		Integer argument for func
+ * @msg:		Message pointer argument for func
+ * @size:		Size argument for func
+ * @wait:		if true wait for result
+ *
+ * Returns: Result value returned by func or -1 if func could not be called.
+ */
+int ipc_task_queue_send_task(struct iosm_imem *imem,
+			     int (*func)(struct iosm_imem *ipc_imem, int arg,
+					 void *msg, size_t size),
+			     int arg, void *msg, size_t size, bool wait);
+
+#endif
-- 
2.12.3

