Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E88A210212
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 04:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgGACa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 22:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbgGACa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 22:30:56 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BF2C03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 19:30:56 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id y13so11168229ybj.10
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 19:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=orh850FlYi6ymGIsnPeKmpVTbgMuFgP3BsMdOWApeO8=;
        b=WPVzRSe29IxXSIUGCzVBbN1Fvdz+LCN0ILXxYv+auvExF/M2kQMNV2v5XMT2C5IS8A
         HArtPGBdd6KV5ibhE7QbBN6ClyFqAikrJrmgQexb3syQM2wCppMa+qo/cUlxyYyjsSJW
         a8cwjoUSABWMyYyDZwGzBFbH14tGo+oBrSMqBaIboOuCxNxavlD9uB8iOXHBVyh03xWU
         tTcZJybPRgya2NcY6jFXx7G7AC7XsI9gv/oDkVk4vtpgeFoIY9YB1HSiIJc1OizOeYUJ
         uzSdhPyLyjlO/DEKUV4+sEKFOEaJt4mRuZbDN4lPrmc2/2gTxIyFEqKF3cQNUAaNIq1b
         6bBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=orh850FlYi6ymGIsnPeKmpVTbgMuFgP3BsMdOWApeO8=;
        b=rX+t0914SH5Ydpx2o3BUx2EHJhTbvMBcM+ON6Ibvjm+cZ99aR9lmm/fecynCC9eaqC
         G+7bNo3jpreRppbZSNlE8KEOd7Ot8aZ/8hs+sI1lHaKxSottHV5Rgq9M6e3bt6IorY9j
         D6XOs+lm0WAQyab1teB5rWpc1dYFslj1r+NlIkgj9ck3t9r6A0yWS+0dZp73cV9oT/Sn
         7HhhPHbuiEbXkCYUFFl1VyPF+0b3ituWXdZ2845niz1ybByZD8zfVMisMFDFcZps+8Zo
         sXzKsfPIBEbck+fIltBoKIKfTeed4oiFFoDZchW1fxk2Op03Ds5W3oST7UpeLFY/sRT3
         HbWg==
X-Gm-Message-State: AOAM531V5Qck8Uy7Fr7xFfgGrOTCh1QjlH71qJ5r28oSucWL84u5DeoI
        JhPEApU/1+0G1V8/8VkhxmK3ct6RWCxMuFWHY48GEtP9pQc=
X-Google-Smtp-Source: ABdhPJwsOFM+bWqFepo8ZmFEToJ3SswQgejDI7L7embhj1VChymRUikpgSLMJsjAySkiB6Ec3Kaa3FE3fFIoe4z4LDo=
X-Received: by 2002:a25:b8c5:: with SMTP id g5mr920040ybm.395.1593570655562;
 Tue, 30 Jun 2020 19:30:55 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iLPqtJG0iESCHF+RcOjo95ukan1oSzjkPjoSJgKpO2wSQ@mail.gmail.com>
 <20200701020211.GA6875@gondor.apana.org.au> <CANn89iKP-evuLxeLo6p_98T+FuJ-J5YaMTRG230nqj3R=43tVA@mail.gmail.com>
 <20200701022241.GA7167@gondor.apana.org.au>
In-Reply-To: <20200701022241.GA7167@gondor.apana.org.au>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Jun 2020 19:30:43 -0700
Message-ID: <CANn89iLKZQAtpejcLHmOu3dsrGf5eyFfHc8JqoMNYisRPWQ8kQ@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 7:23 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Jun 30, 2020 at 07:17:46PM -0700, Eric Dumazet wrote:
> >
> > The main issue of the prior code was the double read of key->keylen in
> > tcp_md5_hash_key(), not that few bytes could change under us.
> >
> > I used smp_rmb() to ease backports, since old kernels had no
> > READ_ONCE()/WRITE_ONCE(), but ACCESS_ONCE() instead.
>
> If it's the double-read that you're protecting against, you should
> just use barrier() and the comment should say so too.

I made this clear in the changelog, do we want comments all over the places ?
Do not get me wrong, we had this bug for years and suddenly this is a
big deal...

    MD5 keys are read with RCU protection, and tcp_md5_do_add()
    might update in-place a prior key.

    Normally, typical RCU updates would allocate a new piece
    of memory. In this case only key->key and key->keylen might
    be updated, and we do not care if an incoming packet could
    see the old key, the new one, or some intermediate value,
    since changing the key on a live flow is known to be problematic
    anyway.

    We only want to make sure that in the case key->keylen
    is changed, cpus in tcp_md5_hash_key() wont try to use
    uninitialized data, or crash because key->keylen was
    read twice to feed sg_init_one() and ahash_request_set_crypt()
