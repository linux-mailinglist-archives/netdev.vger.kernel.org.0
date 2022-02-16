Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184964B9103
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237994AbiBPTMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:12:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237894AbiBPTMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:12:22 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87B72B261;
        Wed, 16 Feb 2022 11:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=y13SwYgPMWjW5s5tMs0L28fhHBRBkvCDSKVz5OvZIdA=; b=KHuJPkcvhkjBKYurHM60mrW7h4
        X4MhLdNmfxhkT1RuUFSuveKlSTWuEp87Hq78reNsp4o6gyoOzfxHlGp2mA/ja1QipvrQKjGRZszsJ
        vFDDE7zMm0MuQPjOHtVeon8UgtYTiiCCdCzVOkDtr/cm7FJsj4yF5itDhf396FtO7qe4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nKPiY-006FnC-3I; Wed, 16 Feb 2022 20:11:58 +0100
Date:   Wed, 16 Feb 2022 20:11:58 +0100
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
Message-ID: <Yg1MfpK5PwiAbGfU@lunn.ch>
References: <20220216160500.2341255-1-alvin@pqrs.dk>
 <CAJq09z6Mr7QFSyqWuM1jjm9Dis4Pa2A4yi=NJv1w4FM0WoyqtA@mail.gmail.com>
 <87k0dusmar.fsf@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0dusmar.fsf@bang-olufsen.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hmm OK. Actually I'm a bit confused about the mdio_lock: can you explain
> what it's guarding against, for someone unfamiliar with MDIO?

The more normal use case for MDIO is for PHYs, not switches. There can
be multiple PHYs on one MDIO bus. And these PHYs each have there own
state machine in phylib. At any point in time, that state machine can
request the driver to do something, like poll the PHY status, does it
have link? To prevent two PHY drivers trying to use the MDIO bus at
the same time, there is an MDIO lock. At the beginning of an MDIO
transaction, the lock is taken. And the end of the transaction,
reading or writing one register of a device on the bus, the lock is
released.

So the MDIO lock simply ensures there is only one user of the MDIO bus
at one time, for a single read or write.

For PHYs this is sufficient. For switches, sometimes you need
additional protection. The granularity of an access might not be a
single register read or a write. It could be you need to read or write
a few registers in an atomic way. If that is the case, you need a lock
at a higher level.

   Andrew
