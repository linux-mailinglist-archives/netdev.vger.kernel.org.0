Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A650577E85
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 11:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiGRJUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 05:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbiGRJTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 05:19:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4764D64DE;
        Mon, 18 Jul 2022 02:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=g+aTLzc5WOjLByrM2aIBjE7jce/TtjRUMlCv6WTaasE=; b=FZU13y12dR3Vgw1hfnZzrtwg2F
        EaTspZRJJMBfg7ahQoT+uqQhdFMzARu3j0eunEwGF39D/BuvTRE0dxk4WFQ3OJn6gfNOOSk9aT3Gb
        +GknrDjVtkhYnXAA3H5kQotvoSa3cl6s6EmR8HfoK6xIxDa1y/0YXmvGkaNfb1A+VuZNxbpVgbRuh
        Z0dgfCitFIA2ZW3maldWMZQWXCDKLP6m3IXCH2SvPwLqP2USPg6U65cZrSQsgBtGv6PnUNMpE4kke
        vLQfR8ldIRKHp06tlrW9iZmqMhnDVzbhoaB99lRNF4UvGCJ1Amx4HGweQptOhCXk7ICuT2JvtMZ9h
        NRzKxgFw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33402)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oDMuf-0001Lw-6u; Mon, 18 Jul 2022 10:19:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oDMuX-0001r0-Ht; Mon, 18 Jul 2022 10:19:29 +0100
Date:   Mon, 18 Jul 2022 10:19:29 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v3 2/5] net: ethernet: stmicro: stmmac: first
 disable all queues in release
Message-ID: <YtUloYvDtTxX1MQA@shell.armlinux.org.uk>
References: <20220716230802.20788-1-ansuelsmth@gmail.com>
 <20220716230802.20788-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716230802.20788-3-ansuelsmth@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 01:07:59AM +0200, Christian Marangi wrote:
> Disable all queues before tx_disable in stmmac_release to prevent a
> corner case where packet may be still queued at the same time tx_disable
> is called resulting in kernel panic if some packet still has to be
> processed.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 5578abb14949..1854dcdd6095 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -3758,6 +3758,11 @@ static int stmmac_release(struct net_device *dev)
>  	struct stmmac_priv *priv = netdev_priv(dev);
>  	u32 chan;
>  
> +	stmmac_disable_all_queues(priv);
> +
> +	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
> +		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
> +
>  	netif_tx_disable(dev);

Is there a reason not to call phylink_stop() as the very first thing in
this function? That will bring the link (and therefore carrier) down
before phylink_stop() returns which should also prevent packets being
queued into the driver for transmission.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
