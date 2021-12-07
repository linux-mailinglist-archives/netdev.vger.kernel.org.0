Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6301046AEC8
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351414AbhLGAIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350279AbhLGAIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:08:00 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CD9C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:04:31 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id 131so35943277ybc.7
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8l4ntg9WowzLbpI0DJtKE7/kb17KZv00oRAXrSHk9bg=;
        b=WDFL+hN6d1uYpT9VjuBoGi8uaC3dV0W/2q3ROQ9Ptzb2RFeHFTdjaXRsmlqFlspJw/
         34M86pyOnAcnfkH8zZgpXiGigf4LlWMr5xdHrojjEfmG6VEBYJJRJvzfQrZ1q3pGjyQ6
         jdjGyapqYDdM9jYaNa/fk4jsRNk4RsVPnxA7WaBB9JzE6UgyQ9NXycxnxq+qTQPThti2
         nwa9HFkGFl5mkh4mZAiVFsc70MZYNVzioWCPGQ3ETEP4oG9ZBjZMA18wW5pIa5VoUcuq
         cHetrhOmhz3RFMgvPMUFrHK5bdXleSq1hIcqdiSjVcYm5XOh8c01/UBwgT0FcETgWMpi
         wwrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8l4ntg9WowzLbpI0DJtKE7/kb17KZv00oRAXrSHk9bg=;
        b=W4UyMuhTkZmm55nNPSSkgRDp1ejg4FQFr7K0vPngpCFB1/BymMmHH/I6ry8O6B2TL6
         X67L2Ccd+fnkjE56RPUfVc6TkTO/h/iIBw8QQetIbLykWtemmNu19xwGG6uIbLCXAXlP
         of30IhI1dzz20Xtyr20Wc7rcXxqNpNnSKA40LIFGBwgIRtBNRafTO2mgwgmzm7sKtc1P
         wf7RkKKTR+41EHP6iA8MMIAeyFHjSCl/dEGrdEvknd/h6aAy0aKyLrn3+DkfxuyCooKT
         VS+caePqYvbbUp3rkr9CNq9E92S2fyg7jy5q760xIh7QYxbcRda2Yey7BzMJKqG8LvNJ
         mmyA==
X-Gm-Message-State: AOAM532qOj4E63JPwIBDtB4G1MXfVCRwy8RYCALBsAkgqEZIbrXqC39X
        Bl0K2KaXfkEqZ1YG8HsJa++JZd886mfHntVvt8G7Gw==
X-Google-Smtp-Source: ABdhPJxFcaKn0ZXyx8ILhesN2BmcdLhuQ6qaGIWYNk6kO1AVg0IWrbaSi2NqxCkBI4Ef5H9+Vc07ThkHhq17oxc8Etk=
X-Received: by 2002:a25:df4f:: with SMTP id w76mr48883170ybg.711.1638835470472;
 Mon, 06 Dec 2021 16:04:30 -0800 (PST)
MIME-Version: 1.0
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <Ya6bj2nplJ57JPml@lunn.ch> <CANn89iLPSianJ7TjzrpOw+a0PTgX_rpQmiNYbgxbn2K-PNouFg@mail.gmail.com>
 <Ya6kJhUtJt5c8tEk@lunn.ch>
