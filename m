Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6915A63C1
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 14:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiH3Mo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 08:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiH3Mo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 08:44:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C07A460;
        Tue, 30 Aug 2022 05:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=M7bxnRn0MHLNZePm0ON+15VulQtEk67FJoxG5y08NKc=; b=z2hPJ1CGLqAoiJSO0R/S4T248Q
        4ysQiCPJlVjuruSN38Xl6UZQukdn4mEi+iK8JiBlB/yaElT/aOnf6+2mbXr2zChsSeDBX8pniMBQO
        cZeefUxNMIUZhrj+fWxve7DeJzSiYp/QfLcYGl+byjSUWPm/hS+dDKHkT0OFNTXqE3pE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oT0bq-00F4Wb-W7; Tue, 30 Aug 2022 14:44:50 +0200
Date:   Tue, 30 Aug 2022 14:44:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: Re: [RFC Patch net-next v3 1/3] net: dsa: microchip: use
 dev_ops->reset instead of exit in ksz_switch_register
Message-ID: <Yw4GQgIMSCmF3UMC@lunn.ch>
References: <20220830105303.22067-1-arun.ramadoss@microchip.com>
 <20220830105303.22067-2-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830105303.22067-2-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 04:23:01PM +0530, Arun Ramadoss wrote:
> ksz8_switch_exit, ksz9477_switch_exit and lan937x_switch_exit functions
> all call the reset function which is assigned to dev_ops->reset hooks.
> So instead of calling the dev_ops->exit in ksz_switch_register during
> the error condition of dsa_register_switch, dev_ops->reset is used now.
> The dev_ops->exit can be extended in lan937x for freeing up the irq
> during the ksz_spi_remove. If we add the irq remove in the exit function
> and it is called during the dsa_switch_register error condition, kernel
> panic happens since irq is setup only in setup operation. To avoid the
> kernel panic, dev_ops->reset is used instead of exit.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 6bd69a7e6809..da9bdf753f7a 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -1963,7 +1963,7 @@ int ksz_switch_register(struct ksz_device *dev)
>  
>  	ret = dsa_register_switch(dev->ds);
>  	if (ret) {
> -		dev->dev_ops->exit(dev);
> +		dev->dev_ops->reset(dev);
>  		return ret;

I don't like this change. You are supposed to be undoing whatever
ksz_switch_register() has done so far. It appears to of called
ops->init() so far, so calling ops->exit() should be the opposite.

If you are making exit() not the opposite of init() in later patches,
it suggests your code structure is wrong. If exit() is not already the
opposite of init() then fix that.

   Andrew
