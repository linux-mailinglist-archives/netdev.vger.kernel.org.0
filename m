Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 436D8161090
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 12:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgBQLCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 06:02:30 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58611 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728516AbgBQLCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 06:02:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581937349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jKUCIeprTRWb1KGKCWqYWiN5G08eSGkYzc2Y5TKQIOA=;
        b=LsFOb7FgCxYJaQqxGl+VIUNz3KDiKYKIMYJpaFGAMJTZO6+WztIbJK25oQeiI8YAWwa0SG
        lwILSCLQ5g/dSRSXuLvxUROwla4dWgblQNZWxHsT0nyg1zgyGUjggA70bNXQN+Bk+xF1qG
        DIKOuJ+DH8p93eafoOX+mnUBKG4ZLw8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-ZqqOYk9PM5CAWLJpsI-KeA-1; Mon, 17 Feb 2020 06:02:24 -0500
X-MC-Unique: ZqqOYk9PM5CAWLJpsI-KeA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A3A2DB6D;
        Mon, 17 Feb 2020 11:02:22 +0000 (UTC)
Received: from localhost.localdomain (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9AAB9053C;
        Mon, 17 Feb 2020 11:02:17 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: [PATCH bpf-next v3] libbpf: Add support for dynamic program attach target
Date:   Mon, 17 Feb 2020 11:01:49 +0000
Message-Id: <158193725120.96608.9449808053785640511.stgit@xdp-tutorial>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
v1 -> v2: Remove requirement for attach type hint in API
v2 -> v3: Moved common warning to __find_vmlinux_btf_id, requested by And=
rii
          Updated the xdp_bpf2bpf test to use this new API

 tools/lib/bpf/libbpf.c                             |   34 ++++++++++++++=
++++--
 tools/lib/bpf/libbpf.h                             |    4 ++
 tools/lib/bpf/libbpf.map                           |    1 +
 .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   16 ++++++++-
 .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |    4 +-
 5 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 514b1a524abb..0c25d78fb5d8 100644
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
@@ -6583,6 +6583,9 @@ static inline int __find_vmlinux_btf_id(struct btf =
*btf, const char *name,
 	else
 		err =3D btf__find_by_name_kind(btf, name, BTF_KIND_FUNC);
=20
+	if (err <=3D 0)
+		pr_warn("%s is not found in vmlinux BTF\n", name);
+
 	return err;
 }
=20
@@ -6655,8 +6658,6 @@ static int libbpf_find_attach_btf_id(struct bpf_pro=
gram *prog)
 			err =3D __find_vmlinux_btf_id(prog->obj->btf_vmlinux,
 						    name + section_defs[i].len,
 						    attach_type);
-		if (err <=3D 0)
-			pr_warn("%s is not found in vmlinux BTF\n", name);
 		return err;
 	}
 	pr_warn("failed to identify btf_id based on ELF section name '%s'\n", n=
ame);
@@ -8132,6 +8133,31 @@ void bpf_program__bpil_offs_to_addr(struct bpf_pro=
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
+	if (btf_id <=3D 0)
+		return btf_id;
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
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c b/tools=
/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
index 6b56bdc73ebc..513fdbf02b81 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
@@ -14,7 +14,7 @@ void test_xdp_bpf2bpf(void)
 	struct test_xdp *pkt_skel =3D NULL;
 	struct test_xdp_bpf2bpf *ftrace_skel =3D NULL;
 	struct vip key4 =3D {.protocol =3D 6, .family =3D AF_INET};
-	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts);
+	struct bpf_program *prog;
=20
 	/* Load XDP program to introspect */
 	pkt_skel =3D test_xdp__open_and_load();
@@ -27,11 +27,21 @@ void test_xdp_bpf2bpf(void)
 	bpf_map_update_elem(map_fd, &key4, &value4, 0);
=20
 	/* Load trace program */
-	opts.attach_prog_fd =3D pkt_fd,
-	ftrace_skel =3D test_xdp_bpf2bpf__open_opts(&opts);
+	ftrace_skel =3D test_xdp_bpf2bpf__open();
 	if (CHECK(!ftrace_skel, "__open", "ftrace skeleton failed\n"))
 		goto out;
=20
+	/* Demonstrate the bpf_program__set_attach_target() API rather than
+	 * the load with options, i.e. opts.attach_prog_fd.
+	 */
+	prog =3D *ftrace_skel->skeleton->progs[0].prog;
+	bpf_program__set_expected_attach_type(prog, BPF_TRACE_FENTRY);
+	bpf_program__set_attach_target(prog, pkt_fd, "_xdp_tx_iptunnel");
+
+	prog =3D *ftrace_skel->skeleton->progs[1].prog;
+	bpf_program__set_expected_attach_type(prog, BPF_TRACE_FEXIT);
+	bpf_program__set_attach_target(prog, pkt_fd, "_xdp_tx_iptunnel");
+
 	err =3D test_xdp_bpf2bpf__load(ftrace_skel);
 	if (CHECK(err, "__load", "ftrace skeleton failed\n"))
 		goto out;
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c b/tools=
/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
index cb8a04ab7a78..b840fc9e3ed5 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
@@ -28,7 +28,7 @@ struct xdp_buff {
 } __attribute__((preserve_access_index));
=20
 __u64 test_result_fentry =3D 0;
-SEC("fentry/_xdp_tx_iptunnel")
+SEC("fentry/FUNC")
 int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
 {
 	test_result_fentry =3D xdp->rxq->dev->ifindex;
@@ -36,7 +36,7 @@ int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
 }
=20
 __u64 test_result_fexit =3D 0;
-SEC("fexit/_xdp_tx_iptunnel")
+SEC("fexit/FUNC")
 int BPF_PROG(trace_on_exit, struct xdp_buff *xdp, int ret)
 {
 	test_result_fexit =3D ret;

