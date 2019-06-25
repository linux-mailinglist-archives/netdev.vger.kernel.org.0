Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E175655A92
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFYWEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:04:53 -0400
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:48203 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfFYWEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:04:53 -0400
Received: from smtp5.infomaniak.ch (smtp5.infomaniak.ch [83.166.132.18])
        by smtp-sh.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrIZC019790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 23:53:18 +0200
Received: from localhost (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp5.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrHgZ038672;
        Tue, 25 Jun 2019 23:53:17 +0200
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Aleksa Sarai <cyphar@cyphar.com>,
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
Subject: [PATCH bpf-next v9 02/10] bpf: Add eBPF program subtype and is_valid_subtype() verifier
Date:   Tue, 25 Jun 2019 23:52:31 +0200
Message-Id: <20190625215239.11136-3-mic@digikod.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625215239.11136-1-mic@digikod.net>
References: <20190625215239.11136-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of the program subtype is to be able to have different static
fine-grained verifications for a unique program type.

The struct bpf_verifier_ops gets a new optional function:
is_valid_subtype(). This new verifier is called at the beginning of the
eBPF program verification to check if the (optional) program subtype is
valid.

The new helper bpf_load_program_xattr() enables to verify a program with
subtypes.

For now, only Landlock eBPF programs are using a program subtype (see
next commits) but this could be used by other program types in the
future.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lkml.kernel.org/r/20160827205559.GA43880@ast-mbp.thefacebook.com
---

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
 include/linux/bpf.h                           |  8 +++++
 include/uapi/linux/bpf.h                      |  9 ++++++
 kernel/bpf/core.c                             |  1 +
 kernel/bpf/syscall.c                          | 32 ++++++++++++++++++-
 kernel/bpf/verifier.c                         | 11 +++++++
 net/core/filter.c                             | 25 ++++++++-------
 tools/include/uapi/linux/bpf.h                |  9 ++++++
 tools/lib/bpf/bpf.c                           | 10 +++++-
 tools/lib/bpf/bpf.h                           |  2 ++
 tools/lib/bpf/libbpf.map                      |  1 +
 tools/testing/selftests/bpf/test_verifier.c   | 26 +++++++++++++--
 .../testing/selftests/bpf/verifier/subtype.c  | 10 ++++++
 12 files changed, 128 insertions(+), 16 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/subtype.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a62e7889b0b6..da167d3afecc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -294,6 +294,11 @@ bpf_ctx_record_field_size(struct bpf_insn_access_aux *aux, u32 size)
 	aux->ctx_field_size = size;
 }
 
+/* specific data per program type */
+struct bpf_prog_extra {
+	union bpf_prog_subtype subtype;
+};
+
 struct bpf_prog_ops {
 	int (*test_run)(struct bpf_prog *prog, const union bpf_attr *kattr,
 			union bpf_attr __user *uattr);
@@ -319,6 +324,8 @@ struct bpf_verifier_ops {
 				  const struct bpf_insn *src,
 				  struct bpf_insn *dst,
 				  struct bpf_prog *prog, u32 *target_size);
+	// TODO?: convert to bool (*is_valid_subtype)(struct bpf_prog *prog);
+	bool (*is_valid_subtype)(struct bpf_prog_extra *prog_extra);
 };
 
 struct bpf_prog_offload_ops {
@@ -418,6 +425,7 @@ struct bpf_prog_aux {
 		struct work_struct work;
 		struct rcu_head	rcu;
 	};
+	struct bpf_prog_extra *extra;
 };
 
 struct bpf_array {
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b077507efa3f..ddae50373d58 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -355,6 +355,13 @@ struct bpf_stack_build_id {
 	};
 };
 
