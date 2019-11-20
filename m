Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D471045E1
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 22:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfKTVi1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 Nov 2019 16:38:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40184 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726038AbfKTVi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 16:38:27 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-vtm7GUXbMPidYs9lK7RzTw-1; Wed, 20 Nov 2019 16:38:23 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 292F1477;
        Wed, 20 Nov 2019 21:38:21 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-103.brq.redhat.com [10.40.204.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C76415F91C;
        Wed, 20 Nov 2019 21:38:17 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Subject: [PATCH] bpf: emit audit messages upon successful prog load and unload
Date:   Wed, 20 Nov 2019 22:38:16 +0100
Message-Id: <20191120213816.8186-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: vtm7GUXbMPidYs9lK7RzTw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

Allow for audit messages to be emitted upon BPF program load and
unload for having a timeline of events. The load itself is in
syscall context, so additional info about the process initiating
the BPF prog creation can be logged and later directly correlated
to the unload event.

The only info really needed from BPF side is the globally unique
prog ID where then audit user space tooling can query / dump all
info needed about the specific BPF program right upon load event
and enrich the record, thus these changes needed here can be kept
small and non-intrusive to the core.

Raw example output:

  # auditctl -D
  # auditctl -a always,exit -F arch=x86_64 -S bpf
  # ausearch --start recent -m 1334
  [...]
  ----
  time->Wed Nov 20 12:45:51 2019
  type=PROCTITLE msg=audit(1574271951.590:8974): proctitle="./test_verifier"
  type=SYSCALL msg=audit(1574271951.590:8974): arch=c000003e syscall=321 success=yes exit=14 a0=5 a1=7ffe2d923e80 a2=78 a3=0 items=0 ppid=742 pid=949 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=2 comm="test_verifier" exe="/root/bpf-next/tools/testing/selftests/bpf/test_verifier" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
  type=UNKNOWN[1334] msg=audit(1574271951.590:8974): auid=0 uid=0 gid=0 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 pid=949 comm="test_verifier" exe="/root/bpf-next/tools/testing/selftests/bpf/test_verifier" prog-id=3260 event=LOAD
  ----
  time->Wed Nov 20 12:45:51 2019
type=UNKNOWN[1334] msg=audit(1574271951.590:8975): prog-id=3260 event=UNLOAD
  ----
  [...]

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/audit.h      |  3 +++
 include/uapi/linux/audit.h |  1 +
 kernel/auditsc.c           |  2 +-
 kernel/bpf/syscall.c       | 31 +++++++++++++++++++++++++++++++
 4 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index aee3dc9eb378..edd006f4597d 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -159,6 +159,7 @@ extern void		    audit_log_key(struct audit_buffer *ab,
 extern void		    audit_log_link_denied(const char *operation);
 extern void		    audit_log_lost(const char *message);
 
+extern void audit_log_task(struct audit_buffer *ab);
 extern int audit_log_task_context(struct audit_buffer *ab);
 extern void audit_log_task_info(struct audit_buffer *ab);
 
@@ -219,6 +220,8 @@ static inline void audit_log_key(struct audit_buffer *ab, char *key)
 { }
 static inline void audit_log_link_denied(const char *string)
 { }
+static inline void audit_log_task(struct audit_buffer *ab)
+{ }
 static inline int audit_log_task_context(struct audit_buffer *ab)
 {
 	return 0;
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index c89c6495983d..32a5db900f47 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -116,6 +116,7 @@
 #define AUDIT_FANOTIFY		1331	/* Fanotify access decision */
 #define AUDIT_TIME_INJOFFSET	1332	/* Timekeeping offset injected */
 #define AUDIT_TIME_ADJNTPVAL	1333	/* NTP value adjustment */
+#define AUDIT_BPF		1334	/* BPF subsystem */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 4effe01ebbe2..9bf1045fedfa 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2545,7 +2545,7 @@ void __audit_ntp_log(const struct audit_ntp_data *ad)
 	audit_log_ntp_val(ad, "adjust",	AUDIT_NTP_ADJUST);
 }
 
-static void audit_log_task(struct audit_buffer *ab)
+void audit_log_task(struct audit_buffer *ab)
 {
 	kuid_t auid, uid;
 	kgid_t gid;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index bac3becf9f90..17f4254495f2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -23,6 +23,7 @@
 #include <linux/timekeeping.h>
 #include <linux/ctype.h>
 #include <linux/nospec.h>
+#include <linux/audit.h>
 #include <uapi/linux/btf.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PROG_ARRAY || \
@@ -1318,6 +1319,34 @@ static void free_used_maps(struct bpf_prog_aux *aux)
 	kfree(aux->used_maps);
 }
 
+enum bpf_event {
+	BPF_EVENT_LOAD,
+	BPF_EVENT_UNLOAD,
+};
+
+static const char * const bpf_event_audit_str[] = {
+	[BPF_EVENT_LOAD]   = "LOAD",
+	[BPF_EVENT_UNLOAD] = "UNLOAD",
+};
+
+static void bpf_audit_prog(const struct bpf_prog *prog, enum bpf_event event)
+{
+	bool has_task_context = event == BPF_EVENT_LOAD;
+	struct audit_buffer *ab;
+
+	if (audit_enabled == AUDIT_OFF)
+		return;
+	ab = audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_BPF);
+	if (unlikely(!ab))
+		return;
+	if (has_task_context)
+		audit_log_task(ab);
+	audit_log_format(ab, "%sprog-id=%u event=%s",
+			 has_task_context ? " " : "",
+			 prog->aux->id, bpf_event_audit_str[event]);
+	audit_log_end(ab);
+}
+
 int __bpf_prog_charge(struct user_struct *user, u32 pages)
 {
 	unsigned long memlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
@@ -1434,6 +1463,7 @@ static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
 {
 	if (atomic64_dec_and_test(&prog->aux->refcnt)) {
 		perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_UNLOAD, 0);
+		bpf_audit_prog(prog, BPF_EVENT_UNLOAD);
 		/* bpf_prog_free_id() must be called first */
 		bpf_prog_free_id(prog, do_idr_lock);
 		__bpf_prog_put_noref(prog, true);
@@ -1843,6 +1873,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	 */
 	bpf_prog_kallsyms_add(prog);
 	perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_LOAD, 0);
+	bpf_audit_prog(prog, BPF_EVENT_LOAD);
 
 	err = bpf_prog_new_fd(prog);
 	if (err < 0)
-- 
2.21.0

