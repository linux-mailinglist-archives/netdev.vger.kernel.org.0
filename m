Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1551A45F9
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 21:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbfHaTgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 15:36:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46528 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728544AbfHaTgQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Aug 2019 15:36:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UxDD8aMUwVVgoe7UqZ9DMJsv9cEhFyQpEU8yg66URO0=; b=egkZEaQiBdt8ozaVJahm2oa6Ib
        DaalqvmOcRDOnNXHQhn9GcB7hvpLn/Tx7MelIb284JVJ0OQ3gTzweFV63HiATnK03yekg5O7aV6iQ
        kKKGcsUmEzLdbyfJFosN7UUjtsV1Un3H4UA9I9z19NUGltsehYMQinmtTDavT77xv4i0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i49AC-000162-Ku; Sat, 31 Aug 2019 21:35:56 +0200
Date:   Sat, 31 Aug 2019 21:35:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Miller <davem@davemloft.net>, jiri@resnulli.us,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, allan.nielsen@microchip.com,
        ivecera@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190831193556.GB2647@lunn.ch>
References: <20190829175759.GA19471@splinter>
 <20190829182957.GA17530@lunn.ch>
 <20190829193613.GA23259@splinter>
 <20190829.151201.940681219080864052.davem@davemloft.net>
 <20190830094319.GA31789@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830094319.GA31789@splinter>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Also, what happens when I'm running these application without putting
> the interface in promisc mode? On an offloaded interface I would not be
> able to even capture packets addressed to my interface's MAC address.

Sorry for rejoining the discussion late. I've been travelling and i'm
now 3/4 of the way to Lisbon.

That statement i don't get. If the frame has the MAC address of the
interface, it has to be delivered to the CPU. And so pcap will see it
when running on the interface. I can pretty much guarantee every DSA
driver does that.

But to address the bigger picture. My understanding is that we want to
model offloading as a mechanism to accelerate what Linux can already
do. The user should not have to care about these accelerators. The
interface should work like a normal Linux interface. I can put an IP
address on it and ping a peer. I can run a dhcp client and get an IP
address from a dhcp server. I can add the interface to a bridge, and
packets will get bridged. I as a user should not need to care if this
is done in software, or accelerated by offloading it. I can add a
route, and if the accelerate knows about L3, it can accelerate that as
well. If not, the kernel will route it.

So if i run wireshark on an interface, i expect the interface will be
put into promisc mode and i see all packets ingressing the interface.
What the accelerator needs to do to achieve this, i as a user don't
care.

I can follow the argument that i won't necessarily see every
packet. But that is always true. For many embedded systems, the CPU is
too slow to receive at line rate, even when we are talking about 1G
links. Packets do get dropped. And i hope tcpdump users understand
that.

For me, having tcpdump use tc trap is just wrong. It breaks the model
that the user should not care about the accelerator. If anything, i
think the driver needs to translate cBPF which pcap passes to the
kernel to whatever internal format the accelerator can process. That
is just another example of using hardware acceleration.

   Andrew
