Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD04C564330
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 01:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiGBWyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 18:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGBWx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 18:53:59 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1966B6437;
        Sat,  2 Jul 2022 15:53:58 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id mf9so10333089ejb.0;
        Sat, 02 Jul 2022 15:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V7Q6p/6qylL0QYHVO+jT6zOCTgkvVY1VVcxdCzpdUIE=;
        b=cxkVTjuYtxNb9f4pPMx8krGexbqyxNDF1m39W8/uekyo3nEY+Wd243nhkZblqydEvY
         N4yJbzSTadaU0J7gNVgIUYdMwPZo03lzXDu4KUcNn3wt2T+kabJvyX15aqI8wLRoYb1l
         T/cdTY6BrIJoKJ0GmgQjZ5WMs+QEfrSEhPAgq/8RZ9qNyS5BnZSsLesab4HkiGV3GzNu
         uiMB6xnvhWYb2YuWMukZIqbNjqHZ/TLKOHO3DfYgh350UE6+xdhOieWrqAl6kRt8C0a2
         v5EQ7OwYyYUwwZ/OiQ2gQriNOyDYG8IkyD3sF2cViC/5Kn+HYtTCwEP7xlnN45LsCslh
         Jt/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V7Q6p/6qylL0QYHVO+jT6zOCTgkvVY1VVcxdCzpdUIE=;
        b=2ZNMQCDzHB0hB/WGE3LzcvJXy14AMLkaNm/xTF248iXrP6n7ZkYQ8BE14PS5P2hECn
         JtsYOaF7lHnRvM5deVHY5DMOYNAGU6Xzrs8lLO1xUvsHn0Xt8pVqvcBQRbSs+TTzmR/O
         w2BIbfSdkvWNdUp026UB7bNjs1PSpYpTPBV5ApW838Y7yCt0kDXRkZotv/OxAtWaIGRY
         5eiGO5LpInI/gnulLVgkNPjjGtBeeeHFgE427S+zSYh4WNU1rdPiRUEKrZKAX1h+m/k/
         Gl08DjdfvLb1iQKufaO714gRj2f03Z+exPvudEoCrSJvk30XSp4+tl74NYKN8kCK6OES
         O/3A==
X-Gm-Message-State: AJIora9C8D9XN8oOhX3fsNR4EpLyu4QNb4s3GnWCJdFo1tzqCn/UdYYx
        DXLuF1Zv1vEVbANPqs5ne9rYbaRfwVkHImEFpqo=
X-Google-Smtp-Source: AGRyM1vMji9ljIoDCw1DS/oZkN2ByiDepNSHSRR+zDVscyXCeSh8tlYMSCI80ld0mAlJKKZmqS6gM4X4rVcGM2AeKzU=
X-Received: by 2002:a17:906:3f51:b0:712:3945:8c0d with SMTP id
 f17-20020a1709063f5100b0071239458c0dmr20950953ejj.302.1656802436586; Sat, 02
 Jul 2022 15:53:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220630212703.3280485-1-martin.blumenstingl@googlemail.com>
 <20220701130157.bwepfw2oeco6teyv@skbuf> <CAFBinCDqgQ1WWWPmfXykeZPsiwLNu+fPg6nCN7TMNNR_JL3gxQ@mail.gmail.com>
 <20220702185652.dpzrxuitacqp6m3t@skbuf>
In-Reply-To: <20220702185652.dpzrxuitacqp6m3t@skbuf>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 3 Jul 2022 00:53:45 +0200
Message-ID: <CAFBinCC7s7adM38JUkroCV3q7t7fJBu6r9zULfpOqR9L5NeWyg@mail.gmail.com>
Subject: Re: [PATCH net v1] net: dsa: lantiq_gswip: Fix FDB add/remove on the
 CPU port
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Sat, Jul 2, 2022 at 8:56 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Sat, Jul 02, 2022 at 07:43:11PM +0200, Martin Blumenstingl wrote:
> > Hi Vladimir,
> >
> > On Fri, Jul 1, 2022 at 3:02 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > [...]
> > > > Use FID 0 (which is also the "default" FID) when adding/removing an FDB
> > > > entry for the CPU port.
> > >
> > > What does "default" FID even mean, and why is the default FID relevant?
> > The GSW140 datasheet [0] (which is for a newer IP than the one we are
> > targeting currently with the GSWIP driver - but I am not aware of any
> > older datasheets)
>
> Thanks for the document! Really useful.
Great that this helps. Whenever you hear me contradicting statements
from that datasheet then please let me know. There have been subtle
changes between the different versions of the IP, so I may have to
double check with the vendor driver to see if things still apply to
older versions.

