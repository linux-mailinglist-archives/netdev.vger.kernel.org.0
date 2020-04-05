Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E99319EC4E
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 17:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgDEPJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 11:09:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49362 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgDEPJV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Apr 2020 11:09:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jkoLjmeQfnMLhyHJFBz1LJZ7zYs69HMpdT1Zj86BWo4=; b=WfVZg9PyXRMWLGyqMlAmjFb2x8
        GAfctRf/5Tv+yjda5orvDFW1ChJzAbHefSjGLtkZCW/nztWaUdFLg7v5/IfpO5rF/ch+B5n+65eqI
        elTi0ZcZYUjsmJeYRq5E5KjKGshguCy28nLZJBEbfyg4KPenFcGNAwFFkI9yKqxunE2U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jL6tf-0016JE-GC; Sun, 05 Apr 2020 17:09:15 +0200
Date:   Sun, 5 Apr 2020 17:09:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Stijn Segers <foss@volatilesystems.org>,
        riddlariddla@hotmail.com
Subject: Re: DSA breaks clients' roaming between switch port and host
 interfaces
Message-ID: <20200405150915.GD161768@lunn.ch>
References: <CALW65jY8vvent1KmAnv2a9BTbmW5C8CHK0DpRRs73yk3L1RXLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jY8vvent1KmAnv2a9BTbmW5C8CHK0DpRRs73yk3L1RXLQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 05, 2020 at 08:23:36PM +0800, DENG Qingfang wrote:
> Hello,
> I found a bug of DSA that breaks WiFi clients roaming.
> 
> I set up 2 WiFi routers as AP, both of them run kernel 5.4.30 and use DSA.
> 
>         +-------------------------+
> +-----------------------------+
>         |                         |                            |
>                       |
>         |                         |                            |
>                       |
>         |       AP1               |                            |
> AP2                   |
>         |                     LAN2+--------------------------->|LAN1
>                       |
>         |       10.0.0.1/24       |                            |
> 10.0.0.2/24           |
>         |                         |                            |
>                       |
>         |       MV88E6XXX DSA     |                            |
> MT7530 DSA            |
>         |                         |                            |
>                       |
>         |                         |                            |
>                       |
>         |                         |                            |
>                       |
>         +-------------------------+
> +-----------------------------+
>                      ^                                              ^
>                      |                                              |
>                      |                      Roams                   |
>                      |                     -------------------------+
>                      |
>                      +------------    +-------------------+
>                                       |     Wi-Fi         |
>                                       |     Client        |
>                                       |                   |
>                                       |     10.0.0.3/24   |
>                                       |                   |
>                                       |                   |
>                                       +-------------------+
> 
> When the client roams from AP1 to AP2, it cannot ping AP1 anymore for
> a few minutes, and vice versa.
> 
> With bridge fdb I found out the part that caused the problem.
> When the client is connected to AP1, bridge fdb on AP2 shows:
> 
> <client's mac> dev lan1 master br-lan
> <client's mac> dev lan1 vlan 1 self
> 
> It means AP2 should talk to the client via lan1, which is correct.
> 
> After the client roams to AP2, the problem comes:
> 
> <client's mac>  dev wlan0 master br-lan
> <client's mac>  dev lan1 vlan 1 self
> 
> >From iproute2 man page: "self" means the address is associated with
> the port drivers fdb. Usually hardware.
> 
> The lan1 is still there, which means the kernel has updated the
> forwarding table in br-lan, but forgot to delete the one in the switch
> hardware.
> 
> What happens when the client now tries to talk to AP1, such as ping
> 10.0.0.1? I debugged with tcpdump:
> 
> 1. The client sends ARP request: who-has 10.0.0.1?
> 2. The software part of the bridge of AP2 receives the ARP request,
> updates fdb, and sends it to the CPU port
> 3. The switch receives the client's ARP request from the CPU port, and
> floods it out of the LAN1 port. Although the source MAC address of the
> request is the client's, _auto learning of the CPU port is disabled in
> DSA_, so the switch does not update the MAC table.
> 4. AP1 receives the ARP request, then responds: 10.0.0.1 is-at <AP1's MAC>.
> 5. AP2's switch receives the response from LAN1, then looks it up in
> the MAC table, the egress port is the same as the ingress port (LAN1).
> To avoid loop, the ARP response is discarded.
> 
> If I manually delete the leftover fdb entry in the hardware via
> "bridge fdb del <client's MAC> dev lan1 vlan 1", the client can talk
> to AP1 immediately.
> And vice versa, the mv88e6xxx has the same bug, so I think it's with
> the general DSA part.
> 
> Does anyone know how to fix it?
> 
> Thanks.
> Qingfang

Hi Qingfang

I've had similar reports from somebody else.

Did you try playing with auto learning for the CPU port?

    Andrew
