Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0A652C6F0
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiERW5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbiERW4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:56:33 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA176CF4E
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:55:57 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id h10-20020a170902748a00b00161b9277a4aso1587667pll.2
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2ifMzJdcStY/5O5m6nh5Ja6Hm2K26IpKO1V8xVAoPAA=;
        b=YXhPrApKNkUQKwlm2mGARh4GMIFWll80cKgOCU0MXAqSBAntXKsil1cubi+/1mhEb8
         Fu9CHujxwdnmwT82yz6cIzjBjLdWfyuJIJu9cNn1g4a1IOB900Lb5eiAIA4YQnPGlYto
         tnP8wtQaFattfbLovkQChzNWJ7Ju6sL/n97UnxifSCZfwpse/dAIKN5Thfe6JReM2lhg
         RFudkvkniz1nnpDb9w7AdH7NQcfdMvFoWeuxqw6EUc4sOfPvtFh5PldUQJCfppG1Ad01
         DYVZVvxx5D6wYRk4Tym8g/6G7pdK+X3/jo8GHoHGdC+UbTiQwaskhDz57+15AnO7r3B8
         HCIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2ifMzJdcStY/5O5m6nh5Ja6Hm2K26IpKO1V8xVAoPAA=;
        b=3zFytNAgkMdVvaO08bmUP7egR4I64QaAhTmAQ07Sp8BJYJppkTDirZ8nqhwOilNTRy
         bjMkjd18gSAgJtH+ROT5GwTJMYYWCZG4AMYZhagUcCI6A9WZy18AZxP3Offlh1PVTsHq
         WtGX1ovxvftV6M+YSYgiP6Ywkz/bosdb8THhecf3Omqy4Z+yc6br/9YFTqPU8kcdxRFu
         AK8O7ebaM55brof1y3OjJFtCybb0yKWFlw4Bzsg+VCBvWceMyS25ZLVt5G6fLVgyZVOw
         p7b4Hs68WDcfCh4XupX1GZd+NFdqJt3kE1SfdEaa3PxkpEpthwi06VOiI1PxYCnYs3sm
         4O1g==
X-Gm-Message-State: AOAM5321YSObKlAbTmWmiXhlnyer5eLGOqpkE2N/gRSQVbCwFwhBmXZA
        Lgq003EjCTIMkTAGzWfEfG1/Zb4RJ3X94/j/jZo7OF129B2gcquWfykHsIeIjig40YZHClbka/8
        biDssvJrx6z3XzVDkVYAYhz7tvYm73OFTmcVZt67OZTrU7i5XYALsUg==
X-Google-Smtp-Source: ABdhPJw0k7LpVBazAYEoSnhzKwo955ffrSG+h/J0BWzBQFCMtKcK8ga39AoNhoSey4mBzYj/Qm0dpz0=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:f763:3448:2567:bf00])
 (user=sdf job=sendgmr) by 2002:a17:90b:4b02:b0:1df:d622:dd07 with SMTP id
 lx2-20020a17090b4b0200b001dfd622dd07mr276056pjb.160.1652914557091; Wed, 18
 May 2022 15:55:57 -0700 (PDT)
Date:   Wed, 18 May 2022 15:55:31 -0700
In-Reply-To: <20220518225531.558008-1-sdf@google.com>
Message-Id: <20220518225531.558008-12-sdf@google.com>
Mime-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH bpf-next v7 11/11] selftests/bpf: verify lsm_cgroup struct
 sock access
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_priority & sk_mark are writable, the rest is readonly.

One interesting thing here is that the verifier doesn't
really force me to add NULL checks anywhere :-/

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/lsm_cgroup.c     | 69 +++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
index 29292ec40343..64b6830e03f5 100644
--- a/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
+++ b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
@@ -270,8 +270,77 @@ static void test_lsm_cgroup_functional(void)
 	lsm_cgroup__destroy(skel);
 }
 
+static int field_offset(const char *type, const char *field)
+{
+	const struct btf_member *memb;
+	const struct btf_type *tp;
+	const char *name;
+	struct btf *btf;
+	int btf_id;
+	int i;
+
+	btf = btf__load_vmlinux_btf();
+	if (!btf)
+		return -1;
+
+	btf_id = btf__find_by_name_kind(btf, type, BTF_KIND_STRUCT);
+	if (btf_id < 0)
+		return -1;
+
+	tp = btf__type_by_id(btf, btf_id);
+	memb = btf_members(tp);
+
+	for (i = 0; i < btf_vlen(tp); i++) {
+		name = btf__name_by_offset(btf,
+					   memb->name_off);
+		if (strcmp(field, name) == 0)
+			return memb->offset / 8;
+		memb++;
+	}
+
+	return -1;
+}
+
+static bool sk_writable_field(const char *type, const char *field, int size)
+{
+	LIBBPF_OPTS(bpf_prog_load_opts, opts,
+		    .expected_attach_type = BPF_LSM_CGROUP);
+	struct bpf_insn	insns[] = {
+		/* r1 = *(u64 *)(r1 + 0) */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0),
+		/* r1 = *(u64 *)(r1 + offsetof(struct socket, sk)) */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, field_offset("socket", "sk")),
+		/* r2 = *(u64 *)(r1 + offsetof(struct sock, <field>)) */
+		BPF_LDX_MEM(size, BPF_REG_2, BPF_REG_1, field_offset(type, field)),
+		/* *(u64 *)(r1 + offsetof(struct sock, <field>)) = r2 */
+		BPF_STX_MEM(size, BPF_REG_1, BPF_REG_2, field_offset(type, field)),
+		BPF_MOV64_IMM(BPF_REG_0, 1),
+		BPF_EXIT_INSN(),
+	};
+	int fd;
+
+	opts.attach_btf_id = libbpf_find_vmlinux_btf_id("socket_post_create",
+							opts.expected_attach_type);
+
+	fd = bpf_prog_load(BPF_PROG_TYPE_LSM, NULL, "GPL", insns, ARRAY_SIZE(insns), &opts);
+	if (fd >= 0)
+		close(fd);
+	return fd >= 0;
+}
+
+static void test_lsm_cgroup_access(void)
+{
+	ASSERT_FALSE(sk_writable_field("sock_common", "skc_family", BPF_H), "skc_family");
+	ASSERT_FALSE(sk_writable_field("sock", "sk_sndtimeo", BPF_DW), "sk_sndtimeo");
+	ASSERT_TRUE(sk_writable_field("sock", "sk_priority", BPF_W), "sk_priority");
+	ASSERT_TRUE(sk_writable_field("sock", "sk_mark", BPF_W), "sk_mark");
+	ASSERT_FALSE(sk_writable_field("sock", "sk_pacing_rate", BPF_DW), "sk_pacing_rate");
+}
+
 void test_lsm_cgroup(void)
 {
 	if (test__start_subtest("functional"))
 		test_lsm_cgroup_functional();
+	if (test__start_subtest("access"))
+		test_lsm_cgroup_access();
 }
-- 
2.36.1.124.g0e6072fb45-goog

