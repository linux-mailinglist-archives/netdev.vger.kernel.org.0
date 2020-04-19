Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191D61AFA22
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 14:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgDSMrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 08:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgDSMrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 08:47:13 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49E9C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 05:47:13 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id q8so5578733eja.2
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 05:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jGmMIHB+PVBtx1XatISRCmAwL71dRMG7XhoqHc+li4k=;
        b=Suao079yKJLo4TQs5uWtCcKjXt1d6eHk7dSrS65I6Bp285TmNwfMtlwc7IF1CRNuln
         m8fRTKKnwk1kHi88UZelCpb2I9fMsRwUFLbb/veQMTRheQXx5+IlDmgI0dFh2zvuA+C6
         cKz2hR8QmRz53w3acg/iIiJER5f159AOIxmqm+kAkfyTy8TOx+joScLPgxdNF/oftrWn
         zc3W1EDyJjxIzplnPlVpADpkCnN2j5eWWFQh9fwzfmncFPtEeI+tsWmJsjixkLPZU5NP
         nqR11cOxrLbwkiegTN/dDJKOALFklw+nFxJQfsh75snmgiPjl/Rf4/p8kCauhNqGvhfC
         rX+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jGmMIHB+PVBtx1XatISRCmAwL71dRMG7XhoqHc+li4k=;
        b=NszkLgl7AMZwGcAK07uHcJvSqAs3Qr1/BmfKXgFH3TMGAqNcY0HF/5Ly/MInRmK94I
         D7FmjqsjMyle9k3dluymrdHD5C06hhmG8rgJvi68JRrZqA6rGBzkQqnbdTU84DRfEb4J
         cD3Dw8BsMUZThCaPHcTLSuLKbp+6VflPvbeQCPCk/HNouqfKYw6zoweI4o/1pZRFSkxL
         EbmDz1vp3BjIBuKe9sAkW4bi6Bl695UyaibJHf0Ftd8XB7wb7Y2U17J1tiNF5FKy0rig
         LLZhTbhgkptoTgJlGsedsRE5oVaCV36jcxIcwOZOSA6jIONF3FWqLOo+oH2vkx+vcfn/
         L+OA==
X-Gm-Message-State: AGi0PuZXu7dfDgFCuPoUgM34krFqWv8x/qgqkoPhz6yPjzdDBMj8d5c/
        ppCmR+7XDtEa4Z/wcdfOfLm+0+a9DLawBItMQFSNmfTZ
X-Google-Smtp-Source: APiQypLURjUsCnwCMji+UhTPNUMvqnhi8vWTW3xDqa6tr+sMT5Oon/DJLL041LY5BI4O8RAUs5/dY3kuc2ZTWjqcjP8=
X-Received: by 2002:a17:906:48ce:: with SMTP id d14mr10896541ejt.113.1587300432222;
 Sun, 19 Apr 2020 05:47:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200417190308.32598-1-olteanv@gmail.com> <20200419073307.uhm3w2jhsczpchvi@ws.localdomain>
 <20200419083032.GA3479405@splinter>
In-Reply-To: <20200419083032.GA3479405@splinter>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 19 Apr 2020 15:47:01 +0300
Message-ID: <CA+h21hrqjXGUERKUXCWiciP7ZGnjhTeq=+ocMyP5msrKZ3pGSw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: deal with problematic
 MAC_ETYPE VCAP IS2 rules
To:     Ido Schimmel <idosch@idosch.org>
Cc:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, Po Liu <po.liu@nxp.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido, Allan,

