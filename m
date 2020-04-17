Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B061ADB5A
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 12:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgDQKn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 06:43:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48022 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729532AbgDQKnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 06:43:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HAfclk016937;
        Fri, 17 Apr 2020 10:43:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=jH6I9i9Tpg+1U/+NJywgMRHwOyC53JQMIrvBRQ6Pjis=;
 b=q0m9H8JFb2xuuN5qDIpkCyWAg3k6enWafGb+1lfb7W1KKsP7eTEcOljacw3hGyUFngrS
 Lx1qNCv4kl4D5LKMcN6XjTkD0OVBOZ8CimUAIjSSqiAEilBmfzo67/XEt20bT31TrlHS
 llpMFokP1LfY6XbD7wCRqVvgklgKL34TBnfGC9JqMzFysDQsNs8Bz0MwuxHoFcmEVmwF
 Rn1q1s9Wbxo56+Uc3B/WUOEdPbn5j5c4SikYpa+GII4tjjFKjvZNRNUvAwceFxZPy0fh
 uPDlVLB2BCeRtI5JL94KV7ZF84c3pybmcRJt+4MyKW5vMuGCzjt6MY1C32aL5J9JKMrq SA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30emejp7e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 10:43:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HAbHij051160;
        Fri, 17 Apr 2020 10:43:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30emeqk3dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 10:43:07 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03HAh6kQ020465;
        Fri, 17 Apr 2020 10:43:06 GMT
Received: from localhost.uk.oracle.com (/10.175.205.33)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 03:43:06 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com
Cc:     kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC PATCH bpf-next 5/6] printk: add type-printing %pT<type> format specifier which uses BTF
Date:   Fri, 17 Apr 2020 11:42:39 +0100
Message-Id: <1587120160-3030-6-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170084
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170084
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

printk supports multiple pointer object type specifiers (printing
netdev features etc).  Extend this support using BTF to cover
arbitrary types.  "%pT" specifies the typed format, and a suffix
enclosed <like this> specifies the type, for example, specifying

	printk("%pT<struct sk_buff>", skb)

...will utilize BTF information to traverse the struct sk_buff *
and display it.  Support is present for structs, unions, enums,
typedefs and core types (though in the latter case there's not
much value in using this feature of course).

Default output is compact, specifying values only, but the
'N' modifier can be used to show field names to more easily
track values.  Pointer values are obfuscated as usual.  As
an example:

  struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
  pr_info("%pTN<struct sk_buff>", skb);

...gives us:

{{{.next=00000000c7916e9c,.prev=00000000c7916e9c,{.dev=00000000c7916e9c|.dev_scratch=0}}|.rbnode={.__rb_parent_color=0,.rb_right=00000000c7916e9c,.rb_left=00000000c7916e9c}|.list={.next=00000000c7916e9c,.prev=00000000c7916e9c}},{.sk=00000000c7916e9c|.ip_defrag_offset=0},{.tstamp=0|.skb_mstamp_ns=0},.cb=['\0'],{{._skb_refdst=0,.destructor=00000000c7916e9c}|.tcp_tsorted_anchor={.next=00000000c7916e9c,.prev=00000000c7916e9c}},._nfct=0,.len=0,.data_len=0,.mac_len=0,.hdr_len=0,.queue_mapping=0,.__cloned_offset=[],.cloned=0x0,.nohdr=0x0,.fclone=0x0,.peeked=0x0,.head_frag=0x0,.pfmemalloc=0x0,.active_extensions=0,.headers_start=[],.__pkt_type_offset=[],.pkt_type=0x0,.ignore_df=0x0,.nf_trace=0x0,.ip_summed=0x0,.ooo_okay=0x0,.l4_hash=0x0,.sw_hash=0x0,.wifi_acked_valid=0x0,.wifi_acked=0x0,.no_fcs=0x0,.encapsulation=0x0,.encap_hdr_csum=0x0,.csum_valid=0x0,.__pkt_vlan_present_offset=[],.vlan_present=0x0,.csum_complete_sw=0x0,.csum_level=0x0,.csum_not_inet=0x0,.dst_pending_co

printk output is truncated at 1024 bytes.  For such cases, the compact
display mode (minus the field info) may be used. "|" differentiates
between different union members.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 Documentation/core-api/printk-formats.rst |   8 ++
 include/linux/btf.h                       |   3 +-
 lib/Kconfig                               |  16 ++++
 lib/vsprintf.c                            | 145 +++++++++++++++++++++++++++++-
 4 files changed, 169 insertions(+), 3 deletions(-)

diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
index 8ebe46b1..b786577 100644
--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -545,6 +545,14 @@ For printing netdev_features_t.
 
 Passed by reference.
 
+BTF-based printing of pointer data
+----------------------------------
+If '%pT[N]<type_name>' is specified, use the BPF Type Format (BTF) to
+show the typed data.  For example, specifying '%pT<struct sk_buff>' will utilize
+BTF information to traverse the struct sk_buff * and display it.
+
+Supported modifer is 'N' (show type field names).
+
 Thanks
 ======
 
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 2f78dc8..456bd8f 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -158,10 +158,11 @@ static inline const struct btf_member *btf_type_member(const struct btf_type *t)
 	return (const struct btf_member *)(t + 1);
 }
 
