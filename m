Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69BDEF2741
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfKGFqz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Nov 2019 00:46:55 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5646 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725770AbfKGFqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:46:54 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA75dMI1003861
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 21:46:52 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2w41w1kgmq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 21:46:52 -0800
Received: from 2401:db00:2120:80e1:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 21:46:50 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 4F1F4760BC0; Wed,  6 Nov 2019 21:46:48 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 02/17] bpf: Add bpf_arch_text_poke() helper
Date:   Wed, 6 Nov 2019 21:46:29 -0800
Message-ID: <20191107054644.1285697-3-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107054644.1285697-1-ast@kernel.org>
References: <20191107054644.1285697-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911070059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_arch_text_poke() helper that is used by BPF trampoline logic to patch
nops/calls in kernel text into calls into BPF trampoline and to patch
calls/nops inside BPF programs too.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 51 +++++++++++++++++++++++++++++++++++++
 include/linux/bpf.h         |  8 ++++++
 kernel/bpf/core.c           |  6 +++++
 3 files changed, 65 insertions(+)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 0399b1f83c23..8631d3bd637f 100644
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
@@ -487,6 +489,55 @@ static int emit_call(u8 **pprog, void *func, void *ip)
 	return 0;
 }
 
+int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
+		       void *old_addr, void *new_addr)
+{
+	u8 old_insn[NOP_ATOMIC5] = {};
+	u8 new_insn[NOP_ATOMIC5] = {};
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
+	if (old_addr) {
+		prog = new_insn;
+		ret = emit_call(&prog, old_addr, (void *)ip);
+		if (ret)
+			return ret;
+	}
+	ret = -EBUSY;
+	mutex_lock(&text_mutex);
+	switch (t) {
+	case BPF_MOD_NOP_TO_CALL:
+		if (memcmp(ip, ideal_nops, 5))
+			goto out;
+		text_poke(ip, new_insn, 5);
+		break;
+	case BPF_MOD_CALL_TO_CALL:
+		if (memcmp(ip, old_insn, 5))
+			goto out;
+		text_poke(ip, new_insn, 5);
+		break;
+	case BPF_MOD_CALL_TO_NOP:
+		if (memcmp(ip, old_insn, 5))
+			goto out;
+		text_poke(ip, ideal_nops, 5);
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
index 97e37d82a1cc..856564e97943 100644
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

