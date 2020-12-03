Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65142CE27D
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 00:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731221AbgLCXPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 18:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgLCXPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 18:15:36 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5476C061A51
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 15:14:55 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id 81so3859102ioc.13
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 15:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/0w0grx4nXcnsLWMOvuB//amwWOUOHjVlIbJsLPJ0NE=;
        b=EzZuFhgM63Zy0NNQhHJvWWqchqorWmhW6I/LzMNfUARIWitC44VC2YRx/NSyoLdkj2
         7c0dOANSxscLGaRlbfmzRPF9iBaDHeYZFqyxAIyHKpTh7ZYM6VBSUcqr2aKyhkAA7Wfb
         2s14M9de3GjkSOtMqyIF7iCZ1gDwFI9LLP25sex8woWrWrF+J7+n3GD1+Et/AIPJzBxM
         7HCwLG+cbrO68Wi4TygfMiCYYCuYAJ81cSKGMTtT8lYFuRDBK42dcLL7A8Fc44WZjjmy
         SLCeRx0+f18VgDZ6P8J/btfMs9JHf0f7i+ZV4YFlz525RuEkFX0CVc3wyRqs2BpmbGUM
         7Rkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/0w0grx4nXcnsLWMOvuB//amwWOUOHjVlIbJsLPJ0NE=;
        b=FacnYlfpSUQUesNeqbRyc0zOKeCDPYdbS+AqBX+2a35YJoeoWNp1vK2FATpNUCb8vA
         jNMSJ/J+wwz4H3UiM9i57xZ0G/MsMEm/i9R1gqbPQA+yZI3fNGRKK1rwx61WYFasWqf/
         sO5dkpqLzSCzJXoVopD+OzjtJj3LLngwkBV5OZmi0YQBxzaG/DB3oCFbqXlB7NpB4fvp
         2SskU4hDbHgaYkhRZL7T4aoK0QjKFt3U3QbwsElPDNCWbTWWy6D/qrz39POfRrLHdGM6
         4l2QUmT3eYPMn6Qm2e0bAGlwU5KELMIY46V9XeuKEtv6IafC24s8hHMpQUDv3PX6lCWY
         /xSw==
X-Gm-Message-State: AOAM530DswdEzmtGnO6fatapLQif6IyOeJwHf8PKEqMZZ250KyDjkDgB
        bSBxJou8PtL8Iq8paGW8/eHSmdqwaIWcVunPLvJWnw==
X-Google-Smtp-Source: ABdhPJxrzNPBKEgtznp3TIdBil16SeQgtZYdspsFCKWyoez94+LR5wnaOEgmjs3HSGS9n48cW/SpYPunYxO6VDQ7sK8=
X-Received: by 2002:a02:7821:: with SMTP id p33mr2003703jac.53.1607037294995;
 Thu, 03 Dec 2020 15:14:54 -0800 (PST)
MIME-Version: 1.0
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
 <20201202220945.911116-2-arjunroy.kdev@gmail.com> <20201202161527.51fcdcd7@hermes.local>
 <384c6be35cc044eeb1bbcf5dcc6d819f@AcuMS.aculab.com>
In-Reply-To: <384c6be35cc044eeb1bbcf5dcc6d819f@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Dec 2020 00:14:42 +0100
Message-ID: <CANn89iKfUdRygt_k2Axf1MZ2FzkOQ9R6S2oJAvKuLqRp-wZvsQ@mail.gmail.com>
Subject: Re: [net-next v2 1/8] net-zerocopy: Copy straggler unaligned data for
 TCP Rx. zerocopy.
To:     David Laight <David.Laight@aculab.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "arjunroy@google.com" <arjunroy@google.com>,
        "soheil@google.com" <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 12:01 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Stephen Hemminger
> > Sent: 03 December 2020 00:15
> >
> > On Wed,  2 Dec 2020 14:09:38 -0800
> > Arjun Roy <arjunroy.kdev@gmail.com> wrote:
> >
> > > diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> > > index cfcb10b75483..62db78b9c1a0 100644
> > > --- a/include/uapi/linux/tcp.h
> > > +++ b/include/uapi/linux/tcp.h
> > > @@ -349,5 +349,7 @@ struct tcp_zerocopy_receive {
> > >     __u32 recv_skip_hint;   /* out: amount of bytes to skip */
> > >     __u32 inq; /* out: amount of bytes in read queue */
> > >     __s32 err; /* out: socket error */
> > > +   __u64 copybuf_address;  /* in: copybuf address (small reads) */
> > > +   __s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
>
> You need to swap the order of the above fields to avoid padding
> and differing alignments for 32bit and 64bit apps.

I do not think so. Please review this patch series carefully.


>
> > >  };
> > >  #endif /* _UAPI_LINUX_TCP_H */
> >
> > You can't safely grow the size of a userspace API without handling the
> > case of older applications.  Logic in setsockopt() would have to handle
> > both old and new sizes of the structure.
>
> You also have to allow for old (working) applications being recompiled
> with the new headers.
> So you cannot rely on the fields being zero even if you are passed
> the size of the structure.

This is too late, there is precedent for this.

We already mentioned this in tcp_mmap.c reference program.



commit bf5525f3a8e3248be5aa5defe5aaadd60e1c1ba1
Author: Eric Dumazet <edumazet@google.com>
Date:   Tue May 5 20:51:06 2020 -0700

    selftests: net: tcp_mmap: clear whole tcp_zerocopy_receive struct

    We added fields in tcp_zerocopy_receive structure,
    so make sure to clear all fields to not pass garbage to the kernel.

    We were lucky because recent additions added 'out' parameters,
    still we need to clean our reference implementation, before folks
    copy/paste it.

    Fixes: c8856c051454 ("tcp-zerocopy: Return inq along with tcp
receive zerocopy.")
    Fixes: 33946518d493 ("tcp-zerocopy: Return sk_err (if set) along
with tcp receive zerocopy.")
    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Cc: Arjun Roy <arjunroy@google.com>
    Cc: Soheil Hassas Yeganeh <soheil@google.com>
    Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/tools/testing/selftests/net/tcp_mmap.c
b/tools/testing/selftests/net/tcp_mmap.c
index 35505b31e5cc092453ea7b72d9dba45bed2d6549..62171fd638c817dabe2d988f3cfae74522112584
100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -165,9 +165,10 @@ void *child_thread(void *arg)
                        socklen_t zc_len = sizeof(zc);
                        int res;

+                       memset(&zc, 0, sizeof(zc));
                        zc.address = (__u64)((unsigned long)addr);
                        zc.length = chunk_size;
-                       zc.recv_skip_hint = 0;
+
                        res = getsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE,
                                         &zc, &zc_len);
                        if (res == -1)




>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
