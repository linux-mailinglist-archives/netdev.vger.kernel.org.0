Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F9E21172F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgGBA2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:28:19 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:47368 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgGBA1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:27:48 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 8EC338066C;
        Thu,  2 Jul 2020 12:27:46 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1593649666;
        bh=U6mx+98LjO78XogJoRjkgUnESMK6sIUlMFc60CvP8LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=x6aiDoqDGclF7PPHFzjOnQIA6g55HtN2HuVUhO7JHYpiV3GJ1/Gdxcp7ThEPSgUDq
         XudrKwr6RwdefPrO81yQ9h3jd9ewypfrXxVLd9yyoyHFoe2i0THfLeAL1k8awgCXya
         znIn+ZhBc8fRZPIDQX/6ezx3Ik8cSiDO50z4Ti47OuFHb0Np8qh6NHmqFgG8yfKNj6
         jz7OED/vkdlIhRbY+Z9F7W+BLImu5lRhQc9Cwe0nePYcjmurdovXu+lUEeArsop3Uk
         /3WS2RyxJu5CZ1VEkP/AXNgnqzCkzPi0r4thUVMHR9yvlF1yIsWOV9U5vFtkQWvJyi
         wf/tK+gicpHzw==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5efd2a020000>; Thu, 02 Jul 2020 12:27:46 +1200
Received: from mattb-dl.ws.atlnz.lc (mattb-dl.ws.atlnz.lc [10.33.25.34])
        by smtp (Postfix) with ESMTP id B2A2413EDDC;
        Thu,  2 Jul 2020 12:27:44 +1200 (NZST)
Received: by mattb-dl.ws.atlnz.lc (Postfix, from userid 1672)
        id 3C64B4A02A3; Thu,  2 Jul 2020 12:27:46 +1200 (NZST)
From:   Matt Bennett <matt.bennett@alliedtelesis.co.nz>
To:     netdev@vger.kernel.org
Cc:     zbr@ioremap.net, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org,
        Matt Bennett <matt.bennett@alliedtelesis.co.nz>
Subject: [PATCH 1/5] connector: Use task pid helpers
Date:   Thu,  2 Jul 2020 12:26:31 +1200
Message-Id: <20200702002635.8169-2-matt.bennett@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
References: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for supporting the connector outside of the default
network namespace we switch to using these helpers now. As the connector
is still only supported in the default namespace this change is a no-op.

Signed-off-by: Matt Bennett <matt.bennett@alliedtelesis.co.nz>
---
 drivers/connector/cn_proc.c | 48 ++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 646ad385e490..36a7823c56ec 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -83,11 +83,11 @@ void proc_fork_connector(struct task_struct *task)
 	ev->what =3D PROC_EVENT_FORK;
 	rcu_read_lock();
 	parent =3D rcu_dereference(task->real_parent);
-	ev->event_data.fork.parent_pid =3D parent->pid;
-	ev->event_data.fork.parent_tgid =3D parent->tgid;
+	ev->event_data.fork.parent_pid =3D task_pid_vnr(parent);
+	ev->event_data.fork.parent_tgid =3D task_tgid_vnr(parent);
 	rcu_read_unlock();
-	ev->event_data.fork.child_pid =3D task->pid;
-	ev->event_data.fork.child_tgid =3D task->tgid;
+	ev->event_data.fork.child_pid =3D task_pid_vnr(task);
+	ev->event_data.fork.child_tgid =3D task_tgid_vnr(task);
=20
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack =3D 0; /* not used */
@@ -110,8 +110,8 @@ void proc_exec_connector(struct task_struct *task)
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	ev->timestamp_ns =3D ktime_get_ns();
 	ev->what =3D PROC_EVENT_EXEC;
