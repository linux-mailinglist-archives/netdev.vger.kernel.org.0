Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAFF2051EF
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 14:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732690AbgFWMK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 08:10:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51434 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732673AbgFWMKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 08:10:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC7xCh052195;
        Tue, 23 Jun 2020 12:09:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=E8fHB7DcBFvLhd8t1qiFwiqXsKebHCqIA8SKLWeX8Ag=;
 b=a+pyfdhEhLKRep9FR7qYoiPUEWy0kACfD8ai7BBZmObjop4905J8HClw/pRdHewtPbWX
 4SQ0oit24pjlCFLzDp0D98+1l123gFbnLnlRglLjiPRDyVHAj5TENfs4jrtGQE92o61g
 17vsBoitadRNLEHx/hwMQ1AHQjJ2WICZHIAFNRFgqMhnjdNyNI/36XeLW4WNQ9szd588
 9sas0/GTfq0Y6UwSObU4HT/SgZDrwUqlS0W5SgL7Nj2oduxCDptYT3OndNOlbO8qdaY3
 DF27tEuV6haRr0Qx+rZzfmVSM67ssLzFM9Jrhq9nV5R2DD+YOud/25DIpLlEBgXaaSYK Ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31sebbcvbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 12:09:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC7kwY185627;
        Tue, 23 Jun 2020 12:09:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31sv1n7h3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 12:09:34 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05NC9W1v025702;
        Tue, 23 Jun 2020 12:09:32 GMT
Received: from localhost.uk.oracle.com (/10.175.166.3)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 12:09:32 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, andriin@fb.com,
        arnaldo.melo@gmail.com
Cc:     kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux@rasmusvillemoes.dk, joe@perches.com,
        pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
        corbet@lwn.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v3 bpf-next 7/8] bpf: add support for %pT format specifier for bpf_trace_printk() helper
Date:   Tue, 23 Jun 2020 13:07:10 +0100
Message-Id: <1592914031-31049-8-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
References: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230097
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow %pT[cNx0] format specifier for BTF-based display of data associated
with pointer.  The unsafe data modifier 'u' - where the source data
is traversed without copying it to a safe buffer via probe_kernel_read() -
is not supported.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/uapi/linux/bpf.h       | 27 ++++++++++++++++++++++-----
 kernel/trace/bpf_trace.c       | 24 +++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h | 27 ++++++++++++++++++++++-----
 3 files changed, 67 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1968481..ea4fbf3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -702,7 +702,12 @@ struct bpf_stack_build_id {
  * 		to file *\/sys/kernel/debug/tracing/trace* from DebugFS, if
  * 		available. It can take up to three additional **u64**
  * 		arguments (as an eBPF helpers, the total number of arguments is
- * 		limited to five).
+ *		limited to five), and also supports %pT (BTF-based type
+ *		printing), as long as BPF_READ lockdown is not active.
+ *		"%pT" takes a "struct __btf_ptr *" as an argument; it
+ *		consists of a pointer value and specified BTF type string or id
+ *		used to select the type for display.  For more details, see
+ *		Documentation/core-api/printk-formats.rst.
  *
  * 		Each time the helper is called, it appends a line to the trace.
  * 		Lines are discarded while *\/sys/kernel/debug/tracing/trace* is
@@ -738,10 +743,10 @@ struct bpf_stack_build_id {
  * 		The conversion specifiers supported by *fmt* are similar, but
  * 		more limited than for printk(). They are **%d**, **%i**,
  * 		**%u**, **%x**, **%ld**, **%li**, **%lu**, **%lx**, **%lld**,
- * 		**%lli**, **%llu**, **%llx**, **%p**, **%s**. No modifier (size
- * 		of field, padding with zeroes, etc.) is available, and the
- * 		helper will return **-EINVAL** (but print nothing) if it
- * 		encounters an unknown specifier.
+ *		**%lli**, **%llu**, **%llx**, **%p**, **%pT[cNx0], **%s**.
+ *		Only %pT supports modifiers, and the helper will return
+ *		**-EINVAL** (but print nothing) if it encouters an unknown
+ *		specifier.
  *
  * 		Also, note that **bpf_trace_printk**\ () is slow, and should
  * 		only be used for debugging purposes. For this reason, a notice
@@ -4260,4 +4265,16 @@ struct bpf_pidns_info {
 	__u32 pid;
 	__u32 tgid;
 };
+
+/*
+ * struct __btf_ptr is used for %pT (typed pointer) display; the
+ * additional type string/BTF id are used to render the pointer
+ * data as the appropriate type.
+ */
+struct __btf_ptr {
+	void *ptr;
+	const char *type;
+	__u32 id;
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e729c9e5..33ddb31 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -374,9 +374,13 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
 	}
 }
 
