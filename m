Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA63B144BD8
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 07:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgAVGmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 01:42:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19300 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726078AbgAVGmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 01:42:03 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00M6ecrc026627
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 22:42:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=/DtnXo7V2j0VmUvpmA1IG3Q9nW32VWWB4y4ElyxILKs=;
 b=VuCEEt1xrCnlolqaPSLqGUhkoAQl0v01RT2/7AkBD0AllNjhEYafCkZSdvFv/fmnlTat
 7t3piPum2dMuLSMEoOZSh8IKVAYsW1XgjyNbZQyVZWX6w2URTBKUEeEXcke+DK72G3H3
 bmoFjBtCzv3tBnHBtYd9Wd1aKTj0nSNg6hc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xnky86svp-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 22:42:02 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 21 Jan 2020 22:42:01 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 846D42944F3E; Tue, 21 Jan 2020 22:41:58 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/3] bpf: Add BPF_FUNC_jiffies64
Date:   Tue, 21 Jan 2020 22:41:58 -0800
Message-ID: <20200122064158.1834037-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122064152.1833564-1-kafai@fb.com>
References: <20200122064152.1833564-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 mlxlogscore=891 spamscore=0
 bulkscore=0 malwarescore=0 suspectscore=13 impostorscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001220059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a helper to read the 64bit jiffies.  It will be used
in a later patch to implement the bpf_cubic.c.

The helper is inlined for jit_requested and 64 BITS_PER_LONG
as the map_gen_lookup().  Other cases could be considered together
with map_gen_lookup() if needed.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h      |  1 +
 include/uapi/linux/bpf.h |  9 ++++++++-
 kernel/bpf/core.c        |  1 +
 kernel/bpf/helpers.c     | 12 ++++++++++++
 kernel/bpf/verifier.c    | 24 ++++++++++++++++++++++++
 net/core/filter.c        |  2 ++
 6 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8e3b8f4ad183..81edd081c00d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1406,6 +1406,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_jiffies64_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 033d90a2282d..d17c6bcd50cd 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2885,6 +2885,12 @@ union bpf_attr {
  *		**-EPERM** if no permission to send the *sig*.
  *
  *		**-EAGAIN** if bpf program can try again.
+ *
+ * u64 bpf_jiffies64(void)
+ *	Description
+ *		Obtain the 64bit jiffies
+ *	Return
+ *		The 64 bit jiffies
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3004,7 +3010,8 @@ union bpf_attr {
 	FN(probe_read_user_str),	\
 	FN(probe_read_kernel_str),	\
 	FN(tcp_send_ack),		\
-	FN(send_signal_thread),
+	FN(send_signal_thread),		\
+	FN(jiffies64),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 29d47aae0dd1..973a20d49749 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2137,6 +2137,7 @@ const struct bpf_func_proto bpf_map_pop_elem_proto __weak;
 const struct bpf_func_proto bpf_map_peek_elem_proto __weak;
 const struct bpf_func_proto bpf_spin_lock_proto __weak;
 const struct bpf_func_proto bpf_spin_unlock_proto __weak;
+const struct bpf_func_proto bpf_jiffies64_proto __weak;
 
 const struct bpf_func_proto bpf_get_prandom_u32_proto __weak;
 const struct bpf_func_proto bpf_get_smp_processor_id_proto __weak;
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index cada974c9f4e..d8b7b110a1c5 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -11,6 +11,7 @@
 #include <linux/uidgid.h>
 #include <linux/filter.h>
 #include <linux/ctype.h>
+#include <linux/jiffies.h>
 
 #include "../../lib/kstrtox.h"
 
@@ -312,6 +313,17 @@ void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
 	preempt_enable();
 }
 
+BPF_CALL_0(bpf_jiffies64)
+{
+	return get_jiffies_64();
+}
+
+const struct bpf_func_proto bpf_jiffies64_proto = {
+	.func		= bpf_jiffies64,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+};
+
 #ifdef CONFIG_CGROUPS
 BPF_CALL_0(bpf_get_current_cgroup_id)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ca17dccc17ba..41915b335813 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9445,6 +9445,30 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			goto patch_call_imm;
 		}
 
+		if (prog->jit_requested && BITS_PER_LONG == 64 &&
+		    insn->imm == BPF_FUNC_jiffies64) {
+			struct bpf_insn ld_jiffies_addr[2] = {
+				BPF_LD_IMM64(BPF_REG_0,
+					     (unsigned long)&jiffies),
+			};
+
+			insn_buf[0] = ld_jiffies_addr[0];
+			insn_buf[1] = ld_jiffies_addr[1];
+			insn_buf[2] = BPF_LDX_MEM(BPF_DW, BPF_REG_0,
+						  BPF_REG_0, 0);
+			cnt = 3;
+
+			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf,
+						       cnt);
+			if (!new_prog)
+				return -ENOMEM;
+
+			delta    += cnt - 1;
+			env->prog = prog = new_prog;
+			insn      = new_prog->insnsi + i + delta;
+			continue;
+		}
+
 patch_call_imm:
 		fn = env->ops->get_func_proto(insn->imm, env->prog);
 		/* all functions that have prototype and verifier allowed
diff --git a/net/core/filter.c b/net/core/filter.c
index 17de6747d9e3..4bf3e4aa8a7a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5923,6 +5923,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_spin_unlock_proto;
 	case BPF_FUNC_trace_printk:
 		return bpf_get_trace_printk_proto();
+	case BPF_FUNC_jiffies64:
+		return &bpf_jiffies64_proto;
 	default:
 		return NULL;
 	}
-- 
2.17.1

