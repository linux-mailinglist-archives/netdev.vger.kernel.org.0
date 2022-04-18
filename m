Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454BE504B6B
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 05:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236113AbiDRD4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 23:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiDRD4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 23:56:12 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A2118B11;
        Sun, 17 Apr 2022 20:53:34 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KhY203xDLzgYv6;
        Mon, 18 Apr 2022 11:53:28 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 18 Apr 2022 11:53:26 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 18 Apr 2022 11:53:26 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-riscv@lists.infradead.org>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <pulehui@huawei.com>
Subject: [PATCH bpf-next] libbpf: Support riscv USDT argument parsing logic
Date:   Mon, 18 Apr 2022 12:22:22 +0800
Message-ID: <20220418042222.2464199-1-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add riscv-specific USDT argument specification parsing logic.
riscv USDT argument format is shown below:
- Memory dereference case:
  "size@off(reg)", e.g. "-8@-88(s0)"
- Constant value case:
  "size@val", e.g. "4@5"
- Register read case:
  "size@reg", e.g. "-8@a1"

s8 will be marked as poison while it's a reg of riscv, we need
to alias it in advance.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 tools/lib/bpf/usdt.c | 107 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index 934c25301ac1..b8af409cc763 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -10,6 +10,11 @@
 #include <linux/ptrace.h>
 #include <linux/kernel.h>
 
+/* s8 will be marked as poison while it's a reg of riscv */
+#if defined(__riscv)
+#define rv_s8 s8
+#endif
+
 #include "bpf.h"
 #include "libbpf.h"
 #include "libbpf_common.h"
@@ -1400,6 +1405,108 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
 	return len;
 }
 
+#elif defined(__riscv)
+
+static int calc_pt_regs_off(const char *reg_name)
+{
+	static struct {
+		const char *name;
+		size_t pt_regs_off;
+	} reg_map[] = {
+		{ "ra", offsetof(struct user_regs_struct, ra) },
+		{ "sp", offsetof(struct user_regs_struct, sp) },
+		{ "gp", offsetof(struct user_regs_struct, gp) },
+		{ "tp", offsetof(struct user_regs_struct, tp) },
+		{ "t0", offsetof(struct user_regs_struct, t0) },
+		{ "t1", offsetof(struct user_regs_struct, t1) },
+		{ "t2", offsetof(struct user_regs_struct, t2) },
+		{ "s0", offsetof(struct user_regs_struct, s0) },
+		{ "s1", offsetof(struct user_regs_struct, s1) },
+		{ "a0", offsetof(struct user_regs_struct, a0) },
+		{ "a1", offsetof(struct user_regs_struct, a1) },
+		{ "a2", offsetof(struct user_regs_struct, a2) },
+		{ "a3", offsetof(struct user_regs_struct, a3) },
+		{ "a4", offsetof(struct user_regs_struct, a4) },
+		{ "a5", offsetof(struct user_regs_struct, a5) },
+		{ "a6", offsetof(struct user_regs_struct, a6) },
+		{ "a7", offsetof(struct user_regs_struct, a7) },
+		{ "s2", offsetof(struct user_regs_struct, s2) },
+		{ "s3", offsetof(struct user_regs_struct, s3) },
+		{ "s4", offsetof(struct user_regs_struct, s4) },
+		{ "s5", offsetof(struct user_regs_struct, s5) },
+		{ "s6", offsetof(struct user_regs_struct, s6) },
+		{ "s7", offsetof(struct user_regs_struct, s7) },
+		{ "s8", offsetof(struct user_regs_struct, rv_s8) },
+		{ "s9", offsetof(struct user_regs_struct, s9) },
+		{ "s10", offsetof(struct user_regs_struct, s10) },
+		{ "s11", offsetof(struct user_regs_struct, s11) },
+		{ "t3", offsetof(struct user_regs_struct, t3) },
+		{ "t4", offsetof(struct user_regs_struct, t4) },
+		{ "t5", offsetof(struct user_regs_struct, t5) },
+		{ "t6", offsetof(struct user_regs_struct, t6) },
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(reg_map); i++) {
+		if (strcmp(reg_name, reg_map[i].name) == 0)
+			return reg_map[i].pt_regs_off;
+	}
+
+	pr_warn("usdt: unrecognized register '%s'\n", reg_name);
+	return -ENOENT;
+}
+
+static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg)
+{
+	char *reg_name = NULL;
+	int arg_sz, len, reg_off;
+	long off;
+
+	if (sscanf(arg_str, " %d @ %ld ( %m[a-z0-9] ) %n", &arg_sz, &off, &reg_name, &len) == 3) {
+		/* Memory dereference case, e.g., -8@-88(s0) */
+		arg->arg_type = USDT_ARG_REG_DEREF;
+		arg->val_off = off;
+		reg_off = calc_pt_regs_off(reg_name);
+		free(reg_name);
+		if (reg_off < 0)
+			return reg_off;
+		arg->reg_off = reg_off;
+	} else if (sscanf(arg_str, " %d @ %ld %n", &arg_sz, &off, &len) == 2) {
+		/* Constant value case, e.g., 4@5 */
+		arg->arg_type = USDT_ARG_CONST;
+		arg->val_off = off;
+		arg->reg_off = 0;
+	} else if (sscanf(arg_str, " %d @ %m[a-z0-9] %n", &arg_sz, &reg_name, &len) == 2) {
+		/* Register read case, e.g., -8@a1 */
+		arg->arg_type = USDT_ARG_REG;
+		arg->val_off = 0;
+		reg_off = calc_pt_regs_off(reg_name);
+		free(reg_name);
+		if (reg_off < 0)
+			return reg_off;
+		arg->reg_off = reg_off;
+	} else {
+		pr_warn("usdt: unrecognized arg #%d spec '%s'\n", arg_num, arg_str);
+		return -EINVAL;
+	}
+
+	arg->arg_signed = arg_sz < 0;
+	if (arg_sz < 0)
+		arg_sz = -arg_sz;
+
+	switch (arg_sz) {
+	case 1: case 2: case 4: case 8:
+		arg->arg_bitshift = 64 - arg_sz * 8;
+		break;
+	default:
+		pr_warn("usdt: unsupported arg #%d (spec '%s') size: %d\n",
+			arg_num, arg_str, arg_sz);
+		return -EINVAL;
+	}
+
+	return len;
+}
+
 #else
 
 static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg)
-- 
2.25.1