> > page 78 mentions: "By default the FID is zero and all entries belong
> > to shared VLAN learning."
>
> Not talking about the hardware defaults when it's obvious the driver
> changes those, in an attempt to comply to Linux networking expectations...
>
> > > In any case, I recommend you to first set up a test bench where you
> > > actually see a difference between packets being flooded to the CPU vs
> > > matching an FDB entry targeting it. Then read up a bit what the provided
> > > dsa_db argument wants from port_fdb_add(). This conversation with Alvin
> > > should explain a few things.
> > > https://patchwork.kernel.org/project/netdevbpf/cover/20220302191417.1288145-1-vladimir.oltean@nxp.com/#24763870
> > I previously asked Hauke whether the RX tag (net/dsa/tag_gswip.c) has
> > some bit to indicate whether traffic is flooded - but to his knowledge
> > the switch doesn't provide this information.
>
> Yeah, you generally won't find quite that level of detail even in more
> advanced switches. Not that you need it...
>
> > So I am not sure what I can do in this case - do you have any pointers for me?
>
> Yes, I do.
>
> gswip_setup has:
>
>         /* Default unknown Broadcast/Multicast/Unicast port maps */
>         gswip_switch_w(priv, BIT(cpu_port), GSWIP_PCE_PMAP1);
>         gswip_switch_w(priv, BIT(cpu_port), GSWIP_PCE_PMAP2);
>         gswip_switch_w(priv, BIT(cpu_port), GSWIP_PCE_PMAP3); <- replace BIT(cpu_port) with 0
>
> If you can no longer ping, it means that flooding was how packets
> reached the system.
I tried this but I can still ping OpenWrt's br-lan IP.

I zero'ed the GSWIP_PCE_PMAP2 register (which according to the
documentation is used for L2 multicast/broadcast flooding) as well,
which changes the behavior:
- once the br-lan (IP address: 192.168.1.14) interface is brought up
it cannot be ping'ed from a device connected to one of the switch
ports ("Destination Host Unreachable")
- I can ping a device connected to the switch from within OpenWrt
(meaning: ping from the CPU port to a device with IP 192.168.1.100 on
one of the switch port works)
- once I start the ping from within OpenWrt I immediately get replies
from OpenWrt to the other device

ping log:
    [similar messages omitted, only the icmp_seq is different]
    From 192.168.1.100 icmp_seq=87 Destination Host Unreachable
    [this is when I start "ping 192.168.1.100" from within OpenWrt)
    64 bytes from 192.168.1.14: icmp_seq=88 ttl=64 time=3016 ms
    64 bytes from 192.168.1.14: icmp_seq=89 ttl=64 time=2002 ms
    64 bytes from 192.168.1.14: icmp_seq=90 ttl=64 time=989 ms
    64 bytes from 192.168.1.14: icmp_seq=91 ttl=64 time=0.379 ms

I made sure that the changes from my patch are not applied:
# dmesg | grep " to fdb: -22" | wc -l
9

Also in case it's relevant: I added some printk's to
gswip_port_fdb_dump() (because I don't know how to differentiate
"hardware FDB" from "software FDB" entries in "bridge fdb show brport
lan1"):
The switch seems to learn the CPU port's MAC address automatically -
even before I issue "ping 192.168.1.100" (most likely due to something
in OpenWrt accessing the network).
The "static" flag is not set though (which is expected I think).

As a side-note: I think the comment is partially incorrect. At least
for the GSWIP IP revision which the driver is targeting,
GSWIP_PCE_PMAP1 is for the "monitoring" port. My understanding is that
this "monitoring port" is used with port mirroring (which the hardware
supports but we don't implement in the driver yet).

> It appears that what goes on is interesting.
> The switch is configured to flood traffic that's unknown to the FDB only
> to the CPU (notably not to other bridged ports).
> In software, the packet reaches tag_gswip.c, where unlike the majority
> of other DSA tagging protocols, we do not call dsa_default_offload_fwd_mark(skb).
> Then, the packet reaches the software bridge, and the switch has
> informed the bridge (via skb->offload_fwd_mark == 0) that the packet
> hasn't been already flooded in hardware, so the software bridge needs to
> do it (only if necessary, of course).
>
> The software bridge floods the packet according to its own FDB. In your
> case, the software bridge recognizes the MAC DA of the packet as being
> equal to the MAC address of br0 itself, and so, it doesn't flood it,
> just terminates it locally. This is true whether or not the switch
> learned that address in its FDB on the CPU port.
>
> > Also apologies if all of this is very obvious. So far I have only been
> > working on the xMII part of Ethernet drivers, meaning: I am totally
> > new to the FDB part.
> >
> > > Then have a patch (set) lifting the "return -EINVAL" from gswip *properly*.
> > > And only then do we get to ask the questions "how bad are things for
> > > linux-5.18.y? how bad are they for linux-5.15.y? what do we need to do?".
> > agreed
> >
> >
> > Thanks again for your time and all these valuable hints Vladimir!
> > Martin
> >
> >
> > [0] https://assets.maxlinear.com/web/documents/617930_gsw140_ds_rev1.11.pdf
>
> So if I'm right, the state of facts is quite "not broken" (quite the
> other way around, I'm really impressed), although there are still
> improvements to be made. Flooding could be offloaded to hardware, then
> flooding to CPU could be turned off and controlled via port promiscuity.
> This would save quite a few CPU cycles.
Hearing that things are not horribly broken is great!
Also saving a few CPU cycles would be awesome since this SoCs has a
500MHz MIPS 34Kc core with two VPEs (meaning: one core which supports
SMT - or "HT" as known in the Intel world). So any CPU cycle that can
be saved helps


Best regards,
Martin
