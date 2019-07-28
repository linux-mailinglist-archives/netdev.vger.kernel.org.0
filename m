Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D24677823E
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 01:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfG1XHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 19:07:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43032 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbfG1XHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jul 2019 19:07:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rgynBm9hctybZUQVcP0RXwQdxJdI0dv3Bh59KGp9aWo=; b=CEzzNg0Xm/Z5ZBhcLdThuFymBA
        3m2WnPrllV0f9OJX4NEWnjuV4tuMKPsDcGlKkETaNLhGbKx6cDsNYO6hMT/yS8pLPcX3D9foSF9cp
        KNe4aEAtQeNKWIaIXvwStAnRykxDdlJRAfnYWuaj3vdzxMx4Jb6cbcZz9Q6Pbx4HEtAk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hrsGT-0006hC-MQ; Mon, 29 Jul 2019 01:07:41 +0200
Date:   Mon, 29 Jul 2019 01:07:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
Message-ID: <20190728230741.GF23125@lunn.ch>
References: <7e7a7015-6072-d884-b2ba-0a51177245ab@cumulusnetworks.com>
 <eef063fe-fd3a-7e02-89c2-e40728a17578@cumulusnetworks.com>
 <20190725142101.65tusauc6fzxb2yp@soft-dev3.microsemi.net>
 <b9ce433a-3ef7-fe15-642a-659c5715d992@cumulusnetworks.com>
 <e6ad982f-4706-46f9-b8f0-1337b09de350@cumulusnetworks.com>
 <20190726120214.c26oj5vks7g5ntwu@soft-dev3.microsemi.net>
 <20190726134613.GD18223@lunn.ch>
 <20190726195010.7x75rr74v7ph3m6m@lx-anielsen.microsemi.net>
 <20190727030223.GA29731@lunn.ch>
 <20190728191558.zuopgfqza2iz5d5b@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190728191558.zuopgfqza2iz5d5b@lx-anielsen.microsemi.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Trying to get back to the original problem:
> 
> We have a network which implements the ODVA/DLR ring protocol. This protocol
> sends out a beacon frame as often as every 3 us (as far as I recall, default I
> believe is 400 us) to this MAC address: 01:21:6C:00:00:01.
> 
> Try take a quick look at slide 10 in [1].
> 
> If we assume that the SwitchDev driver implemented such that all multicast
> traffic goes to the CPU, then we should really have a way to install a HW
> offload path in the silicon, such that these packets does not go to the CPU (as
> they are known not to be use full, and a frame every 3 us is a significant load
> on small DMA connections and CPU resources).
> 
> If we assume that the SwitchDev driver implemented such that only "needed"
> multicast packets goes to the CPU, then we need a way to get these packets in
> case we want to implement the DLR protocol.
> 
> I'm sure that both models can work, and I do not think that this is the main
> issue here.
> 
> Our initial attempt was to allow install static L2-MAC entries and append
> multiple ports to such an entry in the MAC table. This was rejected, for several
> good reasons it seems. But I'm not sure it was clear what we wanted to achieve,
> and why we find it to be important. Hopefully this is clear with a real world
> use-case.
> 
> Any hints or ideas on what would be a better way to solve this problems will be
> much appreciated.

I always try to think about how this would work if i had a bunch of
discrete network interfaces, not a switch. What APIs are involved in
configuring such a system? How does the Linux network stack perform
software DLR? How is the reception and blocking of the multicast group
performed?

Once you understand how it works in the software implement, it should
then be more obvious which switchdev hooks should be used to
accelerate this using hardware.

	   Andrew
