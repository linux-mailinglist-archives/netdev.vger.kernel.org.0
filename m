Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89D03627BA
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238105AbhDPSaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235976AbhDPSaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D4F7610FC;
        Fri, 16 Apr 2021 18:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618597786;
        bh=nlSPl017XN2OhAYys7DYCk+kWZj37KdCE/NuK/zph/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vORZE2Nm+/IFgZbg77o5OjvvSnuIX6fVd6V6tgM49JUzaTY2AmVlBdDXAcsnVJAYV
         SK7gRE9RlMLi2ByM519PlX3D3XNcEKU+SzN3hMynC5LjjmfX5fZcd5LQgJiYR14vFP
         mgADJZG08V8qbbWs2toUvK0HzUtvMyjI1/3ypR7bvbdkDSelEoVmIpZFeVaJmN0ccN
         dApm3NtWPAlOSue8qhpvIce47aSkAUpNEpBswAthF046dwUMGm1oJeloALzGFc/Aql
         IC45Q97p/cYWe/+FPYaSVoYQHKYKPAxn7ZQsg8ttUFoaDSUhQMdmK48yKSjrEEsDm2
         l+sKYuX/Trb7g==
Date:   Fri, 16 Apr 2021 11:29:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH net-next] scm: optimize put_cmsg()
Message-ID: <20210416112945.04f30644@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iK0QOCDyEZS2z4Z_VZSqkDWO6kcFZ+b3ah+CVyyK-5x6A@mail.gmail.com>
References: <20210415173753.3404237-1-eric.dumazet@gmail.com>
        <20210416105735.073466b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iK0QOCDyEZS2z4Z_VZSqkDWO6kcFZ+b3ah+CVyyK-5x6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Apr 2021 20:28:40 +0200 Eric Dumazet wrote:
> On Fri, Apr 16, 2021 at 7:57 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 15 Apr 2021 10:37:53 -0700 Eric Dumazet wrote:  
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > Calling two copy_to_user() for very small regions has very high overhead.
> > >
> > > Switch to inlined unsafe_put_user() to save one stac/clac sequence,
> > > and avoid copy_to_user().
> > >
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Cc: Soheil Hassas Yeganeh <soheil@google.com>  
> >
> > Hi Eric!
> >
> > This appears to break boot on my systems.
> >
> > IDK how exactly, looks like systemd gets stuck waiting for nondescript
> > services to start in initramfs. I have lots of debug enabled and didn't
> > spot anything of note in kernel logs.
> >
> > I'll try to poke at this more, but LMK if you have any ideas. The
> > commit looks "obviously correct" :S  
> 
> Oops, my rebase went wong, sorry for that

Ah, my eyes failed to spot that :)

> Can you check this  patch (on top of the buggy one) ?
> 
> If that works, I'll submit a v2

It's already merged. Let me try the fix now...

> diff --git a/net/core/scm.c b/net/core/scm.c
> index bd96c922041d22a2f3b7ee73e4b3183316f9b616..ae3085d9aae8adb81d3bb42c8a915a205476a0ee
> 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -232,7 +232,7 @@ int put_cmsg(struct msghdr * msg, int level, int
> type, int len, void *data)
>                 if (!user_write_access_begin(cm, cmlen))
>                         goto efault;
> 
> -               unsafe_put_user(len, &cm->cmsg_len, efault_end);
> +               unsafe_put_user(cmlen, &cm->cmsg_len, efault_end);
>                 unsafe_put_user(level, &cm->cmsg_level, efault_end);
>                 unsafe_put_user(type, &cm->cmsg_type, efault_end);
>                 unsafe_copy_to_user(CMSG_USER_DATA(cm), data,

