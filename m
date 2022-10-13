Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AADF5FDC24
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 16:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJMOLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 10:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJMOK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 10:10:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7514BA5D
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 07:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aVV6nLMJHEcCeLK3mA1RUrXSvJ/itjth7X+6dDA8w+g=; b=BFQmGo9sCLrnx8cL+6SlURZgnx
        66tFzclyNQ/mI7x/N6e2OpYzSRa3KWn6IGoTNcxSV8g02JkAEKYqaRx4tOOo8Bkk6wHSZyJY3eSS3
        kRJk9fLfMgUTZuxP0OM08bQDySTRuP9uRx2cy8bgGdKKX0TQF9KhTflIqaFxZfcrhZDo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oiyvG-001tR6-7C; Thu, 13 Oct 2022 16:10:54 +0200
Date:   Thu, 13 Oct 2022 16:10:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH v2 net] net: ftmac100: do not reject packets bigger than
 1514
Message-ID: <Y0gcblXFum4GsSve@lunn.ch>
References: <20221012153737.128424-1-saproj@gmail.com>
 <1b919195757c49769bde19c59a846789@AcuMS.aculab.com>
 <CABikg9zdg-WW+C-46Cy=gcgsd8ZEborOJkXOPUfxy9TmNEz_wg@mail.gmail.com>
 <f05f9dd9b39f42d18df0018c3596d866@AcuMS.aculab.com>
 <CABikg9wnvHCLGXCXc-tpyrMaetHt_DDiYCrprciQ-z+9-7fz+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9wnvHCLGXCXc-tpyrMaetHt_DDiYCrprciQ-z+9-7fz+w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Without an 802.1Q tag (probably a VLAN tag?) the max frame has
> > 1514 data bytes (inc mac addresses, but excl crc).
> > Unless you are using VLANs that should be the frame limit.
> > The IP+TCP is limited to the 1500 byte payload.
> 
> Exactly! Incoming packets first go through a switch chip (Marvell
> 88E6060), so packets should get tagged.
> 
> > So if the sender is generating longer packets it is buggy!
> 
> Looking into it.
> 
> On the sender computer:
> sudo ifconfig eno1 mtu 1500 up
> ssh receiver_computer
> 
> On the receiver computer:
> in ftmac100_rx_packet_error() I call
> ftmac100_rxdes_frame_length(rxdes) and it returns 1518. I suppose, it
> is 1500 + 18(ethernet overhead) + 4(switch tag) - 4(crc).
> 
> Would you like me to dump the entire packet and verify?

You did not mention DSA before. That is an important fact.

What should happen is that the DSA framework should take the DSA frame
header into account. It should be calling into the MAC driver and
asking it to change its MTU to allow for the additional 4 bytes of the
switch tag.

But there is some history here. For a long time, it was just assumed
the MAC driver would accept any length of packet, i.e. the MRU,
Maximum Receive Unit, was big enough for DSA to just work. A Marvell
switch is normally combined with a Marvell MAC, and this was
true. This worked for a long time, until it did not work for some
combination of switch and MAC. It then became necessary to change the
MTU on the master interface, so it would actually receive the bigger
frames. But we had the backwards compatibility problem, that some MAC
drivers which work with DSA because there MRU is sufficient, don't
support changing the MTU. So we could not make it fatal if the change
of the MTU failed.

Does this driver support the MTU change op? If not, you should try
implementing it. If the hardware cannot actually receive longer
packets, you need to take the opposite approach. You need to make the
MTU on the slave interfaces smaller, so that packets from the switch
to the master interface are small enough to be correctly received when
including the switch header.

	  Andrew
