Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B458AB7097
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 03:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387628AbfISBYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 21:24:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51352 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387561AbfISBYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 21:24:47 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E28493DE04;
        Thu, 19 Sep 2019 01:24:40 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71BED60C80;
        Thu, 19 Sep 2019 01:24:35 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com,
        nhorman@tuxdriver.com, dwalsh@redhat.com, mpatel@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 V7 07/21] audit: log container info of syscalls
Date:   Wed, 18 Sep 2019 21:22:24 -0400
Message-Id: <0c0cd13044a26d7e0a280efb7cbd39cfb5fdf4ed.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 19 Sep 2019 01:24:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new audit record AUDIT_CONTAINER_ID to document the audit
container identifier of a process if it is present.

Called from audit_log_exit(), syscalls are covered.

A sample raw event:
type=SYSCALL msg=audit(1519924845.499:257): arch=c000003e syscall=257 success=yes exit=3 a0=ffffff9c a1=56374e1cef30 a2=241 a3=1b6 items=2 ppid=606 pid=635 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=3 comm="bash" exe="/usr/bin/bash" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="tmpcontainerid"
type=CWD msg=audit(1519924845.499:257): cwd="/root"
type=PATH msg=audit(1519924845.499:257): item=0 name="/tmp/" inode=13863 dev=00:27 mode=041777 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:tmp_t:s0 nametype= PARENT cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0
type=PATH msg=audit(1519924845.499:257): item=1 name="/tmp/tmpcontainerid" inode=17729 dev=00:27 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:user_tmp_t:s0 nametype=CREATE cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0
type=PROCTITLE msg=audit(1519924845.499:257): proctitle=62617368002D6300736C65657020313B206563686F2074657374203E202F746D702F746D70636F6E7461696E65726964
type=CONTAINER_ID msg=audit(1519924845.499:257): contid=123458

Please see the github audit kernel issue for the main feature:
  https://github.com/linux-audit/audit-kernel/issues/90
Please see the github audit userspace issue for supporting additions:
  https://github.com/linux-audit/audit-userspace/issues/51
Please see the github audit testsuiite issue for the test case:
  https://github.com/linux-audit/audit-testsuite/issues/64
Please see the github audit wiki for the feature overview:
  https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Acked-by: Steve Grubb <sgrubb@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 include/linux/audit.h      |  5 +++++
 include/uapi/linux/audit.h |  1 +
 kernel/audit.c             | 20 ++++++++++++++++++++
 kernel/auditsc.c           | 20 ++++++++++++++------
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index e317807cdd3e..0c18d8e30620 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -220,6 +220,8 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
 
 extern void audit_cont_put(struct audit_cont *cont);
 
+extern void audit_log_container_id(struct audit_context *context, u64 contid);
+
 extern u32 audit_enabled;
 
 extern int audit_signal_info(int sig, struct task_struct *t);
@@ -297,6 +299,9 @@ static inline struct audit_cont *audit_cont(struct task_struct *tsk)
 static inline void audit_cont_put(struct audit_cont *cont)
 { }
 
+static inline void audit_log_container_id(struct audit_context *context, u64 contid)
+{ }
+
 #define audit_enabled AUDIT_OFF
 
 static inline int audit_signal_info(int sig, struct task_struct *t)
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 5d0ea2a6783e..4ed080f28b47 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -117,6 +117,7 @@
 #define AUDIT_FANOTIFY		1331	/* Fanotify access decision */
 #define AUDIT_TIME_INJOFFSET	1332	/* Timekeeping offset injected */
 #define AUDIT_TIME_ADJNTPVAL	1333	/* NTP value adjustment */
+#define AUDIT_CONTAINER_ID	1334	/* Container ID */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
diff --git a/kernel/audit.c b/kernel/audit.c
index 329916534dd2..adfb3e6a7f0c 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2127,6 +2127,26 @@ void audit_log_session_info(struct audit_buffer *ab)
 	audit_log_format(ab, "auid=%u ses=%u", auid, sessionid);
 }
 
+/*
+ * audit_log_container_id - report container info
+ * @context: task or local context for record
+ * @contid: container ID to report
+ */
+void audit_log_container_id(struct audit_context *context, u64 contid)
+{
+	struct audit_buffer *ab;
+
+	if (!audit_contid_valid(contid))
+		return;
+	/* Generate AUDIT_CONTAINER_ID record with container ID */
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER_ID);
+	if (!ab)
+		return;
+	audit_log_format(ab, "contid=%llu", contid);
+	audit_log_end(ab);
+}
+EXPORT_SYMBOL(audit_log_container_id);
+
 void audit_log_key(struct audit_buffer *ab, char *key)
 {
 	audit_log_format(ab, " key=");
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index bd855794ad26..ac438fcff807 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1534,7 +1534,7 @@ static void audit_log_exit(void)
 	for (aux = context->aux_pids; aux; aux = aux->next) {
 		struct audit_aux_data_pids *axs = (void *)aux;
 
-		for (i = 0; i < axs->pid_count; i++)
+		for (i = 0; i < axs->pid_count; i++) {
 			if (audit_log_pid_context(context, axs->target_pid[i],
 						  axs->target_auid[i],
 						  axs->target_uid[i],
@@ -1542,14 +1542,20 @@ static void audit_log_exit(void)
 						  axs->target_sid[i],
 						  axs->target_comm[i]))
 				call_panic = 1;
+			audit_log_container_id(context, axs->target_cid[i]);
+		}
 	}
 
-	if (context->target_pid &&
-	    audit_log_pid_context(context, context->target_pid,
-				  context->target_auid, context->target_uid,
-				  context->target_sessionid,
-				  context->target_sid, context->target_comm))
+	if (context->target_pid) {
+		if (audit_log_pid_context(context, context->target_pid,
+					  context->target_auid,
+					  context->target_uid,
+					  context->target_sessionid,
+					  context->target_sid,
+					  context->target_comm))
 			call_panic = 1;
+		audit_log_container_id(context, context->target_cid);
+	}
 
 	if (context->pwd.dentry && context->pwd.mnt) {
 		ab = audit_log_start(context, GFP_KERNEL, AUDIT_CWD);
@@ -1568,6 +1574,8 @@ static void audit_log_exit(void)
 
 	audit_log_proctitle();
 
+	audit_log_container_id(context, audit_get_contid(current));
+
 	audit_log_container_drop();
 
 	/* Send end of event record to help user space know we are finished */
-- 
1.8.3.1