-	ev->event_data.exec.process_pid =3D task->pid;
-	ev->event_data.exec.process_tgid =3D task->tgid;
+	ev->event_data.exec.process_pid =3D task_pid_vnr(task);
+	ev->event_data.exec.process_tgid =3D task_tgid_vnr(task);
=20
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack =3D 0; /* not used */
@@ -134,8 +134,8 @@ void proc_id_connector(struct task_struct *task, int =
which_id)
 	ev =3D (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	ev->what =3D which_id;
-	ev->event_data.id.process_pid =3D task->pid;
-	ev->event_data.id.process_tgid =3D task->tgid;
+	ev->event_data.id.process_pid =3D task_pid_vnr(task);
+	ev->event_data.id.process_tgid =3D task_tgid_vnr(task);
 	rcu_read_lock();
 	cred =3D __task_cred(task);
 	if (which_id =3D=3D PROC_EVENT_UID) {
@@ -172,8 +172,8 @@ void proc_sid_connector(struct task_struct *task)
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	ev->timestamp_ns =3D ktime_get_ns();
 	ev->what =3D PROC_EVENT_SID;
-	ev->event_data.sid.process_pid =3D task->pid;
-	ev->event_data.sid.process_tgid =3D task->tgid;
+	ev->event_data.sid.process_pid =3D task_pid_vnr(task);
+	ev->event_data.sid.process_tgid =3D task_tgid_vnr(task);
=20
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack =3D 0; /* not used */
@@ -196,11 +196,11 @@ void proc_ptrace_connector(struct task_struct *task=
, int ptrace_id)
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	ev->timestamp_ns =3D ktime_get_ns();
 	ev->what =3D PROC_EVENT_PTRACE;
-	ev->event_data.ptrace.process_pid  =3D task->pid;
-	ev->event_data.ptrace.process_tgid =3D task->tgid;
+	ev->event_data.ptrace.process_pid  =3D task_pid_vnr(task);
+	ev->event_data.ptrace.process_tgid =3D task_tgid_vnr(task);
 	if (ptrace_id =3D=3D PTRACE_ATTACH) {
-		ev->event_data.ptrace.tracer_pid  =3D current->pid;
-		ev->event_data.ptrace.tracer_tgid =3D current->tgid;
+		ev->event_data.ptrace.tracer_pid  =3D task_pid_vnr(current);
+		ev->event_data.ptrace.tracer_tgid =3D task_tgid_vnr(current);
 	} else if (ptrace_id =3D=3D PTRACE_DETACH) {
 		ev->event_data.ptrace.tracer_pid  =3D 0;
 		ev->event_data.ptrace.tracer_tgid =3D 0;
@@ -228,8 +228,8 @@ void proc_comm_connector(struct task_struct *task)
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	ev->timestamp_ns =3D ktime_get_ns();
 	ev->what =3D PROC_EVENT_COMM;
-	ev->event_data.comm.process_pid  =3D task->pid;
-	ev->event_data.comm.process_tgid =3D task->tgid;
+	ev->event_data.comm.process_pid  =3D task_pid_vnr(task);
+	ev->event_data.comm.process_tgid =3D task_tgid_vnr(task);
 	get_task_comm(ev->event_data.comm.comm, task);
=20
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
@@ -254,14 +254,14 @@ void proc_coredump_connector(struct task_struct *ta=
sk)
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	ev->timestamp_ns =3D ktime_get_ns();
 	ev->what =3D PROC_EVENT_COREDUMP;
-	ev->event_data.coredump.process_pid =3D task->pid;
-	ev->event_data.coredump.process_tgid =3D task->tgid;
+	ev->event_data.coredump.process_pid =3D task_pid_vnr(task);
+	ev->event_data.coredump.process_tgid =3D task_tgid_vnr(task);
=20
 	rcu_read_lock();
 	if (pid_alive(task)) {
 		parent =3D rcu_dereference(task->real_parent);
-		ev->event_data.coredump.parent_pid =3D parent->pid;
-		ev->event_data.coredump.parent_tgid =3D parent->tgid;
+		ev->event_data.coredump.parent_pid =3D task_pid_vnr(parent);
+		ev->event_data.coredump.parent_tgid =3D task_tgid_vnr(parent);
 	}
 	rcu_read_unlock();
=20
@@ -287,16 +287,16 @@ void proc_exit_connector(struct task_struct *task)
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	ev->timestamp_ns =3D ktime_get_ns();
 	ev->what =3D PROC_EVENT_EXIT;
-	ev->event_data.exit.process_pid =3D task->pid;
-	ev->event_data.exit.process_tgid =3D task->tgid;
+	ev->event_data.exit.process_pid =3D task_pid_vnr(task);
+	ev->event_data.exit.process_tgid =3D task_tgid_vnr(task);
 	ev->event_data.exit.exit_code =3D task->exit_code;
 	ev->event_data.exit.exit_signal =3D task->exit_signal;
=20
 	rcu_read_lock();
 	if (pid_alive(task)) {
 		parent =3D rcu_dereference(task->real_parent);
-		ev->event_data.exit.parent_pid =3D parent->pid;
-		ev->event_data.exit.parent_tgid =3D parent->tgid;
+		ev->event_data.exit.parent_pid =3D task_pid_vnr(parent);
+		ev->event_data.exit.parent_tgid =3D task_tgid_vnr(parent);
 	}
 	rcu_read_unlock();
=20
--=20
2.27.0

