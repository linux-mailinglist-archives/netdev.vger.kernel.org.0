Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF142DA164
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503179AbgLNUWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:22:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36369 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503125AbgLNUVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 15:21:50 -0500
Received: from [192.188.8.81] (helo=ascalon)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kamal@canonical.com>)
        id 1kouL3-0007W7-FK; Mon, 14 Dec 2020 20:20:57 +0000
Received: from kamal by ascalon with local (Exim 4.90_1)
        (envelope-from <kamal@ascalon>)
        id 1kouL0-0001v1-Ls; Mon, 14 Dec 2020 12:20:54 -0800
From:   Kamal Mostafa <kamal@canonical.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kamal Mostafa <kamal@canonical.com>, stable@vger.kernel.org
Subject: [PATCH] selftests/bpf: clarify build error if no vmlinux
Date:   Mon, 14 Dec 2020 12:20:48 -0800
Message-Id: <20201214202049.7205-1-kamal@canonical.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If Makefile cannot find any of the vmlinux's in its VMLINUX_BTF_PATHS list,
it tries to run btftool incorrectly, with VMLINUX_BTF unset:

    bpftool btf dump file $(VMLINUX_BTF) format c

Such that the keyword 'format' is misinterpreted as the path to vmlinux.
The resulting build error message is fairly cryptic:

      GEN      vmlinux.h
    Error: failed to load BTF from format: No such file or directory

This patch makes the failure reason clearer by yielding this instead:

    Makefile:...: *** cannot find a vmlinux for VMLINUX_BTF at any of
    "{paths}".  Stop.

Fixes: acbd06206bbb ("selftests/bpf: Add vmlinux.h selftest exercising tracing of syscalls")
Cc: stable@vger.kernel.org # 5.7+
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 tools/testing/selftests/bpf/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 542768f5195b..93ed34ef6e3f 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -196,6 +196,9 @@ $(BUILD_DIR)/libbpf $(BUILD_DIR)/bpftool $(BUILD_DIR)/resolve_btfids $(INCLUDE_D
 $(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) | $(BPFTOOL) $(INCLUDE_DIR)
 ifeq ($(VMLINUX_H),)
 	$(call msg,GEN,,$@)
+ifeq ($(VMLINUX_BTF),)
+$(error cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
+endif
 	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
 else
 	$(call msg,CP,,$@)
-- 
2.17.1

