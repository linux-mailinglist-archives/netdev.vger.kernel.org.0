Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888B0522DE9
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243387AbiEKILE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242778AbiEKIKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:10:51 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA98D60C7
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:10:44 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220511081041epoutp03a0b25adc9907aa3e7704a282a30d71d9~t-qk4oA3N1086110861epoutp03s
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:10:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220511081041epoutp03a0b25adc9907aa3e7704a282a30d71d9~t-qk4oA3N1086110861epoutp03s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652256641;
        bh=RtE6fAg/d3q7O20KfBiDHbSyLyBDyv22fz1QuCeu16w=;
        h=From:To:Cc:Subject:Date:References:From;
        b=VAQPs+Z7TEwMAjEAVVqdrw11Nqcc+9DNWYfqTcMjRACdCdGxg2SJuRRNlhQNwFxw6
         N2iJw5y059QDTujX2/2IAux6ffH6Ycn8cCBbipvFbshNzbNbV1pWydsz3EjLzq1ff2
         qe6MrhjSBIJXI9v2Qs7EwPu3lPNxBpRaXPdVU8p4=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220511081040epcas5p13204c059981002a9855605acdd58e35f~t-qj7tv_K1953519535epcas5p1I;
        Wed, 11 May 2022 08:10:40 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BD.37.09827.F7F6B726; Wed, 11 May 2022 17:10:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220511080722epcas5p459493d02ff662a7c75590e44a11e34a6~t-nr67wCq1800118001epcas5p4T;
        Wed, 11 May 2022 08:07:22 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220511080722epsmtrp15bedbb71df95e1d4c176f11e800264c4~t-nr5mNld1662516625epsmtrp1V;
        Wed, 11 May 2022 08:07:22 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-a2-627b6f7fa38e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C7.23.08924.ABE6B726; Wed, 11 May 2022 17:07:22 +0900 (KST)
