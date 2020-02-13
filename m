Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B44A15C0F5
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 16:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgBMPE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:04:58 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32702 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726937AbgBMPE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 10:04:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581606296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HLe357ysOGQZCr5dc1Y3s+U/g5TdgVSZKlWqF02Wz2I=;
        b=A+r2O03CUVU55vHyqAZfSxrwnydm4vJssgQFKRk9Gl/J3Ob8koV2IV8HU97bJKd2swWUHH
        d+gDzb16d9ZhfCTY2ET7QcWIo0tFvMLPs3CFCG3KEtx+ly+1CXeN4U8Sf9EEeH5FAdg+kr
        1XozxODhfOi1cuILQytNeiw/OB0Yaak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-Z9ez1DWpONSa0Q5chqR47Q-1; Thu, 13 Feb 2020 10:04:52 -0500
X-MC-Unique: Z9ez1DWpONSa0Q5chqR47Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A076E13F8;
        Thu, 13 Feb 2020 15:04:50 +0000 (UTC)
Received: from localhost.localdomain (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2FF119C70;
        Thu, 13 Feb 2020 15:04:46 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: [PATCH bpf-next v2] libbpf: Add support for dynamic program attach target
Date:   Thu, 13 Feb 2020 15:04:25 +0000
Message-Id: <158160616195.80320.5636088335810242866.stgit@xdp-tutorial>
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
  bpf_program__set_expected_attach_type(prog, BPF_TRACE_FENTRY);
  bpf_program__set_attach_target(prog, xdp_fd,
                                 "xdpfilt_blk_all");
  bpf_object__load(trace_obj)

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
v1 -> v2: Remove requirement for attach type name in API

 tools/lib/bpf/libbpf.c   |   33 +++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf.h   |    4 ++++
 tools/lib/bpf/libbpf.map |    1 +
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 514b1a524abb..9b8cab995580 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4939,8 +4939,8 @@ int bpf_program__load(struct bpf_program *prog, cha=
r *license, __u32 kern_ver)
 {
 	int err =3D 0, fd, i, btf_id;
=20
-	if (prog->type =3D=3D BPF_PROG_TYPE_TRACING ||
-	    prog->type =3D=3D BPF_PROG_TYPE_EXT) {
+	if ((prog->type =3D=3D BPF_PROG_TYPE_TRACING ||
+	     prog->type =3D=3D BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
 		btf_id =3D libbpf_find_attach_btf_id(prog);
 		if (btf_id <=3D 0)
 			return btf_id;
@@ -8132,6 +8132,35 @@ void bpf_program__bpil_offs_to_addr(struct bpf_pro=
g_info_linear *info_linear)
 	}
 }
=20
+int bpf_program__set_attach_target(struct bpf_program *prog,
+				   int attach_prog_fd,
+				   const char *attach_func_name)
+{
+	int btf_id;
+
+	if (!prog || attach_prog_fd < 0 || !attach_func_name)
+		return -EINVAL;
+
+	if (attach_prog_fd)
+		btf_id =3D libbpf_find_prog_btf_id(attach_func_name,
+						 attach_prog_fd);
+	else
+		btf_id =3D __find_vmlinux_btf_id(prog->obj->btf_vmlinux,
+					       attach_func_name,
+					       prog->expected_attach_type);
+
+	if (btf_id <=3D 0) {
+		if (!attach_prog_fd)
+			pr_warn("%s is not found in vmlinux BTF\n",
+				attach_func_name);
+		return btf_id;
+	}
+
+	prog->attach_btf_id =3D btf_id;
+	prog->attach_prog_fd =3D attach_prog_fd;
+	return 0;
+}
+
 int parse_cpu_mask_str(const char *s, bool **mask, int *mask_sz)
 {
 	int err =3D 0, n, len, start, end =3D -1;
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

