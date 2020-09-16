Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6CB926CEEA
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgIPWh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgIPWhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:37:54 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D313C061788
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 15:37:54 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id a2so7483244qkg.19
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 15:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=P0/XHNACdLCUTE2NkPXDYLWlznqm7B496+cU0eLiRvs=;
        b=N7PvblzepT8TRkUNWA/I98PPBW+aNIvvd+M0mTCRrCSukeeCnVR01+tnMGSI0jzUAN
         QcGrx8lOIdgc2PYarRTJ9G8hQSBgRpM+lc/UDfCx40FDKUb7h7/+Y/fZiBWoTKQlN0gO
         hiqpFb8Y7eufHgYUv0pWv8y41/L8MmZ+ulRgGCUi2WELX8u0d4A54fGM0ylBghn09AQD
         mo9NYz/23bh4T5A+R/SpbQxCKBXsBUYD4efIJz5BqbhUYFIX9rKqZPbHDlZntc6BqbhZ
         S7c3wKgErQTmuYN3ltJEe32XcLFNKJa76iIUuzxvwR/EVPiZAOc4OiQ4/STFeiGnF1up
         LeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=P0/XHNACdLCUTE2NkPXDYLWlznqm7B496+cU0eLiRvs=;
        b=TX5yMe8ROZp1UBNjCm6haynKDJFv0MaLW+GWQCW6I2ghxWeytwDLE4/WWiPrC3pDk0
         4QVfyN09yXCEP7OBnB6J0udNO3URPmjC7tiXa8bEfXeBZFzDtZ7rb8dUArIEmDXnNVHg
         1MLQ7+eitZVNaT6bIOZJsH5RXh+m8CzA0OcVJ38pOGWP05MJvoVZHqdiT8IHowfDpD/v
         diNSo0DQZqo2WI3c2R2CH8wTqrp5lQdPfHABwCHTzpUdcVTodgAeA6cKyMosueFZKCbl
         pTaf+0v+gx3Qm0ugjsPJVDW0tFoxKRGoxRUhf9vHg2EwEosoFspYV8Cn8znBu1C9oRIJ
         E4wQ==
X-Gm-Message-State: AOAM5337hU/X7QCT2mfkCrh/98+F7Xui7b4Bkw/RGVua9vFaaxvypQsA
        FEMWMkINcoLjplSkAUlukf6XSJPT9W+euxNnsWAHw0CjbtCAMMDHmcQV05jZlESwSYu+vd/qF8k
        1ztkxBxScbnGdw5O9iRSWMitsEDH8LbZIoSCWZOxNvme3THvoqiuxQWFkQU9WHA==
X-Google-Smtp-Source: ABdhPJwjusGHTRhrPsKDw/1tJ1ThXkW8Ff0AXVS+0XHDja3t+9w1eo4pdYJtV3cCf7Fvj63YepgqZqOVn6c=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a0c:f0d1:: with SMTP id d17mr9473565qvl.34.1600295873277;
 Wed, 16 Sep 2020 15:37:53 -0700 (PDT)
Date:   Wed, 16 Sep 2020 15:35:06 -0700
Message-Id: <20200916223512.2885524-1-haoluo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH bpf-next v3 0/6] bpf: BTF support for ksyms
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2 -> v3:
 - Rename functions and variables in verifier for better readability.
 - Stick to logging message convention in libbpf.
 - Move bpf_per_cpu_ptr and bpf_this_cpu_ptr from trace-specific
   helper set to base helper set.
 - More specific test in ksyms_btf.
 - Fix return type cast in bpf_*_cpu_ptr.
 - Fix btf leak in ksyms_btf selftest.
 - Fix return error code for kallsyms_find().

v1 -> v2:
 - Move check_pseudo_btf_id from check_ld_imm() to
   replace_map_fd_with_map_ptr() and rename the latter.
 - Add bpf_this_cpu_ptr().
 - Use bpf_core_types_are_compat() in libbpf.c for checking type
   compatibility.
 - Rewrite typed ksym extern type in BTF with int to save space.
 - Minor revision of bpf_per_cpu_ptr()'s comments.
 - Avoid using long in tests that use skeleton.
 - Refactored test_ksyms.c by moving kallsyms_find() to trace_helpers.c
 - Fold the patches that sync include/linux/uapi and
   tools/include/linux/uapi.

rfc -> v1:
 - Encode VAR's btf_id for PSEUDO_BTF_ID.
 - More checks in verifier. Checking the btf_id passed as
   PSEUDO_BTF_ID is valid VAR, its name and type.
 - Checks in libbpf on type compatibility of ksyms.
 - Add bpf_per_cpu_ptr() to access kernel percpu vars. Introduced
   new ARG and RET types for this helper.

This patch series extends the previously added __ksym externs with
btf support.

Right now the __ksym externs are treated as pure 64-bit scalar value.
Libbpf replaces ld_imm64 insn of __ksym by its kernel address at load
time. This patch series extend those externs with their btf info. Note
that btf support for __ksym must come with the kernel btf that has
VARs encoded to work properly. The corresponding chagnes in pahole
is available at [1] (with a fix at [2] for gcc 4.9+).

The first 3 patches in this series add support for general kernel
global variables, which include verifier checking (01/06), libpf
support (02/06) and selftests for getting typed ksym extern's kernel
address (03/06).

The next 3 patches extends that capability further by introducing
helpers bpf_per_cpu_ptr() and bpf_this_cpu_ptr(), which allows accessing
kernel percpu variables correctly (04/06 and 05/06).

The tests of this feature were performed against pahole that is extended
with [1] and [2]. For kernel BTF that does not have VARs encoded, the
selftests will be skipped.

[1] https://git.kernel.org/pub/scm/devel/pahole/pahole.git/commit/?id=f3d9054ba8ff1df0fc44e507e3a01c0964cabd42
[2] https://www.spinics.net/lists/dwarves/msg00451.html



Hao Luo (6):
  bpf: Introduce pseudo_btf_id
  bpf/libbpf: BTF support for typed ksyms
  selftests/bpf: ksyms_btf to test typed ksyms
  bpf: Introduce bpf_per_cpu_ptr()
  bpf: Introduce bpf_this_cpu_ptr()
  bpf/selftests: Test for bpf_per_cpu_ptr() and bpf_this_cpu_ptr()

 include/linux/bpf.h                           |   6 +
 include/linux/bpf_verifier.h                  |   7 +
 include/linux/btf.h                           |  26 +++
 include/uapi/linux/bpf.h                      |  67 +++++-
 kernel/bpf/btf.c                              |  25 ---
 kernel/bpf/helpers.c                          |  32 +++
 kernel/bpf/verifier.c                         | 190 ++++++++++++++++--
 kernel/trace/bpf_trace.c                      |   4 +
 tools/include/uapi/linux/bpf.h                |  67 +++++-
 tools/lib/bpf/libbpf.c                        | 112 +++++++++--
 .../testing/selftests/bpf/prog_tests/ksyms.c  |  38 ++--
 .../selftests/bpf/prog_tests/ksyms_btf.c      |  88 ++++++++
 .../selftests/bpf/progs/test_ksyms_btf.c      |  55 +++++
 tools/testing/selftests/bpf/trace_helpers.c   |  27 +++
 tools/testing/selftests/bpf/trace_helpers.h   |   4 +
 15 files changed, 653 insertions(+), 95 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf.c

-- 
2.28.0.618.gf4bc123cb7-goog

