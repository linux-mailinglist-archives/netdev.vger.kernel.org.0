Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB882676DF
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgILAmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgILAms (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 20:42:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEEF5221E5;
        Sat, 12 Sep 2020 00:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599871368;
        bh=dOtlb059Sx8hef6DmMJdVZp0NMJjwulANvHSqN9Bs/8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gkKDq+9a/jPbL4J2gDHDLvBVb5hEp85ojqvwIwMJgAKtR6sd63xkEAB5nSr/3G6Gd
         3G3pZUDlpYm2nO1au30aJDvGtCfb8P/NmFdT3iHj6rXz6y7Q78YesGtk+JbJp+wWit
         SLnAPOizLN0wuBPFZPJq3lCT90s5uC0koasJ3Az0=
Date:   Fri, 11 Sep 2020 17:42:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Message-ID: <20200911174246.76466eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200912001542.fqn2hcp35xkwqoun@skbuf>
References: <20200911232853.1072362-1-kuba@kernel.org>
        <20200911234932.ncrmapwpqjnphdv5@skbuf>
        <20200911170724.4b1619d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200912001542.fqn2hcp35xkwqoun@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Sep 2020 03:15:42 +0300 Vladimir Oltean wrote:
> On Fri, Sep 11, 2020 at 05:07:24PM -0700, Jakub Kicinski wrote:
> > On Sat, 12 Sep 2020 02:49:32 +0300 Vladimir Oltean wrote:  
> > > On Fri, Sep 11, 2020 at 04:28:45PM -0700, Jakub Kicinski wrote:  
> > > > Hi!
> > > >
> > > > This is the first (small) series which exposes some stats via
> > > > the corresponding ethtool interface. Here (thanks to the
> > > > excitability of netlink) we expose pause frame stats via
> > > > the same interfaces as ethtool -a / -A.
> > > >
> > > > In particular the following stats from the standard:
> > > >  - 30.3.4.2 aPAUSEMACCtrlFramesTransmitted
> > > >  - 30.3.4.3 aPAUSEMACCtrlFramesReceived
> > > >
> > > > 4 real drivers are converted, hopefully the semantics match
> > > > the standard.
> > > >
> > > > v2:
> > > >  - netdevsim: add missing static
> > > >  - bnxt: fix sparse warning
> > > >  - mlx5: address Saeed's comments  
> > >
> > > DSA used to override the "ethtool -S" callback of the host port, and
> > > append its own CPU port counters to that.
> > >
> > > So you could actually see pause frames transmitted by the host port and
> > > received by the switch's CPU port:
> > >
> > > # ethtool -S eno2 | grep pause
> > > MAC rx valid pause frames: 1339603152
> > > MAC tx valid pause frames: 0
> > > p04_rx_pause: 0
> > > p04_tx_pause: 1339603152
> > >
> > > With this new command what's the plan?  
> >
> > Sounds like something for DSA folks to decide :)
> >
> > What does ethtool -A $cpu_port control?
> > The stats should match what the interface controls.  
> 
> Error: $cpu_port: undefined variable.
> With DSA switches, the CPU port is a physical Ethernet port mostly like
> any other, except that its orientation is inwards towards the system
> rather than outwards. So there is no network interface registered for
> it, since I/O from the network stack would have to literally loop back
> into the system to fulfill the request of sending a packet to that
> interface.

Sorry, perhaps I should have said $MAC, but that kind of in itself
answers the question.

> The ethtool -S framework was nice because you could append to the
> counters of the master interface while not losing them.
> As for "ethtool -A", those parameters are fixed as part of the
> fixed-link device tree node corresponding to the CPU port.

I think I'm missing the problem you're trying to describe.
Are you making a general comment / argument on ethtool stats?

Pause stats are symmetrical - as can be seen in your quote
what's RX for the CPU is TX for the switch, and vice versa.

Since ethtool -A $cpu_mac controls whether CPU netdev generates
and accepts pause frames, correspondingly the direction and meaning
of pause statistics on that interface is well defined.

You can still append your custom CPU port stats to ethtool -S or
debugfs or whatnot, but those are only useful for validating that 
the configuration of the CPU port is not completely broken. Otherwise
the counters are symmetrical. A day-to-day user of the device doesn't
need to see both of them.
