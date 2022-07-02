Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917295641EB
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 19:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbiGBRn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 13:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiGBRn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 13:43:26 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80FE2AE7;
        Sat,  2 Jul 2022 10:43:24 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id dn9so4139818ejc.7;
        Sat, 02 Jul 2022 10:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vecg/3ma9fuFNbUnxyeD84n9r2L5ck+cI7+Rz8YhgoI=;
        b=BJgBm7YnvvJkmrooaeZEor8DoXkjanMXUteSJgtb86jyce1FjRAszK8mdXsUE81/AV
         WCQisty15PoufmKJzRcW8lSiO3ot0bBI0j2D8xg9f/E+33Hbz41mimMoVw3NhdrfEkb5
         cFmVSCN38dAx1JTBev2G0U1wztwiFZtk4ZjmK5darCagVXDcyM/R7ibwutNXVHyRB0ko
         0s9WY4044lV6U1V9oFzFvFfUOid7JEkGXM8aehH7oRpDIBgLiRjIfWVEFfoLnPnoJ3X/
         UG2NqJpvSrd3V8b/raF9ZOFY8dsji7iOKLlI/PHU73iKSHjZHc7TYMgAzSih+HmgWPZb
         +HHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vecg/3ma9fuFNbUnxyeD84n9r2L5ck+cI7+Rz8YhgoI=;
        b=2+c/cXhMmIAwHLQEHsw+GjLDs0MqFvZOuowd00ZYPagly+AQ/anIgacMGyGSwirFpH
         2tNrYXCBmm5CaY46c8PTUE1JN6zYLZbf6iBdcLSZgEWxco3Hp41fDMoezEAq87Yphn8o
         8B5AhmFDcQZK/HBs5w3oQmddqiRHOqE46zxbiH6WaJxZ3FRmZbQOSj0M2/DXnMv5vgYj
         iYGKZ4+BHgnC8BZW2fhVfuehSfkx8biiX7V0WHy9fx3DHhtCbCGR9nU4NQXKT2SxaKd2
         I1APCdzxWDkbrBbHqDRDxvgl37tJrPkpt/jyNukt9GrmGDtgPMvE4tGaN2Likvry4cpE
         8W6Q==
X-Gm-Message-State: AJIora8NQ/jhABQIFtb2BxxG8nEvlARp8bBUCyQXBWayUR66euvtOD65
        SfkofL1Dmg49sHshYiLyH3k03S5tdGoLwsgUwgU=
X-Google-Smtp-Source: AGRyM1ujxkDYOX1yauN7FBN1CZni+7+qpCVM71Hlmgw2g6PSmqVGjhGSo5w9BTBQuSa7Zyufz9Mkup1yRFDkmkqmZVE=
X-Received: by 2002:a17:906:28d6:b0:726:41df:d9cc with SMTP id
 p22-20020a17090628d600b0072641dfd9ccmr20291127ejd.649.1656783802915; Sat, 02
 Jul 2022 10:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220630212703.3280485-1-martin.blumenstingl@googlemail.com> <20220701130157.bwepfw2oeco6teyv@skbuf>
In-Reply-To: <20220701130157.bwepfw2oeco6teyv@skbuf>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 2 Jul 2022 19:43:11 +0200
Message-ID: <CAFBinCDqgQ1WWWPmfXykeZPsiwLNu+fPg6nCN7TMNNR_JL3gxQ@mail.gmail.com>
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

On Fri, Jul 1, 2022 at 3:02 PM Vladimir Oltean <olteanv@gmail.com> wrote:
[...]
> > Use FID 0 (which is also the "default" FID) when adding/removing an FDB
> > entry for the CPU port.
>
> What does "default" FID even mean, and why is the default FID relevant?
The GSW140 datasheet [0] (which is for a newer IP than the one we are
targeting currently with the GSWIP driver - but I am not aware of any
older datasheets) page 78 mentions: "By default the FID is zero and
all entries belong to shared VLAN learning."
Further down you mention that I probably don't understand the problem,
which is probably true - so I'll cut things short here.

[...]
> > Fixes: 58c59ef9e930c4 ("net: dsa: lantiq: Add Forwarding Database access")
>
> I guess you don't understand the problem. That commit can't be wrong,
> since it dates from v5.2, but DSA only started calling port_fdb_add() on
> a CPU port at all since commit
> d5f19486cee7 ("net: dsa: listen for SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors") (v5.12)
> - and technically, that was opt-in, and the technique only started to become more widespread with commits
> 81a619f78759 ("net: dsa: include fdb entries pointing to bridge in the host fdb list"),
> 10fae4ac89ce ("net: dsa: include bridge addresses which are local in the host fdb list") and
> 3068d466a67e ("net: dsa: sync static FDB entries on foreign interfaces to hardware")
> (all appeared in v5.14).
OK, this makes sense as we're not seeing these warnings in 5.10
Initially I thought that "just" the printk level was changed from
DEBUG to something higher - but it seems that this observation is
incorrect.

