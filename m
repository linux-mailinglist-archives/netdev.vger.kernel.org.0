Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93CF6CBF09
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 14:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjC1Mat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 08:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC1Mat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 08:30:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EA186BE;
        Tue, 28 Mar 2023 05:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=p1vueGhlFqaDJRo3Ow4NaqQoeuYHMXia7i1M7wo4oX0=; b=IWf53GWYdLA9Up9WtqneknvJxX
        ztNLrBxlFPW0QeMFs36BDZewTV3YGh98GPqTbyplhKj3H7gS9BFnkTn44mJAlJBWfZNCpWXDkZ/IZ
        5eyAwBA1jNo3833RCoi+FCliKJ/9copbULIfNCKPGbjJEQBopCeYwlMn+yO+TXpkAt6g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ph8TF-008dwt-UM; Tue, 28 Mar 2023 14:30:37 +0200
Date:   Tue, 28 Mar 2023 14:30:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Gustav Ekelund <gustav.ekelund@axis.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@axis.com,
        Gustav Ekelund <gustaek@axis.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Reset mv88e6393x watchdog
 register
Message-ID: <9ba1722a-8dd7-4d6d-bade-b4c702c8387f@lunn.ch>
References: <20230328115511.400145-1-gustav.ekelund@axis.com>
 <20230328120604.zawfeskqs4yhlze6@kandell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328120604.zawfeskqs4yhlze6@kandell>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int mv88e6393x_watchdog_action(struct mv88e6xxx_chip *chip, int irq)
> > +{
> > +	mv88e6390_watchdog_action(chip, irq);
> > +
> > +	mv88e6xxx_g2_write(chip, MV88E6390_G2_WDOG_CTL,
> > +			   MV88E6390_G2_WDOG_CTL_UPDATE |
> > +			   MV88E6390_G2_WDOG_CTL_PTR_EVENT);
> > +
> > +	return IRQ_HANDLED;
> > +}
> 
> Shouldn't this update be in .irq_setup() method? In the commit message
> you're saying that the problem is that bits aren't cleared with SW
> reset. So I would guess that the change should be in the setup of
> watchdog IRQ, not in IRQ action?

I think it is a bit more complex than that. At least for the 6352,
which i just looked at the data sheet, the interrupt bits are listed
as "ROC". Which is missing from the list of definitions, but seems to
mean Read Only, Clear on read. So even if it was not cleared on
software reset, it would only fire once, and then be cleared.

The problem description here is that it does not clear on read, it
needs an explicit write. Which suggests Marvell changed it for the
6393.

So i have a couple of questions:

1) Is this new behaviour limited to the 6393, or does the 6390 also
need this write?

2) What about other interrupts? Is this the only one which has changed
behaviour?

	Andrew
