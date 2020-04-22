Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE861B359D
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 05:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgDVDiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 23:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726228AbgDVDip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 23:38:45 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D40C0610D6;
        Tue, 21 Apr 2020 20:38:45 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id t11so448885lfe.4;
        Tue, 21 Apr 2020 20:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cjSTi7hlF1/NelCXmbeNWnOnAcO/OjzgBK0nAtkVF1M=;
        b=HsYir1MD1qN3cOFB5Lr3179LEcQcQ1a/Qq3NCUTytLRTeuLM6l9Rixek6ovajwT16b
         BMP9vfjjaXChJCfi00vAzyGiJPpHofR2+PIw9/z7h8vSXN9Ha0RkgU3gQTFJgkAe2HGQ
         W5fCz7w7LP1mkVNxJDhgDJsp586/okfTrd0rancohGo7/OAN863jRiEwLN8kGkOC4P+h
         9IPyvWOfG/qXyqqXp4L2tadElFAk//2zk3q6qm3zcY0lBsTOw3BLEg0BSy6YGPPF+otf
         pnpXsE6oUgHvE10hJqnJrncoARHmSXGczeEb3AZtba2V4x0ku1caTdPk7cba5nhn1Mw3
         hYkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cjSTi7hlF1/NelCXmbeNWnOnAcO/OjzgBK0nAtkVF1M=;
        b=oCHQFWo9/CeYmde5RL7xiQClD3oiFv1UVYIQ3O3G9k/dvWUmjfBhEzS9F7KSQVCeYn
         fFp6teUs6ge8OmAnH848Nfq7KXeD1h9teTWI9LrwJ0gvmVl1xBIM2HQ1rCKlRHvmJ+2V
         b4lw/Q+Qxd/aw5XZ4tW74HiZfXov/qo7T5T/Z3VnkGxlMF6V4Bk7UPcQohvZk8kkhMmK
         b3bwUf9iTy3vKmx4srDyCzWsJL7mF7mXqnfheSqdxbLxXpRlRii+0YgkxX6xpn94ieIU
         aGoMMtxCyqNCASc0CfuSyUssfL/8woZQ8WLQCr4YjBeT8dI+BK3FmsfGIpNXgOvGulmV
         EvxA==
X-Gm-Message-State: AGi0PubJvgD6GgKLOZbF/6AvPWX7OBDj9vKh1qI7/hM9S2hK+8WaTgHm
        rJZPeUJIHmmcrtXuBzWzxMNev59chdo1E0feBkBtM4FiKQ0=
X-Google-Smtp-Source: APiQypIpUMoiM4pLlpvoneXnVmUpQwIHtS5zEdjT4qynaypGLsgcvfd5TCUNGVuboXjX5mw49Gl/fP8JXcB430T44RI=
X-Received: by 2002:ac2:519c:: with SMTP id u28mr15656394lfi.17.1587526723542;
 Tue, 21 Apr 2020 20:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200420071548.62112-1-nate.karstens@garmin.com>
 <20200420071548.62112-2-nate.karstens@garmin.com> <36dce9b4-a0bf-0015-f6bc-1006938545b1@gmail.com>
In-Reply-To: <36dce9b4-a0bf-0015-f6bc-1006938545b1@gmail.com>
From:   Changli Gao <xiaosuo@gmail.com>
Date:   Wed, 22 Apr 2020 11:38:32 +0800
Message-ID: <CABa6K_HWsy9DdjsKXE2d_JrC+OsNuW+OALS+-_HiV3r2XgC1bw@mail.gmail.com>
Subject: Re: [PATCH 1/4] fs: Implement close-on-fork
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Nate Karstens <nate.karstens@garmin.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-parisc@vger.kernel.org,
        sparclinux@vger.kernel.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 6:25 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 4/20/20 12:15 AM, Nate Karstens wrote:
> > The close-on-fork flag causes the file descriptor to be closed
> > atomically in the child process before the child process returns
> > from fork(). Implement this feature and provide a method to
> > get/set the close-on-fork flag using fcntl(2).
> >
> > This functionality was approved by the Austin Common Standards
> > Revision Group for inclusion in the next revision of the POSIX
> > standard (see issue 1318 in the Austin Group Defect Tracker).
>
> Oh well... yet another feature slowing down a critical path.
>
> >
> > Co-developed-by: Changli Gao <xiaosuo@gmail.com>
> > Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> > Signed-off-by: Nate Karstens <nate.karstens@garmin.com>
> > ---
> >  fs/fcntl.c                             |  2 ++
> >  fs/file.c                              | 50 +++++++++++++++++++++++++-
> >  include/linux/fdtable.h                |  7 ++++
> >  include/linux/file.h                   |  2 ++
> >  include/uapi/asm-generic/fcntl.h       |  5 +--
> >  tools/include/uapi/asm-generic/fcntl.h |  5 +--
> >  6 files changed, 66 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/fcntl.c b/fs/fcntl.c
> > index 2e4c0fa2074b..23964abf4a1a 100644
> > --- a/fs/fcntl.c
> > +++ b/fs/fcntl.c
> > @@ -335,10 +335,12 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
> >               break;
> >       case F_GETFD:
> >               err = get_close_on_exec(fd) ? FD_CLOEXEC : 0;
> > +             err |= get_close_on_fork(fd) ? FD_CLOFORK : 0;
> >               break;
> >       case F_SETFD:
> >               err = 0;
> >               set_close_on_exec(fd, arg & FD_CLOEXEC);
> > +             set_close_on_fork(fd, arg & FD_CLOFORK);
> >               break;
> >       case F_GETFL:
> >               err = filp->f_flags;
> > diff --git a/fs/file.c b/fs/file.c
> > index c8a4e4c86e55..de7260ba718d 100644
> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -57,6 +57,8 @@ static void copy_fd_bitmaps(struct fdtable *nfdt, struct fdtable *ofdt,
> >       memset((char *)nfdt->open_fds + cpy, 0, set);
> >       memcpy(nfdt->close_on_exec, ofdt->close_on_exec, cpy);
> >       memset((char *)nfdt->close_on_exec + cpy, 0, set);
> > +     memcpy(nfdt->close_on_fork, ofdt->close_on_fork, cpy);
> > +     memset((char *)nfdt->close_on_fork + cpy, 0, set);
> >
>
> I suggest we group the two bits of a file (close_on_exec, close_on_fork) together,
> so that we do not have to dirty two separate cache lines.
>
> Otherwise we will add yet another cache line miss at every file opening/closing for processes
> with big file tables.
>
> Ie having a _single_ bitmap array, even bit for close_on_exec, odd bit for close_on_fork
>
> static inline void __set_close_on_exec(unsigned int fd, struct fdtable *fdt)
> {
>         __set_bit(fd * 2, fdt->close_on_fork_exec);
> }
>
> static inline void __set_close_on_fork(unsigned int fd, struct fdtable *fdt)
> {
>         __set_bit(fd * 2 + 1, fdt->close_on_fork_exec);
> }
>
> Also the F_GETFD/F_SETFD implementation must use a single function call,
> to not acquire the spinlock twice.
>

Good suggestions.

At the same time, we'd better extend other syscalls, which set the
FD_CLOEXEC when  creating FDs. i.e. open, pipe3...


-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
