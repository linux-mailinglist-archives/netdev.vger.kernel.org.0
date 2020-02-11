Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA08159932
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 19:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbgBKSyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 13:54:15 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:38495 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728659AbgBKSyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 13:54:15 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c4a8725a
        for <netdev@vger.kernel.org>;
        Tue, 11 Feb 2020 18:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=RZWBbK3sgLbkqm9pgX+rMS4bU+A=; b=FDPDzF
        W3oPCRoKpQ+zOE39SnUn0HkAcfp4gxmeziVGUkUdByURYHqDji9PZosN8XHKqhLr
        8Nz38tRjNicCrBm0PwLsBVNWbga4JgT9i5eV1UqGtKp+YB+4WdU3ikETzZnkcHKG
        pV/40Op27sNLpVu+Si6dX38ApHVvAQT0zH9pjWSg/1mJezOISJBuhP34bjenlarg
        BCF79/2I7t0YrHTzdPVrJikKMT2DDBifwRt0QqHj83kVKIfEZMqzhrEs2g7DKB3W
        EmWTUpyz9MLA1QfUBirV4II39hBPr3t9Hd4jdj5DJySlCnqCzx2dAmika5myjJ8b
        +LHatnrryAvSDLDQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a8e9dfa0 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Tue, 11 Feb 2020 18:52:28 +0000 (UTC)
Received: by mail-ot1-f52.google.com with SMTP id h9so11168801otj.11
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 10:54:13 -0800 (PST)
X-Gm-Message-State: APjAAAVfCFhYuVEHsc0RXnWX5rBq439cl2o5IFE3Ptcw1jj3hmzn8rgO
        /VHM1gMjeW00xvB9A3ialnw/WF3TeIskUzoWUnk=
X-Google-Smtp-Source: APXvYqxuFaA43R4XnL2B/iTAbZr1eDNras8eJYRYzWg1Fa6dpHRrym65cxa82gjtL6nEQorRntxSlLkesGOqDr+P9kA=
X-Received: by 2002:a05:6830:10c4:: with SMTP id z4mr6399628oto.120.1581447252620;
 Tue, 11 Feb 2020 10:54:12 -0800 (PST)
MIME-Version: 1.0
References: <20200210141423.173790-2-Jason@zx2c4.com> <20200211150028.688073-1-Jason@zx2c4.com>
 <20200211150028.688073-8-Jason@zx2c4.com> <db688bb4-bafa-8e9b-34aa-7f1d5a04e10f@gmail.com>
 <CAHmME9o07Ugxet7sKHc9GYU5DkgyDEYsx36+KyAt7PAVtQRiag@mail.gmail.com> <9c36a95d-aed7-0b63-ccda-8cd49ad97d8f@gmail.com>
In-Reply-To: <9c36a95d-aed7-0b63-ccda-8cd49ad97d8f@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 11 Feb 2020 19:54:01 +0100
X-Gmail-Original-Message-ID: <CAHmME9p_mz0oxwa6DuWom6Ffmes-JK1b9f9WXSeKn_-PFTY0WA@mail.gmail.com>
Message-ID: <CAHmME9p_mz0oxwa6DuWom6Ffmes-JK1b9f9WXSeKn_-PFTY0WA@mail.gmail.com>
Subject: Re: [PATCH v3 net 7/9] ipvlan: remove skb_share_check from xmit path
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 7:50 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 2/11/20 9:44 AM, Jason A. Donenfeld wrote:
> > On Tue, Feb 11, 2020 at 6:39 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >> Yes, maybe, but can you elaborate in this changelog ?
> >>
> >> AFAIK net/core/pktgen.c can definitely provide shared skbs.
> >>
> >>      refcount_inc(&pkt_dev->skb->users);
> >>      ret = dev_queue_xmit(pkt_dev->skb);
> >>
> >> We might have to change pktgen to make sure we do not make skb shared
> >> just because it was convenient.
> >>
> >> Please do not give a link to some web page that might disappear in the future.
> >>
> >> Having to follow an old thread to understand the reasoning is not appealing
> >> for us having to fix bugs in the following years.
> >
> > Well, I don't know really.
> >
> > Florian said I should remove skb_share_check() from a function I was
> > adding, because according to him, the ndo_start_xmit path cannot
> > contain shared skbs. (See the 0/9 cover letter.) If this claim is
> > true, then this series is correct. If this claim is not true, then the
> > series needs to be adjusted.
>
> The claim might be true for a particular driver, but not others.
>
> ipvlan has a way to forward packets from TX to RX, and RX to TX,
> I would rather not touch it unless you really can make good arguments,
> and possibly some tests :)
>
> I am worried about a missing skb_share_check() if for some
> reason pskb_expand_head() has to be called later
>
>       BUG_ON(skb_shared(skb));
>
> >
> > I tried to trace these and couldn't totally make up my mind, hence the
> > ALL CAPS mention in the 0/9.
> >
> > Do you know if this is a safe presumption to make? It sounds like your
> > opinion is "no" in light of pktgen.c? Should that simply be adjusted
> > instead?
>
> The key here is IFF_TX_SKB_SHARING, but really this is the intent.
> I am not sure if all paths have been correctly audited/tested.
>
> I am not saying your patch is wrong, I am unsure about it.

Thanks for the analysis here. It seems like removal of skb_share_check
in a blanket manner is a project in its own. I'll rework v4 of this
patch set to take the conservative set of choices I had originally, of
assuming this can happen and so the helper function needs to be robust
for it. Later we can revisit skb sharing on the tx path as a whole
situation probably best suited for a net-next series.

Jason
