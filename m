Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5EE7BA05A
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 05:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfIVDPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 23:15:06 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:45597 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfIVDPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 23:15:06 -0400
X-Originating-IP: 209.85.217.44
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
        (Authenticated sender: pshelar@ovn.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 693F420007
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 03:14:53 +0000 (UTC)
Received: by mail-vs1-f44.google.com with SMTP id f15so7257108vsq.6
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 20:14:53 -0700 (PDT)
X-Gm-Message-State: APjAAAUeGXVCfn59a9DAgQkMEOqMHeQPfNyoFXEJNRaqLYgE2bNmPh/b
        YKTaPgYpgq2OByB/bDrF+HCoTyFWNrUHdgBr17k=
X-Google-Smtp-Source: APXvYqxwjszy7iBNGm0GyqGvavyY9bHKY+AC7Rujl3isjB39R9bsVevbPfxp4q1xm4McxGwZZqxcNwYq6X1os/Onj1E=
X-Received: by 2002:a67:e447:: with SMTP id n7mr6654305vsm.66.1569122092717;
 Sat, 21 Sep 2019 20:14:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190919.132147.31804711876075453.davem@davemloft.net>
 <vbfk1a41fr1.fsf@mellanox.com> <20190920091647.0129e65f@cakuba.netronome.com>
 <0e9a1701-356f-5f94-b88e-a39175dee77a@iogearbox.net> <20190920155605.7c81c2af@cakuba.netronome.com>
 <f1983a74-d144-6d21-9b20-59cea9afc366@iogearbox.net>
In-Reply-To: <f1983a74-d144-6d21-9b20-59cea9afc366@iogearbox.net>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 21 Sep 2019 20:18:13 -0700
X-Gmail-Original-Message-ID: <CAOrHB_Bqhq6cy6QgyEymHaUDk-BN9fkkQ-rzCqWeN35sqiym4w@mail.gmail.com>
Message-ID: <CAOrHB_Bqhq6cy6QgyEymHaUDk-BN9fkkQ-rzCqWeN35sqiym4w@mail.gmail.com>
Subject: Re: CONFIG_NET_TC_SKB_EXT
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Paul Blakey <paulb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 5:06 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 9/21/19 12:56 AM, Jakub Kicinski wrote:
> [...]
> >> I thought idea of stuffing things into skb extensions are only justified if
> >> it's not enabled by default for everyone. :(
> >>
> >>     [0] https://lore.kernel.org/netdev/CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82mWPduvWwd4A@mail.gmail.com/T/#u
> >
> > The skb ext allocation is only done with GOTO_CHAIN, which AFAIK only
> > has practical use for offload.  We could perhaps add another static
> > branch there or move the OvS static branch out of the OvS module so
> > there are no linking issues?
> >
> > I personally have little sympathy for this piece of code, it is perhaps
> > the purest form of a wobbly narrow-use construct pushed into TC for HW
> > offload.
> >
> > Any suggestions on the way forward? :(
>
> Presumably there are no clean solutions here, but on the top of my head for
> this use case, you'd need to /own/ the underlying datapath anyway, so couldn't
> you program the OVS key->recirc_id based on skb->mark (or alternatively via
> skb->tc_index) which was previously set by tc ingress?
>

If we are going down this path, tc_index should be used. skb->mark is
already used in OVS flow match, overloading it for this purpose would
be complicated.
