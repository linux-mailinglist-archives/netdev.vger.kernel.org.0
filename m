Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0924FE224
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355072AbiDLNUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357115AbiDLNTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:19:17 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E1B35DE3;
        Tue, 12 Apr 2022 06:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hpGCLbrOzXS09YNJzkrxH5woyVIGrdo/h+bTCZ2VPog=; b=A8Q15kXmugOYdyZuQhnZ7fYmpc
        jIA0/p9MCphVCHBxqqjjHVwPkEp2RiAZMcydJDZ34X/6/EC49NevaOkS6zcx+x8GGG4Y8geFneRBl
        1yRpOymkqZRNNwRKUH7X1uXsHdhLSzgd7BXzRAq+n+GTF9lQf4hgKnd4Kyxnfq5VgJM4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1neGEu-00FSH7-Ux; Tue, 12 Apr 2022 15:07:24 +0200
Date:   Tue, 12 Apr 2022 15:07:24 +0200
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
Message-ID: <YlV5jEzNZT1aKmNL@lunn.ch>
References: <20220405195755.10817-1-nbd@nbd.name>
 <20220405195755.10817-15-nbd@nbd.name>
 <Yk8pJRxnVCfdk8xi@lunn.ch>
 <f25a6278-1baf-cc27-702a-5d93eedda438@nbd.name>
 <YlQmf7qGAnq/3nW0@lunn.ch>
 <ece29b0d-bbbe-7c03-a6b4-60e44453ca31@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ece29b0d-bbbe-7c03-a6b4-60e44453ca31@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > > I'm trying to understand the architecture here.
> > > > > We have an Ethernet interface and a Wireless interface. The slow
> > > path
> > > > is that frames ingress from one of these interfaces, Linux decides
> > > > what to do with them, either L2 or L3, and they then egress probably
> > > > out the other interface.
> > > > > The hardware will look at the frames and try to spot flows? It
> > > will
> > > > then report any it finds. You can then add an offload, telling it for
> > > > a flow it needs to perform L2 or L3 processing, and egress out a
> > > > specific port? Linux then no longer sees the frame, the hardware
> > > > handles it, until the flow times out?
> > > Yes, the hw handles it until either the flow times out, or the corresponding
> > > offload entry is removed.
> > > 
> > > For OpenWrt I also wrote a daemon that uses tc classifier BPF to accelerate
> > > the software bridge and create hardware offload entries as well via hardware
> > > TC flower rules: https://github.com/nbd168/bridger
> > > It works in combination with these changes.
> > 
> > What about the bridge? In Linux, it is the software bridge which
> > controls all this at L2, and it should be offloading the flows, via
> > switchdev. The egress port you derive here is from the software bridge
> > FDB?

> My code uses netlink to fetch and monitor the bridge configuration,
> including fdb, port state, vlans, etc. and it uses that for the offload path
> - no extra configuration needed.

So this is where we get into architecture issues. Do we really want
Linux to have two ways for setting up L2 networking? It was decided
that users should not need to know about how to use an accelerator,
they should not use additional tools, it should just look like
linux. The user should just add the WiFi netdev to the bridge and
switchdev will do the rest to offload L2 switching to the hardware.

You appear to be saying you need a daemon in userspace. That is not
how every other accelerate works in Linux networking.

We the Linux network community need to decided if we want this?

    Andrew
