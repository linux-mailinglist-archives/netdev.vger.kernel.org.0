Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B164131BE
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 12:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhIUKjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 06:39:47 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:24956 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhIUKjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 06:39:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1632220693;
    s=strato-dkim-0002; d=fpond.eu;
    h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=Mhkbu5P7WN7rfbFnRiQCrVQxfKO8RUe060B8sbXADEs=;
    b=Q/UpBbDRHi9h1W4RjMEPWM994cS7FlUrETAEviM9pq2nfT4zd0CGseccTtLZ+P/Gpf
    pDK8/CAf/GNRFOlCzJxwhyA6OVAbLGsNPCBOpxRSfKX22+XS1uNhOz4tlp7Io9GHje1c
    x3JAPoAZRTiXrYpInZeB7ms9pF+carb/GVSM4xu7V8nxfEtEya+8MiGLeWwxPAMNL1Zx
    xMz4wK9dAwqURzNAtzrH91ad8613CX8b1XjuYd8TyKLrg7bnU13X75xj02tdU/mbqxz1
    FG6u+F/1wFYgN4zo2SCj1l3Pc6g8ja+UVAy+lpOMs3+84/chZpzclayTO1dvz+3pg076
    lpug==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzvv3qxio1R8fGl/w2B+Io="
X-RZG-CLASS-ID: mo00
Received: from oxapp02-03.back.ox.d0m.de
    by smtp-ox.front (RZmta 47.33.8 AUTH)
    with ESMTPSA id c00f85x8LAcD4Bq
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Tue, 21 Sep 2021 12:38:13 +0200 (CEST)
Date:   Tue, 21 Sep 2021 12:38:13 +0200 (CEST)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        wg@grandegger.com, mkl@pengutronix.de
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ayumi Nakamichi <ayumi.nakamichi.kf@renesas.com>
Message-ID: <1020394138.1395460.1632220693209@webmail.strato.com>
In-Reply-To: <20210921051959.50309-1-yoshihiro.shimoda.uh@renesas.com>
References: <20210921051959.50309-1-yoshihiro.shimoda.uh@renesas.com>
Subject: Re: [PATCH] can: rcar_can: Fix suspend/resume
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.5-Rev23
X-Originating-Client: open-xchange-appsuite
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 09/21/2021 7:19 AM Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> wrote:
> 
>  
> If the driver was not opened, rcar_can_suspend() should not call
> clk_disable() because the clock was not enabled.
> 
> Fixes: fd1159318e55 ("can: add Renesas R-Car CAN driver")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Tested-by: Ayumi Nakamichi <ayumi.nakamichi.kf@renesas.com>
> ---
>  drivers/net/can/rcar/rcar_can.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
> index 00e4533c8bdd..6b4eefb03044 100644
> --- a/drivers/net/can/rcar/rcar_can.c
> +++ b/drivers/net/can/rcar/rcar_can.c
> @@ -846,10 +846,12 @@ static int __maybe_unused rcar_can_suspend(struct device *dev)
>  	struct rcar_can_priv *priv = netdev_priv(ndev);
>  	u16 ctlr;
>  
> -	if (netif_running(ndev)) {
> -		netif_stop_queue(ndev);
> -		netif_device_detach(ndev);
> -	}
> +	if (!netif_running(ndev))
> +		return 0;
> +
> +	netif_stop_queue(ndev);
> +	netif_device_detach(ndev);
> +
>  	ctlr = readw(&priv->regs->ctlr);
>  	ctlr |= RCAR_CAN_CTLR_CANM_HALT;
>  	writew(ctlr, &priv->regs->ctlr);
> @@ -858,6 +860,7 @@ static int __maybe_unused rcar_can_suspend(struct device *dev)
>  	priv->can.state = CAN_STATE_SLEEPING;
>  
>  	clk_disable(priv->clk);
> +
>  	return 0;
>  }
>  
> @@ -868,6 +871,9 @@ static int __maybe_unused rcar_can_resume(struct device *dev)
>  	u16 ctlr;
>  	int err;
>  
> +	if (!netif_running(ndev))
> +		return 0;
> +
>  	err = clk_enable(priv->clk);
>  	if (err) {
>  		netdev_err(ndev, "clk_enable() failed, error %d\n", err);
> @@ -881,10 +887,9 @@ static int __maybe_unused rcar_can_resume(struct device *dev)
>  	writew(ctlr, &priv->regs->ctlr);
>  	priv->can.state = CAN_STATE_ERROR_ACTIVE;
>  
> -	if (netif_running(ndev)) {
> -		netif_device_attach(ndev);
> -		netif_start_queue(ndev);
> -	}
> +	netif_device_attach(ndev);
> +	netif_start_queue(ndev);
> +
>  	return 0;
>  }
>  
> -- 
> 2.25.1

Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>

CU
Uli
