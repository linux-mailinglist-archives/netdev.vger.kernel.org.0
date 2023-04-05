Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157826D832D
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbjDEQL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjDEQLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:11:51 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B626A52;
        Wed,  5 Apr 2023 09:11:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pk5jQ-0007lC-Hh; Wed, 05 Apr 2023 18:11:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     netfilter-devel@vger.kernel.org, bpf@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de, Florian Westphal <fw@strlen.de>
Subject: [PATCH bpf-next 1/6] bpf: add bpf_link support for BPF_NETFILTER programs
Date:   Wed,  5 Apr 2023 18:11:11 +0200
Message-Id: <20230405161116.13565-2-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405161116.13565-1-fw@strlen.de>
References: <20230405161116.13565-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_link support skeleton.  To keep this reviewable, no bpf program
can be invoked yet, if a program is attached only a c-stub is called and
not the actual bpf program.

Defaults to 'y' if both netfilter and bpf syscall are enabled in kconfig.

Uapi example usage:
	union bpf_attr attr = { };

	attr.link_create.prog_fd = progfd;
	attr.link_create.attach_type = 0; /* unused */
	attr.link_create.netfilter.pf = PF_INET;
	attr.link_create.netfilter.hooknum = NF_INET_LOCAL_IN;
	attr.link_create.netfilter.priority = -128;

	err = bpf(BPF_LINK_CREATE, &attr, sizeof(attr));

... this would attach progfd to ipv4:input hook.

Such hook gets removed automatically if the calling program exits.

BPF_NETFILTER program invocation is added in followup change.

NF_HOOK_OP_BPF enum will eventually be read from nfnetlink_hook, it
allows to tell userspace which program is attached at the given hook
when user runs 'nft hook list' command rather than just the priority
and not-very-helpful 'this hook runs a bpf prog but I can't tell which
one'.

Will also be used to disallow registration of two bpf programs with
same priority in a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h           |   1 +
 include/net/netfilter/nf_bpf_link.h |   2 +
 include/uapi/linux/bpf.h            |  15 ++++
 kernel/bpf/syscall.c                |   6 ++
 net/netfilter/Kconfig               |   3 +
 net/netfilter/Makefile              |   1 +
 net/netfilter/nf_bpf_link.c         | 121 ++++++++++++++++++++++++++++
 7 files changed, 149 insertions(+)
 create mode 100644 include/net/netfilter/nf_bpf_link.h
 create mode 100644 net/netfilter/nf_bpf_link.c

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index c8e03bcaecaa..0762444e3767 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -80,6 +80,7 @@ typedef unsigned int nf_hookfn(void *priv,
 enum nf_hook_ops_type {
 	NF_HOOK_OP_UNDEFINED,
 	NF_HOOK_OP_NF_TABLES,
+	NF_HOOK_OP_BPF,
 };
 
 struct nf_hook_ops {
diff --git a/include/net/netfilter/nf_bpf_link.h b/include/net/netfilter/nf_bpf_link.h
new file mode 100644
index 000000000000..9d1b338e89d7
--- /dev/null
+++ b/include/net/netfilter/nf_bpf_link.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+int bpf_nf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index e3d3b5160d26..7d1a615ce78e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -986,6 +986,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
 	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
+	BPF_PROG_TYPE_NETFILTER,
 };
 
 enum bpf_attach_type {
@@ -1050,6 +1051,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_PERF_EVENT = 7,
 	BPF_LINK_TYPE_KPROBE_MULTI = 8,
 	BPF_LINK_TYPE_STRUCT_OPS = 9,
+	BPF_LINK_TYPE_NETFILTER = 10,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1550,6 +1552,13 @@ union bpf_attr {
 				 */
 				__u64		cookie;
 			} tracing;
+			struct {
+				__u32		pf;
+				__u32		hooknum;
+				__s32		prio;
+				__u32		flags;
+				__u64		reserved[2];
+			} netfilter;
 		};
 	} link_create;
 
@@ -6400,6 +6409,12 @@ struct bpf_link_info {
 		struct {
 			__u32 map_id;
 		} struct_ops;
+		struct {
+			__u32 pf;
+			__u32 hooknum;
+			__s32 priority;
+			__u32 flags;
+		} netfilter;
 	};
 } __attribute__((aligned(8)));
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e18ac7fdc210..bf0cce7071ef 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -35,6 +35,7 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
 #include <linux/trace_events.h>
+#include <net/netfilter/nf_bpf_link.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -2472,6 +2473,7 @@ static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_SOCK_OPS:
 	case BPF_PROG_TYPE_EXT: /* extends any prog */
+	case BPF_PROG_TYPE_NETFILTER:
 		return true;
 	case BPF_PROG_TYPE_CGROUP_SKB:
 		/* always unpriv */
