Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3610B48C58E
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353967AbiALOE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353942AbiALOEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:04:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA42DC06175D;
        Wed, 12 Jan 2022 06:04:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A6B760BA0;
        Wed, 12 Jan 2022 14:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E4CC36AE5;
        Wed, 12 Jan 2022 14:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641996253;
        bh=AQZsBKlvjmmS4Et2w8pOxGb2swLZ6ZWiHMtyT66wAnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCVQnCbvtit0iQr5GqTTCREni+sECr0Wij1XIs9cgVzbhIFbV5OvWevMOOBqmsXuK
         Co+Lsfd1l9uunqZYLeo7UQ3rstj7+lz/R0MPNsxNpFpfcpCZVgEdkIs8RRZbjQm2eO
         AJg/MBMSqkjF/xrQHl+qOIcZYeHrfwGpPE7HLoFWaMrHV2RfmdGimNg3ke9KQm6RbH
         kpK5jh0w6NShnnvIBHn6l3W/b+UpLxE65KDPU8fKP9D1Xv5PRnCZxc5X/7AvzZI0qH
         n406gkS6BsXCTfkR0MK0JeQw7DrHHalcQ5o5Go79WyX8oiHXytdp2A/vMugbG4zjrU
         IiNKyJCUQ1dTA==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [RFC PATCH v2 7/8] bpf: Add kprobe link for attaching raw kprobes
Date:   Wed, 12 Jan 2022 23:04:07 +0900
Message-Id: <164199624758.1247129.1566911813214393074.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164199616622.1247129.783024987490980883.stgit@devnote2>
References: <164199616622.1247129.783024987490980883.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding new link type BPF_LINK_TYPE_KPROBE to attach so called
"kprobes" directly through fprobe API. Note that since the
using kprobes with multiple same handler is not efficient,
this uses the fprobe which natively support multiple probe
points for one same handler, but limited on function entry
and exit.

Adding new attach type BPF_TRACE_RAW_KPROBE that enables
such link for kprobe program.

The new link allows to create multiple kprobes link by using
new link_create interface:

  struct {
    __aligned_u64   addrs;
    __u32           cnt;
    __u64           bpf_cookie;
  } kprobe;

Plus new flag BPF_F_KPROBE_RETURN for link_create.flags to
create return probe.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 include/linux/bpf_types.h      |    1 
 include/uapi/linux/bpf.h       |   12 ++
 kernel/bpf/syscall.c           |  195 +++++++++++++++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h |   12 ++
 4 files changed, 215 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 48a91c51c015..a9000feab34e 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -140,3 +140,4 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_XDP, xdp)
 #ifdef CONFIG_PERF_EVENTS
 BPF_LINK_TYPE(BPF_LINK_TYPE_PERF_EVENT, perf)
 #endif
+BPF_LINK_TYPE(BPF_LINK_TYPE_KPROBE, kprobe)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ba5af15e25f5..10e9b56a074e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -995,6 +995,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_TRACE_RAW_KPROBE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1009,6 +1010,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_KPROBE = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1111,6 +1113,11 @@ enum bpf_link_type {
  */
 #define BPF_F_SLEEPABLE		(1U << 4)
 
+/* link_create flags used in LINK_CREATE command for BPF_TRACE_RAW_KPROBE
+ * attach type.
+ */
+#define BPF_F_KPROBE_RETURN	(1U << 0)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
@@ -1463,6 +1470,11 @@ union bpf_attr {
 				 */
 				__u64		bpf_cookie;
 			} perf_event;
+			struct {
+				__aligned_u64	addrs;
+				__u32		cnt;
+				__u64		bpf_cookie;
+			} kprobe;
 		};
 	} link_create;
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 1033ee8c0caf..066fac3cfaa5 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -31,6 +31,7 @@
 #include <linux/bpf-netns.h>
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
+#include <linux/fprobe.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -3013,8 +3014,182 @@ static int bpf_perf_link_attach(const union bpf_attr *attr, struct bpf_prog *pro
 	fput(perf_file);
 	return err;
 }
