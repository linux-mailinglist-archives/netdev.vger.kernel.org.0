Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2697F4E7E84
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 03:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiCZCTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 22:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCZCTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 22:19:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73ED32645;
        Fri, 25 Mar 2022 19:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VVmNfLvytWC951S/CtUzoyGXxk5OGkxlr9n9Bf7nR3w=; b=N6SqGZ1XcSlQGe38Kc13cyzli4
        B7INNI1gSE4ASEyyowTzT75QEWAsysDH5KSH3culOmIRXntvcNvapOOsPw/yhbk4iQCEZdDu0CjZp
        cOJF3edhTOOH4dFS1EVv+jhbMadJkTPfg6rFrt1Qk8HtIz/kmLMD2fF+NxWWAnBlY8/g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nXvzS-00Cilr-BM; Sat, 26 Mar 2022 03:17:18 +0100
Date:   Sat, 26 Mar 2022 03:17:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: lan966x: fix kernel oops on ioctl when I/F is
 down
Message-ID: <Yj53rrvg4+DN68W4@lunn.ch>
References: <20220326000251.2687897-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220326000251.2687897-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 01:02:51AM +0100, Michael Walle wrote:
> A SIOCGMIIPHY ioctl will cause a kernel oops when the interface is down.
> Fix it by checking the state and if it's no running, return an error.

s/no/not/

I don't think it is just SIOCGMIIPHY. phy_has_hwtstamp(dev->phydev) is
probably also an issue. The phy is connected in open, and disconnected
in stop. So dev->phydev is not valid outside of that time.

But i'm also not sure it is guaranteed to be valid while the interface
is up. The driver uses phylink, so there could be an SFP attached to a
port, in which case, dev->phydev will not be set.

So rather than testing of running, it would be better to test if the
phydev is NULL or not.

       Andrew

> 
> Fixes: 735fec995b21 ("net: lan966x: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP")
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> index ec42e526f6fb..0adf49d19142 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -399,6 +399,9 @@ static int lan966x_port_ioctl(struct net_device *dev, struct ifreq *ifr,
>  {
>  	struct lan966x_port *port = netdev_priv(dev);
>  
> +	if (!netif_running(dev))
> +		return -EINVAL;
> +
>  	if (!phy_has_hwtstamp(dev->phydev) && port->lan966x->ptp) {
>  		switch (cmd) {
>  		case SIOCSHWTSTAMP:
> -- 
> 2.30.2
> 
