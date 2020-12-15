Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9881C2DB39D
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 19:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731210AbgLOSVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 13:21:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45267 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727655AbgLOSVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 13:21:10 -0500
Received: from 2.general.kamal.us.vpn ([10.172.68.52] helo=ascalon)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kamal@canonical.com>)
        id 1kpEvp-0001JY-BQ; Tue, 15 Dec 2020 18:20:17 +0000
Received: from kamal by ascalon with local (Exim 4.90_1)
        (envelope-from <kamal@ascalon>)
        id 1kpEvm-00048O-50; Tue, 15 Dec 2020 10:20:14 -0800
From:   Kamal Mostafa <kamal@canonical.com>
To:     andrii.nakryiko@gmail.com
Cc:     Kamal Mostafa <kamal@canonical.com>, stable@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] selftests/bpf: clarify build error if no vmlinux
Date:   Tue, 15 Dec 2020 10:20:10 -0800
Message-Id: <20201215182011.15755-1-kamal@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAEf4BzYBvz4TDayTE=Bc_bjqvOGaavmmw1sJhOCKhq9DwUpd4A@mail.gmail.com>
References: <CAEf4BzYBvz4TDayTE=Bc_bjqvOGaavmmw1sJhOCKhq9DwUpd4A@mail.gmail.com>
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

[v2] moves the check to right after the VMLINUX_BTF definition.

 tools/testing/selftests/bpf/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 542768f5195b..7ba631f495f7 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -146,6 +146,9 @@ VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
 		     /sys/kernel/btf/vmlinux				\
 		     /boot/vmlinux-$(shell uname -r)
 VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
+ifeq ($(VMLINUX_BTF),)
+$(error cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
+endif
 
 DEFAULT_BPFTOOL := $(SCRATCH_DIR)/sbin/bpftool
 
-- 
2.17.1

