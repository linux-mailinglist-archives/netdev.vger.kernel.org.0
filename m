Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3F31200A6
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfLPJNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:13:53 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38109 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfLPJNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 04:13:53 -0500
Received: by mail-pg1-f195.google.com with SMTP id a33so3325332pgm.5;
        Mon, 16 Dec 2019 01:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vpY7MBXQP9D/muTQHYI2tuNdnNT18mzMK9mr9lmyumc=;
        b=WXf++/PI7Qj1eL7NF3/ysask8jTXfygbq3KmxUxE4Ly3cTk1wkgW9Oh9lRRCCaRqux
         SlKDDtj6aug//loLK7vPWhfbUKbw0Pw0jawhDC8jAVB6/2TUptn1mXUtLZEDTIQPyHCt
         yUBIez9eXZJVQPXdOBicsnh8u5wBSTHcmooFYg8N0xFyCxaraVtG3iAxOETh+JzC70ah
         vdVeV4rDnqq2ZLIlovXlRf7hLcU7HDnTqJy1/oowuIjgyyRPsMALcKMJcDhoD7i2pdTU
         nYu/fmY7k28qZC3zNCm09EUnRGlMRGUij0DNVh6EIeHfVTFF5OFYhe9t4FlmgbRiAvs6
         aNlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vpY7MBXQP9D/muTQHYI2tuNdnNT18mzMK9mr9lmyumc=;
        b=giB4Kz4OyBRcKtsTs8H6cabtiYKASf1aCiAqGGP3T6TWqvJ2rI281nySZXVmgoxjfI
         AXAu3IeC2NnjFxuBFG0bNc97unVFsoRP5pJ4zcB9qXpDAnqkRs8Ah+4CIJaysBRGuq1n
         dEnGlYca71G0tF5IF9qs8eOyyFQVlEq0it/b9Yvsi7nRE42uoG1wvuskvPRZCWmVgmIy
         CTsMiGDud8cRLCNKQbRqUJLeQnEoftdydT5j8FDem4OdxsiQe+gpYINNQx2E2Pt4DErD
         0mXHXiUj/AwJ6FTdWJgfJtEdAy1csdQLl1HRegSXFmBo6DhCkFKzOKcto+qEpxy1Zdf6
         Qe8w==
X-Gm-Message-State: APjAAAVMURxsCKLdS6nV1OnYFcTznhF9ilBWwuESmknLi0TpEbCW+bL/
        Vldy5B+P23EJmZ7zSxFXulY=
X-Google-Smtp-Source: APXvYqzaZ3jJM3dOls1Pof33GJoVy83OTL34tNJngEBHjYW5m38n1ijiIvLP4nD5pePW34rW+GPiFQ==
X-Received: by 2002:a63:364d:: with SMTP id d74mr16898806pga.408.1576487632409;
        Mon, 16 Dec 2019 01:13:52 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id x21sm12505033pfn.164.2019.12.16.01.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 01:13:51 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 0/9] riscv: BPF JIT fix, optimizations and far jumps support
Date:   Mon, 16 Dec 2019 10:13:34 +0100
Message-Id: <20191216091343.23260-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This series contain one non-critical fix, support for far jumps. and
some optimizations for the BPF JIT.

Previously, the JIT only supported 12b branch targets for conditional
branches, and 21b for unconditional branches. Starting with this
series, 32b branching is supported.

As part of supporting far jumps, branch relaxation was introduced. The
idea is to start with a pessimistic jump (e.g. auipc/jalr) and for
each pass the JIT will have an opportunity to pick a better
instruction (e.g. jal) and shrink the image. Instead of two passes,
the JIT requires more passes. It typically converges after 3 passes.

The optimizations mentioned in the subject are for calls and tail
calls. In the tail call generation we can save one instruction by
using the offset in jalr. Calls are optimized by doing (auipc)/jal(r)
relative jumps instead of loading the entire absolute address and
doing jalr. This required that the JIT image allocator was made RISC-V
specific, so we can ensure that the JIT image and the kernel text are
in range (32b).

The last two patches of the series is not critical to the series, but
are two UAPI build issues for BPF events. A closer look from the
RV-folks would be much appreciated.

The test_bpf.ko module, selftests/bpf/test_verifier and
selftests/seccomp/seccomp_bpf pass all tests.

RISC-V is still missing proper kprobe and tracepoint support, so a lot
of BPF selftests cannot be run.


Thanks,
Björn

v1->v2: [1]
 * Removed unused function parameter from emit_branch()
 * Added patch to support far branch in tail call emit

[1] https://lore.kernel.org/bpf/20191209173136.29615-1-bjorn.topel@gmail.com/


Björn Töpel (9):
  riscv, bpf: fix broken BPF tail calls
  riscv, bpf: add support for far branching
  riscv, bpf: add support for far branching when emitting tail call
  riscv, bpf: add support for far jumps and exits
  riscv, bpf: optimize BPF tail calls
  riscv, bpf: provide RISC-V specific JIT image alloc/free
  riscv, bpf: optimize calls
  riscv, bpf: add missing uapi header for BPF_PROG_TYPE_PERF_EVENT
    programs
  riscv, perf: add arch specific perf_arch_bpf_user_pt_regs

 arch/riscv/include/asm/perf_event.h          |   4 +
 arch/riscv/include/asm/pgtable.h             |   4 +
 arch/riscv/include/uapi/asm/bpf_perf_event.h |   9 +
 arch/riscv/net/bpf_jit_comp.c                | 531 ++++++++++---------
 tools/include/uapi/asm/bpf_perf_event.h      |   2 +
 5 files changed, 312 insertions(+), 238 deletions(-)
 create mode 100644 arch/riscv/include/uapi/asm/bpf_perf_event.h

-- 
2.20.1

