Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DC338B106
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 16:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243520AbhETOI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 10:08:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:5047 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237114AbhETOHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 10:07:40 -0400
IronPort-SDR: xKmV4SGsBWMdJdcKzSp7NuzWs9NUsKlInHGY3u9tx4o3beq/IIyYi/qOQa6Q/wMrnIvF3OCOTO
 TWyikDbJzYag==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="198144614"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="198144614"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 07:02:50 -0700
IronPort-SDR: gebPyHwzbtJrhO5hWwEvK2q6/sbGgLubgRhG2fE1FElfDAbvhqzX4n1N8wE7G+l3NpqbJOZNc/
 0E7xXTHIwCwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="631407567"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by fmsmga005.fm.intel.com with ESMTP; 20 May 2021 07:02:48 -0700
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V3 08/16] net: iosm: bottom half
Date:   Thu, 20 May 2021 19:31:50 +0530
Message-Id: <20210520140158.10132-9-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210520140158.10132-1-m.chetan.kumar@intel.com>
References: <20210520140158.10132-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Bottom half(tasklet) for IRQ and task processing.
2) Tasks are processed asynchronous and synchronously.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
v3: no change.
v2:
* Moved task queue struct to header file.
* Streamline multiple returns using goto.
---
 drivers/net/wwan/iosm/iosm_ipc_task_queue.c | 202 ++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_task_queue.h |  97 ++++++++++
 2 files changed, 299 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_task_queue.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_task_queue.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_task_queue.c b/drivers/net/wwan/iosm/iosm_ipc_task_queue.c
