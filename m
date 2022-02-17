Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96B74B9FD8
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 13:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240309AbiBQMMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 07:12:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239451AbiBQMMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 07:12:53 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9CF1FA55;
        Thu, 17 Feb 2022 04:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1KoWgBTUlo4nDLAUw7bf+UHEGG4Wj8YcA8JBHAxpzdA=; b=vU16ZIZEOKIv+Zy5HMk99Fl4NW
        m+Tihn9pusbecPWEJNsvCw0qXEMoe4znQwja8zPLQkV35QkKql5Jb0kW+jVXuGLDMH+Ga6LGxTVtk
        mOxEeJbyg3yAAZxIuCfntdxO7ZPWb/f4yYfiOiPQ9AOgimfSYYXtnE0En4rmJzjUBxJQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nKfdz-006ML2-GY; Thu, 17 Feb 2022 13:12:19 +0100
Date:   Thu, 17 Feb 2022 13:12:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: dsa: realtek: fix PHY register read
 corruption
Message-ID: <Yg47o5619InYrs9x@lunn.ch>
References: <20220216160500.2341255-1-alvin@pqrs.dk>
 <CAJq09z6Mr7QFSyqWuM1jjm9Dis4Pa2A4yi=NJv1w4FM0WoyqtA@mail.gmail.com>
 <87k0dusmar.fsf@bang-olufsen.dk>
 <Yg1MfpK5PwiAbGfU@lunn.ch>
 <878ruasjd8.fsf@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878ruasjd8.fsf@bang-olufsen.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thank you Andrew for the clear explanation.
> 
> Somewhat unrelated to this series, but are you able to explain to me the
> difference between:
> 
> 	mutex_lock(&bus->mdio_lock);
> and
> 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> 
> While looking at other driver examples I noticed the latter form quite a
> few times too.

This is to do with the debug code for checking for deadlocks,
CONFIG_PROVE_LOCKING. When that feature is enables, each lock/unlock
of a mutex is tracked, and a list is made of what other locks are also
taken, and the order. The code can find deadlocks where one thread
takes A then B, while another thread takes B and then A. It can also
detect when a thread takes lock A and then tries to take lock A again.

Rather than track each individual mutex, it uses classes of mutex. So
bus->mdio_lock is a class of mutex. The code simply tracks that a
bus->mdio_lock has been taken, not a specific bus->mdio_lock. That is
generally sufficient, but not always. The mv88e6xxx switch is like
many switches, accessed over MDIO. But the mv88e6xxx switch offers an
MDIO bus, and there is an MDIO bus driver inside the mv88e6xxx
driver. So you have nested MDIO calls. So this debug code seems the
same class of mutex being taken twice, and thinks it is a
deadlock. You can tell it that nested MDIO calls are actually O.K, it
won't deadlock.

      Andrew