> Also, the most recent application of the "port_fdb_add() on CPU ports" technique was introduced in commit
> 5e8a1e03aa4d ("net: dsa: install secondary unicast and multicast addresses as host FDB/MDB")
> (v5.18). But that is also more or less opt-in, since the driver needs to
> declare support for FDB isolation to make use of it.
I did find the FDB isolation changes in 5.18 but I am not sure yet how
to integrate it into the GSWIP driver.

> > Cc: stable@vger.kernel.org
>
> We don't CC stable for patches that go through the "net" tree, the
> networking maintainers send weekly pull requests and the patches get
> automatically backported from there to the relevant and still-not-EOL
> stable branches, based on the Fixes: tag. That's why it's important that
> you fill that in correctly.
sorry, I'll clean it up in v2

> > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > ---
> > This patch is "minimalistic" on purpose: the goal is to have it
> > backported to Linux 5.15. Linux 5.15 doesn't have dsa_fdb_present_in_other_db()
> > or struct dsa_db yet. Once this patch has been accepted I will work on
> > implementing FDB isolation for the Lantiq GSWIP driver.
>
> Don't you want to go the other way around, first understand what is the
> real problem, its impact and the correct solution, then figure out what
> and how can be backported, and _where_?
>
> I'm willing to help.
I thought that I understood the problem but this is clearly not the
case. Thanks for offering your help!

> First it should be understood why DSA bothers to install FDB entries on
> the CPU port in the first place. It does so because there is a largeish
> class of switches where the MAC source addresses of traffic originating
> from Linux are not learned by the hardware. As such, packets being targeted
> _towards_ Linux interfaces will not find an entry in the FDB, and will
> be flooded. This can be seen if you have a system with swp0 and swp1
> both under br0, and the station attached to swp0 pings br0. The ICMP
> requests will also be visible by the station attached to swp1.
>
> It's hard to say whether this is the case or not for gswip, but this has
> been going on for years and years. Not really a functional (connectivity)
> problem, but nonetheless undesirable.
I think for GSWIP it's not flooding packets to all ports.
For testing I had one device connected to LAN1 (let's call this swp0,
in OpenWrt we actually name the port "lan1") and another one connected
to LAN4 (I'll again go with your example and call this swp1).
A ping from the device on swp0 to the IPv4 of br0 (called br-lan in
OpenWrt) was not visible in wireshark on the other device on swp1.
This is with and without this patch.

If needed I can re-test this with Linux 5.10 to make sure that none of
the DSA changes had any impact on this behavior.

[...]
> Yet, in a strange way, it appears that it isn't the development of new
> core features that draws people's attention, but the harmless kernel log
> error messages. So in a way, I don't feel so bad that now I have your
> attention?
To give you some insight how I found this warning:
I updated the Lantiq target in OpenWrt to Linux 5.15 - until then I
didn't think we had to make any GSWIP changes because "everything
worked fine".
The first feedback I got for this was basically "does the Ethernet
switch still work with the new warnings?".

Also there's no need to feel bad for this message. I'm having trouble
understanding how just one switch IP (GSWIP) works. Maintaining a
subsystem which fits many switch IPs must be a different beast.

> In any case, I recommend you to first set up a test bench where you
> actually see a difference between packets being flooded to the CPU vs
> matching an FDB entry targeting it. Then read up a bit what the provided
> dsa_db argument wants from port_fdb_add(). This conversation with Alvin
> should explain a few things.
> https://patchwork.kernel.org/project/netdevbpf/cover/20220302191417.1288145-1-vladimir.oltean@nxp.com/#24763870
I previously asked Hauke whether the RX tag (net/dsa/tag_gswip.c) has
some bit to indicate whether traffic is flooded - but to his knowledge
the switch doesn't provide this information.
So I am not sure what I can do in this case - do you have any pointers for me?

Also apologies if all of this is very obvious. So far I have only been
working on the xMII part of Ethernet drivers, meaning: I am totally
new to the FDB part.

> Then have a patch (set) lifting the "return -EINVAL" from gswip *properly*.
> And only then do we get to ask the questions "how bad are things for
> linux-5.18.y? how bad are they for linux-5.15.y? what do we need to do?".
agreed


Thanks again for your time and all these valuable hints Vladimir!
Martin


[0] https://assets.maxlinear.com/web/documents/617930_gsw140_ds_rev1.11.pdf
