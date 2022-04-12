Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7714FE3A0
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 16:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350702AbiDLOX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 10:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiDLOXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 10:23:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99694CD64;
        Tue, 12 Apr 2022 07:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7J96Dt1kXtqyEjRMGqLahhTy2k/Nxamkqnzn0/g7spk=; b=auB5eoNA3P5yotD3a0TyvBOtF+
        ocr66ACTu5npEfCWRZlOm6+ALYeOFOTkNFtD8LI4sFKkSfVXQ3Q7V+0S4sVN+m4/2O60ToFhMGXTS
        N+vtetiGM6F2sVIcM4Ht8O5CHXMJswoix/ii6RVVgqFayifSHJsLr3YnSijidtjA4Usc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1neHOW-00FT60-3l; Tue, 12 Apr 2022 16:21:24 +0200
Date:   Tue, 12 Apr 2022 16:21:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 14/14] net: ethernet: mtk_eth_soc: support creating
 mac address based offload entries
Message-ID: <YlWK5Dozpo7nIS9j@lunn.ch>
References: <20220405195755.10817-1-nbd@nbd.name>
 <20220405195755.10817-15-nbd@nbd.name>
 <Yk8pJRxnVCfdk8xi@lunn.ch>
 <f25a6278-1baf-cc27-702a-5d93eedda438@nbd.name>
 <YlQmf7qGAnq/3nW0@lunn.ch>
 <ece29b0d-bbbe-7c03-a6b4-60e44453ca31@nbd.name>
 <YlV5jEzNZT1aKmNL@lunn.ch>
 <ee1d6c89-95f4-bf28-cf25-36b18ffb342f@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee1d6c89-95f4-bf28-cf25-36b18ffb342f@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 03:49:51PM +0200, Felix Fietkau wrote:
> 
> On 12.04.22 15:07, Andrew Lunn wrote:
> > > > > > > I'm trying to understand the architecture here.
> > > > > > > We have an Ethernet interface and a Wireless interface. The slow
> > > > > path
> > > > > > is that frames ingress from one of these interfaces, Linux decides
> > > > > > what to do with them, either L2 or L3, and they then egress probably
> > > > > > out the other interface.
> > > > > > > The hardware will look at the frames and try to spot flows? It
> > > > > will
> > > > > > then report any it finds. You can then add an offload, telling it for
> > > > > > a flow it needs to perform L2 or L3 processing, and egress out a
> > > > > > specific port? Linux then no longer sees the frame, the hardware
> > > > > > handles it, until the flow times out?
> > > > > Yes, the hw handles it until either the flow times out, or the corresponding
> > > > > offload entry is removed.
> > > > > > > For OpenWrt I also wrote a daemon that uses tc classifier
> > > BPF to accelerate
> > > > > the software bridge and create hardware offload entries as well via hardware
> > > > > TC flower rules: https://github.com/nbd168/bridger
> > > > > It works in combination with these changes.
> > > > > What about the bridge? In Linux, it is the software bridge which
> > > > controls all this at L2, and it should be offloading the flows, via
> > > > switchdev. The egress port you derive here is from the software bridge
> > > > FDB?
> > 
> > > My code uses netlink to fetch and monitor the bridge configuration,
> > > including fdb, port state, vlans, etc. and it uses that for the offload path
> > > - no extra configuration needed.
> > 
> > So this is where we get into architecture issues. Do we really want
> > Linux to have two ways for setting up L2 networking? It was decided
> > that users should not need to know about how to use an accelerator,
> > they should not use additional tools, it should just look like
> > linux. The user should just add the WiFi netdev to the bridge and
> > switchdev will do the rest to offload L2 switching to the hardware.
> > 
> > You appear to be saying you need a daemon in userspace. That is not
> > how every other accelerate works in Linux networking.
> > 
> > We the Linux network community need to decided if we want this?

> The problem here is that it can't be fully transparent. Enabling hardware
> offload for LAN -> WiFi comes at a cost of bypassing airtime fairness and
> mac80211's bufferbloat mitigation.
> Some people want this anyway (often but not always for benchmark/marketing
> purposes), but it's not something that I would want to have enabled by
> default simply by a wifi netdev to a bridge.

So this sounds like a generic issue. How does IPA handle this? Looping
in Alex Elder.

There is already something partially in this direction in the
bridge. You can add a static entry with our without self. This
controls if a specific static entry in the FDB is offloaded to the
accelerate or not. Maybe you can add an attribute to a port which
determines if dynamic entries are self or not, so you can decide if
frames egressing out a specific interface are accelerated or not,
depending on user choice. Since such a change should not touch the
fast path, it has a better chance of being merged.

> Initially, I wanted to put more of the state tracking code in the kernel. I
> made the first implementation of my acceleration code as a patch to the
> network bridge - speeding up bridge unicast forwarding significantly for any
> device regardless of hardware support. I wanted to build on that to avoid
> putting a lot of FDB/VLAN related tracking directly into the driver.

But the driver is the correct place for this. How generic is the state
tracking? Do you expect any other hardware to need the same state
tracking? IPA? Some other accelerate your know of?

	  Andrew
