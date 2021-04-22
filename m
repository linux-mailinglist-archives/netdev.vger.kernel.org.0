Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FF5368541
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 18:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbhDVQw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 12:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236236AbhDVQw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 12:52:58 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58898C06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 09:52:23 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 65so52276007ybc.4
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 09:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yOkRs5K237gbs6NB3+gfmjX34Dy4iq9wMXif+x22Iz8=;
        b=AHzAwu6MBDObX75VQhBcdu7RnDvM5vAUMIR/iHS3V5/BGi9W0n4jx03qZJz9U37uiE
         0kjuqZ1M3x6N18PncMR6LQEJytpJFhqDncy0wwwgKh9z/3nhj/HjRwvpr0BztWP0Uktf
         BP2IFGgc2e6S/WH/c63V1MVNvz50Z2b/XoIbhm2GYd93GkT1MOLuuPuL1jh50VJTjl/u
         NJrdA0HBBiRSeAWozu0nDRi9+fuAw1m1T+A8EoZJCw00oohwMDdIvq46PiW/AF3L8q7j
         42MkrEAoTDt0FmVcBA03wCazvRoq/LRai8HRo/6JH/a8ImJsIhz6L6gw1xvesmkzLop6
         mrmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yOkRs5K237gbs6NB3+gfmjX34Dy4iq9wMXif+x22Iz8=;
        b=L5id/A8QiKeejfouN6jzsSjU8Kej2Vy7y600wQfR3JJx5GFbLL1aSonIdJANC/KaWw
         LO+mQqtxQ0xT+rSwXalaNnnBoN18o0sh/ZsUgUucGU7Tn94FDTKnVCZhW/XAddVl+8gQ
         HwnsQABLqLblRDDyBgyZ5uYhQVQuZROFk1YytMw9/F+t4y2BglPB62nQeE++O+sMr7/x
         sTjHNDVSJmM8Yum5BogDd4Ovs2NFT86Dyz7iAsyOp/2YklGBCBpv98D1lE5C3Nj9yGeT
         SVoULXPSiw3lDlQ2KbJeSW9mm1fXo/IE9ptpp7YZID0mn+wPjCNORu4khxexWT5fLokp
         wBEw==
X-Gm-Message-State: AOAM533OvBZykvMg+X8hVtGurcvIvZoV5LTR66LndJNzVvBrw6kAwuuH
        3dqwuLVlskEV0d1j2ReFnplrPPc8S6iG7BRwDvLRuPFN8qKFQg==
X-Google-Smtp-Source: ABdhPJy7j5HYC4iKiLboV+WKi7D6pJIZJzjC0yhQZJogGQAWyxpptaIBXGKrobDExKxmRatAdTWCv/YoDx+RzKzdcCY=
X-Received: by 2002:a25:4883:: with SMTP id v125mr6306231yba.253.1619110342298;
 Thu, 22 Apr 2021 09:52:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210421231100.7467-1-phil@philpotter.co.uk> <20210422003942.GF4841@breakpoint.cc>
 <YIGeVLyfa2MrAZym@hog>
In-Reply-To: <YIGeVLyfa2MrAZym@hog>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 22 Apr 2021 18:52:10 +0200
Message-ID: <CANn89iJSy82k+5b-vgSE-tD7hc8MhM6Niu=eY8sg-b7LbULouQ@mail.gmail.com>
Subject: Re: [PATCH] net: geneve: modify IP header check in geneve6_xmit_skb
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Florian Westphal <fw@strlen.de>,
        Phillip Potter <phil@philpotter.co.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 6:04 PM Sabrina Dubroca <sd@queasysnail.net> wrote:
>
> 2021-04-22, 02:39:42 +0200, Florian Westphal wrote:
> > Phillip Potter <phil@philpotter.co.uk> wrote:
> > > Modify the check in geneve6_xmit_skb to use the size of a struct iphdr
> > > rather than struct ipv6hdr. This fixes two kernel selftest failures
> > > introduced by commit 6628ddfec758
> > > ("net: geneve: check skb is large enough for IPv4/IPv6 header"), without
> > > diminishing the fix provided by that commit.
> >
> > What errors?
> >
> > > Reported-by: kernel test robot <oliver.sang@intel.com>
> > > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> > > ---
> > >  drivers/net/geneve.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> > > index 42f31c681846..a57a5e6f614f 100644
> > > --- a/drivers/net/geneve.c
> > > +++ b/drivers/net/geneve.c
> > > @@ -988,7 +988,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
> > >     __be16 sport;
> > >     int err;
> > >
> > > -   if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
> > > +   if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
> > >             return -EINVAL;
> >
> > Seems this is papering over some bug, this change makes no sense to
> > me.  Can you please explain this?
>
> I'm not sure the original commit (6628ddfec758 ("net: geneve: check
> skb is large enough for IPv4/IPv6 header")) is correct either. GENEVE
> isn't limited to carrying IP, I think an ethernet header with not much
> else on top should be valid.

Maybe, but we still attempt to use ip_hdr() in this case, from
geneve_get_v6_dst()

So there is something fishy.
