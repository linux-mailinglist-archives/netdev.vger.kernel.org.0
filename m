Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4D794AB7
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfHSQoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:44:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42210 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727919AbfHSQox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 12:44:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4U5i8pud1wzr1vC36hXQSRYBKioRHb7htZQv9m9EGKQ=; b=SeOy7w/ATiZQnrOJUEOikxhNo2
        ooJ2sitIOgkOTsefEWJo0oTm446E0+EzWgDE4r5MQ2f7fKj4cLhUPAByP8lVxcHdt6UOfaCINErbn
        MHw6tEkTYlsV0KZQVh0YsFzX6gbfSfkAqFQLteVJgUglyfG4mX3oWo7LQ+sOduTu7VUc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hzkm2-0007e0-Gj; Mon, 19 Aug 2019 18:44:50 +0200
Date:   Mon, 19 Aug 2019 18:44:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, marek.behun@nic.cz, davem@davemloft.net,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next 4/6] net: dsa: mv88e6xxx: do not change STP
 state on port disabling
Message-ID: <20190819164450.GK15291@lunn.ch>
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
 <20190818173548.19631-5-vivien.didelot@gmail.com>
 <20190819134057.GF8981@lunn.ch>
 <20190819112733.GD6123@t480s.localdomain>
 <20190819161018.GI15291@lunn.ch>
 <20190819122737.GB16144@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819122737.GB16144@t480s.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 12:27:37PM -0400, Vivien Didelot wrote:
> On Mon, 19 Aug 2019 18:10:18 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> > > On Mon, 19 Aug 2019 15:40:57 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> > > > On Sun, Aug 18, 2019 at 01:35:46PM -0400, Vivien Didelot wrote:
> > > > > When disabling a port, that is not for the driver to decide what to
> > > > > do with the STP state. This is already handled by the DSA layer.
> > > > 
> > > > Putting the port into STP disabled state is how you actually disable
> > > > it, for the mv88e6xxx. So this is not really about STP, it is about
> > > > powering off the port. Maybe a comment is needed, rather than removing
> > > > the code?
> > > 
> > > This is not for the driver to decide, the stack already handles that.
> > > Otherwise, calling dsa_port_disable on a bridged port would result in
> > > mv88e6xxx forcing the STP state to Disabled while this is not expected.
> 
> [...]
> 
> > Are you saying the core already sets the STP to disabled, for ports
> > which are unused? I did not spot that in your previous patch?
> 
> Just look at dsa_port_disable Andrew:
> 
> 
>     void dsa_port_disable(struct dsa_port *dp)
>     {
>     	struct dsa_switch *ds = dp->ds;
>     	int port = dp->index;
>     
>     	if (!dp->bridge_dev)
>     		dsa_port_set_state_now(dp, BR_STATE_DISABLED);
>     
>     	if (ds->ops->port_disable)
>     		ds->ops->port_disable(ds, port);
>     }
> 

Ah, cool. I completely missed that.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