+struct btf *btf_parse_vmlinux(void);
+
 #ifdef CONFIG_BPF_SYSCALL
 const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
 const char *btf_name_by_offset(const struct btf *btf, u32 offset);
-struct btf *btf_parse_vmlinux(void);
 struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
 #else
 static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
diff --git a/lib/Kconfig b/lib/Kconfig
index bc7e563..e92109e 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -6,6 +6,22 @@
 config BINARY_PRINTF
 	def_bool n
 
+config BTF_PRINTF
+	bool "print type information using BPF type format"
+	depends on DEBUG_INFO_BTF
+	default n
+	help
+	  Print structures, unions etc pointed to by pointer argument using
+	  printk() family of functions (vsnprintf, printk, trace_printk, etc).
+	  For example, we can specify
+	  printk(KERN_INFO, "%pT<struct sk_buff>", skb); to print the skb
+	  data structure content, including all nested type data.
+	  Pointers within data structures displayed are not followed, and
+	  are obfuscated where specified in line with normal pointer display.
+	  via printk.
+
+	  Depends on availability of vmlinux BTF information.
+
 menu "Library routines"
 
 config RAID6_PQ
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7c488a1..43e06f3 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -43,6 +43,7 @@
 #ifdef CONFIG_BLOCK
 #include <linux/blkdev.h>
 #endif
+#include <linux/btf.h>
 
 #include "../mm/internal.h"	/* For the trace_print_flags arrays */
 
