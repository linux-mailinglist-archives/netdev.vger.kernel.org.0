Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F81544F9A
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 16:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344183AbiFIOhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 10:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344174AbiFIOgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 10:36:24 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE0132388C
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 07:36:22 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id x6-20020a1c7c06000000b003972dfca96cso1363095wmc.4
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 07:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XXt0AjifX4sZi/mItsYRB7C1EVTETD4Ra1f87tpY7Po=;
        b=mjg+gBqRQTviC0qWMlPAM4XmBRuRW2tvScNKNjmS5UNrlPcdwRrKmKMSGLReHjXlIb
         /sPnrwD0bc2p2/fGWJUkk0NqThc6r/Pu+8ICvVDYE3CsjCQjTs56OugKlVSVp8sdfPJ8
         LbmxLC6ZqBZuBc2gLZ4IjNb8VNJYaDzUrJeMdEGP4W2sMBShk+XOH8djtFRelFvRXOcN
         bFbIPb8A4LxZ+4SJgmL7G9hAVbECI+uap1rygytw5Z45AqiML5zXVsNg9SmzfBYjbj9T
         pNbicTExPsane7ACp9N3rqsE9M8+ASOauzM/neiZnYPeaAdmxIWonmeNYQG+uQqs++d2
         YWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XXt0AjifX4sZi/mItsYRB7C1EVTETD4Ra1f87tpY7Po=;
        b=2GNBWHFgAP6byG3CZwKCBHAGQzHxS9S1ilgpXLOLhhe1RO3uXuWcp2RIADP4uFfHBn
         pd0KFqsOs/oU6R8WbAmBzg9EP6VxR4gxJSJqijmX2LbClcsj0RLaTCL/G/sm5VMGyV24
         2rapPzAbXY/HxPKt7CdGN3aefYqNaNqtflzr/iVKkhXExopsAAcYLMGdRHzfSVBFGU/B
         52OUykUnvY9l7iYt/Fg9/Ci3ujF5khyg6CA/hy8lLc7kUilf/9Fj2fJcteJEJ0J1DT4L
         DYl+YnG36mI7e+utXcNwmWDt+AQzlXYqa8Q6EUvn4zprLcHR3xDJU8NUQaalR1pHMsxz
         UBwA==
X-Gm-Message-State: AOAM531Exm8RzwtdDSsO8AO/Scn8oDBaHxV2VnOS80BCXx7gJjBR2gPc
        9m4tH2LBtWCgNjhasNJECyb/6Q==
X-Google-Smtp-Source: ABdhPJxlMte9LkEGe+Gi0Q6FGEuK/JeL1kIj0MDHeLRaombVGYD6rGuvGMddiguz5mEZZFXMrofpUw==
X-Received: by 2002:a05:600c:19cb:b0:397:51db:446f with SMTP id u11-20020a05600c19cb00b0039751db446fmr3673983wmq.182.1654785381264;
        Thu, 09 Jun 2022 07:36:21 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id k1-20020a1ca101000000b0039c4ff5e0a7sm13265207wme.38.2022.06.09.07.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 07:36:20 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Harsh Modi <harshmodi@google.com>, Paul Chaignon <paul@cilium.io>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next] libbpf: Improve probing for memcg-based memory accounting
Date:   Thu,  9 Jun 2022 15:36:14 +0100
Message-Id: <20220609143614.97837-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To ensure that memory accounting will not hinder the load of BPF
objects, libbpf may raise the memlock rlimit before proceeding to some
operations. Whether this limit needs to be raised depends on the version
of the kernel: newer versions use cgroup-based (memcg) memory
accounting, and do not require any adjustment.

There is a probe in libbpf to determine whether memcg-based accounting
is supported. But this probe currently relies on the availability of a
given BPF helper, bpf_ktime_get_coarse_ns(), which landed in the same
kernel version as the memory accounting change. This works in the
generic case, but it may fail, for example, if the helper function has
been backported to an older kernel. This has been observed for Google
Cloud's Container-Optimized OS (COS), where the helper is available but
rlimit is still in use. The probe succeeds, the rlimit is not raised,
and probing features with bpftool, for example, fails.

Here we attempt to improve this probe and to effectively rely on memory
accounting. Function probe_memcg_account() in libbpf is updated to set
the rlimit to 0, then attempt to load a BPF object, and then to reset
the rlimit. If the load still succeeds, then this means we're running
with memcg-based accounting.

This probe was inspired by the similar one from the cilium/ebpf Go
library [0].

[0] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/lib/bpf/bpf.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 240186aac8e6..781387e6f66b 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -99,31 +99,44 @@ static inline int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size, int
 
 /* Probe whether kernel switched from memlock-based (RLIMIT_MEMLOCK) to
  * memcg-based memory accounting for BPF maps and progs. This was done in [0].
- * We use the support for bpf_ktime_get_coarse_ns() helper, which was added in
- * the same 5.11 Linux release ([1]), to detect memcg-based accounting for BPF.
+ * To do so, we lower the soft memlock rlimit to 0 and attempt to create a BPF
+ * object. If it succeeds, then memcg-based accounting for BPF is available.
  *
  *   [0] https://lore.kernel.org/bpf/20201201215900.3569844-1-guro@fb.com/
- *   [1] d05512618056 ("bpf: Add bpf_ktime_get_coarse_ns helper")
  */
 int probe_memcg_account(void)
 {
 	const size_t prog_load_attr_sz = offsetofend(union bpf_attr, attach_btf_obj_fd);
 	struct bpf_insn insns[] = {
-		BPF_EMIT_CALL(BPF_FUNC_ktime_get_coarse_ns),
 		BPF_EXIT_INSN(),
 	};
+	struct rlimit rlim_init, rlim_cur_zero = {};
 	size_t insn_cnt = ARRAY_SIZE(insns);
 	union bpf_attr attr;
 	int prog_fd;
 
-	/* attempt loading freplace trying to use custom BTF */
 	memset(&attr, 0, prog_load_attr_sz);
 	attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
 	attr.insns = ptr_to_u64(insns);
 	attr.insn_cnt = insn_cnt;
 	attr.license = ptr_to_u64("GPL");
 
+	if (getrlimit(RLIMIT_MEMLOCK, &rlim_init))
+		return -1;
+
+	/* Drop the soft limit to zero. We maintain the hard limit to its
+	 * current value, because lowering it would be a permanent operation
+	 * for unprivileged users.
+	 */
+	rlim_cur_zero.rlim_max = rlim_init.rlim_max;
+	if (setrlimit(RLIMIT_MEMLOCK, &rlim_cur_zero))
+		return -1;
+
 	prog_fd = sys_bpf_fd(BPF_PROG_LOAD, &attr, prog_load_attr_sz);
+
+	/* reset soft rlimit as soon as possible */
+	setrlimit(RLIMIT_MEMLOCK, &rlim_init);
+
 	if (prog_fd >= 0) {
 		close(prog_fd);
 		return 1;
-- 
2.34.1

