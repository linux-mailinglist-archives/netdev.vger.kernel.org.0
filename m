Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660BA4D859E
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 14:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240843AbiCNNFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 09:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbiCNNFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 09:05:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C03633D;
        Mon, 14 Mar 2022 06:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6vhEhsEgCajvQZjVFyDpV8W+AQtIQ/00nKngPjn30QY=; b=g45SSZBbdN8lLEZUmR6Qq6e8Su
        w0719+lTfMRmYYajKzDDaaARTqN5iYmjfIm+sl3PTUw/cEqpizcM8UGHapQR3DefziBMLuzPvKnK3
        nA87EyVpWFVAgbSYR9sSULExmVRrBE1Ma4dvIyXZlCJMqlLbLkoGkbkONvJPlc5mC7M4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nTkMv-00AkoG-MP; Mon, 14 Mar 2022 14:04:13 +0100
Date:   Mon, 14 Mar 2022 14:04:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     cgel.zte@gmail.com
Cc:     kuba@kernel.org, chi.minghao@zte.com.cn, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sebastian.hesselbarth@gmail.com, zealci@zte.com.cn
Subject: Re: [PATCH V3] net: mv643xx_eth: use platform_get_irq() instead of
 platform_get_resource()
Message-ID: <Yi89TfRTlM7OxYzb@lunn.ch>
References: <20220311082051.783b7c0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220314024144.2112308-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314024144.2112308-1-chi.minghao@zte.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> -	BUG_ON(!res);
> -	dev->irq = res->start;
> +	irq = platform_get_irq(pdev, 0);
> +	if (WARN_ON(irq < 0)) {
> +		if (!IS_ERR(mp->clk))
> +			clk_disable_unprepare(mp->clk);
> +		free_netdev(dev);
> +		return irq;
> +	}

Why not
		goto out;

?

And FYI: You can pass an error code to clk_disable_unprepare() and it
will not care and do the right thing. So if you were to keep this
code, which you should not, you don't need the if !IS_ERR(mp->clk))


      Andrew
