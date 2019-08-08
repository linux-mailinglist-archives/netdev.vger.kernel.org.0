Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC06586C2B
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 23:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390303AbfHHVQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 17:16:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45730 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfHHVQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 17:16:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dNED9cOAaf+dopo9LgD6lakNRzaOyizkrYw7uOWZ5Xo=; b=2GxiWSnwdFRRFSkcT2NQQ41kOP
        ZUif8Th7z7VjXSCY/+xkhOmbzqIxwsHvzRBDesmOaZn3Y2Isw8iGLNWlrapPp0jir9gAL9bUd55ST
        X9K0bm8frnrWU2LT/cDF1kHeqjJnRI3y8quzNAp6ZKHCGQNRpbK8OXiNvqjmKahnB0ms=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvplt-00069g-Ik; Thu, 08 Aug 2019 23:16:29 +0200
Date:   Thu, 8 Aug 2019 23:16:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tao Ren <taoren@fb.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        William Kennington <wak@google.com>,
        Joel Stanley <joel@jms.id.au>
Subject: Re: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
Message-ID: <20190808211629.GQ27917@lunn.ch>
References: <20190807002118.164360-1-taoren@fb.com>
 <20190807112518.644a21a2@cakuba.netronome.com>
 <20190807184143.GE26047@lunn.ch>
 <806a76a8-229a-7f24-33c7-2cf2094f3436@fb.com>
 <20190808133209.GB32706@lunn.ch>
 <77762b10-b8e7-b8a4-3fc0-e901707a1d54@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77762b10-b8e7-b8a4-3fc0-e901707a1d54@fb.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 07:02:54PM +0000, Tao Ren wrote:
> Hi Andrew,
> 
> On 8/8/19 6:32 AM, Andrew Lunn wrote:
> >> Let me prepare patch v2 using device tree. I'm not sure if standard
> >> "mac-address" fits this situation because all we need is an offset
> >> (integer) and BMC MAC is calculated by adding the offset to NIC's
> >> MAC address. Anyways, let me work out v2 patch we can discuss more
> >> then.
> > 
> > Hi Tao
> > 
> > I don't know BMC terminology. By NICs MAC address, you are referring
> > to the hosts MAC address? The MAC address the big CPU is using for its
> > interface?  Where does this NIC get its MAC address from? If the BMCs
> > bootloader has access to it, it can set the mac-address property in
> > the device tree.
> 
> Sorry for the confusion and let me clarify more:
> 

> The NIC here refers to the Network controller which provide network
> connectivity for both BMC (via NC-SI) and Host (for example, via
> PCIe).
> 

> On Facebook Yamp BMC, BMC sends NCSI_OEM_GET_MAC command (as an
> ethernet packet) to the Network Controller while bringing up eth0,
> and the (Broadcom) Network Controller replies with the Base MAC
> Address reserved for the platform. As for Yamp, Base-MAC and
> Base-MAC+1 are used by Host (big CPU) and Base-MAC+2 are assigned to
> BMC. In my opinion, Base MAC and MAC address assignments are
> controlled by Network Controller, which is transparent to both BMC
> and Host.

Hi Tao

I've not done any work in the BMC field, so thanks for explaining
this.

In a typical embedded system, each network interface is assigned a MAC
address by the vendor. But here, things are different. The BMC SoC
network interface has not been assigned a MAC address, it needs to ask
the network controller for its MAC address, and then do some magical
transformation on the answer to derive a MAC address for
itself. Correct?

It seems like a better design would of been, the BMC sends a
NCSI_OEM_GET_BMC_MAC and the answer it gets back is the MAC address
the BMC should use. No magic involved. But i guess it is too late to
do that now.

> I'm not sure if I understand your suggestion correctly: do you mean
> we should move the logic (GET_MAC from Network Controller, adding
> offset and configuring BMC MAC) from kernel to boot loader?

In general, the kernel is generic. It probably boots on any ARM system
which is has the needed modules for. The bootloader is often much more
specific. It might not be fully platform specific, but it will be at
least specific to the general family of BMC SoCs. If you consider the
combination of the BMC bootloader and the device tree blob, you have
something specific to the platform. This magical transformation of
adding 2 seems to be very platform specific. So having this magic in
the bootloader+DT seems like the best place to put it.

However, how you pass the resulting MAC address to the kernel should
be as generic as possible. The DT "mac-address" property is very
generic, many MAC drivers understand it. Using it also allows for
vendors which actually assign a MAC address to the BMC to pass it to
the BMC, avoiding all this NCSI_OEM_GET_MAC handshake. Having an API
which just passing '2' is not generic at all.

    Andrew
