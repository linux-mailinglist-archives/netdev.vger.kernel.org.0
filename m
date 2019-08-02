Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3BB07FC77
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 16:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395015AbfHBOn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 10:43:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57114 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726505AbfHBOnz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 10:43:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hGTlHtw/TXgZ7A0PovMPVeamEepP/U8j6B3/Q6ReRKQ=; b=j+XmBdJQqiTCyID7EZxc7wucw1
        SMZgC1PBXxKpicnLwCneyVMXQ4Cx5Amk0MYmc/4whSjUqehBNa3P77EZMRyvATIXxvcDyu56SZpHj
        qdgU33OL2ivNIqb/1BGKMevgTigVUA5M9r+k0/a0NAeGQ1rGfw0QtIjhE6RO/eUd9djM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1htYmf-0001CJ-Gy; Fri, 02 Aug 2019 16:43:53 +0200
Date:   Fri, 2 Aug 2019 16:43:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnaud Patard <arnaud.patard@rtp-net.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [patch 1/1] drivers/net/ethernet/marvell/mvmdio.c: Fix non OF
 case
Message-ID: <20190802144353.GG2099@lunn.ch>
References: <20190802083310.772136040@rtp-net.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802083310.772136040@rtp-net.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 10:32:40AM +0200, Arnaud Patard wrote:
> Orion5.x systems are still using machine files and not device-tree.
> Commit 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be
> specified for orion-mdio") has replaced devm_clk_get() with of_clk_get(),
> leading to a oops at boot and not working network, as reported in 
> https://lists.debian.org/debian-arm/2019/07/msg00088.html and possibly in
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=908712.
> 
> Link: https://lists.debian.org/debian-arm/2019/07/msg00088.html
> Fixes: 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be specified for orion-mdio")
> Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
> Index: linux-next/drivers/net/ethernet/marvell/mvmdio.c
> ===================================================================
> --- linux-next.orig/drivers/net/ethernet/marvell/mvmdio.c
> +++ linux-next/drivers/net/ethernet/marvell/mvmdio.c
> @@ -319,20 +319,33 @@ static int orion_mdio_probe(struct platf
>  
>  	init_waitqueue_head(&dev->smi_busy_wait);
>  
> -	for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
> -		dev->clk[i] = of_clk_get(pdev->dev.of_node, i);
> -		if (PTR_ERR(dev->clk[i]) == -EPROBE_DEFER) {
> +	if (pdev->dev.of_node) {
> +		for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
> +			dev->clk[i] = of_clk_get(pdev->dev.of_node, i);
> +			if (PTR_ERR(dev->clk[i]) == -EPROBE_DEFER) {
> +				ret = -EPROBE_DEFER;
> +				goto out_clk;
> +			}
> +			if (IS_ERR(dev->clk[i]))
> +				break;
> +			clk_prepare_enable(dev->clk[i]);
> +		}
> +
> +		if (!IS_ERR(of_clk_get(pdev->dev.of_node,
> +				       ARRAY_SIZE(dev->clk))))
> +			dev_warn(&pdev->dev,
> +				 "unsupported number of clocks, limiting to the first "
> +				 __stringify(ARRAY_SIZE(dev->clk)) "\n");
> +	} else {
> +		dev->clk[0] = clk_get(&pdev->dev, NULL);
> +		if (PTR_ERR(dev->clk[0]) == -EPROBE_DEFER) {
>  			ret = -EPROBE_DEFER;
>  			goto out_clk;
>  		}

Hi Arnaud

It is a long time since i looked at Orion5x. Is this else clause even
needed? If my memory is right, i don't think it needs to enable tclk?
It was kirkwood which first added gateable clocks. And all kirkwood
boards are not DT.

Thanks
	Andrew
