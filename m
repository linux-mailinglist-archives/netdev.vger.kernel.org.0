Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4B323EAC3
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 11:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgHGJqm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 Aug 2020 05:46:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47217 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728114AbgHGJqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 05:46:40 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-9sfuHBpaOvavWScQXvFVlg-1; Fri, 07 Aug 2020 05:46:38 -0400
X-MC-Unique: 9sfuHBpaOvavWScQXvFVlg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E12E1800478;
        Fri,  7 Aug 2020 09:46:35 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.194.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C69469328;
        Fri,  7 Aug 2020 09:46:31 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v10 bpf-next 08/14] bpf: Add btf_struct_ids_match function
Date:   Fri,  7 Aug 2020 11:45:53 +0200
Message-Id: <20200807094559.571260-9-jolsa@kernel.org>
In-Reply-To: <20200807094559.571260-1-jolsa@kernel.org>
References: <20200807094559.571260-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding btf_struct_ids_match function to check if given address provided
by BTF object + offset is also address of another nested BTF object.

This allows to pass an argument to helper, which is defined via parent
BTF object + offset, like for bpf_d_path (added in following changes):

  SEC("fentry/filp_close")
  int BPF_PROG(prog_close, struct file *file, void *id)
  {
    ...
    ret = bpf_d_path(&file->f_path, ...

The first bpf_d_path argument is hold by verifier as BTF file object
plus offset of f_path member.

The btf_struct_ids_match function will walk the struct file object and
check if there's nested struct path object on the given offset.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h   |  2 ++
 kernel/bpf/btf.c      | 31 +++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c | 18 ++++++++++++------
 3 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cef4ef0d2b4e..9fead3baa31c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1338,6 +1338,8 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		      const struct btf_type *t, int off, int size,
 		      enum bpf_access_type atype,
 		      u32 *next_btf_id);
+bool btf_struct_ids_match(struct bpf_verifier_log *log,
+			  int off, u32 id, u32 need_type_id);
 int btf_resolve_helper_id(struct bpf_verifier_log *log,
 			  const struct bpf_func_proto *fn, int);
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index d8d64201c4e0..df966acaaeb1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4160,6 +4160,37 @@ int btf_struct_access(struct bpf_verifier_log *log,
 	return -EINVAL;
 }
 
+bool btf_struct_ids_match(struct bpf_verifier_log *log,
+			  int off, u32 id, u32 need_type_id)
+{
+	const struct btf_type *type;
+	int err;
+
+	/* Are we already done? */
+	if (need_type_id == id && off == 0)
+		return true;
+
+again:
+	type = btf_type_by_id(btf_vmlinux, id);
+	if (!type)
+		return false;
+	err = btf_struct_walk(log, type, off, 1, &id);
+	if (err != WALK_STRUCT)
+		return false;
+
+	/* We found nested struct object. If it matches
+	 * the requested ID, we're done. Otherwise let's
+	 * continue the search with offset 0 in the new
+	 * type.
+	 */
+	if (need_type_id != id) {
+		off = 0;
+		goto again;
+	}
+
+	return true;
+}
+
 int btf_resolve_helper_id(struct bpf_verifier_log *log,
 			  const struct bpf_func_proto *fn, int arg)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b6ccfce3bf4c..041d151be15b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3960,16 +3960,21 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 				goto err_type;
 		}
 	} else if (arg_type == ARG_PTR_TO_BTF_ID) {
+		bool ids_match = false;
+
 		expected_type = PTR_TO_BTF_ID;
 		if (type != expected_type)
 			goto err_type;
 		if (!fn->check_btf_id) {
 			if (reg->btf_id != meta->btf_id) {
-				verbose(env, "Helper has type %s got %s in R%d\n",
-					kernel_type_name(meta->btf_id),
-					kernel_type_name(reg->btf_id), regno);
-
-				return -EACCES;
+				ids_match = btf_struct_ids_match(&env->log, reg->off, reg->btf_id,
+								 meta->btf_id);
+				if (!ids_match) {
+					verbose(env, "Helper has type %s got %s in R%d\n",
+						kernel_type_name(meta->btf_id),
+						kernel_type_name(reg->btf_id), regno);
+					return -EACCES;
+				}
 			}
 		} else if (!fn->check_btf_id(reg->btf_id, arg)) {
 			verbose(env, "Helper does not support %s in R%d\n",
@@ -3977,7 +3982,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 
 			return -EACCES;
 		}
-		if (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off) {
+		if (!ids_match &&
+		    (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off)) {
 			verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
 				regno);
 			return -EACCES;
-- 
2.25.4