@@ -4598,6 +4600,7 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 
 	switch (prog->type) {
 	case BPF_PROG_TYPE_EXT:
+	case BPF_PROG_TYPE_NETFILTER:
 		break;
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_TRACEPOINT:
@@ -4664,6 +4667,9 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 	case BPF_PROG_TYPE_XDP:
 		ret = bpf_xdp_link_attach(attr, prog);
 		break;
+	case BPF_PROG_TYPE_NETFILTER:
+		ret = bpf_nf_link_attach(attr, prog);
+		break;
 #endif
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_TRACEPOINT:
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 4d6737160857..bea06f62a30e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -30,6 +30,9 @@ config NETFILTER_FAMILY_BRIDGE
 config NETFILTER_FAMILY_ARP
 	bool
 
+config NETFILTER_BPF_LINK
+	def_bool BPF_SYSCALL
+
 config NETFILTER_NETLINK_HOOK
 	tristate "Netfilter base hook dump support"
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5ffef1cd6143..d4958e7e7631 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -22,6 +22,7 @@ nf_conntrack-$(CONFIG_DEBUG_INFO_BTF) += nf_conntrack_bpf.o
 endif
 
 obj-$(CONFIG_NETFILTER) = netfilter.o
+obj-$(CONFIG_NETFILTER_BPF_LINK) += nf_bpf_link.o
 
 obj-$(CONFIG_NETFILTER_NETLINK) += nfnetlink.o
 obj-$(CONFIG_NETFILTER_NETLINK_ACCT) += nfnetlink_acct.o
diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
new file mode 100644
index 000000000000..c68b2cb70fd4
--- /dev/null
+++ b/net/netfilter/nf_bpf_link.c
@@ -0,0 +1,121 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <linux/netfilter.h>
+
+#include <net/netfilter/nf_bpf_link.h>
+
+static unsigned int nf_hook_run_bpf(void *bpf_prog, struct sk_buff *skb, const struct nf_hook_state *s)
+{
+	return NF_ACCEPT;
+}
+
+struct bpf_nf_link {
+	struct bpf_link link;
+	struct nf_hook_ops hook_ops;
+	struct net *net;
+};
+
+static void bpf_nf_link_release(struct bpf_link *link)
+{
+	struct bpf_nf_link *nf_link = container_of(link, struct bpf_nf_link, link);
+
+	nf_unregister_net_hook(nf_link->net, &nf_link->hook_ops);
+}
+
+static void bpf_nf_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_nf_link *nf_link = container_of(link, struct bpf_nf_link, link);
+
+	kfree(nf_link);
+}
+
+static int bpf_nf_link_detach(struct bpf_link *link)
+{
+	bpf_nf_link_release(link);
+	return 0;
+}
+
+static void bpf_nf_link_show_info(const struct bpf_link *link,
+				  struct seq_file *seq)
+{
+	struct bpf_nf_link *nf_link = container_of(link, struct bpf_nf_link, link);
+
+	seq_printf(seq, "pf:\t%u\thooknum:\t%u\tprio:\t%d\n",
+		   nf_link->hook_ops.pf, nf_link->hook_ops.hooknum,
+		   nf_link->hook_ops.priority);
+}
+
+static int bpf_nf_link_fill_link_info(const struct bpf_link *link,
+				      struct bpf_link_info *info)
+{
+	struct bpf_nf_link *nf_link = container_of(link, struct bpf_nf_link, link);
+
+	info->netfilter.pf = nf_link->hook_ops.pf;
+	info->netfilter.hooknum = nf_link->hook_ops.hooknum;
+	info->netfilter.priority = nf_link->hook_ops.priority;
+	info->netfilter.flags = 0;
+
+	return 0;
+}
+
+static int bpf_nf_link_update(struct bpf_link *link, struct bpf_prog *new_prog,
+			      struct bpf_prog *old_prog)
+{
+	return -EOPNOTSUPP;
+}
+
+static const struct bpf_link_ops bpf_nf_link_lops = {
+	.release = bpf_nf_link_release,
+	.dealloc = bpf_nf_link_dealloc,
+	.detach = bpf_nf_link_detach,
+	.show_fdinfo = bpf_nf_link_show_info,
+	.fill_link_info = bpf_nf_link_fill_link_info,
+	.update_prog = bpf_nf_link_update,
+};
+
+int bpf_nf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	struct net *net = current->nsproxy->net_ns;
+	struct bpf_link_primer link_primer;
+	struct bpf_nf_link *link;
+	int err;
+
+	if (attr->link_create.flags)
+		return -EINVAL;
+
+	if (attr->link_create.netfilter.flags)
+		return -EOPNOTSUPP;
+
+	if (attr->link_create.netfilter.reserved[0] | attr->link_create.netfilter.reserved[1])
+		return -EINVAL;
+
+	link = kzalloc(sizeof(*link), GFP_USER);
+	if (!link)
+		return -ENOMEM;
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_NETFILTER, &bpf_nf_link_lops, prog);
+
+	link->hook_ops.hook = nf_hook_run_bpf;
+	link->hook_ops.hook_ops_type = NF_HOOK_OP_BPF;
+	link->hook_ops.priv = prog;
+
+	link->hook_ops.pf = attr->link_create.netfilter.pf;
+	link->hook_ops.priority = attr->link_create.netfilter.prio;
+	link->hook_ops.hooknum = attr->link_create.netfilter.hooknum;
+
+	link->net = net;
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err) {
+		kfree(link);
+		return err;
+	}
+
+	err = nf_register_net_hook(net, &link->hook_ops);
+	if (err) {
+		bpf_link_cleanup(&link_primer);
+		return err;
+	}
+
+	return bpf_link_settle(&link_primer);
+}
-- 
2.39.2