+union bpf_prog_subtype {
+	struct {
+		__u32		type; /* enum landlock_hook_type */
+		__aligned_u64	triggers; /* LANDLOCK_TRIGGER_* */
+	} landlock_hook;
+} __attribute__((aligned(8)));
+
 union bpf_attr {
 	struct { /* anonymous struct used by BPF_MAP_CREATE command */
 		__u32	map_type;	/* one of enum bpf_map_type */
@@ -409,6 +416,8 @@ union bpf_attr {
 		__u32		line_info_rec_size;	/* userspace bpf_line_info size */
 		__aligned_u64	line_info;	/* line info */
 		__u32		line_info_cnt;	/* number of bpf_line_info records */
+		__aligned_u64	prog_subtype;	/* bpf_prog_subtype address */
+		__u32		prog_subtype_size;
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ad3be85f1411..8ad392e52328 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -255,6 +255,7 @@ void __bpf_prog_free(struct bpf_prog *fp)
 {
 	if (fp->aux) {
 		free_percpu(fp->aux->stats);
+		kfree(fp->aux->extra);
 		kfree(fp->aux);
 	}
 	vfree(fp);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 7713cf39795a..7dd3376904d4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1596,7 +1596,7 @@ bpf_prog_load_check_attach_type(enum bpf_prog_type prog_type,
 }
 
 /* last field in 'union bpf_attr' used by this command */
-#define	BPF_PROG_LOAD_LAST_FIELD line_info_cnt
+#define	BPF_PROG_LOAD_LAST_FIELD prog_subtype_size
 
 static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 {
@@ -1686,6 +1686,36 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	if (err)
 		goto free_prog;
 
+	/* copy eBPF program subtype from user space */
+	if (attr->prog_subtype) {
+		u32 size;
+
+		err = bpf_check_uarg_tail_zero(
+				u64_to_user_ptr(attr->prog_subtype),
+				sizeof(prog->aux->extra->subtype),
+				attr->prog_subtype_size);
+		if (err)
+			goto free_prog;
+		size = min_t(u32, attr->prog_subtype_size,
+			     sizeof(prog->aux->extra->subtype));
+
+		prog->aux->extra = kzalloc(sizeof(*prog->aux->extra),
+					   GFP_KERNEL | GFP_USER);
+		if (!prog->aux->extra) {
+			err = -ENOMEM;
+			goto free_prog;
+		}
+		if (copy_from_user(&prog->aux->extra->subtype,
+				   u64_to_user_ptr(attr->prog_subtype), size)
+				   != 0) {
+			err = -EFAULT;
+			goto free_prog;
+		}
+	} else if (attr->prog_subtype_size != 0) {
+		err = -EINVAL;
+		goto free_prog;
+	}
+
 	/* run eBPF verifier */
 	err = bpf_check(&prog, attr, uattr);
 	if (err < 0)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0e079b2298f8..930260683d0a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9167,6 +9167,17 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (ret < 0)
 		goto skip_full_check;
 
+	if (env->ops->is_valid_subtype) {
+		if (!env->ops->is_valid_subtype(env->prog->aux->extra)) {
+			ret = -EINVAL;
+			goto err_unlock;
+		}
+	} else if (env->prog->aux->extra) {
+		/* do not accept a subtype if the program does not handle it */
+		ret = -EINVAL;
+		goto err_unlock;
+	}
+
 	if (bpf_prog_is_dev_bound(env->prog->aux)) {
 		ret = bpf_prog_offload_verifier_prep(env->prog);
 		if (ret)
diff --git a/net/core/filter.c b/net/core/filter.c
index 2014d76e0d2a..0160237e5cd8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5846,7 +5846,8 @@ bool bpf_helper_changes_pkt_data(void *func)
 }
 
 static const struct bpf_func_proto *
-bpf_base_func_proto(enum bpf_func_id func_id)
+bpf_base_func_proto(enum bpf_func_id func_id,
+		    const struct bpf_prog_extra *prog_extra)
 {
 	switch (func_id) {
 	case BPF_FUNC_map_lookup_elem:
@@ -5902,7 +5903,7 @@ sock_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_get_local_storage:
 		return &bpf_get_local_storage_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog->aux->extra);
 	}
 }
 
@@ -5942,7 +5943,7 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_sk_storage_delete:
 		return &bpf_sk_storage_delete_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog->aux->extra);
 	}
 }
 
@@ -5959,7 +5960,7 @@ sk_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_get_socket_uid:
 		return &bpf_get_socket_uid_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog->aux->extra);
 	}
 }
 
