Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8034EDC3E
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237912AbiCaPCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbiCaPB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:01:56 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10FE13DB51
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:00:06 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h1so28521310edj.1
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C0OpOJktfmrEvRcZndCGiID1XNPokdjIETk3JmDS1k0=;
        b=cjRMo+umGnIWE9H4V3lDCHh+uQC+nNMdlkthjIDVGoipV0lF3/QsYIOCHEwQNG1Ezc
         cXi4Tq4FPQQ+l//QWiSoB0fQJ2BZZqW5xeZ82RmR0aMLUhe3Lz+QFzTPvmxpjYoF64Nh
         34BK+Cw5DVcVhxeaSGw8HN5X42gDRJmy3eGWrejHDynmPWFuzUttNTdKa7sEFfEoZknT
         WQCGUVqlcFCmLguZ7OJmUGGVgpH3Ct942hGrT06FQQPVtQgfDNaCTAyDaGlBa6dGPPtV
         LdTUKEsxpHmkX3lPVJS3BqvKpY9ppLxG5pajjXKq+9wSJbt3kx3ECyXFTstu1kqEhsEJ
         0m4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C0OpOJktfmrEvRcZndCGiID1XNPokdjIETk3JmDS1k0=;
        b=nA3AzRRNbdsMZlSQERX419qV0YclCJ/taKh1yP8Bn7L56STHxGzIFgPK7CCWt/KBiM
         zZlsPKEQ3XO854Z149aPwIp7kW/bYcaJnLH8nminM9HmB3b8z7WVvSHSVTiUBcJoDJzA
         B1K4vkGsLmZIEjqNccBzkq4K1ELrmuSVHoJwkSI940v0+gqixe5a15Aulul9TyYtzMrD
         t+ejmQcf1AAN7SOuAS8nnEzVdj91PUA5Rpj78nwgz4UWK8qNvgJiCIz1j+OPUqFNX06y
         hl3dtNZLUiGsxFL2oZOsbVrq9P/GHVuOxFk/KOxx5Ii//YSq+KCo8zRQx/4qTvhQBxgs
         tsLQ==
X-Gm-Message-State: AOAM5316qfrg4YVafM3KzBj4kZDRideCXWBvXnkGfHh1AmODVrECx9NL
        Yp6LAGiyHI63Uo+ivgKrZfo=
X-Google-Smtp-Source: ABdhPJzJK78brWBzt1RDWFr1dpRrlpO6jibWBM+Xw/3obX+qL1p0w7c2DfNzms2RApqbN7YROv/JdA==
X-Received: by 2002:a05:6402:d0a:b0:418:ec3b:2242 with SMTP id eb10-20020a0564020d0a00b00418ec3b2242mr9259854edb.229.1648738805027;
        Thu, 31 Mar 2022 08:00:05 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id m16-20020a17090677d000b006dfb0684545sm9565915ejn.29.2022.03.31.08.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 08:00:04 -0700 (PDT)
Date:   Thu, 31 Mar 2022 18:00:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 4/5] mv88e6xxx: Offload the flood flag
Message-ID: <20220331150002.kksvctlj5g5hoxia@skbuf>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
 <20220317065031.3830481-5-mattias.forsblad@gmail.com>
 <20220317130527.h3smbzyqoti3t4ka@skbuf>
 <87a6d6ilrl.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6d6ilrl.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 10:11:58AM +0200, Tobias Waldekranz wrote:
