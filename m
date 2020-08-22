Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6599124E40F
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 02:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgHVAJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 20:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgHVAJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 20:09:11 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DC9C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 17:09:10 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t6so1498861pjr.0
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 17:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rMyn9hs8emrrp0I2fsXhbGlcFRovhDs1WAWzfMJwEx4=;
        b=p018XZOiEljEtc2ycbIpB0lTbHw1bBliiUXmE3s0YLf9cvCeOQL2VcfkciHThilnFh
         UVSIMLr5lxYH5bnL3IywfljcMuXyspJ87Hf21091OktXSFEI8tOFA+rn2WexulkPwH4I
         iNifCITj6vsEAJZ3Gi3TSP0AIO26mX6d5a49oYMNKoK/BrSszJsRkxFZ0miLZ4+lNKb5
         P7F7kHYJ/JyugHy8sodf5NMUK6Rdc/quPfOfm+ubeisvCnWRRJV93iPP6eyf/ZiecANf
         uxdeghNoI4L5pelF8fgtCOvQpYfAhJF0iAEI4PsWfrX3OrBPDgKuNC1eYoXT/YsP3CwS
         OkNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rMyn9hs8emrrp0I2fsXhbGlcFRovhDs1WAWzfMJwEx4=;
        b=RQ8atdhEQsVZDww6jPC0B+cnkyRZFb7sWb8pV6xFHdfDZnQgxksh3iYNUmW1BUz5ts
         IjiWp53PDzW1Z2rLMXGT9cz4aLc62t+zO3elpww5zh++dQ+csWppIdfq8jQsAZ9bWLEh
         xYhnGez8MZACE/e/2T0uJ7e7/fB3AlIkxOWVwjQFFcsnGztVh5OJl8x1G8DhbYuQIEzv
         gXhlWndpgZQaWvIkWLEoZIZ6Ypp4ejYfMJDbEaMTjdHvTSEQPwiJB4NwErn+0/Y2Bje7
         NPvYaEW3U2AwTSCgHA0un9kL3hVwnm4G6EMLx/6Az75eiZjf7CTah5KCXp1h6LUiGNJk
         Xn8Q==
X-Gm-Message-State: AOAM533F1INcWc1LGYupe8K9EfA5CyuVG3tpLdnNmn+tET+TudeW1Ndb
        65gmlhvpPFWMiJICkJLiABW2CQiNqUSerMaBG7E3pg==
X-Google-Smtp-Source: ABdhPJyUUodVS7tvT9BRZs2Sb+IQ0+CuyYBPef+b15l0eAgb2ry1HvczlGj0naEdCz087F0X7T9nCSzJFnWFUk7jKoU=
X-Received: by 2002:a17:902:ec02:: with SMTP id l2mr4167910pld.153.1598054949675;
 Fri, 21 Aug 2020 17:09:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200820234954.1784522-1-luke.w.hsiao@gmail.com>
 <20200820234954.1784522-3-luke.w.hsiao@gmail.com> <20200821134144.642f6fbb@kicinski-fedora-PC1C0HJN>
 <d0819955-6466-9c11-880d-ae607f033b84@kernel.dk>
In-Reply-To: <d0819955-6466-9c11-880d-ae607f033b84@kernel.dk>
From:   Luke Hsiao <lukehsiao@google.com>
Date:   Fri, 21 Aug 2020 17:08:43 -0700
Message-ID: <CADFWnLzwUjs7Sw98y0vitTyPxCzsopeYKO0bVdG9r4uG7qBg2g@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] io_uring: ignore POLLIN for recvmsg on MSG_ERRQUEUE
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Luke Hsiao <luke.w.hsiao@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub and Jens,

Thank you for both of your reviews. Some responses inline below.

On Fri, Aug 21, 2020 at 2:11 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/21/20 2:41 PM, Jakub Kicinski wrote:
> > On Thu, 20 Aug 2020 16:49:54 -0700 Luke Hsiao wrote:
> >> +    /* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
> >> +    if (req->opcode == IORING_OP_RECVMSG && (sqe->msg_flags & MSG_ERRQUEUE))
> >> +            mask &= ~(POLLIN);
> >
> > FWIW this adds another W=1 C=1 warnings to this code:
> >
> > fs/io_uring.c:4940:22: warning: invalid assignment: &=
> > fs/io_uring.c:4940:22:    left side has type restricted __poll_t
> > fs/io_uring.c:4940:22:    right side has type int
>
> Well, 8 or 9 of them don't really matter... This is something that should
> be cleaned up separately at some point.

In the spirit of not adding a warning, even if it doesn't really
matter, I'd like to fix this. But, I'm struggling to reproduce these
warnings using upstream net-next and make for x86_64. With my patches
on top of net-next/master, I'm running

$ make defconfig
$ make -j`nproc` W=1

I don't see the warning you mentioned in the logs. Could you tell me
how I can repro this warning?

> > And obviously the brackets around POLLIN are not necessary.
>
> Agree, would be cleaner without!

Thanks, I'll also remove these unnecessary parens in v2 of the patch series.

--
Luke
