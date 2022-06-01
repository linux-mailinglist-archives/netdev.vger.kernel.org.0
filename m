Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E42653B03D
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 00:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiFAVLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 17:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbiFAVLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 17:11:38 -0400
Received: from mail-vk1-xa49.google.com (mail-vk1-xa49.google.com [IPv6:2607:f8b0:4864:20::a49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FA35AA4F
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 14:11:06 -0700 (PDT)
Received: by mail-vk1-xa49.google.com with SMTP id bk49-20020a0561220e3100b0035ce7546b32so569464vkb.18
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 14:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MtH8Hz1X124NCWwEXnuLD44TX9SlL7+U3QIB1SL8T2g=;
        b=H+zlnQUyQ7wgiN5l7ikqahpCnKh+GmSJ6KYEP2NY9Evx31r2htc7pgEbabKn+WEDMp
         LSRCLZFslgH3grnQnRQu0hyQ7UHu6eP3v1ywzD/my7hdflbAJ3xpVEnwpULfj3Hpo3Oc
         63XH8kvnROK/FH9EbgwEG0FI8H6gKC6UOW0FMC84/ekIOeEhVm4a5tbTzppYfq4Vxev+
         4wrgQkEs3akijG9Z/RMAL1GVxs0bAXIkRM8BKgAByB9FS8h2BdZI2zaWinxXdM5LdIAa
         OgDpH4dwuK2pNLmO3hNRJ+Dlzf3rO8DMsURGJ/dbD8i22nNB5c9HeGiop88rjVh1A1+P
         TBFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MtH8Hz1X124NCWwEXnuLD44TX9SlL7+U3QIB1SL8T2g=;
        b=Ie44E9l12OG/y0RESFNMDMWqk++VduwuIZgssCHWQRRLZQB3UHJIbg973ugNKD4nCT
         La4vGdETWkajg1SfrevwnejDZAQ0KuCoJsWHk+6VuBYJ9Z12Uh3zS1i+dsrZV59m2v/r
         DHO+SBfBs9OvD1VrpZIA9K5ccGdXyEFmW7xAa/MM1otXIfi8x1jtv7ZU2+Go7m5rbxBC
         FxQGI8HZirQoGGJ36WOysa38frGt95vEHdynXxeU8PqsDHqECSzDC+TsczThXBwmNIJd
         nfLtnxK0Mmd3dw1PfsEZ9dCg7DLi1bUCwtOThrD0b0eqoUFzO2ax+dXb9rs1vB64G+7a
         DlJg==
X-Gm-Message-State: AOAM532g5DaRA70u3t1TDaJSnrOTwDNz6/5CbQZSnipO3GY967Alox18
        XXoL/dCyJskR4E+LMFGXYg6M3LpGpIaTFN9LUA7xj/MrRsDZWs74tL8RBPYWeWpCzLo5oEON+3d
        sJAN4QaCRg9jHroLqtS2/IB+2w/6xz1xBjhkWW6fJ41lGsJLkioeEPw==
X-Google-Smtp-Source: ABdhPJw8yDf18Kwulq7LUUNeI3POC5BlyGQGYNYGIkmaGrakDJMu3Zn8PP4V73Mn/uh+GBEgI4Hdc6Q=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:903:11d0:b0:156:6c35:9588 with SMTP id
 q16-20020a17090311d000b001566c359588mr880028plh.50.1654110159080; Wed, 01 Jun
 2022 12:02:39 -0700 (PDT)
Date:   Wed,  1 Jun 2022 12:02:18 -0700
In-Reply-To: <20220601190218.2494963-1-sdf@google.com>
Message-Id: <20220601190218.2494963-12-sdf@google.com>
Mime-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH bpf-next v8 11/11] selftests/bpf: verify lsm_cgroup struct
 sock access
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index a96057ec7dd4..a730acd9dfdd 100644
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
2.36.1.255.ge46751e96f-goog

