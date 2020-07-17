Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D61E224351
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgGQSrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:47:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26480 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728159AbgGQSrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 14:47:12 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HIZ8o8030788
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 11:47:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+WjxlQfmO63N0MdiH4e65kCAwb958zHuzw4cGIBJ3nA=;
 b=KBfFLn3/6ux/E9OEZbe1ZJHqh43tp0A7wRYPRylBfK9X+uMQph13H/EVx980Iwck8mMD
 omIlaEwKu/djMD64pt4F2o4iCr61k0x5w7k8RoWr8f2NXOR/Pg3WrbL+SuAYlO4e4oOL
 +7Lot+Do09JNji0DvtxOVCwvD1hl9nzLyf4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32a7x7tpf3-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 11:47:11 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 17 Jul 2020 11:47:09 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id A20AC3704BBE; Fri, 17 Jul 2020 11:47:07 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/2] bpf: compute bpf_skc_to_*() helper socket btf ids at build time
Date:   Fri, 17 Jul 2020 11:47:07 -0700
Message-ID: <20200717184707.3477423-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200717184706.3476992-1-yhs@fb.com>
References: <20200717184706.3476992-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_09:2020-07-17,2020-07-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=25 clxscore=1015 mlxlogscore=999 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007170130
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, socket types (struct tcp_sock, udp_sock, etc.)
used by bpf_skc_to_*() helpers are computed when vmlinux_btf
is first built in the kernel.

Commit 5a2798ab32ba
("bpf: Add BTF_ID_LIST/BTF_ID/BTF_ID_UNUSED macros")
implemented a mechanism to compute btf_ids at kernel build
time which can simplify kernel implementation and reduce
runtime overhead by removing in-kernel btf_id calculation.
This patch did exactly this, removing in-kernel btf_id
computation and utilizing build-time btf_id computation.

If CONFIG_DEBUG_INFO_BTF is not defined, BTF_ID_LIST will
define an array with size of 5, which is not enough for
btf_sock_ids. So define its own static array if
CONFIG_DEBUG_INFO_BTF is not defined.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h |  4 ----
 kernel/bpf/btf.c    |  1 -
 net/core/filter.c   | 49 +++++++++++++++++----------------------------
 3 files changed, 18 insertions(+), 36 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 54ad426dbea1..bc7a4e475d5c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1537,7 +1537,6 @@ static inline bool bpf_map_is_dev_bound(struct bpf_=
map *map)
=20
 struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr);
 void bpf_map_offload_map_free(struct bpf_map *map);
-void init_btf_sock_ids(struct btf *btf);
 #else
 static inline int bpf_prog_offload_init(struct bpf_prog *prog,
 					union bpf_attr *attr)
@@ -1563,9 +1562,6 @@ static inline struct bpf_map *bpf_map_offload_map_a=
lloc(union bpf_attr *attr)
 static inline void bpf_map_offload_map_free(struct bpf_map *map)
 {
 }
-static inline void init_btf_sock_ids(struct btf *btf)
-{
-}
 #endif /* CONFIG_NET && CONFIG_BPF_SYSCALL */
=20
 #if defined(CONFIG_BPF_STREAM_PARSER)
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 03d6d43bb1d6..315cde73421b 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3672,7 +3672,6 @@ struct btf *btf_parse_vmlinux(void)
 		goto errout;
=20
 	bpf_struct_ops_init(btf, log);
-	init_btf_sock_ids(btf);
=20
 	btf_verifier_env_free(env);
 	refcount_set(&btf->refcnt, 1);
diff --git a/net/core/filter.c b/net/core/filter.c
index bdd2382e655d..d861455ec7bd 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9243,19 +9243,19 @@ void bpf_prog_change_xdp(struct bpf_prog *prev_pr=
og, struct bpf_prog *prog)
  * sock_common as the first argument in its memory layout.
  */
 #define BTF_SOCK_TYPE_xxx \
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET, "inet_sock")			\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_CONN, "inet_connection_sock")	\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_REQ, "inet_request_sock")	\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, "inet_timewait_sock")	\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_REQ, "request_sock")		\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK, "sock")			\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK_COMMON, "sock_common")		\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP, "tcp_sock")			\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_REQ, "tcp_request_sock")	\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, "tcp_timewait_sock")	\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, "tcp6_sock")			\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, "udp_sock")			\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, "udp6_sock")
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET, inet_sock)			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_CONN, inet_connection_sock)	\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_REQ, inet_request_sock)	\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)	\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_REQ, request_sock)			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK, sock)				\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK_COMMON, sock_common)		\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP, tcp_sock)			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_REQ, tcp_request_sock)		\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)		\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
=20
 enum {
 #define BTF_SOCK_TYPE(name, str) name,
@@ -9264,26 +9264,13 @@ BTF_SOCK_TYPE_xxx
 MAX_BTF_SOCK_TYPE,
 };
=20
-static int btf_sock_ids[MAX_BTF_SOCK_TYPE];
-
-#ifdef CONFIG_BPF_SYSCALL
-static const char *bpf_sock_types[] =3D {
-#define BTF_SOCK_TYPE(name, str) str,
+#ifdef CONFIG_DEBUG_INFO_BTF
+BTF_ID_LIST(btf_sock_ids)
+#define BTF_SOCK_TYPE(name, type) BTF_ID(struct, type)
 BTF_SOCK_TYPE_xxx
 #undef BTF_SOCK_TYPE
-};
-
-void init_btf_sock_ids(struct btf *btf)
-{
-	int i, btf_id;
-
-	for (i =3D 0; i < MAX_BTF_SOCK_TYPE; i++) {
-		btf_id =3D btf_find_by_name_kind(btf, bpf_sock_types[i],
-					       BTF_KIND_STRUCT);
-		if (btf_id > 0)
-			btf_sock_ids[i] =3D btf_id;
-	}
-}
+#else
+static u32 btf_sock_ids[MAX_BTF_SOCK_TYPE];
 #endif
=20
 static bool check_arg_btf_id(u32 btf_id, u32 arg)
--=20
2.24.1

