Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A93C96F0AC
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 22:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfGTUlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 16:41:07 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39410 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfGTUlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 16:41:07 -0400
Received: by mail-qk1-f195.google.com with SMTP id w190so25837794qkc.6;
        Sat, 20 Jul 2019 13:41:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2GRr87CeGDH1apo6Nj6AffI/k+fZI6HJLojelJvUYsg=;
        b=k5++5qdVQwSiqTF8qv03J4xxcCaGrRYUZDM99y8C3GdrRjRZaXZGGx+lrQNAg3sV1U
         t9+6XULkckNk2AZWWD0AAvPXx0X3RMGYgM+ppWHax6DTu8trgo0rPUIbZf1D4UV44btH
         sc1qaxSl32KFgR2ea64PvANas921BK38m1HtuUqimJCL13hR1oC9YUIBiQ2pjA+S/xtJ
         xKlQ8Gl1k177x6hyRqUUCRGl4rRC//xFpi2ygcTGkjLwiTzwA4JLhL3ob0G8+tOrGmZ7
         qs5MV9sDzbXgVQ/IKxaGvB6mHMrkgcTJ6aRs8YYVvpvLO2FGr3sYwmC8D/IKaM1glGva
         aNCA==
X-Gm-Message-State: APjAAAWlkMcpKXrvz6CgKtHyrR6Y/jHGp6+s/qrNNAPGyMfxg4rzwTcA
        4NhWPASRmMkThhPladD/V5sHZ06EmOxMzNo72plN27hA5OE=
X-Google-Smtp-Source: APXvYqxcKeJXxpW+eX3DLO4xxR6TFNLNqwLWUasGBjw1iTSLzVThHf8vr1kbmBrHjH5cExUz15aPcmJtiAtNL45Bmms=
X-Received: by 2002:a37:4ac3:: with SMTP id x186mr39214231qka.138.1563655265830;
 Sat, 20 Jul 2019 13:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190720174844.4b989d34@sf> <87wogca86l.fsf@mid.deneb.enyo.de>
 <CAK8P3a3s3OeBj1MviaJV2UR0eUhF0GKPBi1iFf_3QKQyNPkuqw@mail.gmail.com> <87muh8a4a3.fsf@mid.deneb.enyo.de>
In-Reply-To: <87muh8a4a3.fsf@mid.deneb.enyo.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 20 Jul 2019 22:40:49 +0200
Message-ID: <CAK8P3a049MYvvu3pDONanYEosweYYQH1qJMg+CuMK-NcULtXTA@mail.gmail.com>
Subject: Re: linux-headers-5.2 and proper use of SIOCGSTAMP
To:     Florian Weimer <fw@deneb.enyo.de>
Cc:     Sergei Trofimovich <slyfox@gentoo.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 20, 2019 at 9:34 PM Florian Weimer <fw@deneb.enyo.de> wrote:
> * Arnd Bergmann:
> > On Sat, Jul 20, 2019 at 8:10 PM Florian Weimer <fw@deneb.enyo.de> wrote:
> > As far as I can tell, nobody thought it would be a problem to move it
> > from asm/sockios.h to linux/sockios.h, as the general rule is that one
> > should use the linux/*.h version if both exist, and that the asm/*.h
> > version only contains architecture specific definitions. The new
> > definition is the same across all architectures, so it made sense to
> > have it in the common file.
>
> Most of the socket-related constants are not exposed in UAPI headers,
> although userspace is expected to use them.  It seems to me that due
> to the lack of other options among the UAPI headers, <asm/socket.h>
> has been a dumping ground for various socket-related things in the
> past, whether actually architecture-specific or not.
>
> <linux/socket.h> does not include <asm/socket.h>, so that's why we
> usually end up with including <asm/socket.h> (perhaps indirectly via
> <sys/socket.h>), which used to include <asm/sockios.h> on most (all?)
> architectures.  That in turn provided some of the SIOC* constants in
> the past, so people didn't investigate other options.

It seems that both the missing constants and the fact that
linux/socket.h doesn't include asm/socket.h and linux/sockios.h
goes back to a 21 year old commit:

commit 74f513101058f7585176ea8cdf6fb026faea8a7e
Author: linus1 <torvalds@linuxfoundation.org>
Date:   Wed May 20 11:00:00 1998 -0800

    [tytso] include/asm-i386/posix_types.h
    This quick fix eliminates a lot of warning messages when
    compiling e2fsprogs under glibc.  This is because the glibc header files
    defines its own version of FD_SET, FD_ZERO, etc., and so if you need to
    #include the kernel include files, you get a lot of duplicate defined
    macro warning messages.  This patch simply #ifdef's out the kernel
    versions of these function if the kernel is not being compiled and the
    glibc header files are in use.

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 08f0d281401c..35a7629b6b70 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_SOCKET_H
 #define _LINUX_SOCKET_H

+#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+
 #include <asm/socket.h>                        /* arch-dependent
defines       */
 #include <linux/sockios.h>             /* the SIOCxxx I/O controls     */
 #include <linux/uio.h>                 /* iovec support                */
@@ -256,4 +258,5 @@ extern int move_addr_to_user(void *kaddr, int
klen, void *uaddr, int *ulen);
 extern int move_addr_to_kernel(void *uaddr, int ulen, void *kaddr);
 extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
 #endif
+#endif /* not kernel and not glibc */
 #endif /* _LINUX_SOCKET_H */

(the same commit did similar changes in linux/stat.h and asm/posix_types.h)

Over time, the check for glibc was removed (to allow including linux/socket.h
before sys/socket.h), and all the #ifdef __KERNEL__ bits were removed
from the installed header as part of the uapi header split.

> I think we can change glibc to include <linux/sockios.h> in addition
> to <asm/socket.h>.  <linux/sockios.h> looks reasonably clean to me,
> much better than <asm/socket.h>.

That seems reasonable to me, but overall my fear is that these headers
are already so broken that any change will risk breaking something
in more or less unexpected ways.

        Arnd
