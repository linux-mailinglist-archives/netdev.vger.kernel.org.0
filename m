Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77F7A18944A
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 04:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgCRDOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 23:14:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49726 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726229AbgCRDOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 23:14:55 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02I39BxF020992
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 20:14:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=YinHzWkN5kvrfccQMrx+wWIDKtu4btKedzrLz4slACs=;
 b=LoRic2zhAzORSB/UBp5+SrtKlimzbCULS+jz+SMdrsHhrIRu8pUn5/VWQsBaggEPbVNp
 /j7MLBANKW6YitrOaBWnaojrbN/G0lgAa6aia+DTTvs6omKf+GBKPODVO31dNwGsmQGi
 qrZbIgmfFIJKEp06+QgXKFHObLIX9eK7oHs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yu99b0ff0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 20:14:54 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 17 Mar 2020 20:14:53 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 24C0C294307C; Tue, 17 Mar 2020 20:14:50 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 3/4] bpftool: Translate prog_id to its bpf prog_name
Date:   Tue, 17 Mar 2020 20:14:50 -0700
Message-ID: <20200318031450.1256819-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200318031431.1256036-1-kafai@fb.com>
References: <20200318031431.1256036-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-17_10:2020-03-17,2020-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=38
 lowpriorityscore=0 bulkscore=0 mlxlogscore=909 spamscore=0 impostorscore=0
 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180016
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel struct_ops obj has kernel's func ptrs implemented by bpf_progs.
The bpf prog_id is stored as the value of the func ptr for introspection
purpose.  In the latter patch, a struct_ops dump subcmd will be added
to introspect these func ptrs.  It is desired to print the actual bpf
prog_name instead of only printing the prog_id.

Since struct_ops is the only usecase storing prog_id in the func ptr,
this patch adds a prog_id_as_func_ptr bool (default is false) to
"struct btf_dumper" in order not to mis-interpret the ptr value
for the other existing use-cases.

While printing a func_ptr as a bpf prog_name,
this patch also prefix the bpf prog_name with the ptr's func_proto.
[ Note that it is the ptr's func_proto instead of the bpf prog's
  func_proto ]
It reuses the current btf_dump_func() to obtain the ptr's func_proto
string.

Here is an example from the bpf_cubic.c:
"void (struct sock *, u32, u32) bictcp_cong_avoid/prog_id:140"

