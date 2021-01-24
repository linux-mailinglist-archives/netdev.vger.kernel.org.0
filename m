Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9884B301BF9
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 14:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbhAXNC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 08:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbhAXNCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 08:02:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE132C061574;
        Sun, 24 Jan 2021 05:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LkH5qtRnU0iy5lt0nigH+EyN1YwVx2DVm3xBix/OpoA=; b=VdjAm8cQVlU77Br2sk+F9PfK3
        dx2cWRsl7YGTNYCCmZ/ZbdjhoE2celGZs/xXI/1NdevLLJbS8Tp/3TTPo+MWOA1jsgQCI1S2Ta55D
        LS+oszUcQztYM5KnYR813N+FN0Ocypg6DsnnjOpnDgqP624ySLM9fP2rQTGaGFc4kRikRWXMmr/Zj
        4JG9G34weZI7HZ/VPrCEU06QyJRtFsMurR0OoMFSJUBd4BdBqVcvEw1PkRxPZH0c4aglbyOk07kzF
        cKGYZ5DFi1PQmnz7i3EIto6VoGWRJZa4U6hzvLNEJjUpEfqoD9NM3sFQ09Dr6L76SeUMuJH8FRvf6
        l8XA5it9A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52126)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l3f1Q-0002Om-Mi; Sun, 24 Jan 2021 13:01:41 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l3f1M-0001jN-AC; Sun, 24 Jan 2021 13:01:37 +0000
Date:   Sun, 24 Jan 2021 13:01:36 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org
Subject: Re: [PATCH v2 RFC net-next 09/18] net: mvpp2: add FCA RXQ non
 occupied descriptor threshold
Message-ID: <20210124130134.GY1551@shell.armlinux.org.uk>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-10-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611488647-12478-10-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 01:43:58PM +0200, stefanc@marvell.com wrote:
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 9d69752..0f5069f 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -1154,6 +1154,9 @@ static void mvpp2_interrupts_mask(void *arg)
>  	mvpp2_thread_write(port->priv,
>  			   mvpp2_cpu_to_thread(port->priv, smp_processor_id()),
>  			   MVPP2_ISR_RX_TX_MASK_REG(port->id), 0);
> +	mvpp2_thread_write(port->priv,
> +			   mvpp2_cpu_to_thread(port->priv, smp_processor_id()),
> +			   MVPP2_ISR_RX_ERR_CAUSE_REG(port->id), 0);

I wonder if this should be refactored:

	u32 thread = mvpp2_cpu_to_thread(port->priv, smp_processor_id());

	mvpp2_thread_write(port->priv, thread,
			   MVPP2_ISR_RX_TX_MASK_REG(port->id), 0);
	mvpp2_thread_write(port->priv, thread,
			   MVPP2_ISR_RX_ERR_CAUSE_REG(port->id), 0);

to avoid having to recompute mvpp2_cpu_to_thread() for each write?

However, looking deeper...

static void mvpp2_interrupts_mask(void *arg)
{
	struct mvpp2_port *port = arg;
	u32 thread;
	int cpu;

	cpu = smp_processor_id();
	if (cpu > port->priv->nthreads)
		return

	thread = mvpp2_cpu_to_thread(port->priv, cpu);
	...

and I wonder about that condition - "cpu > port->priv->nthreads". If
cpu == port->priv->nthreads, then mvpp2_cpu_to_thread() will return
zero, just like the cpu=0 case. This leads me to suspect that this
comparison off by one.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
