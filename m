Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC71814FD3E
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 14:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgBBNRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 08:17:14 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45374 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgBBNRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 08:17:14 -0500
Received: by mail-ot1-f65.google.com with SMTP id 59so11045022otp.12
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 05:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+JexwpZ7uOUAzO/bZPt69XOsxgXW5ev8PRFd02TcEk8=;
        b=IE+nMVkXga9fWUwZKPOjqNIk95sq5yO14vZeu1ludYC7s0JaU1fr2jelppwPGlACgG
         83h28kTdOijU1EWLsvch7JEqnA+Ea0m9DfYb62/uQy108/7UV+m83daOiNSPwAckbp8F
         DpBcwguqXp7EEyyRRPBYZizpZiRhl1W8LshjY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+JexwpZ7uOUAzO/bZPt69XOsxgXW5ev8PRFd02TcEk8=;
        b=YXMhlpK1pSVnRW1S6/edJbZznGTyJb4fyGwkGXmh7IPE3L69yuKFZdbSdT5uUN8n58
         eySLS3X5bxEAPlK2krdZAbvLYwCFdTDjbNadrxA8RW/CSD9IhyxcCT2EpsDrDsEXIqoX
         FgRmMAYfqy0V6dNEqbE866cdpBrrILnBhwOFW1ApNMuON4mka7DOxPhOR7qpwv27+i8W
         G/Rgo0bXKH4Wu01nCo8g1RqY0mFUvjKMRXOnbWKw0f6TWHDVrj5Fn+xG/n58PPBBMiUs
         7s01vbqJygJOwwriVAlGcenl7hJznJEeXU03avYgNWx/SqLAnEuF0rjLuuv/q1S0ANrv
         brZg==
X-Gm-Message-State: APjAAAUtmLUjeEqfbaf2b3b8HcBPhYN2GRUEoxPq2FaJuSVch89MKo90
        exv3qP9kk/d7ZvCnowDsnvR7vi1cq2lQu9MhpO/aPQ==
X-Google-Smtp-Source: APXvYqyhJpSqQ8at/IdzLDOBcr/4/JYswhhc71+cJLzlo49FIW6k84QX0OWoAy1QjBLh4SW+3pmM+ASFc5nUW+iAsSg=
X-Received: by 2002:a9d:7696:: with SMTP id j22mr14988663otl.188.1580649432010;
 Sun, 02 Feb 2020 05:17:12 -0800 (PST)
MIME-Version: 1.0
References: <20200201043209.13412-1-hdanton@sina.com> <20200201090247.10928-1-hdanton@sina.com>
 <20200201162537.GK1778@kadam>
In-Reply-To: <20200201162537.GK1778@kadam>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Sun, 2 Feb 2020 14:17:00 +0100
Message-ID: <CAKMK7uGHuvyrn=WghhHBk2miW__ctVHeDTDKz+XVJ9yLjpS97Q@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in vgem_gem_dumb_create
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+0dc4444774d419e916c8@syzkaller.appspotmail.com>,
        Dave Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "Wilson, Chris" <chris@chris-wilson.co.uk>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        David Miller <davem@davemloft.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Emil Velikov <emil.velikov@collabora.com>,
        "Anholt, Eric" <eric@anholt.net>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Rob Clark <robdclark@chromium.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 1, 2020 at 5:26 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Sat, Feb 01, 2020 at 05:02:47PM +0800, Hillf Danton wrote:
> >
> > On Sat, 1 Feb 2020 09:17:57 +0300 Dan Carpenter wrote:
> > > On Sat, Feb 01, 2020 at 12:32:09PM +0800, Hillf Danton wrote:
> > > >
> > > > Release obj in error path.
> > > >
> > > > --- a/drivers/gpu/drm/vgem/vgem_drv.c
> > > > +++ b/drivers/gpu/drm/vgem/vgem_drv.c
> > > > @@ -196,10 +196,10 @@ static struct drm_gem_object *vgem_gem_c
> > > >           return ERR_CAST(obj);
> > > >
> > > >   ret = drm_gem_handle_create(file, &obj->base, handle);
> > > > - drm_gem_object_put_unlocked(&obj->base);
> > > > - if (ret)
> > > > + if (ret) {
> > > > +         drm_gem_object_put_unlocked(&obj->base);
> > > >           return ERR_PTR(ret);
> > > > -
> > > > + }
> > > >   return &obj->base;
> > >
> > > Oh yeah.  It's weird that we never noticed the success path was broken.
> > > It's been that way for three years and no one noticed at all.  Very
> > > strange.
> > >
> > > Anyway, it already gets freed on error in drm_gem_handle_create() so
> > > we should just delete the drm_gem_object_put_unlocked() here it looks
> > > like.

There's two refcounts here, one is the handle_count, and the other is
the underlying object refcount. I think the code is correct, except if
you race with a 2nd thread which destroys the object (through the
handle) while we still try to read gem_object->size in the caller of
this. So correct fix (I think at least) is to shuffle that temporary
reference on the object (not the handle) we hold while constructing it
around a bit, so there's no use-after free anymore in the case of a
race. I'm typing a patch for this.

Cheers, Daniel

> > Good catch, Dan :P
> > Would you please post a patch sometime convenient next week?
>
> Sure.  Will do.
>
> regards,
> dan carpenter
>


-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
