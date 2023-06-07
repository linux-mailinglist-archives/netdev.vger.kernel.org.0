Return-Path: <netdev+bounces-9024-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 517627269BB
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:27:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00E622814EA
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D8939237;
	Wed,  7 Jun 2023 19:26:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B00A6118;
	Wed,  7 Jun 2023 19:26:41 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E8F1FDC;
	Wed,  7 Jun 2023 12:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=Bf6O+kSV0jfWqWpshgMNDyEp5rZhdeH2I3m46DcC2F4=; b=Z53+nfN6Qx0h4dGezI7PHbaiDZ
	PqsObpFDwV1QE/LbUKWXO9jyeKgZHRo4wfEDzdrbquzdsnQ67QLYULTrE0UppGteKsThyFsClpCZ+
	jtTWJNSpCOh1mqmoDPrSA8ukrwulq+l0BoKneLPa+2Z8X4XYf/LH/mNeWEO8l2P3VoFjOFxhW2Fcy
	YKOPsVn01GZSnZ7p/mnMbAl45riLerHZq69Ry9u2KF/0YYy2gCVhYeN1oY9t/u4P/lBvyPwuEfsrf
	LINf5dR6yuwA7KfM+I+83T41SCgdI7HICkG3XkcDWqQxDcIPjX1w5Rb+6bLrNAgHC65fI3HOZ63eO
	j+RvmcFA==;
Received: from 49.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.49] helo=localhost)
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q6yni-000CXU-B2; Wed, 07 Jun 2023 21:26:34 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
To: ast@kernel.org
Cc: andrii@kernel.org,
	martin.lau@linux.dev,
	razor@blackwall.org,
	sdf@google.com,
	john.fastabend@gmail.com,
	kuba@kernel.org,
	dxu@dxuuu.xyz,
	joe@cilium.io,
	toke@kernel.org,
	davem@davemloft.net,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API for multi-progs
Date: Wed,  7 Jun 2023 21:26:19 +0200
Message-Id: <20230607192625.22641-2-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230607192625.22641-1-daniel@iogearbox.net>
References: <20230607192625.22641-1-daniel@iogearbox.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26931/Wed Jun  7 09:23:57 2023)
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This adds a generic layer called bpf_mprog which can be reused by different
attachment layers to enable multi-program attachment and dependency resolution.
In-kernel users of the bpf_mprog don't need to care about the dependency
resolution internals, they can just consume it with few API calls.

The initial idea of having a generic API sparked out of discussion [0] from an
earlier revision of this work where tc's priority was reused and exposed via
BPF uapi as a way to coordinate dependencies among tc BPF programs, similar
as-is for classic tc BPF. The feedback was that priority provides a bad user
experience and is hard to use [1], e.g.:

  I cannot help but feel that priority logic copy-paste from old tc, netfilter
  and friends is done because "that's how things were done in the past". [...]
  Priority gets exposed everywhere in uapi all the way to bpftool when it's
  right there for users to understand. And that's the main problem with it.

  The user don't want to and don't need to be aware of it, but uapi forces them
  to pick the priority. [...] Your cover letter [0] example proves that in
  real life different service pick the same priority. They simply don't know
  any better. Priority is an unnecessary magic that apps _have_ to pick, so
  they just copy-paste and everyone ends up using the same.

The course of the discussion showed more and more the need for a generic,
reusable API where the "same look and feel" can be applied for various other
program types beyond just tc BPF, for example XDP today does not have multi-
program support in kernel, but also there was interest around this API for
improving management of cgroup program types. Such common multi-program
management concept is useful for BPF management daemons or user space BPF
applications coordinating about their attachments.

Both from Cilium and Meta side [2], we've collected the following requirements
for a generic attach/detach/query API for multi-progs which has been implemented
as part of this work:

  - Support prog-based attach/detach and link API
  - Dependency directives (can also be combined):
    - BPF_F_{BEFORE,AFTER} with relative_{fd,id} which can be {prog,link,none}
      - BPF_F_ID flag as {fd,id} toggle
      - BPF_F_LINK flag as {prog,link} toggle
      - If relative_{fd,id} is none, then BPF_F_BEFORE will just prepend, and
        BPF_F_AFTER will just append for the case of attaching
      - Enforced only at attach time
    - BPF_F_{FIRST,LAST}
      - Enforced throughout the bpf_mprog state's lifetime
      - Admin override possible (e.g. link detach, prog-based BPF_F_REPLACE)
  - Internal revision counter and optionally being able to pass expected_revision
  - User space daemon can query current state with revision, and pass it along
    for attachment to assert current state before doing updates
  - Query also gets extension for link_ids array and link_attach_flags:
    - prog_ids are always filled with program IDs
    - link_ids are filled with link IDs when link was used, otherwise 0
    - {prog,link}_attach_flags for holding {prog,link}-specific flags
  - Must be easy to integrate/reuse for in-kernel users

The uapi-side changes needed for supporting bpf_mprog are rather minimal,
consisting of the additions of the attachment flags, revision counter, and
expanding existing union with relative_{fd,id} member.

