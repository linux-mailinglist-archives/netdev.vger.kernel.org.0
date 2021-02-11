Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318C9318B37
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhBKMxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhBKMuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:50:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D03BC061574;
        Thu, 11 Feb 2021 04:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wJY1AXNICyiAjWTjHLSdsRyJ5X0w0R4RDqdbhpckHx0=; b=i3rK+jSbve+mC02hmuXLyDrLf
        YkGNpr/rDfUheRqzahx7PxA8y3HUcCrEn7MMA1zfaKbpYPLFEZP6PmTANTk3fUOFxxDCKIFG3R9aG
        oXTxEC1yYVr2zMO6AtGtMlLNIPdwrzSbkFbpE4mnK+pbr0af11+XND9Y6l+3yzPI7wbyN2avB0jDx
        /UvdPxJYv255B0mA140QTjK3uuvDclOxgc/mhbdhlY2kgWm9MuMB3MsJ3J9tubH9vVTABCL+mDEkq
        kpnK9LWeXchtpr0YvjOBPEBS2fVUQtsGB4EfMioP0LFWGMBeJ8IAnVuHnplHnIzlGu+Z+6RiMEAEU
        YvYVymw7g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42030)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lABQA-0006A2-RN; Thu, 11 Feb 2021 12:50:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lABQA-00066M-0o; Thu, 11 Feb 2021 12:50:10 +0000
Date:   Thu, 11 Feb 2021 12:50:09 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 net-next 08/15] net: mvpp2: add FCA RXQ non occupied
 descriptor threshold
Message-ID: <20210211125009.GF1463@shell.armlinux.org.uk>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-9-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613040542-16500-9-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 12:48:55PM +0200, stefanc@marvell.com wrote:
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 761f745..8b4073c 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -1133,14 +1133,19 @@ static inline void mvpp2_qvec_interrupt_disable(struct mvpp2_queue_vector *qvec)
>  static void mvpp2_interrupts_mask(void *arg)
>  {
>  	struct mvpp2_port *port = arg;
> +	int cpu = smp_processor_id();
> +	u32 thread;
>  
>  	/* If the thread isn't used, don't do anything */
> -	if (smp_processor_id() > port->priv->nthreads)
> +	if (cpu > port->priv->nthreads)
>  		return;

What happened to a patch fixing this? Did I miss it? Was it submitted
independently to the net tree?

> @@ -1150,20 +1155,25 @@ static void mvpp2_interrupts_mask(void *arg)
>  static void mvpp2_interrupts_unmask(void *arg)
>  {
>  	struct mvpp2_port *port = arg;
> -	u32 val;
> +	int cpu = smp_processor_id();
> +	u32 val, thread;
>  
>  	/* If the thread isn't used, don't do anything */
> -	if (smp_processor_id() > port->priv->nthreads)
> +	if (cpu > port->priv->nthreads)
>  		return;

Ditto.

I don't think these need to be fixed in the net tree, but it would still
be nice to fix the problem. Please do so, as an initial patch in your
series - so we can then backport if it turns out to eventually be
necessary.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
