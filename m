Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201023652DE
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 09:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhDTHIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 03:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229843AbhDTHIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 03:08:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E8B261220;
        Tue, 20 Apr 2021 07:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618902493;
        bh=DOW/KsRt5H6t1Pgz46XK8iIY+rilYGODWaTzp+KKVBg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bGeMIcK4oyaw9PKWK4LZfywrca9QFox2DwtXtJf3Rpcw/1K0zEYwkxTvdm9Wy2p/k
         6FGb/yaJGmnEbuwRVwyZQkwjZldF6m9tFCT+KATXFY8IrIR886CLL8liQSNzWyh2yw
         iJSJjHp3Z+yxDM9fPgaOfcQdSbHoO+TCqiHV+U8+DlXk0kyo+sveadEsfFEWKESyT3
         JVcLzmur1EbwKBuEBrxveDtDEWusqRL4P/EY4pV14VHKqTqzeLRn2qWiYT9IAC9QW1
         bErddbD2N2wX+mbwamKuFEVf0NAPJ+BT3maEQ6dNvAXY5/xnZvWRUHB1OYwLit78CN
         d989R9HQVE2fA==
Received: by mail-wm1-f49.google.com with SMTP id y204so18099109wmg.2;
        Tue, 20 Apr 2021 00:08:13 -0700 (PDT)
X-Gm-Message-State: AOAM533Qqa5ol86S8ezf9zHdovf6eLUUl4dmm3NXOBrf0cc0ineN5Cby
        jP7z2BR+9sRQYcp1k/O77a/Y1XxIZcHV6dWXzsA=
X-Google-Smtp-Source: ABdhPJzw8YTyu5KshxUEZlu3irZnfAegvQ8VILMGpH1RGSIFiQhsKgjG1gjcqz1I3fFsHj1Q1aLjZg7NWbZtj6Nq3DE=
X-Received: by 2002:a7b:c14a:: with SMTP id z10mr2758133wmi.75.1618902491684;
 Tue, 20 Apr 2021 00:08:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210416230724.2519198-1-willy@infradead.org> <20210416230724.2519198-2-willy@infradead.org>
 <20210417024522.GP2531743@casper.infradead.org> <9f99b0a0-f1c1-f3b0-5f84-3a4bfc711725@synopsys.com>
 <20210420031029.GI2531743@casper.infradead.org>
In-Reply-To: <20210420031029.GI2531743@casper.infradead.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 20 Apr 2021 09:07:55 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0KUwf1Z0bHiUaHC2nHztevkxg5_FBSzHddNeSsBayWUA@mail.gmail.com>
Message-ID: <CAK8P3a0KUwf1Z0bHiUaHC2nHztevkxg5_FBSzHddNeSsBayWUA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "mcroce@linux.microsoft.com" <mcroce@linux.microsoft.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "hch@lst.de" <hch@lst.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 5:10 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Tue, Apr 20, 2021 at 02:48:17AM +0000, Vineet Gupta wrote:
> > > 32-bit architectures which expect 8-byte alignment for 8-byte integers
> > > and need 64-bit DMA addresses (arc, arm, mips, ppc) had their struct
> > > page inadvertently expanded in 2019.
> >
> > FWIW, ARC doesn't require 8 byte alignment for 8 byte integers. This is
> > only needed for 8-byte atomics due to the requirements of LLOCKD/SCOND
> > instructions.
>
> Ah, like x86?  OK, great, I'll drop your arch from the list of
> affected.  Thanks!

I mistakenly assumed that i386 and m68k were the only supported
architectures with 32-bit alignment on u64. I checked it now and found

$ for i in /home/arnd/cross/x86_64/gcc-10.1.0-nolibc/*/bin/*-gcc ; do
echo `echo 'int a = __alignof__(long long);' | $i -xc - -Wall -S -o- |
grep -A1 a: | tail -n 1 | cut -f 3 -d\   `
${i#/home/arnd/cross/x86_64/gcc-10.1.0-nolibc/*/bin/} ; done
8 aarch64-linux-gcc
8 alpha-linux-gcc
4 arc-linux-gcc
8 arm-linux-gnueabi-gcc
8 c6x-elf-gcc
4 csky-linux-gcc
4 h8300-linux-gcc
8 hppa-linux-gcc
8 hppa64-linux-gcc
8 i386-linux-gcc
8 ia64-linux-gcc
2 m68k-linux-gcc
4 microblaze-linux-gcc
8 mips-linux-gcc
8 mips64-linux-gcc
8 nds32le-linux-gcc
4 nios2-linux-gcc
4 or1k-linux-gcc
8 powerpc-linux-gcc
8 powerpc64-linux-gcc
8 riscv32-linux-gcc
8 riscv64-linux-gcc
8 s390-linux-gcc
4 sh2-linux-gcc
4 sh4-linux-gcc
8 sparc-linux-gcc
8 sparc64-linux-gcc
8 x86_64-linux-gcc
8 xtensa-linux-gcc

which means that half the 32-bit architectures do this. This may
cause more problems when arc and/or microblaze want to support
64-bit kernels and compat mode in the future on their latest hardware,
as that means duplicating the x86 specific hacks we have for compat.

What is alignof(u64) on 64-bit arc?

      Arnd
