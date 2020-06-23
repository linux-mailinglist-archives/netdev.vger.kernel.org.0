Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D022051F7
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 14:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732706AbgFWMKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 08:10:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51402 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732665AbgFWMKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 08:10:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC7mGO052074;
        Tue, 23 Jun 2020 12:09:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=5KtWagpRkczJBtfBJ6H66/ElH0imVZdlP7CDOBseCAw=;
 b=mA8wxUvk6JnRSfAjXZoF2EHVamYkxnBQobd93HsoUHe3mfSTecDpOdyCKS8JXtRAiA7/
 WUh8Q+RShp//HmIybnHtXdgW0NrGdsFT8c0dH02oWqoQqDDF1dghjcKhIR1tqDm82aem
 tTBSiF75CqoHFLUqnimpvLNGkaUMS5vSTfxNJUtEa0fjm/kWZjRbLGHbyekCMr6TDkMB
 SXbiklzqEbfaGEtcb5kN9cPJnNT86VIp9BrP6hTdtp9OwaAIglVdlJa+m1i374TSywKK
 yhkuDSavLsgYAgTsu54boE8zD5q+O5Wc0aPIQbuJMhEVKjuaLX3IJ6O3Ma0B2YDQnY0O lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31sebbcvbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 12:09:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC7gE6185211;
        Tue, 23 Jun 2020 12:09:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31sv1n7h1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 12:09:28 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05NC9SZl022676;
        Tue, 23 Jun 2020 12:09:28 GMT
Received: from localhost.uk.oracle.com (/10.175.166.3)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 12:09:27 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, andriin@fb.com,
        arnaldo.melo@gmail.com
Cc:     kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux@rasmusvillemoes.dk, joe@perches.com,
        pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
        corbet@lwn.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v3 bpf-next 6/8] printk: extend test_printf to test %pT BTF-based format specifier
Date:   Tue, 23 Jun 2020 13:07:09 +0100
Message-Id: <1592914031-31049-7-git-send-email-alan.maguire@oracle.com>
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

Add tests to verify basic type display and to iterate through all
enums, structs, unions and typedefs ensuring expected behaviour
occurs.  Since test_printf can be built as a module we need to
export a BTF kind iterator function to allow us to iterate over
all names of a particular BTF kind.

These changes add up to approximately 20,000 new tests covering
all enum, struct, union and typedefs in vmlinux BTF.

Individual tests are also added for int, char, struct, enum
and typedefs which verify output is as expected.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/linux/btf.h |   3 +
 kernel/bpf/btf.c    |  33 ++++++
 lib/test_printf.c   | 316 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 352 insertions(+)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index e8dbf0c..e3102a7 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -191,4 +191,7 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
 }
 #endif
 
+/* Following function used for testing BTF-based printk-family support */
+const char *btf_vmlinux_next_type_name(u8 kind, s32 *id);
+
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index c82cb18..4e250cd 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5459,3 +5459,36 @@ u32 btf_id(const struct btf *btf)
 {
 	return btf->id;
 }
