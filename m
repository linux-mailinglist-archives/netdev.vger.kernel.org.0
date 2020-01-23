Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59ED3146E1B
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 17:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAWQPV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Jan 2020 11:15:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29983 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728900AbgAWQPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 11:15:20 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-2_-BmaSIPwWwU-gy9_OI8w-1; Thu, 23 Jan 2020 11:15:15 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAE281005513;
        Thu, 23 Jan 2020 16:15:13 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D46685750;
        Thu, 23 Jan 2020 16:15:11 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 1/3] bpf: Allow BTF ctx access for string pointers
Date:   Thu, 23 Jan 2020 17:15:06 +0100
Message-Id: <20200123161508.915203-2-jolsa@kernel.org>
In-Reply-To: <20200123161508.915203-1-jolsa@kernel.org>
References: <20200123161508.915203-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 2_-BmaSIPwWwU-gy9_OI8w-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When accessing the context we allow access to arguments with
scalar type and pointer to struct. But we deny access for
pointer to scalar type, which is the case for many functions.

Alexei suggested to take conservative approach and allow
currently only string pointer access, which is the case
for most functions now:

> Compilers have a long history special casing 'char *'. In particular signed
> char because it's a pointer to null terminated string. I think it's still a
> special pointer from pointer aliasing point of view. I think the verifier can
> treat it as scalar here too. In the future the verifier will get smarter and
> will recognize it as PTR_TO_NULL_STRING while 'u8 *', 'u32 *' will be
> PTR_TO_BTF_ID. I think it will solve this particular issue. I like conservative
> approach to the verifier improvements: start with strict checking and relax it
> on case-by-case. Instead of accepting wide range of cases and cause potential
> compatibility issues.

Adding check if the pointer is to string type and allow access to it.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/btf.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 32963b6d5a9c..b7c1660fb594 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3669,6 +3669,19 @@ struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
 	}
 }
 
+static bool is_string_ptr(struct btf *btf, const struct btf_type *t)
+{
+	/* t comes in already as a pointer */
+	t = btf_type_by_id(btf, t->type);
+
+	/* allow const */
+	if (BTF_INFO_KIND(t->info) == BTF_KIND_CONST)
+		t = btf_type_by_id(btf, t->type);
+
+	/* char, signed char, unsigned char */
+	return btf_type_is_int(t) && t->size == 1;
+}
+
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info)
@@ -3735,6 +3748,9 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		 */
 		return true;
 
+	if (is_string_ptr(btf, t))
+		return true;
+
 	/* this is a pointer to another type */
 	info->reg_type = PTR_TO_BTF_ID;
 
-- 
2.24.1

