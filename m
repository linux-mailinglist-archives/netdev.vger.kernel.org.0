Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E86D2F8D43
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 13:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbhAPMST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 07:18:19 -0500
Received: from linux.microsoft.com ([13.77.154.182]:53794 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbhAPMST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 07:18:19 -0500
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by linux.microsoft.com (Postfix) with ESMTPSA id 08D2820B6C43;
        Sat, 16 Jan 2021 04:17:37 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 08D2820B6C43
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1610799458;
        bh=TiCwXpfNxrHR/rVBKoD+4jzbb0V5jvO5CtAr07KA7b4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FO0TCmhLHELPfEZaGGJ2Ue7EOY0mxm7TR6/KNWk+yIV83ZMKVI8VRUMQseEuVJZtP
         BMjGwraxbpbiV6l9LhYJXvyj4HGnQ4XH+7zmPxO2Z80FHUy6wMc64u3c6etJbiT43d
         GtzWT4XWoT8I/0SUGC33d5do1j/OUUwLopL9PgAw=
Received: by mail-pf1-f169.google.com with SMTP id j12so91469pfj.12;
        Sat, 16 Jan 2021 04:17:37 -0800 (PST)
X-Gm-Message-State: AOAM533tUsznodFDzI+LHeJ/mYHCoz9vItYxUrGIZqFH6Z+u56hIXOX8
        WY7ZYsev3x6iy+ZSFgXZpRvUUcaQG2sqslBcg30=
X-Google-Smtp-Source: ABdhPJzsdkUtNc6emWU+kOwopXCqhDBNc4xUtTe14w6gCizMHF9zOvkaQa+0pc/56mpMedx8nyj4eSD3g6h7xlxXTSI=
X-Received: by 2002:a63:703:: with SMTP id 3mr1000997pgh.272.1610799457391;
 Sat, 16 Jan 2021 04:17:37 -0800 (PST)
MIME-Version: 1.0
References: <20210115184209.78611-1-mcroce@linux.microsoft.com>
 <20210115184209.78611-2-mcroce@linux.microsoft.com> <5a553d08-2b3f-79a2-2c0e-b1ad644a43d4@gmail.com>
In-Reply-To: <5a553d08-2b3f-79a2-2c0e-b1ad644a43d4@gmail.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Sat, 16 Jan 2021 13:17:01 +0100
X-Gmail-Original-Message-ID: <CAFnufp06wpTst2dkD-fhUex=8n74o6=GUpexDDNzHQH8wfD4WQ@mail.gmail.com>
Message-ID: <CAFnufp06wpTst2dkD-fhUex=8n74o6=GUpexDDNzHQH8wfD4WQ@mail.gmail.com>
Subject: Re: [PATCH net 1/2] ipv6: create multicast route with RTPROT_KERNEL
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 5:36 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/15/21 11:42 AM, Matteo Croce wrote:
> > From: Matteo Croce <mcroce@microsoft.com>
> >
> > The ff00::/8 multicast route is created without specifying the fc_protocol
> > field, so the default RTPROT_BOOT value is used:
> >
> >   $ ip -6 -d route
> >   unicast ::1 dev lo proto kernel scope global metric 256 pref medium
> >   unicast fe80::/64 dev eth0 proto kernel scope global metric 256 pref medium
> >   unicast ff00::/8 dev eth0 proto boot scope global metric 256 pref medium
> >
> > As the documentation says, this value identifies routes installed during
> > boot, but the route is created when interface is set up.
> > Change the value to RTPROT_KERNEL which is a better value.
> >
> > Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> > ---
> >  net/ipv6/addrconf.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> > index eff2cacd5209..19bf6822911c 100644
> > --- a/net/ipv6/addrconf.c
> > +++ b/net/ipv6/addrconf.c
> > @@ -2469,6 +2469,7 @@ static void addrconf_add_mroute(struct net_device *dev)
> >               .fc_flags = RTF_UP,
> >               .fc_type = RTN_UNICAST,
> >               .fc_nlinfo.nl_net = dev_net(dev),
> > +             .fc_protocol = RTPROT_KERNEL,
> >       };
> >
> >       ipv6_addr_set(&cfg.fc_dst, htonl(0xFF000000), 0, 0, 0);
> >
>
>
> What's the motivation for changing this? ie., what s/w cares that it is
> kernel vs boot?

A practical example: systemd-networkd explicitly ignores routes with
kernel flag[1]. Having a different flag leads the daemon to remove the
route sooner or later.

[1] https://github.com/systemd/systemd/blob/0b81225e5791f660506f7db0ab88078cf296b771/src/network/networkd-routing-policy-rule.c#L675-L677
-- 
per aspera ad upstream
