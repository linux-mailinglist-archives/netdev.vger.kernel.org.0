Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862261C1C32
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 19:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbgEARqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 13:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729713AbgEARqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 13:46:43 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B46C061A0C;
        Fri,  1 May 2020 10:46:42 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id c63so9986138qke.2;
        Fri, 01 May 2020 10:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AbayiFTIzijZIjd55n22iJ78VmMIOeiajB3fxATYYQg=;
        b=WBHE+PH4IbArMAmgjIojgp8zmA22JJbdYGwP4RcyxW3Jb8Py7RvTjg/9Jf5MC0tGML
         uKZn7o5ITPiDXXphVlF5EGWBUOXntkAIQVBXgdgafHP8WRy3g4NjUVlhbeO1/h71brXt
         pKYNTzQPyErQy0o7ynk2msN6JHA4/bMTOMo1bln3d5P8RrES9YFyMpd7gzeYJmv4K5D2
         5zxwuKas7aXdUQfJGjr7fUkR8DTd+BsyzcmT57RRs6217HzkgQd1zyvRLICUB7XMgPjA
         28UFQYiKvKNvESujyehDMPdVCHhk9dRbsS2/HEGIptZZWowHI7briBPWaH5BR2bH7z4t
         bLXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AbayiFTIzijZIjd55n22iJ78VmMIOeiajB3fxATYYQg=;
        b=fOXmqiGTGqWJatgu/2qqDIj+Qhh+ZQVGSChx7lBFxIfB+wzy8htsdd9K2foWNRkF9k
         wppOfoKqNF1ppfuQKmzP8YkpmQLmgSzA/z9a5oPGcDK/b4U7z9tWzyHb5Wtp7XL+XWw+
         uNMETiLm2VnjxKrEqVhZH1igMDuZ/CWYpMRc40zOVhy227KMu8uLbEOSmbAjBSod7sxD
         kzwfJFpCyVqJPF2ZBPQZb24h2jY6pOfz/Rxrg2CRJwbnXSvI3uco5h+ghMtjUoequ4ZO
         tMt+kF1pdfBHTcuu9KnyqdHZO2ehEVNwnjmu8IjxDWQhg38hplZSQSN9U3VyhOKXGXD8
         9RjQ==
X-Gm-Message-State: AGi0PuYyK35IhPYMA8cMQCyUvDznRFEnp6DeOcTd0OmWgGuxUBUeUVsh
        R7gohJpVdFB/SoxgPEDAbjsuTIT5ld4l/SlyPijOtQ==
X-Google-Smtp-Source: APiQypK4cw+B+h4Ogy1xMoM4Xy/KF4auU5mto3E8jLIL/aBDSTWaU/RdbXPBK2YPj/2Q3dh/ZQjPMM3OEN2F72RrYJI=
X-Received: by 2002:a37:68f:: with SMTP id 137mr4780804qkg.36.1588355201304;
 Fri, 01 May 2020 10:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200430194609.1216836-1-andriin@fb.com> <20200501062521.2xruidyrtuxycipw@kafai-mbp>
 <CAEf4Bza166F5M4Qie5t+tkM+vYgYxqgeStpOWovc_WU_MiSURQ@mail.gmail.com> <20200501070846.7tmhev6uhdjn4wyz@kafai-mbp>
In-Reply-To: <20200501070846.7tmhev6uhdjn4wyz@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 May 2020 10:46:30 -0700
Message-ID: <CAEf4BzY54UqZCtB7eJkLCNxifwM2emn=eLZawW031fePY2Oijg@mail.gmail.com>
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

On Fri, May 1, 2020 at 12:09 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Apr 30, 2020 at 11:32:59PM -0700, Andrii Nakryiko wrote:
> > On Thu, Apr 30, 2020 at 11:25 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Thu, Apr 30, 2020 at 12:46:08PM -0700, Andrii Nakryiko wrote:
> > > > If bpf_link_prime() succeeds to allocate new anon file, but then fails to
> > > > allocate ID for it, link priming is considered to be failed and user is
> > > > supposed ot be able to directly kfree() bpf_link, because it was never exposed
> > > > to user-space.
> > > >
> > > > But at that point file already keeps a pointer to bpf_link and will eventually
> > > > call bpf_link_release(), so if bpf_link was kfree()'d by caller, that would
> > > > lead to use-after-free.
> > > >
> > > > Fix this by creating file with NULL private_data until ID allocation succeeds.
> > > > Only then set private_data to bpf_link. Teach bpf_link_release() to recognize
> > > > such situation and do nothing.
> > > >
> > > > Fixes: a3b80e107894 ("bpf: Allocate ID for bpf_link")
> > > > Reported-by: syzbot+39b64425f91b5aab714d@syzkaller.appspotmail.com
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > > >  kernel/bpf/syscall.c | 16 +++++++++++++---
> > > >  1 file changed, 13 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > > index c75b2dd2459c..ce00df64a4d4 100644
> > > > --- a/kernel/bpf/syscall.c
> > > > +++ b/kernel/bpf/syscall.c
> > > > @@ -2267,7 +2267,12 @@ static int bpf_link_release(struct inode *inode, struct file *filp)
> > > >  {
> > > >       struct bpf_link *link = filp->private_data;
> > > >
> > > > -     bpf_link_put(link);
> > > > +     /* if bpf_link_prime() allocated file, but failed to allocate ID,
> > > > +      * file->private_data will be null and by now link itself is kfree()'d
> > > > +      * directly, so just do nothing in such case.
> > > > +      */
> > > > +     if (link)
> > > > +             bpf_link_put(link);
> > > >       return 0;
> > > >  }
> > > >
> > > > @@ -2348,7 +2353,7 @@ int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer)
> > > >       if (fd < 0)
> > > >               return fd;
> > > >
> > > > -     file = anon_inode_getfile("bpf_link", &bpf_link_fops, link, O_CLOEXEC);
> > > > +     file = anon_inode_getfile("bpf_link", &bpf_link_fops, NULL, O_CLOEXEC);
> > > >       if (IS_ERR(file)) {
> > > >               put_unused_fd(fd);
> > > >               return PTR_ERR(file);
> > > > @@ -2357,10 +2362,15 @@ int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer)
> > > >       id = bpf_link_alloc_id(link);
> > > >       if (id < 0) {
> > > >               put_unused_fd(fd);
> > > > -             fput(file);
> > > > +             fput(file); /* won't put link, so user can kfree() it */
> > > >               return id;
> > > >       }
> > > >
> > > > +     /* Link priming succeeded, point file's private data to link now.
> > > > +      * After this caller has to call bpf_link_cleanup() to free link.
> > > > +      */
> > > > +     file->private_data = link;
> > > Instead of switching private_data back and forth, how about calling getfile() at end
> > > (i.e. after alloc_id())?
> > >
> >
> > Because once ID is allocated, user-space might have bumped bpf_link
> > refcnt already, so we can't just kfree() it after that.
> link->id is not set, so refcnt should not be bumped.
>
> Calling bpf_link_free_id(id) at the getfile() error path should be enough?
>

You are totally right! This was my initial instinct to do it this way,
but I somehow convinced myself it wouldn't work due to possible refcnt
bump. But you are right, there is `if (link->id)` check, which will
make all this safe. Thanks for suggestion! I'll re-work this patch.

> >
> > > > +
> > > >       primer->link = link;
> > > >       primer->file = file;
> > > >       primer->fd = fd;
> > > > --
> > > > 2.24.1
> > > >
