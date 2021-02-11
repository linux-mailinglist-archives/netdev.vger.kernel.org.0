Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E1F3190B9
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 18:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhBKRNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 12:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbhBKRLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 12:11:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747D4C061756;
        Thu, 11 Feb 2021 09:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=irdgAUDPC6ndr20WKDeC1q4I6/v6GDUvnSgOdeJh9D4=; b=jdUwWOJodfBwXv0+3Rz52g5FO
        MnSiUQkQ5Cy6ycg8xEd95RinsRu2EDIxWvczos/Z97BjGfhZUJpMxyCqhLmAj9bPnADlBfMzLF1k7
        OCdmZu7BoWmo5Ih2XLXwEac324RwvU8j6QAn51Pf9A2o5Gmgb5Ij6ebpv3QRRzFVvIfIH1lpem7SE
        dOTahEhSaTcuKcFDUm6eB+66HTiNFD3Rnp1BlYy9Wryy9uZP4lCKDToWIYzoEtyyx6wF4YLlWiGg/
        EXw2fpsaRa9tiAmxkfeX6sX+IbmFfTNvB64OP8KeuSadFtqgnrO2mxvSoS2sPYRKu9ZxpMqcoLO7C
        q/I7PQx2w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42116)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lAFUK-0006Qj-7B; Thu, 11 Feb 2021 17:10:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lAFUI-0006HO-2H; Thu, 11 Feb 2021 17:10:42 +0000
Date:   Thu, 11 Feb 2021 17:10:42 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org
Subject: Re: [net-next] net: mvpp2: fix interrupt mask/unmask skip condition
Message-ID: <20210211171041.GM1463@shell.armlinux.org.uk>
References: <1613056399-18730-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613056399-18730-1-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 05:13:19PM +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> The condition should be skipped if CPU ID equal to nthreads.
> The patch doesn't fix any actual issue since
> nthreads = min_t(unsigned int, num_present_cpus(), MVPP2_MAX_THREADS).
> On all current Armada platforms, the number of CPU's is
> less than MVPP2_MAX_THREADS.
> 
> Fixes: e531f76757eb ("net: mvpp2: handle cases where more CPUs are available than s/w threads")
> Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index a07cf60..74613d3 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -1135,7 +1135,7 @@ static void mvpp2_interrupts_mask(void *arg)
>  	struct mvpp2_port *port = arg;
>  
>  	/* If the thread isn't used, don't do anything */
> -	if (smp_processor_id() > port->priv->nthreads)
> +	if (smp_processor_id() >= port->priv->nthreads)
>  		return;
>  
>  	mvpp2_thread_write(port->priv,
> @@ -1153,7 +1153,7 @@ static void mvpp2_interrupts_unmask(void *arg)
>  	u32 val;
>  
>  	/* If the thread isn't used, don't do anything */
> -	if (smp_processor_id() > port->priv->nthreads)
> +	if (smp_processor_id() >= port->priv->nthreads)
>  		return;
>  
>  	val = MVPP2_CAUSE_MISC_SUM_MASK |
> -- 
> 1.9.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
