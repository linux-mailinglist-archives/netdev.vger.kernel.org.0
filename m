Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B1DA0C20
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfH1VE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:04:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51240 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726583AbfH1VE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:04:59 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x7SL4s2b002548
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=YMi7ATQez7af44Q6sVNFWtVib+PyV/1XudXukZNgIYg=;
 b=QmMZBGOhoOfFDnmjfl1ORhYt0GEeMT8sT1mT8kK4tmDqU+Qr6BQYa8Nc3QmgdiD6TsCU
 gF/3TybOuapY17OCwnTwx3vxXZKZnRFzhzjAQuYIAij8bNjLN3pOlmbDzY5N9Te1ycC9
 hkkMZHd7KWnk0J9md9elbjPtWN/es9rkBqk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2un62cf2qu-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:57 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 14:04:23 -0700
Received: by devvm2868.prn3.facebook.com (Postfix, from userid 125878)
        id A41DDA25D6A2; Wed, 28 Aug 2019 14:04:22 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Julia Kartseva <hex@fb.com>
Smtp-Origin-Hostname: devvm2868.prn3.facebook.com
To:     <rdna@fb.com>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Julia Kartseva <hex@fb.com>
Smtp-Origin-Cluster: prn3c11
Subject: [PATCH bpf-next 09/10] tools/bpftool: use libbpf_(prog|map)_type_to_str helpers
Date:   Wed, 28 Aug 2019 14:03:12 -0700
Message-ID: <6dbed87425cb14e32002c7b596fdcfec7dfca732.1567024943.git.hex@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1567024943.git.hex@fb.com>
References: <cover.1567024943.git.hex@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-28_11:2019-08-28,2019-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=2
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908280206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace lookup in (prog|map)_type_name arrays with
libbpf_(prog|map)_type_to_str helpers.
Use __MAX_BPF_(PROG|MAP)_TYPE enum values as loop bounds.

