Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0881917C6
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 18:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgCXRhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 13:37:50 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:33736 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgCXRhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 13:37:50 -0400
Received: by mail-pj1-f43.google.com with SMTP id jz1so1392399pjb.0;
        Tue, 24 Mar 2020 10:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=u4lf1PHYRg4zYxbp68UEi0BJs20RNiGheCb8mlcFBus=;
        b=NtlVvA1t8v9OlCRTWjjQHqbXAWRhdsFYRngjUBx/Vy9vSQiqbTlYGCXt2bz1VAmAGT
         jXVb85i/19wWwHpTh0udfyqVbNSa3PS1df7cMwDdop4MKOgE4KhTLJYdEolo4rCzv32N
         A7JU2RV0GMbxJxqATOJh/iDKBRLP33Wtp4g/PiTwR08/7ZDuKu0LCH0gH3LgUjeVfPRq
         vBcjPU1Az3ONI8MCNKj2Kt7AU78On3MK3V2TkDYbCpVyztd0SIBpTsOhiUgst3uLs1Je
         +RgaLxFtIH5nMuMlauPnJwDQj81JJ6Ekym62SvP6FTrYlRjTNvm31QHBKw+b5YQPMmTM
         BSxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=u4lf1PHYRg4zYxbp68UEi0BJs20RNiGheCb8mlcFBus=;
        b=bDpXhZqZdUt7yMxzOiNYosR9E0h9A/JARSxJsFjaH/etKwvzp1jzDEImsvPLSuggLh
         ONapyExthlbvDPB3YWBZUlXb3M8P2Vli0bAJro/WyFeZw3//aXl2SHncIt1XFVDZz+13
         8pwQjTIt0laR0Bt1AK+27GwwYWMpDf6X0knWQuYMiervfM2KbKQXHZ/ih4WBAH7XJIbU
         vIJ8wTVYJofFFW518kio+nd8zjJJY9T4XvzZXZ+mx6TE7+cwU0DmebD5Zlg2hm/L5U7q
         n001Z86ooEmdqEqDmTCV19+YsxikikQ5Kmca6tOn+yvTUSdwdW+SKOBqAtIljRuF7WUv
         HIKw==
X-Gm-Message-State: ANhLgQ0eSknV6QoMk+tyRWap4XJJ1d2rvJ/Cgm4jH7sM8DS9PvjPZFol
        5Do+zYYL5HwsNf6uHKhnTco=
X-Google-Smtp-Source: ADFU+vuNK/wf80tPeiY0tX55OdH6ymGOhYH/1qljmMzS9E4s7VQI4Yn2woSvGGVgOvkrnUjSxFm3Pw==
X-Received: by 2002:a17:90a:1acf:: with SMTP id p73mr6585816pjp.53.1585071467706;
        Tue, 24 Mar 2020 10:37:47 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 26sm15039680pgs.85.2020.03.24.10.37.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Mar 2020 10:37:47 -0700 (PDT)
Subject: [bpf-next PATCH 00/10] ALU32 bounds tracking support 
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 24 Mar 2020 10:37:34 -0700
Message-ID: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds ALU32 signed and unsigned min/max bounds.

The origins of this work is to fix do_refine_retval_range() which before
this series clamps the return value bounds to [0, max]. However, this
is not correct because its possible these functions may return negative
errors so the correct bound is [*MIN, max]. Where *MIN is the signed
and unsigned min values U64_MIN and S64_MIN. And 'max' here is the max
positive value returned by this routine.

Patch 1 changes the do_refine_retval_range() to return the correct bounds
but this breaks existing programs that were depending on the old incorrect
bound. To repair these old programs we add ALU32 bounds to properly track
the return values from these helpers. The ALU32 bounds are needed because
clang realizes these helepers return 'int' type and will use jmp32 ops
with the return value.  With current state of things this does little to
help 64bit bounds and with patch 1 applied will cause many programs to
fail verifier pass. See patch 4 for trace details on how this happens.
 
Patch 2, 3 and 4 do the ALU32 addition in three steps. Patch 2 does some
refactoring and should not have any functional change. Patch 3 is a one
liner to more aggressively do update_reg_bounds for ALU ops. This improves
the bounds for ADD, SUB, MUL cases. Its not clear to me why it was omitted
in the before this so please review. My guess is unlike in bitwise ops
the bounds are good enough usually so it wasn't strictly needed. Patch 4
is the bulk of the changes it adds the new bounds and populates them
through the verifier. Design note, initially a var32 was added but as
pointed out by Alexei and Edward it is not strictly needed so it was
removed here. This worked out nicely.

Patch 5 notes that int return types may have arbitrary bits set in
the upper 32bits of the register. To reflect this we can only put a
bounds on the 32bit subreg so we further tighten the initial work in
patch 1 but changing the return value max bound to the signed 32bit
max bound added in patch 4.

Patches 6 adds a C test case to test_progs which will cause the verifier
to fail if new 32bit and do_refine_retval_range() is incorrect.

Patches 7,8, and 9 fix test cases that broke after refining the return
values from helpers. I attempted to be explicit about each failure and
why we need the change. Patch 7 adds a missing <0 check on a return
value. Its not correct to use return values otherwise in this case. Patches
8 and 9 address error string changes in tests now that we have better
bounds checking.

Patch 10 adds some bounds check tests to ensure bounds checking when
mixing alu32, alu64 and jmp32 ops together.

Thanks to Alexei, Edward, and Daniel for initial feedback it helped clean
this up a lot. That said this is a pretty large rework from initial RFC
so please review.

This is a fix but its really too large to land in bpf tree in an rc7.
We want some time for folks to review this and let the automation tools
fuzz, build test, etc. So pushing at bpf-next if we slip past 5.6 release
we can target bpf tree early in the release cycle.

---

John Fastabend (10):
      bpf: verifier, do_refine_retval_range may clamp umin to 0 incorrectly
      bpf: verifer, refactor adjust_scalar_min_max_vals
      bpf: verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()
      bpf: verifier, do explicit ALU32 bounds tracking
      bpf: verifier, return value is an int in do_refine_retval_range
      bpf: test_progs, add test to catch retval refine error handling
      bpf: test_verifier, bpf_get_stack return value add <0
      bpf: test_verifier, #70 error message updates for 32-bit right shift
      bpf: test_verifier, #65 error message updates for trunc of boundary-cross
      bpf: test_verifier, add alu32 bounds tracking tests


 include/linux/bpf_verifier.h                       |    4 
 include/linux/limits.h                             |    1 
 include/linux/tnum.h                               |   12 
 kernel/bpf/tnum.c                                  |   15 
 kernel/bpf/verifier.c                              | 1625 ++++++++++++++------
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |    5 
 .../selftests/bpf/progs/test_get_stack_rawtp_err.c |   26 
 tools/testing/selftests/bpf/verifier/bounds.c      |   57 +
 .../testing/selftests/bpf/verifier/bpf_get_stack.c |    3 
 9 files changed, 1257 insertions(+), 491 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c

--
Signature
