Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAB148314F
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 14:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiACNLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 08:11:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47974 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbiACNLV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 08:11:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aI1cZL5yB9L7qnlhEEZoUoA/icXX0WayjwBgzXAEGSM=; b=ovr3ZqLGrOSjym2xPMPaH4Lb0X
        9+459Qp+Vm93dINFlabvTPHkCaIJdQdmzGLZenAEz67gqO4JXt3NdupTjM65SGiRgdY5L12vBdHMy
        hnTNtm1L7ma3Uvlc/u2B3PHdXkS9tudUjWOAPGa3MNXzEJCQWRVGbmYocMQ0ScFpdwx4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n4N7I-000N0r-SU; Mon, 03 Jan 2022 14:11:12 +0100
Date:   Mon, 3 Jan 2022 14:11:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xiangyu Chen <xiangyu.chen@aol.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, xiangyu.chen@msn.com
Subject: Re: [PATCH 2/2] dt-bindings: net: ti:add support slave interface
 using internal clock in dual rmii emac mode
Message-ID: <YdL18KgE8J/ptaO6@lunn.ch>
References: <20220103050200.6382-1-xiangyu.chen.ref@aol.com>
 <20220103050200.6382-1-xiangyu.chen@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103050200.6382-1-xiangyu.chen@aol.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 01:02:02PM +0800, Xiangyu Chen wrote:
> This is the second patch of as subject said topic. It contains dts
>  document modification.

Please thread your two patches together. git send-email should do that
by default.

> Those patches regarding to add a way to setup/config the TI-AM335x series
> Soc for 2 ways phy clock mode under RMII mode.
> 
> The basic scenario is when we have 2 PHYs connected to AM335x in RMII
> mode, either we set the both of phy in external clock mode or we set the phy in internal
> clock mode.
> 
> As TI suggetsion, when under RMII mode, the clock should use an external
> osc due to AM335x cannot generate a low-jitter stable 50MHz clock, this
> might cause some PHY cannot work correctly. But in some case (e.g. our
> design, no impact on using low speed PHY for debugging/management).
> There is no impact on some model phys.
> 
> So I think we should provide a way to allow user can set/config the PHY
> chose clock mode in dual RMII emac mode.
> 
> Tests:
> 
> Below is my testing environment:
> 
> am335x SOC --RMII 1--> PHY1 (eth0) which using internal clock
>           |-RMII 2--> PHY2 (eth1) which using external clock
> 
> Booting log:
> Booting log:
> 
> [    1.843108] cpsw 4a100000.ethernet: Detected MACID = 78:04:73:37:68:6c
> [    1.850924] cpsw 4a100000.ethernet: initialized cpsw ale version 1.4
> [    1.857842] cpsw 4a100000.ethernet: ALE Table size 1024
> [    1.863449] cpsw 4a100000.ethernet: cpts: overflow check period 500 (jiffies)
> [    1.874620] cpsw 4a100000.ethernet: cpsw: Detected MACID = 78:04:73:37:68:6e
> [    4.017695] net eth0: initializing cpsw version 1.12 (0)
> [    5.207867] cpsw 4a100000.ethernet eth0: Link is Up - 10Mbps/Full - flow control off
> [  29.747480] net eth1: initializing cpsw version 1.12 (0)
> [  30.806444] cpsw 4a100000.ethernet eth1: Link is Up - 100Mbps/Full - flow control off
> 
> # ifconfig
> 
> eth0      Link encap:Ethernet  HWaddr 00:FA:F9:00:61:88
>           inet addr:192.168.0.20  Bcast:192.168.0.255  Mask:255.255.255.0
>           inet6 addr: fe80::2fa:f9ff:fe00:6188/64 Scope:Link
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:20 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:35 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:1394 (1.3 KiB)  TX bytes:3272 (3.1 KiB)
>           Interrupt:50
> 
> eth1      Link encap:Ethernet  HWaddr 78:04:73:37:68:6E
>           inet addr:10.176.28.165  Bcast:10.176.29.255  Mask:255.255.254.0
>           inet6 addr: fe80::7a04:73ff:fe37:686e/64 Scope:Link
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:1809 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:99 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:123057 (120.1 KiB)  TX bytes:9012 (8.8 KiB)
> 
> lo        Link encap:Local Loopback
>           inet addr:127.0.0.1  Mask:255.0.0.0
>           inet6 addr: ::1/128 Scope:Host
>           UP LOOPBACK RUNNING  MTU:65536  Metric:1
>           RX packets:44 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:44 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:4872 (4.7 KiB)  TX bytes:4872 (4.7 KiB)
> 
> PHY1 (eth0, using internal clock from AM335x) ping:
> #ping 192.168.0.20
> 
> PING 192.168.0.20 (192.168.0.20): 56 data bytes
> 64 bytes from 192.168.0.20: seq=0 ttl=64 time=1.340 ms
> 
> ^C
> 
> --- 192.168.0.20 ping statistics ---
> 1 packets transmitted, 1 packets received, 0% packet loss
> round-trip min/avg/max = 1.340/1.340/1.340 ms
> 
> PHY2 (eth1, using external clock to AM335x) ping:
> # ping 10.176.28.1
> 
> PING 10.176.28.1 (10.176.28.1): 56 data bytes
> 64 bytes from 10.176.28.1: seq=1 ttl=254 time=1.967 ms
> 64 bytes from 10.176.28.1: seq=2 ttl=254 time=1.652 ms
> 64 bytes from 10.176.28.1: seq=3 ttl=254 time=1.688 ms
> 
> ^C
> 
> --- 10.176.28.1 ping statistics ---
> 
> 
> Both phy working normally.
> 
> 
> Thanks and Best regrads,
> 
> Xiangyu

This text should go into patch 0 of 2.

> From df2b0c2f7723deedcf4195e48e851de16b400775 Mon Sep 17 00:00:00 2001
> From: Xiangyu Chen <xiangyu.chen@aol.com>
> Date: Fri, 31 Dec 2021 10:38:03 +0800
> Subject: [PATCH 2/2] dt-bindings: net: ti:add support slave interface using
>  internal clock in dual rmii emac mode
> 
> The am335x support dual emac in rmii mode, the rmii clock can be
> provided by external osc or internal soc by ref_clk pin.
> When rmii-clock-ext has been set in device tree, both emac has been
> set to external clock mode, otherwise both emac has been set to internal
> clock mode.
> 
> In some case, one slave can be used external clock, another slave can be
> used internal clock.
> 
> This commit to support define a method to tell driver which slave phy
> use internal clock when the "rmii-clock-ext" has been set.

With patch 0/2 explaining the big picture, this commit message should
just talk about the binding.

It is worth reading
https://www.kernel.org/doc/html/latest/process/submitting-patches.html

	Andrew
