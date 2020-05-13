Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A934D1D0566
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 05:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgEMDTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 23:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725898AbgEMDTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 23:19:36 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A38C061A0C;
        Tue, 12 May 2020 20:19:36 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x77so7388944pfc.0;
        Tue, 12 May 2020 20:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nuEw7yQsevwdkCRcMfCo16KnNkfJBQ7TsXok3UBN7zY=;
        b=j6P0g58eXtMAJFD9rY8gGp2mQbc/TH5j1nfkHQJDtxiinzgijjPweXIJ39T0aWuEfM
         PtD6a8E8dtlhguY9wj7iKAGV1z1hnSyjsTgf2hMF7ubv4SYgQahqfDasAV945XvT93My
         te8EQ/0iFZK8JcQrsCEXrnEMcgOAkywy0JoCNG5b7eoaBGVVBOqYbxtHDFMQYpqls4tO
         qy7aHI+8RHrqbZtJ0rcjYZLYNL2NQXGV9TR7xRdyNB2C4a+MsdcV3iaWuwvMQVmaRFpu
         4VACphNbUNP4C4Nac/5Oh+H8GnBGTIX7T+ujcK2jd2TDv8PbB4Ja2WNP2Jp6wMlEvZms
         n2mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nuEw7yQsevwdkCRcMfCo16KnNkfJBQ7TsXok3UBN7zY=;
        b=ZaGlkQEddYshGoKawG8s9iXdmPWoCQvazU3zcU9LoscUX0PpIR/NmGh8vAX8e+MrJe
         dggLwNZd2+C5XGa0b7P3VFDlNsi2LBlphhFscGO7RZSeFFqoroZTk70gD6iUcYXsg+G1
         xcoa3RAFh0OKZQrlUiALBWGJ2UI3rPO5ONX7Pruax3DR4jys2NK7nXGbBxDaBruBhQRZ
         B+WuU8AvQrTWxSBH3fF38xJtyB44bIf1oUR1vf+JycTrKRh+0KcDkta0Kd2SuZnVK4t8
         3jtavHzso3MczHjtZLhJxY11stS/tQREcrrdF/g4Af1tO2EE31lCGLsCoTl9pb+duDan
         ogFA==
X-Gm-Message-State: AGi0PuaI4FM5sXER3C10WDaSsbDA5JH0u4wdWDAz18x9jA1KnXJvOOE3
        hnACkUUFqCk7IsRrIPlI/cw=
X-Google-Smtp-Source: APiQypIgUmF7akWTN6nZOdXikOf33uD+SazejNdmsp4+2mi78TdMzxIjpI5WVnhmWZz1zVO/Kqw4Fw==
X-Received: by 2002:a62:65c3:: with SMTP id z186mr24280158pfb.46.1589339975913;
        Tue, 12 May 2020 20:19:35 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.1])
        by smtp.gmail.com with ESMTPSA id f70sm13206415pfa.17.2020.05.12.20.19.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 May 2020 20:19:35 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com
Subject: [PATCH v6 bpf-next 1/3] bpf, capability: Introduce CAP_BPF
Date:   Tue, 12 May 2020 20:19:28 -0700
Message-Id: <20200513031930.86895-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200513031930.86895-1-alexei.starovoitov@gmail.com>
References: <20200513031930.86895-1-alexei.starovoitov@gmail.com>
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
  BPF_PROG_TYPE_{SCHED_CLS, XDP, CGROUP_SKB, SK_SKB, etc}
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

