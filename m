Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E324E129AB0
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfLWUC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:02:56 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37415 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfLWUCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:02:55 -0500
Received: by mail-ed1-f67.google.com with SMTP id cy15so16279646edb.4
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 12:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w6pwSvPsDng/Us3fAb4bGeA2njO7oAnRoFrQpmUHhQU=;
        b=vTvVn45irzcVC6SeGyjwyQ5OWBk/34Ew3SG1rfRofvGTJ/T/ax+25Lwr2veGUvipSB
         IwnDj21ha2E3SpEsh+yUG5d+/Afd34weWfB6gDIngFEqIHySG2ahqfGQAFbHcyT83URH
         dgiS5/N5IwkcQHSJr2Cir9cxPubWw3TcKczQbg6WzB2BXcoXDYIKBsz490Yhrn/+MASP
         NmCDkD8hMGL2nmZPuAdEzY5qY8+ezg2xW+vXdmyvhJcqySGL+PmGsePcvpVOqQvrZxga
         OZKjYE95hJQjcw9Y6cHp/gx+djXPNR9kSy+sR4GUIa2ABh0ETjkzSgKqtqqEmgXQE1xZ
         lfow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w6pwSvPsDng/Us3fAb4bGeA2njO7oAnRoFrQpmUHhQU=;
        b=HQHb1q19KMetSIUgjXpTf2nZdpEuCDimiuwhY5yASA6Dw35AR1qo3SX8RyPxjX2S1O
         W91XOE8R4TWXY7wPhVghCAGB/l0xO1XUEPPNhEJzFLrslU/QyoQQ+jqKIUXP5J8k6ZDG
         mn9/ScyTyptXSPCVL4yL5fiVdkhnotQecWBozky6NCyY1qwKmvn1o/fnC0M7MeIQPoYo
         LEYpMGJOgKf9qPzr308/qdypYJWZwz7SR4oRjleGj3qqBM5TL5gI0jCuobfuNMDD7bVC
         bpTYvVZ0cBHjB9LYl3+u+AV8NtLcZrKNbNzpCAPOb5ikZGg68FpbvCxTguJ2H2+m5dNR
         3H5w==
X-Gm-Message-State: APjAAAU+qoOnxGGuh1Zckg9I6CDqLRedtit6NBYVm1hjrfjzBRsqnrc1
        2g7t3tA2FHF8ws7BncSPI9zyMHWA/K8nTHSxI2IM3HlMVcM=
X-Google-Smtp-Source: APXvYqwdAh9iy29+yM6YMRH1NDOQWzACrIK68/7z2xZnSKlfgwzxb0WxyiUqdrvLqmW7vd6UpN9jy+w6C+p1K5Z+L0w=
X-Received: by 2002:a17:906:2e53:: with SMTP id r19mr33583434eji.306.1577131373584;
 Mon, 23 Dec 2019 12:02:53 -0800 (PST)
MIME-Version: 1.0
References: <1576885124-14576-1-git-send-email-tom@herbertland.com>
 <1576885124-14576-2-git-send-email-tom@herbertland.com> <CA+FuTSfSFtSZjstCCp4ZdwPMCiHXaskgTqQH0EJYzV4-08t2Eg@mail.gmail.com>
 <CALx6S35o==mvEJ+GOx_tQfi56HVxKFySd+bjNakzwgiuvHnS7Q@mail.gmail.com> <CA+FuTSd4feUHeTAODKEqt7AXoNgh0sbZYJJXrWg7Tb6GTnDmtA@mail.gmail.com>
In-Reply-To: <CA+FuTSd4feUHeTAODKEqt7AXoNgh0sbZYJJXrWg7Tb6GTnDmtA@mail.gmail.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Mon, 23 Dec 2019 12:02:41 -0800
Message-ID: <CALx6S34F-ng51-UxvkqKcsEaKAwEKLiAR0PjgsXdjyF3267_5w@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 1/9] ipeh: Fix destopts and hopopts counters
 on drop
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Tom Herbert <tom@quantonium.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 10:53 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, Dec 23, 2019 at 11:53 AM Tom Herbert <tom@herbertland.com> wrote:
> >
> > On Sun, Dec 22, 2019 at 8:21 AM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Fri, Dec 20, 2019 at 6:39 PM Tom Herbert <tom@herbertland.com> wrote:
> > > >
> > > > From: Tom Herbert <tom@quantonium.net>
> > > >
> > > > For destopts, bump IPSTATS_MIB_INHDRERRORS when limit of length
> > > > of extension header is exceeded.
> > > >
> > > > For hop-by-hop options, bump IPSTATS_MIB_INHDRERRORS in same
> > > > situations as for when destopts are dropped.
> > > >
> > > > Signed-off-by: Tom Herbert <tom@herbertland.com>
> > > > ---
> > > >  net/ipv6/exthdrs.c | 7 ++++++-
> > > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> > > > index ab5add0..f605e4e 100644
> > > > --- a/net/ipv6/exthdrs.c
> > > > +++ b/net/ipv6/exthdrs.c
> > > > @@ -288,9 +288,9 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
> > > >         if (!pskb_may_pull(skb, skb_transport_offset(skb) + 8) ||
> > > >             !pskb_may_pull(skb, (skb_transport_offset(skb) +
> > > >                                  ((skb_transport_header(skb)[1] + 1) << 3)))) {
> > > > +fail_and_free:
> > > >                 __IP6_INC_STATS(dev_net(dst->dev), idev,
> > > >                                 IPSTATS_MIB_INHDRERRORS);
> > > > -fail_and_free:
> > > >                 kfree_skb(skb);
> > > >                 return -1;
> > > >         }
> > > > @@ -820,8 +820,10 @@ static const struct tlvtype_proc tlvprochopopt_lst[] = {
> > > >
> > > >  int ipv6_parse_hopopts(struct sk_buff *skb)
> > > >  {
> > > > +       struct inet6_dev *idev = __in6_dev_get(skb->dev);
> > > >         struct inet6_skb_parm *opt = IP6CB(skb);
> > > >         struct net *net = dev_net(skb->dev);
> > > > +       struct dst_entry *dst = skb_dst(skb);
> > > >         int extlen;
> > > >
> > > >         /*
> > > > @@ -834,6 +836,8 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
> > > >             !pskb_may_pull(skb, (sizeof(struct ipv6hdr) +
> > > >                                  ((skb_transport_header(skb)[1] + 1) << 3)))) {
> > > >  fail_and_free:
> > > > +               __IP6_INC_STATS(dev_net(dst->dev), idev,
> > > > +                               IPSTATS_MIB_INHDRERRORS);
> > >
> > > ip6_rcv_core, the only caller of ipv6_parse_hopopts, checks
> > > skb_valid_dst(skb) before deref. Does this need the same?
> >
> > Hi Willem,
> >
> > Actually, it looks like ipv6_parse_hopopts is doing things the right
> > way. __IP6_INC_STATS is called from ip6_rcv_core if ipv6_parse_hopopts
> > and the net is always taken from skb->dev (not dst) in HBH path. I'll
> > fix destopts to do the same.
>
> I don't entirely follow. The above code uses dev_net(dst->dev). Using
> local variable net, derived from dev_net(skb->dev), here definitely
> sounds good to me, if that's what you meant.

Yes, I'm thinking to just do dev_net(skb->dev) in all cases of
__IP6_INC_STATS for hopopts and destopts.

Tom
