Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB4010C5C9
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 10:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfK1JQq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 Nov 2019 04:16:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28528 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726092AbfK1JQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 04:16:46 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-vB5khnU5Mei4QuQSq8mVBQ-1; Thu, 28 Nov 2019 04:16:40 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 547AD800D41;
        Thu, 28 Nov 2019 09:16:39 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8FD85C1B0;
        Thu, 28 Nov 2019 09:16:33 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-audit@redhat.com, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Subject: [RFC] bpf: Emit audit messages upon successful prog load and unload
Date:   Thu, 28 Nov 2019 10:16:32 +0100
Message-Id: <20191128091633.29275-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: vB5khnU5Mei4QuQSq8mVBQ-1
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
  ...
  ----
  time->Wed Nov 27 16:04:13 2019
  type=PROCTITLE msg=audit(1574867053.120:84664): proctitle="./bpf"
  type=SYSCALL msg=audit(1574867053.120:84664): arch=c000003e syscall=321   \
    success=yes exit=3 a0=5 a1=7ffea484fbe0 a2=70 a3=0 items=0 ppid=7477    \
    pid=12698 auid=1001 uid=1001 gid=1001 euid=1001 suid=1001 fsuid=1001    \
    egid=1001 sgid=1001 fsgid=1001 tty=pts2 ses=4 comm="bpf"                \
    exe="/home/jolsa/auditd/audit-testsuite/tests/bpf/bpf"                  \
    subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
  type=UNKNOWN[1334] msg=audit(1574867053.120:84664): prog-id=76 op=LOAD
  ----
  time->Wed Nov 27 16:04:13 2019
  type=UNKNOWN[1334] msg=audit(1574867053.120:84665): prog-id=76 op=UNLOAD
  ...

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Co-developed-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/uapi/linux/audit.h |  1 +
 kernel/bpf/syscall.c       | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

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
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e3461ec59570..20826aad247c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -23,6 +23,7 @@
 #include <linux/timekeeping.h>
 #include <linux/ctype.h>
 #include <linux/nospec.h>
+#include <linux/audit.h>
 #include <uapi/linux/btf.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
@@ -1306,6 +1307,30 @@ static int find_prog_type(enum bpf_prog_type type, struct bpf_prog *prog)
 	return 0;
 }
 
+enum bpf_audit {
+	BPF_AUDIT_LOAD,
+	BPF_AUDIT_UNLOAD,
+};
+
+static const char * const bpf_audit_str[] = {
+	[BPF_AUDIT_LOAD]   = "LOAD",
+	[BPF_AUDIT_UNLOAD] = "UNLOAD",
+};
+
+static void bpf_audit_prog(const struct bpf_prog *prog, enum bpf_audit op)
+{
+	struct audit_buffer *ab;
+
+	if (audit_enabled == AUDIT_OFF)
+		return;
+	ab = audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_BPF);
+	if (unlikely(!ab))
+		return;
+	audit_log_format(ab, "prog-id=%u op=%s",
+			 prog->aux->id, bpf_audit_str[op]);
+	audit_log_end(ab);
+}
+
 int __bpf_prog_charge(struct user_struct *user, u32 pages)
 {
 	unsigned long memlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
@@ -1421,6 +1446,7 @@ static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
 {
 	if (atomic64_dec_and_test(&prog->aux->refcnt)) {
 		perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_UNLOAD, 0);
+		bpf_audit_prog(prog, BPF_AUDIT_UNLOAD);
 		/* bpf_prog_free_id() must be called first */
 		bpf_prog_free_id(prog, do_idr_lock);
 		__bpf_prog_put_noref(prog, true);
@@ -1830,6 +1856,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	 */
 	bpf_prog_kallsyms_add(prog);
 	perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_LOAD, 0);
+	bpf_audit_prog(prog, BPF_AUDIT_LOAD);
 
 	err = bpf_prog_new_fd(prog);
 	if (err < 0)
-- 
2.23.0

