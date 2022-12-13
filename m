Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A242B64C08E
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 00:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbiLMXZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 18:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236790AbiLMXZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 18:25:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D891C26ACF
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 15:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670973890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W8YyOb6v7QR8nomuiV41xmYHHe3G8SrWVy2kEIBm1qA=;
        b=S9SlrECBzGzPlF7WptqtLayj1LJyjXzGJNBCJ/EuTOsosRbdwHuK6YYUQblabIjuRJoLp+
        VE0uiabh1iw6rV2sPyyi9ke3u7Dgw0Dkrg+XciBy9/dL0MLnjygSlsLiwkKqB6MOFc5t6O
        oOZMIKioi9JrXCtE8QyO39ca7H6TvTU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-595-OBIN7DFXOwO-zph20cMnoA-1; Tue, 13 Dec 2022 18:24:47 -0500
X-MC-Unique: OBIN7DFXOwO-zph20cMnoA-1
Received: by mail-ed1-f69.google.com with SMTP id b13-20020a056402350d00b00464175c3f1eso8226859edd.11
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 15:24:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8YyOb6v7QR8nomuiV41xmYHHe3G8SrWVy2kEIBm1qA=;
        b=bnVx7f7oZQxP1K/+CTxGHGwWqps76rjaRpWXrXPt18THrVj1Y/SdTLgz1N1E7ib8xq
         pPXJI+aJZ65ugjtBNMxvsclBFAmZaSVMO417FUD5STSMiUmXVlPAiVfmjrWuUv2u/L/t
         U98WY7LRmE2ynnWox+PNkRyWUElWs8jPPWhv6dXO6SueI796tUPDpslj1deJY3Pc4U8o
         LUYKV+wS1B3H/+t1V9YNjQPdWTZUeUFVJT8tQbVDz8LqaihqM0D/N+gG64BX5dLWWWRL
         y7sGcsgqwIqFtv8paKGPW61VYsaadrUFKyUl519VwWoaqlfqPu6YyD+OM0iHNGF4Yygn
         PTVQ==
X-Gm-Message-State: AFqh2koH0HdJpJ6RZP4s4/vCgfQTXA/Fts6Ez4Q9W1GE023uztIrk5fR
        Px9AmmUcGq/sVf4R/sxAGtMXtS6dDlgxXNnqa+Utlaq33Dl8Hq0pVyIh2hhizV4O8VJlKb443k8
        SjxXC7n6xKoEhPbGh
X-Received: by 2002:a17:906:ad0:b0:7c4:ed62:5b5d with SMTP id z16-20020a1709060ad000b007c4ed625b5dmr16000ejf.49.1670973886651;
        Tue, 13 Dec 2022 15:24:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5Cc9Su3FH5H9CVN2+I2NXm3+s9WpiHgKkSs5rGimlkZQ6XmLjLETcMg+rw7gL8K5tiza7kfw==
X-Received: by 2002:a17:906:ad0:b0:7c4:ed62:5b5d with SMTP id z16-20020a1709060ad000b007c4ed625b5dmr15963ejf.49.1670973886275;
        Tue, 13 Dec 2022 15:24:46 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id kb16-20020a170907925000b007c08439161dsm5069919ejb.50.2022.12.13.15.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 15:24:45 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EF27A82F3FA; Wed, 14 Dec 2022 00:24:44 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Shuah Khan <shuah@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf v3 2/2] selftests/bpf: Add a test for using a cpumap from an freplace-to-XDP program
Date:   Wed, 14 Dec 2022 00:24:40 +0100
Message-Id: <20221213232441.652313-2-toke@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221213232441.652313-1-toke@redhat.com>
References: <20221213232441.652313-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a simple test for inserting an XDP program into a cpumap that is
"owned" by an XDP program that was loaded as PROG_TYPE_EXT (as libxdp
does). Prior to the kernel fix this would fail because the map type
ownership would be set to PROG_TYPE_EXT instead of being resolved to
PROG_TYPE_XDP.

v3:
- Update comment to better explain the cause
- Add Yonghong's ACK

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 57 +++++++++++++++++++
 .../selftests/bpf/progs/freplace_progmap.c    | 24 ++++++++
 tools/testing/selftests/bpf/testing_helpers.c | 24 +++++++-
 tools/testing/selftests/bpf/testing_helpers.h |  2 +
 4 files changed, 105 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_progmap.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index d1e32e792536..fa8e129d1a71 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -500,6 +500,61 @@ static void test_fentry_to_cgroup_bpf(void)
 	bind4_prog__destroy(skel);
 }
 
