Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F464C3E90
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbfJAR15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:27:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50468 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730447AbfJAR14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 13:27:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A388154F3255;
        Tue,  1 Oct 2019 10:27:56 -0700 (PDT)
Date:   Tue, 01 Oct 2019 10:27:55 -0700 (PDT)
Message-Id: <20191001.102755.1421638394065642330.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     o.rempel@pengutronix.de, jcliburn@gmail.com, chris.snook@gmail.com,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: ag71xx: fix mdio subnode support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001164340.GC2031@lunn.ch>
References: <20191001064147.23633-1-o.rempel@pengutronix.de>
        <20191001.090320.1192378852987776883.davem@davemloft.net>
        <20191001164340.GC2031@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 10:27:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Tue, 1 Oct 2019 18:43:40 +0200

> On Tue, Oct 01, 2019 at 09:03:20AM -0700, David Miller wrote:
>> From: Oleksij Rempel <o.rempel@pengutronix.de>
>> Date: Tue,  1 Oct 2019 08:41:47 +0200
>> 
>> > @@ -571,7 +571,9 @@ static int ag71xx_mdio_probe(struct ag71xx *ag)
>> >  		msleep(200);
>> >  	}
>> >  
>> > -	err = of_mdiobus_register(mii_bus, np);
>> > +	mnp = of_get_child_by_name(np, "mdio");
>> > +	err = of_mdiobus_register(mii_bus, mnp);
>> 
>> of_get_child_by_name() can fail, so error checking is necessary
>> before you pass mnp into of_mdiobus_register().
> 
> Hi David
> 
> /**
>  *	of_get_child_by_name - Find the child node by name for a given parent
>  *	@node:	parent node
>  *	@name:	child name to look for.
>  *
>  *      This function looks for child node for given matching name
>  *
>  *	Returns a node pointer if found, with refcount incremented, use
>  *	of_node_put() on it when done.
>  *	Returns NULL if node is not found.
>  */
> 
> So on error, it returns NULL. And passing NULL to
> of_mdiobus_register() is the correct thing to do if there is no DT
> node. of_node_put() is also O.K. with NULL.
> 
> So this is all O.K. as is.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Aha I didn't think about it that way...

Ok I'll apply this thanks.