@@ -6096,7 +6097,7 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_skb_ecn_set_ce_proto;
 #endif
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog->aux->extra);
 	}
 }
 
@@ -6135,7 +6136,7 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_tcp_check_syncookie_proto;
 #endif
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog->aux->extra);
 	}
 }
 
@@ -6171,7 +6172,7 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_tcp_sock_proto;
 #endif /* CONFIG_INET */
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog->aux->extra);
 	}
 }
 
@@ -6197,7 +6198,7 @@ sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_msg_pop_data:
 		return &bpf_msg_pop_data_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog->aux->extra);
 	}
 }
 
@@ -6237,7 +6238,7 @@ sk_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_skc_lookup_tcp_proto;
 #endif
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog->aux->extra);
 	}
 }
 
@@ -6248,7 +6249,7 @@ flow_dissector_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_skb_load_bytes:
 		return &bpf_flow_dissector_load_bytes_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog->aux->extra);
 	}
 }
 
@@ -6275,7 +6276,7 @@ lwt_out_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_skb_under_cgroup:
 		return &bpf_skb_under_cgroup_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog->aux->extra);
 	}
 }
 
@@ -8611,7 +8612,7 @@ sk_reuseport_func_proto(enum bpf_func_id func_id,
 	case BPF_FUNC_skb_load_bytes_relative:
 		return &sk_reuseport_load_bytes_relative_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog->aux->extra);
 	}
 }
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b077507efa3f..ddae50373d58 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -355,6 +355,13 @@ struct bpf_stack_build_id {
 	};
 };
 
