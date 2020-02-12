Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C245F15A935
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 13:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgBLMbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 07:31:49 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28958 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725887AbgBLMbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 07:31:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581510708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DkuFJgCWon69tEItX6xkmXrSdlha2NBDOEqvvQkjjyw=;
        b=GqhNMcnQuGUHkJdaQdxa3AF2+52cpMsyHoPTBNWFLl39rZWubhxjUFxEP/+kJCoJSKocA2
        i/APKlLlr18A2/rk7+94CxCrLcOLtUW0VXjLQ3N6z0xiEhihzdZ42GwkBe7Byg/tgtuQAP
        WMC266RckfESC+dpkRvCeAeRjo3PB7g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-coPtXN7cN3qSXUd7zsoJqQ-1; Wed, 12 Feb 2020 07:31:46 -0500
X-MC-Unique: coPtXN7cN3qSXUd7zsoJqQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCD1F107ACCA;
        Wed, 12 Feb 2020 12:31:44 +0000 (UTC)
Received: from localhost.localdomain (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A65C27061;
        Wed, 12 Feb 2020 12:31:40 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: [PATCH bpf-next] libbpf: Add support for dynamic program attach target
Date:   Wed, 12 Feb 2020 12:31:22 +0000
Message-Id: <158151067149.71757.2222114135650741733.stgit@xdp-tutorial>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when you want to attach a trace program to a bpf program
the section name needs to match the tracepoint/function semantics.

However the addition of the bpf_program__set_attach_target() API
allows you to specify the tracepoint/function dynamically.

The call flow would look something like this:

  xdp_fd =3D bpf_prog_get_fd_by_id(id);
  trace_obj =3D bpf_object__open_file("func.o", NULL);
  prog =3D bpf_object__find_program_by_title(trace_obj,
                                           "fentry/myfunc");
  bpf_program__set_attach_target(prog, xdp_fd,
                                 "fentry/xdpfilt_blk_all");
  bpf_object__load(trace_obj)

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 tools/lib/bpf/libbpf.c   |   41 +++++++++++++++++++++++++++++++++++-----=
-
 tools/lib/bpf/libbpf.h   |    4 ++++
 tools/lib/bpf/libbpf.map |    1 +
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 514b1a524abb..2ce879c301bb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4933,15 +4933,16 @@ load_program(struct bpf_program *prog, struct bpf=
_insn *insns, int insns_cnt,
 	return ret;
 }
=20
-static int libbpf_find_attach_btf_id(struct bpf_program *prog);
+static int libbpf_find_attach_btf_id(struct bpf_program *prog,
+				     const char *name);
=20
 int bpf_program__load(struct bpf_program *prog, char *license, __u32 ker=
n_ver)
 {
 	int err =3D 0, fd, i, btf_id;
=20
-	if (prog->type =3D=3D BPF_PROG_TYPE_TRACING ||
-	    prog->type =3D=3D BPF_PROG_TYPE_EXT) {
-		btf_id =3D libbpf_find_attach_btf_id(prog);
+	if ((prog->type =3D=3D BPF_PROG_TYPE_TRACING ||
+	     prog->type =3D=3D BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
+		btf_id =3D libbpf_find_attach_btf_id(prog, NULL);
 		if (btf_id <=3D 0)
 			return btf_id;
 		prog->attach_btf_id =3D btf_id;
@@ -6202,6 +6203,31 @@ void bpf_program__set_expected_attach_type(struct =
bpf_program *prog,
 	prog->expected_attach_type =3D type;
 }
=20
+int bpf_program__set_attach_target(struct bpf_program *prog,
+				   int attach_prog_fd,
+				   const char *attach_func_name)
+{
+	__u32 org_attach_prog_fd;
+	int btf_id;
+
+	if (!prog || attach_prog_fd < 0 || !attach_func_name)
+		return -EINVAL;
+
+	org_attach_prog_fd =3D prog->attach_prog_fd;
+	prog->attach_prog_fd =3D attach_prog_fd;
+
+	btf_id =3D libbpf_find_attach_btf_id(prog,
+					   attach_func_name);
+
+	if (btf_id < 0) {
+		prog->attach_prog_fd =3D org_attach_prog_fd;
+		return btf_id;
+	}
+
+	prog->attach_btf_id =3D btf_id;
+	return 0;
+}
+
 #define BPF_PROG_SEC_IMPL(string, ptype, eatype, is_attachable, btf, aty=
pe) \
 	{ string, sizeof(string) - 1, ptype, eatype, is_attachable, btf, atype =
}
=20
@@ -6633,13 +6659,16 @@ static int libbpf_find_prog_btf_id(const char *na=
me, __u32 attach_prog_fd)
 	return err;
 }
=20
-static int libbpf_find_attach_btf_id(struct bpf_program *prog)
+static int libbpf_find_attach_btf_id(struct bpf_program *prog,
+				     const char *name)
 {
 	enum bpf_attach_type attach_type =3D prog->expected_attach_type;
 	__u32 attach_prog_fd =3D prog->attach_prog_fd;
-	const char *name =3D prog->section_name;
 	int i, err;
=20
+	if (!name)
+		name =3D prog->section_name;
+
 	if (!name)
 		return -EINVAL;
=20
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 3fe12c9d1f92..02fc58a21a7f 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -334,6 +334,10 @@ LIBBPF_API void
 bpf_program__set_expected_attach_type(struct bpf_program *prog,
 				      enum bpf_attach_type type);
=20
+LIBBPF_API int
+bpf_program__set_attach_target(struct bpf_program *prog, int attach_prog=
_fd,
+			       const char *attach_func_name);
+
 LIBBPF_API bool bpf_program__is_socket_filter(const struct bpf_program *=
prog);
 LIBBPF_API bool bpf_program__is_tracepoint(const struct bpf_program *pro=
g);
 LIBBPF_API bool bpf_program__is_raw_tracepoint(const struct bpf_program =
*prog);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b035122142bb..8aba5438a3f0 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -230,6 +230,7 @@ LIBBPF_0.0.7 {
 		bpf_program__name;
 		bpf_program__is_extension;
 		bpf_program__is_struct_ops;
+		bpf_program__set_attach_target;
 		bpf_program__set_extension;
 		bpf_program__set_struct_ops;
 		btf__align_of;

