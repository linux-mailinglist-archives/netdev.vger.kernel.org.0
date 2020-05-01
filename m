Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEBB1C0E3C
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 08:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgEAGdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 02:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgEAGdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 02:33:13 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C499C035494;
        Thu, 30 Apr 2020 23:33:11 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id e17so7263917qtp.7;
        Thu, 30 Apr 2020 23:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=97opqjjmRIu4DZpa39DLR9cyrlH6moODHs8h/qHriR0=;
        b=VYVf+QOEUFyTspuR6rTvFP0VDS9BrIwIlWUxDhiTQLA47SPm8wajnQJ7WNBFC9RsOv
         9EnO3vgbGDm9driIedLh3FACE0lD3buEFYCVMjyfOg3pd3Ol/9xv0JNHKdcsV3dINvbZ
         mI7ey/LIXYhYieINBXTo20ElC0spBeNjc9SsE1trrQumMdyCim+/AoXFCd+FRRlZoUPh
         AtTM2Zd9+009sNRCqFg/Sir4eNXeyXZNiR8iT0k0Zq6zPSHcNqa3xl5xsu6lEj0qHa6+
         Nj2lTLjPA1dpU0bQBd0SNTM4u8xu5r5OdkfKwQR34d7QSab4UqQW4rb5V7vF58w3KJTz
         jXCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=97opqjjmRIu4DZpa39DLR9cyrlH6moODHs8h/qHriR0=;
        b=E5WHx4ST0wCa9MCsNjBwYl9/hZcaeAoUmE/LwrmQbhPOUVYhw8ss5bcyM2Bp63WLD6
         41f5vfH8rwn42zLbQJu7m5X4ozMSVyQZKp9FY+CS/kyJurKn/0HTSkMTnzJA64YbM+gg
         HGS8+bAND8sno0rAJ8V7ONkZj1CI+USzxGtW2oR1CvrVs1S+ZXikP8NTSWGRVK48HsPI
         xp3s//J8t9R6GiKkG0Ss9nXFQVHnLLYiFIlIqpyemmFCVKNmgqj/ltlpuePzcgGWPRKg
         SIpRD8YKEsm1gDuiDgw6/bQ/e50ujNeptZDDvJuZrvnbyQ1lSzaO0BszypuIOw0VWqFV
         Ykag==
X-Gm-Message-State: AGi0PuawC1rBAYtX4K99+tFlTy2iiLAOo7GwiZPp7Oc8FBRkBlZS42aD
        FStI1g18AFS8E01cGD8fZxyTOG9J8FGDOkofINo=
X-Google-Smtp-Source: APiQypKTwTrwTmnOqnNhznfvx76T/MGrXXY4E22O1AxAAPZu74ZIDIsi8qpajeaDIe6n0awNkwz9qMUr+B3h1+SU5i4=
X-Received: by 2002:ac8:468d:: with SMTP id g13mr2258896qto.59.1588314790624;
 Thu, 30 Apr 2020 23:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200430194609.1216836-1-andriin@fb.com> <20200501062521.2xruidyrtuxycipw@kafai-mbp>
In-Reply-To: <20200501062521.2xruidyrtuxycipw@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 30 Apr 2020 23:32:59 -0700
Message-ID: <CAEf4Bza166F5M4Qie5t+tkM+vYgYxqgeStpOWovc_WU_MiSURQ@mail.gmail.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] bpf: fix use-after-free of
 bpf_link when priming half-fails
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        syzbot <syzbot+39b64425f91b5aab714d@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 11:25 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Apr 30, 2020 at 12:46:08PM -0700, Andrii Nakryiko wrote:
> > If bpf_link_prime() succeeds to allocate new anon file, but then fails to
> > allocate ID for it, link priming is considered to be failed and user is
> > supposed ot be able to directly kfree() bpf_link, because it was never exposed
> > to user-space.
> >
> > But at that point file already keeps a pointer to bpf_link and will eventually
> > call bpf_link_release(), so if bpf_link was kfree()'d by caller, that would
> > lead to use-after-free.
> >
> > Fix this by creating file with NULL private_data until ID allocation succeeds.
> > Only then set private_data to bpf_link. Teach bpf_link_release() to recognize
> > such situation and do nothing.
> >
> > Fixes: a3b80e107894 ("bpf: Allocate ID for bpf_link")
> > Reported-by: syzbot+39b64425f91b5aab714d@syzkaller.appspotmail.com
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  kernel/bpf/syscall.c | 16 +++++++++++++---
> >  1 file changed, 13 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index c75b2dd2459c..ce00df64a4d4 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -2267,7 +2267,12 @@ static int bpf_link_release(struct inode *inode, struct file *filp)
> >  {
> >       struct bpf_link *link = filp->private_data;
> >
> > -     bpf_link_put(link);
> > +     /* if bpf_link_prime() allocated file, but failed to allocate ID,
> > +      * file->private_data will be null and by now link itself is kfree()'d
> > +      * directly, so just do nothing in such case.
> > +      */
> > +     if (link)
> > +             bpf_link_put(link);
> >       return 0;
> >  }
> >
> > @@ -2348,7 +2353,7 @@ int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer)
> >       if (fd < 0)
> >               return fd;
> >
> > -     file = anon_inode_getfile("bpf_link", &bpf_link_fops, link, O_CLOEXEC);
> > +     file = anon_inode_getfile("bpf_link", &bpf_link_fops, NULL, O_CLOEXEC);
> >       if (IS_ERR(file)) {
> >               put_unused_fd(fd);
> >               return PTR_ERR(file);
> > @@ -2357,10 +2362,15 @@ int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer)
> >       id = bpf_link_alloc_id(link);
> >       if (id < 0) {
> >               put_unused_fd(fd);
> > -             fput(file);
> > +             fput(file); /* won't put link, so user can kfree() it */
> >               return id;
> >       }
> >
> > +     /* Link priming succeeded, point file's private data to link now.
> > +      * After this caller has to call bpf_link_cleanup() to free link.
> > +      */
> > +     file->private_data = link;
> Instead of switching private_data back and forth, how about calling getfile() at end
> (i.e. after alloc_id())?
>

Because once ID is allocated, user-space might have bumped bpf_link
refcnt already, so we can't just kfree() it after that.

> > +
> >       primer->link = link;
> >       primer->file = file;
> >       primer->fd = fd;
> > --
> > 2.24.1
> >
