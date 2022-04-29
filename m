Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D19251569B
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236785AbiD2VTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 17:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbiD2VT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 17:19:28 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4997CB1E
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:16:07 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d11b6259adso85417157b3.19
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UtPIgzvmBvRhCMQR/+L9Uukkz10/65B1dscx6ceVu9Y=;
        b=aAEj+4SbNZUq+5SDn5KgQ240sG8teV88Ceg2OBGMpYsLvcTvQpKutnFc3oYCmMIi+2
         O1Vpf0bxH31bRe0Jjs1EFG6iKzgoFYpGcWqNEQVWkjfNhSYVaS33/uL1NgXi9Yh06gIN
         XnyHSZl30A+l3YrGAgbZz4WDR/nqHtufCQRg1Dtw9wLKg8VR68RA6W5UEIU+9Iv4XKMj
         MAOYmMkvMJ+TTw2Iq7f4ErzTeEhtwQZNIgfHaYdGy89mVC7tkCAE4rbztBpLQZcUGLgY
         gOg5U+q50DPykAVtAzjbiPd0ALRvwGpPvImDrzRF6oLSLesL6RBc6PaKmXviWuVake/8
         uN/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UtPIgzvmBvRhCMQR/+L9Uukkz10/65B1dscx6ceVu9Y=;
        b=bYIaQ4RQZU0PZyP7ZWmi1CBdQKrg6a/avuqRvhchYi6ViyXHARN30Y99AxvY3XMKl8
         g2IwiMPYNU2wOkVNRciEFDa9iQwM6aEg3XoiyNPhIyz2sS2vbMe54JSd9zubT13a+9k1
         gE4yYTl9VBo82QbMPmi/RNdqXgIqmhWOxPJM3DjmKHbmPQbz0LXiqD7MRtkOWtNHSpDk
         UG/THU7tikTE9a2iJVznIvajg5VBOtt5SeNb8m3v9oJ8gIXrzM1LlZ6yNtU4HnfRlxez
         xRPa16z4kRJ1hRh1VIE+Nx95JGCMrLJ5VTV0W3A2xpF6vqgzLiNN0UmrWaL7dc8dkKos
         4dmQ==
X-Gm-Message-State: AOAM532t60D+wmpnr3VuotbcPKWFKe+Y8Q2WX7on+u2aVsN+frDiFLRd
        +gZtSRb+CXvvMgpF0HPpG5au7UbY8ClWknfUnTIiXzvwzV5yetiL8azjhBMzoZPeYspYHKDZbJK
        QLWU3+V9T8dG/ljNgNfuhSpHnaeg5UFtvVk4IssQDouki4xf0ytaREg==
X-Google-Smtp-Source: ABdhPJyGzLv7QMHut2i0w0L2i2aezsPjsOVrMf91A8ECDoLZpaeNrfy9wxQ59h/yT3z8gR34uJZnT0E=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:b0cc:7605:1029:2d96])
 (user=sdf job=sendgmr) by 2002:a25:ed08:0:b0:648:8b96:cb2c with SMTP id
 k8-20020a25ed08000000b006488b96cb2cmr1426804ybh.370.1651266966911; Fri, 29
 Apr 2022 14:16:06 -0700 (PDT)
Date:   Fri, 29 Apr 2022 14:15:40 -0700
In-Reply-To: <20220429211540.715151-1-sdf@google.com>
Message-Id: <20220429211540.715151-11-sdf@google.com>
Mime-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH bpf-next v6 10/10] selftests/bpf: verify lsm_cgroup struct
 sock access
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_priority & sk_mark are writable, the rest is readonly.

Add new ldx_offset fixups to lookup the offset of struct field.
Allow using test.kfunc regardless of prog_type.

One interesting thing here is that the verifier doesn't
really force me to add NULL checks anywhere :-/

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/test_verifier.c   | 54 ++++++++++++++++++-
 .../selftests/bpf/verifier/lsm_cgroup.c       | 34 ++++++++++++
 2 files changed, 87 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/lsm_cgroup.c

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 372579c9f45e..49961492cbd4 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -75,6 +75,12 @@ struct kfunc_btf_id_pair {
 	int insn_idx;
 };
 
