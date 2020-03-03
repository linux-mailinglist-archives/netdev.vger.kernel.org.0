Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD1F17784C
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbgCCOIt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 3 Mar 2020 09:08:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41195 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729466AbgCCOIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 09:08:48 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-Hf3xMLEJPhqgU7Yp7xR7Dw-1; Tue, 03 Mar 2020 09:08:43 -0500
X-MC-Unique: Hf3xMLEJPhqgU7Yp7xR7Dw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53DED8017CC;
        Tue,  3 Mar 2020 14:08:41 +0000 (UTC)
Received: from krava.redhat.com (ovpn-206-59.brq.redhat.com [10.40.206.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7452091D6E;
        Tue,  3 Mar 2020 14:08:38 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: [RFC] libbpf,selftests: Question on btf_dump__emit_type_decl for BTF_KIND_FUNC
Date:   Tue,  3 Mar 2020 15:08:37 +0100
Message-Id: <20200303140837.90056-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
for bpftrace I'd like to print BTF functions (BTF_KIND_FUNC)
declarations together with their names.

I saw we have btf_dump__emit_type_decl and added BTF_KIND_FUNC,
where it seemed to be missing, so it prints out something now
(not sure it's the right fix though).

Anyway, would you be ok with adding some flag/bool to struct
btf_dump_emit_type_decl_opts, so I could get output like:

  kfunc:ksys_readahead(int fd, long long int offset, long unsigned int count) = ssize_t
  kfunc:ksys_read(unsigned int fd, char buf, long unsigned int count) = size_t

... to be able to the arguments and return type separated,
so I could easily get to something like above?

Current interface is just vfprintf callback and I'm not sure
I can rely that it will allywas be called with same arguments,
like having separated calls for parsed atoms like 'return type',
'(', ')', '(', 'arg type', 'arg name', ...

I'm open to any suggestion ;-)

thanks,
jirka


---
 tools/lib/bpf/btf_dump.c                      |  4 ++++
 .../selftests/bpf/prog_tests/btf_dump.c       | 21 +++++++++++++++++++
 .../bpf/progs/btf_dump_test_case_bitfields.c  | 10 +++++++++
 .../bpf/progs/btf_dump_test_case_multidim.c   |  3 +++
 .../progs/btf_dump_test_case_namespacing.c    | 19 +++++++++++++++++
 .../bpf/progs/btf_dump_test_case_ordering.c   |  3 +++
 .../bpf/progs/btf_dump_test_case_packing.c    | 16 ++++++++++++++
 .../bpf/progs/btf_dump_test_case_padding.c    | 15 +++++++++++++
 .../bpf/progs/btf_dump_test_case_syntax.c     |  3 +++
 9 files changed, 94 insertions(+)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index bd09ed1710f1..40c7491424eb 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1068,6 +1068,7 @@ static void btf_dump_emit_type_decl(struct btf_dump *d, __u32 id,
 		case BTF_KIND_CONST:
 		case BTF_KIND_RESTRICT:
 		case BTF_KIND_FUNC_PROTO:
+		case BTF_KIND_FUNC:
 			id = t->type;
 			break;
 		case BTF_KIND_ARRAY:
@@ -1307,6 +1308,9 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 			btf_dump_printf(d, ")");
 			return;
 		}
+		case BTF_KIND_FUNC:
+			/* All work is done via BTF_KIND_FUNC_PROTO already. */
+			break;
 		default:
 			pr_warn("unexpected type in decl chain, kind:%u, id:[%u]\n",
 				kind, id);
diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index 7390d3061065..adcd0abcec5c 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -26,6 +26,9 @@ static struct btf_dump_test_case {
 static int btf_dump_all_types(const struct btf *btf,
 			      const struct btf_dump_opts *opts)
 {
+	DECLARE_LIBBPF_OPTS(btf_dump_emit_type_decl_opts, decl_opts,
+		.field_name = "",
+	);
 	size_t type_cnt = btf__get_nr_types(btf);
 	struct btf_dump *d;
 	int err = 0, id;
@@ -35,9 +38,27 @@ static int btf_dump_all_types(const struct btf *btf,
 		return PTR_ERR(d);
 
 	for (id = 1; id <= type_cnt; id++) {
+		const struct btf_type *type;
+
 		err = btf_dump__dump_type(d, id);
 		if (err)
 			goto done;
+
+		type = btf__type_by_id(btf, id);
+
+		if (BTF_INFO_KIND(type->info) != BTF_KIND_FUNC)
+			continue;
+
+		err = btf_dump__emit_type_decl(d, id, &decl_opts);
+		if (err)
+			goto done;
+
+		/*
+		 * There's no newline at the end of the declaration dumped
+		 * by btf_dump__emit_type_decl, so doing an extra *one, so
+		 * we can have 'expected' counter part with newline.
+		 */
+		fprintf(opts->ctx, "\n");
 	}
 
 done:
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
index 8f44767a75fa..4d911cab7012 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
@@ -82,6 +82,16 @@ struct bitfield_flushed {
 	long b: 16;
 };
 
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *int ()(struct {
+ *	struct bitfields_only_mixed_types _1;
+ *	struct bitfield_mixed_with_others _2;
+ *	struct bitfield_flushed _3;
+ *} *_)
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
 int f(struct {
 	struct bitfields_only_mixed_types _1;
 	struct bitfield_mixed_with_others _2;
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_multidim.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_multidim.c
index ba97165bdb28..97e189e8246a 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_multidim.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_multidim.c
@@ -27,6 +27,9 @@ struct root_struct {
 	fn_ptr_multiarr_t _6;
 };
 
+/*
+ *int ()(struct root_struct *s)
+ */
 /* ------ END-EXPECTED-OUTPUT ------ */
 
 int f(struct root_struct *s)
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_namespacing.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_namespacing.c
index 92a4ad428710..ac4141a611bf 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_namespacing.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_namespacing.c
@@ -49,6 +49,25 @@ typedef int Y;
 
 typedef int Z;
 
+/*
+ *int ()(struct {
+ *	struct S _1;
+ *	S _2;
+ *	union U _3;
+ *	U _4;
+ *	enum E _5;
+ *	E _6;
+ *	struct A a;
+ *	union B b;
+ *	enum C c;
+ *	struct X x;
+ *	union Y y;
+ *	enum Z *z;
+ *	X xx;
+ *	Y yy;
+ *	Z zz;
+ *} *_)
+ */
 /*------ END-EXPECTED-OUTPUT ------ */
 
 int f(struct {
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_ordering.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_ordering.c
index 7c95702ee4cb..2687ca94025d 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_ordering.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_ordering.c
@@ -55,6 +55,9 @@ struct root_struct {
 	struct callback_head cb;
 };
 
+/*
+ *int ()(struct root_struct *root)
+ */
 /*------ END-EXPECTED-OUTPUT ------ */
 
 int f(struct root_struct *root)
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
index 1cef3bec1dc7..88bae49bdbbb 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
@@ -58,6 +58,22 @@ union jump_code_union {
 	} __attribute__((packed));
 };
 
+/*
+ *int ()(struct {
+ *	struct packed_trailing_space _1;
+ *	short: 16;
+ *	struct non_packed_trailing_space _2;
+ *	struct packed_fields _3;
+ *	short: 16;
+ *	struct non_packed_fields _4;
+ *	struct nested_packed _5;
+ *	short: 16;
+ *	union union_is_never_packed _6;
+ *	union union_does_not_need_packing _7;
+ *	union jump_code_union _8;
+ *	int: 24;
+ *} __attribute__((packed)) *_)
+ */
 /*------ END-EXPECTED-OUTPUT ------ */
 
 int f(struct {
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
index 35c512818a56..581349bb0c2f 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
@@ -102,6 +102,21 @@ struct zone {
 	struct zone_padding __pad__;
 };
 
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *int ()(struct {
+ *	struct padded_implicitly _1;
+ *	struct padded_explicitly _2;
+ *	struct padded_a_lot _3;
+ *	struct padded_cache_line _4;
+ *	struct zone _5;
+ *	long: 64;
+ *	long: 64;
+ *	long: 64;
+ *} *_)
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
 int f(struct {
 	struct padded_implicitly _1;
 	struct padded_explicitly _2;
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
index d4a02fe44a12..b110eea7ffd2 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
@@ -221,6 +221,9 @@ struct root_struct {
 	struct struct_with_embedded_stuff _14;
 };
 
+/*
+ *int ()(struct root_struct *s)
+ */
 /* ------ END-EXPECTED-OUTPUT ------ */
 
 int f(struct root_struct *s)
-- 
2.24.1

