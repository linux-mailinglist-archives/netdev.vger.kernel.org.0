Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39F956F5E5
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 23:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfGUVcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 17:32:54 -0400
Received: from smtp-sh2.infomaniak.ch ([128.65.195.6]:47263 "EHLO
        smtp-sh2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfGUVcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 17:32:50 -0400
Received: from smtp7.infomaniak.ch (smtp7.infomaniak.ch [83.166.132.30])
        by smtp-sh2.infomaniak.ch (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id x6LLVXOm253784
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Jul 2019 23:31:33 +0200
Received: from localhost (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp7.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x6LLVWjo069732;
        Sun, 21 Jul 2019 23:31:33 +0200
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale <drysdale@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v10 02/10] bpf: Add expected_attach_triggers and a is_valid_triggers() verifier
Date:   Sun, 21 Jul 2019 23:31:08 +0200
Message-Id: <20190721213116.23476-3-mic@digikod.net>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190721213116.23476-1-mic@digikod.net>
References: <20190721213116.23476-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of the program triggers is to be able to have static triggers
(bitflags) conditionning an eBPF program interpretation.  This help to
avoid unnecessary runs.

The struct bpf_verifier_ops gets a new optional function:
is_valid_verifier(). This new verifier is called at the beginning of the
eBPF program verification to check if the (optional) program triggers
are valid.

For now, only Landlock eBPF programs are using program triggers (see
next commits) but this could be used by other program types in the
future.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lkml.kernel.org/r/20160827205559.GA43880@ast-mbp.thefacebook.com
---

Changes since v9:
* replace subtype with expected_attach_type (suggested by Alexei
  Starovoitov) and a new expected_attach_triggers
* add new bpf_attach_type: BPF_LANDLOCK_FS_PICK and BPF_LANDLOCK_FS_WALK
* remove bpf_prog_extra from bpf_base_func_proto()
* update libbpf and test_verifier to handle triggers

Changes since v8:
* use bpf_load_program_xattr() instead of bpf_load_program() and add
  bpf_verify_program_xattr() to deal with subtypes
* remove put_extra() since there is no more "previous" field (for now)

Changes since v7:
* rename LANDLOCK_SUBTYPE_* to LANDLOCK_*
* move subtype in bpf_prog_aux and use only one bit for has_subtype
  (suggested by Alexei Starovoitov)
* wrap the prog_subtype with a prog_extra to be able to reference kernel
  pointers:
  * add an optional put_extra() function to struct bpf_prog_ops to be
    able to free the pointed data
  * replace all the prog_subtype with prog_extra in the struct
    bpf_verifier_ops functions
* remove the ABI field (requested by Alexei Starovoitov)
* rename subtype fields

Changes since v6:
* rename Landlock version to ABI to better reflect its purpose
* fix unsigned integer checks
* fix pointer cast
* constify pointers
* rebase

Changes since v5:
* use a prog_subtype pointer and make it future-proof
* add subtype test
* constify bpf_load_program()'s subtype argument
* cleanup subtype initialization
* rebase

Changes since v4:
* replace the "status" field with "version" (more generic)
* replace the "access" field with "ability" (less confusing)

Changes since v3:
* remove the "origin" field
* add an "option" field
* cleanup comments
---
 include/linux/bpf.h            |  2 ++
 include/linux/bpf_types.h      |  3 +++
 include/uapi/linux/bpf.h       |  3 +++
 kernel/bpf/syscall.c           | 14 +++++++++++++-
 kernel/bpf/verifier.c          | 11 +++++++++++
 tools/include/uapi/linux/bpf.h |  3 +++
 tools/lib/bpf/bpf.h            |  1 +
 tools/lib/bpf/libbpf.map       |  1 +
 8 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 18f4cc2c6acd..6d9c7a08713e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -319,6 +319,7 @@ struct bpf_verifier_ops {
 				  const struct bpf_insn *src,
 				  struct bpf_insn *dst,
 				  struct bpf_prog *prog, u32 *target_size);
+	bool (*is_valid_triggers)(const struct bpf_prog *prog);
 };
 
 struct bpf_prog_offload_ops {
@@ -418,6 +419,7 @@ struct bpf_prog_aux {
 		struct work_struct work;
 		struct rcu_head	rcu;
 	};
+	u64 expected_attach_triggers;
 };
 
 struct bpf_array {
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index eec5aeeeaf92..2ab647323f3a 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -38,6 +38,9 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2)
 #ifdef CONFIG_INET
 BPF_PROG_TYPE(BPF_PROG_TYPE_SK_REUSEPORT, sk_reuseport)
 #endif
+#ifdef CONFIG_SECURITY_LANDLOCK
+BPF_PROG_TYPE(BPF_PROG_TYPE_LANDLOCK_HOOK, landlock)
+#endif
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6f68438aa4ed..1664d260861b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -197,6 +197,8 @@ enum bpf_attach_type {
 	BPF_CGROUP_UDP6_RECVMSG,
 	BPF_CGROUP_GETSOCKOPT,
 	BPF_CGROUP_SETSOCKOPT,
+	BPF_LANDLOCK_FS_PICK,
+	BPF_LANDLOCK_FS_WALK,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -412,6 +414,7 @@ union bpf_attr {
 		__u32		line_info_rec_size;	/* userspace bpf_line_info size */
 		__aligned_u64	line_info;	/* line info */
 		__u32		line_info_cnt;	/* number of bpf_line_info records */
+		__aligned_u64	expected_attach_triggers;	/* bitfield of triggers, e.g. LANDLOCK_TRIGGER_* */
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 5d141f16f6fa..b2a8cb14f28e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1598,13 +1598,23 @@ bpf_prog_load_check_attach_type(enum bpf_prog_type prog_type,
 		default:
 			return -EINVAL;
 		}
+#ifdef CONFIG_SECURITY_LANDLOCK
+	case BPF_PROG_TYPE_LANDLOCK_HOOK:
+		switch (expected_attach_type) {
+		case BPF_LANDLOCK_FS_PICK:
+		case BPF_LANDLOCK_FS_WALK:
+			return 0;
+		default:
+			return -EINVAL;
+		}
+#endif
 	default:
 		return 0;
 	}
 }
 
 /* last field in 'union bpf_attr' used by this command */
-#define	BPF_PROG_LOAD_LAST_FIELD line_info_cnt
+#define	BPF_PROG_LOAD_LAST_FIELD expected_attach_triggers
 
 static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 {
@@ -1694,6 +1704,8 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	if (err)
 		goto free_prog;
 
+	prog->aux->expected_attach_triggers = attr->expected_attach_triggers;
+
 	/* run eBPF verifier */
 	err = bpf_check(&prog, attr, uattr);
 	if (err < 0)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a2e763703c30..94a43d7c8175 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9265,6 +9265,17 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (ret < 0)
 		goto skip_full_check;
 
+	if (env->ops->is_valid_triggers) {
+		if (!env->ops->is_valid_triggers(env->prog)) {
+			ret = -EINVAL;
+			goto err_unlock;
+		}
+	} else if (env->prog->aux->expected_attach_triggers) {
+		/* do not accept triggers if they are not handled */
+		ret = -EINVAL;
+		goto err_unlock;
+	}
+
 	if (bpf_prog_is_dev_bound(env->prog->aux)) {
 		ret = bpf_prog_offload_verifier_prep(env->prog);
 		if (ret)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f506c68b2612..232747393405 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -197,6 +197,8 @@ enum bpf_attach_type {
 	BPF_CGROUP_UDP6_RECVMSG,
 	BPF_CGROUP_GETSOCKOPT,
 	BPF_CGROUP_SETSOCKOPT,
+	BPF_LANDLOCK_FS_PICK,
+	BPF_LANDLOCK_FS_WALK,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -412,6 +414,7 @@ union bpf_attr {
 		__u32		line_info_rec_size;	/* userspace bpf_line_info size */
 		__aligned_u64	line_info;	/* line info */
 		__u32		line_info_cnt;	/* number of bpf_line_info records */
+		__aligned_u64	expected_attach_triggers;	/* bitfield of triggers, e.g. LANDLOCK_TRIGGER_* */
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index ff42ca043dc8..468bb3ac0be0 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -102,6 +102,7 @@ LIBBPF_API int bpf_load_program(enum bpf_prog_type type,
 				const struct bpf_insn *insns, size_t insns_cnt,
 				const char *license, __u32 kern_version,
 				char *log_buf, size_t log_buf_sz);
+LIBBPF_API int bpf_verify_program_xattr(union bpf_attr *attr, size_t attr_sz);
 LIBBPF_API int bpf_verify_program(enum bpf_prog_type type,
 				  const struct bpf_insn *insns,
 				  size_t insns_cnt, __u32 prog_flags,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index f9d316e873d8..36ac26bdfda0 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -107,6 +107,7 @@ LIBBPF_0.0.1 {
 		bpf_set_link_xdp_fd;
 		bpf_task_fd_query;
 		bpf_verify_program;
+		bpf_verify_program_xattr;
 		btf__fd;
 		btf__find_by_name;
 		btf__free;
-- 
2.22.0

