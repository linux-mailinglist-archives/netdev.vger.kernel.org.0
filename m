Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B18A1B2E
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 15:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfH2NPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 09:15:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40692 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727109AbfH2NPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 09:15:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jFMdGRkchqnYEBrx24o+aDmbK62nouD4dZcC7gAUcKw=; b=WbNRVsGDr16eD5VFXzibrYWSTw
        ZUvdxn6w6eSnOtiO9raQPa7u48PVNYr6HKxUr1eMHyoeH+UtrualQdcUrg9o1h04pYW95Ua9WozwZ
        0Nns1CYUZhYi+isiGmWoY5LTaDwxJJSVBq3xJfImOiEff9sr/XRFpVp3i4WFewiD2CMk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i3KH9-0002EA-FC; Thu, 29 Aug 2019 15:15:43 +0200
Date:   Thu, 29 Aug 2019 15:15:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jiri Pirko <jiri@resnulli.us>, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        allan.nielsen@microchip.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190829131543.GB6998@lunn.ch>
References: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
 <1567070549-29255-2-git-send-email-horatiu.vultur@microchip.com>
 <20190829095100.GH2312@nanopsycho>
 <20190829105650.btgvytgja63sx6wx@soft-dev3.microsemi.net>
 <20190829121811.GI2312@nanopsycho>
 <20190829124412.nrlpz5tzx3fkdoiw@soft-dev3.microsemi.net>
 <20190829145518.393fb99d@ceranb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829145518.393fb99d@ceranb>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 02:55:18PM +0200, Ivan Vecera wrote:
> On Thu, 29 Aug 2019 14:44:14 +0200
> Horatiu Vultur <horatiu.vultur@microchip.com> wrote:
> 
> > When a port is added to a bridge, then the port gets in promisc mode.
> > But in our case the HW has bridge capabilities so it is not required
> > to set the port in promisc mode.
> > But if someone else requires the port to be in promisc mode (tcpdump
> > or any other application) then I would like to set the port in promisc
> > mode.
> > In previous emails Andrew came with the suggestion to look at
> > dev->promiscuity and check if the port is a bridge port. Using this
> > information I could see when to add the port in promisc mode. He also
> > suggested to add a new switchdev call(maybe I missunderstood him, or I
> > have done it at the wrong place) in case there are no callbacks in the
> > driver to get this information.
> 
> I would use the 1st suggestion.
> 
> for/in your driver:
> if (dev->promiscuity > 0) {
> 	if (dev->promiscuity == 1 && netif_is_bridge_port(dev)) {
> 		/* no need to set promisc mode because promiscuity
> 		 * was requested by bridge
> 		 */
> 		...
> 	} else {
> 		/* need to set promisc mode as someone else requested
> 		 * promiscuity
> 		 */
> 	}
> }

Hi Ivan

The problem with this is, the driver only gets called when promisc
goes from 0 to !0. So, the port is added to the bridge. Promisc goes
0->1, and the driver gets called. We can evaluate as you said above,
and leave the port filtering frames, not forwarding everything. When
tcpdump is started, the core does promisc 1->2, but does not call into
the driver. Also, currently sending a notification is not
unconditional.

What this patch adds is an unconditional call into the switchdev
driver so it can evaluate the condition above, with every change to
the promisc counter.

    Andrew