The bpf_mprog framework consists of an bpf_mprog_entry object which holds
an array of bpf_mprog_fp (fast-path structure) and bpf_mprog_cp (control-path
structure). Both have been separated, so that fast-path gets efficient packing
of bpf_prog pointers for maximum cache efficieny. Also, array has been chosen
instead of linked list or other structures to remove unnecessary indirections
for a fast point-to-entry in tc for BPF. The bpf_mprog_entry comes as a pair
via bpf_mprog_bundle so that in case of updates the peer bpf_mprog_entry
is populated and then just swapped which avoids additional allocations that
could otherwise fail, for example, in detach case. bpf_mprog_{fp,cp} arrays are
currently static, but they could be converted to dynamic allocation if necessary
at a point in future. Locking is deferred to the in-kernel user of bpf_mprog,
for example, in case of tcx which uses this API in the next patch, it piggy-
backs on rtnl. The nitty-gritty details are in the bpf_mprog_{replace,head_tail,
add,del} implementation and an extensive test suite for checking all aspects
of this API for prog-based attach/detach and link API as BPF selftests in
this series.

Kudos also to Andrii Nakryiko for API discussions wrt Meta's BPF management daemon.

  [0] https://lore.kernel.org/bpf/20221004231143.19190-1-daniel@iogearbox.net/
  [1] https://lore.kernel.org/bpf/CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com
  [2] http://vger.kernel.org/bpfconf2023_material/tcx_meta_netdev_borkmann.pdf

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 MAINTAINERS                    |   1 +
 include/linux/bpf_mprog.h      | 245 +++++++++++++++++
 include/uapi/linux/bpf.h       |  37 ++-
 kernel/bpf/Makefile            |   2 +-
 kernel/bpf/mprog.c             | 476 +++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  37 ++-
 6 files changed, 781 insertions(+), 17 deletions(-)
 create mode 100644 include/linux/bpf_mprog.h
 create mode 100644 kernel/bpf/mprog.c

diff --git a/MAINTAINERS b/MAINTAINERS
index c904dba1733b..754a9eeca0a1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3733,6 +3733,7 @@ F:	include/linux/filter.h
 F:	include/linux/tnum.h
 F:	kernel/bpf/core.c
 F:	kernel/bpf/dispatcher.c
+F:	kernel/bpf/mprog.c
 F:	kernel/bpf/syscall.c
 F:	kernel/bpf/tnum.c
 F:	kernel/bpf/trampoline.c
