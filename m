Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5431D22A1
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 01:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732291AbgEMXED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 19:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731815AbgEMXEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 19:04:01 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B32C061A0C;
        Wed, 13 May 2020 16:04:01 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w65so393900pfc.12;
        Wed, 13 May 2020 16:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u9vJ8Ibe2TUJ1QVhKFzt9KOOKr6zN91oMhdosARx+EI=;
        b=DQDp+w3/8aibWwLJ6Svq6hDxLK9olHvGrqxayWYbjMrdh9Tf9OzK88pcGaWUjeuiO8
         L5EtIMwL8T6bN2HLPILOpM9fqOntUwy0iwkemLLq2LZv+Hv4afR9mYy6Aqv2PmH5S02+
         y96+iwHfY0f4nL52MwD8sTRClYDzCtpnsjvUvgyRCbqFb5UWwlxfmhcNI6JNqrC0m5wu
         LfKnfVyxgRUqTm0BD347HyALemzNC4sz1VIKe8A3m1xkng2P6jPNMjkIsFS+Ds8yZPiA
         +apFhkubOfGwdAuHdEkrRZ0r4wSVaxBuLI2R00zRqpAA8u8OLSfYCtPTmSUfBY5aNTZB
         S6iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=u9vJ8Ibe2TUJ1QVhKFzt9KOOKr6zN91oMhdosARx+EI=;
        b=Rdn7WbvXU27wDSukQ64TO8S5gwhTy4AOpLd2MsSxOiDBh28oPc6uGn1yVpfjK1ek2j
         +16yfnnBhzoBq1qyZ8S21WePR0QxclCNdextTuZOYgY5HU4gvyaDvfKpf7l5Z+zgGkQE
         tCAuYZwKrjWpiqVA8g615iQh4r4ALIWRyAeu/g9UMfgGDaYubT+zzcDKF/PnF5NYuF9q
         ts/siAz5Bm0k6cODQi2+oaQR6XQPs9L8C+vesfAj4VK8LCk/NF9l/pTO65DRxpezI83L
         ZIDXLxTX+kKODYBaOJF3o96P0ZnFmoyk1oZgABKGosi8N6hRApHn5AVjUOE0Kw1MbKgH
         3GBw==
X-Gm-Message-State: AOAM533GrMmM6JLQfojhK26t3YMUg3JDAFQBDt56oWW6P+q6vR/0bpza
        NP1iBQPtB9Mdri8T71Ag/rPKFQ86
X-Google-Smtp-Source: ABdhPJyHW0xQ/sI670poFg2vDmilweFE3a+EGJHF0WxHwJatlzDlhUXLt0VeYw8ckinAzUttg8EXLA==
X-Received: by 2002:a63:3114:: with SMTP id x20mr1581052pgx.52.1589411040968;
        Wed, 13 May 2020 16:04:00 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id t23sm16558706pji.32.2020.05.13.16.03.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 16:03:59 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com
Subject: [PATCH v7 bpf-next 1/3] bpf, capability: Introduce CAP_BPF
Date:   Wed, 13 May 2020 16:03:53 -0700
Message-Id: <20200513230355.7858-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200513230355.7858-1-alexei.starovoitov@gmail.com>
References: <20200513230355.7858-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Split BPF operations that are allowed under CAP_SYS_ADMIN into
combination of CAP_BPF, CAP_PERFMON, CAP_NET_ADMIN.
For backward compatibility include them in CAP_SYS_ADMIN as well.

The end result provides simple safety model for applications that use BPF:
- to load tracing program types
  BPF_PROG_TYPE_{KPROBE, TRACEPOINT, PERF_EVENT, RAW_TRACEPOINT, etc}
  use CAP_BPF and CAP_PERFMON
- to load networking program types
  BPF_PROG_TYPE_{SCHED_CLS, XDP, SK_SKB, etc}
  use CAP_BPF and CAP_NET_ADMIN

There are few exceptions from this rule:
- bpf_trace_printk() is allowed in networking programs, but it's using
  tracing mechanism, hence this helper needs additional CAP_PERFMON
  if networking program is using this helper.
- BPF_F_ZERO_SEED flag for hash/lru map is allowed under CAP_SYS_ADMIN only
  to discourage production use.
- BPF HW offload is allowed under CAP_SYS_ADMIN.
- bpf_probe_write_user() is allowed under CAP_SYS_ADMIN only.

CAPs are not checked at attach/detach time with two exceptions:
- loading BPF_PROG_TYPE_CGROUP_SKB is allowed for unprivileged users,
  hence CAP_NET_ADMIN is required at attach time.
- flow_dissector detach doesn't check prog FD at detach,
  hence CAP_NET_ADMIN is required at detach time.

