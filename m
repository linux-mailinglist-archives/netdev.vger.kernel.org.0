Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFC2225530
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 03:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgGTBKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 21:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgGTBKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 21:10:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1854C0619D2;
        Sun, 19 Jul 2020 18:10:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B9861284827B;
        Sun, 19 Jul 2020 18:10:13 -0700 (PDT)
Date:   Sun, 19 Jul 2020 18:10:12 -0700 (PDT)
Message-Id: <20200719.181012.2032747244788963553.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        martin.p.rowe@gmail.com, devicetree@vger.kernel.org,
        gregory.clement@bootlin.com, kuba@kernel.org, jason@lakedaemon.net,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        robh+dt@kernel.org, sebastian.hesselbarth@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: fix in-band AN link
 establishment
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1jx73b-0006mh-Ox@rmk-PC.armlinux.org.uk>
References: <E1jx73b-0006mh-Ox@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jul 2020 18:10:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Sun, 19 Jul 2020 12:00:35 +0100

> If in-band negotiation or fixed-link modes are specified for a DSA
> port, the DSA code will force the link down during initialisation. For
> fixed-link mode, this is fine, as phylink will manage the link state.
> However, for in-band mode, phylink expects the PCS to detect link,
> which will not happen if the link is forced down.
> 
> There is a related issue that in in-band mode, the link could come up
> while we are making configuration changes, so we should force the link
> down prior to reconfiguring the interface mode.
> 
> This patch addresses both issues.
> 
> Fixes: 3be98b2d5fbc ("net: dsa: Down cpu/dsa ports phylink will control")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied and queued up for -stable,  but:

> @@ -664,6 +664,7 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
>  				 const struct phylink_link_state *state)
>  {
>  	struct mv88e6xxx_chip *chip = ds->priv;
> +	struct mv88e6xxx_port *p = &chip->ports[port];
>  	int err;

I fixed the reverse christmas tree breakage here by moving the 'p'
assignment into the function body.
