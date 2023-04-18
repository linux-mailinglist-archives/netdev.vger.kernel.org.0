Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16F06E6591
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 15:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbjDRNLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 09:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbjDRNLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 09:11:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22D310F3;
        Tue, 18 Apr 2023 06:11:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pol71-0004G3-3f; Tue, 18 Apr 2023 15:11:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <bpf@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de, Florian Westphal <fw@strlen.de>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v3 5/6] tools: bpftool: print netfilter link info
Date:   Tue, 18 Apr 2023 15:10:37 +0200
Message-Id: <20230418131038.18054-6-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230418131038.18054-1-fw@strlen.de>
References: <20230418131038.18054-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dump protocol family, hook and priority value:
$ bpftool link
2: netfilter  prog 14
        ip input prio -128
        pids install(3264)
5: netfilter  prog 14
        ip6 forward prio 21
        pids a.out(3387)
9: netfilter  prog 14
        ip prerouting prio 123
        pids a.out(5700)
10: netfilter  prog 14
        ip input prio 21
        pids test2(5701)

v2: Quentin Monnet suggested to also add 'bpftool net' support:

$ bpftool net
xdp:

tc:

flow_dissector:

netfilter:

        ip prerouting prio 21 prog_id 14
        ip input prio -128 prog_id 14
        ip input prio 21 prog_id 14
        ip forward prio 21 prog_id 14
        ip output prio 21 prog_id 14
        ip postrouting prio 21 prog_id 14

'bpftool net' only dumps netfilter link type.  netfilter links are sorted by
protocol family, hook and priority.

Suggested-by: Quentin Monnet <quentin@isovalent.com>
Link: https://lore.kernel.org/bpf/eeeaac99-9053-90c2-aa33-cc1ecb1ae9ca@isovalent.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/bpf/bpftool/link.c       |  83 ++++++++++++++++++++++++++
 tools/bpf/bpftool/main.h       |   3 +
 tools/bpf/bpftool/net.c        | 105 +++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  15 +++++
 tools/lib/bpf/libbpf.c         |   2 +
 5 files changed, 208 insertions(+)

diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index f985b79cca27..96a3c458a632 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -3,6 +3,8 @@
 
 #include <errno.h>
 #include <linux/err.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_arp.h>
 #include <net/if.h>
 #include <stdio.h>
 #include <unistd.h>
@@ -135,6 +137,18 @@ static void show_iter_json(struct bpf_link_info *info, json_writer_t *wtr)
 	}
 }
 
+void netfilter_dump_json(const struct bpf_link_info *info, json_writer_t *wtr)
+{
+	jsonw_uint_field(json_wtr, "pf",
+			 info->netfilter.pf);
+	jsonw_uint_field(json_wtr, "hook",
+			 info->netfilter.hooknum);
+	jsonw_int_field(json_wtr, "prio",
+			 info->netfilter.priority);
+	jsonw_uint_field(json_wtr, "flags",
+			 info->netfilter.flags);
+}
+
 static int get_prog_info(int prog_id, struct bpf_prog_info *info)
 {
 	__u32 len = sizeof(*info);
@@ -195,6 +209,10 @@ static int show_link_close_json(int fd, struct bpf_link_info *info)
 				 info->netns.netns_ino);
 		show_link_attach_type_json(info->netns.attach_type, json_wtr);
 		break;
+	case BPF_LINK_TYPE_NETFILTER:
+		netfilter_dump_json(info, json_wtr);
+		break;
+
 	default:
 		break;
 	}
@@ -263,6 +281,68 @@ static void show_iter_plain(struct bpf_link_info *info)
 	}
 }
 