Signed-off-by: Julia Kartseva <hex@fb.com>
---
 tools/bpf/bpftool/feature.c | 47 ++++++++++++++--------
 tools/bpf/bpftool/main.h    | 33 ---------------
 tools/bpf/bpftool/map.c     | 80 ++++++++++---------------------------
 tools/bpf/bpftool/prog.c    | 11 ++---
 4 files changed, 59 insertions(+), 112 deletions(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 03bdc5b3ac49..e9416005e721 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -462,7 +462,7 @@ probe_prog_type(enum bpf_prog_type prog_type, bool *supported_types,
 		const char *define_prefix, __u32 ifindex)
 {
 	char feat_name[128], plain_desc[128], define_name[128];
-	const char *plain_comment = "eBPF program_type ";
+	const char *ptype_name, *plain_comment = "eBPF program_type ";
 	size_t maxlen;
 	bool res;
 
@@ -480,16 +480,21 @@ probe_prog_type(enum bpf_prog_type prog_type, bool *supported_types,
 
 	supported_types[prog_type] |= res;
 
+	if (libbpf_prog_type_to_str(prog_type, &ptype_name)) {
+		p_info("program type name does not exist");
+		return;
+	}
+
 	maxlen = sizeof(plain_desc) - strlen(plain_comment) - 1;
-	if (strlen(prog_type_name[prog_type]) > maxlen) {
+	if (strlen(ptype_name) > maxlen) {
 		p_info("program type name too long");
 		return;
 	}
 
-	sprintf(feat_name, "have_%s_prog_type", prog_type_name[prog_type]);
-	sprintf(define_name, "%s_prog_type", prog_type_name[prog_type]);
+	sprintf(feat_name, "have_%s_prog_type", ptype_name);
+	sprintf(define_name, "%s_prog_type", ptype_name);
 	uppercase(define_name, sizeof(define_name));
-	sprintf(plain_desc, "%s%s", plain_comment, prog_type_name[prog_type]);
+	sprintf(plain_desc, "%s%s", plain_comment, ptype_name);
 	print_bool_feature(feat_name, plain_desc, define_name, res,
 			   define_prefix);
 }
@@ -499,22 +504,27 @@ probe_map_type(enum bpf_map_type map_type, const char *define_prefix,
 	       __u32 ifindex)
 {
 	char feat_name[128], plain_desc[128], define_name[128];
-	const char *plain_comment = "eBPF map_type ";
+	const char *mtype_name, *plain_comment = "eBPF map_type ";
 	size_t maxlen;
 	bool res;
 
 	res = bpf_probe_map_type(map_type, ifindex);
 
+	if (libbpf_map_type_to_str(map_type, &mtype_name)) {
+		p_info("map type name does not exist");
+		return;
+	}
+
 	maxlen = sizeof(plain_desc) - strlen(plain_comment) - 1;
-	if (strlen(map_type_name[map_type]) > maxlen) {
+	if (strlen(mtype_name) > maxlen) {
 		p_info("map type name too long");
 		return;
 	}
 
-	sprintf(feat_name, "have_%s_map_type", map_type_name[map_type]);
-	sprintf(define_name, "%s_map_type", map_type_name[map_type]);
+	sprintf(feat_name, "have_%s_map_type", mtype_name);
+	sprintf(define_name, "%s_map_type", mtype_name);
 	uppercase(define_name, sizeof(define_name));
-	sprintf(plain_desc, "%s%s", plain_comment, map_type_name[map_type]);
+	sprintf(plain_desc, "%s%s", plain_comment, mtype_name);
 	print_bool_feature(feat_name, plain_desc, define_name, res,
 			   define_prefix);
 }
@@ -523,11 +533,16 @@ static void
 probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
 			   const char *define_prefix, __u32 ifindex)
 {
-	const char *ptype_name = prog_type_name[prog_type];
+	const char *ptype_name;
 	char feat_name[128];
 	unsigned int id;
 	bool res;
 
+	if (libbpf_prog_type_to_str(prog_type, &ptype_name)) {
+		p_info("map type name does not exist");
+		return;
+	}
+
 	if (ifindex)
 		/* Only test helpers for offload-able program types */
 		switch (prog_type) {
@@ -689,7 +704,7 @@ static int do_probe(int argc, char **argv)
 				     "/*** eBPF program types ***/",
 				     define_prefix);
 
-	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < ARRAY_SIZE(prog_type_name); i++)
+	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < __MAX_BPF_PROG_TYPE; i++)
 		probe_prog_type(i, supported_types, define_prefix, ifindex);
 
 	print_end_then_start_section("map_types",
@@ -697,7 +712,7 @@ static int do_probe(int argc, char **argv)
 				     "/*** eBPF map types ***/",
 				     define_prefix);
 
-	for (i = BPF_MAP_TYPE_UNSPEC + 1; i < map_type_name_size; i++)
+	for (i = BPF_MAP_TYPE_UNSPEC + 1; i < __MAX_BPF_MAP_TYPE; i++)
 		probe_map_type(i, define_prefix, ifindex);
 
 	print_end_then_start_section("helpers",
@@ -720,9 +735,9 @@ static int do_probe(int argc, char **argv)
 		       "	%sBPF__PROG_TYPE_ ## prog_type ## __HELPER_ ## helper\n",
 		       define_prefix, define_prefix, define_prefix,
 		       define_prefix);
-	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < ARRAY_SIZE(prog_type_name); i++)
-		probe_helpers_for_progtype(i, supported_types[i],
-					   define_prefix, ifindex);
+	for (i = BPF_PROG_TYPE_UNSPEC + 1; i <= __MAX_BPF_PROG_TYPE; i++)
+		probe_helpers_for_progtype(i, supported_types[i], define_prefix,
+					   ifindex);
 
 exit_close_json:
 	if (json_output) {
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index af9ad56c303a..bb840d900fb4 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -48,39 +48,6 @@
 	"\t            {-m|--mapcompat} | {-n|--nomount} }"
 #define HELP_SPEC_MAP							\
 	"MAP := { id MAP_ID | pinned FILE }"
-
-static const char * const prog_type_name[] = {
-	[BPF_PROG_TYPE_UNSPEC]			= "unspec",
-	[BPF_PROG_TYPE_SOCKET_FILTER]		= "socket_filter",
-	[BPF_PROG_TYPE_KPROBE]			= "kprobe",
-	[BPF_PROG_TYPE_SCHED_CLS]		= "sched_cls",
-	[BPF_PROG_TYPE_SCHED_ACT]		= "sched_act",
-	[BPF_PROG_TYPE_TRACEPOINT]		= "tracepoint",
-	[BPF_PROG_TYPE_XDP]			= "xdp",
-	[BPF_PROG_TYPE_PERF_EVENT]		= "perf_event",
-	[BPF_PROG_TYPE_CGROUP_SKB]		= "cgroup_skb",
-	[BPF_PROG_TYPE_CGROUP_SOCK]		= "cgroup_sock",
-	[BPF_PROG_TYPE_LWT_IN]			= "lwt_in",
-	[BPF_PROG_TYPE_LWT_OUT]			= "lwt_out",
-	[BPF_PROG_TYPE_LWT_XMIT]		= "lwt_xmit",
-	[BPF_PROG_TYPE_SOCK_OPS]		= "sock_ops",
-	[BPF_PROG_TYPE_SK_SKB]			= "sk_skb",
-	[BPF_PROG_TYPE_CGROUP_DEVICE]		= "cgroup_device",
-	[BPF_PROG_TYPE_SK_MSG]			= "sk_msg",
-	[BPF_PROG_TYPE_RAW_TRACEPOINT]		= "raw_tracepoint",
-	[BPF_PROG_TYPE_CGROUP_SOCK_ADDR]	= "cgroup_sock_addr",
-	[BPF_PROG_TYPE_LWT_SEG6LOCAL]		= "lwt_seg6local",
-	[BPF_PROG_TYPE_LIRC_MODE2]		= "lirc_mode2",
-	[BPF_PROG_TYPE_SK_REUSEPORT]		= "sk_reuseport",
-	[BPF_PROG_TYPE_FLOW_DISSECTOR]		= "flow_dissector",
-	[BPF_PROG_TYPE_CGROUP_SYSCTL]		= "cgroup_sysctl",
-	[BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE]	= "raw_tracepoint_writable",
-	[BPF_PROG_TYPE_CGROUP_SOCKOPT]		= "cgroup_sockopt",
-};
-
-extern const char * const map_type_name[];
-extern const size_t map_type_name_size;
-
 enum bpf_obj_type {
 	BPF_OBJ_UNKNOWN,
 	BPF_OBJ_PROG,
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index de61d73b9030..ca3760b5c33e 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -16,42 +16,12 @@
 #include <sys/stat.h>
 
 #include <bpf.h>
+#include <libbpf.h>
 
 #include "btf.h"
 #include "json_writer.h"
 #include "main.h"
 
-const char * const map_type_name[] = {
-	[BPF_MAP_TYPE_UNSPEC]			= "unspec",
-	[BPF_MAP_TYPE_HASH]			= "hash",
-	[BPF_MAP_TYPE_ARRAY]			= "array",
-	[BPF_MAP_TYPE_PROG_ARRAY]		= "prog_array",
-	[BPF_MAP_TYPE_PERF_EVENT_ARRAY]		= "perf_event_array",
-	[BPF_MAP_TYPE_PERCPU_HASH]		= "percpu_hash",
-	[BPF_MAP_TYPE_PERCPU_ARRAY]		= "percpu_array",
-	[BPF_MAP_TYPE_STACK_TRACE]		= "stack_trace",
-	[BPF_MAP_TYPE_CGROUP_ARRAY]		= "cgroup_array",
-	[BPF_MAP_TYPE_LRU_HASH]			= "lru_hash",
-	[BPF_MAP_TYPE_LRU_PERCPU_HASH]		= "lru_percpu_hash",
-	[BPF_MAP_TYPE_LPM_TRIE]			= "lpm_trie",
-	[BPF_MAP_TYPE_ARRAY_OF_MAPS]		= "array_of_maps",
-	[BPF_MAP_TYPE_HASH_OF_MAPS]		= "hash_of_maps",
-	[BPF_MAP_TYPE_DEVMAP]			= "devmap",
-	[BPF_MAP_TYPE_DEVMAP_HASH]		= "devmap_hash",
-	[BPF_MAP_TYPE_SOCKMAP]			= "sockmap",
-	[BPF_MAP_TYPE_CPUMAP]			= "cpumap",
-	[BPF_MAP_TYPE_XSKMAP]			= "xskmap",
-	[BPF_MAP_TYPE_SOCKHASH]			= "sockhash",
-	[BPF_MAP_TYPE_CGROUP_STORAGE]		= "cgroup_storage",
-	[BPF_MAP_TYPE_REUSEPORT_SOCKARRAY]	= "reuseport_sockarray",
-	[BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE]	= "percpu_cgroup_storage",
-	[BPF_MAP_TYPE_QUEUE]			= "queue",
-	[BPF_MAP_TYPE_STACK]			= "stack",
-	[BPF_MAP_TYPE_SK_STORAGE]		= "sk_storage",
-};
-
-const size_t map_type_name_size = ARRAY_SIZE(map_type_name);
-
 static bool map_is_per_cpu(__u32 type)
 {
 	return type == BPF_MAP_TYPE_PERCPU_HASH ||
@@ -71,17 +41,6 @@ static bool map_is_map_of_progs(__u32 type)
 	return type == BPF_MAP_TYPE_PROG_ARRAY;
 }
 
-static int map_type_from_str(const char *type)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(map_type_name); i++)
-		/* Don't allow prefixing in case of possible future shadowing */
-		if (map_type_name[i] && !strcmp(map_type_name[i], type))
-			return i;
-	return -1;
-}
-
 static void *alloc_value(struct bpf_map_info *info)
 {
 	if (map_is_per_cpu(info->type))
@@ -481,6 +440,8 @@ static int parse_elem(char **argv, struct bpf_map_info *info,
 
 static int show_map_close_json(int fd, struct bpf_map_info *info)
 {
+	const char *ptype_name, *mtype_name;
+	enum bpf_prog_type prog_type;
 	char *memlock, *frozen_str;
 	int frozen = 0;
 
@@ -488,11 +449,10 @@ static int show_map_close_json(int fd, struct bpf_map_info *info)
 	frozen_str = get_fdinfo(fd, "frozen");
 
 	jsonw_start_object(json_wtr);
-
 	jsonw_uint_field(json_wtr, "id", info->id);
-	if (info->type < ARRAY_SIZE(map_type_name))
-		jsonw_string_field(json_wtr, "type",
-				   map_type_name[info->type]);
+
+	if (!libbpf_map_type_to_str(info->type, &mtype_name))
+		jsonw_string_field(json_wtr, "type", mtype_name);
 	else
 		jsonw_uint_field(json_wtr, "type", info->type);
 
@@ -517,11 +477,11 @@ static int show_map_close_json(int fd, struct bpf_map_info *info)
 		char *owner_jited = get_fdinfo(fd, "owner_jited");
 
 		if (owner_prog_type) {
-			unsigned int prog_type = atoi(owner_prog_type);
+			prog_type = atoi(owner_prog_type);
 
-			if (prog_type < ARRAY_SIZE(prog_type_name))
+			if (!libbpf_prog_type_to_str(prog_type, &ptype_name))
 				jsonw_string_field(json_wtr, "owner_prog_type",
-						   prog_type_name[prog_type]);
+						   ptype_name);
 			else
 				jsonw_uint_field(json_wtr, "owner_prog_type",
 						 prog_type);
@@ -563,6 +523,7 @@ static int show_map_close_json(int fd, struct bpf_map_info *info)
 
 static int show_map_close_plain(int fd, struct bpf_map_info *info)
 {
+	const char *mtype_name, *ptype_name;
 	char *memlock, *frozen_str;
 	int frozen = 0;
 
@@ -570,8 +531,9 @@ static int show_map_close_plain(int fd, struct bpf_map_info *info)
 	frozen_str = get_fdinfo(fd, "frozen");
 
 	printf("%u: ", info->id);
-	if (info->type < ARRAY_SIZE(map_type_name))
-		printf("%s  ", map_type_name[info->type]);
+
+	if (!libbpf_map_type_to_str(info->type, &mtype_name))
+		printf("%s  ", mtype_name);
 	else
 		printf("type %u  ", info->type);
 
@@ -596,10 +558,8 @@ static int show_map_close_plain(int fd, struct bpf_map_info *info)
 			printf("\n\t");
 		if (owner_prog_type) {
 			unsigned int prog_type = atoi(owner_prog_type);
-
-			if (prog_type < ARRAY_SIZE(prog_type_name))
-				printf("owner_prog_type %s  ",
-				       prog_type_name[prog_type]);
+			if (!libbpf_prog_type_to_str(prog_type, &ptype_name))
+				printf("owner_prog_type %s  ", ptype_name);
 			else
 				printf("owner_prog_type %d  ", prog_type);
 		}
@@ -772,6 +732,7 @@ static int do_dump(int argc, char **argv)
 	unsigned int num_elems = 0;
 	__u32 len = sizeof(info);
 	json_writer_t *btf_wtr;
+	const char *mtype_name;
 	struct btf *btf = NULL;
 	int err;
 	int fd;
@@ -813,10 +774,14 @@ static int do_dump(int argc, char **argv)
 			}
 		}
 
+		if (libbpf_map_type_to_str(info.type, &mtype_name)) {
+			p_info("map type name does not exist");
+			goto exit_free;
+		}
 	if (info.type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY &&
 	    info.value_size != 8)
 		p_info("Warning: cannot read values from %s map with value_size != 8",
-		       map_type_name[info.type]);
+		       mtype_name);
 	while (true) {
 		err = bpf_map_get_next_key(fd, prev_key, key);
 		if (err) {
@@ -1150,8 +1115,7 @@ static int do_create(int argc, char **argv)
 				return -1;
 			}
 
-			attr.map_type = map_type_from_str(*argv);
-			if ((int)attr.map_type < 0) {
+			if (libbpf_map_type_from_str(*argv, &attr.map_type)) {
 				p_err("unrecognized map type: %s", *argv);
 				return -1;
 			}
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 66f04a4846a5..8bbb24339a52 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -196,13 +196,13 @@ static void show_prog_maps(int fd, u32 num_maps)
 
 static void print_prog_json(struct bpf_prog_info *info, int fd)
 {
+	const char *ptype_name;
 	char *memlock;
 
 	jsonw_start_object(json_wtr);
 	jsonw_uint_field(json_wtr, "id", info->id);
-	if (info->type < ARRAY_SIZE(prog_type_name))
-		jsonw_string_field(json_wtr, "type",
-				   prog_type_name[info->type]);
+	if (!libbpf_prog_type_to_str(info->type, &ptype_name))
+		jsonw_string_field(json_wtr, "type", ptype_name);
 	else
 		jsonw_uint_field(json_wtr, "type", info->type);
 
@@ -270,11 +270,12 @@ static void print_prog_json(struct bpf_prog_info *info, int fd)
 
 static void print_prog_plain(struct bpf_prog_info *info, int fd)
 {
+	const char *ptype_name;
 	char *memlock;
 
 	printf("%u: ", info->id);
-	if (info->type < ARRAY_SIZE(prog_type_name))
-		printf("%s  ", prog_type_name[info->type]);
+	if (!libbpf_prog_type_to_str(info->type, &ptype_name))
+		printf("%s  ", ptype_name);
 	else
 		printf("type %u  ", info->type);
 
-- 
2.17.1

