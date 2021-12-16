Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F2D477C45
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 20:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240802AbhLPTPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 14:15:41 -0500
Received: from gate.crashing.org ([63.228.1.57]:55698 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231803AbhLPTPk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 14:15:40 -0500
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 1BGIuSL3021510;
        Thu, 16 Dec 2021 12:56:28 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 1BGIuLq7021509;
        Thu, 16 Dec 2021 12:56:21 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Thu, 16 Dec 2021 12:56:20 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, johannes@sipsolutions.net,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Paul Mackerras <paulus@samba.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:SPARC + UltraSPARC (sparc/sparc64)" 
        <sparclinux@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshinori Sato <ysato@users.osdn.me>, X86 ML <x86@kernel.org>,
        James Morris <jmorris@namei.org>,
        Ingo Molnar <mingo@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "Richard Russon (FlatCap)" <ldm@flatcap.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Jonas Bonn <jonas@southpole.se>, Arnd Bergmann <arnd@arndb.de>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        linux-block@vger.kernel.org,
        linux-m68k <linux-m68k@vger.kernel.org>,
        openrisc@lists.librecores.org, Borislav Petkov <bp@alien8.de>,
        Stafford Horne <shorne@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jens Axboe <axboe@kernel.dk>,
        John Johansen <john.johansen@canonical.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-ntfs-dev@lists.sourceforge.net,
        linux-security-module@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>
Subject: Re: [PATCH v2 00/13] Unify asm/unaligned.h around struct helper
Message-ID: <20211216185620.GP614@gate.crashing.org>
References: <20210514100106.3404011-1-arnd@kernel.org> <CAMj1kXG0CNomZ0aXxh_4094fT+g4bVWFCkrd7QwgTQgiqoxMWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXG0CNomZ0aXxh_4094fT+g4bVWFCkrd7QwgTQgiqoxMWA@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 06:29:40PM +0100, Ard Biesheuvel wrote:
> I think this series is a huge improvement, but it does not solve the
> UB problem completely. As we found, there are open issues in the GCC
> bugzilla regarding assumptions in the compiler that aligned quantities
> either overlap entirely or not at all. (e.g.,
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=100363)

That isn't open, it was closed as INVALID back in May.

(Naturally) aligned quantities only overlap if they are the same datum.
This follows directly from the definition of (naturally) aligned.  There
is no mystery here.

All unaligned data need to be marked up properly.

> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is used in many places to
> conditionally emit code that violates C alignment rules.

Most of this is ABI, not C.  It is the ABI that requires certain
alignments.  Ignoring that plain does not work, but even if it would
you will end up with much slower generated code.

> whereas the following pattern makes more sense, I think, and does not
> violate any C rules in the common case:
> 
> #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>   // use unaligned accessors, which are cheap or even entirely free
> #else
>   // avoid unaligned accessors, as they are expensive; instead, reorganize
>   // the data so we don't need them (similar to setting NET_IP_ALIGN to 2)
> #endif

Yes, this looks more reasonable.

> The only remaining problem here is reinterpreting a char* pointer to a
> u32*, e.g., for accessing the IP address in an Ethernet frame when
> NET_IP_ALIGN == 2, which could suffer from the same UB problem again,
> as I understand it.

The problem is never casting a pointer to pointer to character type, and
then later back to an appriopriate pointer type.  These things are both
required to work.  The problem always is accessing something as if it
was something of another type, which is not valid C.  This however is
exactly what -fno-strict-aliasing allows, so that works as well.

But this does not have much to do with alignment.


Segher
