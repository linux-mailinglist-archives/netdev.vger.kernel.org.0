Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3703F35DE72
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243321AbhDMMQP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Apr 2021 08:16:15 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:34622 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231329AbhDMMQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:16:13 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-KBgnrNAFMa2TkXCKtwtB8g-1; Tue, 13 Apr 2021 08:15:49 -0400
X-MC-Unique: KBgnrNAFMa2TkXCKtwtB8g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C27B8839A7F;
        Tue, 13 Apr 2021 12:15:34 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.196.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9FD310023B0;
        Tue, 13 Apr 2021 12:15:31 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCHv2 RFC bpf-next 4/7] libbpf: Add btf__find_by_pattern_kind function
Date:   Tue, 13 Apr 2021 14:15:13 +0200
Message-Id: <20210413121516.1467989-5-jolsa@kernel.org>
In-Reply-To: <20210413121516.1467989-1-jolsa@kernel.org>
References: <20210413121516.1467989-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index d30e67e7e1e5..e193713b9d56 100644
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
@@ -712,6 +714,72 @@ __s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
 	return -ENOENT;
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
2.30.2

