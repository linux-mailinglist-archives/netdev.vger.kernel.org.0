Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C783627D1
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244624AbhDPShP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236156AbhDPShN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 14:37:13 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8E6C061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 11:36:48 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id z1so31142154ybf.6
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 11:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jynMxnnJWnlcMpohtKKw1aCYN3PRHxcDN/S9bB/gn2g=;
        b=PfyQIdwDMriz9vaznoXH21NFXDZU+jKsIwb9z87BMe10dmC3i5Am+3HT1xh3EdrBZI
         yAChzBrbkXwjCjA/4/13BcGsS9r21FZofo+jlOQ4atwkt7ylCU11gc25KJO0hnLcKlo/
         zfvnpOrk57OXAZDia/rlKIDubOzSJVoyBqtE2PrBfpmRAZX0R6f2SJA83IBggvO4kFA/
         7Jx2CdXLA3xiAd+m04LQrvYIOkFJHG7vd5LeZfKOmaPTbCPwML8KpeoizXOL5NkIbCud
         5TWid29Lwzqt2L9wWXf2OMmEAW7poI5YDQqB7bAGxxh/H2SzSn/V3Hso5j5hF6pr3dIP
         9J6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jynMxnnJWnlcMpohtKKw1aCYN3PRHxcDN/S9bB/gn2g=;
        b=dohxRAI+mCdkuJHSHDNj0YQ05AI5R3VGP2TPu89v0yXN+HkTlJBj28WwEWmfbjKft/
         R5eaecqNP20SNdHgK8fCh8YxeUAVfSfqAlrAnvGkRSiWgbmQeHja6x7iUq9o4qBumfHw
         lbbU1dPfK67idjRKzpNmZTuZWX70aBVD2U3BBftO68Z/7YCiZ0VsF23rX/XoMV8BsdGw
         K840J82vmd77gKLS88fm+HPC0eQZJBV1qwNaD5QxaoSVRyOreIJKx3oG6qCFWoak8l1l
         4pcx4Vnned6qRsUype1hNcmKTqaaNivxF1Bm/+2CXDHePtVQQT/TRVLCehcUFlS2XMJf
         b7IA==
X-Gm-Message-State: AOAM5321WbQHvWjU4iSLlI+L/YLSjamr+q8zwv7gKA3NRHQq32SHA2iE
        mM2Mh+Fy7X98gklTVYnrPVmKEUraamA+oEiYT5YPew==
X-Google-Smtp-Source: ABdhPJwBQOKcUXQpwmnuk3EG/5kC23d3rHOeOqy/mkA+hJfiJGduZxFnYYZct/+N3rdQlAtMEdwbVT3CtvyhcOmzO2g=
X-Received: by 2002:a25:6a88:: with SMTP id f130mr693802ybc.234.1618598207860;
 Fri, 16 Apr 2021 11:36:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210415173753.3404237-1-eric.dumazet@gmail.com>
 <20210416105735.073466b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iK0QOCDyEZS2z4Z_VZSqkDWO6kcFZ+b3ah+CVyyK-5x6A@mail.gmail.com> <20210416112945.04f30644@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210416112945.04f30644@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 16 Apr 2021 20:36:36 +0200
Message-ID: <CANn89iKqQ0at-hyWZq5EOZOUMTjL7PvZOB_k3KRA8acbGzQy5w@mail.gmail.com>
Subject: Re: [PATCH net-next] scm: optimize put_cmsg()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 8:29 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 16 Apr 2021 20:28:40 +0200 Eric Dumazet wrote:
> > On Fri, Apr 16, 2021 at 7:57 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Thu, 15 Apr 2021 10:37:53 -0700 Eric Dumazet wrote:
> > > > From: Eric Dumazet <edumazet@google.com>
> > > >
> > > > Calling two copy_to_user() for very small regions has very high overhead.
> > > >
> > > > Switch to inlined unsafe_put_user() to save one stac/clac sequence,
> > > > and avoid copy_to_user().
> > > >
> > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > > Cc: Soheil Hassas Yeganeh <soheil@google.com>
> > >
> > > Hi Eric!
> > >
> > > This appears to break boot on my systems.
> > >
> > > IDK how exactly, looks like systemd gets stuck waiting for nondescript
> > > services to start in initramfs. I have lots of debug enabled and didn't
> > > spot anything of note in kernel logs.
> > >
> > > I'll try to poke at this more, but LMK if you have any ideas. The
> > > commit looks "obviously correct" :S
> >
> > Oops, my rebase went wong, sorry for that
>
> Ah, my eyes failed to spot that :)
>
> > Can you check this  patch (on top of the buggy one) ?
> >
> > If that works, I'll submit a v2
>
> It's already merged. Let me try the fix now...

I have sent the official patch, thanks for this fast feedback !
