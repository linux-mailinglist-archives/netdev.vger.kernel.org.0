Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792772D48F1
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 19:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732975AbgLIS0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 13:26:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729021AbgLIS0Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 13:26:25 -0500
Date:   Wed, 9 Dec 2020 10:25:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607538344;
        bh=3olh70Ox39tw6XugRa/u3i6hc1jdPMEGvZsicOzBiHs=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LTtPJP9Sh1z0vnmicfb4IxJpefbvHz6j1zy9HDVJ5YXM64kL1Dq85e1nGUia2QPKv
         OoNT1iEkS1aMcNKwM84MdlBTzzBqwJNOZuwhAFVpCKt62d4iamJf1Zzl4Qitr+8Ici
         Tzsmy0qAkU0dI8OVjbVMxzM9nfC/L0X9X3S00AqFCJw1knbZAQ40zyHfMzaz1yX0EX
         vacQsYooFruphkDKS1H4+MbMLXOuedfXJa/SIZT5OVie9kUpQcSWWld+YbEX0Delw4
         /jJreAwXRVUHLN/S5CLgpjXlig6dk71s+VFdaae/2oF4M8uhGXBGo0Rj5u9WG8xFlN
         Wrez9+TBmXLJg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH v3 net-next] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
Message-ID: <20201209102543.7f293126@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201209015613.b35hn6u4jgd5afb4@skbuf>
References: <20201205004315.143851-1-vladimir.oltean@nxp.com>
        <20201207170937.2bed0b40@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201209015613.b35hn6u4jgd5afb4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Dec 2020 01:56:14 +0000 Vladimir Oltean wrote:
> On Mon, Dec 07, 2020 at 05:09:37PM -0800, Jakub Kicinski wrote:
> > > +	ocelot->owq = alloc_ordered_workqueue("ocelot-owq", WQ_MEM_RECLAIM);  
> >
> > Why MEM_RECLAIM ?  
> 
> Ok, fine, I admit, I copied it.
> 
> After reading the documentation a bit more thoroughly, I am still as
> clear about the guidelines as before. The original logic was, I am
> allocating a memory area and then freeing it from the work item. So it
> must be beneficial for the kernel to want to flush this workqueue during
> the memory reclaim process / under memory pressure, because I am doing
> no memory allocation, and I am also freeing some memory in fact.
> 
> The thing is, there are already a lot of users of WQ_MEM_RECLAIM. Many
> outside of the filesystem/block subsystems. Not sure if all of them
> misuse it, or how to even tell which one constitutes a correct example
> of usage for WQ_MEM_RECLAIM.

Agreed, I wasn't 100% sure either.

I double checked with Tejun, he says it's only needed if the work 
queue is directly used in memory reclaim paths, like writing pages 
out to swap and such.
