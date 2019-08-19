Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248FB9497E
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfHSQKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:10:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42080 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbfHSQKU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 12:10:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=E2+cbW5d6qxYVuNoFqhw7dW8Fzq/5tA95Uihf0j2K74=; b=dMiN1SI16EokRV/OvRWXxi8U2R
        rhwQ6fE5XhqfVazvjDwgB2e4NI3p30mMSd/wKybXs1viuWw8jbS/cj2hIwc4uZm9jg0U/4+5eUl4g
        rbQjk9OEyLlAS8RfjIHm5SSYrkpTzHPTBbEtksFYU8ny8eBG1fnzU0By2TbtSkmdm4ro=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hzkEc-0007ML-F3; Mon, 19 Aug 2019 18:10:18 +0200
Date:   Mon, 19 Aug 2019 18:10:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, marek.behun@nic.cz, davem@davemloft.net,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next 4/6] net: dsa: mv88e6xxx: do not change STP
 state on port disabling
Message-ID: <20190819161018.GI15291@lunn.ch>
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
 <20190818173548.19631-5-vivien.didelot@gmail.com>
 <20190819134057.GF8981@lunn.ch>
 <20190819112733.GD6123@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819112733.GD6123@t480s.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 11:27:33AM -0400, Vivien Didelot wrote:
> Hi Andrew,
> 
> On Mon, 19 Aug 2019 15:40:57 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> > On Sun, Aug 18, 2019 at 01:35:46PM -0400, Vivien Didelot wrote:
> > > When disabling a port, that is not for the driver to decide what to
> > > do with the STP state. This is already handled by the DSA layer.
> > 
> > Hi Vivien
> > 
> > Putting the port into STP disabled state is how you actually disable
> > it, for the mv88e6xxx. So this is not really about STP, it is about
> > powering off the port. Maybe a comment is needed, rather than removing
> > the code?
> 
> This is not for the driver to decide, the stack already handles that.
> Otherwise, calling dsa_port_disable on a bridged port would result in
> mv88e6xxx forcing the STP state to Disabled while this is not expected.

Hi Vivien

Lets look at this from a different angle.

The chip powers up. The older generation, the ports are enabled by
default. For newer generations the NO_CPU strapping determines the
power up state of a port.

What we want is that unused ports get powered off. The previous change
in the set does this. It calls mv88e6xxx_port_disable for all unused
ports. How do we disable the port? For the mv88ex666, we set the port
state to disabled. "The switch port is disabled and it will not
receive or transmit and frames." For other switches, there might be
other control registers to play with, other than STP.

Are you saying the core already sets the STP to disabled, for ports
which are unused? I did not spot that in your previous patch?

Thanks
	Andrew

