Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F49275F15
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 19:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgIWRsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 13:48:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55760 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgIWRsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 13:48:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NHdK3H078123;
        Wed, 23 Sep 2020 17:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=+xFzePYDwaghOwy39cVudGoZ3x+QB4s7E6Ub21RVEvU=;
 b=av/TQLMz0fMrwYKjzyyiCzmFDEoEJjk+G0WGLfsW1mV6wznRueutftEkbhDUPzBbY2Jq
 CxJCLUtWDm61EdoQnU1oIvyOjHrxeLhx/DtUZaNiSzW+bQWubdcBgRmuPCJu44fUxNFS
 skZnCu4wzF1ZvOA4wO+J0bUGkXQ8DF1TACFDpGYcF8RFoZwkPq8U/hKYdnj4F0LtAMI3
 IfD47xWa9/0GlcJxutw6KrEFX021uCxRb7JZsyuIwKj5PGMZGfHq4xy8HIqUUlNkeo8j
 UgwVhUyqjzSPzg4D5iE8fcXCNQCa0Ydi9UrdfvjXznufSg7ypMw3cjsRsSPXz8agaArU gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33q5rgj9qh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 17:47:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NHe6AS074411;
        Wed, 23 Sep 2020 17:47:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33r28vxw2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 17:47:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08NHl9iQ000940;
        Wed, 23 Sep 2020 17:47:09 GMT
Received: from localhost.uk.oracle.com (/10.175.195.80)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 10:47:09 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com
Cc:     linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        acme@kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v6 bpf-next 4/6] selftests/bpf: add bpf_snprintf_btf helper tests
Date:   Wed, 23 Sep 2020 18:46:26 +0100
Message-Id: <1600883188-4831-5-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com>
References: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230135
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tests verifying snprintf()ing of various data structures,
flags combinations using a tp_btf program.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/snprintf_btf.c        |  54 +++++
 .../selftests/bpf/progs/netif_receive_skb.c        | 260 +++++++++++++++++++++
 2 files changed, 314 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/snprintf_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/netif_receive_skb.c