@@ -2059,6 +2060,127 @@ char *fwnode_string(char *buf, char *end, struct fwnode_handle *fwnode,
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
+#define is_btf_fmt_start(c)	(c == 'T')
+#define is_btf_type_start(c)	(c == '<')
+#define is_btf_type_end(c)	(c == '>')
+
+#define btf_modifier_flag(c)	(c == 'N' ? BTF_SHOW_NAME : 0)
+
+static noinline_for_stack
+const char *skip_btf_type(const char *fmt, bool *found_btf_type)
+{
+	*found_btf_type = false;
+
+	if (!is_btf_fmt_start(*fmt))
+		return fmt;
+	fmt++;
+
+	while (btf_modifier_flag(*fmt))
+		fmt++;
+
+	if (!is_btf_type_start(*fmt))
+		return fmt;
+
+	while (!is_btf_type_end(*fmt) && *fmt != '\0')
+		fmt++;
+
+	if (is_btf_type_end(*fmt)) {
+		fmt++;
+		*found_btf_type = true;
+	}
+
+	return fmt;
+}
+
+static noinline_for_stack
+char *btf_string(char *buf, char *end, void *ptr, struct printf_spec spec,
+		 const char *fmt)
+{
+	const struct btf_type *btf_type;
+	char btf_name[KSYM_SYMBOL_LEN];
+	u8 btf_kind = BTF_KIND_TYPEDEF;
+	const struct btf *btf;
+	char *buf_start = buf;
+	u64 flags = 0, mod;
+	s32 btf_id;
+	int i;
+
+	/*
+	 * Accepted format is [format_modifiers]*<type> ;
+	 * for example "%pTN<struct sk_buff>" will show a representation
+	 * of the sk_buff pointed to by the associated argument including
+	 * member names.
+	 */
+	if (check_pointer(&buf, end, ptr, spec))
+		return buf;
+
+	while (isalpha(*fmt)) {
+		mod = btf_modifier_flag(*fmt);
+		if (!mod)
+			break;
+		flags |= mod;
+		fmt++;
+	}
+
+	if (!is_btf_type_start(*fmt))
+		return error_string(buf, end, "(%pT?)", spec);
+	fmt++;
+
+	if (isspace(*fmt))
+		fmt = skip_spaces(++fmt);
+
+	if (strncmp(fmt, "struct ", strlen("struct ")) == 0) {
+		btf_kind = BTF_KIND_STRUCT;
+		fmt += strlen("struct ");
+	} else if (strncmp(fmt, "union ", strlen("union ")) == 0) {
+		btf_kind = BTF_KIND_UNION;
+		fmt += strlen("union ");
+	} else if (strncmp(fmt, "enum ", strlen("enum ")) == 0) {
+		btf_kind = BTF_KIND_ENUM;
+		fmt += strlen("enum ");
+	}
+
+	if (isspace(*fmt))
+		fmt = skip_spaces(++fmt);
+
+	for (i = 0; isalnum(*fmt) || *fmt == '_'; fmt++, i++)
+		btf_name[i] = *fmt;
+
+	btf_name[i] = '\0';
+
+	if (isspace(*fmt))
+		fmt = skip_spaces(++fmt);
+
+	if (strlen(btf_name) == 0 || !is_btf_type_end(*fmt))
+		return error_string(buf, end, "(%pT?)", spec);
+
+	btf = bpf_get_btf_vmlinux();
+	if (IS_ERR_OR_NULL(btf))
+		return ptr_to_id(buf, end, ptr, spec);
+
+	/*
+	 * Assume type specified is a typedef as there's not much
+	 * benefit in specifying %p<int> other than wasting time
+	 * on BTF lookups; we optimize for the most useful path.
+	 *
+	 * Fall back to BTF_KIND_INT if this fails.
+	 */
+	btf_id = btf_find_by_name_kind(btf, btf_name, btf_kind);
+	if (btf_id < 0)
+		btf_id = btf_find_by_name_kind(btf, btf_name,
+					       BTF_KIND_INT);
+
+	if (btf_id >= 0)
+		btf_type = btf_type_by_id(btf, btf_id);
+	if (btf_id < 0 || !btf_type)
+		return ptr_to_id(buf, end, ptr, spec);
+
+	buf += btf_type_snprintf_show(btf, btf_id, ptr, buf,
+				      end - buf_start, flags);
+
+	return widen_string(buf, buf - buf_start, end, spec);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -2169,6 +2291,15 @@ char *fwnode_string(char *buf, char *end, struct fwnode_handle *fwnode,
  *		P node name, including a possible unit address
  * - 'x' For printing the address. Equivalent to "%lx".
  *
+ * - 'T[N<type_name>]' For printing pointer data using BPF Type Format (BTF).
+ *
+ *			Optional arguments are
+ *			N		print type and member names
+ *
+ *			Required options are
+ *			<type_name>	associated pointer is interpreted
+ *					to point at type_name.
+ *
  * ** When making changes please also update:
  *	Documentation/core-api/printk-formats.rst
  *
@@ -2251,6 +2382,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		if (!IS_ERR(ptr))
 			break;
 		return err_ptr(buf, end, ptr, spec);
+	case 'T':
+		return btf_string(buf, end, ptr, spec, fmt + 1);
 	}
 
 	/* default is to _not_ leak addresses, hash before printing */
@@ -2506,6 +2639,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 	unsigned long long num;
 	char *str, *end;
 	struct printf_spec spec = {0};
+	bool found_btf_type;
 
 	/* Reject out-of-range values early.  Large positive sizes are
 	   used for unknown buffer sizes. */
@@ -2577,8 +2711,15 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 		case FORMAT_TYPE_PTR:
 			str = pointer(fmt, str, end, va_arg(args, void *),
 				      spec);
-			while (isalnum(*fmt))
-				fmt++;
+			/*
+			 * BTF type info is enclosed <like this>, so can
+			 * contain whitespace.
+			 */
+			fmt = skip_btf_type(fmt, &found_btf_type);
+			if (!found_btf_type) {
+				while (isalnum(*fmt))
+					fmt++;
+			}
 			break;
 
 		case FORMAT_TYPE_PERCENT_CHAR:
-- 
1.8.3.1

