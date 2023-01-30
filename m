Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8DC68186D
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 19:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236848AbjA3SO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 13:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237025AbjA3SOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 13:14:48 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641F513D54;
        Mon, 30 Jan 2023 10:14:46 -0800 (PST)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 30EAF60006;
        Mon, 30 Jan 2023 18:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675102484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0L70D0T7QBqKP00Tgau2b2n6CiaOYgTN060BDBSnB5w=;
        b=VHOjrcmAKJDoMCDsy5vnesTU+moU9c4NOI9it7ZGRlIr12tMXrmtfEWY73rX7efjhxrmds
        fbS69hq7uRe1gVYNJoiuJ1gqNf5kYuZnqgY6TQwkabp2nktNCiqPuT8vI/QtPEihv/UM3L
        BB6MaGaUz4fmoVYRvu3sXmrQ0MFS4Y8tjB8aLXnoNq3z3CN49QMw2WR7IJqRmrChtKrEux
        XRbC9OEzjnAVZIvjCWOxUAg7mfywywlTBD5qilTOBaDwkl1ar94Fa6Iqo/InZtZvTdx9kb
        C75HlW0LX2wbVaNynKl1Z3GzwM2dbNtiJyz3BkbxYt2PsxkdaL0pQT7wJ8cYmw==
Date:   Mon, 30 Jan 2023 19:14:41 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next] net: pcs: pcs-lynx: remove
 lynx_get_mdio_device() and refactor cleanup
Message-ID: <20230130191441.7aa46ea9@pc-7.home>
In-Reply-To: <20230128015841.rotwc2arwgn2csef@skbuf>
References: <20230127134031.156143-1-maxime.chevallier@bootlin.com>
        <20230127134351.xlz4wqrubfnvmecd@skbuf>
        <20230127150758.68eb1d29@pc-7.home>
        <20230128015841.rotwc2arwgn2csef@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vlad,

On Sat, 28 Jan 2023 03:58:41 +0200
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Fri, Jan 27, 2023 at 03:07:58PM +0100, Maxime Chevallier wrote:
> > However this current patch still makes sense though right ?  
> 
> I have a pretty hard time saying yes; TL;DR yes it's less code, but
> it's structured that way with a reason.
> 
> I don't think it's lynx_pcs_destroy()'s responsibility to call
> mdio_device_free(), just like it isn't lynx_pcs_create()'s
> responsibility to call mdio_device_create() (or whatever). In fact
> that's the reason why the mdiodev isn't completely absorbed by the
> lynx_pcs - because there isn't a unified way to get a reference to it
> - some platforms have a hardcoded address, others have a phandle in
> the device tree.

I get you and I actually agree, I've been also thinking about that this
weekend and indeed it would create an asymetry that can easily lead to
leaky code.

Let's drop that patch then, thanks a lot for the thourough review and
comments, I appreciate it.

Best regards,

Maxime

> I know this is entirely subjective, but to me, having functions
> organized in pairs which undo precisely what the other has done, and
> not more, really helps with spotting resource leakage issues. I
> realize that it's not the same for everybody. For example, while
> reviewing your patch, I noticed this in the existing code:
> 
> static struct phylink_pcs *memac_pcs_create(struct device_node
> *mac_node, int index)
> {
> 	struct device_node *node;
> 	struct mdio_device *mdiodev = NULL;
> 	struct phylink_pcs *pcs;
> 
> 	node = of_parse_phandle(mac_node, "pcsphy-handle", index);
> 	if (node && of_device_is_available(node))
> 		mdiodev = of_mdio_find_device(node);
> 	of_node_put(node);
> 
> 	if (!mdiodev)
> 		return ERR_PTR(-EPROBE_DEFER);
> 
> 	pcs = lynx_pcs_create(mdiodev); // if this fails, we miss
> calling mdio_device_free() return pcs;
> }
> 
> and it's clear that what is obvious to me was not obvious to the
> author of commit a7c2a32e7f22 ("net: fman: memac: Use lynx pcs
> driver"), since this organization scheme didn't work for him.



