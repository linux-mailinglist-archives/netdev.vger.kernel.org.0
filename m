Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7340F1B617E
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 19:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgDWRAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 13:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729674AbgDWRAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 13:00:21 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50901C09B042;
        Thu, 23 Apr 2020 10:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SLXXj8i9vi69xcCnNJQ1dfaFIQxrJ+YqvKu0gtVCAnQ=; b=eIMON1LeXDi2bpKRQUdKsX28Z
        sXPQjqYmJL/INAPNPDWJ4OIROoVRHub4XPPLyxOZuUC4I/Mnnd47yBIFp6nNG0mV5RU1mQMsN1zkD
        XnxVvCum5qsMvAaSVZRvkbW0axQPcB9pZwGUYqZvoXu2gJ79TG3nBD/z4OSn2VcnsI2GKeaUHNY5S
        XAphacigPIzIdUnQ9qogMpqRidDg0CVK0OXl/EADqiw7LoC1tnKzv6j+OGlYMwDH2i2bQLV+Zo9it
        76DOJYBybNHwPa61WElYI+/4ru2Xda0r42mktZuW8/RmmnXfGIHweL5TzvVUbtCKVzccnK7hM3AvE
        MOWx03tQQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54318)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jRfCr-0007au-Mo; Thu, 23 Apr 2020 18:00:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jRfCl-0000rV-JN; Thu, 23 Apr 2020 18:00:03 +0100
Date:   Thu, 23 Apr 2020 18:00:03 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        Nadav Haklai <nadavh@marvell.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts to handle
 RSS tables
Message-ID: <20200423170003.GT25745@shell.armlinux.org.uk>
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
 <20190524100554.8606-4-maxime.chevallier@bootlin.com>
 <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 01:43:02AM +0200, Matteo Croce wrote:
> On Tue, Apr 14, 2020 at 1:21 AM Maxime Chevallier
> <maxime.chevallier@bootlin.com> wrote:
> >
> > The PPv2 controller has 8 RSS tables that are shared across all ports on
> > a given PPv2 instance. The previous implementation allocated one table
> > per port, leaving others unused.
> >
> > By using RSS contexts, we can make use of multiple RSS tables per
> > port, one being the default table (always id 0), the other ones being
> > used as destinations for flow steering, in the same way as rx rings.
> >
> > This commit introduces RSS contexts management in the PPv2 driver. We
> > always reserve one table per port, allocated when the port is probed.
> >
> > The global table list is stored in the struct mvpp2, as it's a global
> > resource. Each port then maintains a list of indices in that global
> > table, that way each port can have it's own numbering scheme starting
> > from 0.
> >
> > One limitation that seems unavoidable is that the hashing parameters are
> > shared across all RSS contexts for a given port. Hashing parameters for
> > ctx 0 will be applied to all contexts.
> >
> > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> 
> Hi all,
> 
> I noticed that enabling rxhash blocks the RX on my Macchiatobin. It
> works fine with the 10G ports (the RX rate goes 4x up) but it
> completely kills the gigabit interface.
> 
> # 10G port
> root@macchiatobin:~# iperf3 -c 192.168.0.2
> Connecting to host 192.168.0.2, port 5201
> [  5] local 192.168.0.1 port 42394 connected to 192.168.0.2 port 5201
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec   941 MBytes  7.89 Gbits/sec  4030    250 KBytes
> [  5]   1.00-2.00   sec   933 MBytes  7.82 Gbits/sec  4393    240 KBytes
> root@macchiatobin:~# ethtool -K eth0 rxhash on
> root@macchiatobin:~# iperf3 -c 192.168.0.2
> Connecting to host 192.168.0.2, port 5201
> [  5] local 192.168.0.1 port 42398 connected to 192.168.0.2 port 5201
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec   860 MBytes  7.21 Gbits/sec  428    410 KBytes
> [  5]   1.00-2.00   sec   859 MBytes  7.20 Gbits/sec  185    563 KBytes
> 
> # gigabit port
> root@macchiatobin:~# iperf3 -c turbo
> Connecting to host turbo, port 5201
> [  5] local 192.168.85.42 port 45144 connected to 192.168.85.6 port 5201
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec   113 MBytes   948 Mbits/sec    0    407 KBytes
> [  5]   1.00-2.00   sec   112 MBytes   942 Mbits/sec    0    428 KBytes
> root@macchiatobin:~# ethtool -K eth2 rxhash on
> root@macchiatobin:~# iperf3 -c turbo
> iperf3: error - unable to connect to server: Resource temporarily unavailable
> 
> I've bisected and it seems that this commit causes the issue. I tried
> to revert it on nex-next as a second test, but the code has changed a
> lot much since, generating too much conflicts.
> Can you have a look into this?

This behaviour on eth2 is confirmed here on v5.6.  Turning on rxhash
appears to prevent eth2 working.

Maxime, please look into this regression, thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
