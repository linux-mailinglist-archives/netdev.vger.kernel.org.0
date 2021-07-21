Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC99F3D0BC5
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 12:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbhGUIku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 04:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236733AbhGUIbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 04:31:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08FF860FE9
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 09:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626858745;
        bh=m6A+yIrHXTFesp1MogKqTyNNizrUw8mq8jszGGFCEHs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SLjn2Dl3HcPrVu5k6E5lTfZ3ZF1h9eHSOzZPsSvW9CB0NeOboC/8u2a6qdBQzAhh0
         yUJkTgD9WbE9Ww6A4eyxxh0P1XLXJ6PCGgzf2iBzuldEsOTzF/FAvbW1349hXQhXus
         4Hpoxkf2nVj+MXBew4OIu/2AyFRkP3ir/5UAyFErgwcdbzIya+kB5Wh+3JQOBq2XGE
         e3L7qlGXE+WM+bQYebUBqHy6NxubeurfM1oca0YOZJu90FuZInL4SE/T4u7oy/lyay
         Si2s2Ovrm06idfvh01xnsmcw9FzYhcwV5Sly45nEpFHxRsxydB1ZiFRZbn5t5m5q6I
         z5T2BSdYjCcoQ==
Received: by mail-wr1-f47.google.com with SMTP id k4so1358458wrc.8
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 02:12:24 -0700 (PDT)
X-Gm-Message-State: AOAM530F0s6SRmk9cQDOU6u7VwB/ZPNRaFXIuetR1rvsHSYjo5hAL8HA
        DZSd+a/ytBkJkmD2ULSRcku2SInPv51FEX+cCUU=
X-Google-Smtp-Source: ABdhPJxW8J6KE9TLuawWr667LpKSxhP48gAhQbOQVSsOCqBIDhQQtsfdkcU0PN4Z8D0LC2/gIO5dur2xqVukuJDtoq4=
X-Received: by 2002:adf:b318:: with SMTP id j24mr42689041wrd.361.1626858743588;
 Wed, 21 Jul 2021 02:12:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210720142436.2096733-1-arnd@kernel.org> <20210720142436.2096733-4-arnd@kernel.org>
 <20210721073250.GC11257@lst.de>
In-Reply-To: <20210721073250.GC11257@lst.de>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 21 Jul 2021 11:12:07 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1gY63K0-J4mqtmLvKg1G1Bm0TzeA_Jjdn56Luae-bJdQ@mail.gmail.com>
Message-ID: <CAK8P3a1gY63K0-J4mqtmLvKg1G1Bm0TzeA_Jjdn56Luae-bJdQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] net: socket: simplify dev_ifconf handling
To:     Christoph Hellwig <hch@lst.de>
Cc:     Networking <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 9:32 AM Christoph Hellwig <hch@lst.de> wrote:
>
> > The implementation can be simplified further, based on the
> > knowledge that the dynamic registration is only ever used
> > > for IPv4.
>
> I think dropping register_gifconf (which seems like a nice cleanup!)
> needs to be a separate prep patch to not make this too confusing.

Right, good idea.

> > index e6231837aff5..4727c7a3a988 100644
> > --- a/include/linux/compat.h
> > +++ b/include/linux/compat.h
> > @@ -104,6 +104,11 @@ struct compat_ifmap {
> >       unsigned char port;
> >  };
> >
> > +struct compat_ifconf {
> > +     compat_int_t    ifc_len;                /* size of buffer */
> > +     compat_uptr_t   ifcbuf;
> > +};
> > +
> >  #ifdef CONFIG_COMPAT
> >
> >  #ifndef compat_user_stack_pointer
> > @@ -326,12 +331,6 @@ typedef struct compat_sigevent {
> >       } _sigev_un;
> >  } compat_sigevent_t;
> >
> > -struct compat_if_settings {
> > -     unsigned int type;      /* Type of physical device or protocol */
> > -     unsigned int size;      /* Size of the data allocated by the caller */
> > -     compat_uptr_t ifs_ifsu; /* union of pointers */
> > -};
>
> Does this actually compile as-is?  It adds a second definition of
> compat_ifconf but removes the still used compat_if_settings?

Indeed it does not. I must have applied a hunk to the wrong patch
in an earlier rebase, and the build bots never picked up on it because
the series was fine in the end.

> Maybe it would be a better idea to add a prep patch that makes as much
> as possible of compat.h available unconditionally instead of all these
> little moves.

Ok, I'll figure something out.

        Arnd