+struct ldx_offset {
+	const char *strct;
+	const char *field;
+	int insn_idx;
+};
+
 struct bpf_test {
 	const char *descr;
 	struct bpf_insn	insns[MAX_INSNS];
@@ -103,6 +109,7 @@ struct bpf_test {
 	int fixup_map_timer[MAX_FIXUPS];
 	int fixup_map_kptr[MAX_FIXUPS];
 	struct kfunc_btf_id_pair fixup_kfunc_btf_id[MAX_FIXUPS];
+	struct ldx_offset fixup_ldx[MAX_FIXUPS];
 	/* Expected verifier log output for result REJECT or VERBOSE_ACCEPT.
 	 * Can be a tab-separated sequence of expected strings. An empty string
 	 * means no log verification.
@@ -799,6 +806,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_timer = test->fixup_map_timer;
 	int *fixup_map_kptr = test->fixup_map_kptr;
 	struct kfunc_btf_id_pair *fixup_kfunc_btf_id = test->fixup_kfunc_btf_id;
+	struct ldx_offset *fixup_ldx = test->fixup_ldx;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -1018,6 +1026,50 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_kfunc_btf_id++;
 		} while (fixup_kfunc_btf_id->kfunc);
 	}
+
+	if (fixup_ldx->strct) {
+		const struct btf_member *memb;
+		const struct btf_type *tp;
+		const char *name;
+		struct btf *btf;
+		int btf_id;
+		int off;
+		int i;
+
+		btf = btf__load_vmlinux_btf();
+
+		do {
+			off = -1;
+			if (!btf)
+				goto next_ldx;
+
+			btf_id = btf__find_by_name_kind(btf,
+							fixup_ldx->strct,
+							BTF_KIND_STRUCT);
+			if (btf_id < 0)
+				goto next_ldx;
+
+			tp = btf__type_by_id(btf, btf_id);
+			memb = btf_members(tp);
+
+			for (i = 0; i < btf_vlen(tp); i++) {
+				name = btf__name_by_offset(btf,
+							   memb->name_off);
+				if (strcmp(fixup_ldx->field, name) == 0) {
+					off = memb->offset / 8;
+					break;
+				}
+				memb++;
+			}
+
+next_ldx:
+			prog[fixup_ldx->insn_idx].off = off;
+			fixup_ldx++;
+
+		} while (fixup_ldx->strct);
+
+		btf__free(btf);
+	}
 }
 
 struct libcap {
@@ -1182,7 +1234,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 		opts.log_level = 4;
 	opts.prog_flags = pflags;
 
-	if (prog_type == BPF_PROG_TYPE_TRACING && test->kfunc) {
+	if (test->kfunc) {
 		int attach_btf_id;
 
 		attach_btf_id = libbpf_find_vmlinux_btf_id(test->kfunc,
diff --git a/tools/testing/selftests/bpf/verifier/lsm_cgroup.c b/tools/testing/selftests/bpf/verifier/lsm_cgroup.c
new file mode 100644
index 000000000000..af0efe783511
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/lsm_cgroup.c
@@ -0,0 +1,34 @@
+#define SK_WRITABLE_FIELD(tp, field, size, res) \
+{ \
+	.descr = field, \
+	.insns = { \
+		/* r1 = *(u64 *)(r1 + 0) */ \
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0), \
+		/* r1 = *(u64 *)(r1 + offsetof(struct socket, sk)) */ \
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0), \
+		/* r2 = *(u64 *)(r1 + offsetof(struct sock, <field>)) */ \
+		BPF_LDX_MEM(size, BPF_REG_2, BPF_REG_1, 0), \
+		/* *(u64 *)(r1 + offsetof(struct sock, <field>)) = r2 */ \
+		BPF_STX_MEM(size, BPF_REG_1, BPF_REG_2, 0), \
+		BPF_MOV64_IMM(BPF_REG_0, 1), \
+		BPF_EXIT_INSN(), \
+	}, \
+	.result = res, \
+	.errstr = res ? "no write support to 'struct sock' at off" : "", \
+	.prog_type = BPF_PROG_TYPE_LSM, \
+	.expected_attach_type = BPF_LSM_CGROUP, \
+	.kfunc = "socket_post_create", \
+	.fixup_ldx = { \
+		{ "socket", "sk", 1 }, \
+		{ tp, field, 2 }, \
+		{ tp, field, 3 }, \
+	}, \
+}
+
+SK_WRITABLE_FIELD("sock_common", "skc_family", BPF_H, REJECT),
+SK_WRITABLE_FIELD("sock", "sk_sndtimeo", BPF_DW, REJECT),
+SK_WRITABLE_FIELD("sock", "sk_priority", BPF_W, ACCEPT),
+SK_WRITABLE_FIELD("sock", "sk_mark", BPF_W, ACCEPT),
+SK_WRITABLE_FIELD("sock", "sk_pacing_rate", BPF_DW, REJECT),
+
+#undef SK_WRITABLE_FIELD
-- 
2.36.0.464.gb9c8b46e94-goog

