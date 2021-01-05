Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB0E2EB65E
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbhAEXnV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Jan 2021 18:43:21 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:49741 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbhAEXnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 18:43:21 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-t27V7puaOSqHWJ6PZJcBLw-1; Tue, 05 Jan 2021 18:42:25 -0500
X-MC-Unique: t27V7puaOSqHWJ6PZJcBLw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C279803621;
        Tue,  5 Jan 2021 23:42:23 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.193.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1AD06F812;
        Tue,  5 Jan 2021 23:42:20 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCHv2 bpf-next] tools/resolve_btfids: Warn when having multiple IDs for single type
Date:   Wed,  6 Jan 2021 00:42:19 +0100
Message-Id: <20210105234219.970039-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel image can contain multiple types (structs/unions)
with the same name. This causes distinct type hierarchies in
BTF data and makes resolve_btfids fail with error like:

  BTFIDS  vmlinux
FAILED unresolved symbol udp6_sock

as reported by Qais Yousef [1].

This change adds warning when multiple types of the same name
are detected:

  BTFIDS  vmlinux
WARN: multiple IDs found for 'file': 526, 113351 - using 526
WARN: multiple IDs found for 'sk_buff': 2744, 113958 - using 2744

We keep the lower ID for the given type instance and let the
build continue.

Also changing the 'nr' variable name to 'nr_types' to avoid confusion.

[1] https://lore.kernel.org/lkml/20201229151352.6hzmjvu3qh6p2qgg@e107158-lin/
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
v2 changes:
  - changed the warning message [Alexei]
  - renamed 'nr' to 'nr_types' [Andrii]

 tools/bpf/resolve_btfids/main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index e3ea569ee125..7409d7860aa6 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -139,6 +139,8 @@ int eprintf(int level, int var, const char *fmt, ...)
 #define pr_debug2(fmt, ...) pr_debugN(2, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_err(fmt, ...) \
 	eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info(fmt, ...) \
+	eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
 
 static bool is_btf_id(const char *name)
 {
@@ -472,7 +474,7 @@ static int symbols_resolve(struct object *obj)
 	int nr_funcs    = obj->nr_funcs;
 	int err, type_id;
 	struct btf *btf;
-	__u32 nr;
+	__u32 nr_types;
 
 	btf = btf__parse(obj->btf ?: obj->path, NULL);
 	err = libbpf_get_error(btf);
@@ -483,12 +485,12 @@ static int symbols_resolve(struct object *obj)
 	}
 
 	err = -1;
-	nr  = btf__get_nr_types(btf);
+	nr_types = btf__get_nr_types(btf);
 
 	/*
 	 * Iterate all the BTF types and search for collected symbol IDs.
 	 */
-	for (type_id = 1; type_id <= nr; type_id++) {
+	for (type_id = 1; type_id <= nr_types; type_id++) {
 		const struct btf_type *type;
 		struct rb_root *root;
 		struct btf_id *id;
@@ -526,8 +528,13 @@ static int symbols_resolve(struct object *obj)
 
 		id = btf_id__find(root, str);
 		if (id) {
-			id->id = type_id;
-			(*nr)--;
+			if (id->id) {
+				pr_info("WARN: multiple IDs found for '%s': %d, %d - using %d\n",
+					str, id->id, type_id, id->id);
+			} else {
+				id->id = type_id;
+				(*nr)--;
+			}
 		}
 	}
 
-- 
2.26.2

