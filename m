Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EA81FAAFC
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 10:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgFPIU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 04:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgFPIU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 04:20:57 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4BCC05BD43
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 01:20:56 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id mb16so20526049ejb.4
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 01:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nx102nMJD7m9CKmVQHFFSn4mFPyTSxDfnq/bvaKXpRs=;
        b=uymIM/pgfXm4iFrKMkahcIIyGD5085KyZ1UOaqz7bOIlwf1nQYmD4jUnSCgQi+WaVa
         vbgUyig/mhr301Ghi+9xXFEh1L1vXsM75Zc3iTqwcX2TjMuWhPee+cqMgl1FiRjsDjV2
         UWCQDU1WtpNT3nVhBIgVIrySilu0tilZZLIXqyxNGQULTSiRQJUAX1QiK3i2lk/GUh4D
         QniB3b0n+1TZ+KvjmSB6N/u1UhM7QhHUFx0Nn/kANFfwRm+Z+mv1MCbjwwU8hwb60T2/
         8HZuKmcevOxF2QdGYvroFb/UQVtZqYC3+wmvK9murrmv+efGrXwhDFX2ltL1II4/qqS7
         lZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nx102nMJD7m9CKmVQHFFSn4mFPyTSxDfnq/bvaKXpRs=;
        b=gbvj8tevAGTi8rVmRc2L+ZaZarRqRomB+q+KTyOKUnusvLZ/6Zh8neLAL37Ub2hJsl
         /2RfUL5yNNfpfgYn41vG5M0Vt9H/yJzOQmrw2zJteDF5Bymba6SYfs3UDkFPVDT29El1
         0MX9FfA9/eHS2WMLz/mS2N2e7bamm6ObGY73wy4+78QPrcyRM/73bTAb7PCuwJDB5pVq
         MiBSYEgIkqbc7b8tIp7n0hdnbwiNbswKRZ8HGvXtAl5vKcFP7fOZ/aB26qCD694CBETe
         scRcBGuSprE6w3agGEs+u/PLUMwrHT5mgSxM/RuCRF5Lx57eAb6DHywbl50+oRTv8rqX
         g2pg==
X-Gm-Message-State: AOAM532jmTTY3mR0f0GGcmkvWCQE6rHmkNPv1/iMslorGhiCI1R67NJj
        pvsNNpcqLVGuk/Wl9CppV+cr2y0o0PN6CrUbfN4=
X-Google-Smtp-Source: ABdhPJxb2/qy3JYBq6u074+sMDFI74eWflygZxFEkejZQOGKp73mcAQgYQITah2jQ0gv8bT2504Uw368lHUgPZJjbh4=
X-Received: by 2002:a17:906:1149:: with SMTP id i9mr1782689eja.100.1592295655476;
 Tue, 16 Jun 2020 01:20:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592247564.git.dcaratti@redhat.com> <4a4a840333d6ba06042b9faf7e181048d5dc2433.1592247564.git.dcaratti@redhat.com>
 <CA+h21ho1x1-N+HyFXcy+pqdWcQioFWgRs0C+1h+kn6w8zHVUwQ@mail.gmail.com> <20200615.180022.2063479179425015644.davem@davemloft.net>
In-Reply-To: <20200615.180022.2063479179425015644.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 16 Jun 2020 11:20:44 +0300
Message-ID: <CA+h21hps0H21u16xYOOfoohXHmGZYLCK-zuDuxDWQvX3-NU0DQ@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] net/sched: act_gate: fix configuration of the
 periodic timer
To:     David Miller <davem@davemloft.net>
Cc:     dcaratti@redhat.com, Po Liu <Po.Liu@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jun 2020 at 04:00, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Tue, 16 Jun 2020 00:55:50 +0300
>
> > On Mon, 15 Jun 2020 at 22:33, Davide Caratti <dcaratti@redhat.com> wrote:
> >>
> >> assigning a dummy value of 'clock_id' to avoid cancellation of the cycle
> >> timer before its initialization was a temporary solution, and we still
> >> need to handle the case where act_gate timer parameters are changed by
> >> commands like the following one:
> >>
> >>  # tc action replace action gate <parameters>
> >>
> >> the fix consists in the following items:
> >>
> >> 1) remove the workaround assignment of 'clock_id', and init the list of
> >>    entries before the first error path after IDR atomic check/allocation
> >> 2) validate 'clock_id' earlier: there is no need to do IDR atomic
> >>    check/allocation if we know that 'clock_id' is a bad value
> >> 3) use a dedicated function, 'gate_setup_timer()', to ensure that the
> >>    timer is cancelled and re-initialized on action overwrite, and also
> >>    ensure we initialize the timer in the error path of tcf_gate_init()
> >>
> >> v2: avoid 'goto' in gate_setup_timer (thanks to Cong Wang)
> >>
> >
> > The change log is put under the 3 '---' characters for a reason: it is
> > relevant only to reviewers, and git automatically trims it when
> > applying the patch. The way it is now, the commit message would
> > contain this line about "v2 ...".
>
> I completely disagree and I ask submitters of networking changes to keep
> the changelog in the commit message.
>
> Later people will look at this commit and ask "why didn't they do X
> or Y" and if the changelog shows that the submitter was asked not to
> do X or Y that is useful information.

Interesting, I didn't know that. If there are really relevant changes
which might matter post-review (which I don't consider "avoid 'goto'
in gate_setup_timer" to be), I usually try to integrate them better
into the main commit message. Nonetheless, sorry, feel free to ignore
me!

-Vladimir
