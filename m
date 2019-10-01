Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C100C3C78
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732993AbfJAQnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:43:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56406 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732946AbfJAQno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QuwwxLI9kehPovTMnhH9tA/I5Dk8xgDmaCwWA+JgdKs=; b=jRiBOJ+rTkEwl7VFrxVg659ca8
        wE80UkiiCyYsOLCNrwJ8A5H//VMB9zBAb5HNTBZlx7/caNEggddhy4ECPA79qLoIGa/5ANSlgzWbo
        Dn2PDpgELnhdQv1XA2Q33QkzPnsLRMMaa/QjEPiG5pb2NNYCCwJPJ3WRndmIOvHreI7Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iFLFU-0001Zn-3t; Tue, 01 Oct 2019 18:43:40 +0200
Date:   Tue, 1 Oct 2019 18:43:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     o.rempel@pengutronix.de, jcliburn@gmail.com, chris.snook@gmail.com,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: ag71xx: fix mdio subnode support
Message-ID: <20191001164340.GC2031@lunn.ch>
References: <20191001064147.23633-1-o.rempel@pengutronix.de>
 <20191001.090320.1192378852987776883.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001.090320.1192378852987776883.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 01, 2019 at 09:03:20AM -0700, David Miller wrote:
> From: Oleksij Rempel <o.rempel@pengutronix.de>
> Date: Tue,  1 Oct 2019 08:41:47 +0200
> 
> > @@ -571,7 +571,9 @@ static int ag71xx_mdio_probe(struct ag71xx *ag)
> >  		msleep(200);
> >  	}
> >  
> > -	err = of_mdiobus_register(mii_bus, np);
> > +	mnp = of_get_child_by_name(np, "mdio");
> > +	err = of_mdiobus_register(mii_bus, mnp);
> 
> of_get_child_by_name() can fail, so error checking is necessary
> before you pass mnp into of_mdiobus_register().

Hi David

/**
 *	of_get_child_by_name - Find the child node by name for a given parent
 *	@node:	parent node
 *	@name:	child name to look for.
 *
 *      This function looks for child node for given matching name
 *
 *	Returns a node pointer if found, with refcount incremented, use
 *	of_node_put() on it when done.
 *	Returns NULL if node is not found.
 */

So on error, it returns NULL. And passing NULL to
of_mdiobus_register() is the correct thing to do if there is no DT
node. of_node_put() is also O.K. with NULL.

So this is all O.K. as is.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