new file mode 100644
index 000000000000..852a99166144
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_task_queue.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020-21 Intel Corporation.
+ */
+
+#include "iosm_ipc_imem.h"
+#include "iosm_ipc_task_queue.h"
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
+			args->response = args->func(args->ipc_imem, args->arg,
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
+ipc_task_queue_add_task(struct iosm_imem *ipc_imem,
+			int arg, void *msg,
+			int (*func)(struct iosm_imem *ipc_imem, int arg,
+				    void *msg, size_t size),
+			size_t size, bool is_copy, bool wait)
+{
+	struct tasklet_struct *ipc_tasklet = ipc_imem->ipc_task->ipc_tasklet;
+	struct ipc_task_queue *ipc_task = &ipc_imem->ipc_task->ipc_queue;
+	struct completion completion;
+	unsigned int pos, nextpos;
+	unsigned long flags;
+	int result = -EIO;
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
+		ipc_task->args[pos].msg = msg;
+		ipc_task->args[pos].func = func;
+		ipc_task->args[pos].ipc_imem = ipc_imem;
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
+		dev_err(ipc_imem->ipc_task->dev, "queue is full");
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
+	bool is_copy = false;
+	void *copy = msg;
+	int ret = -ENOMEM;
+
+	if (size > 0) {
+		copy = kmemdup(msg, size, GFP_ATOMIC);
+		if (!copy)
+			goto out;
+
+		is_copy = true;
+	}
+
+	ret = ipc_task_queue_add_task(imem, arg, copy, func,
+				      size, is_copy, wait);
+	if (ret < 0) {
+		dev_err(imem->ipc_task->dev,
+			"add task failed for %ps %d, %p, %zu, %d", func, arg,
+			copy, size, is_copy);
+		if (is_copy)
+			kfree(copy);
+		goto out;
+	}
+
+	ret = 0;
+out:
+	return ret;
+}
+
+int ipc_task_init(struct ipc_task *ipc_task)
+{
+	struct ipc_task_queue *ipc_queue = &ipc_task->ipc_queue;
+
+	ipc_task->ipc_tasklet = kzalloc(sizeof(*ipc_task->ipc_tasklet),
+					GFP_KERNEL);
+
+	if (!ipc_task->ipc_tasklet)
+		return -ENOMEM;
+
+	/* Initialize the spinlock needed to protect the message queue of the
+	 * ipc_task
+	 */
+	spin_lock_init(&ipc_queue->q_lock);
+
+	tasklet_init(ipc_task->ipc_tasklet, ipc_task_queue_handler,
+		     (unsigned long)ipc_queue);
+	return 0;
+}
+
+void ipc_task_deinit(struct ipc_task *ipc_task)
+{
+	tasklet_kill(ipc_task->ipc_tasklet);
+
+	kfree(ipc_task->ipc_tasklet);
+	/* This will free/complete any outstanding messages,
+	 * without calling the actual handler
+	 */
+	ipc_task_queue_cleanup(&ipc_task->ipc_queue);
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_task_queue.h b/drivers/net/wwan/iosm/iosm_ipc_task_queue.h
new file mode 100644
index 000000000000..df6e9cd925a9
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_task_queue.h
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020-21 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_TASK_QUEUE_H
+#define IOSM_IPC_TASK_QUEUE_H
+
+/* Number of available element for the input message queue of the IPC
+ * ipc_task
+ */
+#define IPC_THREAD_QUEUE_SIZE 256
+
+/**
+ * struct ipc_task_queue_args - Struct for Task queue elements
+ * @ipc_imem:   Pointer to struct iosm_imem
+ * @msg:        Message argument for tasklet function. (optional, can be NULL)
+ * @completion: OS object used to wait for the tasklet function to finish for
+ *              synchronous calls
+ * @func:       Function to be called in tasklet (tl) context
+ * @arg:        Generic integer argument for tasklet function (optional)
+ * @size:       Message size argument for tasklet function (optional)
+ * @response:   Return code of tasklet function for synchronous calls
+ * @is_copy:    Is true if msg contains a pointer to a copy of the original msg
+ *              for async. calls that needs to be freed once the tasklet returns
+ */
+struct ipc_task_queue_args {
+	struct iosm_imem *ipc_imem;
+	void *msg;
+	struct completion *completion;
+	int (*func)(struct iosm_imem *ipc_imem, int arg, void *msg,
+		    size_t size);
+	int arg;
+	size_t size;
+	int response;
+	u8 is_copy:1;
+};
+
+/**
+ * struct ipc_task_queue - Struct for Task queue
+ * @q_lock:     Protect the message queue of the ipc ipc_task
+ * @args:       Message queue of the IPC ipc_task
+ * @q_rpos:     First queue element to process.
+ * @q_wpos:     First free element of the input queue.
+ */
+struct ipc_task_queue {
+	spinlock_t q_lock; /* for atomic operation on queue */
+	struct ipc_task_queue_args args[IPC_THREAD_QUEUE_SIZE];
+	unsigned int q_rpos;
+	unsigned int q_wpos;
+};
+
+/**
+ * struct ipc_task - Struct for Task
+ * @dev:	 Pointer to device structure
+ * @ipc_tasklet: Tasklet for serialized work offload
+ *		 from interrupts and OS callbacks
+ * @ipc_queue:	 Task for entry into ipc task queue
+ */
+struct ipc_task {
+	struct device *dev;
+	struct tasklet_struct *ipc_tasklet;
+	struct ipc_task_queue ipc_queue;
+};
+
+/**
+ * ipc_task_init - Allocate a tasklet
+ * @ipc_task:	Pointer to ipc_task structure
+ * Returns: 0 on success and failure value on error.
+ */
+int ipc_task_init(struct ipc_task *ipc_task);
+
+/**
+ * ipc_task_deinit - Free a tasklet, invalidating its pointer.
+ * @ipc_task:	Pointer to ipc_task structure
+ */
+void ipc_task_deinit(struct ipc_task *ipc_task);
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
+ * Returns: Result value returned by func or failure value if func could not
+ *	    be called.
+ */
+int ipc_task_queue_send_task(struct iosm_imem *imem,
+			     int (*func)(struct iosm_imem *ipc_imem, int arg,
+					 void *msg, size_t size),
+			     int arg, void *msg, size_t size, bool wait);
+
+#endif
-- 
2.25.1