+union bpf_prog_subtype {
+	struct {
+		__u32		type; /* enum landlock_hook_type */
+		__aligned_u64	triggers; /* LANDLOCK_TRIGGER_* */
+	} landlock_hook;
+} __attribute__((aligned(8)));
+
 union bpf_attr {
 	struct { /* anonymous struct used by BPF_MAP_CREATE command */
 		__u32	map_type;	/* one of enum bpf_map_type */
@@ -409,6 +416,8 @@ union bpf_attr {
 		__u32		line_info_rec_size;	/* userspace bpf_line_info size */
 		__aligned_u64	line_info;	/* line info */
 		__u32		line_info_cnt;	/* number of bpf_line_info records */
+		__aligned_u64	prog_subtype;	/* bpf_prog_subtype address */
+		__u32		prog_subtype_size;
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index c7d7993c44bb..ecd894344bbd 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -227,6 +227,9 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 
 	memset(&attr, 0, sizeof(attr));
 	attr.prog_type = load_attr->prog_type;
+	attr.prog_subtype = ptr_to_u64(load_attr->prog_subtype);
+	attr.prog_subtype_size = load_attr->prog_subtype ?
+		sizeof(*load_attr->prog_subtype) : 0;
 	attr.expected_attach_type = load_attr->expected_attach_type;
 	attr.insn_cnt = (__u32)load_attr->insns_cnt;
 	attr.insns = ptr_to_u64(load_attr->insns);
@@ -332,6 +335,11 @@ int bpf_load_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 	return bpf_load_program_xattr(&load_attr, log_buf, log_buf_sz);
 }
 
+int bpf_verify_program_xattr(union bpf_attr *attr, size_t attr_sz)
+{
+	return sys_bpf_prog_load(attr, attr_sz);
+}
+
 int bpf_verify_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 		       size_t insns_cnt, __u32 prog_flags, const char *license,
 		       __u32 kern_version, char *log_buf, size_t log_buf_sz,
@@ -351,7 +359,7 @@ int bpf_verify_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 	attr.kern_version = kern_version;
 	attr.prog_flags = prog_flags;
 
-	return sys_bpf_prog_load(&attr, sizeof(attr));
+	return bpf_verify_program_xattr(&attr, sizeof(attr));
 }
 
 int bpf_map_update_elem(int fd, const void *key, const void *value,
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index ff42ca043dc8..7cd600d49f9e 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -88,6 +88,7 @@ struct bpf_load_program_attr {
 	__u32 line_info_cnt;
 	__u32 log_level;
 	__u32 prog_flags;
+	const union bpf_prog_subtype *prog_subtype;
 };
 
 /* Flags to direct loading requirements */
@@ -102,6 +103,7 @@ LIBBPF_API int bpf_load_program(enum bpf_prog_type type,
 				const struct bpf_insn *insns, size_t insns_cnt,
 				const char *license, __u32 kern_version,
 				char *log_buf, size_t log_buf_sz);
+LIBBPF_API int bpf_verify_program_xattr(union bpf_attr *attr, size_t attr_sz);
 LIBBPF_API int bpf_verify_program(enum bpf_prog_type type,
 				  const struct bpf_insn *insns,
 				  size_t insns_cnt, __u32 prog_flags,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 2c6d835620d2..48c9269a0496 100644
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
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index c5514daf8865..93faffd31fc3 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -105,6 +105,8 @@ struct bpf_test {
 			__u64 data64[TEST_DATA_LEN / 8];
 		};
 	} retvals[MAX_TEST_RUNS];
+	bool has_prog_subtype;
+	union bpf_prog_subtype prog_subtype;
 };
 
 /* Note we want this to be 64 bit aligned so that the end of our array is
@@ -122,6 +124,11 @@ struct other_val {
 	long long bar;
 };
 
+static inline __u64 ptr_to_u64(const void *ptr)
+{
+	return (__u64) (unsigned long) ptr;
+}
+
 static void bpf_fill_ld_abs_vlan_push_pop(struct bpf_test *self)
 {
 	/* test: {skb->data[0], vlan_push} x 51 + {skb->data[0], vlan_pop} x 51 */
@@ -856,6 +863,9 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	int fixup_skips;
 	__u32 pflags;
 	int i, err;
+	union bpf_attr attr;
+	union bpf_prog_subtype *prog_subtype =
+		test->has_prog_subtype ? &test->prog_subtype : NULL;
 
 	for (i = 0; i < MAX_NR_MAPS; i++)
 		map_fds[i] = -1;
@@ -881,8 +891,20 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 		pflags |= BPF_F_STRICT_ALIGNMENT;
 	if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
 		pflags |= BPF_F_ANY_ALIGNMENT;
-	fd_prog = bpf_verify_program(prog_type, prog, prog_len, pflags,
-				     "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 4);
+
+	memset(&attr, 0, sizeof(attr));
+	attr.prog_type = prog_type;
+	attr.prog_subtype = ptr_to_u64(prog_subtype);
+	attr.prog_subtype_size = prog_subtype ? sizeof(*prog_subtype) : 0;
+	attr.insn_cnt = (__u32)prog_len;
+	attr.insns = ptr_to_u64(prog);
+	attr.license = ptr_to_u64("GPL");
+	bpf_vlog[0] = 0;
+	attr.log_buf = ptr_to_u64(bpf_vlog);
+	attr.log_size = sizeof(bpf_vlog);
+	attr.log_level = 4;
+	attr.prog_flags = pflags;
+	fd_prog = bpf_verify_program_xattr(&attr, sizeof(attr));
 	if (fd_prog < 0 && !bpf_probe_prog_type(prog_type, 0)) {
 		printf("SKIP (unsupported program type %d)\n", prog_type);
 		skips++;
diff --git a/tools/testing/selftests/bpf/verifier/subtype.c b/tools/testing/selftests/bpf/verifier/subtype.c
new file mode 100644
index 000000000000..cf614223d53f
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/subtype.c
@@ -0,0 +1,10 @@
+{
+	"superfluous subtype",
+	.insns = {
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "",
+	.result = REJECT,
+	.has_prog_subtype = true,
+},
-- 
2.20.1

