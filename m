Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D27911EF5D
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 01:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfLNAsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 19:48:04 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43762 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726890AbfLNAsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 19:48:03 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBE0Vunf014043
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:48:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=oLbwrkPk93pTDrz6Mlvl/uQqOvz+UQshqcWwP4NZztU=;
 b=ioNdXgbXpNxeOigwJAEUUqXouJ1rW/Jzc/7oEfQFCG9ZPl8yMdMoch3SKwH5DWN+1XW7
 cA9cIu9btXjpoGZjzmIH+1bS32K5ch//wwhcQGFYfA3ftJwWsgDVDlUDXKKyzAugWVlh
 GXtcHmysp6ldkLMcv9K9/aflRuFYtXUGorI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvev5swph-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:48:01 -0800
Received: from intmgw003.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 16:47:59 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 8C34D2943AB4; Fri, 13 Dec 2019 16:47:58 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
Date:   Fri, 13 Dec 2019 16:47:58 -0800
Message-ID: <20191214004758.1653342-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191214004737.1652076-1-kafai@fb.com>
References: <20191214004737.1652076-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=756 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=13 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912140001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a helper to handle jiffies.  Some of the
tcp_sock's timing is stored in jiffies.  Although things
could be deduced by CONFIG_HZ, having an easy way to get
jiffies will make the later bpf-tcp-cc implementation easier.

While at it, instead of reading jiffies alone, it also takes a
"flags" argument to help converting between ns and jiffies.

This helper is available to CAP_SYS_ADMIN.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h      |  1 +
 include/uapi/linux/bpf.h | 16 +++++++++++++++-
 kernel/bpf/core.c        |  1 +
 kernel/bpf/helpers.c     | 25 +++++++++++++++++++++++++
 net/core/filter.c        |  2 ++
 5 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 349cedd7b97b..00491961421e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1371,6 +1371,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_jiffies_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 602449a56dde..cf864a5f7d61 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2835,6 +2835,16 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure.
  *
+ * u64 bpf_jiffies(u64 in, u64 flags)
+ *	Description
+ *		jiffies helper.
+ *	Return
+ *		*flags*: 0, return the current jiffies.
+ *			 BPF_F_NS_TO_JIFFIES, convert *in* from ns to jiffies.
+ *			 BPF_F_JIFFIES_TO_NS, convert *in* from jiffies to
+ *			 ns.  If *in* is zero, it returns the current
+ *			 jiffies as ns.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2953,7 +2963,8 @@ union bpf_attr {
 	FN(probe_read_kernel),		\
 	FN(probe_read_user_str),	\
 	FN(probe_read_kernel_str),	\
-	FN(tcp_send_ack),
+	FN(tcp_send_ack),		\
+	FN(jiffies),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3032,6 +3043,9 @@ enum bpf_func_id {
 /* BPF_FUNC_sk_storage_get flags */
 #define BPF_SK_STORAGE_GET_F_CREATE	(1ULL << 0)
 
+#define BPF_F_NS_TO_JIFFIES		(1ULL << 0)
+#define BPF_F_JIFFIES_TO_NS		(1ULL << 1)
+
 /* Mode for BPF_FUNC_skb_adjust_room helper. */
 enum bpf_adj_room_mode {
 	BPF_ADJ_ROOM_NET,
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 2ff01a716128..0ffbda9a13e9 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2134,6 +2134,7 @@ const struct bpf_func_proto bpf_map_pop_elem_proto __weak;
 const struct bpf_func_proto bpf_map_peek_elem_proto __weak;
 const struct bpf_func_proto bpf_spin_lock_proto __weak;
 const struct bpf_func_proto bpf_spin_unlock_proto __weak;
+const struct bpf_func_proto bpf_jiffies_proto __weak;
 
 const struct bpf_func_proto bpf_get_prandom_u32_proto __weak;
 const struct bpf_func_proto bpf_get_smp_processor_id_proto __weak;
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index cada974c9f4e..e87c332d1b61 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -11,6 +11,7 @@
 #include <linux/uidgid.h>
 #include <linux/filter.h>
 #include <linux/ctype.h>
+#include <linux/jiffies.h>
 
 #include "../../lib/kstrtox.h"
 
@@ -486,4 +487,28 @@ const struct bpf_func_proto bpf_strtoul_proto = {
 	.arg3_type	= ARG_ANYTHING,
 	.arg4_type	= ARG_PTR_TO_LONG,
 };
+
+BPF_CALL_2(bpf_jiffies, u64, in, u64, flags)
+{
+	if (!flags)
+		return get_jiffies_64();
+
+	if (flags & BPF_F_NS_TO_JIFFIES) {
+		return nsecs_to_jiffies(in);
+	} else if (flags & BPF_F_JIFFIES_TO_NS) {
+		if (!in)
+			in = get_jiffies_64();
+		return jiffies_to_nsecs(in);
+	}
+
+	return 0;
+}
+
+const struct bpf_func_proto bpf_jiffies_proto = {
+	.func		= bpf_jiffies,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING,
+};
 #endif
diff --git a/net/core/filter.c b/net/core/filter.c
index fbb3698026bd..355746715901 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6015,6 +6015,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_spin_unlock_proto;
 	case BPF_FUNC_trace_printk:
 		return bpf_get_trace_printk_proto();
+	case BPF_FUNC_jiffies:
+		return &bpf_jiffies_proto;
 	default:
 		return NULL;
 	}
-- 
2.17.1

