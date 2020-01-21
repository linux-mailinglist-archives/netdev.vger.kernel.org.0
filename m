Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DECD144571
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 20:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgAUTyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 14:54:23 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2546 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728205AbgAUTyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 14:54:23 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00LJqdf6016154
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 11:54:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=aTBnajkVhnCIn48XAGN58xRK8qz/62jfbsJ8N33w5hY=;
 b=mdPSUSvKzNuOagHUs5+I4vKOHtPdIAnbjHwTWqrhJgVe6AzuINaYqjgXHfDAcVFWEg1y
 C0NDPu9xw4NLAEp+WQi7m0CvzKOzaV+YeoDCllEdldgo+YUOWSuAreGYTZDBJ4QDMhrG
 vv9lZYtnWrQIl5M4lzazwtGfbRDBwHzojKk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xnky84khc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 11:54:22 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 21 Jan 2020 11:54:21 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id B11EC29420B3; Tue, 21 Jan 2020 11:54:14 -0800 (PST)
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
Subject: [PATCH bpf-next 1/3] bpf: Add BPF_FUNC_jiffies64
Date:   Tue, 21 Jan 2020 11:54:14 -0800
Message-ID: <20200121195414.3757563-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121195408.3756734-1-kafai@fb.com>
References: <20200121195408.3756734-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.634
 definitions=2020-01-21_06:2020-01-21,2020-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 suspectscore=13 impostorscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001210147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a helper to read the 64bit jiffies.  It will be used
in a later patch to implement the bpf_cubic.c.

The helper is inlined.  "gen_inline" is added to "struct bpf_func_proto"
to do that.  This helper is available to CAP_SYS_ADMIN.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h      |  2 ++
 include/uapi/linux/bpf.h |  9 ++++++++-
 kernel/bpf/core.c        |  1 +
 kernel/bpf/helpers.c     | 27 +++++++++++++++++++++++++++
 kernel/bpf/verifier.c    | 18 ++++++++++++++++++
 net/core/filter.c        |  2 ++
 6 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8e3b8f4ad183..3d85ef44b247 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -258,6 +258,7 @@ enum bpf_return_type {
  */
 struct bpf_func_proto {
 	u64 (*func)(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
+	u32 (*gen_inline)(struct bpf_insn *insn_buf);
 	bool gpl_only;
 	bool pkt_access;
 	enum bpf_return_type ret_type;
@@ -1406,6 +1407,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
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
index cada974c9f4e..b241cfd350c4 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -11,6 +11,7 @@
 #include <linux/uidgid.h>
 #include <linux/filter.h>
 #include <linux/ctype.h>
+#include <linux/jiffies.h>
 
 #include "../../lib/kstrtox.h"
 
@@ -312,6 +313,32 @@ void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
 	preempt_enable();
 }
 
+static u32 bpf_jiffies64_gen_inline(struct bpf_insn *insn_buf)
+{
+	struct bpf_insn *insn = insn_buf;
+#if BITS_PER_LONG == 64
+	struct bpf_insn ld_jiffies_addr[2] = {
+		BPF_LD_IMM64(BPF_REG_0, (unsigned long)&jiffies),
+	};
+
+	BUILD_BUG_ON(sizeof(jiffies) != sizeof(unsigned long));
+
+	*insn++ = ld_jiffies_addr[0];
+	*insn++ = ld_jiffies_addr[1];
+	*insn++ = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0);
+#else
+	*insn++ = BPF_EMIT_CALL(BPF_CAST_CALL(get_jiffies_64));
+#endif
+
+	return insn - insn_buf;
+}
+
+const struct bpf_func_proto bpf_jiffies64_proto = {
+	.gen_inline	= bpf_jiffies64_gen_inline,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+};
+
 #ifdef CONFIG_CGROUPS
 BPF_CALL_0(bpf_get_current_cgroup_id)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ca17dccc17ba..91818aad2f80 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9447,6 +9447,24 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 
 patch_call_imm:
 		fn = env->ops->get_func_proto(insn->imm, env->prog);
+		if (fn->gen_inline) {
+			cnt = fn->gen_inline(insn_buf);
+			if (cnt == 0 || cnt >= ARRAY_SIZE(insn_buf)) {
+				verbose(env, "bpf verifier is misconfigured\n");
+				return -EINVAL;
+			}
+
+			new_prog = bpf_patch_insn_data(env, i + delta,
+						       insn_buf, cnt);
+			if (!new_prog)
+				return -ENOMEM;
+
+			delta    += cnt - 1;
+			env->prog = prog = new_prog;
+			insn      = new_prog->insnsi + i + delta;
+			continue;
+		}
+
 		/* all functions that have prototype and verifier allowed
 		 * programs to call them, must be real in-kernel functions
 		 */
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

