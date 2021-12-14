Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6711474062
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 11:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhLNKYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 05:24:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54002 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230072AbhLNKYb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 05:24:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XnwQdUxy4IYvVDUW4035SZEoPZxIuIXqIkGFyZDLtmU=; b=XaOSANN3DBXUpdb/SNOC46yFhu
        ARmfxt3fAT07nk/7O440llDHZ8a9RMjwEO5BU+AhiGuAVp3wZPbAVgdaQ4AFYy88uUveW3VO21h8p
        pZI8UyKAbiptLgvLxn+PFof1k60ZguzaEtHr2WAvzep0MSqidT6zP3dS+rB2fEAgBSO8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mx4yu-00GUxe-IY; Tue, 14 Dec 2021 11:24:24 +0100
Date:   Tue, 14 Dec 2021 11:24:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH net-next] net: fec: fix system hang during suspend/resume
Message-ID: <Ybhw2JBqjRBOlyn1@lunn.ch>
References: <20211214025350.8985-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214025350.8985-1-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 10:53:50AM +0800, Joakim Zhang wrote:
> 1. During normal suspend (WoL not enabled) process, system has posibility
> to hang. The root cause is TXF interrupt coming after clocks disabled,
> system hang when accessing registers from interrupt handler. To fix this
> issue, disable all interrupts when system suspend.
> 
> 2. System also has posibility to hang with WoL enabled during suspend,
> after entering stop mode, then magic pattern coming after clocks
> disabled, system will be waked up, and interrupt handler will be called,
> system hang when access registers. To fix this issue, disable wakeup
> irq in .suspend(), and enable it in .resume().
> 
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
> Send to net-next although this is a bug fix, since there is no suitable
> commit to be blamed, can be back ported to stable tree if others need.
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 46 +++++++++++++++++------
>  1 file changed, 34 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 613b8180a1bd..786dcb923697 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1185,6 +1185,21 @@ static void fec_enet_stop_mode(struct fec_enet_private *fep, bool enabled)
>  	}
>  }
>  
> +static inline void fec_irqs_disable(struct net_device *ndev)

Please don't use inline in .c files. Let the compiler decide.

       Andrew
