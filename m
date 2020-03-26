Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1702A1934FB
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 01:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbgCZAbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 20:31:07 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40216 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbgCZAbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 20:31:07 -0400
Received: by mail-ed1-f66.google.com with SMTP id w26so4922433edu.7
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 17:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tGVK/hCZDa12aJUZ5I8RSk6vk3rJ/D+Y3ODI7/8pYrc=;
        b=PYoqOD5Dl5FCWmkaIOTJgtVdQ2GgjthvbNm9FVhD//o4Wg+RAWhzw/w0HsuCQ3vL99
         zar+KBqF/oFh6xbuVeotsZOPxLpIeB//Bqxpg4AJwAsHFsm2FctRWW/ct1cLq6t9xeNH
         9urZjbRWWWrefE65cHVJkY5vYpuJldrb+OXhaUnAJEpFYo+iPIwZMbCTmmW+9FtVJAJA
         g8j300FsIlKECn0JXIE2WC89JuTnmfasjNNNEe8qkol7IonO1RGn5SEoQPu0P7V5ijoN
         zmiKGKoFOE/Tf9vEQiabvw6c04mVTEL20rU8DoFEl8S+8JzGGPTVc/TQoOcKx9BZUdLn
         Kchw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tGVK/hCZDa12aJUZ5I8RSk6vk3rJ/D+Y3ODI7/8pYrc=;
        b=HrvxReSLByrpH9xYNNRdujL0EfpaOQiKaM1m0JeZLuE8UxtH4ot9UYdlvDEyhV2KNs
         0eSW/LjpW7nqSozJPZP9CyXgBbKA+Zoa3WPubmjLHYQ/ECq0ZXg/8i9OKCbHMI1lpT55
         81KGab0U3KN4aw+Q7dzmPk9p9uDuqzgfVNs+wA00kcppYGnrA9E+gOBLNaxDXABL5A4Y
         TJ4tQsbo59JoXNm1zll7HSmtYmmcG6DvTDDwvst/F3D6aUecNlPYlWRAmK6gxphrmcS9
         XtiaSDbqcbhijZbflrw2G8xeIf5Ah0NJ50byiRWEH0CkQI3//7KyytAovOh4Wqa1x976
         TgcA==
X-Gm-Message-State: ANhLgQ0i/0D2zrmRzYyaeMy+pMRxQYMR+d9NOiifzCe5zg+CTIxbu8ni
        YaDiz5v0kwZhejwIvHcCSZLyKLLXZzM8ZBN0wwR/iK+vO4o=
X-Google-Smtp-Source: ADFU+vscFBQVaIym0w73AtKPlY7/CPCEkj6AXWIpgSJYGNftayHHkfg4sJvMaeJwOjPtuaQkdKjqQeaYBHJCB0snA7k=
X-Received: by 2002:a50:aca3:: with SMTP id x32mr5824956edc.368.1585182663158;
 Wed, 25 Mar 2020 17:31:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200325152209.3428-1-olteanv@gmail.com> <20200325152209.3428-11-olteanv@gmail.com>
 <8d2d819c-328c-9b2a-d25b-dccc85b93735@gmail.com>
In-Reply-To: <8d2d819c-328c-9b2a-d25b-dccc85b93735@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 26 Mar 2020 02:30:52 +0200
Message-ID: <CA+h21hqZAUccQ3vsJTFtv8bifC_Uv9cmL5WXM7DO7EwERk3GFg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 10/10] net: bridge: implement
 auto-normalization of MTU for hardware datapath
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        murali.policharla@broadcom.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Mar 2020 at 01:18, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 3/25/2020 8:22 AM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > In the initial attempt to add MTU configuration for DSA:
> >
> > https://patchwork.ozlabs.org/cover/1199868/
> >
> > Florian raised a concern about the bridge MTU normalization logic (when
> > you bridge an interface with MTU 9000 and one with MTU 1500). His
> > expectation was that the bridge would automatically change the MTU of
> > all its slave ports to the minimum MTU, if those slaves are part of the
> > same hardware bridge. However, it doesn't do that, and for good reason,
> > I think. What br_mtu_auto_adjust() does is it adjusts the MTU of the
> > bridge net device itself, and not that of any slave port.  If it were to
> > modify the MTU of the slave ports, the effect would be that the user
> > wouldn't be able to increase the MTU of any bridge slave port as long as
> > it was part of the bridge, which would be a bit annoying to say the
> > least.
> >
> > The idea behind this behavior is that normal termination from Linux over
> > the L2 forwarding domain described by DSA should happen over the bridge
> > net device, which _is_ properly limited by the minimum MTU. And
> > termination over individual slave device is possible even if those are
> > bridged. But that is not "forwarding", so there's no reason to do
> > normalization there, since only a single interface sees that packet.
> >
> > The real problem is with the offloaded data path, where of course, the
> > bridge net device MTU is ignored. So a packet received on an interface
> > with MTU 9000 would still be forwarded to an interface with MTU 1500.
> > And that is exactly what this patch is trying to prevent from happening.
> >
> > Florian's idea was that all hardware ports having the same
> > netdev_port_same_parent_id should be adjusted to have the same MTU.
> > The MTU that we attempt to configure the ports to is the most recently
> > modified MTU. The attempt is to follow user intention as closely as
> > possible and not be annoying at that.
> >
> > So there are 2 cases really:
> >
> > ip link set dev sw0p0 master br0
> > ip link set dev sw0p1 mtu 1400
> > ip link set dev sw0p1 master br0
> >
> > The above sequence will make sw0p0 inherit MTU 1400 as well.
> >
> > The second case:
> >
> > ip link set dev sw0p0 master br0
> > ip link set dev sw0p1 master br0
> > ip link set dev sw0p0 mtu 1400
> >
> > This sequence will make sw0p1 inherit MTU 1400 from sw0p0.
> >
> > Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  net/bridge/br.c         |  1 +
> >  net/bridge/br_if.c      | 93 +++++++++++++++++++++++++++++++++++++++++
> >  net/bridge/br_private.h |  1 +
> >  3 files changed, 95 insertions(+)
> >
> > diff --git a/net/bridge/br.c b/net/bridge/br.c
> > index b6fe30e3768f..5f05380df1ee 100644
> > --- a/net/bridge/br.c
> > +++ b/net/bridge/br.c
> > @@ -57,6 +57,7 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
> >
> >       switch (event) {
> >       case NETDEV_CHANGEMTU:
> > +             br_mtu_normalization(br, dev);
>
> I do not remember if you are allowed to sleep in a netdevice notifier, I
> believe not, so you may need to pass a gfp_t to br_mtu_normalization for
> allocations to be GFP_ATOMIC when called from that context, and
> GFP_KERNEL from br_add_if().
>

Not only can you sleep, but the RTNL is also held. It's a bliss!

> It would be nice if we could avoid doing these allocations when called
> from the netdev notifier though, could we just keep the information
> around since the br_hw_port follows the same lifetime as the
> net_bridge_port structure. Other than that, this looks good to me, thanks!

So does this comment still apply then?
I wanted to be as self-contained as possible, it's a pain to keep the
old_mtu list for rollback as the code probably shows. I wouldn't go as
far as to add more stuff into struct net_bridge_port for the sole
purpose of passing data around in this function.

> --
> Florian

Thanks,
-Vladimir
