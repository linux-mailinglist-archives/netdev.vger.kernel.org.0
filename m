Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 722A1902EE
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfHPNZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:25:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbfHPNZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 09:25:08 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5EEA689C39;
        Fri, 16 Aug 2019 13:25:06 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-116-43.ams2.redhat.com [10.36.116.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E44B64EE11;
        Fri, 16 Aug 2019 13:25:02 +0000 (UTC)
Date:   Fri, 16 Aug 2019 15:25:00 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Igor Russkikh <Igor.Russkikh@aquantia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "camelia.groza@nxp.com" <camelia.groza@nxp.com>,
        Simon Edelhaus <Simon.Edelhaus@aquantia.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: Re: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Message-ID: <20190816132500.GA8697@bistromath.localdomain>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190813085817.GA3200@kwain>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 16 Aug 2019 13:25:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-13, 10:58:17 +0200, Antoine Tenart wrote:
> Hi Igor,
> 
> On Sat, Aug 10, 2019 at 01:20:32PM +0000, Igor Russkikh wrote:
> > On 08.08.2019 17:05, Antoine Tenart wrote:
> > 
> > > The Rx and TX handlers are modified to take in account the special case
> > > were the MACsec transformation happens in the hardware, whether in a PHY
> > > or in a MAC, as the packets seen by the networking stack on both the
> > 
> > Don't you think we may eventually may need xmit / handle_frame ops to be
> > a part of macsec_ops?
> > 
> > That way software macsec could be extract to just another type of offload.
> > The drawback of current code is it doesn't show explicitly the path of
> > offloaded packets. It is hidden in `handle_not_macsec` and in
> > `macsec_start_xmit` branch. This makes incorrect counters to tick (see my below
> > comment)
> > 
> > Another thing is that both xmit / macsec_handle_frame can't now be customized
> > by device driver. But this may be required.
> > We for example have usecases and HW features to allow specific flows to bypass
> > macsec encryption. This is normally used for macsec key control protocols,
> > identified by ethertype. Your phy is also capable on that as I see.
> 
> I think this question is linked to the use of a MACsec virtual interface
> when using h/w offloading. The starting point for me was that I wanted
> to reuse the data structures and the API exposed to the userspace by the
> s/w implementation of MACsec. I then had two choices: keeping the exact
> same interface for the user (having a virtual MACsec interface), or

Unless it's really infeasible, yes, that's how things should be done IMO.

> registering the MACsec genl ops onto the real net devices (and making
> the s/w implementation a virtual net dev and a provider of the MACsec
> "offloading" ops).

Please, no :( Let's keep it as close as possible to the software
implementation, unless there's a really good reason not to. It's not
just "ip macsec" btw, wpa_supplicant can also configure MACsec and
would also need some logic to pick the device on which to do the genl
operations in that case.

> The advantages of the first option were that nearly all the logic of the
> s/w implementation could be kept and especially that it would be
> transparent for the user to use both implementations of MACsec. But this
> raised an issue as I had to modify the xmit / handle_frame ops to let
> all the traffic pass. This is because we have no way of knowing if a
> frame was handled by the MACsec h/w or not in ingress. So the virtual
> interface here only serve as the entrypoint for the API...

It's also the interface on which you'll run DHCP or install IP addresses.

> The second option would have the advantage to better represent the actual
> flow, but the way of configuring MACsec would be a bit different for the
> user, whether he wants to use s/w or h/w MACsec. If we were to do this I
> think we could extract the genl functions from the MACsec s/w
> implementation, and let it implement the MACsec ops (exactly as the
> offloading drivers).
> 
> I'm open to discussing this :)
> 
> As for the need for xmit / handle_frame ops (for a MAC w/ MACsec
> offloading), I'd say the xmit / handle_frame ops of the real net device
> driver could be used as the one of the MACsec virtual interface do not
> do much (regardless of the implementation choice discussed above).

There's no "handle_frame" op on a real device. macsec_handle_frame is
an rx_handler specificity that grabs packets from a real device and
sends them into a virtual device stacked on top of it. A real device
just hands packets over to the stack via NAPI.


> > > @@ -2546,11 +2814,15 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
> > >  {
> > >  	struct macsec_dev *macsec = netdev_priv(dev);
> > >  	struct macsec_secy *secy = &macsec->secy;
> > > +	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
> > >  	struct pcpu_secy_stats *secy_stats;
> > > +	struct macsec_tx_sa *tx_sa;
> > >  	int ret, len;
> > >  
> > > +	tx_sa = macsec_txsa_get(tx_sc->sa[tx_sc->encoding_sa]);
> > 
> > Declared, but not used?
> 
> I'll remove it then.

That's also a refcount leak, so, yes, please get rid of it.

[I'll answer the rest of the patch separately]

-- 
Sabrina
