Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2914CBFEC
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbiCCOXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiCCOXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:23:35 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC89E42495;
        Thu,  3 Mar 2022 06:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FE1RUnKIPLpvyuGyxirLfG2pGSchVmNj3iusKNQ3aGU=; b=Fd7fOJEaWMx/H86NWQQ5FYFOeN
        bODq4psjtEEX5C+99j+mV5l69Jka9QTloP+9HnKi2/CJQraDAe/e4szbZu8SVNlzHdni4j9tlm/rS
        1pk1Jj3NQgeZ722iBodH/RXlMCFkPXeHhrBhnytALGRka98dHw8ecnOVlaNZ4J91aoUc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nPmLr-00968N-Jy; Thu, 03 Mar 2022 15:22:43 +0100
Date:   Thu, 3 Mar 2022 15:22:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] net: ethernet: sun: Remove redundant code
Message-ID: <YiDPM7JhGLX73wHk@lunn.ch>
References: <20220303091440.71416-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303091440.71416-1-jiapeng.chong@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 03, 2022 at 05:14:40PM +0800, Jiapeng Chong wrote:
> Because CAS_FLAG_REG_PLUS is assigned a value of 1, it never enters
> these for loops.

Please can you expand this comment, it is not clear to my what you
mean here. When i look at:

/* check pci invariants */
static void cas_check_pci_invariants(struct cas *cp)
{
        struct pci_dev *pdev = cp->pdev;

        cp->cas_flags = 0;
        if ((pdev->vendor == PCI_VENDOR_ID_SUN) &&
            (pdev->device == PCI_DEVICE_ID_SUN_CASSINI)) {
                if (pdev->revision >= CAS_ID_REVPLUS)
                        cp->cas_flags |= CAS_FLAG_REG_PLUS;

it is not obvious why it could not enter these loops.

   Andrew

> 
> Clean up the following smatch warning:
> 
> drivers/net/ethernet/sun/cassini.c:3513 cas_start_dma() warn: we never
> enter this loop.
> 
> drivers/net/ethernet/sun/cassini.c:1239 cas_init_rx_dma() warn: we never
> enter this loop.
> 
> drivers/net/ethernet/sun/cassini.c:1247 cas_init_rx_dma() warn: we never
> enter this loop.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/ethernet/sun/cassini.c | 16 ----------------
>  1 file changed, 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
> index 947a76a788c7..153edc5eadad 100644
> --- a/drivers/net/ethernet/sun/cassini.c
> +++ b/drivers/net/ethernet/sun/cassini.c
> @@ -1235,19 +1235,6 @@ static void cas_init_rx_dma(struct cas *cp)
>  	 */
>  	readl(cp->regs + REG_INTR_STATUS_ALIAS);
>  	writel(INTR_RX_DONE | INTR_RX_BUF_UNAVAIL, cp->regs + REG_ALIAS_CLEAR);
> -	if (cp->cas_flags & CAS_FLAG_REG_PLUS) {
> -		for (i = 1; i < N_RX_COMP_RINGS; i++)
> -			readl(cp->regs + REG_PLUS_INTRN_STATUS_ALIAS(i));
> -
> -		/* 2 is different from 3 and 4 */
> -		if (N_RX_COMP_RINGS > 1)
> -			writel(INTR_RX_DONE_ALT | INTR_RX_BUF_UNAVAIL_1,
> -			       cp->regs + REG_PLUS_ALIASN_CLEAR(1));
> -
> -		for (i = 2; i < N_RX_COMP_RINGS; i++)
> -			writel(INTR_RX_DONE_ALT,
> -			       cp->regs + REG_PLUS_ALIASN_CLEAR(i));
> -	}
>  
>  	/* set up pause thresholds */
>  	val  = CAS_BASE(RX_PAUSE_THRESH_OFF,
> @@ -3509,9 +3496,6 @@ static inline void cas_start_dma(struct cas *cp)
>  		if (N_RX_DESC_RINGS > 1)
>  			writel(RX_DESC_RINGN_SIZE(1) - 4,
>  			       cp->regs + REG_PLUS_RX_KICK1);
> -
> -		for (i = 1; i < N_RX_COMP_RINGS; i++)
> -			writel(0, cp->regs + REG_PLUS_RX_COMPN_TAIL(i));
>  	}
>  }
>  
> -- 
> 2.20.1.7.g153144c
> 
