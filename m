Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0B84DAF9D
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355667AbiCPM0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355649AbiCPM0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:26:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257A24EA08;
        Wed, 16 Mar 2022 05:25:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7285E61735;
        Wed, 16 Mar 2022 12:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF32C340F8;
        Wed, 16 Mar 2022 12:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647433500;
        bh=mOeD/oOG5sZ6FKYaF27d4IwtMmYNkrxYnVizFqV8Y5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oD4K0anTvRaiGkIBw+HLhvsRmSbrT2Yr9pYU69sJFeB0E/nqLvSIkDqqj9DDZkIe7
         OFP1kZgGUXsBo3ojkamvf1eI5YuwK4XCBl2euMVmIrMlSeIHMnF2ryGA++xuHWwHR7
         dHgkrXAOfBtoY0XsC51sYDAQxh88vcEnkQjhoUWTLyoMC24+yoCdm9G6VeLpM70Ros
         3azx7IyRgf98y0b0aKabFGzNb+UZ53GDuTLokzfbKmprWulgOqJ2QWAE7ds52gDlAf
         nbovBVS8vVFyhz39JSPClwV798InleMSyam7wRsYIx4cZmc6w932ENIyeyOfujjCql
         0heDmxT98hMWQ==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCHv3 bpf-next 03/13] bpf: Add multi kprobe link
Date:   Wed, 16 Mar 2022 13:24:09 +0100
Message-Id: <20220316122419.933957-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316122419.933957-1-jolsa@kernel.org>
References: <20220316122419.933957-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding new link type BPF_LINK_TYPE_KPROBE_MULTI that attaches kprobe
program through fprobe API.

The fprobe API allows to attach probe on multiple functions at once
very fast, because it works on top of ftrace. On the other hand this
limits the probe point to the function entry or return.

The kprobe program gets the same pt_regs input ctx as when it's attached
through the perf API.

Adding new attach type BPF_TRACE_KPROBE_MULTI that allows attachment
kprobe to multiple function with new link.

User provides array of addresses or symbols with count to attach the
kprobe program to. The new link_create uapi interface looks like:

  struct {
          __u32           flags;
          __u32           cnt;
          __aligned_u64   syms;
          __aligned_u64   addrs;
  } kprobe_multi;

The flags field allows single BPF_TRACE_KPROBE_MULTI bit to create
return multi kprobe.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf_types.h      |   1 +
 include/linux/trace_events.h   |   7 ++
 include/uapi/linux/bpf.h       |  13 ++
 kernel/bpf/syscall.c           |  26 +++-
 kernel/trace/bpf_trace.c       | 211 +++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  13 ++
 6 files changed, 266 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 48a91c51c015..3e24ad0c4b3c 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -140,3 +140,4 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_XDP, xdp)
 #ifdef CONFIG_PERF_EVENTS
 BPF_LINK_TYPE(BPF_LINK_TYPE_PERF_EVENT, perf)
 #endif
+BPF_LINK_TYPE(BPF_LINK_TYPE_KPROBE_MULTI, kprobe_multi)
diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index dcea51fb60e2..8f0e9e7cb493 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -15,6 +15,7 @@ struct array_buffer;
 struct tracer;
 struct dentry;
 struct bpf_prog;
