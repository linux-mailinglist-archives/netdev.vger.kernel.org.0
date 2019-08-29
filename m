Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF43CA255E
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbfH2SaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:30:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41730 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730019AbfH2SaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:30:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SxqYvv49yqmIIqleMdsHFqKFHskcW+8pUjR7rwMTuP0=; b=oUA4l5+HGnWxmXp/tiI7FHZZEh
        s1vQyf/zy8GyvMEe32SQXw/YV4dSxoMd3p7rknNMcTgQ/NZQCtn7jEEAvW0NHy+bRPFAfk5wLi0WL
        dCFZLLDKmQSpccVrnR234OJdaFEGCLGRFtkL9q40/NC1BM8/CFIqk6IBIkCB4O30O2PA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i3PBF-0004wy-Lu; Thu, 29 Aug 2019 20:29:57 +0200
Date:   Thu, 29 Aug 2019 20:29:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, allan.nielsen@microchip.com,
        ivecera@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190829182957.GA17530@lunn.ch>
References: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
 <1567070549-29255-2-git-send-email-horatiu.vultur@microchip.com>
 <20190829095100.GH2312@nanopsycho>
 <20190829132611.GC6998@lunn.ch>
 <20190829134901.GJ2312@nanopsycho>
 <20190829143732.GB17864@lunn.ch>
 <20190829175759.GA19471@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829175759.GA19471@splinter>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 
> What happens when you run tcpdump on a routed interface without putting
> it in promiscuous mode ('-p')? If it is a pure software switch, then you
> see all unicast packets addressed to your interface's MAC address. What
> happens when the same is done on a hardware switch? With the proposed
> solution you will not get the same result.
> 
> On a software switch, when you run tcpdump without '-p', do you incur
> major packet loss? No. Will this happen when you punt several Tbps to
> your CPU on the hardware switch? Yes.

Hi Ido

Please think about the general case, not your hardware. A DSA switch
generally has 1G ports. And the connection to the host is generally
1G, maybe 2.5G. So if i put one interface into promisc mode, i will
probably receive the majority of the traffic on that port, so long as
there is not too much traffic from other ports towards the CPU.

I also don't expect any major packet loss in the switch. It is still
hardware switching, but also sending a copy to the CPU. That copy will
have the offload_fwd_mark bit set, so the bridge will discard the
frame. The switch egress queue towards the CPU might overflow, but
that means tcpdump does not get to see all the frames, and some
traffic which is actually heading to the CPU is lost. But that can
happen anyway.

We should also think about the different classes of users. Somebody
using a TOR switch with a NOS is very different to a user of a SOHO
switch in their WiFi access point. The first probably knows tc very
well, the second has probably never heard of it, and just wants
tcpdump to work like on their desktop.

	 Andrew