+static void test_func_replace_progmap(void)
+{
+	struct bpf_cpumap_val value = { .qsize = 1 };
+	struct bpf_object *obj, *tgt_obj = NULL;
+	struct bpf_program *drop, *redirect;
+	struct bpf_map *cpumap;
+	int err, tgt_fd;
+	__u32 key = 0;
+
+	err = bpf_prog_test_open("freplace_progmap.bpf.o", BPF_PROG_TYPE_UNSPEC, &obj);
+	if (!ASSERT_OK(err, "prog_open"))
+		return;
+
+	err = bpf_prog_test_load("xdp_dummy.bpf.o", BPF_PROG_TYPE_UNSPEC, &tgt_obj, &tgt_fd);
+	if (!ASSERT_OK(err, "tgt_prog_load"))
+		goto out;
+
+	drop = bpf_object__find_program_by_name(obj, "xdp_drop_prog");
+	redirect = bpf_object__find_program_by_name(obj, "xdp_cpumap_prog");
+	cpumap = bpf_object__find_map_by_name(obj, "cpu_map");
+
+	if (!ASSERT_OK_PTR(drop, "drop") || !ASSERT_OK_PTR(redirect, "redirect") ||
+	    !ASSERT_OK_PTR(cpumap, "cpumap"))
+		goto out;
+
+	/* Change the 'redirect' program type to be a PROG_TYPE_EXT
+	 * with an XDP target
+	 */
+	bpf_program__set_type(redirect, BPF_PROG_TYPE_EXT);
+	bpf_program__set_expected_attach_type(redirect, 0);
+	err = bpf_program__set_attach_target(redirect, tgt_fd, "xdp_dummy_prog");
+	if (!ASSERT_OK(err, "set_attach_target"))
+		goto out;
+
+	err = bpf_object__load(obj);
+	if (!ASSERT_OK(err, "obj_load"))
+		goto out;
+
+	/* Prior to fixing the kernel, loading the PROG_TYPE_EXT 'redirect'
+	 * program above will cause the map owner type of 'cpumap' to be set to
+	 * PROG_TYPE_EXT. This in turn will cause the bpf_map_update_elem()
+	 * below to fail, because the program we are inserting into the map is
+	 * of PROG_TYPE_XDP. After fixing the kernel, the initial ownership will
+	 * be correctly resolved to the *target* of the PROG_TYPE_EXT program
+	 * (i.e., PROG_TYPE_XDP) and the map update will succeed.
+	 */
+	value.bpf_prog.fd = bpf_program__fd(drop);
+	err = bpf_map_update_elem(bpf_map__fd(cpumap), &key, &value, 0);
+	ASSERT_OK(err, "map_update");
+
+out:
+	bpf_object__close(tgt_obj);
+	bpf_object__close(obj);
+}
+
 /* NOTE: affect other tests, must run in serial mode */
 void serial_test_fexit_bpf2bpf(void)
 {
@@ -525,4 +580,6 @@ void serial_test_fexit_bpf2bpf(void)
 		test_func_replace_global_func();
 	if (test__start_subtest("fentry_to_cgroup_bpf"))
 		test_fentry_to_cgroup_bpf();
+	if (test__start_subtest("func_replace_progmap"))
+		test_func_replace_progmap();
 }
diff --git a/tools/testing/selftests/bpf/progs/freplace_progmap.c b/tools/testing/selftests/bpf/progs/freplace_progmap.c
new file mode 100644
index 000000000000..68174c3d7b37
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/freplace_progmap.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_CPUMAP);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(struct bpf_cpumap_val));
+	__uint(max_entries, 1);
+} cpu_map SEC(".maps");
+
+SEC("xdp/cpumap")
+int xdp_drop_prog(struct xdp_md *ctx)
+{
+	return XDP_DROP;
+}
+
+SEC("xdp")
+int xdp_cpumap_prog(struct xdp_md *ctx)
+{
+	return bpf_redirect_map(&cpu_map, 0, XDP_PASS);
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/testing_helpers.c b/tools/testing/selftests/bpf/testing_helpers.c
index 9695318e8132..2050244e6f24 100644
--- a/tools/testing/selftests/bpf/testing_helpers.c
+++ b/tools/testing/selftests/bpf/testing_helpers.c
@@ -174,8 +174,8 @@ __u32 link_info_prog_id(const struct bpf_link *link, struct bpf_link_info *info)
 
 int extra_prog_load_log_flags = 0;
 
-int bpf_prog_test_load(const char *file, enum bpf_prog_type type,
-		       struct bpf_object **pobj, int *prog_fd)
+int bpf_prog_test_open(const char *file, enum bpf_prog_type type,
+		       struct bpf_object **pobj)
 {
 	LIBBPF_OPTS(bpf_object_open_opts, opts,
 		.kernel_log_level = extra_prog_load_log_flags,
@@ -201,6 +201,26 @@ int bpf_prog_test_load(const char *file, enum bpf_prog_type type,
 	flags = bpf_program__flags(prog) | BPF_F_TEST_RND_HI32;
 	bpf_program__set_flags(prog, flags);
 
+	*pobj = obj;
+	return 0;
+err_out:
+	bpf_object__close(obj);
+	return err;
+}
+
+int bpf_prog_test_load(const char *file, enum bpf_prog_type type,
+		       struct bpf_object **pobj, int *prog_fd)
+{
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	int err;
+
+	err = bpf_prog_test_open(file, type, &obj);
+	if (err)
+		return err;
+
+	prog = bpf_object__next_program(obj, NULL);
+
 	err = bpf_object__load(obj);
 	if (err)
 		goto err_out;
diff --git a/tools/testing/selftests/bpf/testing_helpers.h b/tools/testing/selftests/bpf/testing_helpers.h
index 6ec00bf79cb5..977eb520d119 100644
--- a/tools/testing/selftests/bpf/testing_helpers.h
+++ b/tools/testing/selftests/bpf/testing_helpers.h
@@ -6,6 +6,8 @@
 
 int parse_num_list(const char *s, bool **set, int *set_len);
 __u32 link_info_prog_id(const struct bpf_link *link, struct bpf_link_info *info);
+int bpf_prog_test_open(const char *file, enum bpf_prog_type type,
+		       struct bpf_object **pobj);
 int bpf_prog_test_load(const char *file, enum bpf_prog_type type,
 		       struct bpf_object **pobj, int *prog_fd);
 int bpf_test_load_program(enum bpf_prog_type type, const struct bpf_insn *insns,
-- 
2.38.1

