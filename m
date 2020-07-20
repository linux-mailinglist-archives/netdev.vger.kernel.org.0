Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D8C226A74
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388998AbgGTQeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:34:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44244 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388009AbgGTQeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:34:17 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KGY1K9019021
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:34:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=TjRIkvvgye1YBKEy6oOU7WEjfpv4EQRQNyzQFDrXXCM=;
 b=SYh4ZkxS7UkefRBmZHkh5TEF2XpHBRyPs8suao8zIsvhnhGTuQtuI+fB39kDYfDMJASd
 uDhZZTvRW3nFw4oNYprvEsuvH72UhDQomKLlprJ8xcfrPjTAjiw2snrwb/xhm4oUj+BM
 4MtvrJl+8tl54EMVuOLMyOoBqP39kgr4BZQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32bxwfqg1h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:34:16 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 20 Jul 2020 09:34:14 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 4FF5E370209A; Mon, 20 Jul 2020 09:34:02 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 4/5] bpf: make btf_sock_ids global
Date:   Mon, 20 Jul 2020 09:34:02 -0700
Message-ID: <20200720163402.1393427-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200720163358.1392964-1-yhs@fb.com>
References: <20200720163358.1392964-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200111
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp and udp bpf_iter can reuse some socket ids in
btf_sock_ids, so make it global.

I put the extern definition in btf_ids.h as a central
place so it can be easily discovered by developers.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/btf_ids.h       | 30 ++++++++++++++++++++++++++++++
 net/core/filter.c             | 30 ++----------------------------
 tools/include/linux/btf_ids.h | 30 ++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 28 deletions(-)

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 77ab45baa095..4867d549e3c1 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -97,4 +97,34 @@ asm(							\
=20
 #endif /* CONFIG_DEBUG_INFO_BTF */
=20
+#ifdef CONFIG_NET
+/* Define a list of socket types which can be the argument for
+ * skc_to_*_sock() helpers. All these sockets should have
+ * sock_common as the first argument in its memory layout.
+ */
+#define BTF_SOCK_TYPE_xxx \
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
+
+enum {
+#define BTF_SOCK_TYPE(name, str) name,
+BTF_SOCK_TYPE_xxx
+#undef BTF_SOCK_TYPE
+MAX_BTF_SOCK_TYPE,
+};
+
+extern u32 btf_sock_ids[];
+#endif
+
 #endif
diff --git a/net/core/filter.c b/net/core/filter.c
index 5a65fb4b95ff..654c346b7d91 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9421,39 +9421,13 @@ void bpf_prog_change_xdp(struct bpf_prog *prev_pr=
og, struct bpf_prog *prog)
 	bpf_dispatcher_change_prog(BPF_DISPATCHER_PTR(xdp), prev_prog, prog);
 }
=20
-/* Define a list of socket types which can be the argument for
- * skc_to_*_sock() helpers. All these sockets should have
- * sock_common as the first argument in its memory layout.
- */
-#define BTF_SOCK_TYPE_xxx \
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET, inet_sock)			\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_CONN, inet_connection_sock)	\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_REQ, inet_request_sock)	\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)	\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_REQ, request_sock)			\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK, sock)				\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK_COMMON, sock_common)		\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP, tcp_sock)			\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_REQ, tcp_request_sock)		\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)		\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
-
-enum {
-#define BTF_SOCK_TYPE(name, str) name,
-BTF_SOCK_TYPE_xxx
-#undef BTF_SOCK_TYPE
-MAX_BTF_SOCK_TYPE,
-};
-
 #ifdef CONFIG_DEBUG_INFO_BTF
-BTF_ID_LIST(btf_sock_ids)
+BTF_ID_LIST_GLOBAL(btf_sock_ids)
 #define BTF_SOCK_TYPE(name, type) BTF_ID(struct, type)
 BTF_SOCK_TYPE_xxx
 #undef BTF_SOCK_TYPE
 #else
-static u32 btf_sock_ids[MAX_BTF_SOCK_TYPE];
+u32 btf_sock_ids[MAX_BTF_SOCK_TYPE];
 #endif
=20
 static bool check_arg_btf_id(u32 btf_id, u32 arg)
diff --git a/tools/include/linux/btf_ids.h b/tools/include/linux/btf_ids.=
h
index 77ab45baa095..4867d549e3c1 100644
--- a/tools/include/linux/btf_ids.h
+++ b/tools/include/linux/btf_ids.h
@@ -97,4 +97,34 @@ asm(							\
=20
 #endif /* CONFIG_DEBUG_INFO_BTF */
=20
+#ifdef CONFIG_NET
+/* Define a list of socket types which can be the argument for
+ * skc_to_*_sock() helpers. All these sockets should have
+ * sock_common as the first argument in its memory layout.
+ */
+#define BTF_SOCK_TYPE_xxx \
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
+
+enum {
+#define BTF_SOCK_TYPE(name, str) name,
+BTF_SOCK_TYPE_xxx
+#undef BTF_SOCK_TYPE
+MAX_BTF_SOCK_TYPE,
+};
+
+extern u32 btf_sock_ids[];
+#endif
+
 #endif
--=20
2.24.1

