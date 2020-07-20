Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C2F226A6F
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388991AbgGTQeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:34:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52814 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730420AbgGTQeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:34:10 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06KGXx3h008475
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:34:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=CLJi3fvfLyab4T98gtAUluQbA/w84o+369SZrwJgNkQ=;
 b=fAdvbcuds/FvnikcYyC2IscSl6M4iH8Jh40TawqVQPwPY7aCFOa4l4hN7pBE/EA9zRdF
 rPpx8AWDEMRir9YUQE+KpZLItaOZyaq3XnwtUjuDGp8nB0H5b0d9zYbJd4WxuQCM5j+2
 NUtvJ+slsSX+nbatxFcyBU/2D0oBdrHcfw0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 32bvrnftbc-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:34:08 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 20 Jul 2020 09:34:02 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 9540A370209A; Mon, 20 Jul 2020 09:33:58 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 1/5] bpf: compute bpf_skc_to_*() helper socket btf ids at build time
Date:   Mon, 20 Jul 2020 09:33:58 -0700
Message-ID: <20200720163358.1393023-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200720163358.1392964-1-yhs@fb.com>
References: <20200720163358.1392964-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=25
 mlxlogscore=999 impostorscore=0 clxscore=1015 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200111
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
index adb16bdc5f0a..1df1c0fd3f28 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1541,7 +1541,6 @@ static inline bool bpf_map_is_dev_bound(struct bpf_=
map *map)
=20
 struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr);
 void bpf_map_offload_map_free(struct bpf_map *map);
-void init_btf_sock_ids(struct btf *btf);
 #else
 static inline int bpf_prog_offload_init(struct bpf_prog *prog,
 					union bpf_attr *attr)
@@ -1567,9 +1566,6 @@ static inline struct bpf_map *bpf_map_offload_map_a=
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
index 2bd129b5ae74..5a65fb4b95ff 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9426,19 +9426,19 @@ void bpf_prog_change_xdp(struct bpf_prog *prev_pr=
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
@@ -9447,26 +9447,13 @@ BTF_SOCK_TYPE_xxx
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

