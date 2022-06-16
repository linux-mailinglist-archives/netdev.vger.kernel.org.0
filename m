Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9655554E61F
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 17:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377938AbiFPPbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 11:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377939AbiFPPbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 11:31:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4A64161E
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 08:31:06 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o1rSU-0003NM-3h; Thu, 16 Jun 2022 17:30:58 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o1rST-00069W-IS; Thu, 16 Jun 2022 17:30:57 +0200
Date:   Thu, 16 Jun 2022 17:30:57 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: dsa: ar9331: fix potential dead
 lock on mdio access
Message-ID: <20220616153057.GB28995@pengutronix.de>
References: <20220616112550.877118-1-o.rempel@pengutronix.de>
 <YqsxWv79Ge1AFiQx@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YqsxWv79Ge1AFiQx@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 03:34:18PM +0200, Andrew Lunn wrote:
> >  static int ar9331_mdio_read(void *ctx, const void *reg_buf, size_t reg_len,
> > @@ -849,6 +849,8 @@ static int ar9331_mdio_read(void *ctx, const void *reg_buf, size_t reg_len,
> >  		return 0;
> >  	}
> >  
> > +	mutex_lock_nested(&sbus->mdio_lock, MDIO_MUTEX_NESTED);
> > +
> 
> Do you know about mdiobus_read_nested() and
> mdiobus_write_nested(). The mv88e6xxx driver uses these.

Yes.

I need at least 2 master MDIO accesses to implement 1 slave mdio access.
So I decided to get lock one time for all needed accesses instead of
taking it multiple times.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
