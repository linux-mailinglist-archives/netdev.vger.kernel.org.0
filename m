Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D4E1FBD18
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 19:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgFPRgR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Jun 2020 13:36:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45134 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729113AbgFPRgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 13:36:16 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-hBi9glBYOq2alrJLW3Ucmw-1; Tue, 16 Jun 2020 13:36:02 -0400
X-MC-Unique: hBi9glBYOq2alrJLW3Ucmw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E12287342E;
        Tue, 16 Jun 2020 17:36:00 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.193.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67EF16A950;
        Tue, 16 Jun 2020 17:35:57 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Masanori Misono <m.misono760@gmail.com>
Subject: [PATCH] bpf: Allow small structs to be type of function argument
Date:   Tue, 16 Jun 2020 19:35:56 +0200
Message-Id: <20200616173556.2204073-1-jolsa@kernel.org>
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

This way we can have trampoline on function
that has arguments with types like:

  kuid_t uid
  kgid_t gid

which unwind into small structs like:

  typedef struct {
        uid_t val;
  } kuid_t;

  typedef struct {
        gid_t val;
  } kgid_t;

And we can use them in bpftrace like:
(assuming d_path changes are in)

  # bpftrace -e 'lsm:path_chown { printf("uid %d, gid %d\n", args->uid, args->gid) }'
  Attaching 1 probe...
  uid 0, gid 0
  uid 1000, gid 1000
  ...

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/btf.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 58c9af1d4808..f8fee5833684 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -362,6 +362,14 @@ static bool btf_type_is_struct(const struct btf_type *t)
 	return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
 }
 
+/* type is struct and its size is within 8 bytes
+ * and it can be value of function argument
+ */
+static bool btf_type_is_struct_arg(const struct btf_type *t)
+{
+	return btf_type_is_struct(t) && (t->size <= sizeof(u64));
+}
+
 static bool __btf_type_is_struct(const struct btf_type *t)
 {
 	return BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT;
@@ -3768,7 +3776,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	/* skip modifiers */
 	while (btf_type_is_modifier(t))
 		t = btf_type_by_id(btf, t->type);
-	if (btf_type_is_int(t) || btf_type_is_enum(t))
+	if (btf_type_is_int(t) || btf_type_is_enum(t) || btf_type_is_struct_arg(t))
 		/* accessing a scalar */
 		return true;
 	if (!btf_type_is_ptr(t)) {
@@ -4161,6 +4169,8 @@ static int __get_type_size(struct btf *btf, u32 btf_id,
 		return sizeof(void *);
 	if (btf_type_is_int(t) || btf_type_is_enum(t))
 		return t->size;
+	if (btf_type_is_struct_arg(t))
+		return t->size;
 	*bad_type = t;
 	return -EINVAL;
 }
-- 
2.25.4

