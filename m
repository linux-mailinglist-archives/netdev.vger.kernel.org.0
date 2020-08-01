Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696642353A9
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 19:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgHAREG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 1 Aug 2020 13:04:06 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36888 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727977AbgHAREF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 13:04:05 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-RhoaVFHcPL23zhUemcKyiQ-1; Sat, 01 Aug 2020 13:03:57 -0400
X-MC-Unique: RhoaVFHcPL23zhUemcKyiQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA5D7107ACCA;
        Sat,  1 Aug 2020 17:03:54 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6EFF7C116;
        Sat,  1 Aug 2020 17:03:51 +0000 (UTC)
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
Subject: [PATCH v9 bpf-next 08/14] bpf: Add btf_struct_ids_match function
Date:   Sat,  1 Aug 2020 19:03:16 +0200
Message-Id: <20200801170322.75218-9-jolsa@kernel.org>
In-Reply-To: <20200801170322.75218-1-jolsa@kernel.org>
References: <20200801170322.75218-1-jolsa@kernel.org>
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
 kernel/bpf/verifier.c | 20 +++++++++++++-------
 3 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 40c5e206ecf2..8206d5e324be 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1337,6 +1337,8 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		      const struct btf_type *t, int off, int size,
 		      enum bpf_access_type atype,
 		      u32 *next_btf_id);
+bool btf_struct_ids_match(struct bpf_verifier_log *log,
+			  int off, u32 id, u32 need_type_id);
 int btf_resolve_helper_id(struct bpf_verifier_log *log,
 			  const struct bpf_func_proto *fn, int);
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 7bacc2f56061..ba05b15ad599 100644
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
index b6ccfce3bf4c..bb6ca19f282d 100644
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
-			if (reg->btf_id != meta->btf_id) {
-				verbose(env, "Helper has type %s got %s in R%d\n",
-					kernel_type_name(meta->btf_id),
-					kernel_type_name(reg->btf_id), regno);
-
-				return -EACCES;
+			if (reg->btf_id != meta->btf_id || reg->off) {
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

