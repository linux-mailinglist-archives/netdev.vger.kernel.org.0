Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7984B629AA8
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 14:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238204AbiKONhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 08:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238496AbiKONhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 08:37:13 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9E019F;
        Tue, 15 Nov 2022 05:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=S7WV79hoVcmGUSCfQ45AubkiXYKAS8NdE60SffWuwcM=; b=2/wlW3CUNxG4hLPOez+leitI19
        4RUo9sgg+gXqjETQhYuU8i3GcdGxNgPAYzvHGjy7hEyWcaM9uqi/LpyDEv83PKCb4ZY1KSUVL86mm
        9v+iKE1+Kc75wkrERVWl0a1dHV/YR5CS4N69q8C9avHRcesMaOKogePbeCREfdMpmZ8Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ouw78-002Sn2-2D; Tue, 15 Nov 2022 14:36:34 +0100
Date:   Tue, 15 Nov 2022 14:36:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        mw@semihalf.com, linux@armlinux.org.uk, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yusongping@huawei.com
Subject: Re: [PATCH] net: mdio-ipq4019: fix possible invalid pointer
 dereference
Message-ID: <Y3OV4og418SxPF7+@lunn.ch>
References: <20221115045028.182441-1-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115045028.182441-1-tanghui20@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 12:50:28PM +0800, Hui Tang wrote:
> priv->eth_ldo_rdy is saved the return value of devm_ioremap_resource(),
> which !IS_ERR() should be used to check.
> 
> Fixes: 23a890d493e3 ("net: mdio: Add the reset function for IPQ MDIO driver")
> Signed-off-by: Hui Tang <tanghui20@huawei.com>
> ---
>  drivers/net/mdio/mdio-ipq4019.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
> index 4eba5a91075c..d7a1f7c56f97 100644
> --- a/drivers/net/mdio/mdio-ipq4019.c
> +++ b/drivers/net/mdio/mdio-ipq4019.c
> @@ -188,7 +188,7 @@ static int ipq_mdio_reset(struct mii_bus *bus)
>  	/* To indicate CMN_PLL that ethernet_ldo has been ready if platform resource 1
>  	 * is specified in the device tree.
>  	 */
> -	if (priv->eth_ldo_rdy) {
> +	if (!IS_ERR(priv->eth_ldo_rdy)) {
>  		val = readl(priv->eth_ldo_rdy);
>  		val |= BIT(0);
>  		writel(val, priv->eth_ldo_rdy);

There is a general pattern in the kernel that optional things are set
to NULL if the resource does not exist. Often there is a
get_foo_optional() which will return a NULL point if the things does
not exist, the thing if it does exist, or an error code if a real
error happened.

So please follow this patterns. Check the return value in
ipq4019_mdio_probe(). Looking at __devm_ioremap_resource() i _think_
it returns -ENOMEM if the resource does not exist? So maybe any other
error is a real error, and should be reported, and -ENOMEM should
result in eth_ldo_rdy set to NULL?

       Andrew
