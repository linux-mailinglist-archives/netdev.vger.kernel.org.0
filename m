Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16536699C4
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 15:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241836AbjAMOOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 09:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242036AbjAMONw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 09:13:52 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718521CB0F;
        Fri, 13 Jan 2023 06:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=tHeGtSvlWJlFggYowRpfbMojybMJOk2BXEnuJhsk0fI=; b=3s
        O1hliQjZRFEHblcq7Gvep0JYoGWuBJ+ijFxNK7O8MkIQuuClBbgCtId/OhMZj84w6w/1J9GNSJ0yd
        hrN/+nHk0sKXD6J8MhTnWA7Cb/ieJ7LMgcBl+6MQZNX9doQ0Anx1U4hYr6DzNhFGa5LUGQlJYRFqF
        rCDTilSqjycGuxo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pGKnQ-0020U3-CN; Fri, 13 Jan 2023 15:12:40 +0100
Date:   Fri, 13 Jan 2023 15:12:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>
Subject: Re: [PATCH net-next] net: dsa: rzn1-a5psw: Add vlan support
Message-ID: <Y8Fm2GdUF9R1asZs@lunn.ch>
References: <20230111115607.1146502-1-clement.leger@bootlin.com>
 <20230112213755.42f6cf75@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230112213755.42f6cf75@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 09:37:55PM -0800, Jakub Kicinski wrote:
> On Wed, 11 Jan 2023 12:56:07 +0100 Clément Léger wrote:
> > Add support for vlan operation (add, del, filtering) on the RZN1
> > driver. The a5psw switch supports up to 32 VLAN IDs with filtering,
> > tagged/untagged VLANs and PVID for each ports.
> 
> noob question - do you need that mutex? 
> aren't those ops all under rtnl_lock?

Hi Jakub

Not commenting about this specific patch, but not everything in DSA is
done under RTNL. So you need to deal with some parallel API calls. But
they tend to be in different areas. I would not expect to see two VLAN
changes as the same time, but maybe VLAN and polling in a workqueue to
update the statistics for example could happen. Depending on the
switch, some protect might be needed to stop these operations
interfering with each other. And DSA drivers in general tend to KISS
and over lock. Nothing here is particularly hot path, the switch
itself is on the end of a slow bus, so the overhead of locks are
minimum.

	Andrew
