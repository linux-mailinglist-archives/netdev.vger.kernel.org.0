Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B64D2ED0B2
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 23:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfKBWAc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 2 Nov 2019 18:00:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34750 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726675AbfKBWAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 18:00:32 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA2M0Umw022255
        for <netdev@vger.kernel.org>; Sat, 2 Nov 2019 15:00:30 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w17ant4h1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 15:00:30 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 2 Nov 2019 15:00:29 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id E2389760F5C; Sat,  2 Nov 2019 15:00:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <peterz@infradead.org>,
        <rostedt@goodmis.org>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/7] bpf, ftrace: temporary workaround
Date:   Sat, 2 Nov 2019 15:00:19 -0700
Message-ID: <20191102220025.2475981-2-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191102220025.2475981-1-ast@kernel.org>
References: <20191102220025.2475981-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-02_13:2019-11-01,2019-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 mlxlogscore=943
 malwarescore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 spamscore=0
 suspectscore=1 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1911020218
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add temporary workaround until proper register_ftrace_direct() api lands. This
commit must be reverted during upcoming merge window. The hack functions don't
have safety checks that ftrace api performs.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 arch/x86/kernel/ftrace.c | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/bpf.h      |  5 +++++
 kernel/bpf/core.c        | 30 ++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 024c3053dbba..0fd7643da92d 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -265,6 +265,42 @@ static int update_ftrace_func(unsigned long ip, void *new)
 	return ret;
 }
 
+/*
+ * There are no safety checks here. It's a temporary hack until proper
+ * register_ftrace_direct() api lands. These functions blindly rewrite kernel
+ * text. Proper register_ftrace_direct() should check that IP is one of allowed
+ * fentry points. unregister_ftrace_direct() and modify_ftrace_direct() should
+ * do similar checks.
+ */
+int arch_register_ftrace_hack(unsigned long ip, unsigned long addr)
+{
+	u8 *new;
+	int ret;
+
+	ftrace_arch_code_modify_prepare();
+	new = ftrace_call_replace(ip, addr);
+	ret = update_ftrace_func(ip, new);
+	ftrace_arch_code_modify_post_process();
+	return ret;
+}
+
+int arch_unregister_ftrace_hack(unsigned long ip, unsigned long addr)
+{
+	u8 *old;
+	int ret;
+
+	ftrace_arch_code_modify_prepare();
+	old = (void *)ftrace_nop_replace();
+	ret = update_ftrace_func(ip, old);
+	ftrace_arch_code_modify_post_process();
+	return ret;
+}
+
+int arch_modify_ftrace_hack(unsigned long ip, unsigned long addr)
+{
+	return arch_register_ftrace_hack(ip, addr);
+}
+
 int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7c7f518811a6..a8941f113298 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1157,4 +1157,9 @@ static inline u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
 }
 #endif /* CONFIG_INET */
 
+/* workaround */
+int register_ftrace_direct(unsigned long ip, unsigned long addr);
+int unregister_ftrace_direct(unsigned long ip, unsigned long addr);
+int modify_ftrace_direct(unsigned long ip, unsigned long addr);
+
 #endif /* _LINUX_BPF_H */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index df82d5a42b23..1bacf70e6509 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2140,6 +2140,36 @@ int __weak skb_copy_bits(const struct sk_buff *skb, int offset, void *to,
 	return -EFAULT;
 }
 
+int __weak arch_register_ftrace_hack(unsigned long ip, unsigned long addr)
+{
+	return -ENOTSUPP;
+}
+
+int __weak register_ftrace_direct(unsigned long ip, unsigned long addr)
+{
+	return arch_register_ftrace_hack(ip, addr);
+}
+
+int __weak arch_unregister_ftrace_hack(unsigned long ip, unsigned long addr)
+{
+	return -ENOTSUPP;
+}
+
+int __weak unregister_ftrace_direct(unsigned long ip, unsigned long addr)
+{
+	return arch_unregister_ftrace_hack(ip, addr);
+}
+
+int __weak arch_modify_ftrace_hack(unsigned long ip, unsigned long addr)
+{
+	return -ENOTSUPP;
+}
+
+int __weak modify_ftrace_direct(unsigned long ip, unsigned long addr)
+{
+	return arch_modify_ftrace_hack(ip, addr);
+}
+
 DEFINE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 EXPORT_SYMBOL(bpf_stats_enabled_key);
 
-- 
2.23.0