+static const char *pf2name[] = {
+	[NFPROTO_INET] = "inet",
+	[NFPROTO_IPV4] = "ip",
+	[NFPROTO_ARP] = "arp",
+	[NFPROTO_NETDEV] = "netdev",
+	[NFPROTO_BRIDGE] = "bridge",
+	[NFPROTO_IPV6] = "ip6",
+};
+
+static const char *inethook2name[] = {
+	[NF_INET_PRE_ROUTING] = "prerouting",
+	[NF_INET_LOCAL_IN] = "input",
+	[NF_INET_FORWARD] = "forward",
+	[NF_INET_LOCAL_OUT] = "output",
+	[NF_INET_POST_ROUTING] = "postrouting",
+};
+
+static const char *arphook2name[] = {
+	[NF_ARP_IN] = "input",
+	[NF_ARP_OUT] = "output",
+};
+
+void netfilter_dump_plain(const struct bpf_link_info *info)
+{
+	const char *hookname = NULL, *pfname = NULL;
+	unsigned int hook = info->netfilter.hooknum;
+	unsigned int pf = info->netfilter.pf;
+
+	if (pf < ARRAY_SIZE(pf2name))
+		pfname = pf2name[pf];
+
+	switch (pf) {
+	case NFPROTO_BRIDGE: /* bridge shares numbers with enum nf_inet_hooks */
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		if (hook < ARRAY_SIZE(inethook2name))
+			hookname = inethook2name[hook];
+		break;
+	case NFPROTO_ARP:
+		if (hook < ARRAY_SIZE(arphook2name))
+			hookname = arphook2name[hook];
+	default:
+		break;
+	}
+
+	if (pfname)
+		printf("\n\t%s", pfname);
+	else
+		printf("\n\tpf: %d", pf);
+
+	if (hookname)
+		printf(" %s", hookname);
+	else
+		printf(", hook %u,", hook);
+
+	printf(" prio %d", info->netfilter.priority);
+
+	if (info->netfilter.flags)
+		printf(" flags 0x%x", info->netfilter.flags);
+}
+
 static int show_link_close_plain(int fd, struct bpf_link_info *info)
 {
 	struct bpf_prog_info prog_info;
@@ -301,6 +381,9 @@ static int show_link_close_plain(int fd, struct bpf_link_info *info)
 		printf("\n\tnetns_ino %u  ", info->netns.netns_ino);
 		show_link_attach_type_plain(info->netns.attach_type);
 		break;
+	case BPF_LINK_TYPE_NETFILTER:
+		netfilter_dump_plain(info);
+		break;
 	default:
 		break;
 	}
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 00d11ca6d3f2..63d9aa1012a9 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -264,4 +264,7 @@ static inline bool hashmap__empty(struct hashmap *map)
 	return map ? hashmap__size(map) == 0 : true;
 }
 
+/* print netfilter bpf_link info */
+void netfilter_dump_plain(const struct bpf_link_info *info);
+void netfilter_dump_json(const struct bpf_link_info *info, json_writer_t *wtr);
 #endif
diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index c40e44c938ae..61710cc63ef7 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -647,6 +647,107 @@ static int do_detach(int argc, char **argv)
 	return 0;
 }
 
