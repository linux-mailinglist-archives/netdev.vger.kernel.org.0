Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49DA0466BF
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 20:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfFNSAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 14:00:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41486 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbfFNSAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 14:00:35 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 652B481F13;
        Fri, 14 Jun 2019 18:00:29 +0000 (UTC)
Received: from treble.redhat.com (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA8B95D982;
        Fri, 14 Jun 2019 18:00:24 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v2 0/5] x86/bpf: unwinder fixes
Date:   Fri, 14 Jun 2019 12:56:39 -0500
Message-Id: <cover.1560534694.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 14 Jun 2019 18:00:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:

- Simplified the frame pointer fixes - instead of using R12, just
  continue to use RBP for BPF_REG_FP, but use nested frames so the
  unwinder can understand (suggested by David Laight).

- Dropped the AT&T syntax patches for now.  I'm about to disappear for a
  week and I don't have time to argue about whether code readability is
  a good thing.

- I can do the 32-bit version of the fix when I get back.  It should be
  easy enough.

v1 is here:
https://lkml.kernel.org/r/cover.1560431531.git.jpoimboe@redhat.com


Josh Poimboeuf (4):
  objtool: Fix ORC unwinding in non-JIT BPF generated code
  x86/bpf: Move epilogue generation to a dedicated function
  x86/bpf: Fix 64-bit JIT frame pointer usage
  x86/unwind/orc: Fall back to using frame pointers for generated code

Song Liu (1):
  perf/x86: Always store regs->ip in perf_callchain_kernel()

 arch/x86/events/core.c       |  10 +--
 arch/x86/kernel/unwind_orc.c |  26 ++++++--
 arch/x86/net/bpf_jit_comp.c  | 115 +++++++++++++++++++----------------
 kernel/bpf/core.c            |   5 +-
 tools/objtool/check.c        |  16 ++++-
 5 files changed, 107 insertions(+), 65 deletions(-)

-- 
2.20.1

