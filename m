Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49DD15B131
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 20:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgBLTgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 14:36:09 -0500
Received: from alln-iport-8.cisco.com ([173.37.142.95]:48852 "EHLO
        alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbgBLTgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 14:36:09 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2020 14:36:08 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4752; q=dns/txt; s=iport;
  t=1581536168; x=1582745768;
  h=from:to:cc:subject:date:message-id;
  bh=9zcQWBaPNM6CcS8hmrmnBCPaodg8GgYBKqA4jri8k5E=;
  b=b7QdyvPAtMJGJPQpWCG5p4XYYP2mVoXC8yQXvvVHYU1T49zX4JdYuPjG
   0etczV/rtitz1hM+eB4ISSKMMS/gRBFSUcRtEeKKxNYo2Haj9DkxasKr5
   BoVt6yzqyDFak+3N1s0fYUgk+GBJwtjp3ktaAuwZ44ogj/RUJ/B2GWquC
   s=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0B9AACoUERe/5ldJa1mHAEBAQEBBwE?=
 =?us-ascii?q?BEQEEBAEBgWcHAQELAYIogUEyKow3nSyFGoF7CQEBAQ4vBAEBhECCSyQ0CQ4?=
 =?us-ascii?q?CAw0BAQUBAQECAQUEbYVDhmYpgRUTgyaCfKwdgieFSoNFgT6BOAGHRYReGoF?=
 =?us-ascii?q?BP4RihCOGFgSWYYEql2uCRHyVSQwcmxQBLYpXnzmBUjmBWDMaCBsVgydQGA2?=
 =?us-ascii?q?OJAUXjkQgAzCPH4JCAQE?=
X-IronPort-AV: E=Sophos;i="5.70,433,1574121600"; 
   d="scan'208";a="438477709"
Received: from rcdn-core-2.cisco.com ([173.37.93.153])
  by alln-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 12 Feb 2020 19:29:02 +0000
Received: from zorba.cisco.com ([10.154.200.25])
        by rcdn-core-2.cisco.com (8.15.2/8.15.2) with ESMTP id 01CJT10q011732;
        Wed, 12 Feb 2020 19:29:02 GMT
From:   Daniel Walker <danielwa@cisco.com>
To:     Evgeniy Polyakov <zbr@ioremap.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: connector: cn_proc: allow limiting certain messages
Date:   Wed, 12 Feb 2020 11:29:01 -0800
Message-Id: <20200212192901.6402-1-danielwa@cisco.com>
X-Mailer: git-send-email 2.17.1
X-Outbound-SMTP-Client: 10.154.200.25, [10.154.200.25]
X-Outbound-Node: rcdn-core-2.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a way for system administrators to limit which messages can be
seen on the interface. Currently cn_proc is rather noisy, and it sends a
lot of different messages which may not be needed.

At Cisco we need to receive the coredump messages, and no others. This
interface currently has no way to allow this. This patch provides a set
of bool module parameters to enable or disable each message type. The
parameters end up looking like this,

$ ls -al /sys/module/cn_proc/parameters/
total 0
drwxr-xr-x 2 root root    0 Feb 10 16:51 .
drwxr-xr-x 3 root root    0 Feb 10 16:50 ..
-rw-r--r-- 1 root root 4096 Feb 10 16:51 enabled_comm
-rw-r--r-- 1 root root 4096 Feb 10 16:51 enabled_coredump
-rw-r--r-- 1 root root 4096 Feb 10 16:51 enabled_exec
-rw-r--r-- 1 root root 4096 Feb 10 16:51 enabled_exit
-rw-r--r-- 1 root root 4096 Feb 10 16:51 enabled_fork
-rw-r--r-- 1 root root 4096 Feb 10 16:51 enabled_gid
-rw-r--r-- 1 root root 4096 Feb 10 16:51 enabled_none
-rw-r--r-- 1 root root 4096 Feb 10 16:51 enabled_ptrace
-rw-r--r-- 1 root root 4096 Feb 10 16:51 enabled_sid
-rw-r--r-- 1 root root 4096 Feb 10 16:51 enabled_uid

All messages are enabled by default. To disable one you can run the following,

echo N > /sys/module/cn_proc/parameters/enabled_comm

Signed-off-by: Daniel Walker <danielwa@cisco.com>
---
 drivers/connector/cn_proc.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index d58ce664da84..23b934ee9862 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -38,6 +38,22 @@ static inline struct cn_msg *buffer_to_cn_msg(__u8 *buffer)
 static atomic_t proc_event_num_listeners = ATOMIC_INIT(0);
 static struct cb_id cn_proc_event_id = { CN_IDX_PROC, CN_VAL_PROC };
 
+#define CN_PROC_MSG_PARAM(name) \
+	static bool enabled_##name = true; \
+	module_param(enabled_##name, bool, 0644); \
+	MODULE_PARM_DESC(enabled_##name, "Enable message #name");
+
+CN_PROC_MSG_PARAM(none)
+CN_PROC_MSG_PARAM(fork)
+CN_PROC_MSG_PARAM(exec)
+CN_PROC_MSG_PARAM(uid)
+CN_PROC_MSG_PARAM(gid)
+CN_PROC_MSG_PARAM(sid)
+CN_PROC_MSG_PARAM(ptrace)
+CN_PROC_MSG_PARAM(comm)
+CN_PROC_MSG_PARAM(coredump)
+CN_PROC_MSG_PARAM(exit)
+
 /* proc_event_counts is used as the sequence number of the netlink message */
 static DEFINE_PER_CPU(__u32, proc_event_counts) = { 0 };
 
@@ -66,6 +82,8 @@ void proc_fork_connector(struct task_struct *task)
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 	struct task_struct *parent;
 
+	if (!enabled_fork)
+		return;
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
@@ -95,6 +113,8 @@ void proc_exec_connector(struct task_struct *task)
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
+	if (!enabled_exec)
+		return;
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
@@ -120,6 +140,8 @@ void proc_id_connector(struct task_struct *task, int which_id)
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 	const struct cred *cred;
 
+	if (!enabled_uid)
+		return;
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
@@ -157,6 +179,8 @@ void proc_sid_connector(struct task_struct *task)
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
+	if (!enabled_sid)
+		return;
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
@@ -181,6 +205,8 @@ void proc_ptrace_connector(struct task_struct *task, int ptrace_id)
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
+	if (!enabled_ptrace)
+		return;
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
@@ -213,6 +239,8 @@ void proc_comm_connector(struct task_struct *task)
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
+	if (!enabled_comm)
+		return;
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
@@ -239,6 +267,8 @@ void proc_coredump_connector(struct task_struct *task)
 	struct task_struct *parent;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
+	if (!enabled_coredump)
+		return;
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
@@ -272,6 +302,8 @@ void proc_exit_connector(struct task_struct *task)
 	struct task_struct *parent;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
+	if (!enabled_exit)
+		return;
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
@@ -314,6 +346,8 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
+	if (!enabled_none)
+		return;
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-- 
2.17.1