diff --git a/include/linux/bpf_mprog.h b/include/linux/bpf_mprog.h
new file mode 100644
index 000000000000..7399181d8e6c
--- /dev/null
+++ b/include/linux/bpf_mprog.h
@@ -0,0 +1,245 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2023 Isovalent */
+#ifndef __BPF_MPROG_H
+#define __BPF_MPROG_H
+
+#include <linux/bpf.h>
+
+#define BPF_MPROG_MAX	64
+#define BPF_MPROG_SWAP	1
+#define BPF_MPROG_FREE	2
+
+struct bpf_mprog_fp {
+	struct bpf_prog *prog;
+};
+
+struct bpf_mprog_cp {
+	struct bpf_link *link;
+	u32 flags;
+};
+
+struct bpf_mprog_entry {
+	struct bpf_mprog_fp fp_items[BPF_MPROG_MAX] ____cacheline_aligned;
+	struct bpf_mprog_cp cp_items[BPF_MPROG_MAX] ____cacheline_aligned;
+	struct bpf_mprog_bundle *parent;
+};
+
+struct bpf_mprog_bundle {
+	struct bpf_mprog_entry a;
+	struct bpf_mprog_entry b;
+	struct rcu_head rcu;
+	struct bpf_prog *ref;
+	atomic_t revision;
+};
+
+struct bpf_tuple {
+	struct bpf_prog *prog;
+	struct bpf_link *link;
+};
+
+static inline struct bpf_mprog_entry *
+bpf_mprog_peer(const struct bpf_mprog_entry *entry)
+{
+	if (entry == &entry->parent->a)
+		return &entry->parent->b;
+	else
+		return &entry->parent->a;
+}
+
+#define bpf_mprog_foreach_tuple(entry, fp, cp, t)			\
+	for (fp = &entry->fp_items[0], cp = &entry->cp_items[0];	\
+	     ({								\
+		t.prog = READ_ONCE(fp->prog);				\
+		t.link = cp->link;					\
+		t.prog;							\
+	      });							\
+	     fp++, cp++)
+
+#define bpf_mprog_foreach_prog(entry, fp, p)				\
+	for (fp = &entry->fp_items[0];					\
+	     (p = READ_ONCE(fp->prog));					\
+	     fp++)
+
+static inline struct bpf_mprog_entry *bpf_mprog_create(size_t extra_size)
+{
+	struct bpf_mprog_bundle *bundle;
+
+	/* Fast-path items are not extensible, must only contain prog pointer! */
+	BUILD_BUG_ON(sizeof(bundle->a.fp_items[0]) > sizeof(u64));
+	/* Control-path items can be extended w/o affecting fast-path. */
+	BUILD_BUG_ON(ARRAY_SIZE(bundle->a.fp_items) != ARRAY_SIZE(bundle->a.cp_items));
+
+	bundle = kzalloc(sizeof(*bundle) + extra_size, GFP_KERNEL);
+	if (bundle) {
+		atomic_set(&bundle->revision, 1);
+		bundle->a.parent = bundle;
+		bundle->b.parent = bundle;
+		return &bundle->a;
+	}
+	return NULL;
+}
+
+static inline void bpf_mprog_free(struct bpf_mprog_entry *entry)
+{
+	kfree_rcu(entry->parent, rcu);
+}
+
+static inline void bpf_mprog_mark_ref(struct bpf_mprog_entry *entry,
+				      struct bpf_prog *prog)
+{
+	WARN_ON_ONCE(entry->parent->ref);
+	entry->parent->ref = prog;
+}
+
+static inline u32 bpf_mprog_flags(u32 cur_flags, u32 req_flags, u32 flag)
+{
+	if (req_flags & flag)
+		cur_flags |= flag;
+	else
+		cur_flags &= ~flag;
+	return cur_flags;
+}
+
+static inline u32 bpf_mprog_max(void)
+{
+	return ARRAY_SIZE(((struct bpf_mprog_entry *)NULL)->fp_items) - 1;
+}
+
+static inline struct bpf_prog *bpf_mprog_first(struct bpf_mprog_entry *entry)
+{
+	return READ_ONCE(entry->fp_items[0].prog);
+}
+
+static inline struct bpf_prog *bpf_mprog_last(struct bpf_mprog_entry *entry)
+{
+	struct bpf_prog *tmp, *prog = NULL;
+	struct bpf_mprog_fp *fp;
+
+	bpf_mprog_foreach_prog(entry, fp, tmp)
+		prog = tmp;
+	return prog;
+}
+
+static inline bool bpf_mprog_exists(struct bpf_mprog_entry *entry,
+				    struct bpf_prog *prog)
+{
+	const struct bpf_mprog_fp *fp;
+	const struct bpf_prog *tmp;
+
+	bpf_mprog_foreach_prog(entry, fp, tmp) {
+		if (tmp == prog)
+			return true;
+	}
+	return false;
+}
+
+static inline struct bpf_prog *bpf_mprog_first_reg(struct bpf_mprog_entry *entry)
+{
+	struct bpf_tuple tuple = {};
+	struct bpf_mprog_fp *fp;
+	struct bpf_mprog_cp *cp;
+
+	bpf_mprog_foreach_tuple(entry, fp, cp, tuple) {
+		if (cp->flags & BPF_F_FIRST)
+			continue;
+		return tuple.prog;
+	}
+	return NULL;
+}
+
+static inline struct bpf_prog *bpf_mprog_last_reg(struct bpf_mprog_entry *entry)
+{
+	struct bpf_tuple tuple = {};
+	struct bpf_prog *prog = NULL;
+	struct bpf_mprog_fp *fp;
+	struct bpf_mprog_cp *cp;
+
+	bpf_mprog_foreach_tuple(entry, fp, cp, tuple) {
+		if (cp->flags & BPF_F_LAST)
+			break;
+		prog = tuple.prog;
+	}
+	return prog;
+}
+
+static inline void bpf_mprog_commit(struct bpf_mprog_entry *entry)
+{
+	do {
+		atomic_inc(&entry->parent->revision);
+	} while (atomic_read(&entry->parent->revision) == 0);
+	synchronize_rcu();
+	if (entry->parent->ref) {
+		bpf_prog_put(entry->parent->ref);
+		entry->parent->ref = NULL;
+	}
+}
+
+static inline void bpf_mprog_entry_clear(struct bpf_mprog_entry *entry)
+{
+	memset(entry->fp_items, 0, sizeof(entry->fp_items));
+	memset(entry->cp_items, 0, sizeof(entry->cp_items));
+}
+
+static inline u64 bpf_mprog_revision(struct bpf_mprog_entry *entry)
+{
+	return atomic_read(&entry->parent->revision);
+}
+
+static inline void bpf_mprog_read(struct bpf_mprog_entry *entry, u32 which,
+				  struct bpf_mprog_fp **fp_dst,
+				  struct bpf_mprog_cp **cp_dst)
+{
+	*fp_dst = &entry->fp_items[which];
+	*cp_dst = &entry->cp_items[which];
+}
+
+static inline void bpf_mprog_write(struct bpf_mprog_fp *fp_dst,
+				   struct bpf_mprog_cp *cp_dst,
+				   struct bpf_tuple *tuple, u32 flags)
+{
+	WRITE_ONCE(fp_dst->prog, tuple->prog);
+	cp_dst->link  = tuple->link;
+	cp_dst->flags = flags;
+}
+
+static inline void bpf_mprog_copy(struct bpf_mprog_fp *fp_dst,
+				  struct bpf_mprog_cp *cp_dst,
+				  struct bpf_mprog_fp *fp_src,
+				  struct bpf_mprog_cp *cp_src)
+{
+	WRITE_ONCE(fp_dst->prog, READ_ONCE(fp_src->prog));
+	memcpy(cp_dst, cp_src, sizeof(*cp_src));
+}
+
+static inline void bpf_mprog_copy_range(struct bpf_mprog_entry *peer,
+					struct bpf_mprog_entry *entry,
+					u32 idx_peer, u32 idx_entry, u32 num)
+{
+	memcpy(&peer->fp_items[idx_peer], &entry->fp_items[idx_entry],
+	       num * sizeof(peer->fp_items[0]));
+	memcpy(&peer->cp_items[idx_peer], &entry->cp_items[idx_entry],
+	       num * sizeof(peer->cp_items[0]));
+}
+
+static inline u32 bpf_mprog_total(struct bpf_mprog_entry *entry)
+{
+	const struct bpf_mprog_fp *fp;
+	const struct bpf_prog *tmp;
+	u32 num = 0;
+
+	bpf_mprog_foreach_prog(entry, fp, tmp)
+		num++;
+	return num;
+}
+
+int bpf_mprog_attach(struct bpf_mprog_entry *entry, struct bpf_prog *prog,
+		     struct bpf_link *link, u32 flags, u32 object,
+		     u32 expected_revision);
+int bpf_mprog_detach(struct bpf_mprog_entry *entry, struct bpf_prog *prog,
+		     struct bpf_link *link, u32 flags, u32 object,
+		     u32 expected_revision);
+
+int bpf_mprog_query(const union bpf_attr *attr, union bpf_attr __user *uattr,
+		    struct bpf_mprog_entry *entry);
+
+#endif /* __BPF_MPROG_H */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a7b5e91dd768..207f8a37b327 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1102,7 +1102,14 @@ enum bpf_link_type {
  */
 #define BPF_F_ALLOW_OVERRIDE	(1U << 0)
 #define BPF_F_ALLOW_MULTI	(1U << 1)
