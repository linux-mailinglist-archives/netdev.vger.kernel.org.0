Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5D2413A91
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 21:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbhIUTPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 15:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhIUTPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 15:15:34 -0400
Received: from wp441.webpack.hosteurope.de (wp441.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:85d2::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B09C061574;
        Tue, 21 Sep 2021 12:14:05 -0700 (PDT)
Received: from [2a03:7846:b79f:101:21c:c4ff:fe1f:fd93] (helo=valdese.nms.ulrich-teichert.org); authenticated
        by wp441.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1mSlDF-000156-KC; Tue, 21 Sep 2021 21:13:53 +0200
Received: from valdese.nms.ulrich-teichert.org (localhost [127.0.0.1])
        by valdese.nms.ulrich-teichert.org (8.15.2/8.15.2/Debian-8+deb9u1) with ESMTPS id 18LJDp1x031137
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 21:13:52 +0200
Received: (from ut@localhost)
        by valdese.nms.ulrich-teichert.org (8.15.2/8.15.2/Submit) id 18LJDnXp031134;
        Tue, 21 Sep 2021 21:13:49 +0200
Message-Id: <202109211913.18LJDnXp031134@valdese.nms.ulrich-teichert.org>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
To:     torvalds@linux-foundation.org (Linus Torvalds)
Date:   Tue, 21 Sep 2021 21:13:49 +0200 (CEST)
Cc:     krypton@ulrich-teichert.org (Ulrich Teichert),
        mcree@orcon.net.nz (Michael Cree),
        linux@roeck-us.net (Guenter Roeck),
        rth@twiddle.net (Richard Henderson),
        ink@jurassic.park.msu.ru (Ivan Kokshaysky),
        mattst88@gmail.com (Matt Turner),
        James.Bottomley@hansenpartnership.com (James E . J . Bottomley),
        deller@gmx.de (Helge Deller),
        davem@davemloft.net (David S . Miller),
        kuba@kernel.org (Jakub Kicinski),
        linux-alpha@vger.kernel.org (alpha),
        geert@linux-m68k.org (Geert Uytterhoeven),
        linux-kernel@vger.kernel.org (Linux Kernel Mailing List),
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org (Netdev),
        linux-sparse@vger.kernel.org (Sparse Mailing-list)
In-Reply-To: <CAHk-=wibRWoy4-ZkSVXUoGsUw5wKovPvRhS7r6VM+_GeBYZw1A@mail.gmail.com>
From:   Ulrich Teichert <krypton@ulrich-teichert.org>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;ut@ulrich-teichert.org;1632251645;99896d52;
X-HE-SMSGID: 1mSlDF-000156-KC
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

[del]
> > The main trouble is that my system has only 64MB of memory and the smallest
> > kernel image with all drivers I need was about 105MB big.
> 
> Are you sure you aren't looking at some debug image?
> 
> I just tried building something based on your Jensen config (lots of
> new questions, you sent your old config from 4.18.0-rc5 time), and I
> get
> 
>   [torvalds@ryzen linux]$ ll -h arch/alpha/boot/vmlinux*
>   -rwxr-xr-x. 1 torvalds torvalds 5.4M Sep 20 11:32 arch/alpha/boot/vmlinux
>   -rw-r--r--. 1 torvalds torvalds 2.3M Sep 20 11:32 arch/alpha/boot/vmlinux.gz
> 
> so yeah, it's not exactly tiny, but at 5.4MB it's certainly not 105MB.

Right, I had DEBUG_INFO set. Stupid me. Now it looks much better:

valdese:~/soft/linux/kernel-git> ls -lh arch/alpha/boot/vmlinux*
-rwxr-xr-x 1 ut ut 6.4M Sep 21 18:12 arch/alpha/boot/vmlinux*
-rw-r--r-- 1 ut ut 3.0M Sep 21 18:12 arch/alpha/boot/vmlinux.gz

But it still dies before the first message from the kernel shows up.

[del]
> It would be very interesting to hear whether this all still boots. I
> do think people still occasionally boot-test some other alpha
> configurations, but maybe not.

I'm sure that other Alpha configurations are still working, but the
Jensen is a bit special. So far I know it's the only Alpha which needs
aboot and not milo as second stage bootloader. aboot itself seems to
be OK, as I can boot the ancient kernel just fine, but when I'm trying
to boot other kernels, I'm coming as far as:

aboot: loading compressed vmlinux-5-15-rc2

and that's it. I don't think I have to do something special with the
compressed image and according to https://tldp.org/HOWTO/SRM-HOWTO/aboot.html
I don't have to. But why do I have the feeling I am doing something
fundamentally wrong? Was there something with a different kernel
jumping in point or a special build option? I remember something like
that, but can't grasp it nor find it on the web.

I would try the SRM bootimage (make bootimage), but the build is broken:

valdese:~/soft/linux/kernel-git> make -j8 ARCH=alpha CROSS_COMPILE=alpha-linux- bootimage
...
  SYSMAP  System.map
  AS      arch/alpha/boot/head.o
  CC      arch/alpha/boot/stdio.o
  HOSTCC  arch/alpha/boot/tools/objstrip
arch/alpha/boot/stdio.c: In function ‘vsprintf’:
arch/alpha/boot/stdio.c:249:10: warning: this statement may fall through [-Wimplicit-fallthrough=]
    flags |= LARGE;
          ^
arch/alpha/boot/stdio.c:250:3: note: here
   case 'x':
   ^~~~
arch/alpha/boot/tools/objstrip.c: In function ‘main’:
arch/alpha/boot/tools/objstrip.c:151:36: warning: implicit declaration of function ‘str_has_prefix’ [-Wimplicit-function-declaration]
     if (elf->e_ident[0] == 0x7f && str_has_prefix((char *)elf->e_ident + 1, "ELF")) {
                                    ^~~~~~~~~~~~~~
arch/alpha/boot/tools/objstrip.c:191:52: warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 5 has type ‘long long unsigned int’ [-Wformat=]
      fprintf(stderr, "%s: extracting %#016lx-%#016lx (at %lx)\n",
                                                    ^
arch/alpha/boot/tools/objstrip.c:200:12: error: ‘struct exec’ has no member named ‘fh’
  if (!(aout->fh.f_flags & COFF_F_EXEC)) {
            ^~
arch/alpha/boot/tools/objstrip.c:206:10: error: ‘struct exec’ has no member named ‘fh’
  if (aout->fh.f_opthdr != sizeof(aout->ah)) {
          ^~
arch/alpha/boot/tools/objstrip.c:206:38: error: ‘struct exec’ has no member named ‘ah’
  if (aout->fh.f_opthdr != sizeof(aout->ah)) {
                                      ^~
arch/alpha/boot/tools/objstrip.c:218:17: error: ‘struct exec’ has no member named ‘ah’
  fil_size = aout->ah.tsize + aout->ah.dsize;
                 ^~
arch/alpha/boot/tools/objstrip.c:218:34: error: ‘struct exec’ has no member named ‘ah’
  fil_size = aout->ah.tsize + aout->ah.dsize;
                                  ^~
arch/alpha/boot/tools/objstrip.c:219:28: error: ‘struct exec’ has no member named ‘ah’
  mem_size = fil_size + aout->ah.bsize;
                            ^~
arch/alpha/boot/tools/objstrip.c:223:22: error: ‘struct exec’ has no member named ‘ah’
       prog_name, aout->ah.text_start,
                      ^~
arch/alpha/boot/tools/objstrip.c:224:11: error: ‘struct exec’ has no member named ‘ah’
       aout->ah.text_start + fil_size, offset);
           ^~
scripts/Makefile.host:95: recipe for target 'arch/alpha/boot/tools/objstrip' failed

Was that the target used to get bootable CDROMs? Could that be broken since
the move from aout to ELF? Ugh, sorry for raising so much trouble,

CU,
Uli
-- 
Dipl. Inf. Ulrich Teichert|e-mail: Ulrich.Teichert@gmx.de | Listening to:
Stormweg 24               |Eat Lipstick: Dirty Little Secret, The Baboon Show:
24539 Neumuenster, Germany|Work Work Work, The Bellrays: Bad Reaction
