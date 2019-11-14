Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC1FFCAE2
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 17:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfKNQlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 11:41:07 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33686 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfKNQlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 11:41:07 -0500
Received: by mail-ed1-f65.google.com with SMTP id a24so5586361edt.0
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 08:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JmabFK8GQgzKaI6Pf3ctt9qB+xmo0mFBtsLMleCi/bU=;
        b=MFDjd4MufKQOjl3C18NCMEVdKUvGsgTI8D5Ad/7A9YaWk4L0/N0Ym9N4jG94236spD
         InHJxhjaY5CgW/0R7a7Ho+rzCaakpg84jCHBjm+KZlIm7Mjtxi3HAxh7UXHirABp6NwG
         4hz0TkD0T8AIhJbFW75fo7lrdZTUnUCiJaVPmcF41AcXnaA+CwkVjrgQW7VoKjJyoE/Z
         jMIn07DR2/MVtRk1At8kCPBJEnDzL8GmAArCLChpqubDOWv77NbFTxTXel/0DgjnUcY9
         6UqXAD9jIXqrGvQ/QijHCkCFsfvWr34b0EINcN91dIyHbiLqvmb0xp1CmFCm88l0sXzv
         NuzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JmabFK8GQgzKaI6Pf3ctt9qB+xmo0mFBtsLMleCi/bU=;
        b=eEt3yYpD8Fp0BNG+duW/9/sF62Aka/30X0/5XWYOyXzGw9ZDrhjV9zKuM+0ZTk3VE6
         Xl8hZ4bIVKJM7H0vfsXbXRjoU6+i2K28Jo0yEU6WX33fE+G9ZOh5+LEQBg5Pwe3dsoyV
         yI44Pt6IdIEjB8Xeeq9OFtJTkzexTuJthXf2nJuZhtseJkoLy05SQXFfw6Jlhnv2tzLv
         zamhJdnZYR7Rs/1mHC+Cyj411rMhnu2QSbvNe08NSc11e1gmL4f2leTsOvrk6Koo2/Zl
         pS8MSU4mGBQ1BWKR4wjq0xPWFl4B5RR0FfZNWijaQOSkaK8+Y7kD7OIK55nUJJY23Oe4
         07qw==
X-Gm-Message-State: APjAAAW70Um7TWgWhkhkZbKQ8eB3G0YVm37qrrRDhEuGE5e6nIPS9HNv
        vslEeAy78lJy056B3O9W0zyGjOUBsGZB9MG59hY=
X-Google-Smtp-Source: APXvYqxK4KPSFW1wxFRfqXjgo9W7fw3DpXzvihdnrXCIa0YUmaNsxq92g4yd4MGc2QMOh/D99gTJruJ/dRso2L7KEo4=
X-Received: by 2002:aa7:c3d0:: with SMTP id l16mr2331425edr.18.1573749665031;
 Thu, 14 Nov 2019 08:41:05 -0800 (PST)
MIME-Version: 1.0
References: <CA+h21hqte1sOefqVXKvSQ6N7WoTU3BH7qKpq3C7pieaqSB6AFg@mail.gmail.com>
 <6fbc4127-ab67-3898-8eaa-409c3209a2e2@gmail.com>