In-Reply-To: <Ya6kJhUtJt5c8tEk@lunn.ch>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 6 Dec 2021 16:04:19 -0800
Message-ID: <CANn89iL4nVf+N1R=XV5VRSm4193CcU1N8XTNZzpBV9-mS3vxig@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 00/23] net: add preliminary netdev refcount tracking
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 4:00 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Dec 06, 2021 at 03:44:57PM -0800, Eric Dumazet wrote:
> > On Mon, Dec 6, 2021 at 3:24 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Sat, Dec 04, 2021 at 08:21:54PM -0800, Eric Dumazet wrote:
> > > > From: Eric Dumazet <edumazet@google.com>
> > > >
> > > > Two first patches add a generic infrastructure, that will be used
> > > > to get tracking of refcount increments/decrements.
> > >
> > > Hi Eric
> > >
> > > Using this i found:
> > >
> > > [  774.108901] unregister_netdevice: waiting for eth0 to become free. Usage count = 4
> > > [  774.110864] leaked reference.
> > > [  774.110874]  dst_alloc+0x7a/0x180
> > > [  774.110887]  ip6_dst_alloc+0x27/0x90
> > > [  774.110894]  ip6_pol_route+0x257/0x430
> > > [  774.110900]  ip6_pol_route_output+0x19/0x20
> > > [  774.110905]  fib6_rule_lookup+0x18b/0x270
> > > [  774.110914]  ip6_route_output_flags_noref+0xaa/0x110
> > > [  774.110918]  ip6_route_output_flags+0x32/0xa0
> > > [  774.110922]  ip6_dst_lookup_tail.constprop.0+0x181/0x240
> > > [  774.110929]  ip6_dst_lookup_flow+0x43/0xa0
> > > [  774.110934]  inet6_csk_route_socket+0x166/0x200
> > > [  774.110943]  inet6_csk_xmit+0x56/0x130
> > > [  774.110946]  __tcp_transmit_skb+0x53b/0xc30
> > > [  774.110953]  __tcp_send_ack.part.0+0xc6/0x1a0
> > > [  774.110958]  tcp_send_ack+0x1c/0x20
> > > [  774.110964]  __tcp_ack_snd_check+0x42/0x200
> > > [  774.110968]  tcp_rcv_established+0x27a/0x6f0
> > > [  774.110973] leaked reference.
> > > [  774.110975]  ipv6_add_dev+0x13e/0x4f0
> > > [  774.110982]  addrconf_notify+0x2ca/0x950
> > > [  774.110989]  raw_notifier_call_chain+0x49/0x60
> > > [  774.111000]  call_netdevice_notifiers_info+0x50/0x90
> > > [  774.111007]  __dev_change_net_namespace+0x30d/0x6c0
> > > [  774.111016]  do_setlink+0xdc/0x10b0
> > > [  774.111024]  __rtnl_newlink+0x608/0xa10
> > > [  774.111031]  rtnl_newlink+0x49/0x70
> > > [  774.111038]  rtnetlink_rcv_msg+0x14f/0x380
> > > [  774.111046]  netlink_rcv_skb+0x55/0x100
> > > [  774.111053]  rtnetlink_rcv+0x15/0x20
> > > [  774.111059]  netlink_unicast+0x230/0x340
> > > [  774.111064]  netlink_sendmsg+0x252/0x4b0
> > > [  774.111075]  sock_sendmsg+0x65/0x70
> > > [  774.111080]  ____sys_sendmsg+0x24e/0x290
> > > [  774.111084]  ___sys_sendmsg+0x81/0xc0
> > >
> > > I'm using GNS3 to simulate a network topology. So a collection of veth
> > > pairs, bridges and tap interfaces spread over a few namespaces. The
> > > network being simulated uses Segment Routing. And traceroute might also
> > > involved in this somehow. I have 3 patches applied, to make traceroute
> > > actually work when SRv6 is being used. You can find v3 here:
> > >
> > > https://lore.kernel.org/netdev/20211203162926.3680281-3-andrew@lunn.ch/T/
> > >
> > > I'm not sure if these patches are part of the problem or not. None of
> > > the traces i've seen are directly on the ICMP path. traceroute is
> > > using udp, and one of the traces above is for tcp, and the other looks
> > > like it is moving an interface into a different namespace?
> > >
> > > This is net-next from today.
> >
> > I do not understand, net-next does not contain this stuff yet ?
>
> Hi Eric
>
> I'm getting warnings like:
>
> unregister_netdevice: waiting for eth0 to become free. Usage count = 4
>
> which is what your patchset is supposed to help fix. So i applied what
> has been posted so far, in the hope it would find the issue. It is
> reporting something...

I thought you were telling me that you got these new reports after the
patch set being applied ?

Or were they happening because of your other changes ?

>
> > I have other patches, this work is still in progress.
>
> Is what is currently posted usable? Do these traces above point at the
> real problem i have, or because there are more patches, i should not
> trust the output?

I think I have not worked yet on the XFRM side in patch set 1.
Are you using XFRM ?
