Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BC7251FC5
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 21:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgHYTV7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Aug 2020 15:21:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46081 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726066AbgHYTV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 15:21:59 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-Fd_UtpRwOVqG0XeWDyUDmA-1; Tue, 25 Aug 2020 15:21:54 -0400
X-MC-Unique: Fd_UtpRwOVqG0XeWDyUDmA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69D1C800466;
        Tue, 25 Aug 2020 19:21:52 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC25519C4F;
        Tue, 25 Aug 2020 19:21:44 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH v12 bpf-next 04/14] bpf: Add elem_id pointer as argument to __btf_resolve_size
Date:   Tue, 25 Aug 2020 21:21:14 +0200
Message-Id: <20200825192124.710397-5-jolsa@kernel.org>
In-Reply-To: <20200825192124.710397-1-jolsa@kernel.org>
References: <20200825192124.710397-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the resolved type is array, make btf_resolve_size return also
ID of the elem type. It will be needed in following changes.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/btf.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 6ed4ecc60381..dbc70fedfb44 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1079,6 +1079,7 @@ static const struct resolve_vertex *env_stack_peak(struct btf_verifier_env *env)
  * *type_size: (x * y * sizeof(u32)).  Hence, *type_size always
  *             corresponds to the return type.
  * *elem_type: u32
+ * *elem_id: id of u32
  * *total_nelems: (x * y).  Hence, individual elem size is
  *                (*type_size / *total_nelems)
  *
@@ -1086,15 +1087,16 @@ static const struct resolve_vertex *env_stack_peak(struct btf_verifier_env *env)
  * return type: type "struct X"
  * *type_size: sizeof(struct X)
  * *elem_type: same as return type ("struct X")
+ * *elem_id: 0
  * *total_nelems: 1
  */
 static const struct btf_type *
 __btf_resolve_size(const struct btf *btf, const struct btf_type *type,
 		   u32 *type_size, const struct btf_type **elem_type,
-		   u32 *total_nelems)
+		   u32 *elem_id, u32 *total_nelems)
 {
 	const struct btf_type *array_type = NULL;
-	const struct btf_array *array;
+	const struct btf_array *array = NULL;
 	u32 i, size, nelems = 1;
 
 	for (i = 0; i < MAX_RESOLVE_DEPTH; i++) {
@@ -1146,6 +1148,8 @@ __btf_resolve_size(const struct btf *btf, const struct btf_type *type,
 		*total_nelems = nelems;
 	if (elem_type)
 		*elem_type = type;
+	if (elem_id)
+		*elem_id = array ? array->type : 0;
 
 	return array_type ? : type;
 }
@@ -3984,7 +3988,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		mname = __btf_name_by_offset(btf_vmlinux, member->name_off);
 
 		mtype = __btf_resolve_size(btf_vmlinux, mtype, &msize,
-					   &elem_type, &total_nelems);
+					   &elem_type, NULL, &total_nelems);
 		if (IS_ERR(mtype)) {
 			bpf_log(log, "field %s doesn't have size\n", mname);
 			return -EFAULT;
-- 
2.25.4

