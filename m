Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACD8271001
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 20:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgISSth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 14:49:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45340 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbgISSth (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 14:49:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJhvG-00FPVc-R7; Sat, 19 Sep 2020 20:49:22 +0200
Date:   Sat, 19 Sep 2020 20:49:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Leon Romanovsky <leon@kernel.org>,
        Gal Pressman <galpress@amazon.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200919184922.GA3665637@lunn.ch>
References: <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115227.GR869610@unreal>
 <CAFCwf10C1zm91e=tqPVGOX8kZD7o=AR2EW-P9VwCF4rcvnEJnA@mail.gmail.com>
 <20200918120340.GT869610@unreal>
 <CAFCwf12VPuyGFqFJK5D19zcKFQJ=fmzjwscdPG82tfR_v_h3Kg@mail.gmail.com>
 <20200918121905.GU869610@unreal>
 <20200919064020.GC439518@kroah.com>
 <20200919082003.GW869610@unreal>
 <20200919083012.GA465680@kroah.com>
 <CAFCwf122V-ep44Kqk1DgRJN+tq3ctxE9uVbqYL07apLkLe2Z7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCwf122V-ep44Kqk1DgRJN+tq3ctxE9uVbqYL07apLkLe2Z7g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 07:43:28PM +0300, Oded Gabbay wrote:
> It's probably heresy, but why do I need to integrate into the RDMA subsystem ?

Hi Oded

I don't know the RDMA subsystem at all. So i will give a more generic
answer. Are you reinventing things which a subsystem core already has?
The subsystem core will be well tested, since lots of devices use
it. Because of this, subsystem cores generally have a lower bug count
per line of code than driver code. Using core code means drivers are
smaller, and smaller code has less bugs by definition.

We as maintainers have to assume you are going to abandon the driver
at some point, while the hardware still exists, and leave the
community to maintain it. So a smaller driver, which makes heavy use
of the core is much easier to maintain.

By making use of core code, you also get freebies. Somebody adds new
functionality to the core, your driver automatically gets it.

Look at this from the opposite perspective. Say every driver
implemented their own TCP/IP stack? Or DMA engine? SPI infrastructure?
How big a nightmare would it be to maintain?

In your case, some parts of you hardware looks a bit like RDMA? So you
ideally want to use the core code from the RDMA subsystem. Maybe you
just need some of the lower layers? Maybe you need to refactor some of
the RDMA core to make it a library you can pick and choice the bits
useful to you? What you really want to avoid is re-implementing stuff
in your driver which is already in the core.

      Andrew
