Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4741722A124
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732931AbgGVVNC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Jul 2020 17:13:02 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56052 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732919AbgGVVNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 17:13:01 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-NJ2TPhdBO0KIYlch7ka9RA-1; Wed, 22 Jul 2020 17:12:54 -0400
X-MC-Unique: NJ2TPhdBO0KIYlch7ka9RA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D34C98015F3;
        Wed, 22 Jul 2020 21:12:52 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.194.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEA0919C4F;
        Wed, 22 Jul 2020 21:12:49 +0000 (UTC)
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
Subject: [PATCH v8 bpf-next 07/13] bpf: Add btf_struct_ids_match function
Date:   Wed, 22 Jul 2020 23:12:17 +0200
Message-Id: <20200722211223.1055107-8-jolsa@kernel.org>
In-Reply-To: <20200722211223.1055107-1-jolsa@kernel.org>
References: <20200722211223.1055107-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
 kernel/bpf/btf.c      | 29 +++++++++++++++++++++++++++++
 kernel/bpf/verifier.c | 18 ++++++++++++------
 3 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index bae557ff2da8..c981e258fed3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1306,6 +1306,8 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		      const struct btf_type *t, int off, int size,
 		      enum bpf_access_type atype,
 		      u32 *next_btf_id);
+bool btf_struct_ids_match(struct bpf_verifier_log *log,
+			  int off, u32 id, u32 mid);
 int btf_resolve_helper_id(struct bpf_verifier_log *log,
 			  const struct bpf_func_proto *fn, int);
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 1ab5fd5bf992..562d4453fad3 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4140,6 +4140,35 @@ int btf_struct_access(struct bpf_verifier_log *log,
 	return -EINVAL;
 }
 
+bool btf_struct_ids_match(struct bpf_verifier_log *log,
+			  int off, u32 id, u32 mid)
+{
+	const struct btf_type *type;
+	u32 nid;
+	int err;
+
+	do {
+		type = btf_type_by_id(btf_vmlinux, id);
+		if (!type)
+			return false;
+		err = btf_struct_walk(log, type, off, 1, &nid);
+		if (err < 0)
+			return false;
+
+		/* We found nested struct object. If it matches
+		 * the requested ID, we're done. Otherwise let's
+		 * continue the search with offset 0 in the new
+		 * type.
+		 */
+		if (err == walk_struct && mid == nid)
+			return true;
+		off = 0;
+		id = nid;
+	} while (err == walk_struct);
+
+	return false;
+}
+
 int btf_resolve_helper_id(struct bpf_verifier_log *log,
 			  const struct bpf_func_proto *fn, int arg)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9a6703bc3f36..39922fa07154 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3887,16 +3887,21 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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
@@ -3904,7 +3909,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 
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

