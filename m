Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F1C439D6
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388584AbfFMPQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:16:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24399 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732202AbfFMNXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 09:23:44 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A719D30C31B9;
        Thu, 13 Jun 2019 13:23:33 +0000 (UTC)
Received: from treble.redhat.com (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E41F3537B3;
        Thu, 13 Jun 2019 13:23:27 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: [PATCH 0/9] x86/bpf: unwinder fixes
Date:   Thu, 13 Jun 2019 08:20:57 -0500
Message-Id: <cover.1560431531.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 13 Jun 2019 13:23:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commit

  d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")

was a step in the right direction, but it triggered some BPF selftest
failures.  That commit exposed the fact that we currently can't unwind
through BPF code.

- Patch 1 (originally from Song Liu) fixes a bug in the above commit
  (regs->ip getting skipped in the stack trace).

- Patch 2 fixes non-JIT BPF for the ORC unwinder.

- Patches 3-5 are preparatory improvements for patch 6.

- Patch 6 fixes JIT BPF for the FP unwinder.

- Patch 7 fixes JIT BPF for the ORC unwinder (building on patch 6).

- Patches 8-9 are some readability cleanups.


Josh Poimboeuf (8):
  objtool: Fix ORC unwinding in non-JIT BPF generated code
  x86/bpf: Move epilogue generation to a dedicated function
  x86/bpf: Simplify prologue generation
  x86/bpf: Support SIB byte generation
  x86/bpf: Fix JIT frame pointer usage
  x86/unwind/orc: Fall back to using frame pointers for generated code
  x86/bpf: Convert asm comments to AT&T syntax
  x86/bpf: Convert MOV function/macro argument ordering to AT&T syntax

Song Liu (1):
  perf/x86: Always store regs->ip in perf_callchain_kernel()

 arch/x86/events/core.c       |  10 +-
 arch/x86/kernel/unwind_orc.c |  26 ++-
 arch/x86/net/bpf_jit_comp.c  | 355 ++++++++++++++++++++---------------
 kernel/bpf/core.c            |   5 +-
 tools/objtool/check.c        |  16 +-
 5 files changed, 246 insertions(+), 166 deletions(-)

-- 
2.20.1