+#else
+static int bpf_perf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	return -ENOTSUPP;
+}
 #endif /* CONFIG_PERF_EVENTS */
 
+#ifdef CONFIG_FPROBE
+
+/* Note that this is called 'kprobe_link' but using fprobe inside */
+struct bpf_kprobe_link {
+	struct bpf_link link;
+	struct fprobe fp;
+	bool is_return;
+	unsigned long *addrs;
+	u32 cnt;
+	u64 bpf_cookie;
+};
+
+static void bpf_kprobe_link_release(struct bpf_link *link)
+{
+	struct bpf_kprobe_link *kprobe_link;
+
+	kprobe_link = container_of(link, struct bpf_kprobe_link, link);
+
+	unregister_fprobe(&kprobe_link->fp);
+}
+
+static void bpf_kprobe_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_kprobe_link *kprobe_link;
+
+	kprobe_link = container_of(link, struct bpf_kprobe_link, link);
+	kfree(kprobe_link->addrs);
+	kfree(kprobe_link);
+}
+
+static const struct bpf_link_ops bpf_kprobe_link_lops = {
+	.release = bpf_kprobe_link_release,
+	.dealloc = bpf_kprobe_link_dealloc,
+};
+
+static int kprobe_link_prog_run(struct bpf_kprobe_link *kprobe_link,
+				struct pt_regs *regs)
+{
+	struct bpf_trace_run_ctx run_ctx;
+	struct bpf_run_ctx *old_run_ctx;
+	int err;
+
+	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
+		err = 0;
+		goto out;
+	}
+
+	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
+	run_ctx.bpf_cookie = kprobe_link->bpf_cookie;
+
+	rcu_read_lock();
+	migrate_disable();
+	err = bpf_prog_run(kprobe_link->link.prog, regs);
+	migrate_enable();
+	rcu_read_unlock();
+
+	bpf_reset_run_ctx(old_run_ctx);
+
+ out:
+	__this_cpu_dec(bpf_prog_active);
+	return err;
+}
+
+static void kprobe_link_entry_handler(struct fprobe *fp, unsigned long entry_ip,
+				      struct pt_regs *regs)
+{
+	struct bpf_kprobe_link *kprobe_link;
+
+	/*
+	 * Because fprobe's regs->ip is set to the next instruction of
+	 * dynamic-ftrace insturction, correct entry ip must be set, so
+	 * that the bpf program can access entry address via regs as same
+	 * as kprobes.
+	 */
+	instruction_pointer_set(regs, entry_ip);
+	kprobe_link = container_of(fp, struct bpf_kprobe_link, fp);
+	kprobe_link_prog_run(kprobe_link, regs);
+}
+
+static void kprobe_link_exit_handler(struct fprobe *fp, unsigned long entry_ip,
+				     struct pt_regs *regs)
+{
+	struct bpf_kprobe_link *kprobe_link;
+
+	kprobe_link = container_of(fp, struct bpf_kprobe_link, fp);
+	kprobe_link_prog_run(kprobe_link, regs);
+}
+
+static int bpf_kprobe_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	struct bpf_link_primer link_primer;
+	struct bpf_kprobe_link *link = NULL;
+	unsigned long *addrs;
+	u32 flags, cnt, size;
+	void __user *uaddrs;
+	u64 **tmp;
+	int err;
+
+	flags = attr->link_create.flags;
+	if (flags & ~BPF_F_KPROBE_RETURN)
+		return -EINVAL;
+
+	uaddrs = u64_to_user_ptr(attr->link_create.kprobe.addrs);
+	cnt = attr->link_create.kprobe.cnt;
+	size = cnt * sizeof(*tmp);
+
+	tmp = kzalloc(size, GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
+	if (copy_from_user(tmp, uaddrs, size)) {
+		err = -EFAULT;
+		goto error;
+	}
+
+	/* TODO add extra copy for 32bit archs */
+	if (sizeof(u64) != sizeof(void *)) {
+		err = -EINVAL;
+		goto error;
+	}
+
+	addrs = (unsigned long *) tmp;
+
+	link = kzalloc(sizeof(*link), GFP_KERNEL);
+	if (!link) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_KPROBE, &bpf_kprobe_link_lops, prog);
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err)
+		goto error;
+
+	link->is_return = flags & BPF_F_KPROBE_RETURN;
+	link->addrs = addrs;
+	link->cnt = cnt;
+	link->bpf_cookie = attr->link_create.kprobe.bpf_cookie;
+
+	link->fp.addrs = addrs;
+	link->fp.nentry = cnt;
+
+	if (link->is_return)
+		link->fp.exit_handler = kprobe_link_exit_handler;
+	else
+		link->fp.entry_handler = kprobe_link_entry_handler;
+
+	err = register_fprobe(&link->fp);
+	if (err) {
+		bpf_link_cleanup(&link_primer);
+		goto error;
+	}
+
+	return bpf_link_settle(&link_primer);
+
+error:
+	kfree(link);
+	kfree(tmp);
+
+	return err;
+}
+#else /* !CONFIG_FPROBE */
+static int bpf_kprobe_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	return -ENOTSUPP;
+}
+#endif
+
 #define BPF_RAW_TRACEPOINT_OPEN_LAST_FIELD raw_tracepoint.prog_fd
 
 static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
