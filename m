Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3701BBBA6
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 12:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgD1Ky6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 06:54:58 -0400
Received: from conssluserg-02.nifty.com ([210.131.2.81]:58652 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgD1Ky5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 06:54:57 -0400
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id 03SAsVHb003792;
        Tue, 28 Apr 2020 19:54:32 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 03SAsVHb003792
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1588071272;
        bh=DvrztLqXLwkbKNNvyyk2abuZyw9KD3WysD/ymL0dSlo=;
        h=From:Date:Subject:To:Cc:From;
        b=0+eg9Pz4cSPuuuYL5OaMKEHPLF3ndT585dZIguWqvUVUgg0s8Y08uKoc1hdoxLiQt
         xnDnQg4V4pJ1HY8c5NcAANuGYNFIzYoxa9otb+ya3VIoK6SkJJkXKb4/UiAlDtibJT
         b4V4VoQzvJ3A/kDfGf28XS/+ci8c6M98KS4IZQ1R3yrRXeNLjF3MHT2nwE9NIocn+H
         7dTo1ai5S4lQ1vpeg8HrugJ9kNo3nx/IPbtkDQYzCobX+QmmtsYg+9FqUqJmoYl1E4
         e6XdOxt6LAAVHG65EaTdIWYpWTcqqw6azujYzp5R/Dc4fWV3Q8EOqz4JS5W+/tzErs
         wpWVD2WyGSDAg==
X-Nifty-SrcIP: [209.85.222.47]
Received: by mail-ua1-f47.google.com with SMTP id y10so20859322uao.8;
        Tue, 28 Apr 2020 03:54:32 -0700 (PDT)
X-Gm-Message-State: AGi0PuaZdmCJ/f56iHEqFOee4eQf28ta8iNhuTbzq+mIEE9ztCJIK+YP
        OKs/TkAK6GJ531ZEjCwoGVv3YDL7TMkX7wAT8JI=
X-Google-Smtp-Source: APiQypJxccn14dWrLYyUjBNE7+Sl1to9kyCFhKc2cnk+3tpYrY7twjdkGUBmpY5DTHLfyUqOVbeB4mLIwmxvUKTv2hI=
X-Received: by 2002:a05:6102:240f:: with SMTP id j15mr21176730vsi.155.1588071270835;
 Tue, 28 Apr 2020 03:54:30 -0700 (PDT)
MIME-Version: 1.0
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 28 Apr 2020 19:53:55 +0900
X-Gmail-Original-Message-ID: <CAK7LNARHd0DXRLONf6vH_ghsYZjzoduzkixqNDpVqqPx0yHbHg@mail.gmail.com>
Message-ID: <CAK7LNARHd0DXRLONf6vH_ghsYZjzoduzkixqNDpVqqPx0yHbHg@mail.gmail.com>
Subject: BPFilter: bit size mismatch between bpfiter_umh and vmliux
To:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi.

I have a question about potential bit size
mismatch between vmlinux and bpfilter_umh.


net/bpfilter/bpfilter_umh is compiled for the
default machine bit of the compiler.
This may not match to the kernel bit size.


This happens in the following scenario.

GCC can be compiled as bi-arch.
If you use GCC that defaults to 64-bit,
you can give -m32 flag to produce the 32 bit code.

When you build the kernel for 32-bit, -m32 is
properly passed for building the kernel space objects.
However, it is missing while building the userspace
objects for bpfilter_umh.


For example, my build host is x86_64 Ubuntu.

If I build the kernel for i386
with CONFIG_BPFILTER_UMH=y,
the embedded bpfilter_umh is 64bit ELF.

You can reproduce it by the following command on the
mainline kernel.

masahiro@oscar:~/ref/linux$ make ARCH=i386 defconfig
masahiro@oscar:~/ref/linux$ scripts/config -e BPFILTER
masahiro@oscar:~/ref/linux$ scripts/config -e BPFILTER_UMH
masahiro@oscar:~/ref/linux$ make $(nproc) ARCH=i386
   ...
masahiro@oscar:~/ref/linux$ file vmlinux
vmlinux: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV),
statically linked,
BuildID[sha1]=7ac691c67b4fe9b0cd46b45a2dc2d728d7d87686, not stripped
masahiro@oscar:~/ref/linux$ file net/bpfilter/bpfilter_umh
net/bpfilter/bpfilter_umh: ELF 64-bit LSB executable, x86-64, version
1 (GNU/Linux), statically linked,
BuildID[sha1]=baf1ffe26f4c030a99a945fc22924c8c559e60ac, for GNU/Linux
3.2.0, not stripped




At least, the build was successful,
but does this work at runtime?

If this is a bug, I can fix it cleanly.

I think the bit size of the user mode helper
should match to the kernel bit size. Is this correct?


I noticed this while I was working on userspace
build cleanups.
https://patchwork.kernel.org/patch/11505207/


-- 
Best Regards
Masahiro Yamada