+static int netfilter_link_compar(const void *a, const void *b)
+{
+	const struct bpf_link_info *nfa = a;
+	const struct bpf_link_info *nfb = b;
+	int delta;
+
+	delta = nfa->netfilter.pf - nfb->netfilter.pf;
+	if (delta)
+		return delta;
+
+	delta = nfa->netfilter.hooknum - nfb->netfilter.hooknum;
+	if (delta)
+		return delta;
+
+	if (nfa->netfilter.priority < nfb->netfilter.priority)
+		return -1;
+	if (nfa->netfilter.priority > nfb->netfilter.priority)
+		return 1;
+
+	return nfa->netfilter.flags - nfb->netfilter.flags;
+}
+
+static void show_link_netfilter(void)
+{
+	unsigned int nf_link_len = 0, nf_link_count = 0;
+	struct bpf_link_info *nf_link_info = NULL;
+	__u32 id = 0;
+
+	while (true) {
+		struct bpf_link_info info;
+		int fd, err;
+		__u32 len;
+
+		err = bpf_link_get_next_id(id, &id);
+		if (err) {
+			if (errno == ENOENT)
+				break;
+			p_err("can't get next link: %s (id %d)", strerror(errno), id);
+			break;
+		}
+
+		fd = bpf_link_get_fd_by_id(id);
+		if (fd < 0) {
+			p_err("can't get link by id (%u): %s", id, strerror(errno));
+			continue;
+		}
+
+		memset(&info, 0, sizeof(info));
+		len = sizeof(info);
+
+		err = bpf_link_get_info_by_fd(fd, &info, &len);
+
+		close(fd);
+
+		if (err) {
+			p_err("can't get link info for fd %d: %s", fd, strerror(errno));
+			continue;
+		}
+
+		if (info.type != BPF_LINK_TYPE_NETFILTER)
+			continue;
+
+		if (nf_link_count >= nf_link_len) {
+			struct bpf_link_info *expand;
+
+			if (nf_link_count > (INT_MAX / sizeof(info))) {
+				fprintf(stderr, "link count %d\n", nf_link_count);
+				break;
+			}
+
+			nf_link_len += 16;
+
+			expand = realloc(nf_link_info, nf_link_len * sizeof(info));
+			if (!expand) {
+				p_err("realloc: %s",  strerror(errno));
+				break;
+			}
+
+			nf_link_info = expand;
+		}
+
+		nf_link_info[nf_link_count] = info;
+		nf_link_count++;
+	}
+
+	qsort(nf_link_info, nf_link_count, sizeof(*nf_link_info), netfilter_link_compar);
+
+	for (id = 0; id < nf_link_count; id++) {
+		NET_START_OBJECT;
+		if (json_output)
+			netfilter_dump_json(&nf_link_info[id], json_wtr);
+		else
+			netfilter_dump_plain(&nf_link_info[id]);
+
+		NET_DUMP_UINT("id", " prog_id %u", nf_link_info[id].prog_id);
+		NET_END_OBJECT;
+	}
+
+	free(nf_link_info);
+}
+
 static int do_show(int argc, char **argv)
 {
 	struct bpf_attach_info attach_info = {};
@@ -701,6 +802,10 @@ static int do_show(int argc, char **argv)
 		NET_DUMP_UINT("id", "id %u", attach_info.flow_dissector_id);
 	NET_END_ARRAY("\n");
 
+	NET_START_ARRAY("netfilter", "%s:\n");
+	show_link_netfilter();
+	NET_END_ARRAY("\n");
+
 	NET_END_OBJECT;
 	if (json_output)
 		jsonw_end_array(json_wtr);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4b20a7269bee..be97cc6398a4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
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
@@ -1560,6 +1562,13 @@ union bpf_attr {
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
 
@@ -6410,6 +6419,12 @@ struct bpf_link_info {
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
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 49cd304ae3bc..ce0e3badc9db 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -130,6 +130,7 @@ static const char * const link_type_name[] = {
 	[BPF_LINK_TYPE_PERF_EVENT]		= "perf_event",
 	[BPF_LINK_TYPE_KPROBE_MULTI]		= "kprobe_multi",
 	[BPF_LINK_TYPE_STRUCT_OPS]		= "struct_ops",
+	[BPF_LINK_TYPE_NETFILTER]		= "netfilter",
 };
 
 static const char * const map_type_name[] = {
@@ -8641,6 +8642,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("struct_ops+",		STRUCT_OPS, 0, SEC_NONE),
 	SEC_DEF("struct_ops.s+",	STRUCT_OPS, 0, SEC_SLEEPABLE),
 	SEC_DEF("sk_lookup",		SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE),
+	SEC_DEF("netfilter",		NETFILTER, 0, SEC_NONE),
 };
 
 static size_t custom_sec_def_cnt;
-- 
2.39.2

