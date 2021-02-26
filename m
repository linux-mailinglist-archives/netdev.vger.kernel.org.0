Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94483269F0
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 23:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhBZWXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 17:23:42 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:51958 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230164AbhBZWXl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 17:23:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1614378177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tDpDlwTHh+iIyqiy98eYvpSrVbYasf3uJsqF7je5n4M=;
        b=hB6O/RM565wiR12FUjmu+gz21fo9XLcCubED6g2IikOtJCb1MmuaMqNJnFtpGzsVzl9ngc
        ECCEt+Yu62xuW+Kgy0JPm3lQG/bPcH0X85tc04MPkt1F0+t0gcjmf1zhQ9/BTbXO743TYp
        N3nUVDaB+taCXS0aCjtF326wzMlKeWg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b113cd66 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 26 Feb 2021 22:22:56 +0000 (UTC)
Received: by mail-yb1-f180.google.com with SMTP id u3so10419095ybk.6
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 14:22:56 -0800 (PST)
X-Gm-Message-State: AOAM5335LiaR6Aw9jD6MFOvibEjqphqt6NggSUZzPsT7X79e3CTVIwjC
        4nEp5uxQO2WaCEJTKKaOyaCq9Cl1QlxDZS16Gp8=
X-Google-Smtp-Source: ABdhPJyPMTy5DgcIAwU03hBaIK0nbn/a9XDiM087aYJJHeFrp3nLBGQ/Ty8SYWteVampgtlmB+LY4qWsQO9Ye2+c9/o=
X-Received: by 2002:a25:8712:: with SMTP id a18mr7626756ybl.306.1614378176495;
 Fri, 26 Feb 2021 14:22:56 -0800 (PST)
MIME-Version: 1.0
References: <20210225234631.2547776-1-Jason@zx2c4.com> <CA+FuTScmM12PG96k8ZjGd1zCjAaGzjk3cOS+xam+_h6sx2_HDA@mail.gmail.com>
In-Reply-To: <CA+FuTScmM12PG96k8ZjGd1zCjAaGzjk3cOS+xam+_h6sx2_HDA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 26 Feb 2021 23:22:45 +0100
X-Gmail-Original-Message-ID: <CAHmME9o2yPQ+Ai12XcCjF3jMVcMT_aooFCeKkfgFFOnqPmK_yg@mail.gmail.com>
Message-ID: <CAHmME9o2yPQ+Ai12XcCjF3jMVcMT_aooFCeKkfgFFOnqPmK_yg@mail.gmail.com>
Subject: Re: [PATCH] net: always use icmp{,v6}_ndo_send from ndo_start_xmit
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 10:25 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Feb 25, 2021 at 6:46 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > There were a few remaining tunnel drivers that didn't receive the prior
> > conversion to icmp{,v6}_ndo_send. Knowing now that this could lead to
> > memory corrution (see ee576c47db60 ("net: icmp: pass zeroed opts from
> > icmp{,v6}_ndo_send before sending") for details), there's even more
> > imperative to have these all converted. So this commit goes through the
> > remaining cases that I could find and does a boring translation to the
> > ndo variety.
> >
> > Cc: Willem de Bruijn <willemb@google.com>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>
> Using a stack variable over skb->cb[] is definitely the right fix for
> all of these. Thanks Jason.
>
> Only part that I don't fully know is the conntrack conversion. That is
> a behavioral change. What is the context behind that? I assume it's
> fine. In that if needed, that is the case for all devices, nothing
> specific about the couple that call icmp(v6)_ndo_send already.

That's actually a sensible change anyway. icmp_send does something
bogus if the packet has already passed through netfilter, which is why
the ndo variant was adopted. So it's good and correct for these to
change in that way.

Jason
