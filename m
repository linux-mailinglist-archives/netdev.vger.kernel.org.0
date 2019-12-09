Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 183EA1172C1
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfLIRbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:31:49 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40397 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfLIRbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:31:49 -0500
Received: by mail-pj1-f67.google.com with SMTP id s35so6177717pjb.7;
        Mon, 09 Dec 2019 09:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C5b9Uf0GwcHgF5e4Hu2jn/jphfKXR8QqlkLc5ktEGfg=;
        b=R0DMiWmmITpXFdzh6mpq04E2Q0WwhDn2U+6MEj9eH3Oji3lbpC2PI1MVY7zPYRWz6h
         7FORjT0vcuF6Szs09wdad/ixyaHTF2m2jgl9SJtG5P4REhl2mNoVLI44LfdChsY1EkNE
         ybDwEUtLhQT0bb+2BlzraMWr1XlgjlkI9mgquKtGaIMVc7Cvyw9fRYJOEvsX4Fp9zT0a
         h61HzcEp6U6K4JF3Z4uebE77HGj+kx5IRq28G4DmN0VKqkdSXOeb9w+aKY0SoxslunIB
         dlGea1nxMx41HMRweY1LkiYVh1tCKMzru7OVkatGEX0Pip5qBzqTomiW6a6HOEm1ZVOe
         A1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C5b9Uf0GwcHgF5e4Hu2jn/jphfKXR8QqlkLc5ktEGfg=;
        b=S8it4050AX5NRCI5FVMv7Tm2/cdDQ6pFnggblkvt8N14Z3bhMx74H4XOm0XgTfWtNW
         TSGq+3ygbqWGRe8UbGzyvWY3IKRapzS5uM7Qf1oWx7M0QZP5VjT2p95SXRskxcJ8jTsN
         D0umch8HC0VMgsNbBpalZ2uaCXXfVV43sBtr9FdZTH+2//QlgBe55YTj1w2U74jVY9CS
         GThDEzOhVs3rzmG0HljnBgIgsGl4kP6TBkKqdViI0T4y27JMoaGpQzSjlVomXuQgMhd+
         BKH8AMqh4LTsrGMueaC7U1hEQnF5obPm3EWe775zF4E3uZx5tQHfEsm/bQDwHCiMXfCQ
         2AIQ==
X-Gm-Message-State: APjAAAV+oinFcJWCdkl2G83XrBskG0C0DhHrr6VJjqk9wpVOIt5ChDVp
        LZGabMqxWPgYqXCpllqvPVo=
X-Google-Smtp-Source: APXvYqzWxC0EBbOgVhQuUBy/Sisu4ZBPnVmN4PGO9kKjPX6U3FlNELa35UdcgXfXKJm9UNv6AWWA9Q==
X-Received: by 2002:a17:90a:c706:: with SMTP id o6mr165655pjt.82.1575912708506;
        Mon, 09 Dec 2019 09:31:48 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id d23sm54943pfo.176.2019.12.09.09.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 09:31:47 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 0/8] riscv: BPF JIT fix, optimizations and far jumps support
Date:   Mon,  9 Dec 2019 18:31:28 +0100
Message-Id: <20191209173136.29615-1-bjorn.topel@gmail.com>
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

The test_bpf.ko module and test_verifier from selftests pass all tests.

RISC-V is still missing proper kprobe and tracepoint support, so a lot
of BPF selftests cannot be run.


Thanks,
Björn


Björn Töpel (8):
  riscv, bpf: fix broken BPF tail calls
  riscv, bpf: add support for far branching
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
 arch/riscv/net/bpf_jit_comp.c                | 511 +++++++++++--------
 tools/include/uapi/asm/bpf_perf_event.h      |   2 +
 5 files changed, 310 insertions(+), 220 deletions(-)
 create mode 100644 arch/riscv/include/uapi/asm/bpf_perf_event.h

-- 
2.20.1

