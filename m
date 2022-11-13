Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53BB626DD7
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 07:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbiKMGKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 01:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiKMGK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 01:10:29 -0500
Received: from smtp3.cs.Stanford.EDU (smtp3.cs.stanford.edu [171.64.64.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E5CDE9F
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 22:10:28 -0800 (PST)
Received: from mail-ej1-f46.google.com ([209.85.218.46]:40789)
        by smtp3.cs.Stanford.EDU with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <ouster@cs.stanford.edu>)
        id 1ou6CJ-0006l1-4W
        for netdev@vger.kernel.org; Sat, 12 Nov 2022 22:10:28 -0800
Received: by mail-ej1-f46.google.com with SMTP id kt23so21259854ejc.7
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 22:10:27 -0800 (PST)
X-Gm-Message-State: ANoB5pmWnWEcz3oqnvJf9pLoC46Uf8IEIm/88wJSDSKvIM5yIeyKlGTr
        HpmLl8en7nb/MsQIhAzqYp3Ox7dsDFizqJ7dd6w=
X-Google-Smtp-Source: AA0mqf7jdYGDPIRGh1XoqVfbFc2c3mEnmpgLDKM/+EE/OEJqNUyJ6eFguTlosGZjbo97YPGqmJEJ7W9+fX6HWvzgG3I=
X-Received: by 2002:a17:906:654a:b0:78d:e645:9f7d with SMTP id
 u10-20020a170906654a00b0078de6459f7dmr6470128ejn.572.1668319826407; Sat, 12
 Nov 2022 22:10:26 -0800 (PST)
MIME-Version: 1.0
References: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
 <20221110132540.44c9463c@hermes.local> <Y22IDLhefwvjRnGX@lunn.ch>
 <CAGXJAmw=NY17=6TnDh0oV9WTmNkQCe9Q9F3Z=uGjG9x5NKn7TQ@mail.gmail.com> <Y26huGkf50zPPCmf@lunn.ch>
In-Reply-To: <Y26huGkf50zPPCmf@lunn.ch>
From:   John Ousterhout <ouster@cs.stanford.edu>
Date:   Sat, 12 Nov 2022 22:09:48 -0800
X-Gmail-Original-Message-ID: <CAGXJAmzrjKUUDNk0GEvqCNk0SUgtdh=rkDhYSDBogoDyUmr9Tg@mail.gmail.com>
Message-ID: <CAGXJAmzrjKUUDNk0GEvqCNk0SUgtdh=rkDhYSDBogoDyUmr9Tg@mail.gmail.com>
Subject: Re: Upstream Homa?
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Score: -1.0
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Scan-Signature: 6890477ab20817755420d5b1edd0addc
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 11:25 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Nov 11, 2022 at 10:59:58AM -0800, John Ousterhout wrote:
> > The netlink and 32-bit kernel issues are new for me; I've done some digging to
> > learn more, but still have some questions.
> >
>
> > * Is the intent that netlink replaces *all* uses of /proc and ioctl? Homa
> > currently uses ioctls on sockets for I/O (its APIs aren't sockets-compatible).
> > It looks like switching to netlink would double the number of system calls that
> > have to be invoked, which would be unfortunate given Homa's goal of getting the
> > lowest possible latency. It also looks like netlink might be awkward for
> > dumping large volumes of kernel data to user space (potential for buffer
> > overflow?).
>
> I've not looked at the actually code, i'm making general comments.
>
> netlink, like ioctl, is meant for the control plain, not the data
> plain. Your statistics should be reported via netlink, for
> example. netlink is used to configure routes, setup bonding, bridges
> etc. netlink can also dump large volumes of data, it has no problems
> dumping the full Internet routing table for example.
>
> How you get real packet data between the userspace and kernel space is
> a different question. You say it is not BSD socket compatible. But
> maybe there is another existing kernel API which will work? Maybe post
> what your ideal API looks like and why sockets don't work. Eric
> Dumazet could give you some ideas about what the kernel has which
> might do what you need. This is the uAPI point that Stephen raised.

OK, will do. I'm in the middle of a major API refactor, so I'll wait
until that is
resolved before pursing this issue more.

> > * By "32 bit kernel problems" are you referring to the lack of atomic 64-bit
> > operations and using the facilities of u64_stats_sync.h, or is there a more
> > general issue with 64-bit operations?
>
> Those helpers do the real work, and should optimise to pretty much
> nothing on an 64 bit kernel, but do the right thing on 32 bit kernels.
>
> But you are right, the general point is that they are not atomic, so
> you need to be careful with threads, and any access to a 64 bit values
> needs to be protected somehow, hopefully in a way that is optimised
> out on 64bit systems.

Is it acceptable to have features that are only supported on 64-bit kernels?
This would be my first choice, since I don't think there will be much interest
in Homa on 32-bit platforms.

If that's not OK, are there any mechanisms available for helping people
test on 32-bit platforms? For example, is it possible to configure Linux to
compile in 32-bit mode so I could test that even on a 64-bit machine
(I don't have access to a 32-bit machine)?

-John-