On Sun, 19 Apr 2020 at 11:30, Ido Schimmel <idosch@idosch.org> wrote:
>
> On Sun, Apr 19, 2020 at 09:33:07AM +0200, Allan W. Nielsen wrote:
> > Hi,
> >
> > Sorry I did not manage to provide feedback before it was merged (I will
> > need to consult some of my colleagues Monday before I can provide the
> > foll feedback).
> >
> > There are many good things in this patch, but it is not only good.
> >
> > The problem is that these TCAMs/VCAPs are insanely complicated and it is
> > really hard to make them fit nicely into the existing tc frame-work
> > (being hard does not mean that we should not try).
> >
> > In this patch, you try to automatic figure out who the user want the
> > TCAM to be configured. It works for 1 use-case but it breaks others.
> >
> > Before this patch you could do a:
> >     tc filter add dev swp0 ingress protocol ipv4 \
> >             flower skip_sw src_ip 10.0.0.1 action drop
> >     tc filter add dev swp0 ingress \
> >             flower skip_sw src_mac 96:18:82:00:04:01 action drop
> >
> > But the second rule would not apply to the ICMP over IPv4 over Ethernet
> > packet, it would however apply to non-IP packets.
> >
> > With this patch it not possible. Your use-case is more common, but the
> > other one is not unrealistic.
> >
> > My concern with this, is that I do not think it is possible to automatic
> > detect how these TCAMs needs to be configured by only looking at the
> > rules installed by the user. Trying to do this automatic, also makes the
> > TCAM logic even harder to understand for the user.
> >
> > I would prefer that we by default uses some conservative default
> > settings which are easy to understand, and then expose some expert
> > settings in the sysfs, which can be used to achieve different
> > behavioral.
> >
> > Maybe forcing MAC_ETYPE matches is the most conservative and easiest to
> > understand default.
> >
> > But I do seem to recall that there is a way to allow matching on both
> > SMAC and SIP (your original motivation). This may be a better default
> > (despite that it consumes more TCAM resources). I will follow up and
> > check if this is possible.
> >
> > Vladimir (and anyone else whom interested): would you be interested in
> > spending some time discussion the more high-level architectures and
> > use-cases on how to best integrate this TCAM architecture into the Linux
> > kernel. Not sure on the outlook for the various conferences, but we
> > could arrange some online session to discuss this.
>
> Not sure I completely understand the difficulties you are facing, but it
> sounds similar to a problem we had in mlxsw. You might want to look into
> "chain templates" [1] in order to restrict the keys that can be used
> simultaneously.
>
> I don't mind participating in an online discussion if you think it can
> help.
>
> [1] https://github.com/Mellanox/mlxsw/wiki/ACLs#chain-templates

I think it is worth giving a bit of context on what motivated me to
add this patch. Luckily I believe I can summarize it in a paragraph
below.

I am trying to understand practical ways in which IEEE 802.1CB can be
used - an active redundancy mechanism similar to HSR/PRP which relies
on sending sequence-numbered frame duplicates and eliminating those
duplicates at the destination (as opposed to passive redundancy
mechanisms such as RSTP, MRP etc which rely on BLOCKING port states to
stop L2 forwarding loops from killing the network). So since 802.1CB
needs a network where none of the port states can be put to BLOCKING
(as that would break the forwarding of some of the replicated
streams), I need a way to limit the impact of L2 loops. Currently I am
using, rather successfully, an idea borrowed from HSR called
"self-address filtering". It says that received packets can be dropped
if their source MAC address matches the device's MAC address. This
feature is useful for ensuring that packets never traverse a ring
network more than once.
To implement this idea, I use an offloaded tc-flower rule matching on
src_mac with an action of "drop".

To my surprise, such a src_mac rule does not do what's written on the
box with the Ocelot switch flow classification engine called VCAP IS2.
That is, packets having that src_mac would only get dropped if their
protocol is not ARP, SNAP, IPv4, IPv6 and maybe others. Clearly such a
rule is less than useful for the purpose we want it to.
I did raise this concern here, and the suggestion that I got is to
implement something like this patch, aka enable a port setting which
forces matches on MAC_ETYPE keys only, regardless of higher-layer
protocol information:
https://lkml.org/lkml/2020/2/24/489
So the default (pre-patch) behavior is for IP (and other) matches to
be sane, at the expense of MAC matches being insane.
Whereas the current behavior is for MAC matches to be sane, at the
expense of IP matches becoming impossible as long as MAC rules are
also present.
In this context, Allan's complaint seems to be that the MAC matches
were "good enough" for them, even if not all MAC address matches were
caught, at least it did not prevent them from installing IP matching
rules on the same port.

I may not have completely understood Ido's suggestion to use
FLOW_CLS_TMPLT_CREATE (I might lack the imagination of how it can be
put to practical use to solve the clash here), but I do believe that
it is only a way for the driver to eliminate the guesswork out of the
user's intention.
In this case, my personal opinion is that the intention is absolutely
clear: a classifier with src_mac should match on all frames having
that src_mac (if that is not commonly agreed here, a good rule of
thumb is to compare with what a non-offloaded tc filter rule does).
Whereas the "non-problematic" MAC matches that the VCAP IS2 _is_ able
to still perform [ without calling ocelot_match_all_as_mac_etype ]
should be expressed in terms of a more specific classification key to
tc, such as:

tc filter add dev swp0 ingress *protocol 0x88f7* flower src_mac
96:18:82:00:04:01 action drop

In the above case, because "protocol" is not ipv4, ipv6, arp, snap,
then these rules can happily live together without ever needing to
call ocelot_match_all_as_mac_etype. If we agree on this solution, I
can send a patch that refines the ocelot_ace_is_problematic_mac_etype
function.

Thanks,
-Vladimir