In-Reply-To: <6fbc4127-ab67-3898-8eaa-409c3209a2e2@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 14 Nov 2019 18:40:53 +0200
Message-ID: <CA+h21hrmP_nDZK9edm6_SGm6orzySj7=SGoui1QzmPV2BgFdBA@mail.gmail.com>
Subject: Re: Offloading DSA taggers to hardware
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Wed, 13 Nov 2019 at 21:40, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 11/13/19 4:40 AM, Vladimir Oltean wrote:
> > DSA is all about pairing any tagging-capable (or at least VLAN-capable) switch
> > to any NIC, and the software stack creates N "virtual" net devices, each
> > representing a switch port, with I/O capabilities based on the metadata present
> > in the frame. It all looks like an hourglass:
> >
> >   switch           switch           switch           switch           switch
> > net_device       net_device       net_device       net_device       net_device
> >      |                |                |                |                |
> >      |                |                |                |                |
> >      |                |                |                |                |
> >      +----------------+----------------+----------------+----------------+
> >                                        |
> >                                        |
> >                                   DSA master
> >                                   net_device
> >                                        |
> >                                        |
> >                                   DSA master
> >                                       NIC
> >                                        |
> >                                     switch
> >                                    CPU port
> >                                        |
> >                                        |
> >      +----------------+----------------+----------------+----------------+
> >      |                |                |                |                |
> >      |                |                |                |                |
> >      |                |                |                |                |
> >   switch           switch           switch           switch           switch
> >    port             port             port             port             port
> >
> >
> > But the process by which the stack:
> > - Parses the frame on receive, decodes the DSA tag and redirects the frame from
> >   the DSA master net_device to a switch net_device based on the source port,
> >   then removes the DSA tag from the frame and recalculates checksums as
> >   appropriate
> > - Adds the DSA tag on xmit, then redirects the frame from the "virtual" switch
> >   net_device to the real DSA master net_device
> >
> > can be optimized, if the DSA master NIC supports this. Let's say there is a
> > fictional NIC that has a programmable hardware parser and the ability to
> > perform frame manipulation (insert, extract a tag). Such a NIC could be
> > programmed to do a better job adding/removing the DSA tag, as well as
> > masquerading skb->dev based on the parser meta-data. In addition, there would
> > be a net benefit for QoS, which as a consequence of the DSA model, cannot be
> > really end-to-end: a frame classified to a high-priority traffic class by the
> > switch may be treated as best-effort by the DSA master, due to the fact that it
> > doesn't really parse the DSA tag (the traffic class, in this case).
>
> The QoS part can be guaranteed for an integrated design, not so much if
> you have discrete/separate NIC and switch vendors and there is no agreed
> upon mechanism to "not lose information" between the two.
>
> >
> > I think the DSA hotpath would still need to be involved, but instead of calling
> > the tagger's xmit/rcv it would need to call a newly introduced ndo that
> > offloads this operation.
> >
> > Is there any hardware out there that can do this? Is it desirable to see
> > something like this in DSA?
>
> BCM7445 and BCM7278 (and other DSL and Cable Modem chips, just not
> supported upstream) use drivers/net/dsa/bcm_sf2.c along with
> drivers/net/ethernet/broadcom/bcmsysport.c. It is possible to offload
> the creation and extraction of the Broadcom tag:
>
> http://linux-kernel.2935.n7.nabble.com/PATCH-net-next-0-3-net-Switch-tag-HW-extraction-insertion-td1162606.html
>
> (this was reverted shortly after because napi_gro_receive() occupies the
> full 48 bytes skb->cb[] space on 64-bit hosts, I have now a better view
> of solving this though, see below).
>
> In my experience though, since the data is already hot in the cache in
> either direction, so a memmove() is not that costly, it was not possible
> to see sizable throughput improvements at 1Gbps or 2Gbps speeds because
> the CPU is more than capable of managing the tag extraction in software,
> and that is the most compatible way of doing it.
>
> To give you some more details, the SYSTEMPORT MAC will pre-pend an 8
> byte Receive Status Block, word 0 contains status/length/error and word
> 1 can contain the full 4byte Broadcom tag as extracted. Then there is a
> (configurable) 2byte gap to align the IP header and then the Ethernet
> header can be found. This is quite similar to the
> NET_DSA_TAG_BRCM_PREPEND case, except for this 2b gap, which is why I am
> wondering if I am not going to introduce an additional tagging protocol
> NET_DSA_TAG_BRCM_PREPEND_WITH_2B or whatever side band information I can
> provide in the skb to permit the removal of these extraneous 2bytes.
>
> On transmit, we also have an 8byte transmit status block which can be
> constructed to contain information for the HW to insert a 4byte Broadcom
> tag, along with a VLAN tag, and with the same length/checksum insertion
> information. TX path would be equivalent to not doing any tagging, so
> similarly, it may be desirable to have a separate
> NET_DSA_TAG_BRCM_PREPEN value that indicates that nothing needs to be
> done except queue the frame for transmission on the master netdev.
>
> Now from a practical angle, offloading DSA tagging only makes sense if
> you happen to have a lot of host initiated/received traffic, which would
> be the case for either a streaming device (BCM7445/BCM7278) with their
> ports either completely separate (DSA default), or bridged. Does that
> apply in your case?

Not at all, I would say. In fact, I was trying to understand what are
the chances of interpreting information from the master's frame
descriptor as the de-facto DSA tag in mainline Linux. Your story with
Starfighter 2 chips seems to indicate that it isn't such a good idea.

> --
> Florian

Thanks,
-Vladimir
