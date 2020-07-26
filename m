Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFBE22DEF3
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 14:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgGZMZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 08:25:04 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37021 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726072AbgGZMZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 08:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595766300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LE5NbR2GAK1D1bhpMjEyL6dMr4KtOQ/jHc/PViRIYjk=;
        b=NO7sOR9TtChxhmk74AM32PQhbTko8wwuyYZrjypy7LaGs0pp5wOc8yBLBp+Tagl4gSOSTo
        ykNkzaP7VtnaGsr5wG0zbkLxaQVc65raLGeH8s6mQ0vn7i80QsiMUCeLSL2I/KhrGjrWb9
        0aMztiSfMpHq/y5VR0Y6ElfO+3y3quk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-gR8ZqAdePo27sbfY7tUrug-1; Sun, 26 Jul 2020 08:24:58 -0400
X-MC-Unique: gR8ZqAdePo27sbfY7tUrug-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A92259;
        Sun, 26 Jul 2020 12:24:57 +0000 (UTC)
Received: from krava (unknown [10.40.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54ECC5D9DC;
        Sun, 26 Jul 2020 12:24:51 +0000 (UTC)
Date:   Sun, 26 Jul 2020 14:24:50 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        toke@redhat.com
Subject: Re: fentry/fexit attach to EXT type XDP program does not work
Message-ID: <20200726122450.GC1175442@krava>
References: <159162546868.10791.12432342618156330247.stgit@ebuild>
 <42b0c8d3-e855-7531-b01c-a05414360aff@fb.com>
 <88B08061-F85B-454C-9E9D-234154B9F000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <88B08061-F85B-454C-9E9D-234154B9F000@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 10:52:34AM +0200, Eelco Chaudron wrote:

SNIP

> > >    libbpf: failed to load object 'test_xdp_bpf2bpf'
> > >    libbpf: failed to load BPF skeleton 'test_xdp_bpf2bpf': -4007
> > >    test_xdp_fentry_ext:FAIL:__load ftrace skeleton failed
> > >    #91 xdp_fentry_ext:FAIL
> > >    Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
> > > 
> > > Any idea what could be the case here? The same fentry/fexit attach
> > > code works fine in the xdp_bpf2bpf.c tests case.
> 
> <SNIP>
> > 
> > I think this is not supported now. That is, you cannot attach a fentry
> > trace
> > to the EXT program. The current implementation for fentry program simply
> > trying to find and match the signature of freplace program which by
> > default
> > is a pointer to void.
> > 
> > It is doable in that in kernel we could recognize to-be-attached program
> > is
> > a freplace and further trace down to find the real signature. The
> > related
> > kernel function is btf_get_prog_ctx_type(). You can try to implement by
> > yourself
> > or I can have a patch for this once bpf-next opens.
> 
> I’m not familiar with this area of the code, so if you could prepare a patch
> that would nice.
> You can also send it to me before bpf-next opens and I can verify it, and
> clean up the self-test so it can be included as well.
> 

hi,
it seems that you cannot exten fentry/fexit programs,
but it's possible to attach fentry/fexit to ext program.

   /* Program extensions can extend all program types
    * except fentry/fexit. The reason is the following.
    * The fentry/fexit programs are used for performance
    * analysis, stats and can be attached to any program
    * type except themselves. When extension program is
    * replacing XDP function it is necessary to allow
    * performance analysis of all functions. Both original
    * XDP program and its program extension. Hence
    * attaching fentry/fexit to BPF_PROG_TYPE_EXT is
    * allowed. If extending of fentry/fexit was allowed it
    * would be possible to create long call chain
    * fentry->extension->fentry->extension beyond
    * reasonable stack size. Hence extending fentry is not
    * allowed.
    */

I changed fexit_bpf2bpf.c test just to do a quick check
and it seems to work:

  # echo > /sys/kernel/debug/tracing/trace
  #  ./test_progs -t fexit_bpf2bpf 
  #25 fexit_bpf2bpf:OK
  Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
  # cat /sys/kernel/debug/tracing/trace | tail -2
           <...>-75365 [012] d... 313932.416780: bpf_trace_printk: ENTRY val 123
           <...>-75365 [012] d... 313932.416784: bpf_trace_printk: EXIT  val 123, ret 1

jirka


---
diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index a895bfed55db..4b6c26ac2362 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -17,6 +17,7 @@ static void test_fexit_bpf2bpf_common(const char *obj_file,
 	struct bpf_map *data_map;
 	const int zero = 0;
 	u64 *result = NULL;
+	int ext_fd;
 
 	err = bpf_prog_load(target_obj_file, BPF_PROG_TYPE_UNSPEC,
 			    &pkt_obj, &pkt_fd);
@@ -51,11 +52,50 @@ static void test_fexit_bpf2bpf_common(const char *obj_file,
 		link[i] = bpf_program__attach_trace(prog[i]);
 		if (CHECK(IS_ERR(link[i]), "attach_trace", "failed to link\n"))
 			goto close_prog;
+
+		if (!strcmp(prog_name[i], "freplace/get_constant"))
+			ext_fd = bpf_program__fd(prog[i]);
 	}
 
 	if (!run_prog)
 		goto close_prog;
 
+{
+	struct bpf_object *obj_trace = NULL;
+	struct bpf_program *prog_trace = NULL;
+	struct bpf_link *link_trace = NULL;
+
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts_trace,
+			    .attach_prog_fd = ext_fd,
+			   );
+
+	obj_trace = bpf_object__open_file("trace_ext.o", &opts_trace);
+	if (CHECK(IS_ERR_OR_NULL(obj_trace), "obj_open",
+		  "failed to open %s: %ld\n", obj_file,
+		  PTR_ERR(obj_trace)))
+		goto close_prog;
+
+	err = bpf_object__load(obj_trace);
+	if (CHECK(err, "obj_load", "err %d\n", err))
+		goto close_prog;
+
+	prog_trace = bpf_object__find_program_by_title(obj_trace, "fexit/new_get_constant");
+	if (CHECK(!prog_trace, "find_prog", "prog %s not found\n", "fexit/new_get_constant"))
+		goto close_prog;
+
+	link_trace = bpf_program__attach_trace(prog_trace);
+	if (CHECK(IS_ERR(link_trace), "attach_trace", "failed to link\n"))
+		goto close_prog;
+
+	prog_trace = bpf_object__find_program_by_title(obj_trace, "fentry/new_get_constant");
+	if (CHECK(!prog_trace, "find_prog", "prog %s not found\n", "fentry/new_get_constant"))
+		goto close_prog;
+
+	link_trace = bpf_program__attach_trace(prog_trace);
+	if (CHECK(IS_ERR(link_trace), "attach_trace", "failed to link\n"))
+		goto close_prog;
+}
+
 	data_map = bpf_object__find_map_by_name(obj, "fexit_bp.bss");
 	if (CHECK(!data_map, "find_data_map", "data map not found\n"))
 		goto close_prog;
@@ -88,6 +128,7 @@ static void test_fexit_bpf2bpf_common(const char *obj_file,
 	free(result);
 }
 
+#if 0
 static void test_target_no_callees(void)
 {
 	const char *prog_name[] = {
@@ -112,6 +153,7 @@ static void test_target_yes_callees(void)
 				  ARRAY_SIZE(prog_name),
 				  prog_name, true);
 }
+#endif
 
 static void test_func_replace(void)
 {
@@ -130,6 +172,7 @@ static void test_func_replace(void)
 				  prog_name, true);
 }
 
+#if 0
 static void test_func_replace_verify(void)
 {
 	const char *prog_name[] = {
@@ -140,11 +183,9 @@ static void test_func_replace_verify(void)
 				  ARRAY_SIZE(prog_name),
 				  prog_name, false);
 }
+#endif
 
 void test_fexit_bpf2bpf(void)
 {
-	test_target_no_callees();
-	test_target_yes_callees();
 	test_func_replace();
-	test_func_replace_verify();
 }
diff --git a/tools/testing/selftests/bpf/progs/trace_ext.c b/tools/testing/selftests/bpf/progs/trace_ext.c
new file mode 100644
index 000000000000..c7eaf30bf5ba
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/trace_ext.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <stddef.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#include <bpf/bpf_tracing.h>
+
+
+SEC("fentry/new_get_constant")
+int BPF_PROG(test_fentry_new_get_constant, long val)
+{
+        bpf_printk("ENTRY val %ld", val);
+	return 0;
+}
+
+SEC("fexit/new_get_constant")
+int BPF_PROG(test_fexit_new_get_constant, long val, int ret)
+{
+        bpf_printk("EXIT  val %ld, ret %d", val, ret);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";