+/* Generic attachment flags. */
 #define BPF_F_REPLACE		(1U << 2)
+#define BPF_F_BEFORE		(1U << 3)
+#define BPF_F_AFTER		(1U << 4)
+#define BPF_F_FIRST		(1U << 5)
+#define BPF_F_LAST		(1U << 6)
+#define BPF_F_ID		(1U << 7)
+#define BPF_F_LINK		BPF_F_LINK /* 1 << 13 */
 
 /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
  * verifier will perform strict alignment checking as if the kernel
@@ -1433,14 +1440,19 @@ union bpf_attr {
 	};
 
 	struct { /* anonymous struct used by BPF_PROG_ATTACH/DETACH commands */
-		__u32		target_fd;	/* container object to attach to */
-		__u32		attach_bpf_fd;	/* eBPF program to attach */
+		union {
+			__u32	target_fd;	/* target object to attach to or ... */
+			__u32	target_ifindex;	/* target ifindex */
+		};
+		__u32		attach_bpf_fd;
 		__u32		attach_type;
 		__u32		attach_flags;
-		__u32		replace_bpf_fd;	/* previously attached eBPF
-						 * program to replace if
-						 * BPF_F_REPLACE is used
-						 */
+		union {
+			__u32	relative_fd;
+			__u32	relative_id;
+			__u32	replace_bpf_fd;
+		};
+		__u32		expected_revision;
 	};
 
 	struct { /* anonymous struct used by BPF_PROG_TEST_RUN command */
@@ -1486,16 +1498,25 @@ union bpf_attr {
 	} info;
 
 	struct { /* anonymous struct used by BPF_PROG_QUERY command */
-		__u32		target_fd;	/* container object to query */
+		union {
+			__u32	target_fd;	/* target object to query or ... */
+			__u32	target_ifindex;	/* target ifindex */
+		};
 		__u32		attach_type;
 		__u32		query_flags;
 		__u32		attach_flags;
 		__aligned_u64	prog_ids;
-		__u32		prog_cnt;
+		union {
+			__u32	prog_cnt;
+			__u32	count;
+		};
+		__u32		revision;
 		/* output: per-program attach_flags.
 		 * not allowed to be set during effective query.
 		 */
 		__aligned_u64	prog_attach_flags;
+		__aligned_u64	link_ids;
+		__aligned_u64	link_attach_flags;
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 1d3892168d32..1bea2eb912cd 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list
 obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
 obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
-obj-$(CONFIG_BPF_SYSCALL) += disasm.o
+obj-$(CONFIG_BPF_SYSCALL) += disasm.o mprog.o
 obj-$(CONFIG_BPF_JIT) += trampoline.o
 obj-$(CONFIG_BPF_SYSCALL) += btf.o memalloc.o
 obj-$(CONFIG_BPF_JIT) += dispatcher.o
diff --git a/kernel/bpf/mprog.c b/kernel/bpf/mprog.c
new file mode 100644
index 000000000000..efc3b73f8bf5
--- /dev/null
+++ b/kernel/bpf/mprog.c
@@ -0,0 +1,476 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2023 Isovalent */
+
+#include <linux/bpf.h>
+#include <linux/bpf_mprog.h>
+#include <linux/filter.h>
+
+static int bpf_mprog_tuple_relative(struct bpf_tuple *tuple,
+				    u32 object, u32 flags,
+				    enum bpf_prog_type type)
+{
+	struct bpf_prog *prog;
+	struct bpf_link *link;
+
+	memset(tuple, 0, sizeof(*tuple));
+	if (!(flags & (BPF_F_REPLACE | BPF_F_BEFORE | BPF_F_AFTER)))
+		return object || (flags & (BPF_F_ID | BPF_F_LINK)) ?
+		       -EINVAL : 0;
+	if (flags & BPF_F_LINK) {
+		if (flags & BPF_F_ID)
+			link = bpf_link_by_id(object);
+		else
+			link = bpf_link_get_from_fd(object);
+		if (IS_ERR(link))
+			return PTR_ERR(link);
+		if (type && link->prog->type != type) {
+			bpf_link_put(link);
+			return -EINVAL;
+		}
+		tuple->link = link;
+		tuple->prog = link->prog;
+	} else {
+		if (flags & BPF_F_ID)
+			prog = bpf_prog_by_id(object);
+		else
+			prog = bpf_prog_get(object);
+		if (IS_ERR(prog)) {
+			if (!object &&
+			    !(flags & BPF_F_ID))
+				return 0;
+			return PTR_ERR(prog);
+		}
+		if (type && prog->type != type) {
+			bpf_prog_put(prog);
+			return -EINVAL;
+		}
+		tuple->link = NULL;
+		tuple->prog = prog;
+	}
+	return 0;
+}
+
+static void bpf_mprog_tuple_put(struct bpf_tuple *tuple)
+{
+	if (tuple->link)
+		bpf_link_put(tuple->link);
+	else if (tuple->prog)
+		bpf_prog_put(tuple->prog);
+}
+
+static int bpf_mprog_replace(struct bpf_mprog_entry *entry,
+			     struct bpf_tuple *ntuple,
+			     struct bpf_tuple *rtuple, u32 rflags)
+{
+	struct bpf_mprog_fp *fp;
+	struct bpf_mprog_cp *cp;
+	struct bpf_prog *oprog;
+	u32 iflags;
+	int i;
+
+	if (rflags & (BPF_F_BEFORE | BPF_F_AFTER | BPF_F_LINK))
+		return -EINVAL;
+	if (rtuple->prog != ntuple->prog &&
+	    bpf_mprog_exists(entry, ntuple->prog))
+		return -EEXIST;
+	for (i = 0; i < bpf_mprog_max(); i++) {
+		bpf_mprog_read(entry, i, &fp, &cp);
+		oprog = READ_ONCE(fp->prog);
+		if (!oprog)
+			break;
+		if (oprog != rtuple->prog)
+			continue;
+		if (cp->link != ntuple->link)
+			return -EBUSY;
+		iflags = cp->flags;
+		if ((iflags & BPF_F_FIRST) !=
+		    (rflags & BPF_F_FIRST)) {
+			iflags = bpf_mprog_flags(iflags, rflags,
+						 BPF_F_FIRST);
+			if ((iflags & BPF_F_FIRST) &&
+			    rtuple->prog != bpf_mprog_first(entry))
+				return -EACCES;
+		}
+		if ((iflags & BPF_F_LAST) !=
+		    (rflags & BPF_F_LAST)) {
+			iflags = bpf_mprog_flags(iflags, rflags,
+						 BPF_F_LAST);
+			if ((iflags & BPF_F_LAST) &&
+			    rtuple->prog != bpf_mprog_last(entry))
+				return -EACCES;
+		}
+		bpf_mprog_write(fp, cp, ntuple, iflags);
+		if (!ntuple->link)
+			bpf_prog_put(oprog);
+		return 0;
+	}
+	return -ENOENT;
+}
+
+static int bpf_mprog_head_tail(struct bpf_mprog_entry *entry,
+			       struct bpf_tuple *ntuple,
+			       struct bpf_tuple *rtuple, u32 aflags)
+{
+	struct bpf_mprog_entry *peer;
+	struct bpf_mprog_fp *fp;
+	struct bpf_mprog_cp *cp;
+	struct bpf_prog *oprog;
+	u32 iflags, items;
+
+	if (bpf_mprog_exists(entry, ntuple->prog))
+		return -EEXIST;
+	items = bpf_mprog_total(entry);
+	peer = bpf_mprog_peer(entry);
+	bpf_mprog_entry_clear(peer);
+	if (aflags & BPF_F_FIRST) {
+		if (aflags & BPF_F_AFTER)
+			return -EINVAL;
+		bpf_mprog_read(entry, 0, &fp, &cp);
+		iflags = cp->flags;
+		if (iflags & BPF_F_FIRST)
+			return -EBUSY;
+		if (aflags & BPF_F_LAST) {
+			if (aflags & BPF_F_BEFORE)
+				return -EINVAL;
+			if (items)
+				return -EBUSY;
+			bpf_mprog_read(peer, 0, &fp, &cp);
+			bpf_mprog_write(fp, cp, ntuple,
+					BPF_F_FIRST | BPF_F_LAST);
+			return BPF_MPROG_SWAP;
+		}
+		if (aflags & BPF_F_BEFORE) {
+			oprog = READ_ONCE(fp->prog);
+			if (oprog != rtuple->prog ||
+			    (rtuple->link &&
+			     rtuple->link != cp->link))
+				return -EBUSY;
+		}
+		if (items >= bpf_mprog_max())
+			return -ENOSPC;
+		bpf_mprog_read(peer, 0, &fp, &cp);
+		bpf_mprog_write(fp, cp, ntuple, BPF_F_FIRST);
+		bpf_mprog_copy_range(peer, entry, 1, 0, items);
+		return BPF_MPROG_SWAP;
+	}
+	if (aflags & BPF_F_LAST) {
+		if (aflags & BPF_F_BEFORE)
+			return -EINVAL;
+		if (items) {
+			bpf_mprog_read(entry, items - 1, &fp, &cp);
+			iflags = cp->flags;
+			if (iflags & BPF_F_LAST)
+				return -EBUSY;
+			if (aflags & BPF_F_AFTER) {
+				oprog = READ_ONCE(fp->prog);
+				if (oprog != rtuple->prog ||
+				    (rtuple->link &&
+				     rtuple->link != cp->link))
+					return -EBUSY;
+			}
+			if (items >= bpf_mprog_max())
+				return -ENOSPC;
+		} else {
+			if (aflags & BPF_F_AFTER)
+				return -EBUSY;
+		}
+		bpf_mprog_read(peer, items, &fp, &cp);
+		bpf_mprog_write(fp, cp, ntuple, BPF_F_LAST);
+		bpf_mprog_copy_range(peer, entry, 0, 0, items);
+		return BPF_MPROG_SWAP;
+	}
+	return -ENOENT;
+}
+
+static int bpf_mprog_add(struct bpf_mprog_entry *entry,
+			 struct bpf_tuple *ntuple,
+			 struct bpf_tuple *rtuple, u32 aflags)
+{
+	struct bpf_mprog_fp *fp_dst, *fp_src;
+	struct bpf_mprog_cp *cp_dst, *cp_src;
+	struct bpf_mprog_entry *peer;
+	struct bpf_prog *oprog;
+	bool found = false;
+	u32 items;
+	int i, j;
+
+	items = bpf_mprog_total(entry);
+	if (items >= bpf_mprog_max())
+		return -ENOSPC;
+	if ((aflags & (BPF_F_BEFORE | BPF_F_AFTER)) ==
+	    (BPF_F_BEFORE | BPF_F_AFTER))
+		return -EINVAL;
+	if (bpf_mprog_exists(entry, ntuple->prog))
+		return -EEXIST;
+	if (!rtuple->prog && (aflags & (BPF_F_BEFORE | BPF_F_AFTER))) {
+		if (!items)
+			aflags &= ~(BPF_F_AFTER | BPF_F_BEFORE);
+		if (aflags & BPF_F_BEFORE)
+			rtuple->prog = bpf_mprog_first_reg(entry);
+		if (aflags & BPF_F_AFTER)
+			rtuple->prog = bpf_mprog_last_reg(entry);
+		if (!rtuple->prog)
+			aflags &= ~(BPF_F_AFTER | BPF_F_BEFORE);
+		else
+			bpf_prog_inc(rtuple->prog);
+	}
+	peer = bpf_mprog_peer(entry);
+	bpf_mprog_entry_clear(peer);
+	for (i = 0, j = 0; i < bpf_mprog_max(); i++, j++) {
+		bpf_mprog_read(entry, i, &fp_src, &cp_src);
+		bpf_mprog_read(peer,  j, &fp_dst, &cp_dst);
+		oprog = READ_ONCE(fp_src->prog);
+		if (!oprog) {
+			if (i != j)
+				break;
+			if (i > 0) {
+				bpf_mprog_read(entry, i - 1,
+					       &fp_src, &cp_src);
+				if (cp_src->flags & BPF_F_LAST) {
+					if (cp_src->flags & BPF_F_FIRST)
+						return -EBUSY;
+					bpf_mprog_copy(fp_dst, cp_dst,
+						       fp_src, cp_src);
+					bpf_mprog_read(peer, --j,
+						       &fp_dst, &cp_dst);
+				}
+			}
+			bpf_mprog_write(fp_dst, cp_dst, ntuple, 0);
+			break;
+		}
+		if (aflags & (BPF_F_BEFORE | BPF_F_AFTER)) {
+			if (rtuple->prog != oprog ||
+			    (rtuple->link &&
+			     rtuple->link != cp_src->link))
+				goto next;
+			found = true;
+			if (aflags & BPF_F_BEFORE) {
+				if (cp_src->flags & BPF_F_FIRST)
+					return -EBUSY;
+				bpf_mprog_write(fp_dst, cp_dst, ntuple, 0);
+				bpf_mprog_read(peer, ++j, &fp_dst, &cp_dst);
+				goto next;
+			}
+			if (aflags & BPF_F_AFTER) {
+				if (cp_src->flags & BPF_F_LAST)
+					return -EBUSY;
+				bpf_mprog_copy(fp_dst, cp_dst,
+					       fp_src, cp_src);
+				bpf_mprog_read(peer, ++j, &fp_dst, &cp_dst);
+				bpf_mprog_write(fp_dst, cp_dst, ntuple, 0);
+				continue;
+			}
+		}
+next:
+		bpf_mprog_copy(fp_dst, cp_dst,
+			       fp_src, cp_src);
+	}
+	if (rtuple->prog && !found)
+		return -ENOENT;
+	return BPF_MPROG_SWAP;
+}
+
+static int bpf_mprog_del(struct bpf_mprog_entry *entry,
+			 struct bpf_tuple *dtuple,
+			 struct bpf_tuple *rtuple, u32 dflags)
+{
+	struct bpf_mprog_fp *fp_dst, *fp_src;
+	struct bpf_mprog_cp *cp_dst, *cp_src;
+	struct bpf_mprog_entry *peer;
+	struct bpf_prog *oprog;
+	bool found = false;
+	int i, j, ret;
+
+	if (dflags & BPF_F_REPLACE)
+		return -EINVAL;
+	if (dflags & BPF_F_FIRST) {
+		oprog = bpf_mprog_first(entry);
+		if (dtuple->prog &&
+		    dtuple->prog != oprog)
+			return -ENOENT;
+		dtuple->prog = oprog;
+	}
+	if (dflags & BPF_F_LAST) {
+		oprog = bpf_mprog_last(entry);
+		if (dtuple->prog &&
+		    dtuple->prog != oprog)
+			return -ENOENT;
+		dtuple->prog = oprog;
+	}
+	if (!rtuple->prog && (dflags & (BPF_F_BEFORE | BPF_F_AFTER))) {
+		if (dtuple->prog)
+			return -EINVAL;
+		if (dflags & BPF_F_BEFORE)
+			dtuple->prog = bpf_mprog_first_reg(entry);
+		if (dflags & BPF_F_AFTER)
+			dtuple->prog = bpf_mprog_last_reg(entry);
+		if (dtuple->prog)
+			dflags &= ~(BPF_F_AFTER | BPF_F_BEFORE);
+	}
+	for (i = 0; i < bpf_mprog_max(); i++) {
+		bpf_mprog_read(entry, i, &fp_src, &cp_src);
+		oprog = READ_ONCE(fp_src->prog);
+		if (!oprog)
+			break;
+		if (dflags & (BPF_F_BEFORE | BPF_F_AFTER)) {
+			if (rtuple->prog != oprog ||
+			    (rtuple->link &&
+			     rtuple->link != cp_src->link))
+				continue;
+			found = true;
+			if (dflags & BPF_F_BEFORE) {
+				if (!i)
+					return -ENOENT;
+				bpf_mprog_read(entry, i - 1,
+					       &fp_src, &cp_src);
+				oprog = READ_ONCE(fp_src->prog);
+				if (dtuple->prog &&
+				    dtuple->prog != oprog)
+					return -ENOENT;
+				dtuple->prog = oprog;
+				break;
+			}
+			if (dflags & BPF_F_AFTER) {
+				bpf_mprog_read(entry, i + 1,
+					       &fp_src, &cp_src);
+				oprog = READ_ONCE(fp_src->prog);
+				if (dtuple->prog &&
+				    dtuple->prog != oprog)
+					return -ENOENT;
+				dtuple->prog = oprog;
+				break;
+			}
+		}
+	}
+	if (!dtuple->prog || (rtuple->prog && !found))
+		return -ENOENT;
+	peer = bpf_mprog_peer(entry);
+	bpf_mprog_entry_clear(peer);
+	ret = -ENOENT;
+	for (i = 0, j = 0; i < bpf_mprog_max(); i++) {
+		bpf_mprog_read(entry, i, &fp_src, &cp_src);
+		bpf_mprog_read(peer,  j, &fp_dst, &cp_dst);
+		oprog = READ_ONCE(fp_src->prog);
+		if (!oprog)
+			break;
+		if (oprog != dtuple->prog) {
+			bpf_mprog_copy(fp_dst, cp_dst,
+				       fp_src, cp_src);
+			j++;
+		} else {
+			if (cp_src->link != dtuple->link)
+				return -EBUSY;
+			if (!cp_src->link)
+				bpf_mprog_mark_ref(entry, dtuple->prog);
+			ret = BPF_MPROG_SWAP;
+		}
+	}
+	if (!bpf_mprog_total(peer))
+		ret = BPF_MPROG_FREE;
+	return ret;
+}
+
+int bpf_mprog_attach(struct bpf_mprog_entry *entry, struct bpf_prog *prog,
+		     struct bpf_link *link, u32 flags, u32 object,
+		     u32 expected_revision)
+{
+	struct bpf_tuple rtuple, ntuple = {
+		.prog = prog,
+		.link = link,
+	};
+	int ret;
+
+	if (expected_revision &&
+	    expected_revision != bpf_mprog_revision(entry))
+		return -ESTALE;
+	ret = bpf_mprog_tuple_relative(&rtuple, object, flags, prog->type);
+	if (ret)
+		return ret;
+	if (flags & BPF_F_REPLACE)
+		ret = bpf_mprog_replace(entry, &ntuple, &rtuple, flags);
+	else if (flags & (BPF_F_FIRST | BPF_F_LAST))
+		ret = bpf_mprog_head_tail(entry, &ntuple, &rtuple, flags);
+	else
+		ret = bpf_mprog_add(entry, &ntuple, &rtuple, flags);
+	bpf_mprog_tuple_put(&rtuple);
+	return ret;
+}
+
+int bpf_mprog_detach(struct bpf_mprog_entry *entry, struct bpf_prog *prog,
+		     struct bpf_link *link, u32 flags, u32 object,
+		     u32 expected_revision)
+{
+	struct bpf_tuple rtuple, dtuple = {
+		.prog = prog,
+		.link = link,
+	};
+	int ret;
+
+	if (expected_revision &&
+	    expected_revision != bpf_mprog_revision(entry))
+		return -ESTALE;
+	ret = bpf_mprog_tuple_relative(&rtuple, object, flags,
+				       prog ? prog->type :
+				       BPF_PROG_TYPE_UNSPEC);
+	if (ret)
+		return ret;
+	ret = bpf_mprog_del(entry, &dtuple, &rtuple, flags);
+	bpf_mprog_tuple_put(&rtuple);
+	return ret;
+}
+
+int bpf_mprog_query(const union bpf_attr *attr, union bpf_attr __user *uattr,
+		    struct bpf_mprog_entry *entry)
+{
+	u32 i, id, flags = 0, count, revision;
+	u32 __user *uprog_id, *uprog_af;
+	u32 __user *ulink_id, *ulink_af;
+	struct bpf_mprog_fp *fp;
+	struct bpf_mprog_cp *cp;
+	struct bpf_prog *prog;
+	int ret = 0;
+
+	if (attr->query.query_flags || attr->query.attach_flags)
+		return -EINVAL;
+	revision = bpf_mprog_revision(entry);
+	count = bpf_mprog_total(entry);
+	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
+		return -EFAULT;
+	if (copy_to_user(&uattr->query.revision, &revision, sizeof(revision)))
+		return -EFAULT;
+	if (copy_to_user(&uattr->query.count, &count, sizeof(count)))
+		return -EFAULT;
+	uprog_id = u64_to_user_ptr(attr->query.prog_ids);
+	if (attr->query.count == 0 || !uprog_id || !count)
+		return 0;
+	if (attr->query.count < count) {
+		count = attr->query.count;
+		ret = -ENOSPC;
+	}
+	uprog_af = u64_to_user_ptr(attr->query.prog_attach_flags);
+	ulink_id = u64_to_user_ptr(attr->query.link_ids);
+	ulink_af = u64_to_user_ptr(attr->query.link_attach_flags);
+	for (i = 0; i < ARRAY_SIZE(entry->fp_items); i++) {
+		bpf_mprog_read(entry, i, &fp, &cp);
+		prog = READ_ONCE(fp->prog);
+		if (!prog)
+			break;
+		id = prog->aux->id;
+		if (copy_to_user(uprog_id + i, &id, sizeof(id)))
+			return -EFAULT;
+		id = cp->link ? cp->link->id : 0;
+		if (ulink_id &&
+		    copy_to_user(ulink_id + i, &id, sizeof(id)))
+			return -EFAULT;
+		flags = cp->flags;
+		if (uprog_af && !id &&
+		    copy_to_user(uprog_af + i, &flags, sizeof(flags)))
+			return -EFAULT;
+		if (ulink_af && id &&
+		    copy_to_user(ulink_af + i, &flags, sizeof(flags)))
+			return -EFAULT;
+		if (i + 1 == count)
+			break;
+	}
+	return ret;
+}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a7b5e91dd768..207f8a37b327 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1102,7 +1102,14 @@ enum bpf_link_type {
  */
 #define BPF_F_ALLOW_OVERRIDE	(1U << 0)
 #define BPF_F_ALLOW_MULTI	(1U << 1)
+/* Generic attachment flags. */
 #define BPF_F_REPLACE		(1U << 2)
+#define BPF_F_BEFORE		(1U << 3)
+#define BPF_F_AFTER		(1U << 4)
+#define BPF_F_FIRST		(1U << 5)
+#define BPF_F_LAST		(1U << 6)
+#define BPF_F_ID		(1U << 7)
+#define BPF_F_LINK		BPF_F_LINK /* 1 << 13 */
 
 /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
  * verifier will perform strict alignment checking as if the kernel
@@ -1433,14 +1440,19 @@ union bpf_attr {
 	};
 
 	struct { /* anonymous struct used by BPF_PROG_ATTACH/DETACH commands */
-		__u32		target_fd;	/* container object to attach to */
-		__u32		attach_bpf_fd;	/* eBPF program to attach */
+		union {
+			__u32	target_fd;	/* target object to attach to or ... */
+			__u32	target_ifindex;	/* target ifindex */
+		};
+		__u32		attach_bpf_fd;
 		__u32		attach_type;
 		__u32		attach_flags;
-		__u32		replace_bpf_fd;	/* previously attached eBPF
-						 * program to replace if
-						 * BPF_F_REPLACE is used
-						 */
+		union {
+			__u32	relative_fd;
+			__u32	relative_id;
+			__u32	replace_bpf_fd;
+		};
+		__u32		expected_revision;
 	};
 
 	struct { /* anonymous struct used by BPF_PROG_TEST_RUN command */
@@ -1486,16 +1498,25 @@ union bpf_attr {
 	} info;
 
 	struct { /* anonymous struct used by BPF_PROG_QUERY command */
-		__u32		target_fd;	/* container object to query */
+		union {
+			__u32	target_fd;	/* target object to query or ... */
+			__u32	target_ifindex;	/* target ifindex */
+		};
 		__u32		attach_type;
 		__u32		query_flags;
 		__u32		attach_flags;
 		__aligned_u64	prog_ids;
-		__u32		prog_cnt;
+		union {
+			__u32	prog_cnt;
+			__u32	count;
+		};
+		__u32		revision;
 		/* output: per-program attach_flags.
 		 * not allowed to be set during effective query.
 		 */
 		__aligned_u64	prog_attach_flags;
+		__aligned_u64	link_ids;
+		__aligned_u64	link_attach_flags;
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
-- 
2.34.1