Received: from localhost.localdomain (unknown [107.109.224.44]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220511080717epsmtip12a9645428e734708fd7299aba545db11~t-nnn7o2B1154711547epsmtip1h;
        Wed, 11 May 2022 08:07:17 +0000 (GMT)
From:   Maninder Singh <maninder1.s@samsung.com>
To:     mcgrof@kernel.org, avimalin@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        senozhatsky@chromium.org, andriy.shevchenko@linux.intel.com,
        naveen.n.rao@linux.ibm.com, davem@davemloft.net,
        mhiramat@kernel.org, anil.s.keshavamurthy@intel.com,
        linux@rasmusvillemoes.dk, akpm@linux-foundation.org,
        keescook@chromium.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        v.narang@samsung.com, Maninder Singh <maninder1.s@samsung.com>,
        Onkarnath <onkarnath.1@samsung.com>
Subject: [PATCH 1/2] kallsyms: add kallsyms_show_value definition in all
 cases
Date:   Wed, 11 May 2022 13:36:56 +0530
Message-Id: <20220511080657.3996053-1-maninder1.s@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmum59fnWSwZvz1hZz1q9hs/j+ezaz
        RW/TdCaL3S9us1h8+Xmb3eLBwevsFosXfmO2mHO+hcWiaccKJosXH54wWpzpzrV4vq+XyeLy
        rjlsFo9nzWOzODy/jcXixoSnjBaLl6tZrJ7yl93i2AIxixU9H1gt/j/+ymqxr+MB0OyNi9gs
        fh4+w2xx6ORcRosXS2YwOkh5zG64yOKxZeVNJo+Jze/YPXbOusvu0bLvFrvH4j0vmTy6blxi
        9ti0qpPN48SM3yweExYdYPSYdzLQ40JXtkffllWMHuu3XGXx+LxJLoA/issmJTUnsyy1SN8u
        gStjwZTfrAWfDSvOvupiamB8oNHFyMkhIWAi8e76bqYuRi4OIYHdjBLT531hgXA+MUocaGhi
        hHA+M0pcO/eWEaal9f4/dojELkaJxScWsUE4X4Cqfs4Cq2IT0JNYtWsP2CwRgafMEp3PpoJt
        YRZYyCjx4uNtNpAqYYEAiUcNk9hBbBYBVYnnzycwgdi8AnYSbU9XsUDsk5eYeek7O0RcUOLk
        zCdgcWagePPW2cwgQyUEZnNKTG5pZ4NocJH4NqGPCcIWlnh1fAs7hC0l8bK/DcjmALLLJbZO
        qIfobWGU2D9nClSvvcSTiwtZQWqYBTQl1u/ShwjLSkw9tY4JYi+fRO/vJ1DjeSV2zIOxVSVa
        bm5ghbClJT5//Ah1v4fEz8c/mEFsIYFYiVm/brBMYJSfheSdWUjemYWweQEj8ypGydSC4tz0
        1GLTAqO81HK94sTc4tK8dL3k/NxNjOC0q+W1g/Hhgw96hxiZOBgPMUpwMCuJ8O7vq0gS4k1J
        rKxKLcqPLyrNSS0+xCjNwaIkzns6fUOikEB6YklqdmpqQWoRTJaJg1Oqgcl43oF6MRPusGdT
        DFZtP7mKtbpoQ0+PiQCzlaNVYPeFIy4lqh2LM00MeRx/ThKUrNG/P7lTk1v5b8QB++4rH6+5
        sYZLLBGbPWuB4WuZHIP+g5vvhhSaBPl36jA/ddJf+y1oCoPcl2r+nWKiiSrdzQvXiO59xH0/
        LNWxZftkVU2fC2aTDl6+p92+JGzDtahnTQre//dY7dU8udfTMM5g62Tru44nCxRvvwoSjjhe
        X6HfkDhdSzCGP1cx7vTZHyy7labedWI8uq9qYY39u/OzN7obXmm4eymh+Y5I0s7VwZnrGP6t
        YHG/0nDQ9ti+FzbfdO/qTy5aMVelnuXsfQ3HLulnmy8W+L4Sqn62wdLYX4mlOCPRUIu5qDgR
        AFrMo3IqBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsWy7bCSnO6uvOokgwtfRSzmrF/DZvH992xm
        i96m6UwWu1/cZrH48vM2u8WDg9fZLRYv/MZsMed8C4tF044VTBYvPjxhtDjTnWvxfF8vk8Xl
        XXPYLB7PmsdmcXh+G4vFjQlPGS0WL1ezWD3lL7vFsQViFit6PrBa/H/8ldViX8cDoNkbF7FZ
        /Dx8htni0Mm5jBYvlsxgdJDymN1wkcVjy8qbTB4Tm9+xe+ycdZfdo2XfLXaPxXteMnl03bjE
        7LFpVSebx4kZv1k8Jiw6wOgx72Sgx4WubI++LasYPdZvucri8XmTXAB/FJdNSmpOZllqkb5d
        AlfGgim/WQs+G1acfdXF1MD4QKOLkZNDQsBEovX+P/YuRi4OIYEdjBJXL05jgkhIS/z8954F
        whaWWPnvOVTRJ0aJX9samEESbAJ6Eqt27WEBSYgI/GeW+DSllwnEYRZYyihx88pMNpAqYQE/
        iRcNbawgNouAqsTz5xPAVvAK2Em0PV0FtUJeYual7+wQcUGJkzOfgMWZgeLNW2czT2Dkm4Uk
        NQtJagEj0ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOAY1tLawbhn1Qe9Q4xMHIyH
        GCU4mJVEePf3VSQJ8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvE
        wSnVwGTvKuR32nT7t8VisysN3XeKJQtffaFrtnFVT40udzL7gU2d76eFrkrd4mcxd63aKZPQ
        9vWt8fx5RUvKa490vfljGsbP/X+PoLtNbso7/3cLt/Fb+8QpR1s1qy+0TvU6Z6K63ux/Bmu1
        14Q1zL98p28Of9S9lHvlgkO1wqqcExz+ahzItwq/5+kuwSfpkPSo7GvmqtOXRZZ4ZltW7XvP
        4dGz4VzlioiSXasXB51fPEfef//UlyHXZkj0fFtRbPzvr1JH6Iubc+69FZzJVvcq5OOqGSy9
        +VnBZo2eh+45Lj0YmSMQwi7GmySZHDjtTbu08JX0ZXdvlprt2vU5MXHHrow/8lKXGb5GPtVo
        Ldq6X4mlOCPRUIu5qDgRAKwIwRNQAwAA
X-CMS-MailID: 20220511080722epcas5p459493d02ff662a7c75590e44a11e34a6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20220511080722epcas5p459493d02ff662a7c75590e44a11e34a6
References: <CGME20220511080722epcas5p459493d02ff662a7c75590e44a11e34a6@epcas5p4.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kallsyms_show_value return false if KALLSYMS is disabled,
but its usage is done by module.c also.
Thus when KALLSYMS is disabled, system will not print module
load address:

/ # insmod crash.ko
/ # lsmod
crash 12288 0 - Live 0x0000000000000000 (O)

After change (making definition generic)
============
/ # lsmod
crash 12288 0 - Live 0xffff800000ec0000 (O)
/ # cat /proc/modules
crash 12288 0 - Live 0xffff800000ec0000 (O)
/ #

BPF code has high dependency on kallsyms,
so bpf_dump_raw_ok check is not changed.

Co-developed-by: Onkarnath <onkarnath.1@samsung.com>
Signed-off-by: Onkarnath <onkarnath.1@samsung.com>
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
---
BPF logic is not changed and seems kprobe will work, rest kprobe
maintainer can comment if it can cause issue. Tested for modules data.
https://lkml.org/lkml/2022/4/13/326

 include/linux/filter.h   |  7 ++++++
 include/linux/kallsyms.h | 10 +++-----
 kernel/Makefile          |  2 +-
 kernel/kallsyms.c        | 35 ---------------------------
 kernel/kallsyms_tiny.c   | 51 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 62 insertions(+), 43 deletions(-)
 create mode 100644 kernel/kallsyms_tiny.c

diff --git a/include/linux/filter.h b/include/linux/filter.h
index ed0c0ff42ad5..98c4365e726d 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -951,6 +951,7 @@ bool bpf_jit_needs_zext(void);
 bool bpf_jit_supports_kfunc_call(void);
 bool bpf_helper_changes_pkt_data(void *func);
 
+#ifdef CONFIG_KALLSYMS
 static inline bool bpf_dump_raw_ok(const struct cred *cred)
 {
 	/* Reconstruction of call-sites is dependent on kallsyms,
@@ -958,6 +959,12 @@ static inline bool bpf_dump_raw_ok(const struct cred *cred)
 	 */
 	return kallsyms_show_value(cred);
 }
+#else
+static inline bool bpf_dump_raw_ok(const struct cred *cred)
+{
+	return false;
+}
+#endif
 
 struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
 				       const struct bpf_insn *patch, u32 len);
diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index c24fa627ab6e..c5e63a217404 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -24,6 +24,9 @@
 struct cred;
 struct module;
 
+/* How and when do we show kallsyms values? */
+extern bool kallsyms_show_value(const struct cred *cred);
+
 static inline int is_kernel_text(unsigned long addr)
 {
 	if (__is_kernel_text(addr))
@@ -95,8 +98,6 @@ extern int sprint_kallsym_common(char *buffer, unsigned long address, int build_
 int lookup_symbol_name(unsigned long addr, char *symname);
 int lookup_symbol_attrs(unsigned long addr, unsigned long *size, unsigned long *offset, char *modname, char *name);
 
-/* How and when do we show kallsyms values? */
-extern bool kallsyms_show_value(const struct cred *cred);
 
 #else /* !CONFIG_KALLSYMS */
 
@@ -160,11 +161,6 @@ static inline int lookup_symbol_attrs(unsigned long addr, unsigned long *size, u
 	return -ERANGE;
 }
 
-static inline bool kallsyms_show_value(const struct cred *cred)
-{
-	return false;
-}
-
 #endif /*CONFIG_KALLSYMS*/
 
 static inline void print_ip_sym(const char *loglvl, unsigned long ip)
diff --git a/kernel/Makefile b/kernel/Makefile
index 318789c728d3..844ed3df95f6 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    extable.o params.o \
 	    kthread.o sys_ni.o nsproxy.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
-	    async.o range.o smpboot.o ucount.o regset.o
+	    async.o range.o smpboot.o ucount.o regset.o kallsyms_tiny.o
 
 obj-$(CONFIG_USERMODE_DRIVER) += usermode_driver.o
 obj-$(CONFIG_MODULES) += kmod.o
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 9a0d6cfca619..d818048cb9f7 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -819,41 +819,6 @@ static const struct seq_operations kallsyms_op = {
 	.show = s_show
 };
 
-static inline int kallsyms_for_perf(void)
-{
-#ifdef CONFIG_PERF_EVENTS
-	extern int sysctl_perf_event_paranoid;
-	if (sysctl_perf_event_paranoid <= 1)
-		return 1;
-#endif
-	return 0;
-}
-
-/*
- * We show kallsyms information even to normal users if we've enabled
- * kernel profiling and are explicitly not paranoid (so kptr_restrict
- * is clear, and sysctl_perf_event_paranoid isn't set).
- *
- * Otherwise, require CAP_SYSLOG (assuming kptr_restrict isn't set to
- * block even that).
- */
-bool kallsyms_show_value(const struct cred *cred)
-{
-	switch (kptr_restrict) {
-	case 0:
-		if (kallsyms_for_perf())
-			return true;
-		fallthrough;
-	case 1:
-		if (security_capable(cred, &init_user_ns, CAP_SYSLOG,
-				     CAP_OPT_NOAUDIT) == 0)
-			return true;
-		fallthrough;
-	default:
-		return false;
-	}
-}
-
 static int kallsyms_open(struct inode *inode, struct file *file)
 {
 	/*
diff --git a/kernel/kallsyms_tiny.c b/kernel/kallsyms_tiny.c
new file mode 100644
index 000000000000..96ad06836126
--- /dev/null
+++ b/kernel/kallsyms_tiny.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Samsung Electronics Co., Ltd
+ *
+ * Author:
+ *	Maninder singh <maninder1.s@samsung.com>
+ *	Onkarnath <onkarnath.1@samsung.com>
+ *
+ * A split of kernel/kallsyms.c
+ * Contains few generic definitions independent of CONFIG_KALLSYMS
+ * or defined under !CONFIG_KALLSYMS.
+ */
+
+#include <linux/kallsyms.h>
+#include <linux/security.h>
+
+static inline int kallsyms_for_perf(void)
+{
+#ifdef CONFIG_PERF_EVENTS
+	extern int sysctl_perf_event_paranoid;
+
+	if (sysctl_perf_event_paranoid <= 1)
+		return 1;
+#endif
+	return 0;
+}
+
+/*
+ * We show kallsyms information even to normal users if we've enabled
+ * kernel profiling and are explicitly not paranoid (so kptr_restrict
+ * is clear, and sysctl_perf_event_paranoid isn't set).
+ *
+ * Otherwise, require CAP_SYSLOG (assuming kptr_restrict isn't set to
+ * block even that).
+ */
+bool kallsyms_show_value(const struct cred *cred)
+{
+	switch (kptr_restrict) {
+	case 0:
+		if (kallsyms_for_perf())
+			return true;
+		fallthrough;
+	case 1:
+		if (security_capable(cred, &init_user_ns, CAP_SYSLOG,
+				     CAP_OPT_NOAUDIT) == 0)
+			return true;
+		fallthrough;
+	default:
+		return false;
+	}
+}
-- 
2.17.1

