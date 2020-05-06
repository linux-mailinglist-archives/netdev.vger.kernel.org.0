Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279401C7B13
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgEFUSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgEFUSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 16:18:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 297D02075E;
        Wed,  6 May 2020 20:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588796325;
        bh=8Sej8aUk9IaZRIgP1lsxb1KUmZLb9ww84lQcyW/w7JA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=koDl/cfHbwUDaHEDXE9KShFTvX2BsBlgoa16I9Uk+ojauzDcpR4gP1c8k9R7aU360
         4VzN7manhmTrbJcwtgeUNHAnlq47ZK2mMIaRBW2vPAF4Hzqr+V1BTNn9TOWx/HQQMT
         mYG4LKhMXVfxpNDXU4ZVvuGbwq0qG/DhC5mVh98Q=
Date:   Wed, 6 May 2020 13:18:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <nicolas.ferre@microchip.com>
Cc:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>
Subject: Re: [PATCH v4 1/5] net: macb: fix wakeup test in runtime
 suspend/resume routines
Message-ID: <20200506131843.22cf1dab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <dc30ff1d17cb5a75ddd10966eab001f67ac744ef.1588763703.git.nicolas.ferre@microchip.com>
References: <cover.1588763703.git.nicolas.ferre@microchip.com>
        <dc30ff1d17cb5a75ddd10966eab001f67ac744ef.1588763703.git.nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 May 2020 13:37:37 +0200 nicolas.ferre@microchip.com wrote:
> From: Nicolas Ferre <nicolas.ferre@microchip.com>
> 
> Use the proper struct device pointer to check if the wakeup flag
> and wakeup source are positioned.
> Use the one passed by function call which is equivalent to
> &bp->dev->dev.parent.
> 
> It's preventing the trigger of a spurious interrupt in case the
> Wake-on-Lan feature is used.
> 
> Fixes: bc1109d04c39 ("net: macb: Add pm runtime support")

        Fixes tag: Fixes: bc1109d04c39 ("net: macb: Add pm runtime support")
        Has these problem(s):
                - Target SHA1 does not exist

> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
> Cc: Harini Katakam <harini.katakam@xilinx.com>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 36290a8e2a84..d11fae37d46b 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -4616,7 +4616,7 @@ static int __maybe_unused macb_runtime_suspend(struct device *dev)
>  	struct net_device *netdev = dev_get_drvdata(dev);
>  	struct macb *bp = netdev_priv(netdev);
>  
> -	if (!(device_may_wakeup(&bp->dev->dev))) {
> +	if (!(device_may_wakeup(dev))) {
>  		clk_disable_unprepare(bp->tx_clk);
>  		clk_disable_unprepare(bp->hclk);
>  		clk_disable_unprepare(bp->pclk);
> @@ -4632,7 +4632,7 @@ static int __maybe_unused macb_runtime_resume(struct device *dev)
>  	struct net_device *netdev = dev_get_drvdata(dev);
>  	struct macb *bp = netdev_priv(netdev);
>  
> -	if (!(device_may_wakeup(&bp->dev->dev))) {
> +	if (!(device_may_wakeup(dev))) {
>  		clk_prepare_enable(bp->pclk);
>  		clk_prepare_enable(bp->hclk);
>  		clk_prepare_enable(bp->tx_clk);

