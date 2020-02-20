Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B68165EBA
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 14:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgBTN1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 08:27:31 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50516 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726959AbgBTN1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 08:27:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582205249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RzKpJW68gmeKH6pJZ0P2aLs3ozr7hD4rnZlMcjop9TI=;
        b=XVHCx2xPrGaPFR50RzfOm5RkVbP3EtDTEpZG3fSei5ksRv5CImX+e4MJiV0ig1UzO10AtN
        hkz+N5Mxh+/NBk7j2BOySST7TChvB+SrAdu9hjn/7IkJOZ15ZqPB2YmKUB5/jLb/D2BYIe
        pBWdhUyaHuFgxN68yG4Fy/LHOIlzc+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-yGpSIfMNPRanWtLYT7dP4g-1; Thu, 20 Feb 2020 08:27:26 -0500
X-MC-Unique: yGpSIfMNPRanWtLYT7dP4g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94CBB108442D;
        Thu, 20 Feb 2020 13:27:24 +0000 (UTC)
Received: from localhost.localdomain (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23647863A5;
        Thu, 20 Feb 2020 13:27:21 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: [PATCH bpf-next v5 3/3] selftests/bpf: update xdp_bpf2bpf test to use new set_attach_target API
Date:   Thu, 20 Feb 2020 13:26:45 +0000
Message-Id: <158220520562.127661.14289388017034825841.stgit@xdp-tutorial>
In-Reply-To: <158220517358.127661.1514720920408191215.stgit@xdp-tutorial>
References: <158220517358.127661.1514720920408191215.stgit@xdp-tutorial>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new bpf_program__set_attach_target() API in the xdp_bpf2bpf
selftest so it can be referenced as an example on how to use it.

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   16 +++++++++++++-=
--
 .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |    4 ++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c b/tools=
/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
index 6b56bdc73ebc..4ba011031d4c 100644
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
+	prog =3D ftrace_skel->progs.trace_on_entry;
+	bpf_program__set_expected_attach_type(prog, BPF_TRACE_FENTRY);
+	bpf_program__set_attach_target(prog, pkt_fd, "_xdp_tx_iptunnel");
+
+	prog =3D ftrace_skel->progs.trace_on_exit;
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

