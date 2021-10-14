Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC2B42E350
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 23:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhJNVhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 17:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhJNVhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 17:37:42 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119F3C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 14:35:37 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id d131so17963838ybd.5
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 14:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9MrEqCMd3fs3WsNk35T8o2Ev4bBtF/8vXsYb2IQQFSw=;
        b=qGjD/Xzst/yOB1VypJbxkO7EVzSomy7AVRHpDsMLioAV2t40tcspUEQ4QP/RPQ/lWy
         5G6HV/2TMJ9gN1Mn/yAJXP/NQzBc0AgJH+UrVgRUhcJ/jTdZbRDE605yItv0lNbxIiB6
         cHHTitoIs0gIMYhpGJmKiAeZ295ClVTxmJH1ytPu4C+UiUgR8eKzArmMyij6phE7Rkk4
         RKGEllMNql4azraXqjqrRWhuJ3QK/p7uY2IjNNPRFzmJWuwVNbp5wTldG/AhEi6MuxVa
         VLfHXRgXmoAQQl5P3ipNUteRF3+NQst+zauy2J1FsO5K2eTapHJOTxSldIxhCXm5Yu83
         CnoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9MrEqCMd3fs3WsNk35T8o2Ev4bBtF/8vXsYb2IQQFSw=;
        b=WWzUCWIRKpm4eAZM+/pozNcl/vjj7t3NkSt7gSKVkLB/lmvcRaX0mSs/B/cYwMqlRd
         nJqyY44JjqfM48wVyySzjCx35r7Vs1MVruaZAEOXZHlSoqwpI7+o5hOTXETjHkj4gxzr
         YTZ7IufG57GudKzw6S90Wlo0yxvQlZJF5uO/Mkshwo4B1Bk1MfDkW7Tsfnr9FRGaz2Rt
         9aOvD9OHSVQgMtB+gSOKR5rv+20fLfMfsKSm/q6vaPuZUvNGAGEUQcO7rtH3JMRaAfAu
         5L0ZEBVexK0ayG5labhlA6gJcPimevQk039GTdaJw/8dcEV2wHrvHzvCYlcAyKyAZiT+
         DsIg==
X-Gm-Message-State: AOAM530H0zRdayl3ALNB9Pm6CqHazzZKK4k2OYr4tsUpidA8D8wBKTZ9
        gx207nD7xKS2jTXfDcebNjYUaOmTnZbjBpMUs3RmOA==
X-Google-Smtp-Source: ABdhPJy3Bb9nbWcqCUiE7qpCmvm0YaeuxtVqF74NTvrZXdzzsEjBKoBMxZK+ZBJVm6XGH+oDVK7b1a92OrOh284RQ84=
X-Received: by 2002:a25:c696:: with SMTP id k144mr8366273ybf.296.1634247335903;
 Thu, 14 Oct 2021 14:35:35 -0700 (PDT)
MIME-Version: 1.0
References: <20211014175918.60188-1-eric.dumazet@gmail.com>
 <20211014175918.60188-3-eric.dumazet@gmail.com> <87wnmf1ixc.fsf@toke.dk>
In-Reply-To: <87wnmf1ixc.fsf@toke.dk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 14 Oct 2021 14:35:24 -0700
Message-ID: <CANn89iLbJL2Jzot5fy7m07xDhP_iCf8ro8SBzXx1hd0EYVvHcA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] fq_codel: implement L4S style
 ce_threshold_ect1 marking
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>, Bob Briscoe <in@bobbriscoe.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 12:54 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Eric Dumazet <eric.dumazet@gmail.com> writes:
>
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Add TCA_FQ_CODEL_CE_THRESHOLD_ECT1 boolean option to select Low Latency=
,
> > Low Loss, Scalable Throughput (L4S) style marking, along with ce_thresh=
old.
> >
> > If enabled, only packets with ECT(1) can be transformed to CE
> > if their sojourn time is above the ce_threshold.
> >
> > Note that this new option does not change rules for codel law.
> > In particular, if TCA_FQ_CODEL_ECN is left enabled (this is
> > the default when fq_codel qdisc is created), ECT(0) packets can
> > still get CE if codel law (as governed by limit/target) decides so.
>
> The ability to have certain packets receive a shallow marking threshold
> and others regular ECN semantics is no doubt useful. However, given that
> it is by no means certain how the L4S experiment will pan out (and I for
> one remain sceptical that the real-world benefits will turn out to match
> the tech demos), I think it's premature to bake the ECT(1) semantics
> into UAPI.

Chicken and egg problem.
We had fq_codel in linux kernel years before RFC after all :)

>
> So how about tying this behaviour to a configurable skb->mark instead?
> That way users can get the shallow marking behaviour for any subset of
> packets they want, simply by installing a suitable filter on the
> qdisc...

This seems an idea, but do you really expect users installing a sophisticat=
ed
filter ? Please provide more details, and cost analysis.
(Having to install a filter is probably more expensive than testing a boole=
an,
after the sojourn time  has exceeded the threshold)

Given that INET_ECN_set_ce(skb) only operates on ECT(1) and ECT(0),
I guess we could  use a bitmask of two bits so that users can decide
which code points can become CE.