+/* Unsafe BTF display ('u' modifier) is absent here. */
+#define is_btf_safe_modifier(c)		\
+	(c == 'c' || c == 'N' || c == 'x' || c == '0')
+
 /*
  * Only limited trace_printk() conversion specifiers allowed:
- * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pks %pus %s
+ * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pks %pus %s %pT
  */
 BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
 	   u64, arg2, u64, arg3)
@@ -412,6 +416,24 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
 			i++;
 		} else if (fmt[i] == 'p') {
 			mod[fmt_cnt]++;
+
+			/*
+			 * allow BTF type-based printing, but disallow unsafe
+			 * mode - this ensures the data is copied safely
+			 * using probe_kernel_read() prior to traversing it.
+			 */
+			if (fmt[i + 1] == 'T') {
+				int ret;
+
+				ret = security_locked_down(LOCKDOWN_BPF_READ);
+				if (unlikely(ret < 0))
+					return ret;
+				i += 2;
+				while (is_btf_safe_modifier(fmt[i]))
+					i++;
+				goto fmt_next;
+			}
+
 			if ((fmt[i + 1] == 'k' ||
 			     fmt[i + 1] == 'u') &&
 			    fmt[i + 2] == 's') {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1968481..ea4fbf3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -702,7 +702,12 @@ struct bpf_stack_build_id {
  * 		to file *\/sys/kernel/debug/tracing/trace* from DebugFS, if
  * 		available. It can take up to three additional **u64**
  * 		arguments (as an eBPF helpers, the total number of arguments is
- * 		limited to five).
+ *		limited to five), and also supports %pT (BTF-based type
+ *		printing), as long as BPF_READ lockdown is not active.
+ *		"%pT" takes a "struct __btf_ptr *" as an argument; it
+ *		consists of a pointer value and specified BTF type string or id
+ *		used to select the type for display.  For more details, see
+ *		Documentation/core-api/printk-formats.rst.
  *
  * 		Each time the helper is called, it appends a line to the trace.
  * 		Lines are discarded while *\/sys/kernel/debug/tracing/trace* is
@@ -738,10 +743,10 @@ struct bpf_stack_build_id {
  * 		The conversion specifiers supported by *fmt* are similar, but
  * 		more limited than for printk(). They are **%d**, **%i**,
  * 		**%u**, **%x**, **%ld**, **%li**, **%lu**, **%lx**, **%lld**,
- * 		**%lli**, **%llu**, **%llx**, **%p**, **%s**. No modifier (size
- * 		of field, padding with zeroes, etc.) is available, and the
- * 		helper will return **-EINVAL** (but print nothing) if it
- * 		encounters an unknown specifier.
+ *		**%lli**, **%llu**, **%llx**, **%p**, **%pT[cNx0], **%s**.
+ *		Only %pT supports modifiers, and the helper will return
+ *		**-EINVAL** (but print nothing) if it encouters an unknown
+ *		specifier.
  *
  * 		Also, note that **bpf_trace_printk**\ () is slow, and should
  * 		only be used for debugging purposes. For this reason, a notice
@@ -4260,4 +4265,16 @@ struct bpf_pidns_info {
 	__u32 pid;
 	__u32 tgid;
 };
+
+/*
+ * struct __btf_ptr is used for %pT (typed pointer) display; the
+ * additional type string/BTF id are used to render the pointer
+ * data as the appropriate type.
+ */
+struct __btf_ptr {
+	void *ptr;
+	const char *type;
+	__u32 id;
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
1.8.3.1