@@ -4241,7 +4416,7 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 	return -EINVAL;
 }
 
-#define BPF_LINK_CREATE_LAST_FIELD link_create.iter_info_len
+#define BPF_LINK_CREATE_LAST_FIELD link_create.kprobe.bpf_cookie
 static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 {
 	enum bpf_prog_type ptype;
@@ -4265,7 +4440,6 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 		ret = tracing_bpf_link_attach(attr, uattr, prog);
 		goto out;
 	case BPF_PROG_TYPE_PERF_EVENT:
-	case BPF_PROG_TYPE_KPROBE:
 	case BPF_PROG_TYPE_TRACEPOINT:
 		if (attr->link_create.attach_type != BPF_PERF_EVENT) {
 			ret = -EINVAL;
@@ -4273,6 +4447,14 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 		}
 		ptype = prog->type;
 		break;
+	case BPF_PROG_TYPE_KPROBE:
+		if (attr->link_create.attach_type != BPF_PERF_EVENT &&
+		    attr->link_create.attach_type != BPF_TRACE_RAW_KPROBE) {
+			ret = -EINVAL;
+			goto out;
+		}
+		ptype = prog->type;
+		break;
 	default:
 		ptype = attach_type_to_prog_type(attr->link_create.attach_type);
 		if (ptype == BPF_PROG_TYPE_UNSPEC || ptype != prog->type) {
@@ -4304,13 +4486,16 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
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
+			ret = bpf_kprobe_link_attach(attr, prog);
+		break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ba5af15e25f5..10e9b56a074e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -995,6 +995,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_TRACE_RAW_KPROBE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1009,6 +1010,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_KPROBE = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1111,6 +1113,11 @@ enum bpf_link_type {
  */
 #define BPF_F_SLEEPABLE		(1U << 4)
 
+/* link_create flags used in LINK_CREATE command for BPF_TRACE_RAW_KPROBE
+ * attach type.
+ */
+#define BPF_F_KPROBE_RETURN	(1U << 0)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
@@ -1463,6 +1470,11 @@ union bpf_attr {
 				 */
 				__u64		bpf_cookie;
 			} perf_event;
+			struct {
+				__aligned_u64	addrs;
+				__u32		cnt;
+				__u64		bpf_cookie;
+			} kprobe;
 		};
 	} link_create;
 