diff --git a/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c b/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c
new file mode 100644
index 0000000..855e11d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <linux/btf.h>
+#include "netif_receive_skb.skel.h"
+
+/* Demonstrate that bpf_snprintf_btf succeeds and that various data types
+ * are formatted correctly.
+ */
+void test_snprintf_btf(void)
+{
+	struct netif_receive_skb *skel;
+	struct netif_receive_skb__bss *bss;
+	int err, duration = 0;
+
+	skel = netif_receive_skb__open();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		return;
+
+	err = netif_receive_skb__load(skel);
+	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
+		goto cleanup;
+
+	bss = skel->bss;
+
+	err = netif_receive_skb__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* generate receive event */
+	system("ping -c 1 127.0.0.1 > /dev/null");
+
+	/*
+	 * Make sure netif_receive_skb program was triggered
+	 * and it set expected return values from bpf_trace_printk()s
+	 * and all tests ran.
+	 */
+	if (CHECK(bss->ret <= 0,
+		  "bpf_snprintf_btf: got return value",
+		  "ret <= 0 %ld test %d\n", bss->ret, bss->ran_subtests))
+		goto cleanup;
+
+	if (CHECK(bss->ran_subtests == 0, "check if subtests ran",
+		  "no subtests ran, did BPF program run?"))
+		goto cleanup;
+
+	if (CHECK(bss->num_subtests != bss->ran_subtests,
+		  "check all subtests ran",
+		  "only ran %d of %d tests\n", bss->num_subtests,
+		  bss->ran_subtests))
+		goto cleanup;
+
+cleanup:
+	netif_receive_skb__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
new file mode 100644
index 0000000..b4f96f1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
@@ -0,0 +1,260 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Oracle and/or its affiliates. */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <errno.h>
+
+long ret = 0;
+int num_subtests = 0;
+int ran_subtests = 0;
+
+#define STRSIZE			2048
+#define EXPECTED_STRSIZE	256
+
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(x)	(sizeof(x) / sizeof((x)[0]))
+#endif
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, char[STRSIZE]);
+} strdata SEC(".maps");
+
+static int __strncmp(const void *m1, const void *m2, size_t len)
+{
+	const unsigned char *s1 = m1;
+	const unsigned char *s2 = m2;
+	int i, delta = 0;
+
+#pragma clang loop unroll(full)
+	for (i = 0; i < len; i++) {
+		delta = s1[i] - s2[i];
+		if (delta || s1[i] == 0 || s2[i] == 0)
+			break;
+	}
+	return delta;
+}
+
+/* Use __builtin_btf_type_id to test snprintf_btf by type id instead of name */
+#if __has_builtin(__builtin_btf_type_id)
+#define TEST_BTF_BY_ID(_str, _typestr, _ptr, _hflags)			\
+	do {								\
+		int _expected_ret = ret;				\
+		_ptr.type = 0;						\
+		_ptr.type_id = __builtin_btf_type_id(_typestr, 0);	\
+		ret = bpf_snprintf_btf(_str, STRSIZE, &_ptr,		\
+				       sizeof(_ptr), _hflags);		\
+		if (ret != _expected_ret) {				\
+			bpf_printk("expected ret (%d), got (%d)",	\
+				   _expected_ret, ret);			\
+			ret = -EBADMSG;					\
+		}							\
+	} while (0)
+#else
+#define TEST_BTF_BY_ID(_str, _typestr, _ptr, _hflags)			\
+	do { } while (0)
+#endif
+
+#define	TEST_BTF(_str, _type, _flags, _expected, ...)			\
+	do {								\
+		static const char _expectedval[EXPECTED_STRSIZE] =	\
+							_expected;	\
+		static const char _ptrtype[64] = #_type;		\
+		__u64 _hflags = _flags | BTF_F_COMPACT;			\
+		static _type _ptrdata = __VA_ARGS__;			\
+		static struct btf_ptr _ptr = { };			\
+		int _cmp;						\
+									\
+		_ptr.type = _ptrtype;					\
+		_ptr.ptr = &_ptrdata;					\
+									\
+		++num_subtests;						\
+		if (ret < 0)						\
+			break;						\
+		++ran_subtests;						\
+		ret = bpf_snprintf_btf(_str, STRSIZE,			\
+				       &_ptr, sizeof(_ptr), _hflags);	\
+		if (ret)						\
+			break;						\
+		_cmp = __strncmp(_str, _expectedval, EXPECTED_STRSIZE);	\
+		if (_cmp != 0) {					\
+			bpf_printk("(%d) got %s", _cmp, _str);		\
+			bpf_printk("(%d) expected %s", _cmp,		\
+				   _expectedval);			\
+			ret = -EBADMSG;					\
+			break;						\
+		}							\
+		TEST_BTF_BY_ID(_str, #_type, _ptr, _hflags);		\
+	} while (0)
+
+/* Use where expected data string matches its stringified declaration */
+#define TEST_BTF_C(_str, _type, _flags, ...)				\
+	TEST_BTF(_str, _type, _flags, "(" #_type ")" #__VA_ARGS__,	\
+		 __VA_ARGS__)
+
+/* TRACE_EVENT(netif_receive_skb,
+ *	TP_PROTO(struct sk_buff *skb),
+ */
+SEC("tp_btf/netif_receive_skb")
+int BPF_PROG(trace_netif_receive_skb, struct sk_buff *skb)
+{
+	static __u64 flags[] = { 0, BTF_F_COMPACT, BTF_F_ZERO, BTF_F_PTR_RAW,
+				 BTF_F_NONAME, BTF_F_COMPACT | BTF_F_ZERO |
+				 BTF_F_PTR_RAW | BTF_F_NONAME };
+	static const char skbtype[] = "struct sk_buff";
+	static struct btf_ptr p = { };
+	__u32 key = 0;
+	int i, __ret;
+	char *str;
+
+	str = bpf_map_lookup_elem(&strdata, &key);
+	if (!str)
+		return 0;
+
+	/* Ensure we can write skb string representation */
+	p.type = skbtype;
+	p.ptr = skb;
+	for (i = 0; i < ARRAY_SIZE(flags); i++) {
+		++num_subtests;
+		ret = bpf_snprintf_btf(str, STRSIZE, &p, sizeof(p), 0);
+		if (ret < 0)
+			bpf_printk("returned %d when writing skb", ret);
+		++ran_subtests;
+	}
+
+	/* Check invalid ptr value */
+	p.ptr = 0;
+	__ret = bpf_snprintf_btf(str, STRSIZE, &p, sizeof(p), 0);
+	if (__ret >= 0) {
+		bpf_printk("printing NULL should generate error, got (%d)",
+			   __ret);
+		ret = -ERANGE;
+	}
+
+	/* Verify type display for various types. */
+
+	/* simple int */
+	TEST_BTF_C(str, int, 0, 1234);
+	TEST_BTF(str, int, BTF_F_NONAME, "1234", 1234);
+	/* zero value should be printed at toplevel */
+	TEST_BTF(str, int, 0, "(int)0", 0);
+	TEST_BTF(str, int, BTF_F_NONAME, "0", 0);
+	TEST_BTF(str, int, BTF_F_ZERO, "(int)0", 0);
+	TEST_BTF(str, int, BTF_F_NONAME | BTF_F_ZERO, "0", 0);
+	TEST_BTF_C(str, int, 0, -4567);
+	TEST_BTF(str, int, BTF_F_NONAME, "-4567", -4567);
+
+	/* simple char */
+	TEST_BTF_C(str, char, 0, 100);
+	TEST_BTF(str, char, BTF_F_NONAME, "100", 100);
+	/* zero value should be printed at toplevel */
+	TEST_BTF(str, char, 0, "(char)0", 0);
+	TEST_BTF(str, char, BTF_F_NONAME, "0", 0);
+	TEST_BTF(str, char, BTF_F_ZERO, "(char)0", 0);
+	TEST_BTF(str, char, BTF_F_NONAME | BTF_F_ZERO, "0", 0);
+
+	/* simple typedef */
+	TEST_BTF_C(str, uint64_t, 0, 100);
+	TEST_BTF(str, u64, BTF_F_NONAME, "1", 1);
+	/* zero value should be printed at toplevel */
+	TEST_BTF(str, u64, 0, "(u64)0", 0);
+	TEST_BTF(str, u64, BTF_F_NONAME, "0", 0);
+	TEST_BTF(str, u64, BTF_F_ZERO, "(u64)0", 0);
+	TEST_BTF(str, u64, BTF_F_NONAME|BTF_F_ZERO, "0", 0);
+
+	/* typedef struct */
+	TEST_BTF_C(str, atomic_t, 0, {.counter = (int)1,});
+	TEST_BTF(str, atomic_t, BTF_F_NONAME, "{1,}", {.counter = 1,});
+	/* typedef with 0 value should be printed at toplevel */
+	TEST_BTF(str, atomic_t, 0, "(atomic_t){}", {.counter = 0,});
+	TEST_BTF(str, atomic_t, BTF_F_NONAME, "{}", {.counter = 0,});
+	TEST_BTF(str, atomic_t, BTF_F_ZERO, "(atomic_t){.counter = (int)0,}",
+		 {.counter = 0,});
+	TEST_BTF(str, atomic_t, BTF_F_NONAME|BTF_F_ZERO,
+		 "{0,}", {.counter = 0,});
+
+	/* enum where enum value does (and does not) exist */
+	TEST_BTF_C(str, enum bpf_cmd, 0, BPF_MAP_CREATE);
+	TEST_BTF(str, enum bpf_cmd, 0, "(enum bpf_cmd)BPF_MAP_CREATE", 0);
+	TEST_BTF(str, enum bpf_cmd, BTF_F_NONAME, "BPF_MAP_CREATE",
+		 BPF_MAP_CREATE);
+	TEST_BTF(str, enum bpf_cmd, BTF_F_NONAME|BTF_F_ZERO,
+		 "BPF_MAP_CREATE", 0);
+
+	TEST_BTF(str, enum bpf_cmd, BTF_F_ZERO, "(enum bpf_cmd)BPF_MAP_CREATE",
+		 BPF_MAP_CREATE);
+	TEST_BTF(str, enum bpf_cmd, BTF_F_NONAME|BTF_F_ZERO,
+		 "BPF_MAP_CREATE", BPF_MAP_CREATE);
+	TEST_BTF_C(str, enum bpf_cmd, 0, 2000);
+	TEST_BTF(str, enum bpf_cmd, BTF_F_NONAME, "2000", 2000);
+
+	/* simple struct */
+	TEST_BTF_C(str, struct btf_enum, 0,
+		   {.name_off = (__u32)3,.val = (__s32)-1,});
+	TEST_BTF(str, struct btf_enum, BTF_F_NONAME, "{3,-1,}",
+		 { .name_off = 3, .val = -1,});
+	TEST_BTF(str, struct btf_enum, BTF_F_NONAME, "{-1,}",
+		 { .name_off = 0, .val = -1,});
+	TEST_BTF(str, struct btf_enum, BTF_F_NONAME|BTF_F_ZERO, "{0,-1,}",
+		 { .name_off = 0, .val = -1,});
+	/* empty struct should be printed */
+	TEST_BTF(str, struct btf_enum, 0, "(struct btf_enum){}",
+		 { .name_off = 0, .val = 0,});
+	TEST_BTF(str, struct btf_enum, BTF_F_NONAME, "{}",
+		 { .name_off = 0, .val = 0,});
+	TEST_BTF(str, struct btf_enum, BTF_F_ZERO,
+		 "(struct btf_enum){.name_off = (__u32)0,.val = (__s32)0,}",
+		 { .name_off = 0, .val = 0,});
+
+	/* struct with pointers */
+	TEST_BTF(str, struct list_head, BTF_F_PTR_RAW,
+		 "(struct list_head){.next = (struct list_head *)0x0000000000000001,}",
+		 { .next = (struct list_head *)1 });
+	/* NULL pointer should not be displayed */
+	TEST_BTF(str, struct list_head, BTF_F_PTR_RAW,
+		 "(struct list_head){}",
+		 { .next = (struct list_head *)0 });
+
+	/* struct with char array */
+	TEST_BTF(str, struct bpf_prog_info, 0,
+		 "(struct bpf_prog_info){.name = (char[])['f','o','o',],}",
+		 { .name = "foo",});
+	TEST_BTF(str, struct bpf_prog_info, BTF_F_NONAME,
+		 "{['f','o','o',],}",
+		 {.name = "foo",});
+	/* leading null char means do not display string */
+	TEST_BTF(str, struct bpf_prog_info, 0,
+		 "(struct bpf_prog_info){}",
+		 {.name = {'\0', 'f', 'o', 'o'}});
+	/* handle non-printable characters */
+	TEST_BTF(str, struct bpf_prog_info, 0,
+		 "(struct bpf_prog_info){.name = (char[])[1,2,3,],}",
+		 { .name = {1, 2, 3, 0}});
+
+	/* struct with non-char array */
+	TEST_BTF(str, struct __sk_buff, 0,
+		 "(struct __sk_buff){.cb = (__u32[])[1,2,3,4,5,],}",
+		 { .cb = {1, 2, 3, 4, 5,},});
+	TEST_BTF(str, struct __sk_buff, BTF_F_NONAME,
+		 "{[1,2,3,4,5,],}",
+		 { .cb = { 1, 2, 3, 4, 5},});
+	/* For non-char, arrays, show non-zero values only */
+	TEST_BTF(str, struct __sk_buff, 0,
+		 "(struct __sk_buff){.cb = (__u32[])[1,],}",
+		 { .cb = { 0, 0, 1, 0, 0},});
+
+	/* struct with bitfields */
+	TEST_BTF_C(str, struct bpf_insn, 0,
+		   {.code = (__u8)1,.dst_reg = (__u8)0x2,.src_reg = (__u8)0x3,.off = (__s16)4,.imm = (__s32)5,});
+	TEST_BTF(str, struct bpf_insn, BTF_F_NONAME, "{1,0x2,0x3,4,5,}",
+		 {.code = 1, .dst_reg = 0x2, .src_reg = 0x3, .off = 4,
+		  .imm = 5,});
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
1.8.3.1