> On Thu, Mar 17, 2022 at 15:05, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Thu, Mar 17, 2022 at 07:50:30AM +0100, Mattias Forsblad wrote:
> >> Use the port vlan table to restrict ingressing traffic to the
> >> CPU port if the flood flags are cleared.
> >> 
> >> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> >> ---
> >
> > There is a grave mismatch between what this patch says it does and what
> > it really does. (=> NACK)
> >
> > Doing some interpolation from previous commit descriptions, the
> > intention is to disable flooding from a given port towards the CPU
> > (which, I mean, is fair enough as a goal).
> >
> > But:
> > (a) mv88e6xxx_port_vlan() disables _forwarding_ from port A to port B.
> >     So this affects not only unknown traffic (the one which is flooded),
> >     but all traffic
> > (b) even if br_flood_enabled() is false (meaning that the bridge device
> >     doesn't want to locally process flooded packets), there is no
> >     equality sign between this and disabling flooding on the CPU port.
> >     If the DSA switch is bridged with a foreign (non-DSA) interface, be
> >     it a tap, a Wi-Fi AP, or a plain Ethernet port, then from the
> >     switch's perspective, this is no different from a local termination
> >     flow (packets need to be forwarded to the CPU). Yet from the
> >     bridge's perspective, it is a forwarding and not a termination flow.
> >     So you can't _just_ disable CPU flooding/forwarding when the bridge
> >     doesn't want to locally terminate traffic.
> >
> > Regarding (b), I've CC'ed Allan Nielsen who held this presentation a few
> > years ago, and some ideas were able to be materialized in the meantime:
> > https://www.youtube.com/watch?v=B1HhxEcU7Jg
> >
> > Regarding (a), have you seen the new dsa_port_manage_cpu_flood() from
> > the DSA unicast filtering patch series?
> > https://patchwork.kernel.org/project/netdevbpf/patch/20220302191417.1288145-6-vladimir.oltean@nxp.com/
> > It is incomplete work in the sense that
> >
> > (1) it disables CPU flooding only if there isn't any port with IFF_PROMISC,
> >     but the bridge puts all ports in promiscuous mode. I think we can
> >     win that battle here, and convince bridge/switchdev maintainers to
> >     not put offloaded bridge ports (those that call switchdev_bridge_port_offload)
> >     in promiscuous mode, since it serves no purpose and that actively
> >     bothers us. At least the way DSA sees this is that unicast filtering
> >     and promiscuous mode deal with standalone mode. The forwarding plane
> >     is effectively a different address database and there is no direct
> >     equivalent to promiscuity there.
> >
> > (2) Right now DSA calls ->port_bridge_flags() from dsa_port_manage_cpu_flood(),
> >     i.e. it treats CPU flooding as a purely per-port-egress setting.
> >     But once I manage to straighten some kinks in DSA's unicast
> >     filtering support for switches with ds->vlan_filtering_is_global (in
> >     other words, make sja1105 eligible for unicast filtering), I pretty
> >     much plan to change this by making DSA ask the driver to manage CPU
> >     flooding per user port - leaving this code path as just a fallback.
> >
> > As baroque as I consider the sja1105 hardware to be, I'm surprised it
> > has a feature which mv88e6xxx doesn't seem to - which is having flood
> > controls per {ingress port, egress port} pair. So we'll have to
> > improvise here.
> >
> > Could you tell me - ok, you remove the CPU port from the port VLAN map -
> > but if you install host FDB entries as ACL entries (so as to make the
> > switch generate a TO_CPU packet instead of a FORWARD packet), doesn't
> > the switch in fact send packets to the CPU even in lack of the CPU
> > port's membership in the port VLAN table for the bridge port?
> >
> > If I'm right and it does, then I do see a path forward for this, with
> > zero user space additions, and working by default. We make the bridge
> > stop uselessly making offloaded DSA bridge ports promiscuous, then we
> > make DSA manage CPU flooding by itself - taking promiscuity into account
> > but also foreign interfaces joining/leaving. Then we make host addresses
> > be delivered by mv88e6xxx to the CPU as trapped and not forwarded, then
> > from new the DSA ->port_set_cpu_flood() callback we remove the CPU port
> > from the port VLAN table.
> >
> > What do you think?
> 
> It's an interesting idea. For unicast entries you could maybe get away
> with it.  Though, it would mean that we would be limited to assisted CPU
> learning, since there is no way for the switch to autonomously generate
> ACL entries ("Policy entries" in ATU parlance). By extension, this also
> means that the Learn2All functionality goes out the window for multichip
> setups for addresses associated with the CPU.

Yes, but on the other hand, dsa_port_bridge_host_fdb_add() does emit an
actual cross-chip notifier, which means that all switches in the tree do
get notified of the addresses added through assisted learning. More work
though, which I can probably agree with.

> For multicast though, I'm not sure that it would work in a multichip
> system. As you say a policy entry will be sent with a TO_CPU tag, the
> problem is that I think that applies to all DSA ports. So in this
> system:
> 
>   CPU
>    |
> .--0--.   .-----.
> | sw0 3---0 sw1 |
> '-1-2-'   '-1-2-'
> 
> If we have a multicast group with subscribers behind sw0p{0,2} and
> sw1p2, we need the following ATU entries:
> 
> sw0:
> da:01:00:5e:01:02:03 vid:0 state:policy dpv:0,2,3
> 
> sw1:
> da:01:00:5e:01:02:03 vid:0 state:policy dpv:0,2
> 
> When this group ingresses on sw0p1, I suspect it will egress
> sw0p{0,2,3}, but on ingress at sw1p0 the frame will be dropped since it
> will contain a TO_CPU tag (and sw1's CPU port is the ingress port).
> 
> Similarly, when this group ingresses on sw1p1, it will egress sw1p{0,2},
> but since it is tagged with TO_CPU on ingress to sw0p3, it won't reach
> sw0p2.

I think the idea for cross-chip multicast to work is to mark the
relevant addresses as Policy Mirrors, and make the upstream port be the
mirror port. I guess the problem will be that this will block the user
from installing mirroring rules using tc-mirred towards other ports
than the upstream port. Some other switches have a dedicated 'copy to CPU'
action, and I guess this is the reason, to not clobber your mirror port,
and I thought Marvell would too, but it looks like they don't.

In any case, implementing things this way certainly doesn't appear to be
the most straightforward way to achieve what you want, it was just worth
considering for its pros and cons.

The fact that Mattias sent a new RFC taking foreign interfaces into
account means to me that for your particular use case, you don't intend
to do software bridging, otherwise that would have been a deal breaker,
right? Or is it rather that you _may_ need software bridging, but not
for the bridge with local termination cut off, but rather for other
bridges spanning the switch? The reason I'm asking is for me to know
whether it's worth pursuing the idea of turning off CPU egress flooding,
in the most ideal of circumstances: all ports are either
(a) standalone but not promiscuous
(b) under a bridge device that isn't promiscuous and has no non-DSA bridge ports

If you really, really, really need to cut off the whole forwarding
towards the CPU and not just flooding, just because forwarding is
per-ingress-port and flooding is common to all ingress ports, then I
guess I might need to look more seriously at the option of monitoring
ingress drop tc rules on the bridge device, as implemented by Mattias,
and see what else it needs to work well.
