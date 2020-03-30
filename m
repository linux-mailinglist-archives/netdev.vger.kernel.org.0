Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763621986A1
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgC3VgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:36:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39561 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728778AbgC3VgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:36:15 -0400
Received: by mail-pf1-f193.google.com with SMTP id k15so4130515pfh.6;
        Mon, 30 Mar 2020 14:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=6C9Ps4Wgq4kpMvAE3jfBU4O8xK980w/qbm+iImGeZEc=;
        b=dvGIIskpU25uN803kj01H8RRSqYc0iawZL5jHOwKlNcR3JmHOESAh2O5oauG3h2WU1
         mzRxeGK+gpMC6xWFXAjf9w8ueJX20QjscBMDt8qZKnGGM0xwJx89K5yhiCP+izbKLI4O
         FyrEAUlFDWi8N/ek2TBa8M95Uz5Iui048f3BEjvcCwXpsHN87gAoLZGSRlTc8UyxLixh
         JZ6FzgMvVKdw/IMPK0986kZAobNKe/b4R1hxnrL5bXMLz7jDcurx1ZzFkesoQqXBTOuK
         F0SEUxXzzaIXfU+ZX0R5tJ1Awz8jdZmNFZp7h7tvMefBIJ+VGDLzPeAJNfB+YFlIi1tM
         1Tjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=6C9Ps4Wgq4kpMvAE3jfBU4O8xK980w/qbm+iImGeZEc=;
        b=L4xJgw0yblRoQttCmd1mJiQBot2X6HQYraiHkbg18+LL8SuPpQ/B21knwNZu8/d4x3
         p8kA523Lh8pLfz0VvJY3kpnp8ONZ8sFhnRxmyHRyOTwsUiJPq0ZzWCSS0b7lHkHIq/gg
         y4/SfzzSCkBMqlQcOOS7PzIW2iuM6wM8xV2Q/A5HDa3P4HPc2iToKKh+KklVUg/wd/sl
         G2kaobpP/cSortlquJ0fOXbFn5LGz8RULHtEaqvlSLiXLPPIadDMjCOFicMktHv80t03
         lrqMfsOMOaBKs4ioy2uEKFCO6QulzjsjqPmGDuaOjzHnYR9pk3eilHgDqvmk5IOjt9/5
         PQVw==
X-Gm-Message-State: ANhLgQ06PnMevcFYt03Vzw+KpChkK8LOa9UpCPFuLZihfPsSd3YI4VgO
        7ewU/VNRGzCZSr6lSVew+AU=
X-Google-Smtp-Source: ADFU+vvB3owtXBll5S+Ftwoeah3bPeYQjHAzlZ3m123k0zzWZ92leCNqd5N5it4s3Fm/ufS+QWHnJQ==
X-Received: by 2002:a63:3e87:: with SMTP id l129mr14256385pga.270.1585604172446;
        Mon, 30 Mar 2020 14:36:12 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r186sm11069966pfc.181.2020.03.30.14.36.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Mar 2020 14:36:11 -0700 (PDT)
Subject: [bpf-next PATCH v2 0/7] ALU32 bounds tracking support
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 30 Mar 2020 14:35:59 -0700
Message-ID: <158560409224.10843.3588655801186916301.stgit@john-Precision-5820-Tower>
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
fail verifier pass. See patch 5 for trace details on how this happens.
 
Patch 2 does the ALU32 addition it adds the new bounds and populates them
through the verifier. Design note, initially a var32 was added but as
pointed out by Alexei and Edward it is not strictly needed so it was
removed here. This worked out nicely.

Patch 3 notes that the refine return value can now also bound the 32-bit
subregister allowing better bouinds tracking in these cases.

Patches 4 adds a C test case to test_progs which will cause the verifier
to fail if new 32bit and do_refine_retval_range() is incorrect.

Patches 5 and 6 fix test cases that broke after refining the return
values from helpers. I attempted to be explicit about each failure and
why we need the change. See patches for details.

Patch 7 adds some bounds check tests to ensure bounds checking when
mixing alu32, alu64 and jmp32 ops together.

Thanks to Alexei, Edward, and Daniel for initial feedback it helped clean
this up a lot.

v2:
  - rebased to bpf-next
  - fixed tnum equals optimization for combining 32->64bits
  - updated patch to fix verifier test correctly
  - updated refine_retval_range to set both s32_*_value and s*_value we
    need both to get better bounds tracking

---

John Fastabend (7):
      bpf: verifier, do_refine_retval_range may clamp umin to 0 incorrectly
      bpf: verifier, do explicit ALU32 bounds tracking
      bpf: verifier, refine 32bit bound in do_refine_retval_range
      bpf: test_progs, add test to catch retval refine error handling
      bpf: test_verifier, bpf_get_stack return value add <0
      bpf: test_verifier, #65 error message updates for trunc of boundary-cross
      bpf: test_verifier, add alu32 bounds tracking tests


 include/linux/bpf_verifier.h                       |    4 
 include/linux/limits.h                             |    1 
 include/linux/tnum.h                               |   12 
 kernel/bpf/tnum.c                                  |   15 
 kernel/bpf/verifier.c                              | 1138 +++++++++++++++-----
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |    5 
 .../selftests/bpf/progs/test_get_stack_rawtp_err.c |   26 
 tools/testing/selftests/bpf/verifier/bounds.c      |   51 +
 .../testing/selftests/bpf/verifier/bpf_get_stack.c |    8 
 9 files changed, 959 insertions(+), 301 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c

--
Signature
