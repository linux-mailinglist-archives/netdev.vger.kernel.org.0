Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9561A3D33D7
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 06:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhGWEL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 00:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbhGWEL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 00:11:27 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDA4C061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 21:52:01 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id q15so525866ybu.2
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 21:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=knRIGgFWyIcjOYSJBLC4OF11gQStImCh21tcZ5kw4HI=;
        b=gT2rHl6FD7eXWNs1RKT4vkjXGTbGv8F5trApBVArNy6Mpdraapzc5RsbJ5Pa/m3s86
         L+lDBwJFHZAIXCtfDuPBTga/eMBxlqgCVJyg1VvckIMU3pcZLJeym4ptIfuJgIo141GF
         VEfSsRLU8qP7pIKOp4B/o4vv/syBh28prQPui9k189ZrhQ8D/FAnk6XTlUbGe7AxRuG3
         OJaJSSMhh2MZv63Ok5e92N+IJG1Zgca62n5fyZFjMdHQiQ15Oosr6jCM5DVMNXOHi9SN
         bg0E0e7YfU6oBQNus4b9srG9O3tRuvPfsumlkaOLBKVdaiPR3WTO6R6cYuq45oiLarod
         ckbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=knRIGgFWyIcjOYSJBLC4OF11gQStImCh21tcZ5kw4HI=;
        b=tFAg3OgFNB0fPIOvfskcyrlQml+p3qGw1JMQwGtpFkJDUOTOzRYcyTwQ5ptByMRd/p
         uMAEfEYzPhD2w+Ovd+C4jIxfKchP6c5b0UhytScs3hh87eT+gtNBpCmy09xADTaVo9Vr
         CcW39ayBMkY0TaIOopF874yrstLPEyhRS4buH0mXU7BCffZXmRt88ET3jIg/q0+TtL+N
         q4qYnKrbS2guxhRBrwfilt4xQpJheFvwmKsymA3ruCgoXo/Tf/IgbZTsa4qDC4I8n6PS
         9kiuY1c8ARqVQQ/ogdJEvYibDfwHb9ippR1TrQqQHSsjF+Y5HSzqj6Or4KtXdpC9BW3F
         ghwQ==
X-Gm-Message-State: AOAM533PziHdwMgKZOoSUnbPwDvJ7tBiBUS6KTpAXr+7PGdAghaZMNRg
        3Yu6P7ywwxc6rcMJvg0Sy7tF7GAMwrvKIO0LGFk=
X-Google-Smtp-Source: ABdhPJziNutzII4feNDZkDX1T5BM0uzOqiW/KSqTZNxtOPNVP4Kb2aj0IO86zJNMGwSy5qHVVyg6eJjwEpOirjT6qRk=
X-Received: by 2002:a25:1455:: with SMTP id 82mr3998616ybu.403.1627015921097;
 Thu, 22 Jul 2021 21:52:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210705124307.201303-1-m@lambda.lt> <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
 <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt> <YPpIeppWpqFCSaqZ@Laptop-X1>
In-Reply-To: <YPpIeppWpqFCSaqZ@Laptop-X1>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Jul 2021 21:51:50 -0700
Message-ID: <CAEf4Bzavevcn=p7iBSH6iXMOCXp5kCu71a1kZ7PSawW=LW5NSQ@mail.gmail.com>
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple sections
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Martynas Pumputis <m@lambda.lt>,
        Networking <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 9:41 PM Hangbin Liu <haliu@redhat.com> wrote:
>
> On Wed, Jul 21, 2021 at 04:47:14PM +0200, Martynas Pumputis wrote:
> > > > diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
> > > > index d05737a4..f76b90d2 100644
> > > > --- a/lib/bpf_libbpf.c
> > > > +++ b/lib/bpf_libbpf.c
> > > > @@ -267,10 +267,12 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
> > > >          }
> > > >
> > > >          bpf_object__for_each_program(p, obj) {
> > > > +               bool prog_to_attach = !prog && cfg->section &&
> > > > +                       !strcmp(get_bpf_program__section_name(p), cfg->section);
> > >
> > > This is still problematic, because one section can have multiple BPF
> > > programs. I.e., it's possible two define two or more XDP BPF programs
> > > all with SEC("xdp") and libbpf works just fine with that. I suggest
> > > moving users to specify the program name (i.e., C function name
> > > representing the BPF program). All the xdp_mycustom_suffix namings are
> > > a hack and will be rejected by libbpf 1.0, so it would be great to get
> > > a head start on fixing this early on.
> >
> > Thanks for bringing this up. Currently, there is no way to specify a
> > function name with "tc exec bpf" (only a section name via the "sec" arg). So
> > probably, we should just add another arg to specify the function name.
>
> How about add a "prog" arg to load specified program name and mark
> "sec" as not recommended? To keep backwards compatibility we just load the
> first program in the section.

Why not error out if there is more than one program with the same
section name? if there is just one (and thus section name is still
unique) -- then proceed. It seems much less confusing, IMO.

>
> Thanks
> Hangbin
>
