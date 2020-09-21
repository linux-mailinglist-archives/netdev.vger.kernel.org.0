Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8AC2731FD
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 20:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgIUSbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 14:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgIUSbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 14:31:36 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AE9C061755;
        Mon, 21 Sep 2020 11:31:36 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id j76so5089570ybg.3;
        Mon, 21 Sep 2020 11:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0h9V+COgaTKtGEw7E+vRM3Fe7BKvj7om5nGhejL8wwY=;
        b=ACKnACqiCilNnTbCy5YM6MKP1WvNSGtRwYAR7C9lgA+2XewGMfHjYUev2yk/SzxsM/
         r7HPOxX1RlcYfZW4l7Q5ZYvHkn/iMJkONIZJ4JMtsEhDBHFAFFrkWouM6mYb2+j0KdAV
         VXf5I4wIlfGAcys4onGqn52mNhV87Q8aiHfiTRDAvrn5ufHL0V7zjAxG5aJ/XpULjc5Z
         E6GtZGyNrvq1ftPpFhgt4C53kIsE/bZeTp+XkFhluFtz1MVoe4Vn/owuLbErZVkBgvWx
         N7zHzuzt27NWNcDP61SwyPfWnSzk3V4pHvjalWphlmhV9d6Y0cjucpzqgKfL8uJNlUji
         qsrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0h9V+COgaTKtGEw7E+vRM3Fe7BKvj7om5nGhejL8wwY=;
        b=Z15MC/5PM6stua6QkwyzUHFDq0j+Fcr36HvVXTpcKq2ZtEiQCTGeZ4mLkEY/YSrPy6
         vbWGJ0HC8janOG5ax7y4l2XkZbmnDfdrFg+uxbLCLA0G42znfcXD6iFlIN250dHofZPT
         1nlaJ6nEHmgyxlbi+ijZLCMtMFCcaZ6yjiiZaeiy8Ax+IEoKlzLhX2o6ZE/9dCv1x+WS
         hjPc0S/OcSe3/R9UqsoyZDOTRS1SCeAIdXq1w8GaL0BEuypJ/RfzXeeGagM5obriCjry
         fAjloCDj+tbK4aUMOmNQkwKdizi4dHsVuMCMt2HrIrD4u40Nkdu10GdcZprEbB4Xok+q
         0gGA==
X-Gm-Message-State: AOAM530F/Jner5xsaufAeImpk36ZVE1wfvYmexe9zmFKGpy1lnBrKwNp
        wXLVG4sZSLyPObQ1h5cWDxmyzwNrJod84+namcU=
X-Google-Smtp-Source: ABdhPJwDqc7VnZG9Kgo70CXuHeN8V19hv6xXELhkOkXnwWTrcNbWz9twwO14BQp2b+RAE9HUxmAaPosHWHXbwAwhhXQ=
X-Received: by 2002:a25:4446:: with SMTP id r67mr1606876yba.459.1600713095548;
 Mon, 21 Sep 2020 11:31:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200917074453.20621-1-songmuchun@bytedance.com> <CAEf4Bzad2LDGH_qnE+Qumy=B0N9WXGrwaK5pAdhNm53Q-XzawA@mail.gmail.com>
In-Reply-To: <CAEf4Bzad2LDGH_qnE+Qumy=B0N9WXGrwaK5pAdhNm53Q-XzawA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 11:31:24 -0700
Message-ID: <CAEf4BzbbU-EmBQn_eTwNR-L1+XgwEgn9e5t8Z5ssVBmoLu-Uow@mail.gmail.com>
Subject: Re: [RFC PATCH] bpf: Fix potential call bpf_link_free() in atomic context
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 10:29 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Sep 17, 2020 at 12:46 AM Muchun Song <songmuchun@bytedance.com> wrote:
> >
> > The in_atomic macro cannot always detect atomic context. In particular,
> > it cannot know about held spinlocks in non-preemptible kernels. Although,
> > there is no user call bpf_link_put() with holding spinlock now. Be the
> > safe side, we can avoid this in the feature.
> >
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > ---
>
> This change seems unnecessary (or at least premature), as if we ever
> get a use case that does bpf_link_put() from under held spinlock, we
> should see a warning about that (and in that case I bet code can be
> rewritten to not hold spinlock during bpf_link_put()). But on the
> other hand it makes bpf_link_put() to follow the pattern of
> bpf_map_put(), which always defers the work, so I'm ok with this. As
> Song mentioned, this is not called from a performance-critical hot
> path, so doesn't matter all that much.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>

btw, you probably need to resubmit this patch as a non-RFC one for it
to be applied?..

> >  kernel/bpf/syscall.c | 8 ++------
> >  1 file changed, 2 insertions(+), 6 deletions(-)
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 178c147350f5..6347be0a5c82 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -2345,12 +2345,8 @@ void bpf_link_put(struct bpf_link *link)
> >         if (!atomic64_dec_and_test(&link->refcnt))
> >                 return;
> >
> > -       if (in_atomic()) {
> > -               INIT_WORK(&link->work, bpf_link_put_deferred);
> > -               schedule_work(&link->work);
> > -       } else {
> > -               bpf_link_free(link);
> > -       }
> > +       INIT_WORK(&link->work, bpf_link_put_deferred);
> > +       schedule_work(&link->work);
> >  }
> >
> >  static int bpf_link_release(struct inode *inode, struct file *filp)
> > --
> > 2.20.1
> >
