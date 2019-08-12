Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1A98AA0C
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfHLVxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:53:17 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:42678 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727699AbfHLVxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:53:15 -0400
Received: by mail-pf1-f202.google.com with SMTP id 21so67094957pfu.9
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YgAdSQNQK5RRSuTOz4Q5BGZbFQj3edcVyfEz3s8S5aQ=;
        b=hNh20e8yVAqhC501qgqcjuQ0i5LsaslXsipm2xAXWGnGb/fVTvbBs56+3cEF/4psbR
         vd+aCLC8rkY0yc37yiOqygu9ZiNGRR6yarB4fkirGOAro8tg2cx8l93sIAGipAPn8rZo
         HCBTocL9vCapv5MkLz3aRzLVqG6tLK/eqcKOcHnzb8MhSx9FfSetfZt/RkQ10zrbmys3
         5fVjDE57BoEhumHZ486AxaQU/nRIAyC++wlcT+r7wHIRC7tZzttTgf64G4KSFgsl6OQi
         5kx9DR6BodIyaY71IWmvZSGc+LNmiqGmQZz0j35b68tXi7pnbaeiUp/z0XYqTyP+Z0HA
         pvBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YgAdSQNQK5RRSuTOz4Q5BGZbFQj3edcVyfEz3s8S5aQ=;
        b=Kj4wtBCE4/smh84epwnFxCWc6SnoCS2a0Z9PM/Y6z69WYhPse3lQBxPUVpDMbmRS9N
         WuGAqNRchQGFx/UDckP6KaBi4+jeL9lw7Og5dcyUU5i8mrBYujXAroS+JCjNQrJx/IA8
         mEUmZ+Iaj8nLPxht4XmTdBX3q923aZZVDCjozjw0VfHh98kCsIswi8LCoRSMQpXIDbF9
         7hEp96o7Fi9flX32F6rc6BJX7CHYOx0Kzxbfu6K63Kjgf9r5NTD9W6Mv2Zojbk7vyBOC
         R86iMH/polnqPGFRnEVdJr6fjS3Gh7t4ixDyUiOQZ0j5TipQFnUKbApF7J3hwz4guBGf
         lP6A==
X-Gm-Message-State: APjAAAWUZBPGOihLJ5rO7a7rrCpP+mtrqSOoaEFCBWOAgJjaE9AxJUXm
        ODXjIfsi0ZquvLKKlSUKOWXUDaIxuibsWIjhO48=
X-Google-Smtp-Source: APXvYqzuPe5shinEGeMAlq/vxb2lm76ce6O1V98lxpu8cB801lah02QJsTdeJ8g1XyzdySS5v59I+RjN9L3C7txvZ7M=
X-Received: by 2002:a63:f94c:: with SMTP id q12mr31466728pgk.10.1565646794664;
 Mon, 12 Aug 2019 14:53:14 -0700 (PDT)
Date:   Mon, 12 Aug 2019 14:50:50 -0700
In-Reply-To: <20190812215052.71840-1-ndesaulniers@google.com>
Message-Id: <20190812215052.71840-17-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH 00/16] treewide: prefer __section from compiler_attributes.h
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     akpm@linux-foundation.org
Cc:     sedat.dilek@gmail.com, jpoimboe@redhat.com, yhs@fb.com,
        miguel.ojeda.sandonis@gmail.com,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC unescapes escaped string section names while Clang does not. Because
__section uses the `#` stringification operator for the section name, it
doesn't need to be escaped.

This fixes an Oops observed in distro's that use systemd and not
net.core.bpf_jit_enable=1, when their kernels are compiled with Clang.

Instead, we should:
1. Prefer __section(.section_name_no_quotes).
2. Only use __attribute__((__section(".section"))) when creating the
section name via C preprocessor (see the definition of __define_initcall
in arch/um/include/shared/init.h).

This antipattern was found with:
$ grep -e __section\(\" -e __section__\(\" -r

See the discussions in:
https://bugs.llvm.org/show_bug.cgi?id=42950
https://marc.info/?l=linux-netdev&m=156412960619946&w=2

Nick Desaulniers (16):
  s390/boot: fix section name escaping
  arc: prefer __section from compiler_attributes.h
  parisc: prefer __section from compiler_attributes.h
  um: prefer __section from compiler_attributes.h
  sh: prefer __section from compiler_attributes.h
  ia64: prefer __section from compiler_attributes.h
  arm: prefer __section from compiler_attributes.h
  mips: prefer __section from compiler_attributes.h
  sparc: prefer __section from compiler_attributes.h
  powerpc: prefer __section and __printf from compiler_attributes.h
  x86: prefer __section from compiler_attributes.h
  arm64: prefer __section from compiler_attributes.h
  include/asm-generic: prefer __section from compiler_attributes.h
  include/linux: prefer __section from compiler_attributes.h
  include/linux/compiler.h: remove unused KENTRY macro
  compiler_attributes.h: add note about __section

 arch/arc/include/asm/linkage.h        |  8 +++----
 arch/arc/include/asm/mach_desc.h      |  3 +--
 arch/arm/include/asm/cache.h          |  2 +-
 arch/arm/include/asm/mach/arch.h      |  4 ++--
 arch/arm/include/asm/setup.h          |  2 +-
 arch/arm64/include/asm/cache.h        |  2 +-
 arch/arm64/kernel/smp_spin_table.c    |  2 +-
 arch/ia64/include/asm/cache.h         |  2 +-
 arch/mips/include/asm/cache.h         |  2 +-
 arch/parisc/include/asm/cache.h       |  2 +-
 arch/parisc/include/asm/ldcw.h        |  2 +-
 arch/powerpc/boot/main.c              |  3 +--
 arch/powerpc/boot/ps3.c               |  6 ++----
 arch/powerpc/include/asm/cache.h      |  2 +-
 arch/powerpc/kernel/btext.c           |  2 +-
 arch/s390/boot/startup.c              |  2 +-
 arch/sh/include/asm/cache.h           |  2 +-
 arch/sparc/include/asm/cache.h        |  2 +-
 arch/sparc/kernel/btext.c             |  2 +-
 arch/um/kernel/um_arch.c              |  6 +++---
 arch/x86/include/asm/cache.h          |  2 +-
 arch/x86/include/asm/intel-mid.h      |  2 +-
 arch/x86/include/asm/iommu_table.h    |  5 ++---
 arch/x86/include/asm/irqflags.h       |  2 +-
 arch/x86/include/asm/mem_encrypt.h    |  2 +-
 arch/x86/kernel/cpu/cpu.h             |  3 +--
 include/asm-generic/error-injection.h |  2 +-
 include/asm-generic/kprobes.h         |  5 ++---
 include/linux/cache.h                 |  6 +++---
 include/linux/compiler.h              | 31 ++++-----------------------
 include/linux/compiler_attributes.h   | 10 +++++++++
 include/linux/cpu.h                   |  2 +-
 include/linux/export.h                |  2 +-
 include/linux/init_task.h             |  4 ++--
 include/linux/interrupt.h             |  5 ++---
 include/linux/sched/debug.h           |  2 +-
 include/linux/srcutree.h              |  2 +-
 37 files changed, 62 insertions(+), 83 deletions(-)

-- 
2.23.0.rc1.153.gdeed80330f-goog

