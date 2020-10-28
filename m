Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F16F29E060
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgJ1WE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:04:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729508AbgJ1WCX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:02:23 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA850247F5;
        Wed, 28 Oct 2020 17:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603905313;
        bh=FsmcOn0XxpUX5de9S0UmGY+4ZGOqbW4cCRPICKIXKI4=;
        h=From:To:Cc:Subject:Date:From;
        b=NF6yHpW3jDsvWT6SJd9HhXl7b6oqz9sIEwd04rVK4NSy14dPU/rkmGH6SIv1YrILN
         2gNIEFCQsug2/rZ1HaJlj57elsl5UcgBaYU4petFMPCGb7JZOhmYkhIDcuqzQ06lzI
         B+TZ0wVcZ2fGIg/Q7v0lAo6dKYN2geM0EFiiH28c=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, arnd@arndb.de,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 0/2] get rid of GCC __attribute__((optimize)) for BPF
Date:   Wed, 28 Oct 2020 18:15:04 +0100
Message-Id: <20201028171506.15682-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a followup to [0]:
[PATCH] bpf: don't rely on GCC __attribute__((optimize)) to disable GCSE[0]

Changes since v1:
- only use -fno-gcse when CONFIG_BPF_JIT_ALWAYS_ON=y and CONFIG_CC_IS_GCC=y
  (but ignore CONFIG_RETPOLINE since we want to avoid GCSE in all cases)
- to avoid potential impact of disabling GCSE on other code, put the
  interpreter in a separate file (patch #2)

Note that patch #1 is intended for backporting, as function scope GCC
optimization attributes are really quite broken.

I don't have a strong opinion on whether the interpreter code should be
split off or not, but it looks like it can be done fairly painlessly,
so it is probably a good idea to do it anyway.

[0] https://lore.kernel.org/bpf/20201027205723.12514-1-ardb@kernel.org/

Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kees Cook <keescook@chromium.org>

Ard Biesheuvel (2):
  bpf: don't rely on GCC __attribute__((optimize)) to disable GCSE
  bpf: move interpreter into separate source file

 include/linux/compiler-gcc.h   |   2 -
 include/linux/compiler_types.h |   4 -
 include/linux/filter.h         |   1 +
 kernel/bpf/Makefile            |   7 +-
 kernel/bpf/core.c              | 567 ------------------
 kernel/bpf/interp.c            | 601 ++++++++++++++++++++
 6 files changed, 607 insertions(+), 575 deletions(-)
 create mode 100644 kernel/bpf/interp.c

-- 
2.17.1