+union bpf_attr;
 
 const char *trace_print_flags_seq(struct trace_seq *p, const char *delim,
 				  unsigned long flags,
@@ -738,6 +739,7 @@ void bpf_put_raw_tracepoint(struct bpf_raw_event_map *btp);
 int bpf_get_perf_event_info(const struct perf_event *event, u32 *prog_id,
 			    u32 *fd_type, const char **buf,
 			    u64 *probe_offset, u64 *probe_addr);
+int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
 #else
 static inline unsigned int trace_call_bpf(struct trace_event_call *call, void *ctx)
 {
@@ -779,6 +781,11 @@ static inline int bpf_get_perf_event_info(const struct perf_event *event,
 {
 	return -EOPNOTSUPP;
 }
+static inline int
+bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 enum {
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 99fab54ae9c0..d77f47af7752 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -997,6 +997,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_TRACE_KPROBE_MULTI,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1011,6 +1012,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_KPROBE_MULTI = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1118,6 +1120,11 @@ enum bpf_link_type {
  */
 #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
 
+/* link_create.kprobe_multi.flags used in LINK_CREATE command for
+ * BPF_TRACE_KPROBE_MULTI attach type to create return probe.
+ */
+#define BPF_F_KPROBE_MULTI_RETURN	(1U << 0)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
@@ -1475,6 +1482,12 @@ union bpf_attr {
 				 */
 				__u64		bpf_cookie;
 			} perf_event;
+			struct {
+				__u32		flags;
+				__u32		cnt;
+				__aligned_u64	syms;
+				__aligned_u64	addrs;
+			} kprobe_multi;
 		};
 	} link_create;
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 9beb585be5a6..b8bb67ee6c57 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -32,6 +32,7 @@
 #include <linux/bpf-netns.h>
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
+#include <linux/trace_events.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -3022,6 +3023,11 @@ static int bpf_perf_link_attach(const union bpf_attr *attr, struct bpf_prog *pro
 	fput(perf_file);
 	return err;
 }
+#else
+static int bpf_perf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_PERF_EVENTS */
 
 #define BPF_RAW_TRACEPOINT_OPEN_LAST_FIELD raw_tracepoint.prog_fd
@@ -4255,7 +4261,7 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 	return -EINVAL;
 }
 
-#define BPF_LINK_CREATE_LAST_FIELD link_create.iter_info_len
+#define BPF_LINK_CREATE_LAST_FIELD link_create.kprobe_multi.addrs
 static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 {
 	enum bpf_prog_type ptype;
@@ -4279,7 +4285,6 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 		ret = tracing_bpf_link_attach(attr, uattr, prog);
 		goto out;
 	case BPF_PROG_TYPE_PERF_EVENT:
-	case BPF_PROG_TYPE_KPROBE:
 	case BPF_PROG_TYPE_TRACEPOINT:
 		if (attr->link_create.attach_type != BPF_PERF_EVENT) {
 			ret = -EINVAL;
@@ -4287,6 +4292,14 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 		}
 		ptype = prog->type;
 		break;
+	case BPF_PROG_TYPE_KPROBE:
+		if (attr->link_create.attach_type != BPF_PERF_EVENT &&
+		    attr->link_create.attach_type != BPF_TRACE_KPROBE_MULTI) {
+			ret = -EINVAL;
+			goto out;
+		}
+		ptype = prog->type;
+		break;
 	default:
 		ptype = attach_type_to_prog_type(attr->link_create.attach_type);
 		if (ptype == BPF_PROG_TYPE_UNSPEC || ptype != prog->type) {
@@ -4318,13 +4331,16 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 		ret = bpf_xdp_link_attach(attr, prog);
 		break;
 #endif
-#ifdef CONFIG_PERF_EVENTS
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_TRACEPOINT:
-	case BPF_PROG_TYPE_KPROBE:
 		ret = bpf_perf_link_attach(attr, prog);
 		break;
-#endif
+	case BPF_PROG_TYPE_KPROBE:
+		if (attr->link_create.attach_type == BPF_PERF_EVENT)
+			ret = bpf_perf_link_attach(attr, prog);
+		else
+			ret = bpf_kprobe_multi_link_attach(attr, prog);
+		break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index a2024ba32a20..fffa2171fae4 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -17,6 +17,7 @@
 #include <linux/error-injection.h>
 #include <linux/btf_ids.h>
 #include <linux/bpf_lsm.h>
+#include <linux/fprobe.h>
 
 #include <net/bpf_sk_storage.h>
 
@@ -2181,3 +2182,213 @@ static int __init bpf_event_init(void)
 
 fs_initcall(bpf_event_init);
 #endif /* CONFIG_MODULES */
+
+#ifdef CONFIG_FPROBE
+struct bpf_kprobe_multi_link {
+	struct bpf_link link;
+	struct fprobe fp;
+	unsigned long *addrs;
+};
+
+static void bpf_kprobe_multi_link_release(struct bpf_link *link)
+{
+	struct bpf_kprobe_multi_link *kmulti_link;
+
+	kmulti_link = container_of(link, struct bpf_kprobe_multi_link, link);
+	unregister_fprobe(&kmulti_link->fp);
+}
+
+static void bpf_kprobe_multi_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_kprobe_multi_link *kmulti_link;
+
+	kmulti_link = container_of(link, struct bpf_kprobe_multi_link, link);
+	kvfree(kmulti_link->addrs);
+	kfree(kmulti_link);
+}
+
+static const struct bpf_link_ops bpf_kprobe_multi_link_lops = {
+	.release = bpf_kprobe_multi_link_release,
+	.dealloc = bpf_kprobe_multi_link_dealloc,
+};
+
+static int
+kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
+			   struct pt_regs *regs)
+{
+	int err;
+
+	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
+		err = 0;
+		goto out;
+	}
+
+	migrate_disable();
+	rcu_read_lock();
+	err = bpf_prog_run(link->link.prog, regs);
+	rcu_read_unlock();
+	migrate_enable();
+
+ out:
+	__this_cpu_dec(bpf_prog_active);
+	return err;
+}
+
+static void
+kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
+			  struct pt_regs *regs)
+{
+	unsigned long saved_ip = instruction_pointer(regs);
+	struct bpf_kprobe_multi_link *link;
+
+	/*
+	 * Because fprobe's regs->ip is set to the next instruction of
+	 * dynamic-ftrace instruction, correct entry ip must be set, so
+	 * that the bpf program can access entry address via regs as same
+	 * as kprobes.
+	 *
+	 * Both kprobe and kretprobe see the entry ip of traced function
+	 * as instruction pointer.
+	 */
+	instruction_pointer_set(regs, entry_ip);
+
+	link = container_of(fp, struct bpf_kprobe_multi_link, fp);
+	kprobe_multi_link_prog_run(link, regs);
+
+	instruction_pointer_set(regs, saved_ip);
+}
+
+static int
+kprobe_multi_resolve_syms(const void *usyms, u32 cnt,
+			  unsigned long *addrs)
+{
+	unsigned long addr, size;
+	const char **syms;
+	int err = -ENOMEM;
+	unsigned int i;
+	char *func;
+
+	size = cnt * sizeof(*syms);
+	syms = kvzalloc(size, GFP_KERNEL);
+	if (!syms)
+		return -ENOMEM;
+
+	func = kmalloc(KSYM_NAME_LEN, GFP_KERNEL);
+	if (!func)
+		goto error;
+
+	if (copy_from_user(syms, usyms, size)) {
+		err = -EFAULT;
+		goto error;
+	}
+
+	for (i = 0; i < cnt; i++) {
+		err = strncpy_from_user(func, syms[i], KSYM_NAME_LEN);
+		if (err == KSYM_NAME_LEN)
+			err = -E2BIG;
+		if (err < 0)
+			goto error;
+		err = -EINVAL;
+		addr = kallsyms_lookup_name(func);
+		if (!addr)
+			goto error;
+		if (!kallsyms_lookup_size_offset(addr, &size, NULL))
+			goto error;
+		addr = ftrace_location_range(addr, addr + size - 1);
+		if (!addr)
+			goto error;
+		addrs[i] = addr;
+	}
+
+	err = 0;
+error:
+	kvfree(syms);
+	kfree(func);
+	return err;
+}
+
+int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	struct bpf_kprobe_multi_link *link = NULL;
+	struct bpf_link_primer link_primer;
+	unsigned long *addrs;
+	u32 flags, cnt, size;
+	void __user *uaddrs;
+	void __user *usyms;
+	int err;
+
+	/* no support for 32bit archs yet */
+	if (sizeof(u64) != sizeof(void *))
+		return -EOPNOTSUPP;
+
+	if (prog->expected_attach_type != BPF_TRACE_KPROBE_MULTI)
+		return -EINVAL;
+
+	flags = attr->link_create.kprobe_multi.flags;
+	if (flags & ~BPF_F_KPROBE_MULTI_RETURN)
+		return -EINVAL;
+
+	uaddrs = u64_to_user_ptr(attr->link_create.kprobe_multi.addrs);
+	usyms = u64_to_user_ptr(attr->link_create.kprobe_multi.syms);
+	if (!!uaddrs == !!usyms)
+		return -EINVAL;
+
+	cnt = attr->link_create.kprobe_multi.cnt;
+	if (!cnt)
+		return -EINVAL;
+
+	size = cnt * sizeof(*addrs);
+	addrs = kvmalloc(size, GFP_KERNEL);
+	if (!addrs)
+		return -ENOMEM;
+
+	if (uaddrs) {
+		if (copy_from_user(addrs, uaddrs, size)) {
+			err = -EFAULT;
+			goto error;
+		}
+	} else {
+		err = kprobe_multi_resolve_syms(usyms, cnt, addrs);
+		if (err)
+			goto error;
+	}
+
+	link = kzalloc(sizeof(*link), GFP_KERNEL);
+	if (!link) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_KPROBE_MULTI,
+		      &bpf_kprobe_multi_link_lops, prog);
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err)
+		goto error;
+
+	if (flags & BPF_F_KPROBE_MULTI_RETURN)
+		link->fp.exit_handler = kprobe_multi_link_handler;
+	else
+		link->fp.entry_handler = kprobe_multi_link_handler;
+
+	link->addrs = addrs;
+
+	err = register_fprobe_ips(&link->fp, addrs, cnt);
+	if (err) {
+		bpf_link_cleanup(&link_primer);
+		return err;
+	}
+
+	return bpf_link_settle(&link_primer);
+
+error:
+	kfree(link);
+	kvfree(addrs);
+	return err;
+}
+#else /* !CONFIG_FPROBE */
+int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	return -EOPNOTSUPP;
+}
+#endif
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 99fab54ae9c0..d77f47af7752 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -997,6 +997,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_TRACE_KPROBE_MULTI,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1011,6 +1012,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_KPROBE_MULTI = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1118,6 +1120,11 @@ enum bpf_link_type {
  */
 #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
 
+/* link_create.kprobe_multi.flags used in LINK_CREATE command for
+ * BPF_TRACE_KPROBE_MULTI attach type to create return probe.
+ */
+#define BPF_F_KPROBE_MULTI_RETURN	(1U << 0)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
@@ -1475,6 +1482,12 @@ union bpf_attr {
 				 */
 				__u64		bpf_cookie;
 			} perf_event;
+			struct {
+				__u32		flags;
+				__u32		cnt;
+				__aligned_u64	syms;
+				__aligned_u64	addrs;
+			} kprobe_multi;
 		};
 	} link_create;
 
-- 
2.35.1