Acked-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/bpf/bpftool/btf_dumper.c | 118 +++++++++++++++++++++++++++++----
 tools/bpf/bpftool/main.h       |   1 +
 2 files changed, 107 insertions(+), 12 deletions(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index 3a9dc8bc97a8..76a807b963e0 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -4,11 +4,13 @@
 #include <ctype.h>
 #include <stdio.h> /* for (FILE *) used by json_writer */
 #include <string.h>
+#include <unistd.h>
 #include <asm/byteorder.h>
 #include <linux/bitops.h>
 #include <linux/btf.h>
 #include <linux/err.h>
 #include <bpf/btf.h>
+#include <bpf/bpf.h>
 
 #include "json_writer.h"
 #include "main.h"
@@ -22,13 +24,102 @@
 static int btf_dumper_do_type(const struct btf_dumper *d, __u32 type_id,
 			      __u8 bit_offset, const void *data);
 
-static void btf_dumper_ptr(const void *data, json_writer_t *jw,
-			   bool is_plain_text)
+static int btf_dump_func(const struct btf *btf, char *func_sig,
+			 const struct btf_type *func_proto,
+			 const struct btf_type *func, int pos, int size);
+
+static int dump_prog_id_as_func_ptr(const struct btf_dumper *d,
+				    const struct btf_type *func_proto,
+				    __u32 prog_id)
 {
-	if (is_plain_text)
-		jsonw_printf(jw, "%p", *(void **)data);
+	struct bpf_prog_info_linear *prog_info = NULL;
+	const struct btf_type *func_type;
+	const char *prog_name = NULL;
+	struct bpf_func_info *finfo;
+	struct btf *prog_btf = NULL;
+	struct bpf_prog_info *info;
+	int prog_fd, func_sig_len;
+	char prog_str[1024];
+
+	/* Get the ptr's func_proto */
+	func_sig_len = btf_dump_func(d->btf, prog_str, func_proto, NULL, 0,
+				     sizeof(prog_str));
+	if (func_sig_len == -1)
+		return -1;
+
+	if (!prog_id)
+		goto print;
+
+	/* Get the bpf_prog's name.  Obtain from func_info. */
+	prog_fd = bpf_prog_get_fd_by_id(prog_id);
+	if (prog_fd == -1)
+		goto print;
+
+	prog_info = bpf_program__get_prog_info_linear(prog_fd,
+						1UL << BPF_PROG_INFO_FUNC_INFO);
+	close(prog_fd);
+	if (IS_ERR(prog_info)) {
+		prog_info = NULL;
+		goto print;
+	}
+	info = &prog_info->info;
+
+	if (!info->btf_id || !info->nr_func_info ||
+	    btf__get_from_id(info->btf_id, &prog_btf))
+		goto print;
+	finfo = (struct bpf_func_info *)info->func_info;
+	func_type = btf__type_by_id(prog_btf, finfo->type_id);
+	if (!func_type || !btf_is_func(func_type))
+		goto print;
+
+	prog_name = btf__name_by_offset(prog_btf, func_type->name_off);
+
+print:
+	if (!prog_id)
+		snprintf(&prog_str[func_sig_len],
+			 sizeof(prog_str) - func_sig_len, " 0");
+	else if (prog_name)
+		snprintf(&prog_str[func_sig_len],
+			 sizeof(prog_str) - func_sig_len,
+			 " %s/prog_id:%u", prog_name, prog_id);
 	else
-		jsonw_printf(jw, "%lu", *(unsigned long *)data);
+		snprintf(&prog_str[func_sig_len],
+			 sizeof(prog_str) - func_sig_len,
+			 " <unknown_prog_name>/prog_id:%u", prog_id);
+
+	prog_str[sizeof(prog_str) - 1] = '\0';
+	jsonw_string(d->jw, prog_str);
+	btf__free(prog_btf);
+	free(prog_info);
+	return 0;
+}
+
+static void btf_dumper_ptr(const struct btf_dumper *d,
+			   const struct btf_type *t,
+			   const void *data)
+{
+	unsigned long value = *(unsigned long *)data;
+	const struct btf_type *ptr_type;
+	__s32 ptr_type_id;
+
+	if (!d->prog_id_as_func_ptr || value > UINT32_MAX)
+		goto print_ptr_value;
+
+	ptr_type_id = btf__resolve_type(d->btf, t->type);
+	if (ptr_type_id < 0)
+		goto print_ptr_value;
+	ptr_type = btf__type_by_id(d->btf, ptr_type_id);
+	if (!ptr_type || !btf_is_func_proto(ptr_type))
+		goto print_ptr_value;
+
+	if (!dump_prog_id_as_func_ptr(d, ptr_type, value))
+		return;
+
+print_ptr_value:
+	if (d->is_plain_text)
+		jsonw_printf(d->jw, "%p", (void *)value);
+	else
+		jsonw_printf(d->jw, "%lu", value);
 }
 
 static int btf_dumper_modifier(const struct btf_dumper *d, __u32 type_id,
@@ -443,7 +534,7 @@ static int btf_dumper_do_type(const struct btf_dumper *d, __u32 type_id,
 		btf_dumper_enum(d, t, data);
 		return 0;
 	case BTF_KIND_PTR:
-		btf_dumper_ptr(data, d->jw, d->is_plain_text);
+		btf_dumper_ptr(d, t, data);
 		return 0;
 	case BTF_KIND_UNKN:
 		jsonw_printf(d->jw, "(unknown)");
@@ -488,10 +579,6 @@ int btf_dumper_type(const struct btf_dumper *d, __u32 type_id,
 			return -1;					\
 	} while (0)
 
-static int btf_dump_func(const struct btf *btf, char *func_sig,
-			 const struct btf_type *func_proto,
-			 const struct btf_type *func, int pos, int size);
-
 static int __btf_dumper_type_only(const struct btf *btf, __u32 type_id,
 				  char *func_sig, int pos, int size)
 {
@@ -600,8 +687,15 @@ static int btf_dump_func(const struct btf *btf, char *func_sig,
 			BTF_PRINT_ARG(", ");
 		if (arg->type) {
 			BTF_PRINT_TYPE(arg->type);
-			BTF_PRINT_ARG("%s",
-				      btf__name_by_offset(btf, arg->name_off));
+			if (arg->name_off)
+				BTF_PRINT_ARG("%s",
+					      btf__name_by_offset(btf, arg->name_off));
+			else if (pos && func_sig[pos - 1] == ' ')
+				/* Remove unnecessary space for
+				 * FUNC_PROTO that does not have
+				 * arg->name_off
+				 */
+				func_sig[--pos] = '\0';
 		} else {
 			BTF_PRINT_ARG("...");
 		}
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 5f6dccd43622..6db2398ae7e9 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -205,6 +205,7 @@ struct btf_dumper {
 	const struct btf *btf;
 	json_writer_t *jw;
 	bool is_plain_text;
+	bool prog_id_as_func_ptr;
 };
 
 /* btf_dumper_type - print data along with type information
-- 
2.17.1