+
+/*
+ * btf_vmlinux_next_type_name():  used in test_printf.c to
+ * iterate over types for testing.
+ * Exported as test_printf can be built as a module.
+ *
+ * @kind: BTF_KIND_* value
+ * @id: pointer to last id; value/result argument. When next
+ *      type name is found, we set *id to associated id.
+ * Returns:
+ *	Next type name, sets *id to associated id.
+ */
+const char *btf_vmlinux_next_type_name(u8 kind, s32 *id)
+{
+	const struct btf *btf = bpf_get_btf_vmlinux();
+	const struct btf_type *t;
+	const char *name;
+
+	if (!btf || !id)
+		return NULL;
+
+	for ((*id)++; *id <= btf->nr_types; (*id)++) {
+		t = btf->types[*id];
+		if (BTF_INFO_KIND(t->info) != kind)
+			continue;
+		name = btf_name_by_offset(btf, t->name_off);
+		if (name && strlen(name) > 0)
+			return name;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(btf_vmlinux_next_type_name);
diff --git a/lib/test_printf.c b/lib/test_printf.c
index 7ac87f1..7ce7387 100644
--- a/lib/test_printf.c
+++ b/lib/test_printf.c
@@ -23,6 +23,9 @@
 #include <linux/mm.h>
 
 #include <linux/property.h>
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/skbuff.h>
 
 #include "../tools/testing/selftests/kselftest_module.h"
 
@@ -669,6 +672,318 @@ static void __init fwnode_pointer(void)
 #endif
 }
 
+#define	__TEST_BTF(fmt, type, ptr, expected)				       \
+	test(expected, "%pT"fmt, ptr)
+
+#define TEST_BTF_C(type, var, ...)					       \
+	do {								       \
+		type var = __VA_ARGS__;					       \
+		struct btf_ptr *ptr = BTF_PTR_TYPE(&var, type);		       \
+		pr_debug("type %s: %pTc", #type, ptr);			       \
+		__TEST_BTF("c", type, ptr, "(" #type ")" #__VA_ARGS__);	       \
+	} while (0)
+
+#define TEST_BTF(fmt, type, var, expected, ...)				       \
+	do {								       \
+		type var = __VA_ARGS__;					       \
+		struct btf_ptr *ptr = BTF_PTR_TYPE(&var, type);		       \
+		pr_debug("type %s: %pT"fmt, #type, ptr);		       \
+		__TEST_BTF(fmt, type, ptr, expected);			       \
+	} while (0)
+
+#define	BTF_MAX_DATA_SIZE	65536
+
+static void __init
+btf_print_kind(u8 kind, const char *kind_name, u64 fillval)
+{
+	const char *fmt1 = "%pT", *fmt2 = "%pTN", *fmt3 = "%pT0";
+	const char *name, *fmt = fmt1;
+	int i, res1, res2, res3, res4;
+	char type_name[256];
+	char *buf, *buf2;
+	u8 *dummy_data;
+	s32 id = 0;
+
+	dummy_data = kzalloc(BTF_MAX_DATA_SIZE, GFP_KERNEL);
+
+	/* fill our dummy data with supplied fillval. */
+	for (i = 0; i < BTF_MAX_DATA_SIZE; i++)
+		dummy_data[i] = fillval;
+
+	buf = kzalloc(BTF_MAX_DATA_SIZE, GFP_KERNEL);
+	buf2 = kzalloc(BTF_MAX_DATA_SIZE, GFP_KERNEL);
+
+	for (;;) {
+		name = btf_vmlinux_next_type_name(kind, &id);
+		if (!name)
+			break;
+
+		total_tests++;
+
+		snprintf(type_name, sizeof(type_name), "%s%s",
+			 kind_name, name);
+
+		res1 = snprintf(buf, BTF_MAX_DATA_SIZE, fmt1,
+				BTF_PTR_TYPE(dummy_data, type_name));
+		res2 = snprintf(buf, 0, fmt1,
+				BTF_PTR_TYPE(dummy_data, type_name));
+		res3 = snprintf(buf, BTF_MAX_DATA_SIZE, fmt2,
+				BTF_PTR_TYPE(dummy_data, type_name));
+		res4 = snprintf(buf, BTF_MAX_DATA_SIZE, fmt3,
+				BTF_PTR_TYPE(dummy_data, type_name));
+
+		(void) snprintf(buf, BTF_MAX_DATA_SIZE, "%pT",
+				BTF_PTR_TYPE(dummy_data, type_name));
+		(void) snprintf(buf2, BTF_MAX_DATA_SIZE, "%pT",
+				BTF_PTR_TYPE(dummy_data, type_name));
+
+		/*
+		 * Ensure return value is > 0 and identical irrespective
+		 * of whether we pass in a big enough buffer;
+		 * also ensure that printing names always results in as
+		 * long/longer buffer length.
+		 */
+		if (res1 <= 0 || res2 <= 0 || res3 <= 0 || res4 <= 0) {
+			if (res3 <= 0)
+				fmt = fmt2;
+			if (res4 <= 0)
+				fmt = fmt3;
+
+			pr_warn("snprintf(%s%s); %d <= 0 (fmt %s)",
+				kind_name, name,
+				res1 <= 0 ? res1 : res2 <= 0 ? res2 :
+				res3 <= 0 ? res3 : res4, fmt);
+			failed_tests++;
+		} else if (res1 != res2) {
+			pr_warn("snprintf(%s%s): %d (to buf) != %d (no buf)",
+				kind_name, name, res1, res2);
+			failed_tests++;
+		} else if (res3 > res2) {
+			pr_warn("snprintf(%s%s); %d (no names) > %d (names)",
+				kind_name, name, res3, res2);
+			failed_tests++;
+		} else if (strcmp(buf, buf2) != 0) {
+			/* Safe and unsafe buffers should match. */
+			pr_warn("snprintf(%s%s); safe != unsafe",
+				kind_name, name);
+			pr_warn("safe: %s", buf);
+			pr_warn("unsafe: %s", buf2);
+			failed_tests++;
+		} else {
+			pr_debug("Printed %s%s (%d bytes)",
+				 kind_name, name, res1);
+		}
+	}
+	kfree(dummy_data);
+	kfree(buf);
+	kfree(buf2);
+}
+
+/*
+ * For BTF it is the struct btf_ptr * ptr field, not the pointer itself
+ * which gets displayed, so it is that we need to hash.
+ */
+static void __init
+test_btf_hashed(const char *fmt, struct btf_ptr *p)
+{
+	char buf[PLAIN_BUF_SIZE];
+	int ret;
+
+	ret = plain_hash_to_buffer(p->ptr, buf, PLAIN_BUF_SIZE);
+	if (ret)
+		return;
+
+	test(buf, fmt, p);
+}
+
+#ifdef CONFIG_DEBUG_INFO_BTF
+
+static void __init btf_pointer_test_int(void)
+{
+	/* simple int */
+	TEST_BTF_C(int, testint, 1234);
+	TEST_BTF("cN", int, testint, "1234", 1234);
+	/* zero value should be printed at toplevel */
+	TEST_BTF("c", int, testint, "(int)0", 0);
+	TEST_BTF("cN", int, testint, "0", 0);
+	TEST_BTF("c0", int, testint, "(int)0", 0);
+	TEST_BTF("cN0", int, testint, "0", 0);
+	TEST_BTF_C(int, testint, -4567);
+	TEST_BTF("cN", int, testint, "-4567", -4567);
+}
+
+static void __init btf_pointer_test_char(void)
+{
+	/* simple char */
+	TEST_BTF_C(char, testchar, 100);
+	TEST_BTF("cN", char, testchar, "100", 100);
+	/* zero value should be printed at toplevel */
+	TEST_BTF("c", char, testchar, "(char)0", 0);
+	TEST_BTF("cN", char, testchar, "0", 0);
+	TEST_BTF("c0", char, testchar, "(char)0", 0);
+	TEST_BTF("cN0", char, testchar, "0", 0);
+}
+
+static void __init btf_pointer_test_typedef(void)
+{
+	/* simple typedef */
+	TEST_BTF_C(phys_addr_t, testtype, 100);
+	TEST_BTF("cN", phys_addr_t, testtype, "1", 1);
+	/* zero value should be printed at toplevel */
+	TEST_BTF("c", phys_addr_t, testtype, "(phys_addr_t)0", 0);
+	TEST_BTF("cN", phys_addr_t, testtype, "0", 0);
+	TEST_BTF("c0", phys_addr_t, testtype, "(phys_addr_t)0", 0);
+	TEST_BTF("cN0", phys_addr_t, testtype, "0", 0);
+
+	/* typedef struct */
+	TEST_BTF_C(atomic_t, testtype, {.counter = (int)1,});
+	TEST_BTF("cN", atomic_t, testtype, "{1,}", {.counter = 1,});
+	/* typedef with 0 value should be printed at toplevel */
+	TEST_BTF("c", atomic_t, testtype, "(atomic_t){}", {.counter = 0,});
+	TEST_BTF("cN", atomic_t, testtype, "{}", {.counter = 0,});
+	TEST_BTF("c0", atomic_t, testtype, "(atomic_t){.counter = (int)0,}",
+		 {.counter = 0,});
+	TEST_BTF("cN0", atomic_t, testtype, "{0,}", {.counter = 0,});
+
+	/* typedef array */
+	TEST_BTF("c", cpumask_t, testtype,
+		 "(cpumask_t){.bits = (long unsigned int[])[1,],}",
+		 { .bits = {1,}});
+	TEST_BTF("cN", cpumask_t, testtype, "{[1,],}",
+		 { .bits = {1,}});
+	/* typedef with 0 value should be printed at toplevel */
+	TEST_BTF("c", cpumask_t, testtype, "(cpumask_t){}", {{ 0 }});
+}
+
+static void __init btf_pointer_test_enum(void)
+{
+	/* enum where enum value does (and does not) exist */
+	TEST_BTF_C(enum bpf_cmd, testenum, BPF_MAP_CREATE);
+	TEST_BTF("c", enum bpf_cmd, testenum, "(enum bpf_cmd)BPF_MAP_CREATE",
+		 0);
+	TEST_BTF("cN", enum bpf_cmd, testenum, "BPF_MAP_CREATE",
+		 BPF_MAP_CREATE);
+	TEST_BTF("cN0", enum bpf_cmd, testenum, "BPF_MAP_CREATE", 0);
+
+	TEST_BTF("c0", enum bpf_cmd, testenum, "(enum bpf_cmd)BPF_MAP_CREATE",
+		 BPF_MAP_CREATE);
+	TEST_BTF("cN0", enum bpf_cmd, testenum, "BPF_MAP_CREATE",
+		 BPF_MAP_CREATE);
+	TEST_BTF_C(enum bpf_cmd, testenum, 2000);
+	TEST_BTF("cN", enum bpf_cmd, testenum, "2000", 2000);
+}
+
+static void __init btf_pointer_test_struct(void)
+{
+	/* simple struct */
+	TEST_BTF_C(struct btf_enum, teststruct,
+		   {.name_off = (__u32)3,.val = (__s32)-1,});
+	TEST_BTF("cN", struct btf_enum, teststruct, "{3,-1,}",
+		 { .name_off = 3, .val = -1,});
+	TEST_BTF("cN", struct btf_enum, teststruct, "{-1,}",
+		 { .name_off = 0, .val = -1,});
+	TEST_BTF("cN0", struct btf_enum, teststruct, "{0,-1,}",
+		 { .name_off = 0, .val = -1,});
+	/* empty struct should be printed */
+	TEST_BTF("c", struct btf_enum, teststruct, "(struct btf_enum){}",
+		 { .name_off = 0, .val = 0,});
+	TEST_BTF("cN", struct btf_enum, teststruct, "{}",
+		 { .name_off = 0, .val = 0,});
+	TEST_BTF("c0", struct btf_enum, teststruct,
+		 "(struct btf_enum){.name_off = (__u32)0,.val = (__s32)0,}",
+		 { .name_off = 0, .val = 0,});
+
+	/* struct with pointers */
+	TEST_BTF("cx", struct skb_shared_info, testptr,
+		 "(struct skb_shared_info){.frag_list = (struct sk_buff *)0x0000000000000001,}",
+		 { .frag_list = (struct sk_buff *)1 });
+	/* NULL pointer should not be displayed */
+	TEST_BTF("cx", struct skb_shared_info, testptr,
+		 "(struct skb_shared_info){}",
+		 { .frag_list = (struct sk_buff *)0 });
+
+	/* struct with char array */
+	TEST_BTF("c", struct bpf_prog_info, teststruct,
+		 "(struct bpf_prog_info){.name = (char[])['f','o','o',],}",
+		 { .name = "foo",});
+	TEST_BTF("cN", struct bpf_prog_info, teststruct,
+		 "{['f','o','o',],}",
+		 {.name = "foo",});
+	/* leading null char means do not display string */
+	TEST_BTF("c", struct bpf_prog_info, teststruct,
+		 "(struct bpf_prog_info){}",
+		 {.name = {'\0', 'f', 'o', 'o'}});
+	/* handle non-printable characters */
+	TEST_BTF("c", struct bpf_prog_info, teststruct,
+		 "(struct bpf_prog_info){.name = (char[])[1,2,3,],}",
+		 { .name = {1, 2, 3, 0}});
+
+	/* struct with non-char array */
+	TEST_BTF("c", struct __sk_buff, teststruct,
+		 "(struct __sk_buff){.cb = (__u32[])[1,2,3,4,5,],}",
+		 { .cb = {1, 2, 3, 4, 5,},});
+	TEST_BTF("cN", struct __sk_buff, teststruct,
+		 "{[1,2,3,4,5,],}",
+		 { .cb = { 1, 2, 3, 4, 5},});
+	/* For non-char, arrays, show non-zero values only */
+	TEST_BTF("c", struct __sk_buff, teststruct,
+		 "(struct __sk_buff){.cb = (__u32[])[1,],}",
+		 { .cb = { 0, 0, 1, 0, 0},});
+
+	/* struct with struct array */
+	TEST_BTF("c", struct bpf_struct_ops, teststruct,
+		 "(struct bpf_struct_ops){.func_models = (struct btf_func_model[])[(struct btf_func_model){.ret_size = (u8)1,.nr_args = (u8)2,.arg_size = (u8[])[3,4,5,],},],}",
+		 { .func_models = {{ .ret_size = 1, .nr_args = 2,
+				     .arg_size = { 3, 4, 5,},}}});
+
+	/* struct with bitfields */
+	TEST_BTF_C(struct bpf_insn, testbitfield,
+		   {.code = (__u8)1,.dst_reg = (__u8)0x2,.src_reg = (__u8)0x3,.off = (__s16)4,.imm = (__s32)5,});
+	TEST_BTF("cN", struct bpf_insn, testbitfield, "{1,0x2,0x3,4,5,}",
+		 {.code = 1, .dst_reg = 0x2, .src_reg = 0x3, .off = 4,
+		  .imm = 5,});
+
+	/* struct with anon struct/unions */
+	TEST_BTF("cx", struct sk_buff, test_anon,
+		 "(struct sk_buff){(union){(struct){(union){.dev = (struct net_device *)0x0000000000000001,.dev_scratch = (long unsigned int)1,},},.rbnode = (struct rb_node){.rb_left = (struct rb_node *)0x0000000000000001,},},}",
+		 { .dev_scratch = 1 });
+}
+
+#endif /* CONFIG_DEBUG_INFO_BTF */
+
+static void __init
+btf_pointer(void)
+{
+	struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
+	u64 fillvals[] = { 0x0, 0xffffffffffffffff, 0x0123456789abcdef };
+	int i;
+
+#ifdef CONFIG_DEBUG_INFO_BTF
+	btf_pointer_test_int();
+	btf_pointer_test_char();
+	btf_pointer_test_typedef();
+	btf_pointer_test_enum();
+	btf_pointer_test_struct();
+#endif /* CONFIG_DEBUG_INFO_BTF */
+
+	/*
+	 * Iterate every instance of each kind, printing each associated type.
+	 * This constitutes around 10k tests.
+	 */
+	for (i = 0; i < ARRAY_SIZE(fillvals); i++) {
+		btf_print_kind(BTF_KIND_STRUCT, "struct ", fillvals[i]);
+		btf_print_kind(BTF_KIND_UNION, "union ", fillvals[i]);
+		btf_print_kind(BTF_KIND_ENUM, "enum ", fillvals[i]);
+		btf_print_kind(BTF_KIND_TYPEDEF, "", fillvals[i]);
+	}
+
+	/* verify unknown type falls back to hashed pointer display */
+	test("(null)", "%pT", BTF_PTR_TYPE(NULL, "unknown_type"));
+	test_btf_hashed("%pT", BTF_PTR_TYPE(skb, "unknown_type"));
+
+	kfree_skb(skb);
+}
+
 static void __init
 test_pointer(void)
 {
@@ -694,6 +1009,7 @@ static void __init fwnode_pointer(void)
 	flags();
 	errptr();
 	fwnode_pointer();
+	btf_pointer();
 }
 
 static void __init selftest(void)
-- 
1.8.3.1

