Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFFBBFCE3F
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfKNS5a convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Nov 2019 13:57:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16514 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727059AbfKNS53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:57:29 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAEIeS8n028194
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:28 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w8n9s6xyy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:28 -0800
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 14 Nov 2019 10:57:27 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 0E5C176071B; Thu, 14 Nov 2019 10:57:27 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 03/20] bpf: Add bpf_arch_text_poke() helper
Date:   Thu, 14 Nov 2019 10:57:03 -0800
Message-ID: <20191114185720.1641606-4-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114185720.1641606-1-ast@kernel.org>
References: <20191114185720.1641606-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 phishscore=0 clxscore=1034
 lowpriorityscore=0 malwarescore=0 suspectscore=1 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_arch_text_poke() helper that is used by BPF trampoline logic to patch
nops/calls in kernel text into calls into BPF trampoline and to patch
calls/nops inside BPF programs too.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
---
 arch/x86/net/bpf_jit_comp.c | 51 +++++++++++++++++++++++++++++++++++++
 include/linux/bpf.h         |  8 ++++++
 kernel/bpf/core.c           |  6 +++++
 3 files changed, 65 insertions(+)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index fb99d976ad6e..254b2889e881 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -9,9 +9,11 @@
 #include <linux/filter.h>
 #include <linux/if_vlan.h>
 #include <linux/bpf.h>
+#include <linux/memory.h>
 #include <asm/extable.h>
 #include <asm/set_memory.h>
 #include <asm/nospec-branch.h>
+#include <asm/text-patching.h>
 
 static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
 {
@@ -486,6 +488,55 @@ static int emit_call(u8 **pprog, void *func, void *ip)
 	return 0;
 }
 
+int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
+		       void *old_addr, void *new_addr)
+{
+	u8 old_insn[X86_CALL_SIZE] = {};
+	u8 new_insn[X86_CALL_SIZE] = {};
+	u8 *prog;
+	int ret;
+
+	if (!is_kernel_text((long)ip))
+		/* BPF trampoline in modules is not supported */
+		return -EINVAL;
+
+	if (old_addr) {
+		prog = old_insn;
+		ret = emit_call(&prog, old_addr, (void *)ip);
+		if (ret)
+			return ret;
+	}
+	if (new_addr) {
+		prog = new_insn;
+		ret = emit_call(&prog, new_addr, (void *)ip);
+		if (ret)
+			return ret;
+	}
+	ret = -EBUSY;
+	mutex_lock(&text_mutex);
+	switch (t) {
+	case BPF_MOD_NOP_TO_CALL:
+		if (memcmp(ip, ideal_nops[NOP_ATOMIC5], X86_CALL_SIZE))
+			goto out;
+		text_poke_bp(ip, new_insn, X86_CALL_SIZE, NULL);
+		break;
+	case BPF_MOD_CALL_TO_CALL:
+		if (memcmp(ip, old_insn, X86_CALL_SIZE))
+			goto out;
+		text_poke_bp(ip, new_insn, X86_CALL_SIZE, NULL);
+		break;
+	case BPF_MOD_CALL_TO_NOP:
+		if (memcmp(ip, old_insn, X86_CALL_SIZE))
+			goto out;
+		text_poke_bp(ip, ideal_nops[NOP_ATOMIC5], X86_CALL_SIZE, NULL);
+		break;
+	}
+	ret = 0;
+out:
+	mutex_unlock(&text_mutex);
+	return ret;
+}
+
 static bool ex_handler_bpf(const struct exception_table_entry *x,
 			   struct pt_regs *regs, int trapnr,
 			   unsigned long error_code, unsigned long fault_addr)
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7c7f518811a6..8b90db25348a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1157,4 +1157,12 @@ static inline u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
 }
 #endif /* CONFIG_INET */
 
+enum bpf_text_poke_type {
+	BPF_MOD_NOP_TO_CALL,
+	BPF_MOD_CALL_TO_CALL,
+	BPF_MOD_CALL_TO_NOP,
+};
+int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
+		       void *addr1, void *addr2);
+
 #endif /* _LINUX_BPF_H */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c1fde0303280..c4bcec1014a9 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2140,6 +2140,12 @@ int __weak skb_copy_bits(const struct sk_buff *skb, int offset, void *to,
 	return -EFAULT;
 }
 
+int __weak bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
+			      void *addr1, void *addr2)
+{
+	return -ENOTSUPP;
+}
+
 DEFINE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 EXPORT_SYMBOL(bpf_stats_enabled_key);
 
-- 
2.23.0