CAP_SYS_ADMIN is required to iterate BPF objects (progs, maps, links) via get_next_id
command and convert them to file descriptor via GET_FD_BY_ID command.
This restriction guarantees that mutliple tasks with CAP_BPF are not able to
affect each other. That leads to clean isolation of tasks. For example:
task A with CAP_BPF and CAP_NET_ADMIN loads and attaches a firewall via bpf_link.
task B with the same capabilities cannot detach that firewall unless
task A explicitly passed link FD to task B via scm_rights or bpffs.
CAP_SYS_ADMIN can still detach/unload everything.

Two networking user apps with CAP_SYS_ADMIN and CAP_NET_ADMIN can
accidentely mess with each other programs and maps.
Two networking user apps with CAP_NET_ADMIN and CAP_BPF cannot affect each other.

CAP_NET_ADMIN + CAP_BPF allows networking programs access only packet data.
Such networking progs cannot access arbitrary kernel memory or leak pointers.

bpftool, bpftrace, bcc tools binaries should NOT be installed with
CAP_BPF and CAP_PERFMON, since unpriv users will be able to read kernel secrets.
But users with these two permissions will be able to use these tracing tools.

CAP_PERFMON is least secure, since it allows kprobes and kernel memory access.
CAP_NET_ADMIN can stop network traffic via iproute2.
CAP_BPF is the safest from security point of view and harmless on its own.

Having CAP_BPF and/or CAP_NET_ADMIN is not enough to write into arbitrary map
and if that map is used by firewall-like bpf prog.
CAP_BPF allows many bpf prog_load commands in parallel. The verifier
may consume large amount of memory and significantly slow down the system.

Existing unprivileged BPF operations are not affected.
In particular unprivileged users are allowed to load socket_filter and cg_skb
program types and to create array, hash, prog_array, map-in-map map types.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/capability.h          |  5 +++++
 include/uapi/linux/capability.h     | 34 ++++++++++++++++++++++++++++-
 security/selinux/include/classmap.h |  4 ++--
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 027d7e4a853b..b4345b38a6be 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -256,6 +256,11 @@ static inline bool perfmon_capable(void)
 	return capable(CAP_PERFMON) || capable(CAP_SYS_ADMIN);
 }
 
+static inline bool bpf_capable(void)
+{
+	return capable(CAP_BPF) || capable(CAP_SYS_ADMIN);
+}
+
 /* audit system wants to get cap info from files as well */
 extern int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps);
 
diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index e58c9636741b..c7372180a0a9 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -274,6 +274,7 @@ struct vfs_ns_cap_data {
    arbitrary SCSI commands */
 /* Allow setting encryption key on loopback filesystem */
 /* Allow setting zone reclaim policy */
+/* Allow everything under CAP_BPF and CAP_PERFMON for backward compatibility */
 
 #define CAP_SYS_ADMIN        21
 
@@ -374,7 +375,38 @@ struct vfs_ns_cap_data {
 
 #define CAP_PERFMON		38
 
-#define CAP_LAST_CAP         CAP_PERFMON
+/*
+ * CAP_BPF allows the following BPF operations:
+ * - Creating all types of BPF maps
+ * - Advanced verifier features
+ *   - Indirect variable access
+ *   - Bounded loops
+ *   - BPF to BPF function calls
+ *   - Scalar precision tracking
+ *   - Larger complexity limits
+ *   - Dead code elimination
+ *   - And potentially other features
+ * - Loading BPF Type Format (BTF) data
+ * - Retrieve xlated and JITed code of BPF programs
+ * - Use bpf_spin_lock() helper
+ *
+ * CAP_PERFMON relaxes the verifier checks further:
+ * - BPF progs can use of pointer-to-integer conversions
+ * - speculation attack hardening measures are bypassed
+ * - bpf_probe_read to read arbitrary kernel memory is allowed
+ * - bpf_trace_printk to print kernel memory is allowed
+ *
+ * CAP_SYS_ADMIN is required to use bpf_probe_write_user.
+ *
+ * CAP_SYS_ADMIN is required to iterate system wide loaded
+ * programs, maps, links, BTFs and convert their IDs to file descriptors.
+ *
+ * CAP_PERFMON and CAP_BPF are required to load tracing programs.
+ * CAP_NET_ADMIN and CAP_BPF are required to load networking programs.
+ */
+#define CAP_BPF			39
+
+#define CAP_LAST_CAP         CAP_BPF
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index d233ab3f1533..98e1513b608a 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -27,9 +27,9 @@
 	    "audit_control", "setfcap"
 
 #define COMMON_CAP2_PERMS  "mac_override", "mac_admin", "syslog", \
-		"wake_alarm", "block_suspend", "audit_read", "perfmon"
+		"wake_alarm", "block_suspend", "audit_read", "perfmon", "bpf"
 
-#if CAP_LAST_CAP > CAP_PERFMON
+#if CAP_LAST_CAP > CAP_BPF
 #error New capability defined, please update COMMON_CAP2_PERMS.
 #endif
 
-- 
2.23.0

