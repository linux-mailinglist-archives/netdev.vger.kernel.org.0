Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA8B191FD8
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 04:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgCYDuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 23:50:32 -0400
Received: from conssluserg-06.nifty.com ([210.131.2.91]:59891 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgCYDuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 23:50:32 -0400
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id 02P3oNDZ010002;
        Wed, 25 Mar 2020 12:50:24 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 02P3oNDZ010002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585108224;
        bh=B51d25RhLVLUEBZV9KWWRN6tXxZV+Ex93ixb/7dltgg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Le7+OZ8u8HnRmAwzMt4fHQZedJ35wfYmXP2hGXWJKEK8YjSO3HsHPDSNXh8GWcbCZ
         qY8bddsN3m6MekkNLlj5yVU/clWjII23lFn6ZEpSFbFKuilzM1Pva8yYoA63f2lv/A
         pLTtVDaRtEYnG5E2kmbzo6alZcoRTePRHoP9UcUQ97YL6w099Ve9ktMbTPVZk1Uav+
         bQMRCVRL4ls/dY9vFMZQxqIpobL3VuEsYapC5Ws0YKEQBGJ/w5uied1rn4Fh3ALYFP
         bLE9jbvCVfQWlnFeAteYO3FLQclv/oILidEZAHvWInDTkourXLCwVNSHOkphHMZETo
         DK80A4KP0GG4g==
X-Nifty-SrcIP: [209.85.221.171]
Received: by mail-vk1-f171.google.com with SMTP id t3so303920vkm.10;
        Tue, 24 Mar 2020 20:50:24 -0700 (PDT)
X-Gm-Message-State: ANhLgQ066tFI8VZJWFChRXfmw5Q6R1bZirzuw4ZMz+dPSZ2b7aMhtaSE
        d76h81106MhepOQAsTnhmX72SbJJ14xaJt9oPxQ=
X-Google-Smtp-Source: ADFU+vugUnmkSvll3RiJFbA2FTdNiomZtU7A9mupdJ/HuYxSm4m6xNGGuElIsoiBxSJi+JrdbLShk+BTp4vuo97bNMI=
X-Received: by 2002:a1f:32cf:: with SMTP id y198mr781430vky.96.1585108223131;
 Tue, 24 Mar 2020 20:50:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200324161539.7538-1-masahiroy@kernel.org> <CAMuHMdWPNFRhUVGb0J27MZg2CrWWm06N9OQjQsGLMZkNXJktAg@mail.gmail.com>
In-Reply-To: <CAMuHMdWPNFRhUVGb0J27MZg2CrWWm06N9OQjQsGLMZkNXJktAg@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Wed, 25 Mar 2020 12:49:46 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQFbcfK=q4eYW_dQUqe-sqbjpxSpQBeCkp0Vr4P3HJc7A@mail.gmail.com>
Message-ID: <CAK7LNAQFbcfK=q4eYW_dQUqe-sqbjpxSpQBeCkp0Vr4P3HJc7A@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: wan: wanxl: use $(CC68K) instead of $(AS68K) for
 rebuilding firmware
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-kbuild <linux-kbuild@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 2:47 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Yamada-san,
>
> On Tue, Mar 24, 2020 at 5:17 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> > As far as I understood from the Kconfig help text, this build rule is
> > used to rebuild the driver firmware, which runs on the QUICC, m68k-based
> > Motorola 68360.
> >
> > The firmware source, wanxlfw.S, is currently compiled by the combo of
> > $(CPP) and $(AS68K). This is not what we usually do for compiling *.S
> > files. In fact, this is the only user of $(AS) in the kernel build.
> >
> > Moreover, $(CPP) is not likely to be a m68k tool because wanxl.c is a
> > PCI driver, but CONFIG_M68K does not select CONFIG_HAVE_PCI.
> > Instead of combining $(CPP) and (AS) from different tool sets, using
> > single $(CC68K) seems simpler, and saner.
> >
> > After this commit, the firmware rebuild will require cc68k instead of
> > as68k. I do not know how many people care about this, though.
> >
> > I do not have cc68k/ld68k in hand, but I was able to build it by using
> > the kernel.org m68k toolchain. [1]
>
> Would this work with a "standard" m68k-linux-gnu-gcc toolchain, like
> provided by Debian/Ubuntu, too?
>

Yes, I did 'sudo apt install gcc-8-m68k-linux-gnu'
It successfully compiled this firmware.

In my understanding, the difference is that
the kernel.org ones lack libc,
so cannot link userspace programs.

They do not make much difference for this case.

-- 
Best Regards
Masahiro Yamada
