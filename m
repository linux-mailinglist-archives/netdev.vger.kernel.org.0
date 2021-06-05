Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE99939C7D1
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 13:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFELNT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Jun 2021 07:13:19 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:46598 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230309AbhFELNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 07:13:17 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-dgpVB63sMNugNYU4tMrT8g-1; Sat, 05 Jun 2021 07:11:26 -0400
X-MC-Unique: dgpVB63sMNugNYU4tMrT8g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B09B803620;
        Sat,  5 Jun 2021 11:11:24 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.192.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 753FE614FD;
        Sat,  5 Jun 2021 11:11:21 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH 14/19] libbpf: Add btf__find_by_pattern_kind function
Date:   Sat,  5 Jun 2021 13:10:29 +0200
Message-Id: <20210605111034.1810858-15-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-1-jolsa@kernel.org>
References: <20210605111034.1810858-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding btf__find_by_pattern_kind function that returns
array of BTF ids for given function name pattern.

Using libc's regex.h support for that.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/btf.c | 68 +++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/btf.h |  3 ++
 2 files changed, 71 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index b46760b93bb4..421dd6c1e44a 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
 /* Copyright (c) 2018 Facebook */
 
+#define _GNU_SOURCE
 #include <byteswap.h>
 #include <endian.h>
 #include <stdio.h>
@@ -16,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/btf.h>
 #include <gelf.h>
+#include <regex.h>
 #include "btf.h"
 #include "bpf.h"
 #include "libbpf.h"
@@ -711,6 +713,72 @@ __s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
 	return libbpf_err(-ENOENT);
 }
 
+static bool is_wildcard(char c)
+{
+	static const char *wildchars = "*?[|";
+
+	return strchr(wildchars, c);
+}
+
+int btf__find_by_pattern_kind(const struct btf *btf,
+			      const char *type_pattern, __u32 kind,
+			      __s32 **__ids)
+{
+	__u32 i, nr_types = btf__get_nr_types(btf);
+	__s32 *ids = NULL;
+	int cnt = 0, alloc = 0, ret;
+	regex_t regex;
+	char *pattern;
+
+	if (kind == BTF_KIND_UNKN || !strcmp(type_pattern, "void"))
+		return 0;
+
+	/* When the pattern does not start with wildcard, treat it as
+	 * if we'd want to match it from the beginning of the string.
+	 */
+	asprintf(&pattern, "%s%s",
+		 is_wildcard(type_pattern[0]) ? "^" : "",
+		 type_pattern);
+
+	ret = regcomp(&regex, pattern, REG_EXTENDED);
+	if (ret) {
+		pr_warn("failed to compile regex\n");
+		free(pattern);
+		return -EINVAL;
+	}
+
+	free(pattern);
+
+	for (i = 1; i <= nr_types; i++) {
+		const struct btf_type *t = btf__type_by_id(btf, i);
+		const char *name;
+		__s32 *p;
+
+		if (btf_kind(t) != kind)
+			continue;
+		name = btf__name_by_offset(btf, t->name_off);
+		if (name && regexec(&regex, name, 0, NULL, 0))
+			continue;
+		if (cnt == alloc) {
+			alloc = max(100, alloc * 3 / 2);
+			p = realloc(ids, alloc * sizeof(__u32));
+			if (!p) {
+				free(ids);
+				regfree(&regex);
+				return -ENOMEM;
+			}
+			ids = p;
+		}
+
+		ids[cnt] = i;
+		cnt++;
+	}
+
+	regfree(&regex);
+	*__ids = ids;
+	return cnt ?: -ENOENT;
+}
+
 static bool btf_is_modifiable(const struct btf *btf)
 {
 	return (void *)btf->hdr != btf->raw_data;
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index b54f1c3ebd57..036857aded94 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -371,6 +371,9 @@ btf_var_secinfos(const struct btf_type *t)
 	return (struct btf_var_secinfo *)(t + 1);
 }
 
+int btf__find_by_pattern_kind(const struct btf *btf,
+			      const char *type_pattern, __u32 kind,
+			      __s32 **__ids);
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
-- 
2.31.1

